using System;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Specialized;
using System.Diagnostics;
using System.Threading;
using System.Xml;


namespace Admin.CommonUse
{
	/// <summary>
	/// Summary description for Affiliate.
	/// </summary>
	public class Skins
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

		private int SkinsID=0;



		Common.Web.Core oDB;
		public Skins(Page page,int _SkinsID)
		{
			SkinsID=_SkinsID; 
			Common.Web.Page oPage  = page as Common.Web.Page;
			oDB = oPage.DBase;
		}


		/// <summary>
		///  Parse installation code file.
		/// </summary>
		protected void ParseInstallFile()
		{
			string installStr = "";
			string unInstallStr = "";
			string fileListInstallStr = "";
			string fileExecutableInstallStr = "";
			string fileListUnInstallStr = "";
			string fileExecutableUnInstallStr = "";
			DataTable oDTList = oDB.GetDataTable(Config.DbGetClientApplicationFileList,"@SkinsID",SkinsID);
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

			string templateNsi = Common.Files.Access.ReadFile(Config.GetAffiliatePath(SkinsID ,true,false)+"\\"+ Config.FileSkinsTemplateNsi);
			templateNsi = templateNsi.Replace(fileExecutableInstall, fileExecutableInstallStr);
			templateNsi = templateNsi.Replace(fileListInstall, fileListInstallStr);
			templateNsi = templateNsi.Replace(fileExecutableUnInstall, fileExecutableUnInstallStr);
			templateNsi = templateNsi.Replace(fileListUnInstall, fileListUnInstallStr);
			Common.Files.Access.WriteFile( Config.GetAffiliatePath(SkinsID,true,false)+"\\"+Config.FileSkinsNsi, templateNsi);
		}


		/// <summary>
		/// It updates install shields for affiliates.
		/// </summary>
		public string UpdateSkin()
		{
			string sError = "";
			try
			{
				//1. Create file list xml
				string xmlString = "";
				string filePath = "";
				DataTable oDTXML = oDB.GetDataTable(Config.DbGetClientApplicationFileListForXML, new object[] {"@SkinsID",SkinsID });
				foreach(DataRow oRow in oDTXML.Rows)
				{
					xmlString += oRow[0].ToString();
				}
				xmlString = String.Format("<{0}>{1}</{0}>",xmlTopRoot, xmlString);
				filePath =Config.GetAffiliatePath(SkinsID,false,false);
				if (!filePath.Trim().EndsWith("\\")) filePath += "\\";
				filePath += xmlFileName;
				Common.Files.Access.WriteFile(filePath, xmlString);

				//2. Parse installation code file
				ParseInstallFile();

				DataTable tbAff = oDB.GetDataTable(Config.DbGetAffiliateList , new object[] {"@SkinID",SkinsID });
				foreach (DataRow dr in tbAff.Rows)
				{
					//3. Rebuild installation for affiliate
					if (Convert.ToInt32(dr["StatusID"])==4)
					{
						int AffID=Convert.ToInt32(dr["id"]);
						bool bRet = CreateSkin(SkinsID,AffID);
						if (!bRet)
						{
							sError += String.Format("Error occured for Skin {0}, AffID {1}<br>", SkinsID,AffID);
						}
					}
				}

			}
			catch(Exception oEx)
			{
				Common.Log.Write(this, oEx);
				sError += "Error occured in Skin Update<br>";
			}
			return sError;
		}


		/// <summary>
		/// It updates install shields for particular affiliate.
		/// </summary>
		public bool CreateSkin(int nScID,int AffID)
		{
			bool bRes = false;
			try
			{
				//Create Directory
				string directoryPath = Config.GetAffiliatePath(nScID,true,false);

				//Create InstallShield
				Common.Log.Write(this,directoryPath);  
				Common.Log.Write(this,Config.FileSkinsBat);  
				bRes = ExecCommand(directoryPath+"\\"+Config.FileSkinsBat, directoryPath, String.Format("{0} {1}",directoryPath,AffID));
			}
			catch(Exception oEx)
			{
				Common.Log.Write(this, oEx);
				bRes = false;
			}
			return bRes;
		}



		protected bool ExecCommand(string sFileToExecute, string workingDirectory, string sArguments)
		{
			bool bRes = false;
			ProcessStartInfo startInfo = new ProcessStartInfo();
			startInfo.CreateNoWindow = true;
			startInfo.UseShellExecute = false;


			startInfo.WorkingDirectory = workingDirectory;
			startInfo.FileName = sFileToExecute;
			startInfo.Arguments = sArguments;

			Process proc = Process.Start(startInfo);
			if ( proc != null )
			{
				proc.WaitForExit(30000);
				if ( proc.ExitCode == 0 )
				{
					bRes = true;
				}
				else
				{
					string sError = string.Format("Process exit code = {0}. Call parameters: {1} {2}", proc.ExitCode, startInfo.FileName, startInfo.Arguments);
					Common.Log.Write(this, sError);
				}
				if ( !proc.HasExited )
				{
					proc.Kill();
				}
			}
			return bRes;
		}


	}
}
