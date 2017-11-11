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

namespace Admin.Support
{
	/// <summary>
	/// Summary description for GameProcessMaintenance.
	/// </summary>
	public class SupportMaintenance : Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.DataGrid oGrid;
	
		protected override  void Page_Load(object sender, System.EventArgs e)
		{
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
				Session["SupportMaintenanceUrl"]=Request.Url.AbsoluteUri;   
			}
		}

		public SupportMaintenance()
		{
			nEditPageNum     = Config.PageSupportDetails;
			sGridSourceQuery = Config.DbGetSupportList;
			sDbDeleteQuery   = Config.DbDeleteSupport;
		}
		protected override void BindGrid()
		{
			PrepareHyperLinkColumn(1, "Date", "id");
			PrepareHyperLinkColumn(2, "UserName", "id");
			PrepareHyperLinkColumn(3, "Subject", "id");
			PrepareHyperLinkColumn(4, "Body", "id");
			PrepareHyperLinkColumn(5, "SupportUserType", "id");
			PrepareHyperLinkColumn(6, "SupportUserName", "id");
			PrepareHyperLinkColumn(7, "SupportStatusName", "id");
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
