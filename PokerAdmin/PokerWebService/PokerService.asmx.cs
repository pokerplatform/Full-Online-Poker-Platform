using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Web;
using System.Web.Services;
using System.IO;

using NSCommonLib;
using ICSharpCode.SharpZipLib.Zip ; 


namespace PokerWebService
{
	[WebService(Namespace="http://DesktopAdmin/webservice/")]
	public class PokerService : System.Web.Services.WebService
	{

		public  PokerService()
		{
			InitializeComponent();
		}

		#region Component Designer generated code
		
		//Required by the Web Services Designer 
		private IContainer components = null;
				
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if(disposing && components != null)
			{
				components.Dispose();
			}
			base.Dispose(disposing);		
		}
		
		#endregion

		/// <summary>
		/// Start receive file from client
		/// </summary>
		/// <param name="fileName"></param>
		/// <returns></returns>
		[WebMethod]
		public string StartPostFile(string fileName)
		{
			 string fName="";
			try
			{
				fName=WSCommon.GetTempFilePath(Path.GetFileName(fileName));
				if (CIO.FileExists(fName) )
				{
					CIO.blRemoveFile(fName); 
				}
				return fName;
			}
			catch(Exception ex)
			{
				CLog.stLogException(new Exception("StartPostFile : ", ex));
				return "";
			}
		}

		/// <summary>
		/// Receive  file body from client
		/// </summary>
		/// <param name="fileName"></param>
		/// <param name="fileSize"></param>
		/// <param name="buf"></param>
		/// <param name="bufLen"></param>
		/// <returns></returns>
		[WebMethod]
		public bool PostFile(string fileName,long fileSize,string buf, int bufLen)
		{
			FileStream fl=null;
			long fSize; 

			try
			{
				byte [] bbuf=CConvert.FromBase64ToBytes(buf); 
				if (bbuf.Length != bufLen) 
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError ,this, 
						        String.Format(fileName+" : Buffer length not equal with parameter {0} > {1}",bbuf.Length,bufLen));  
					return false;
				}

				if (CIO.FileExists(fileName) )
				{
					fl=File.Open(fileName,FileMode.Append,FileAccess.Write,FileShare.Read);      
						FileInfo fi=new FileInfo(fileName);
					fSize=fi.Length; 
				}
				else
				{
					fl=File.Create(fileName);
					fSize=0;
				}

