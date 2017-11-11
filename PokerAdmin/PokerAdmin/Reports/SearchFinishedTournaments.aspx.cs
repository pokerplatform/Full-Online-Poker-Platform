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

namespace Admin.Reports
{
	/// <summary>
	/// Summary description for SearchFinishedTournaments.
	/// </summary>
	public class SearchFinishedTournaments : Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.TextBox txtStFrom;
		protected System.Web.UI.WebControls.TextBox txtTo;
		protected System.Web.UI.WebControls.TextBox txtEndFrom;
		protected System.Web.UI.WebControls.TextBox txtEndTo;
		protected System.Web.UI.WebControls.DropDownList ddCurrency;
		protected System.Web.UI.WebControls.TextBox txtLoginName;
		protected System.Web.UI.WebControls.DataGrid oGrid;
		protected System.Web.UI.WebControls.Label lbInfo;
		protected System.Web.UI.WebControls.TextBox txtTrnName;
	
		protected override void Page_Load(object sender, System.EventArgs e)
		{
			if ( oSGridPager != null )
			{
				oParentGrid = oSGridPager.GridObject;
			}

			if(!IsPostBack)
			{
				DBase.FillList(ddCurrency,Config.DbDictionaryCurrency,false);
				ddCurrency.Items.Insert(0, new ListItem( "[All]","0"));
			}
		}

		public void btnSearch_Click(object sender, System.EventArgs e)
		{
			lbInfo.Text ="";
			oGrid.DataSource =null; 
             DataTable tb=DBase.GetDataTable(Config.DbFindFinishedTournaments,"@TournName",txtTrnName.Text,
															"@CurrencyType",int.Parse(ddCurrency.SelectedValue ),
															"@LoginName",txtLoginName.Text,
													        "@dbFrom",Common.Utils.GetDbDate (txtStFrom.Text),   
															"@dbTo",Common.Utils.GetDbDate (txtTo.Text),		
															"@deFrom",Common.Utils.GetDbDate (txtEndFrom.Text),
															"@deTo",Common.Utils.GetDbDate (txtEndTo.Text));
             oGrid.DataSource=tb.DefaultView;    
             oGrid.DataBind();  

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
