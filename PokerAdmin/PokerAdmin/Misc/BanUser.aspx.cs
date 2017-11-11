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
	/// Summary description for BanUser.
	/// </summary>
	public class BanUser : Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.TextBox txtUID;
		protected System.Web.UI.WebControls.TextBox txtIP;
		protected System.Web.UI.WebControls.TextBox txtHost;
		protected System.Web.UI.WebControls.DataGrid oGrid;
	
		protected override void Page_Load(object sender, System.EventArgs e)
		{
			if (!IsPostBack)
			{
				Data_Bind();
			}
		}

		private void Data_Bind()
		{
			DataTable tb=DBase.GetDataTable(Config.DbGetBanList);
			oGrid.DataSource =tb.DefaultView;
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
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void oGrid_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			Data_Bind();
		}

		public void  btnDeleteBan_Click(object sender, System.EventArgs e)
		{
			string sIDs= GetCheckedValues(Config.MainCheckboxName);
			DBase.Execute(Config.DbDeleteBan,"@IDs",sIDs);  
			Data_Bind();
		}
		public void  btnAddBan_Click(object sender, System.EventArgs e)
		{
			if (Common.Utils.GetInt(txtUID.Text)==0 && txtIP.Text==String.Empty && txtHost.Text ==String.Empty) return; 
			DBase.Execute(Config.DbSaveBan,"@UserID",Common.Utils.GetInt(txtUID.Text),"@IP",txtIP.Text,"@Host",txtHost.Text );
    		Data_Bind();
		}


	}
}
