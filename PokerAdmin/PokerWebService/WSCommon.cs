using System;
using System.IO;
using System.Diagnostics; 

using NSCommonLib;

namespace PokerWebService
{
	public class WSCommon
	{

		public const string pathAffiliatePrefix  = "Skin_";

		public static string GetAffiliateSubFolder(int affID, bool instDir)
		{
			string dir=pathAffiliatePrefix+affID.ToString();  
			if (instDir) dir+="\\Installer";
			return dir;
		}

		public static string GetAffiliateURL(int affID, bool instDir,string baseURL)
		{
			string dir= baseURL;
			dir=dir.TrimEnd(new char[] {'\\'}); 
			dir=dir.TrimEnd(new char[] {'/'}); 
			string tmp=CConfig.stGetConfigValue("PostedCommonFileFolder",false).Trim() ;
			tmp=tmp.TrimEnd(new char[] {'/'}); 
			tmp=tmp.TrimStart(new char[] {'/'}); 
			tmp=tmp.TrimEnd(new char[] {'\\'}); 
			tmp=tmp.TrimStart(new char[] {'\\'}).Trim() ; 
			if (tmp != String.Empty) 
			{
				dir+="/"+tmp;
			}
			dir+="/"+GetAffiliateSubFolder(affID, instDir).Replace("\\","/") ;
			return dir;
		}

		public static string GetAffiliatePath(int affID, bool instDir)
		{
			string dir= CConfig.stGetConfigValue("PostedFileBasePath",false);
			dir=dir.TrimEnd(new char[] {'\\'}); 
			string tmp=CConfig.stGetConfigValue("PostedCommonFileFolder",false).Trim();
			tmp=tmp.TrimEnd(new char[] {'\\'}); 
			tmp=tmp.TrimStart(new char[] {'\\'}).Trim() ; 
			if (tmp != String.Empty) 
			{
				dir+="\\"+tmp;
			}
			dir+="\\"+GetAffiliateSubFolder(affID, instDir);
			if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
			return dir;
		}

		public static bool RunCommand(ref ProcessStartInfo startInfo,int waitMillisec, object Parent)
		{
			bool bRes = true;
			try
			{
				Process proc = Process.Start(startInfo);
				if ( proc != null )
				{
					proc.WaitForExit(waitMillisec);
					if ( proc.ExitCode != 0 )
					{
						CLog.stWriteLog(CLog.LogSeverityLevels.lslError,Parent,  
							string.Format("Process exit code = {0}. Call parameters: {1} {2}", proc.ExitCode, startInfo.FileName, startInfo.Arguments));
						bRes =false;
					}
					if ( !proc.HasExited )
					{
						CLog.stWriteLog(CLog.LogSeverityLevels.lslError,Parent ,  
							string.Format("Process has'nt exited. Call parameters: {0} {1}", startInfo.FileName, startInfo.Arguments));
						proc.Kill();
						bRes=false;
					}
				}
				else
				{
					CLog.stWriteLog(CLog.LogSeverityLevels.lslError,Parent ,  
						string.Format("Error create process. Call parameters: {0} {1}", startInfo.FileName, startInfo.Arguments));
					bRes=false;
				}
			}
			catch(Exception ex)
			{
				CLog.stLogException(new Exception( "RunCommand:",ex));
				CLog.stWriteLog(CLog.LogSeverityLevels.lslError,"RunCommand","Command: "+startInfo.FileName+"\r\n"+
					     "Arguments: "+startInfo.Arguments+"\r\n"+"Working directory: "+startInfo.WorkingDirectory);    
				bRes =false;
			}

			return bRes;
		}


		public static string GetTempFilePath(string fileName)
		{
			Guid guid = Guid.NewGuid(); //guid will used to make name unique
			string filePath = String.Format("{0}{1}_{2}", Path.GetTempPath(), guid.ToString(),  fileName);
			return filePath;
		}

	}
}
