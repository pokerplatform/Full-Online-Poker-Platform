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

using Common;
using Common.Web;

namespace Admin.Outcome
{
	/// <summary>
	/// Summary description for OutcomeDetails.
	/// </summary>
	public class OutcomeDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.WebControls.DropDownList comboType;
		protected System.Web.UI.WebControls.TextBox txtRate;
		protected System.Web.UI.WebControls.TextBox txtValue;
		protected System.Web.UI.WebControls.TextBox txtDescription;
		protected System.Web.UI.WebControls.DropDownList comboResult;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator2;
		protected System.Web.UI.WebControls.RangeValidator RangeValidator1;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnID;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnEventID;

		protected int nResultID = 0;
		protected int nTypeID = 0;
		protected System.Web.UI.WebControls.TextBox txtWonValue;
		protected int nOutcomeID = 0;
		protected int nEventID = 0;

		const int overUnderTypeID = 3;
		const int straightTypeID = 1;
		const int handicapTypeID = 2;
		const int overTypeID = 3;
		const int underTypeID = 4;

		const int waitingResultID = 1;
		const int positiveResultID = 2;
		const int negativeResultID = 3;

		private void Page_Load(object sender, System.EventArgs e)
		{
			nOutcomeID = GetMainParamInt(hdnID);
			nEventID = GetParamInt(Config.ParamEventID);
			if (nEventID <= 0)
			{
				nEventID = Utils.GetInt(hdnEventID.Value);
			}

			if ( !IsPostBack )
			{
				GetPageData();
				FillCombo();
				InitJS();
			}
		}
		private void GetPageData()
		{
			DataRow oDR = GetFirstRow(Config.DbGetOutcomeDetails, new object[]{"@OutcomeID", nOutcomeID});
			if ( oDR != null )
			{
				txtName.Text = oDR["Name"].ToString();
				nResultID = Utils.GetInt(oDR["ResultID"]);
				hdnEventID.Value = Utils.GetInt(oDR["EventID"]).ToString();
				txtRate.Text = Utils.GetNumber(oDR["Rate"]);
				//txtRate.Text = Utils.GetNumber(Components.BetPriceConvert.Euro2Usa(oDR["Rate"]));
				txtDescription.Text = oDR["Description"].ToString();
				decimal  BetValue = Utils.GetDecimal(oDR["BetValue"]);
				decimal  WonValue = Utils.GetDecimal(oDR["WonValue"]);
				if (oDR["BetValue"]!=System.DBNull.Value) txtValue.Text = Convert.ToString(Math.Abs(BetValue));
				if (oDR["WonValue"]!=System.DBNull.Value) txtWonValue.Text = Convert.ToString(Math.Abs(WonValue));
				nTypeID = Utils.GetInt(oDR["TypeID"]);
				if ((nTypeID==overUnderTypeID) && (BetValue<0)) nTypeID = underTypeID;  //3 - Over; 4 - Under
				comboType.Items.FindByValue(nTypeID.ToString()).Selected = true;
				
			}
		}

		private void FillCombo()
		{
			//DBase.FillList(comboType, nTypeID, Config.DbGetDictionaryBetType, true);
			DBase.FillList(comboResult, nResultID, Config.DbGetDictionaryOutcomeResult, false);
		}

		private void InitJS()
		{
			comboType.Attributes["onchange"] = "OnTypeChanged();";
		}

		protected void btnNew_Click(object sender, System.EventArgs e)
		{
			string newPageUrl = FindPageAbsoluteUrl(Config.PageOutcomeDetails);
			Response.Redirect(newPageUrl + "?" + Config.ParamEventID + "=" + nEventID.ToString());
		}

		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			int nRes = 0;

			if ( nEventID > 0 )
			{
				SqlCommand oCmd = DBase.GetCommand(Config.DbSaveOutcomeDetails);
				SqlParameterCollection oParams = oCmd.Parameters;

				nTypeID = Core.GetSelectedValueInt(comboType);

				decimal BetValue = Utils.GetDecimal(txtValue.Text);
				decimal WonValue = Utils.GetDecimal(txtWonValue.Text);
				nResultID = waitingResultID;
				if (nTypeID==straightTypeID) nResultID = Core.GetSelectedValueInt(comboResult);
				else if ((txtValue.Text!="") && (txtWonValue.Text!=""))
				{
					nResultID = negativeResultID;
					if ((nTypeID==handicapTypeID) && (WonValue>BetValue)) nResultID = positiveResultID;
					if ((nTypeID==overTypeID)     && (WonValue>BetValue)) nResultID = positiveResultID;
					if ((nTypeID==underTypeID)    && (WonValue<BetValue)) nResultID = positiveResultID;
				}
					
				int factor = 1;
				if (nTypeID==underTypeID) factor = -1;
				if ((nTypeID==underTypeID) || (nTypeID==overTypeID)) nTypeID = overUnderTypeID;

				oParams.Add("@OutcomeID", nOutcomeID);
				oParams.Add("@Name", txtName.Text);
				oParams.Add("@EventID", nEventID);
				//oParams.Add("@Rate", Components.BetPriceConvert.Usa2Euro(txtRate.Text));
				oParams.Add("@Rate", txtRate.Text);
				oParams.Add("@Description", txtDescription.Text);
				oParams.Add("@ResultID", nResultID);
				oParams.Add("@BetTypeID", nTypeID);
				if (txtValue.Text=="") oParams.Add("@BetValue", System.DBNull.Value);
				else oParams.Add("@BetValue", Convert.ToString(BetValue*factor));
				if (txtWonValue.Text=="") oParams.Add("@WonValue", System.DBNull.Value);
				else oParams.Add("@WonValue", Convert.ToString(WonValue*factor));

				nRes = DBase.ExecuteReturnInt(oCmd);
			}
			else
			{
				nRes = -10;
			}

			if ( nRes > 0 )
			{
				hdnID.Value = nRes.ToString();
				StoreBackID(nRes);

				lblInfo.ForeColor = Color.Green;
				lblInfo.Text = "Outcome details have been saved";

				Response.Redirect(GetGoBackUrl());
			}
			else
			{
				switch( nRes )
				{
					case -10:
						lblInfo.Text = "Not specified event! (Parameter error)";
						break;
					case 0:
						lblInfo.Text = "Database error occured";
						break;
					default:
						lblInfo.Text = "Unknown error occured";
						break;
				}
			}
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
