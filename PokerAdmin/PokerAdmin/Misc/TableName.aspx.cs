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

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for TableName.
	/// </summary>
	public class TableName  : Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.DataGrid oGrid;
		protected System.Web.UI.WebControls.TextBox txtName;
	
		protected override void  Page_Load(object sender, System.EventArgs e)
		{
			if (!IsPostBack)
			{
				Data_Bind();
			}
		}

		private void Data_Bind()
		{
			 DataTable tb=DBase.GetDataTable(Config.DbGetExoticNameList);
			 oGrid.DataSource =tb.DefaultView;
			 oGrid.DataBind();  
		}

		public void btnAddTableName_Click(object sender, System.EventArgs e)
		{
			 if (txtName.Text ==String.Empty) return;
			 DBase.Execute(Config.DbSaveExoticName,"@Name",txtName.Text);
			Data_Bind();
		}

		public void btnDeleteTableName_Click(object sender, System.EventArgs e)
		{
			string sIDs= GetCheckedValues(Config.MainCheckboxName);
			DBase.Execute(Config.DbDeleteExoticName,"@IDs",sIDs);  
			Data_Bind();
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
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void oGrid_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			Data_Bind();
		}
	}
}
