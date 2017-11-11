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
using Common.WebControls;  
using DesktopAPIEngine; 
using DesktopBaseClasses; 

namespace Admin.Users
{
	/// <summary>
	/// Summary description for SubCategoryMaintenance.
	/// </summary>
	public class UsersMaintenance : Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.DataGrid oGrid;
		protected int intProcessID=-1;
		protected bool IsTournament=false;
		protected int m_Status=100;

		protected Controls.ButtonImage btnKickOff;
		protected System.Web.UI.WebControls.TextBox txtMessage;
		protected Controls.ButtonImage btnCancel;
	
		protected override void Page_Load(object sender, System.EventArgs e)
		{

			if(Request["ProcessIDForUsers"] != null)
			{
				try
				{
					intProcessID =int.Parse((string) Request["ProcessIDForUsers"]);
				}
				catch {intProcessID=-1;}
			}
			if(Request["IsTournament"] != null)
			{
				try
				{
					 IsTournament =(int.Parse((string) Request["IsTournament"])==1);
					m_Status=Utils.GetInt((string) Request["Status"]); 
					btnKickOff.Visible=(m_Status<=2);
				}
				catch
				 {IsTournament=false;}
			}

			if ( oSGridPager != null )
			{
				oParentGrid = oSGridPager.GridObject;
			}
			if ( oFilter != null )
			{
				if(intProcessID >0) 
				{
					sGridSourceQuery = IsTournament ? Config.DbGetUserListByTournament : Config.DbGetUserListByProcess;	
					btnAdd.Visible =false;
					btnDelete.Visible =false; 
				}

				oFilter.SqlProcedureName = sGridSourceQuery;
				oFilter.PrepareGridSource();
				if ( !IsPostBack )
				{
					BindGrid();
					Session["UserMaint_PKAdmin"]=oFilter.DataSource; 
				}
			}
			if (!IsPostBack)
			{
				Session["UsersMaintenanceUrl"]=Request.Url.AbsoluteUri;   
			}
		}

		public UsersMaintenance()
		{
			nEditPageNum = Config.PageUserDetails;

			sDbEnableQuery  = Config.DbEnableUser;
			sDbDisableQuery = Config.DbDisableUser;
			sDbDeleteQuery  = Config.DbDeleteUser;
	
			sGridSourceQuery = Config.DbGetUserList;

            arButtonImageEvents.Add(new Admin.Components.ButtonImageEventsData("btnChatEnable",Config.DbEnableChat)) ;
			arButtonImageEvents.Add(new Admin.Components.ButtonImageEventsData("btnChatDisable",Config.DbDisableChat )) ;

		}

		protected ArrayList FilterActiveUsers(DataTable tb, ArrayList al)
		{
			ArrayList all=new ArrayList();
            string sf;  
			foreach(DataRow dr in tb.Rows)
			{
				sf=dr["ID"].ToString();
				if (al.Contains(sf))
					all.Add(sf); 
			}
			return all;
		}

		protected ArrayList FilterActiveUsers(DataTable tb, DataTable tbs)
		{
			ArrayList all=new ArrayList();
			tb.Constraints.Add("CNSTR_ID",tb.Columns["ID"],true);   
			foreach(DataRow dr in tbs.Rows)
			{
				DataRow drr=tb.Rows.Find(dr["ID"]);
				if (drr !=null)
                 all.Add(dr["ID"].ToString());  
			}
			return all;
		}

		protected  void  btnSendMsg_Click(object sender, System.EventArgs e)
		{
			ArrayList al=GetCheckedValuesToArray(Config.MainCheckboxName);
			if (al == null || al.Count <=0) return;
			if(txtMessage.Text.Length <=0) return;
		/*		DataTable tb= DBase.GetDataTable("dskGetUserList", new object[] {"@StatusID",1});   
				if (tb==null) return;
				al=FilterActiveUsers(tb,al);
				if (al == null || al.Count <=0) return;*/
			SendUsersMessage(al);
		}

		protected  void  btnSetBot_Click(object sender, System.EventArgs e)
		{
			string sIDs = GetCheckedValues(Config.MainCheckboxName);
			if (sIDs == String.Empty) return; 
			DBase.Execute("admSetBot",new object[] {"@IDs",sIDs ,"@StatusID",1});
			 BindGrid();
		}

