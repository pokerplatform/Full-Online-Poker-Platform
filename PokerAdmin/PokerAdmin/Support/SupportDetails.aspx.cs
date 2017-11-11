using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient ;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Web.Mail;

using Common;
using Common.Web;
using Admin.CommonUse;

namespace Admin.Support
{
	/// <summary>
	/// Summary description for SBCategoryDatails.
	/// </summary>
	public class SupportDetails : Common.Web.Page
	{
		#region Page Controls / const
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnID;
		protected PrizeTable oPrize = new PrizeTable();
		protected System.Web.UI.WebControls.Label lblUserName;
		protected System.Web.UI.WebControls.Label lblLogin;
		protected System.Web.UI.WebControls.Label lblSubject;
		protected System.Web.UI.WebControls.TextBox txtMessageBody;
		protected System.Web.UI.WebControls.TextBox txtAnswer;
		protected Controls.ButtonImage btnSave;
		protected Controls.ButtonImage btnReturn;
		protected Controls.ButtonImage btnUser;
		protected Controls.ButtonImage btnUserProfile;
		protected Controls.ButtonImage btnUserAccount;
		protected Controls.ButtonImage btnHandHistory;
		protected Controls.ButtonImage btnTransactionHistory;
		protected System.Web.UI.WebControls.TextBox txtEmail;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnUserID;

		int nSupportID = 0;
		protected System.Web.UI.WebControls.Label lblFooter;
		protected System.Web.UI.WebControls.TextBox txtHeader;
		const int completedState = 2;

		const string firstNameTemplate = "{FIRSTNAME}";
		const string CSNameTemplate = "{CSNAME}";
		#endregion


		#region Page_Load / Show Control/ InitJScript/ Get Data
		private void Page_Load(object sender, System.EventArgs e)
		{
			nSupportID = GetMainParamInt(hdnID);
			BackPageUrl= (string) Session["SupportMaintenanceUrl"];
			if ( !IsPostBack )
			{
				GetData();
			}
			InitJavascript();
			ShowControls();
		}

		protected void ShowControls(){
			bool bShow = (hdnUserID.Value != "");
			btnUserProfile.Visible = bShow;
			btnUserAccount.Visible = bShow;
			btnUser.Visible = !bShow;
		}

		/// <summary>
		/// Retrieve data will be placed on the page from the database
		/// </summary>
		protected void GetData()
		{
			int supportUserID = GetCurrentUserID();
/*			HttpCookie userIDCookie = Request.Cookies[Config.UserIDCookie];
			if (userIDCookie != null)
			{
				supportUserID = Utils.GetInt(userIDCookie.Value);
			}
*/
			DataRow oDR = GetFirstRow(Config.DbGetSupportDetails, new object[]{"@id", nSupportID, "@SupportUserID", supportUserID});
			if ( oDR != null )
			{
				lblUserName.Text    = oDR["userName"].ToString();
				lblLogin.Text       = oDR["loginName"].ToString();
				txtEmail.Text       = oDR["Email"].ToString();
				lblSubject.Text     = oDR["subject"].ToString();
				txtMessageBody.Text = oDR["body"].ToString();
				txtAnswer.Text		= oDR["answer"].ToString();
				hdnUserID.Value     = oDR["userID"].ToString();
				string firstName	= GetUserName(oDR["firstName"], oDR["Email"]);
				string sHeader      = RemoveTags(oDR["headerBody"].ToString());
				txtHeader.Text		= sHeader.Replace(firstNameTemplate, firstName);
				string csUserName   = oDR["csUserName"].ToString();
				lblFooter.Text		= oDR["footerBody"].ToString().Replace(CSNameTemplate, csUserName);
				int SupportStatusID = Utils.GetInt(oDR["SupportStatusID"]);
				if (SupportStatusID == completedState)
				{
					txtAnswer.ReadOnly = true;
					txtEmail.ReadOnly = true;
					btnSave.Visible = false;
					txtHeader.Visible = false;
					lblFooter.Visible = false;
				}
			}
		}

