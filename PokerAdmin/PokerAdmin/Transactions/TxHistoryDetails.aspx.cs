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
	public class TxHistoryDetails : Common.Web.Page
	{
		protected Controls.ButtonImage btnCancel;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTxID;
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.TextBox txtDate;
		protected System.Web.UI.WebControls.TextBox txtAmount;
		protected System.Web.UI.WebControls.TextBox txtType;
		protected System.Web.UI.WebControls.TextBox txtUser;
		protected System.Web.UI.WebControls.TextBox txtDocument;
		protected System.Web.UI.WebControls.TextBox txtComment;
		protected GameHistory gameHistory;
		protected TournamentHistory tournamentHistory;
		protected System.Web.UI.WebControls.Label lblNothing;
		protected int nTxID = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{
			nTxID = GetMainParamInt(hdnTxID);
			switch (nTxID)
			{
				case 1: break;
			}
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
			gameHistory.Visible = false;
			tournamentHistory.Visible = false;
			int txTypeID = -1;
			if (nTxID>0)
			{
				DataRow oDR = GetFirstRow(Config.DbGetTxHistoryDetails, new object[]{"@ID", nTxID});
				if ( oDR != null )
				{
					//Genaral Information
					txtUser.Text     = oDR["UserName"].ToString();
					txtType.Text     = oDR["txType"].ToString();
					txtAmount.Text   = oDR["txAmount"].ToString();
					txtDate.Text     = oDR["RecordDate"].ToString();	
					txtDocument.Text = oDR["txDocument"].ToString();
					//Detail information
					txTypeID = Convert.ToInt32(oDR["txTypeID"]);
					switch (txTypeID)
					{
						//Game
						case 5: //Lose
						case 6: //Win
							if (oDR["GameLogID"]==System.DBNull.Value) break;
							int nGameLogID = Convert.ToInt32(oDR["GameLogID"]);
							ShowError(gameHistory.Details(Page, nGameLogID));
							gameHistory.Visible = true;
							break;
						//Tournamnent
						case 7: //Tourney entry
						case 8: //Tourney won
							if (oDR["TournamentID"]==System.DBNull.Value) break;
							int nTournamentID = Convert.ToInt32(oDR["TournamentID"]);
							ShowError(tournamentHistory.Details(Page, nTournamentID));
							tournamentHistory.Visible = true;
							break;
						default: 
							lblNothing.Visible = true;
							break;
					}
					//lblName.Text = "Game Log Name: " + oDR["name"].ToString();
				}
			}
			
		}


		private void ShowError(string sError)
		{
			lblInfo.Text = sError;
			lblInfo.ForeColor = Color.Red;
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

