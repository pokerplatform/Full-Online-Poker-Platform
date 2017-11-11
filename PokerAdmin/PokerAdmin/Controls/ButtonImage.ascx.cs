namespace Admin.Controls
{
	using Common.WebControls;
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for ButtonImage.
	/// </summary>
	public abstract class ButtonImage : UserControlWithEvents
	{
		protected	string		sNavigateUrl = Config.DefaultHyperButtonNavigateUrl;
		public System.Web.UI.WebControls.HyperLink oLink;
		protected	bool bCausesValidation = true;
		protected	const	string DefaultUrl = "action";
		protected object m_value=null; 
		protected string m_target;

		private void Page_Load(object sender, System.EventArgs e)
		{
			string str = GetOnclickClientReference();
			if ( str != string.Empty )
				oLink.Attributes["onclick"] = str;
		}

		private string GetOnclickClientReference()
		{
			string sRes = string.Empty;
			if ( NavigateUrl == DefaultUrl )
			{
				if ( CausesValidation && Page.Validators.Count > 0 )
				{
					sRes = string.Format("javasctipt:var b = true; if (typeof(Page_ClientValidate) == 'function') b=Page_ClientValidate();if(b){0};return false;",Page.GetPostBackEventReference(this,""));
				}
				else
				{
					sRes = string.Format("javascript:{0};return false;", Page.GetPostBackEventReference(this,""));
				}
			}
			return sRes;
		}

		public object Value
		{
			get{return m_value;}
			set{m_value = value;}
		}

		public string Target
		{
			get{return oLink.Target;}
			set
			{
				oLink.Target = value;
				m_target=value;
			}
		}

		public string NavigateUrl
		{
			get{return oLink.NavigateUrl;}
			set{oLink.NavigateUrl = value;}
		}

		public bool CausesValidation
		{
			get{return bCausesValidation;}
			set{bCausesValidation = value;}
		}

		public string Text
		{
			get{return oLink.Text;}
			set{oLink.Text = value;}
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
			if ( oLink.NavigateUrl == string.Empty )
			{
				oLink.NavigateUrl = DefaultUrl;
			}

		}
		#endregion
	}
}
