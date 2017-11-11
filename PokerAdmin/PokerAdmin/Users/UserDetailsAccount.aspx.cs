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

namespace Admin.Users
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class UserDetailsAccount : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnUserID;
		protected System.Web.UI.WebControls.Label lblBalance;
		protected System.Web.UI.WebControls.Label lblTodayDeposit;
		protected System.Web.UI.WebControls.Label lblWeekDeposit;
		protected System.Web.UI.WebControls.Label lblMonthDeposit;
		protected System.Web.UI.WebControls.Label lblUserName;
		protected System.Web.UI.WebControls.DropDownList comboCurrency;
		protected System.Web.UI.WebControls.TextBox txtReason;
		protected System.Web.UI.WebControls.TextBox txtAmount;
		protected Controls.ButtonImage btnSave;
		protected Controls.ButtonImage btnCancel;
		protected int nUserID = 0;
		protected int nAccountID = 0;
		protected System.Web.UI.HtmlControls.HtmlInputHidden Hidden1;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnAccountID;
		protected System.Web.UI.WebControls.TextBox txtAmountTr;
		protected System.Web.UI.WebControls.TextBox txtReasonTr;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnBalance;
		protected System.Web.UI.WebControls.TextBox txtUser;
		protected int nCurrencyID = -1;

		private void Page_Load(object sender, System.EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nUserID = GetMainParamInt(hdnUserID);
			nAccountID = Utils.GetInt(hdnAccountID.Value);
			if (comboCurrency.SelectedItem!=null)
			{
				nCurrencyID = Utils.GetInt(comboCurrency.SelectedItem.Value);
			}

			
			if ( !IsPostBack )
			{
				GetData();
				PreparePage();
			}
		}
	

		/// <summary>
		/// Fill both combo boxes
		/// </summary>
		protected void PreparePage()
		{
			DBase.FillList(comboCurrency, nCurrencyID, Config.DbDictionaryCurrency, false);
		}

		/// <summary>
		/// Retrieve data will be placed on the page from the database
		/// </summary>
		protected void GetData()
		{
			if ( nUserID > 0 )
			{
				DataRow oDR = GetFirstRow(Config.DbGetUserDetailsAccount, new object[]{"@UserID", nUserID, "@CurrencyID", nCurrencyID});
				if ( oDR != null )
				{
					lblUserName.Text     = "User: " + oDR["UserName"].ToString();
					lblBalance.Text   = oDR["Balance"].ToString();
					hdnBalance.Value =lblBalance.Text ;
					lblTodayDeposit.Text = oDR["DepositedPerDay"].ToString();
					lblWeekDeposit.Text  = oDR["DepositedPerWeek"].ToString();
					lblMonthDeposit.Text = oDR["DepositedPerMonth"].ToString();
					if (nCurrencyID<=0) nCurrencyID = Utils.GetInt(oDR["CurrencyTypeID"]);
					nAccountID = Utils.GetInt(oDR["AccountID"]);
					hdnAccountID.Value = nAccountID.ToString(); 
					btnSave.Visible = true;
				}
				else
				{
					lblBalance.Text      = "";
					lblTodayDeposit.Text = "";
					lblWeekDeposit.Text  = "";
					lblMonthDeposit.Text = "";
					btnSave.Visible = false;
				}
				txtAmount.Text = "";
				txtReason.Text = "";
				if (Request[Config.ParamBack]=="no") btnCancel.Visible = false;
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
			this.comboCurrency.SelectedIndexChanged += new System.EventHandler(this.comboCurrency_SelectedIndexChanged);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void comboCurrency_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			GetData();
		}

		protected void btnTransfer_click(object sender, System.EventArgs e)
		{
			int nTrgAccountID=0;
			if(Utils.GetDecimal(hdnBalance.Value) < Utils.GetDecimal ( txtAmountTr.Text ) ) return;
			if (Utils.GetDecimal ( txtAmountTr.Text )==0 ) return;
			int UserID  = DBase.ExecuteReturnInt(Config.DbGetUserID, new object[]{"@LoginName", txtUser.Text});
			if (UserID<=0)
			{
				lblInfo.Text ="Invalid Login name";
				return;
			}
			DataRow oDR = GetFirstRow(Config.DbGetUserDetailsAccount, new object[]{"@UserID", UserID , "@CurrencyID", nCurrencyID});
			if ( oDR != null )
				nTrgAccountID = Utils.GetInt(oDR["AccountID"]);
			else
				return;

			DBase.BeginTransaction("TransferAmmount"); 
			if (!SaveMoney(nAccountID, (0-Utils.GetDecimal ( txtAmountTr.Text )),txtReasonTr.Text))
			{
				DBase.RollbackTransaction(); 
				return;
			}
			if (!SaveMoney(nTrgAccountID , Utils.GetDecimal ( txtAmountTr.Text ),txtReasonTr.Text))
			{
				DBase.RollbackTransaction(); 
				return;
			}
               
			      DBase.CommitTransaction();
 
			lblInfo.Text = "User balance was changed";
			lblInfo.ForeColor = Color.Green;
			GetData();
		}

		protected void btnSave_click(object sender, System.EventArgs e)
		{
			decimal Amount = Utils.GetDecimal(txtAmount.Text);
			if (Amount==0){
				if (txtAmount.Text.Trim()!="0")
				{
					lblInfo.Text = "Amount to add is not correct";
					lblInfo.ForeColor = Color.Red;
				}
				return;
			}
			if (SaveMoney(nAccountID, Amount,txtReason.Text))
			{
				lblInfo.Text = "User balance was changed";
				lblInfo.ForeColor = Color.Green;
			}
			GetData();
		}

		protected bool SaveMoney(int pAccountID, decimal pAmount , string pReason)
		{
			if (pAmount==0)
			{
					lblInfo.Text = "Amount is not correct";
					lblInfo.ForeColor = Color.Red;
				return false;
			}

			int nRes = DBase.Execute(Config.DbSaveTransaction, "@Amount", pAmount,
				"@AccountID", pAccountID, "@Comment", pReason);
			if (nRes==0)
			{
				lblInfo.Text = "Database error occured";
				lblInfo.ForeColor = Color.Red;
				return false;
			}
			return true;
		}


	}
}

