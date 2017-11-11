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

namespace Admin.SentEmail
{
	public class SentEmailDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblSubject;
		protected System.Web.UI.WebControls.TextBox txtMessageBody;
		protected Controls.ButtonImage btnReturn;
		protected System.Web.UI.WebControls.Label lblFrom;
		protected System.Web.UI.WebControls.Label lblTo;
		protected System.Web.UI.WebControls.Label lblDate;
		protected System.Web.UI.WebControls.Label lblBy;
        
		protected int nMailtID;

		private void Page_Load(object sender, System.EventArgs e)
		{
			nMailtID = GetMainParamInt();
			if ( !IsPostBack )
			{
				BackPageUrl= (string) Session["SentEmailUrl"];
				GetData();
			}
		}

		protected void GetData()
		{
			DataRow oDR = GetFirstRow(Config.DbGetSentEmalsDetails, new object[]{"@id", nMailtID});
			if ( oDR != null )
			{
				lblDate.Text=DateTime.Parse(oDR["DateSent"].ToString()).ToString("G") ;
				lblBy.Text= oDR["SentByName"].ToString();
				lblFrom.Text   = oDR["sentfrom"].ToString();
				lblTo.Text       = oDR["sentto"].ToString();
				lblSubject.Text     = oDR["subject"].ToString();
				txtMessageBody.Text = oDR["Message"].ToString();
			}
		}

		protected void btnReturn_Click(object sender, System.EventArgs e)
		{
			string CustomerSupportListUrl = FindPageAbsoluteUrl(Config.PageSentEmails);
			Response.Redirect(CustomerSupportListUrl);
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
