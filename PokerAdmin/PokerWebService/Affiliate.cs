using System;
using System.Web;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Specialized;
using System.Xml;
using System.Diagnostics;
using System.Collections; 

using NSCommonLib;

namespace PokerWebService
{
	/// <summary>
	///class Affiliate.
	/// </summary>
	public class Affiliate : IDisposable
   	{
		protected const string xmlTopRoot  = "filelist";
		protected const string xmlFileName = "filelist.xml";

		protected const string instCommand = "File";
		protected const string instBeforeFileName = "\"..\\";
		protected const string instAfterFileName = "\"\r\n";

		protected const string unInstCommand = "Delete";
		protected const string unInstBeforeFileName = "\"$INSTDIR\\files\\";
		protected const string unInstBeforeExecutableFileName = "\"$INSTDIR\\";
		protected const string unInstAfterFileName = "\"\r\n";

		const int ContentTypeExecutable = 4;
		protected const string fileExecutableInstall = "${FileExecutableInstall}";
		protected const string fileListInstall       = "${FileListInstall}";
		protected const string fileExecutableUnInstall = "${FileExecutableUnInstall}";
		protected const string fileListUnInstall     = "${FileListUnInstall}";

		protected const string DbGetClientApplicationFileList  = "admGetClientApplicationFileList";
		protected	const	string	DbGetClientApplicationFileListForXML = "admGetClientApplicationFileListForXML";
		protected const string DbGetAffiliateList  = "admGetAffiliateList";

        protected int m_waitMillisec =60000;

		CSQL oDB;
		int m_SkinsID=-1;

	#region "Constructor / Destructor"

		private bool disposed = false;

		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}

		private void Dispose(bool disposing)
		{
			if(!this.disposed)
			{
				if(disposing){}
				if (oDB != null)
				{
					oDB.CloseConnection(true);
					oDB=null;
				}
			}
			disposed = true;         
		}

		~Affiliate()      
		{
			Dispose(false);
		}

		public Affiliate(int waitMillisec,int SkinsID)
		{
			m_waitMillisec=waitMillisec;
			m_SkinsID=SkinsID; 
             string cnString = CConfig.stGetConfigValue("DatabaseConnectionString",false);
             oDB = new CSQL(cnString);
		}

	#endregion

		/// <summary>
		///  Parse installation code file.
		/// </summary>
		protected void ParseInstallFile(int SkinID)
		{
			string installStr = "";
			string unInstallStr = "";
			string fileListInstallStr = "";
			string fileExecutableInstallStr = "";
			string fileListUnInstallStr = "";
			string fileExecutableUnInstallStr = "";

			ArrayList ar=new ArrayList();
			ar.Add("@SkinsID");
			ar.Add(SkinID);  
			DataTable oDTList = oDB.GetDataTable(DbGetClientApplicationFileList,CommandType.StoredProcedure,ar);
			foreach(DataRow oRow in oDTList.Rows)
			{
				installStr = String.Format("{0} {1}{2}{3}", instCommand, instBeforeFileName,
					oRow["FileName"].ToString(), instAfterFileName);
				unInstallStr = String.Format("{0} {1}{2}{3}", unInstCommand, unInstBeforeFileName,
					oRow["FileName"].ToString(), unInstAfterFileName);

				if (Convert.ToInt32(oRow["contentTypeID"]) == ContentTypeExecutable)
				{
					fileExecutableInstallStr = installStr;
					fileExecutableUnInstallStr = String.Format("{0} {1}{2}{3}", unInstCommand, unInstBeforeExecutableFileName,
						oRow["FileName"].ToString(), unInstAfterFileName);
				}
				else
				{
					fileListInstallStr += installStr;
					fileListUnInstallStr += unInstallStr;
				}

			}

			//Add xmlFile
			fileListInstallStr += String.Format("{0} {1}{2}{3}", instCommand, instBeforeFileName,
				xmlFileName, instAfterFileName);
			fileListUnInstallStr += String.Format("{0} {1}{2}{3}", unInstCommand, unInstBeforeFileName,
				xmlFileName, unInstAfterFileName);

			string templateNsi = CIO.ReadAllFile(WSCommon.GetAffiliatePath(SkinID,true)+"\\"+ CConfig.stGetConfigValue("NsiTemplateFile",false));
			templateNsi = templateNsi.Replace(fileExecutableInstall, fileExecutableInstallStr);
			templateNsi = templateNsi.Replace(fileListInstall, fileListInstallStr);
			templateNsi = templateNsi.Replace(fileExecutableUnInstall, fileExecutableUnInstallStr);
			templateNsi = templateNsi.Replace(fileListUnInstall, fileListUnInstallStr);
			CIO.WriteToFile(WSCommon.GetAffiliatePath(SkinID,true)+"\\"+CConfig.stGetConfigValue("NsiFile",false), templateNsi);
		}

