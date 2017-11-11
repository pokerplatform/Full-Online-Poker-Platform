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
using Admin.CommonUse;
using NetCompress; 

using Common;
using Common.Web;
using Common.Com;

namespace Admin.Transactions
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class GameHistoryPlay : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblName;
		protected Controls.ButtonImage btnClose;

		private const int CONST_CONTENTTYPEPOKERTABLE = 3;
		protected int nGameLogID = 0;
		public string sXmlFilePath = "";
		public string sXmlFileUrl = "";

		private void Page_Load(object sender, System.EventArgs e)
		{
			//nGameLogID = GetMainParamInt(hdnGameLogID);
			nGameLogID = Utils.GetInt(Request[Config.ParamGameLogID]);
			if ( !IsPostBack )
			{
				GetData();
			}
		}

	
		/// <summary>
		/// Retrieve DB data to place to the page
		/// </summary>
		protected void GetData()
		{
			if (nGameLogID>0)
			{
				//DataRow oDR = GetFirstRow(Config.DbGetGameLogDetails, new object[]{"@ID", nGameLogID});
				//if ( oDR != null )
				//{
				//	lblName.Text = "Game Log Name: " + oDR["name"].ToString();
				//	string gameXml = oDR["data"].ToString();
				//	gameXml = String.Format("<init processid=\"-1\" processname=\"\" subcategoryname=\"\" rhand=\"{0}\" sessionid=\"-1\"><gaaction>{1}</gaaction></init>", nGameLogID, gameXml);
				//	SaveXml(gameXml);
				//}

				DataRow oDR = GetFirstRow(Config.DbGetGameLogDetails, "@GameLogID", nGameLogID);
				if (oDR != null)
				{
					lblName.Text = "Game Log Name: " + oDR["name"].ToString();
					string gameXml = oDR["data"].ToString();
					gameXml = FromBase64ToString(gameXml);
					if (Config.IsHandLogCompressed == "true")
					{
						//string retXml = "";
						NetCompress.Zip  oUncompress = new NetCompress.Zip();
						gameXml=oUncompress.Extract(gameXml);
						//gameXml = retXml;
					}
					gameXml = String.Format("<init processid=\"-1\" processname=\"\" subcategoryname=\"\" rhand=\"{0}\" sessionid=\"-1\"><gaaction>{1}</gaaction></init>", nGameLogID, gameXml);
					SaveXml(gameXml);
				}
				//DesktopAPIEngine.ApiControl  oApi = Config.GetApIEngine() ;
				//string gameXml = oApi.GetPersonalHandHistory( nGameLogID, DesktopAPIEngine.ApiMsg.msgForAction.GETPERSONALHANDHISTORYASTEXT);
				//gameXml = String.Format("<init processid=\"-1\" processname=\"\" subcategoryname=\"\" rhand=\"{0}\" sessionid=\"-1\"><gaaction>{1}</gaaction></init>", nGameLogID, gameXml);
			}
			InitJavascript();
			GetGoBackUrl();
		}


		private string FromBase64ToString(string base64Data)
		{
			byte[] bytesData  = Convert.FromBase64String(base64Data);
			string sData = "";
			foreach(byte byteData in bytesData)
			{
				sData += Convert.ToChar(byteData);
			}
			return sData;
		}

		private void SaveXml(string sXml)
		{
			string uploadUrl = Config.FileUploadUrl;
			if (!uploadUrl.Trim().EndsWith("/")) uploadUrl += "/";
			string tempFolderUrl = Config.TempFolder;
			if (!tempFolderUrl.Trim().EndsWith("/")) tempFolderUrl += "/";

			string uploadRoot = Config.FileUploadPath;
			if (!uploadRoot.Trim().EndsWith("\\")) uploadRoot += "\\";
			string tempFolderPath = Config.TempFolder;
			if (!tempFolderPath.Trim().EndsWith("\\")) tempFolderPath += "\\";


			Guid guid = Guid.NewGuid(); //guid will used to make name unique
			sXmlFilePath = String.Format("{0}{1}{2}.xml", uploadRoot, tempFolderPath,  guid.ToString());
			sXmlFileUrl = String.Format("{0}{1}{2}.xml", uploadUrl, tempFolderUrl,  guid.ToString());


			StreamWriter fileSave = new StreamWriter(sXmlFilePath, false);
			fileSave.Write(sXml);
			fileSave.Flush();                               
			fileSave.Close();   
		}

		protected void btnClose_click(object sender, System.EventArgs e)
		{
			//
		}
		
		public string GetXmlPath()
		{
			return sXmlFilePath.Replace("\\", "\\\\");
		}
		public string GetXmlUrl()
		{
			return sXmlFileUrl;
		}


		public string GetPokerSwfUrl()
		{
			string sRet = "";
			DataRow oDR = DBase.GetFirstRow(Config.DbGetContentTypeSkinFile,
				"@contentTypeID", CONST_CONTENTTYPEPOKERTABLE);
			if (oDR != null) sRet = oDR["url"].ToString();
			return sRet;
		}
		
		protected void InitJavascript()
		{
			btnClose.NavigateUrl = "Close";
			btnClose.oLink.Attributes["onclick"] = "window.close(); return false;";
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
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion


	}
}

