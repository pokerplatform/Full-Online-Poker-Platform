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
	/// <summary>
	/// Summary description for PostedFile.
	/// </summary>
	public class PostedFile
	{

		private int AffID=0;

		public PostedFile( int SkinID)
		{
			AffID=SkinID; 
		}


		/// <summary>
		/// Delete specified file from database and file system.
		/// </summary>
		public string DeleteFile(Page page, int fileID)
		{
			if (fileID<=0) return "File is not specified";

			Common.Web.Page oPage = page as Common.Web.Page;
			Common.Web.Core oDB = oPage.DBase;
			DataRow oDR = oDB.GetFirstRow(Config.DbGetFileDetails, "@ID", fileID);
			if ((oDR==null) || (oDR["FileName"]==System.DBNull.Value)) return "File name not found.";
			string fileName = oDR["FileName"].ToString();
			string serverRoot = Config.GetAffiliatePath(AffID,false,false)  ;
			if (!serverRoot.Trim().EndsWith("\\")) serverRoot += "\\";
			string filePath = serverRoot + fileName;
			try
			{
				//first - delete from DB then delete from file system
				int iRet = oDB.Execute(Config.DbDeleteFileRelated, "@IDs", fileID);
				if (iRet==0) return "File " + fileName + " could not be deleted";
				else File.Delete(filePath);
			}
			catch(Exception oEx)
			{
				Log.Write(this, "Fail to delete File. Error description: " + oEx.Message);
				return "Error occured during deleting file " + fileName;
			}

			return "";
		}

		/// <summary>
		/// It extracts files from zip archive and saves them
		/// </summary>
		public string SaveZipFile(Page page, HttpPostedFile postFile, int ContentTypeID, ref string sFileList)
		{
			string sError = "";
			sFileList = "";
			int nFileID = -1;  // -1 means replace old file with files from zip archive

			ZipInputStream zipStream = new ZipInputStream(postFile.InputStream);
			ZipEntry theEntry;
			while ((theEntry = zipStream.GetNextEntry()) != null) 
			{
				int nFileSize = Convert.ToInt32(theEntry.Size);
				byte[] buff = new byte[nFileSize];
				zipStream.Read(buff, 0, nFileSize);

				string fileName = theEntry.Name;
				string filePath = GetTempFilePath(fileName);
				FileStream fileSave = new FileStream(filePath, FileMode.CreateNew);
				fileSave.Write(buff, 0, nFileSize);
				fileSave.Flush();
				fileSave.Close();
	
				sError += ProcessFile(page, ContentTypeID, filePath, fileName, nFileSize, ref nFileID);
				if (nFileID > 0)
				{
					sFileList += String.Format("{0};", nFileID);
				}
				nFileID = -1;
			}
			if (sFileList.Trim().EndsWith(";"))
			{
				sFileList = sFileList.Remove(sFileList.Length-1, 1);
			}

			return sError;
		}


		public string SaveFile(Page page, HttpPostedFile postFile, ref int fileID)
		{
			return SaveFile(page, postFile, 1, ref fileID);
		}

		/// <summary>
		/// Save file to file system and create/update record in DB.
		/// </summary>
		public string SaveFile(Page page, HttpPostedFile postFile, int ContentTypeID, ref int fileID)
		{
			if (fileID<0) fileID = 0; // 0 - do not replace existing files, -1 replace with new one
			int fileSize = 0;
			string filePath = "";
			string fileName = "";
			string sError = UploadFile(postFile, ref filePath, ref fileName, ref fileSize);
			if ((sError == "") || (sError == null))
			{
				sError = ProcessFile(page, ContentTypeID, filePath, fileName, fileSize, ref fileID);
			}
			return sError;
		}

		/// <summary>
		/// Save file in temporary folder
		/// </summary>
		protected string UploadFile(HttpPostedFile postFile, ref string tempFilePath, ref string fileName, ref int fileSize)
		{
			//1. Validations
			string filePath = postFile.FileName;
			if ((filePath==null) || (filePath=="")) return "File not specified";
			fileSize = postFile.ContentLength;
			if (fileSize<=0) return "File " + filePath + " is not exist or has 0 size.";

			fileName = Path.GetFileName(filePath);
			tempFilePath = GetTempFilePath(fileName);

			//2. Upload File
			try
			{
				postFile.SaveAs(tempFilePath);
			}
			catch(Exception oEx)
			{
				Log.Write(this, "Fail to save HttpPostedFile. Error description: " + oEx.Message);
				return "Error occured during upload file " + fileName;
			}
			return "";
		}

		/// <summary>
		/// Process saved file
		/// </summary>
		public string ProcessFile(Page page, int ContentTypeID, string filePath, string fileName, int fileSize, ref int fileID)
		{
			int originalFileID = fileID;
			string fileExtension = Path.GetExtension(filePath).Replace(".", "");

			string uploadUrl = Config.GetAffiliatePath(AffID,false,true)  ;
			if (!uploadUrl.Trim().EndsWith("/")) uploadUrl += "/";

			string serverRoot = Config.GetAffiliatePath(AffID,false,false)  ;
			if (!serverRoot.Trim().EndsWith("\\")) serverRoot += "\\";

			//1. Update DB
			Common.Web.Page oPage  = page as Common.Web.Page;
			Common.Web.Core oDB = oPage.DBase;
			SqlCommand oCmd = oDB.GetCommand(Config.DbSaveFile);
			SqlParameterCollection oParams = oCmd.Parameters;

			oParams.Add("@fileID", fileID);
			oParams.Add("@fileName", fileName);
			oParams.Add("@fileSize", fileSize);
			oParams.Add("@fileExtension", fileExtension);
			oParams.Add("@urlRoot", uploadUrl);
			oParams.Add("@ContentTypeID", ContentTypeID);
			oParams.Add("@AffID", AffID);
			
			SqlParameter oParam = new SqlParameter("@fileNameOld", System.Data.SqlDbType.VarChar, 250);
			oParam.Direction = ParameterDirection.Output;
			oParams.Add(oParam);
			fileID = oDB.ExecuteReturnInt(oCmd);
			string fileNameOld = oCmd.Parameters["@fileNameOld"].Value.ToString();
			if (fileID <= 0) 
			{
				try
				{
					File.Delete(filePath);
				}catch (Exception oEx){
					Log.Write(this, "Fail to delete file. Error description: " + oEx.Message);
				}
				if (fileID<0) return "File with name " + fileName + " already exists. Please change name of file and try again. ";
				else return "Database error occured during saving file " + fileName + ". ";
			}

			//Everything is ok. We can rename just uploaded file with permanent name
			//delete old file
			if (originalFileID>0)
			{
				try
				{
					string filePathOld = serverRoot + fileNameOld;
					File.Delete(filePathOld);
				}
				catch(Exception oEx)
				{
					oDB.Execute(Config.DbDeleteFile, "@IDs", fileID);
					Log.Write(this, "Fail to delete old file. Error description: " + oEx.Message);
					return "Error occured during delete old file " + fileNameOld;
				}
			}

			//rename uploaded file to permanent name
			try
			{
				string filePathNew = serverRoot + fileName;
				if (File.Exists(filePathNew)) File.Delete(filePathNew);
				File.Move(filePath, filePathNew);
			}
			catch(Exception oEx)
			{
				oDB.Execute(Config.DbDeleteFile, "@IDs", fileID);
				Log.Write(this, "Fail to move file. Error description: " + oEx.Message);
				return "Error occured during moving file " + fileName + ". ";
			}

			return "";
		}

		
		protected string GetTempFilePath(string fileName)
		{
			Guid guid = Guid.NewGuid(); //guid will used to make name unique
			string filePath = String.Format("{0}{1}_{2}", Path.GetTempPath(), guid.ToString(),  fileName);
			return filePath;
		}



	}
}