		/// <summary>
		/// It updates install shields for affiliates.
		/// </summary>
		public bool UpdateSkin()
		{
			bool ret  = true;
			try
			{
				  ArrayList ar=new ArrayList(); 

					//1. Create file list xml
					string xmlString = "";
					string filePath = "";
					ar.Clear();
					ar.Add("@SkinsID");
					ar.Add(m_SkinsID);  
					DataTable oDTXML = oDB.GetDataTable(DbGetClientApplicationFileListForXML,CommandType.StoredProcedure,ar);
					foreach(DataRow bRow in oDTXML.Rows)
					{
						xmlString += bRow[0].ToString();
					}
					xmlString = String.Format("<{0}>{1}</{0}>",xmlTopRoot, xmlString);
					filePath = WSCommon.GetAffiliatePath(m_SkinsID,false);
					if (!filePath.Trim().EndsWith("\\")) filePath += "\\";
					filePath += xmlFileName;
					CIO.WriteToFile(filePath, xmlString);

					//2. Parse installation code file
					ParseInstallFile(m_SkinsID);

				DataTable tbAff = oDB.GetDataTable(DbGetAffiliateList ,CommandType.StoredProcedure , new object[] {"@SkinID",m_SkinsID });
				foreach (DataRow dr in tbAff.Rows)
				{
					//3. Rebuild installation for affiliate
					if (Convert.ToInt32(dr["StatusID"])==4)
					{
						int AffID=Convert.ToInt32(dr["id"]);
						bool bRet = CreateSkin(m_SkinsID,AffID);
						if (!bRet)
						{
							CLog.stWriteLog(CLog.LogSeverityLevels.lslError,this,  String.Format("Error occured for Skin {0}, AffID {1}<br>", m_SkinsID,AffID));
							ret=false;
						}
					}
				}
			}
			catch(Exception oEx)
			{
				CLog.stLogException(new Exception ("UpdateSkin:",oEx)); 
				ret= false;
			}
			return ret;
		}


		/// <summary>
		/// It updates install shields for particular affiliate.
		/// </summary>
		public bool CreateSkin(int nScID,int nAffID)
		{
			bool bRes = false;
			try
			{
				//Create Directory
				string directoryPath = WSCommon.GetAffiliatePath(nScID,false);
				ProcessStartInfo startInfo = new ProcessStartInfo();
				startInfo.CreateNoWindow = true;
				startInfo.UseShellExecute = false;
				startInfo.WorkingDirectory = directoryPath;
				string sDir = WSCommon.GetAffiliatePath(nScID,true);
				startInfo.FileName = sDir+"\\"+ CConfig.stGetConfigValue("FileSkinsBat",false);
				startInfo.Arguments =string.Format("{0} {1}",  sDir , nAffID); //string.Format("{0} {1} {2}",  sDir, sDir, nAffID);

				//Create InstallShield
				bRes = WSCommon.RunCommand(ref startInfo, m_waitMillisec,this);
			}
			catch(Exception oEx)
			{
				CLog.stLogException(new Exception("CreateSkin:", oEx)); 
				bRes = false;
			}
			return bRes;
		}

	}
}


