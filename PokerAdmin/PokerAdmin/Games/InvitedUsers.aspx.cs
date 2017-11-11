using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Admin.Components;
using Common;
using Common.WebControls;

namespace Admin.Games
{
	/// <summary>
	/// Summary description for InvitedUsers.
	/// </summary>
	public class InvitedUsers  : MaintenancePage
	{
		protected Label lbMessage;
		protected TextBox txtUserName;
		protected DataGrid oGrid;
	
        private int mProcessID;
		private int mIsTournament;

		protected override void Page_Load(object sender, EventArgs e)
		{

			lbMessage.EnableViewState =false;
			mProcessID=Utils.GetInt(Request["processID"]);
			mIsTournament=Utils.GetInt(Request["IsTournament"]);

			if ( oSGridPager != null )
			{
				oParentGrid = oSGridPager.GridObject;
			}
			BackPageUrl =	Session["InvitedUsersBackUrl"].ToString() ;   
			if ( oFilter != null )
			{
				oFilter.SqlProcedureName = sGridSourceQuery;
				oFilter.PrepareGridSource();
				if ( !IsPostBack ) 
					BindGrid();
			}
		}

		public InvitedUsers()
		{
			sDbDeleteQuery = Config.DbDeleteInvitedUsers;
			sGridSourceQuery = Config.DbGetInvitedUsersList;
		}

		private void oGrid_PreRender(object sender, EventArgs e)
		{
			if ( oFilter != null )
			{
				((Control)  ((FilterItem) oFilter.FilterItems[1]).GetControl(false)).Visible =false;
				((Control)  ((FilterItem) oFilter.FilterItems[2]).GetControl(false)).Visible =false;
			}
		}

		public void btnAddUser_Click(object sender, EventArgs e)
		{
              int ret=DBase.ExecuteReturnInt(Config.DbAddInvitedUser,"@processid",mProcessID,"@loginname",txtUserName.Text ,
													"@ISTournament",mIsTournament );  
			if (ret==-2)
			{
				lbMessage.Text ="User does not exists";
				return;
			}
			if (ret==-1)
			{
				lbMessage.Text ="User already exists";
				return;
			}
			BindGrid();
		}

		protected override void BindGrid()
		{
			if ( oFilter != null )
			{
				((FilterItem) oFilter.FilterItems[1]).Value=mProcessID;   
				((FilterItem) oFilter.FilterItems[2]).Value=mIsTournament ;   
			}
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
//			this.Load += new System.EventHandler(this.Page_Load);
			this.oGrid.PreRender += new EventHandler(this.oGrid_PreRender);
		}
		#endregion
	}
}
