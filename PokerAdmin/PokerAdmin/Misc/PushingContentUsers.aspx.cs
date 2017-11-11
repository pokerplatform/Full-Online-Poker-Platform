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
using DataGridCustomColumns;

namespace Admin.Misc
{
	public class PushingContentUsers  : Page //MaintenancePage
	{
		protected DataGrid oGrid;
		protected Label lbStatus;
		protected DropDownList combo_0;
		protected System.Web.UI.WebControls.TextBox txtLoginName;

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
			DataTable tb = DBase.GetDataTable(Config.DbGetPushingContentUsersList,"@PushingContentID",ContentID); 
            oGrid.DataSource = tb.DefaultView;
		    oGrid.DataBind() ; 
      }

		protected  void btnDelete_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(Config.DbDeletePushingContentUsers);
			GridBind();
		}

		protected  void btnAdd_Click(object sender, EventArgs e)
		{
			int ret=DBase.ExecuteReturnInt(Config.DbSavePushingContentUsers,"@ID",-1,
                                   "@PushingContentID",ContentID,"@UserLoginname",txtLoginName.Text );
			if (ret==-1)
				lbStatus.Text ="User does not exists";
			else if (ret==-2)
				lbStatus.Text ="User already exists in this content";
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
