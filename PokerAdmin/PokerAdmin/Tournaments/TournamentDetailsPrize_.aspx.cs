using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;

using Admin.CommonUse;
using Common;
using Common.Web;

namespace Admin.Tournaments
{
	/// <summary>
	/// Summary description for TournamentPrizes.
	/// </summary>
	public class TournamentDetailsPrize : Common.Web.Page
	{
		int nTournamentID = 0;
		string xmlTournamentPrize = "";
		int nTemplateID = 1;
		protected PrizeTable oPrize = new PrizeTable();
		protected Controls.ButtonImage btnSave;
		protected Controls.ButtonImage btnCancel;
		protected Controls.ButtonImage btnAdd;
		protected Controls.ButtonImage btnDelete;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTournamentID;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTournamentPrizeXML;
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.DropDownList comboTemplate;
		protected System.Web.UI.WebControls.Table table;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nTournamentID = GetMainParamInt(hdnTournamentID);
			xmlTournamentPrize = hdnTournamentPrizeXML.Value;

			if ( !IsPostBack )
			{
				PreparePage();
				GetData();
			}
			InitJS();
		}

		protected void InitJS()
		{
			//Add column/row
			btnAdd.NavigateUrl = "Add";
			btnAdd.oLink.Attributes["onclick"] = "AddNew(); return false;";

			//Delete column/rows
			btnDelete.NavigateUrl = "Delete";
			btnDelete.oLink.Attributes["onclick"] = "DeleteSelected(); return false;";

			btnSave.NavigateUrl = "Save";
			btnSave.oLink.Attributes["onclick"] = "return GetXML();";

		}


		protected void btnSave_click(object sender, System.EventArgs e)
		{
			xmlTournamentPrize = hdnTournamentPrizeXML.Value;
			oPrize.FillTable(ref xmlTournamentPrize, ref table, true, false);  //fill table from xml

/*			int nRet = DBase.Execute(Config.DbUpdateTournamentPrize, "@ID", nTournamentID, "@PrizeXml", xmlTournamentPrize); 
			if (nRet==0)
			{
				ShowError("Database error occured");
				return;
			}
*/
			PokerControls.TournamentClass oTournament = new PokerControls.TournamentClass();
			int nRet = oTournament.SetPrizePool(nTournamentID, xmlTournamentPrize); 
			if (nRet!=0)
			{
				ShowError("COM error occured");
				return;
			}
			lblInfo.Text = "Tournament Prizes were saved";
			lblInfo.ForeColor = Color.Green;

			oTournament=null;
			GC.Collect();

			Response.Redirect(GetGoBackUrl());
		}

		protected void btnCopy_Click(object sender, System.EventArgs e)
		{
			xmlTournamentPrize = hdnTournamentPrizeXML.Value;
			int tempateID = Convert.ToInt32(comboTemplate.Items[comboTemplate.SelectedIndex].Value);
			DataRow oDR = GetFirstRow(Config.DbGetTournamentPrizeDetails, new object[]{"@ID", tempateID});
			if ( oDR != null )
			{
				if (oDR["PaySchemaXML"]!=null) xmlTournamentPrize = oDR["PaySchemaXML"].ToString();
			}
			oPrize.FillTable(ref xmlTournamentPrize, ref table, true, false);
			hdnTournamentPrizeXML.Value = xmlTournamentPrize;
		}
				  
				  

		/// <summary>
		/// Fill page combo boxes
		/// </summary>
		protected void PreparePage()
		{
			DBase.FillList(comboTemplate, nTemplateID, Config.DbDictionaryTournamentPrize, false);
		}

		/// <summary>
		/// Retrieve DB data to place to the page
		/// </summary>
		protected void GetData()
		{
			if (nTournamentID>0)
			{
				DataRow oDR = GetFirstRow(Config.DbGetTournamentDetails, new object[]{"@ID", nTournamentID});
				if ( oDR != null )
				{
					if (oDR["PaySchemaXML"]!=null) xmlTournamentPrize = oDR["PaySchemaXML"].ToString();
				}
			}
			else 
			{
				ShowError("Incorrect Parameters");
				return;
			}

			oPrize.FillTable(ref xmlTournamentPrize, ref table, true, false);
			hdnTournamentPrizeXML.Value = xmlTournamentPrize;
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
