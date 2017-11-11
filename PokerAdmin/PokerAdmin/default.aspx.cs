using System;
using System.Web;
using Common;
using Common.Web;

namespace Admin
{
	/// <summary>
	/// Summary description for _default.
	/// </summary>
	public class _default : Page
	{
		private void Page_Load(object sender, EventArgs e)
		{
			HttpCookie userTypeCookie = Request.Cookies[Config.UserTypeCookie];
			if (userTypeCookie != null) 
			{
				if (Utils.GetInt(userTypeCookie.Value) == Config.UserTypeCustomerSupport)
				{
					Response.Redirect(FindPageAbsoluteUrl(Config.PageSupportMaintenance));
				}
			}

			Redirect(Config.PageDefault);
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
			this.Load += new EventHandler(this.Page_Load);
		}
		#endregion
	}
}
