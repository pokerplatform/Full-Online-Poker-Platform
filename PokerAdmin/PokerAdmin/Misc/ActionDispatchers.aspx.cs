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
using Common ; 
using Common.Web;

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for BonusRules.
	/// </summary>
	public class ActionDispatchers : Common.Web.Page
	{
		protected System.Web.UI.WebControls.DataGrid oGrid;
		protected System.Web.UI.WebControls.Label lblError;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			if(!IsPostBack)
			{
				DoBindData();
			}
		}

		private void DoBindData()
		{
			DataTable oDT = DBase.GetDataTable(Config.DbGetActionDispatchersList);
			oGrid.DataSource =oDT.DefaultView;
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
			this.oGrid.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.oGrid_PageIndexChanged);
			this.oGrid.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_CancelCommand);
			this.oGrid.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_EditCommand);
			this.oGrid.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_UpdateCommand);
			this.oGrid.DeleteCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_DeleteCommand);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		protected void btnAdd_Click(object sender, System.EventArgs e)
		{
			int ID=DBase.ExecuteReturnInt(Config.DbSaveActionDispatcher,"@ID",0,"@IP","0.0.0.0","@Port",0);
			DoBindData();
		}

		private void oGrid_DeleteCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			int ID = Utils.GetInt(e.Item.Cells[0].Text );  
			DBase.Execute(Config.DbDeleteActionDispatcher ,"@ID",ID);
			DoBindData();
		}

		private void oGrid_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			int ID = Utils.GetInt(e.Item.Cells[0].Text );  
			ID=DBase.ExecuteReturnInt(Config.DbSaveActionDispatcher,"@ID",ID,"@IP",((TextBox)e.Item.Cells[1].Controls[0]).Text,"@Port",
				                 Utils.GetInt(((TextBox)e.Item.Cells[2].Controls[0]).Text ));
			oGrid.EditItemIndex = -1;
			DoBindData();
		}

		private void oGrid_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			DoBindData();
		}

		private void oGrid_EditCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			oGrid.EditItemIndex = e.Item.ItemIndex;
			DoBindData();
		}

		private void oGrid_CancelCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			oGrid.EditItemIndex = -1;
			DoBindData();
		}

	}
}
