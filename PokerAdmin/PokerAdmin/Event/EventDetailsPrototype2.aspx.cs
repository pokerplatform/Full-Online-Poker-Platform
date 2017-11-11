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

using Admin.CommonUse;
using Common;
using Common.Web;

namespace Admin.Event
{
	/// <summary>
	/// Summary description for EventDetails.
	/// </summary>
	public class EventDetailsPrototype2 : Common.Web.Page
	{
		protected int nEventID = 0;
		protected int nCategoryID = 0;
		protected int nSubCategoryID = 0;
		const int stateReady  = 2;
		const int stateActive = 3;

		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnEventID;
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.DropDownList comboCategory;
		protected System.Web.UI.WebControls.DropDownList comboSubCategory;
		protected System.Web.UI.HtmlControls.HtmlTableRow EventStatus;
		protected System.Web.UI.WebControls.DropDownList comboDate;
		protected System.Web.UI.WebControls.DropDownList comboTime;
		protected System.Web.UI.WebControls.DropDownList comboHomeSpread;
		protected System.Web.UI.WebControls.DropDownList comboTotalOU;
		protected System.Web.UI.WebControls.TextBox txtHomeML;
		protected System.Web.UI.WebControls.TextBox txtAwayML;
		protected System.Web.UI.HtmlControls.HtmlTableRow rowNewsTable;
		protected Controls.ButtonImage btnSave;
		protected System.Web.UI.WebControls.TextBox txtHomeSpread;
		protected System.Web.UI.WebControls.TextBox txtTotalOU;
		protected System.Web.UI.WebControls.TextBox txtHomeTeam;
		protected System.Web.UI.WebControls.TextBox txtAwayTeam;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnSubCategoryList;
		protected System.Web.UI.WebControls.DropDownList comboAway;
		protected System.Web.UI.WebControls.DropDownList comboHome;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnHomeList;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnAwayList;
		protected Controls.ButtonImage btnProcess;

		#region PageLoad / GetPageData
		private void Page_Load(object sender, System.EventArgs e)
		{
			nEventID = GetMainParamInt(hdnEventID);
			if ( !IsPostBack )
			{
				if ( nEventID > 0 )
				{
					GetPageData();
				}
				FillComboBoxes();
				DisplayControls();
			}
			InitJS();
		}

		//
		private void GetPageData()
		{
			DataRow oDR = GetFirstRow(Config.DbGetEventDetails, new object[]{"@EventID", nEventID});
			if ( oDR != null )
			{
				//txtAway.Text         = oDR["away"].ToString();
				//txtHome.Text         = oDR["home"].ToString();
				nCategoryID          = Utils.GetInt(oDR["CategoryID"]);
				nSubCategoryID       = Utils.GetInt(oDR["SubCategoryID"]);
			}
		}

		private void InitJS()
		{
			comboCategory.Attributes["onchange"] = "FillSubCategory();FillHome();FillAway(); return false;";

			comboSubCategory.Attributes["onchange"] = "FillHome();FillAway(); return false;";
		}


		#endregion

		#region Display controls
		private void DisplayControls()
		{
			bool bPresent = nEventID > 0;
			btnProcess.Visible = bPresent;

			btnProcess.Visible = false;
			btnSave.Visible = false;
		}
		#endregion


		#region Fill ComBoxes
		private void FillComboBoxes()
		{
			GetCategoriesCombo();
			GetSubCategoriesCombo();
			GetDateCombo();
			GetTimeCombo();
			GetHomeSpreadCombo();
			GetTotalOUCombo();
		}

		private void GetCategoriesCombo()
		{
			DBase.FillList(comboCategory, nCategoryID, Config.DbGetSBCategoryListSimple, false);
		}
		private void GetSubCategoriesCombo()
		{
			DataTable oDT = GetDataTable(Config.DbGetSBSubCategoryList);
			DataView  oDV = new DataView(oDT);
			string insideRowDelimeter = ",";
			string betweenRowDelimeter = ";";
			string subCategoryList = "";
			string TeamListHome = "";
			string TeamListAway = "";
			int iTeam = 1;
			foreach(DataRowView oDR in oDV)
			{
				subCategoryList += oDR["SubCategoryName"].ToString() + insideRowDelimeter;
				subCategoryList += oDR["ID"].ToString() + insideRowDelimeter;
				subCategoryList += oDR["CategoryID"].ToString() + betweenRowDelimeter;

				for(int j=1;j<=2;j++)
				{
					TeamListHome += "Home Team " + j.ToString()+ " " + oDR["SubCategoryName"].ToString() + insideRowDelimeter;
					TeamListHome += iTeam.ToString() + insideRowDelimeter;
					TeamListHome += oDR["ID"].ToString() + betweenRowDelimeter;
					TeamListAway += "Away Team " + j.ToString()+ " " + oDR["SubCategoryName"].ToString() + insideRowDelimeter;
					TeamListAway += iTeam.ToString() + insideRowDelimeter;
					TeamListAway += oDR["ID"].ToString() + betweenRowDelimeter;
					iTeam++;
				}
			}
			if ((subCategoryList.Length>0) &&
				(subCategoryList.LastIndexOf(betweenRowDelimeter) == subCategoryList.Length - betweenRowDelimeter.Length))
			{
				subCategoryList = subCategoryList.Substring(0, subCategoryList.Length - betweenRowDelimeter.Length);
			}
			hdnSubCategoryList.Value = subCategoryList;

			hdnHomeList.Value = TeamListHome;
			hdnAwayList.Value = TeamListAway;
		}

		private void GetDateCombo()
		{
			DateTime dtNow = DateTime.Now;
			DateTime dtNextMonth = dtNow.AddMonths(1);
			while (dtNow<dtNextMonth)
			{
				comboDate.Items.Add(dtNow.ToShortDateString());
				dtNow = dtNow.AddDays(1);
			}
		}

		private void GetTimeCombo()
		{
			for(int i=0; i<24; i++)
			{
				comboTime.Items.Add(i.ToString() + ":00");
				comboTime.Items.Add(i.ToString() + ":30");
			}
		}

		private void GetHomeSpreadCombo()
		{
			comboHomeSpread.Items.Add("- Select Spread -");
			double i = -100.0;
			while (i<=100.0)
			{
				comboHomeSpread.Items.Add(Convert.ToString(Math.Round(i,1)));
				i += 0.5;
			}
			comboHomeSpread.Items.FindByValue("0").Selected = true;
		}

		private void GetTotalOUCombo()
		{
			comboTotalOU.Items.Add("- Select Total O/U -");
			for(int i=0; i<=300; i++)
			{
				comboTotalOU.Items.Add(i.ToString());
			}
			comboTotalOU.Items.FindByValue("0").Selected = true;
		}

		#endregion



		#region Save/Process Event Handlers
		protected void btnProcess_Click(object sender, System.EventArgs e)
		{
		}

		protected void btnGoBack_Click(object sender, System.EventArgs e)
		{
			string EventMaintenacePage = FindPageAbsoluteUrl(Config.PageEventMaintenance);
			Response.Redirect(EventMaintenacePage);
		}


		protected void btnSave_Click(object sender, System.EventArgs e)
		{
		}


		private void ShowError(string param)
		{
			lblInfo.ForeColor = Color.Red;
			lblInfo.Text = param;
		}

		#endregion


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
