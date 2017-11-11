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

namespace Admin.Affiliate
{
	/// <summary>
	/// Summary description for GameProcessMaintenance.
	/// </summary>
	public class AffiliateMaintenance : Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.DataGrid oGrid;
	
		protected override  void Page_Load(object sender, System.EventArgs e)
		{
			/*if ( oGridPager != null )
			{
				oParentGrid = oGridPager.GridObject;
			}*/
			if ( oSGridPager != null )
			{
				oParentGrid = oSGridPager.GridObject;
			}
			if ( oFilter != null )
			{
				oFilter.SqlProcedureName = sGridSourceQuery;
				oFilter.PrepareGridSource();
				if ( !IsPostBack )
				{
					BindGrid();
				}
			}
			if (!IsPostBack)
			{
				Session["AffiliateMaintenanceUrl"]=Request.Url.AbsoluteUri;   
			}
		}



		public AffiliateMaintenance()
		{
			nEditPageNum     = Config.PageAffiliateDetails;
			sDbDeleteQuery   = Config.DbDeleteAffiliate;
			sGridSourceQuery = Config.DbGetAffiliateList;
		}
		protected override void BindGrid()
		{
			PrepareHyperLinkColumn(1, "Name", "id");
			PrepareHyperLinkColumn(2, "Status", "id");
			PrepareHyperLinkColumn(3, "Skin", "id");
			base.BindGrid();
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

		}
		#endregion
	}
}
