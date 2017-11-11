namespace Admin.Controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	using Common.WebControls;

	/// <summary>
	///		Summary description for PageHeader.
	/// </summary>
	public class PageHeader : System.Web.UI.UserControl, INamingContainer
	{
		protected System.Web.UI.WebControls.Image oImageLogo;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			oImageLogo.ImageUrl = Config.ImageFolder + Config.ImageLogoName;
		}

		public string GetPageName()
		{
			
			string sPageName = string.Empty;
			Common.Web.Page oPage = (Page as Common.Web.Page);
			if ( oPage != null )
			{
				sPageName = oPage.GetPageInfoName();
			}
			else
			{
				InvalidCastException oEx = new InvalidCastException("Inherit your page class from Common.WebControls.Page");

				oEx.Source = "PageHeader control";
				throw(oEx);
			}
			return sPageName;
			
			//return ((Common.WebControls.Page)Page).GetPageInfoName();
		}
		public string GetCssPageUrl()
		{
			return Config.CommonCssPath;
		}

		public string GetMenuPath()
		{
			HttpCookie userTypeCookie = Request.Cookies[Config.UserTypeCookie];
			if (userTypeCookie != null) 
			{
				if (Common.Utils.GetInt(userTypeCookie.Value) == Config.UserTypeCustomerSupport)
				{
					return String.Format("{0}{1}", Config.SiteRoot, "Menu/csMenu");
				}
			}

			return String.Format("{0}{1}", Config.SiteRoot, "Menu");
		}

		public string GetMainMenuLink()
		{
			if (Page.Request[Config.ParamMenu] == "no") return "";
			return string.Format("<script language=\"JavaScript\" type=\"text/javascript\" src=\"{0}\"></script>", ((Common.Web.Page)Page).FindPage(Config.PageJsMenuLoader).PageBaseUrl);
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
		
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
