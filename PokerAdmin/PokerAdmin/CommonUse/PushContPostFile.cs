using System;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Data;
using System.Data.SqlClient;

using ICSharpCode.SharpZipLib.Zip;

using Common;

namespace Admin.CommonUse
{
	public class PushContPostFile
	{

		 int ContentID =-1;

		public PushContPostFile(int PContentID) { ContentID=PContentID;}

		/// <summary>
		/// Delete specified file from database and file system.
		/// </summary>
		public string DeleteFile(Page page, string fileIDs)
		{
			if (fileIDs.Length ==0) return "File is not specified";
            string [] s = fileIDs.Split(',');  
			string sRez="";

			foreach (string sfile in s)
			{
				Common.Web.Page oPage = page as Common.Web.Page;
				Common.Web.Core oDB = oPage.DBase;
				DataRow oDR = oDB.GetFirstRow(Config.DbGetPushingContentFileDetails, "@ID", Utils.GetInt(sfile));
				if ((oDR==null) || (oDR["Name"]==System.DBNull.Value) || (oDR["Name"].ToString() == String.Empty)) return "File name not found.";
				string fileName = oDR["Name"].ToString();
				string serverRoot = Config.GetPushingContentPath(ContentID ,false) ;
				if (!serverRoot.Trim().EndsWith("\\")) serverRoot += "\\";
				string filePath = serverRoot + fileName;
				try
				{
					//first - delete from DB then delete from file system
					int iRet = oDB.Execute(Config.DbDeletePushingContentFile, "@IDs", Utils.GetInt(sfile));
					if (iRet==0) 
						sRez+= "File " + fileName + " could not be deleted; ";
					else 
						File.Delete(filePath);
				}
				catch(Exception oEx)
				{
					Log.Write(this, "Fail to delete File. Error description: " + oEx.Message);
					sRez+= "Error occured during deleting file " + fileName;
				}
			}

			return sRez;
		}

		public string SaveFile(Page page, HttpPostedFile postFile, int Width,int Heigth, int contentType, ref int fileID)
		{
			int fileSize = 0;
			string fileName = "";
			string sError="";
			if ((postFile.FileName !="") && (postFile.FileName!=null))
			{
				sError = UploadFile(postFile,  ref fileName, ref fileSize);
			}
			if ((sError == "") || (sError == null))
			{
				sError = ProcessFile(page, fileName, fileSize, Width, Heigth, contentType,  ref fileID);
			}
			return sError;
		}

		/// <summary>
		/// Save file in temporary folder
		/// </summary>
		protected string UploadFile(HttpPostedFile postFile,  ref string fileName, ref int fileSize)
		{
			//1. Validations
			string filePath = postFile.FileName;
			if ((filePath==null) || (filePath=="")) return "File not specified";
			fileSize = postFile.ContentLength;
			if (fileSize<=0) return "File " + filePath + " is not exist or has 0 size.";
			fileName =Path.GetFileName(filePath);

			//2. Upload File
			try
			{
				string serverRoot = Config.GetPushingContentPath(ContentID ,false);
				if (!serverRoot.Trim().EndsWith("\\")) serverRoot += "\\";
                serverRoot+=fileName;
				if (File.Exists(serverRoot)) File.Delete(serverRoot); 
				postFile.SaveAs(serverRoot);
			}
			catch(Exception oEx)
			{
				Log.Write(this, "Fail to save HttpPostedFile. Error description: " + oEx.Message);
				return "Error occured during upload file " + fileName ;
			}
			return "";
		}

		/// <summary>
		/// Process saved file
		/// </summary>
		public string ProcessFile(Page page, string fileName, int fileSize,  int Width,int Height, int contentType,ref int fileID)
		{
			string uploadUrl = Config.GetPushingContentPath(ContentID ,true);
			if (!uploadUrl.Trim().EndsWith("/")) uploadUrl += "/";

			string serverRoot = Config.GetPushingContentPath(ContentID ,false);
			if (!serverRoot.Trim().EndsWith("\\")) serverRoot += "\\";

			Common.Web.Page oPage  = page as Common.Web.Page;
			Common.Web.Core oDB = oPage.DBase;

            string oldFile="";
			 int Version=-1;
			if (fileID >=0)
			{
				DataRow oDR = oDB.GetFirstRow(Config.DbGetPushingContentFileDetails, "@ID", fileID);
				if ((oDR!=null) && (oDR["Name"]!=System.DBNull.Value) && (oDR["Name"].ToString() != String.Empty)) 
                  oldFile=oDR["Name"].ToString(); 
				if (fileName == String.Empty )
				{
					fileName =oldFile;
					uploadUrl=oDR["URL"].ToString(); 
					fileSize= Utils.GetInt (oDR["FileSize"]);
					Version=Utils.GetInt (oDR["Version"]);
				}
			}

			//1. Update DB
			 int NewfileID=oDB.ExecuteReturnInt(Config.DbSavePushingContentFile,"@ID",fileID,
				"@Name", fileName,
				"@URL", uploadUrl,
				"@PushingContentID",ContentID ,
				"@FileSize", fileSize,
				"@Width", Width,
				"@Height", Height,
				 "@Version",Version, 
				"@ContentTypeID",contentType );

			if (NewfileID <= 0) 
			{
				try
				{
					if ( File.Exists(serverRoot+fileName)) File.Delete(serverRoot+fileName);
				}catch (Exception oEx){
					Log.Write(this, "Fail to delete file. Error description: " + oEx.Message);
				}
				return "Database error occured during saving file " + fileName + ". ";
			}

			if (oldFile != fileName)
			{
				if (File.Exists(serverRoot+oldFile)) 	File.Delete(serverRoot+oldFile);
			}

			return "";
		}

	}
}