		protected void InitJavascript()
		{
			string menuParam = "?" + Config.ParamMenu + "=no&";
			string backParam = Config.ParamBack + "=no&";
			string windowParam = "'toolbar=no,menubar=no,scrollbars=yes,resizable=yes,width=800,height=600,location=no,screenX=10,screenY=10'";

			//user profile
			string userUrl = FindPageAbsoluteUrl(Config.PageUserMaintenance)+ menuParam + backParam + Config.ParamUserID + "=" + hdnUserID.Value;
			btnUser.NavigateUrl = "users";
			btnUser.oLink.Attributes["onclick"] = "window.open('" + userUrl + "','user'," + windowParam + "); return false;";

			//user profile
			string userProfileUrl = FindPageAbsoluteUrl(Config.PageUserDetails)+ menuParam + backParam + Config.ParamUserID + "=" + hdnUserID.Value;
			btnUserProfile.NavigateUrl = "userProfile";
			btnUserProfile.oLink.Attributes["onclick"] = "window.open('" + userProfileUrl + "','userProfile'," + windowParam + "); return false;";

			//user account
			string userAccountUrl = FindPageAbsoluteUrl(Config.PageUserDetailsAccount)+ menuParam + backParam + Config.ParamUserID + "=" + hdnUserID.Value;
			btnUserAccount.NavigateUrl = "userProfile";
			btnUserAccount.oLink.Attributes["onclick"] = "window.open('" + userAccountUrl + "','userAccount'," + windowParam + "); return false;";

			//TxHistory
			string transactionHistoryUrl = FindPageAbsoluteUrl(Config.PageTxHistoryList)+ menuParam + "oFilter:userName=" + lblUserName.Text;
			btnTransactionHistory.NavigateUrl = "TransactionHistory";
			btnTransactionHistory.oLink.Attributes["onclick"] = "window.open('" + transactionHistoryUrl + "','transactionHistory'," + windowParam + "); return false;";

			//HandHistory
			string handHistoryUrl = FindPageAbsoluteUrl(Config.PageGameHistoryUserList)+ menuParam + "oFilter:userName=" + lblUserName.Text;
			btnHandHistory.NavigateUrl = "HandHistory";
			btnHandHistory.oLink.Attributes["onclick"] = "window.open('" + handHistoryUrl + "','handHistory'," + windowParam + "); return false;";
		}

		#endregion

		#region Save / Return
		protected void btnReturn_Click(object sender, System.EventArgs e)
		{
			string CustomerSupportListUrl = FindPageAbsoluteUrl(Config.PageSupportMaintenance);
			Response.Redirect(CustomerSupportListUrl);
		}

		protected string GetAffiliateEmail()
		{
			SqlParameter [] sp=new SqlParameter[] {new SqlParameter("@UserID",SqlDbType.Int ) ,
																							  new SqlParameter("@EmailFrom",SqlDbType.VarChar,50) }; 
			sp[0].Value =int.Parse (hdnUserID.Value );
			sp[1].Value ="";
			sp[1].Direction=ParameterDirection.Output; 
       
			return DBase.ExecuteWithOutput("dskGetAffiliateEMailFrom",sp).ToString() ;
			
		}

		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			//1. Send answer to customer
			lblInfo.Text="";
			string msgBody = String.Format("{0}\r\n{1}\r\n\r\n{2}", txtHeader.Text, txtAnswer.Text, RemoveTags(lblFooter.Text));
			int rez=	CommonUse.CSentMail.Send(DBase,txtEmail.Text,GetAffiliateEmail(), "Re: " + lblSubject.Text,
													msgBody,MailFormat.Text);  
			if (rez==1)
				ShowError("Send Mail error occured");
			else if (rez==2)
				ShowError("Message was send , but Database error occured");

            if (rez<=1) return;

			//2. Update DB
			int nRes = DBase.Execute(Config.DbSaveSupportDetails, new object[]{"@id", nSupportID, "@Answer", msgBody});
			if (nRes <= 0)
			{
				lblInfo.ForeColor = Color.Red;
				lblInfo.Text += " Database error occured";
				return;
			}	

			//3. Sucess message
			lblInfo.ForeColor = Color.Green;
			lblInfo.Text += " Message was saved and send";
			StoreBackID(nRes);
			hdnID.Value = nRes.ToString();

			txtAnswer.ReadOnly = true;
			btnSave.Visible = false;

			btnReturn_Click(null, null);
			//Response.Redirect(GetGoBackUrl());
		}


		private void ShowError(string sError)
		{
			lblInfo.Text = sError;
			lblInfo.ForeColor = Color.Red;
		}
		#endregion

		#region Utils (GetUserName, RemoveTags)
		protected string GetUserName(object oName, object oEmail)
		{
			string sRet = "";
			if (oName == System.DBNull.Value)
			{
				if (oEmail != System.DBNull.Value)
				{
					string sEmail = oEmail.ToString();
					int eT = sEmail.IndexOf("@");
					if (eT > 0)
					{
						sRet = sEmail.Substring(0, eT);
					}
				}
			}
			else
			{
				sRet = oName.ToString();
			}
			return sRet;
		}

		protected string RemoveTags(string htmlString)
		{
			string sRet = htmlString;
			sRet = sRet.Replace("<br>", "\r\n");
			sRet = sRet.Replace("<BR>", "\r\n");
			return sRet;
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
