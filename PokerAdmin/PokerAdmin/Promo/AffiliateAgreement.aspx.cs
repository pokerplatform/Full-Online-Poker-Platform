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


using Common;
using Common.Web;

namespace Promo
{
	/// <summary>
	/// Summary description for AffiliateAgreement.
	/// </summary>
	public class AffiliateAgreement  : Common.Web.Page
	{
		private string m_skDomain="";
		protected System.Web.UI.WebControls.Image oImg;
		protected System.Web.UI.WebControls.Image Image1;
		protected System.Web.UI.WebControls.Image Image2;
		private string m_skSuppEmail="";
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			if ( Session["AffiliateSignup_SkinsID"]==null) return;
			    int skID=Utils.GetInt ( Session["AffiliateSignup_SkinsID"]);
			    DataTable tb=DBase.GetDataTable(Config.DbGetSkinsDetails,"@ID",skID);
			    if (tb == null || tb.Rows.Count <=0 ) return; 
			    m_skDomain =tb.Rows[0]["SkinsDomain"].ToString() ; 
				m_skSuppEmail =tb.Rows[0]["EmailSupport"].ToString(); 
 		}

		public string GetCssPageUrl()
		{
			return Config.CommonCssPath;
		}

		public string GetDomain()
		{
			return m_skDomain;
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
