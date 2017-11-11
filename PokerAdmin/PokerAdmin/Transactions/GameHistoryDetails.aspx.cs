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

using Common;
using Common.Web;
using Common.Com;

namespace Admin.Transactions
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class GameHistoryDetails : Common.Web.Page
	{
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnGameLogID;
		protected GameHistory gameHistory;
		protected System.Web.UI.WebControls.Label lblInfo;
		protected Controls.ButtonImage btnPlay;
		protected Controls.ButtonImage btnCancel;
		protected System.Web.UI.WebControls.Label Label1;
		protected System.Web.UI.WebControls.TextBox txtHndID;
		protected System.Web.UI.WebControls.Panel pnHandId;
		protected int nGameLogID = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{
			int gLog=0;
			try
			{
				gLog = GetMainParamInt(hdnGameLogID);
			}
			catch
			{ gLog =0 ; }

			pnHandId.Visible =(gLog <=0);
			nGameLogID =gLog; 

			if ( !IsPostBack && nGameLogID>0 )
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
				string sResult = gameHistory.Details(Page, nGameLogID);
				lblInfo.Text = sResult;
			}
			InitJavascript();
		}


		protected void btGoHand_Click(object sender, System.EventArgs e)
		{
			nGameLogID = Utils.GetInt(txtHndID.Text); 
			GetData();
		}


		protected void InitJavascript()
		{
			string windowParam = "'toolbar=no,menubar=no,scrollbars=yes,resizable=yes,width=800,height=600'";
			string getParam = "?" + Config.ParamMenu + "=no&";
			string playGameUrl = FindPageAbsoluteUrl(Config.PageGameHistoryPlay)+ getParam + Config.ParamGameLogID + "=" + nGameLogID.ToString();
			btnPlay.NavigateUrl = "PlayGame";
			btnPlay.oLink.Attributes["onclick"] = "window.open('" + playGameUrl + "','playGameUrl'," + windowParam + "); return false;";
		}


		protected void btnPlay_click(object sender, System.EventArgs e)
		{
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

