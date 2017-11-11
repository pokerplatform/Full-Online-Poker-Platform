using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Reflection;
using System.Xml;
using System.IO;

using Common;
using Common.Web;
using Common.Com;

namespace Promo
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class ChangeAvatar : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
	
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.WebControls.TextBox txtEmail;
		protected System.Web.UI.WebControls.Image oImageLogo;
		protected System.Web.UI.WebControls.TextBox txtLogin;
		protected System.Web.UI.WebControls.TextBox txtPassword;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnUserID;
		protected System.Web.UI.WebControls.Button btnChangeAvatar;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnLoginName;
		protected System.Web.UI.HtmlControls.HtmlInputFile iFile;
		protected int nUserID = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{
			oImageLogo.ImageUrl = Config.ImageFolder + Config.ImageLogoName;
			if (!IsPostBack)
			{
				hdnUserID.Value ="0";
			}
			else
			{
				nUserID= Utils.GetInt(hdnUserID.Value); 
			}
		}

		public string GetCssPageUrl()
		{
			return Config.CommonCssPath;
		}
	
		private void btnChangeAvatar_Click(object sender, System.EventArgs e)
		{
			lblInfo.ForeColor=Color.Red ;  
			DataRow oDR = GetFirstRow(Config.DbCheckAffiliateLogin, "@Login", txtLogin.Text, "@Password", txtPassword.Text);

			if ( oDR != null && Utils.GetInt(oDR["ID"]) > 0)
			{
				nUserID =Utils.GetInt(oDR["ID"]);
				hdnUserID.Value =nUserID.ToString();  
				hdnLoginName.Value =txtLogin.Text; 
				string rez=SaveFile();
				if (rez!="")
					lblInfo.Text=rez;
				else
				{
					lblInfo.Text="Upload successful";
					lblInfo.ForeColor =Color.Green;   
				}
			}
			else
			{
				lblInfo.Text="Incorrect Login or Password"; 
			}
		}

		public string SaveFile()
		{
			int fileSize = 0;
			string filePath = "";
			string fileName = "";
			string OrigFile="";
			string sError = UploadFile(ref filePath, ref fileName, ref fileSize,ref OrigFile);
			if ((sError == "") || (sError == null))
			{
				sError = ProcessFile( filePath, fileName, fileSize,OrigFile);
			}
			return sError;
		}

		/// <summary>
		/// Save file in temporary folder
		/// </summary>
		protected string UploadFile( ref string tempFilePath, ref string fileName, ref int fileSize,ref string OrigFile)
		{
			//1. Validations
		    HttpPostedFile postFile = Request.Files[0];  
			string filePath = postFile.FileName;
			OrigFile=Path.GetFileName(filePath); 
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
		public string ProcessFile( string filePath, string fileName, int fileSize,string OrigFile)
		{
            int rez=DBase.ExecuteReturnInt("admSaveAvatar","@File",OrigFile,"@Path",
				      Config.GetConfigValue("AvatarUploadURL")+hdnLoginName.Value  ,"@Size",fileSize,
				      "@UserID",nUserID); 
			if (rez<=0) 
			{
				try
				{
					File.Delete(filePath);
				}
				catch (Exception oEx)
				{
					Log.Write(this, "Fail to delete file. Error description: " + oEx.Message);
				}
				return "Error uploading file " + OrigFile ;
			}
			//rename uploaded file to permanent name
			try
			{
				string cDir=Config.GetConfigValue("AvatarUploadPath");
				string chPath=cDir+ "\\"+hdnLoginName.Value ;
				string filePathNew = chPath +"\\" +OrigFile;
				if (!Directory.Exists(chPath)) Directory.CreateDirectory(chPath);    
				if (File.Exists(filePathNew)) File.Delete(filePathNew);
				File.Move(filePath, filePathNew);
			}
			catch(Exception oEx)
			{
				try
				{
					DBase.Execute("admDeleteAvatar", "@ID", rez);
					File.Delete(filePath); 
				}
				catch {}
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




		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
			
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.btnChangeAvatar.Click += new System.EventHandler(this.btnChangeAvatar_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

	}
}

