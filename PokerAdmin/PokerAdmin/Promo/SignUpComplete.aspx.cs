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

using Common;
using Common.Web;
using Common.Com;

namespace Promo
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class SignupComplete : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Button btSelectSkin;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnAffiliateID;
		protected System.Web.UI.WebControls.Image oImg;
		protected System.Web.UI.WebControls.Image Image1;
		protected System.Web.UI.WebControls.Image Image2;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnSkinID;

        string m_skSuppEmail="";

		private void Page_Load(object sender, System.EventArgs e)
		{
            int SK_ID= Utils.GetInt(  Request["SkinsID"]); 
			if (SK_ID >0)
			{
				DataTable tb=DBase.GetDataTable(Config.DbGetSkinsDetails,"@ID",SK_ID);
				if (tb == null || tb.Rows.Count <=0 ) return; 
				m_skSuppEmail =tb.Rows[0]["EmailSupport"].ToString(); 
			}
		}

		public string GetCssPageUrl()
		{
			return Config.CommonCssPath;
		}

		public string GetSuppEmail()
		{
			return m_skSuppEmail;
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