		protected  void  btnSetNotBot_Click(object sender, System.EventArgs e)
		{
			string sIDs = GetCheckedValues(Config.MainCheckboxName);
			if (sIDs == String.Empty) return; 
			DBase.Execute("admSetBot",new object[] {"@IDs",sIDs ,"@StatusID",0});
			BindGrid();
		}

		protected void SendUsersMessage(ArrayList al)
		{
			ApiControl  admC =Config.GetApIEngine() ;
			int l;
			string uids="";
			string msg =txtMessage.Text;
			for (l=0;l<al.Count;l++)
			{
				if (al[l].ToString().Length >0) uids+=al[l].ToString().Trim()+","  ;  
			}
			admC.SendMessageToUser(uids.TrimEnd(',') ,  msg );
			admC=null;
		}

		protected  void  btnSendMsgAll_Click(object sender, System.EventArgs e)
		{
			if(txtMessage.Text.Length <=0) return;
			string msg =txtMessage.Text;
			ApiControl  admC =Config.GetApIEngine() ;
            admC.SendMessageToAll(msg);
			string m=LogAdmin.LogFileName;
 		}

		protected override void bntGoBack_Click(object sender, System.EventArgs e)
		{
			if(intProcessID >0)
				Response.Redirect((string) Session["LastUrl"]);    
		}

		protected  void btnKickOff_Click(object sender, System.EventArgs e)
		{
			ApiControl  oTc =Config.GetApIEngine() ;
			try
			{
				string sIDs= GetCheckedValues(Config.MainCheckboxName);
				string [] s= sIDs.Split(new char [] {','});
				int l;
				for (l=0;l<s.Length ;l++)
				{
					if (s[l] != String.Empty) 
					{
						if (!IsTournament)
							oTc.KickOffUserFromProcess(int.Parse(s[l]),intProcessID ); 
						else
							oTc.KickOffUserFromTournament (int.Parse(s[l]),intProcessID); 
					}
				}
			}
			finally
			{
				oTc=null;
			}
		}

		protected override void AfterModifySetOfRecordsFromCombo(string sProcedureName,string sIDs, int typeAction)
		{
			ApiControl  oTc =Config.GetApIEngine() ;
			string [] ar = sIDs.Split(new char[] {','}); 
			int l;
			switch(typeAction)
			{
				case 0:
					if (sProcedureName == Config.DbEnableChat || sProcedureName == Config.DbDisableChat)
					{
						for(l=0;l<ar.Length ;l++)
						{
							if (ar[l] != String.Empty)
							{
								oTc.UpdateUserChatAllow( int.Parse(ar[l]), (sProcedureName == Config.DbEnableChat ? 1 : 0));
							}
						}
					}
					break;
				case 1:
				case 2:
					for(l=0;l<ar.Length ;l++)
					{
						if (ar[l] != String.Empty)
						{
							oTc.UpdateUserStatus( int.Parse(ar[l]),typeAction);
						}
					}
					break;
			}
			oTc=null;
		}

		protected override void BindGrid()
		{
			if ( oFilter != null  && intProcessID>0)
			{
					((FilterItem) oFilter.FilterItems[5]).Value=intProcessID.ToString() ;   
			}

			PrepareHyperLinkColumn(1, "ID", "id");
			PrepareHyperLinkColumn(2, "LoginName", "id");
			PrepareHyperLinkColumn(3, "email", "id");
			PrepareHyperLinkColumn(4, "Status", "id");
			PrepareHyperLinkColumn(5, "ChatAccess", "id");
			PrepareHyperLinkColumn(6, "LastLoginTime", "id");
			PrepareHyperLinkColumn(7, "TotalLoggedTime", "id");
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
			this.oGrid.PreRender += new System.EventHandler(this.oGrid_PreRender);

		}
		#endregion


		private void oGrid_PreRender(object sender, System.EventArgs e)
		{
			if (intProcessID <=0) 
			{
				btnKickOff.Visible =false; 
				btnCancel.Visible =false;
			}

			if ( oFilter != null)
			{
				if ( oFilter.FilterItems.Count ==6 )
				((Control)  ((FilterItem) oFilter.FilterItems[5]).GetControl(false)).Visible =false;
			}
		}

	}
}
