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

namespace Admin.Event
{
	/// <summary>
	/// Summary description for EventMaintenance.
	/// </summary>
	public class EventMaintenance : Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.DataGrid oGrid;
	
		protected override  void Page_Load(object sender, System.EventArgs e)
		{
			if ( oGridPager != null )
			{
				oParentGrid = oGridPager.GridObject;
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
				Session["EventMaintenanceUrl"]=Request.Url.AbsoluteUri;   
			}
		}

		public EventMaintenance()
		{
			nEditPageNum = Config.PageEventDetails;

			sDbDeleteQuery = Config.DbDeleteEvent;
	
			sGridSourceQuery = Config.DbGetEventList;
		}
		protected override void BindGrid()
		{
			PrepareHyperLinkColumn(1, "Name", "id");
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
