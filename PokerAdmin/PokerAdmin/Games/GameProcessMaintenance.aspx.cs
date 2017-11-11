using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Admin.Components;
using Admin.Controls;
using Common.Web;
using Common.WebControls;

namespace Admin.Games
{
	/// <summary>
	/// Summary description for GameProcessMaintenance.
	/// </summary>
	public class GameProcessMaintenance : MaintenancePage
	{
		protected DataGrid oGrid;
		protected bool isMini=false;
	
		protected override void Page_Load(object sender, EventArgs e)
		{

			if(Request["mini"]!=null && Request["mini"].ToString() =="1") isMini=true;
			if ( oSGridPager != null )
			{
				oParentGrid = oSGridPager.GridObject;
			}
			if ( oFilter != null )
			{
				oFilter.SqlProcedureName = sGridSourceQuery;
				oFilter.PrepareGridSource();
				if ( !IsPostBack ) BindGrid();
			}
			if ( !IsPostBack )
			{
				Session["GameProcessMaintenanceUrl"]=Request.Url.AbsoluteUri;   
				Session["LastUrl"]=Request.Url.AbsoluteUri;   
			}
		}

		public GameProcessMaintenance()
		{
			nEditPageNum = Config.PageGameProcessDetails;
			sDbDeleteQuery = Config.DbDeleteGameProcess;
			sGridSourceQuery = Config.DbGetGameProcessList;
		}

		protected override void btnAdd_Click(object sender, EventArgs e)
		{
			if ( nEditPageNum > 0 )
			{
				Redirect(nEditPageNum,(isMini ? "?mini=1":"?mini=0"));
			}
		}

		protected override void BindGrid()
		{
			if ( oFilter != null )
			{
				if(!isMini)
					((FilterItem) oFilter.FilterItems[4]).Value=Config.Mini_TourneyID;   
				else
					((FilterItem) oFilter.FilterItems[4]).Value=Config.NonMini_TourneyIDs;   
			}
			PrepareHyperLinkColumnWithQueryString(1, "ProcessName", "id");
			PrepareHyperLinkColumnWithQueryString(2, "SubCategoryName", "id");
			PrepareHyperLinkColumnWithQueryString(3, "CurrencyName", "id");
			PrepareHyperLinkColumnWithQueryString(4, "ActiveUsers", "id");
			PrepareHyperLinkColumnWithQueryString(5, "PassiveUsers", "id");
			base.BindGrid();
			DropDownList o =(DropDownList) ((FilterItem) oFilter.FilterItems[2]).InnerControl;
			if (!isMini)
				Core.RemoveItemByValue(o, (object) Config.Mini_TourneyID);
			else
				Core.RemoveItemByValue(o, Config.NonMini_TourneyIDs);
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
			this.oGrid.PreRender += new EventHandler(this.oGrid_PreRender);
			this.oGrid.ItemDataBound += new DataGridItemEventHandler(this.oGrid_ItemDataBound);

		}
		#endregion

		private void oGrid_PreRender(object sender, EventArgs e)
		{
			if ( oFilter != null )
			{
				((Control)  ((FilterItem) oFilter.FilterItems[4]).GetControl(false)).Visible =false;
			}
		}

		private void oGrid_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			if (e.Item.Cells[6].Controls.Count >0)
			{
				ButtonImage ct=( (ButtonImage) e.Item.Cells[6].Controls[1]);
				ct.NavigateUrl ="..\\Users\\UsersMaintenance.aspx?ProcessIDForUsers=" +((DataRowView)  e.Item.DataItem)[0].ToString();
			}
		} 

	}
}
