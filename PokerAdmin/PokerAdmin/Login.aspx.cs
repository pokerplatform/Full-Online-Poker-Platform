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

using System.Web.Security;
using Common;

namespace Admin
{
	/// <summary>
	/// Summary description for Login.
	/// </summary>
	public class Login : Common.Web.Page
	{
		protected System.Web.UI.WebControls.TextBox oLogin;
		protected System.Web.UI.WebControls.TextBox oPassword;
		protected System.Web.UI.WebControls.Label oError;
		protected System.Web.UI.WebControls.Image oImageLogo;
		protected System.Web.UI.WebControls.CheckBox chSaveLogin;
		protected Controls.ButtonImage btnLogin;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			if (bool.Parse(Session["IPAllowed"].ToString() )==false)
			{
				oError.Text ="Sorry, this IP ("+ Session["IPClient"].ToString()+") is'nt allowed";
				btnLogin.Visible =false; 
			  }
			if ( !IsPostBack )
			{
				oImageLogo.ImageUrl = Config.ImageFolder + Config.ImageLogoName;
				chSaveLogin.Checked = Config.IsCookiePersistent;
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

		protected void btnLogin_Click(object sender, System.EventArgs e)
		{

			// check login in db here
			DataRow oDR = GetFirstRow(Config.DbCheckLogin, "@Login", oLogin.Text, "@Password", oPassword.Text);

			if ( oDR != null && Utils.GetInt(oDR["ID"]) > 0)
			{
				int userID   = Utils.GetInt(oDR["ID"]);
				int userType = Utils.GetInt(oDR["UserTypeID"]);

				if (userType != Config.UserTypeAdmin && userType !=Config.UserTypeCustomerSupport)
				{
					oError.Text = "Access denied";
					return;
				}

					HttpCookie userTypeCookie = new HttpCookie(Config.UserTypeCookie, userType.ToString());
				if (chSaveLogin.Checked )
				{
					DateTime oDateTime = new DateTime(2050,1, 1);
					userTypeCookie.Expires = oDateTime;
				}
				else
				{
					userTypeCookie.Expires = DateTime.MinValue;
				}

					Response.Cookies.Add(userTypeCookie);

				if (userType == Config.UserTypeCustomerSupport)
				{
					//Set authentication status
					FormsAuthentication.SetAuthCookie(userID.ToString()+":"+oLogin.Text+":"+oPassword.Text, chSaveLogin.Checked );
					string CustomerSupportListUrl = FindPageAbsoluteUrl(Config.PageSupportMaintenance);
					Response.Redirect(CustomerSupportListUrl);
				}
				else
				{
					//Redirect to requested url
					FormsAuthentication.RedirectFromLoginPage(userID.ToString()+":"+oLogin.Text+":"+oPassword.Text, chSaveLogin.Checked);
				}
			}
			else
			{
				oError.Text = "Access denied";
			}
		}
	}
}