				if ((fSize+bbuf.Length) > fileSize)
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError ,this,
						     String.Format(fileName+" : The received size of the data will exceed the specified size of a file {0} : {1}",
						                                 (fSize+bbuf.Length),fileSize));  
					 return false; 
				}

                 fl.Write(bbuf,0,bbuf.Length); 
					return true;
			} 
			catch(Exception ex)
			{
				CLog.stLogException(new Exception ("PostFile:",ex));
				return false;
			}
			finally
			{
				if (fl!=null) fl.Close(); 
			}
		}

		private long ExtractFromZip( string fName,string entryName, string destPath)
		{
            ZipFile  zf =null;
            System.IO.Stream zp =null;
            FileStream fs =null; 
			ZipEntry ze=null;
			long ret=-1;

			try
			{
				zf = new ZipFile(fName);
				ze=zf.GetEntry(entryName);
				zp = zf.GetInputStream(ze);   

				string pt= destPath;
				pt+="\\"+entryName;
				if (CIO.FileExists(pt)) CIO.blRemoveFile(pt);  
				fs = new FileStream(pt, FileMode.CreateNew);
				int bt;
				while(true) 
				{
					bt=zp.ReadByte();
					if (bt<0) break;
                    fs.WriteByte(CConvert.ToByte(bt)); 
				}
				ret=ze.Size; 
			}
			catch(Exception ex)
			{
				CLog.stLogException(new Exception( "ExtractFromZip:",ex));
				ret=-1;
			}
			finally
			{
                if ( zf != null)  zf.Close();
                if ( zp !=null) zp.Close();
                if ( fs != null) fs.Close();
				CIO.blRemoveFile(fName); 
			}
			return ret;
		}


		/// <summary>
		///  End receive file from client
		/// </summary>
		/// <param name="fileName"></param>
		/// <param name="fileSize"></param>
		/// <returns></returns>
		[WebMethod]
		public bool EndPostFile(string subFolder,string fileName,string entryName, long fileSize, long origFileSize)
		{
			return EndPostFileArch(subFolder,fileName,entryName,fileSize,origFileSize,true);
		}

		protected string GetDestinationPath(string subFolder)
		{
			string destPath= CConfig.stGetConfigValue("PostedFileBasePath",false);
			destPath=destPath.TrimEnd(new char[] {'\\'}); 
			string tmp=CConfig.stGetConfigValue("PostedCommonFileFolder",false).Trim();
			tmp=tmp.TrimEnd(new char[] {'\\'}); 
			tmp=tmp.TrimStart(new char[] {'\\'}).Trim() ; 
			if (tmp != String.Empty) 
			{
				destPath+="\\"+tmp;
			}
			if (subFolder != String.Empty)
			{
				destPath+="\\"+subFolder;
				if (!Directory.Exists(destPath)) CIO.CreateDirectory(destPath);   
			}
            return destPath; 
		}

		/// <summary>
		///  End receive file from client
		/// </summary>
		/// <param name="fileName"></param>
		/// <param name="fileSize"></param>
		/// <returns></returns>
		[WebMethod]
		public bool EndPostFileArch(string subFolder,string fileName,string entryName, long fileSize, long origFileSize,bool IsFileArchive)
		{
			try
			{
				if (!CIO.FileExists(fileName) )
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError ,this,fileName+" : does'nt exist");  
					return false; 
				}

				FileInfo fi=new FileInfo(fileName);
				if(fileSize !=fi.Length) 
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError ,this, String.Format(Path.GetFileName( fileName)+" : wrong archive file size {0} , {1} ",fileSize,fi.Length));  
					return false; 
				}
 
				string destPath= GetDestinationPath(subFolder);
				if (IsFileArchive)
				{
					long fSize=ExtractFromZip(fileName,entryName,destPath);  
					if (fSize<0)
					{
						CLog.stWriteLog(CLog.LogSeverityLevels.lslError ,this,fileName+" : error decoding file");  
						return false; 
					}
				}
				else
				{
					if (File.Exists(destPath+"\\"+entryName)) File.Delete(destPath+"\\"+entryName);  
					File.Move(fileName,destPath+"\\"+entryName);
				}

				fi=new FileInfo(destPath+"\\"+entryName);
				if( fi.Length != origFileSize) 
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError ,this,
						String.Format(entryName +" : wrong destination file size {0} , {1}",origFileSize,fi.Length));  
					CIO.blRemoveFile( destPath+"\\"+entryName);
					return false; 
				}
			} 
			catch(Exception ex)
			{
				CLog.stLogException(new Exception("EndPostFile:",ex));
				return false;
			}

			return true;
		}

		/// <summary>
		/// Get to Subdirectory path to affiliate files
		/// </summary>
		/// <param name="fileName"></param>
		/// <param name="fileSize"></param>
		/// <returns></returns>
		[WebMethod]
		public string AffiliateFilesPath(int AffID, bool instDir)
		{
			try
			{
				return WSCommon.GetAffiliateSubFolder(AffID, instDir);
			}
			catch(Exception ex)
			{
				CLog.stLogException(ex);
				return "";
			}
		}

		[WebMethod]
		public string CommonFileFolder()
		{
			return CConfig.stGetConfigValue("PostedCommonFileFolder",false);
		}
		[WebMethod]
		public string CommonFileBaseURL()
		{
			return CConfig.stGetConfigValue("PostedFileBaseURL",false);
		}

		protected  bool SetStartupInfo(int execType, int affID, ref ProcessStartInfo startInfo) 
		{
			try
			{
				switch(execType)
				{
					case 0:
						startInfo.FileName = WSCommon.GetAffiliatePath(affID,true)+"\\"+CConfig.stGetConfigValue("FileSecurityBat",false) ;
						startInfo.WorkingDirectory =Path.GetDirectoryName(startInfo.FileName);
						startInfo.Arguments =string.Format("{0} {1}", startInfo.WorkingDirectory, WSCommon.GetAffiliatePath(affID,false));
						break;
					default:
						return false;
				}

				return true;
			}
			catch(Exception ex)
			{
				CLog.stLogException(ex);
				return false;
			}
		}

		[WebMethod]
		public bool RemoveFile(int affiliateID, string fileName)
		{
			string fPath=WSCommon.GetAffiliatePath(affiliateID,false);
			if (File.Exists(fPath+"\\"+Path.GetFileName(fileName))==false)  return true;
			try
			{
				File.Delete(fPath+"\\"+Path.GetFileName(fileName));
				return true;
			}
			catch
			{
				return false;
			}
		}

		[WebMethod]
		public int UpdateAvatarData(int UserID, string file, string size)
		{
			CSQL oDB =null;
			try
			{
				string cnString = CConfig.stGetConfigValue("DatabaseConnectionString",false);
				 oDB = new CSQL(cnString);
				DataRow dt= oDB.GetFirstRow("admGetUserLoginName",CommandType.StoredProcedure ,
					CSQL.GetArrayListParameters(new object [] {"@id",UserID}));
				if (dt == null) return -1;
				string lName= dt[0].ToString();
				string mPath=CConfig.stGetConfigValue("AvatarUploadURL",false);
				if (mPath==String.Empty ) return -2;
				mPath+= lName;//+"/"+file;
				int ret =oDB.ExecuteNonQueryWithReturnID("admSaveAvatar", CommandType.StoredProcedure , 
					CSQL.GetArrayListParameters (new object [] {"@UserID",UserID,"@Path",mPath,"@File",file,"@Size",size}));
				mPath=GetDestinationPath("");
				mPath+="\\Avatars";
				ProcessStartInfo startInfo = new ProcessStartInfo();
				startInfo.CreateNoWindow = true;
				startInfo.UseShellExecute = false;
				startInfo.WorkingDirectory = mPath;
				startInfo.FileName = mPath+"\\"+ CConfig.stGetConfigValue("FileSecurityBat",false);
				startInfo.Arguments =string.Format("{0} {1}",  mPath  ,mPath+"\\"+lName); 
				bool bRes = WSCommon.RunCommand(ref startInfo, 60000,this);
				return bRes?ret:-100;
			}
			catch(Exception ex)
			{
				CLog.stLogException(ex);
				return -100;
			}
			finally
			{
				if (oDB != null) oDB.CloseConnection(true);
			}
		}


		[WebMethod]
		public bool ExecCommand(int execType,int affiliateID, int waitMillisec)
		{
			bool bRes = true;
			try
			{
				if (execType <0 || execType> 1)
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError,this,  string.Format("Bad execute type: {0}.", execType));
					return false;
				}
				if (execType ==0 && affiliateID<=0)
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError,this,  string.Format("Error Skin's ID: {0}.", affiliateID));
					return false;
				}

				ProcessStartInfo startInfo = new ProcessStartInfo();
				startInfo.CreateNoWindow = true;
				startInfo.UseShellExecute = false;

				if (!SetStartupInfo(execType,affiliateID, ref startInfo) && execType !=1)
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError,this,  string.Format("Error create startup parameters. Execute type: {0}.", execType));
					return false;
				}
				switch(execType)
				{
					case 0:
						bRes = WSCommon.RunCommand(ref startInfo,waitMillisec,this);
						break;
					case 1:
						Affiliate aff = new Affiliate(waitMillisec,affiliateID);
						bRes = aff.UpdateSkin(); 
						aff.Dispose();
						break;
					default:
						bRes =false;
						break;
				}
			}
			catch(Exception ex)
			{
				CLog.stLogException(new Exception("ExecCommand:", ex));
				bRes = false;
			}
             return bRes; 
		}



	}
}
