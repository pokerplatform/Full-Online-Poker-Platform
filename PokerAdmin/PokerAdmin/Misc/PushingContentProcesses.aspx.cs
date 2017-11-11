using System;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web; 
using Admin.Components;
using Admin.Controls;
using Common;
using Common.Web;
using System.Globalization; 
using System.Collections; 
using DataGridCustomColumns;

namespace Admin.Misc
{
	public class PushingContentProcesses  : Page //MaintenancePage
	{
		protected Label lbStatus;
		protected DropDownList combo_0;
		protected System.Web.UI.WebControls.DataGrid oGrid;
		protected System.Web.UI.WebControls.DataGrid oGridForAdd;

		private int  ContentID=-1;

		protected void Page_Load(object sender, EventArgs e)
		{
            if (Request["ContentID"] !=null)
				ContentID= Utils.GetInt(Request["ContentID"]); 
			if (!IsPostBack)
			{
				GridBind();
			}
		}

		private void GridBind()
		{
			DataTable tb = DBase.GetDataTable(Config.DbGetPushingContentProcessesList ,"@PushingContentID",ContentID); 
            oGrid.DataSource = tb.DefaultView;
		    oGrid.DataBind() ; 
			 tb = DBase.GetDataTable(Config.DbGetProcessesForPushigContent ,"@PushingContentID",ContentID); 
			oGridForAdd.DataSource = tb.DefaultView;
			oGridForAdd.DataBind() ;  
		}

		protected  void btnDelete_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(Config.DbDeletePushingContentProcesses);
			GridBind();
		}

		protected  void btnAdd_Click(object sender, EventArgs e)
		{
			ArrayList lIDs = GetCheckedValuesToArray(Config.MainCheckboxName);
			foreach (string s in lIDs)
			{
				DBase.ExecuteReturnInt(Config.DbSavePushingContentProcesses,"@id",-1,"@PushingContentID",ContentID,
					"@ProcessID",Utils.GetInt(s)); 
			}
			GridBind();
		}

		protected  void btnBack_Click(object sender, EventArgs e)
		{
			Response.Redirect(Session["PushingContent_BackURL"].ToString() ); 
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
