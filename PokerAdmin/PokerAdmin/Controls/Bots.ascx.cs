using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using Common;
using DesktopAPIEngine;
using DesktopBaseClasses;

namespace Admin.Controls
{
	/// <summary>
	///		Summary description for Bots.
	/// </summary>
	public class Bots : UserControl
	{
		protected DropDownList ddProcesses;
		protected CheckBox chAuto;
		protected Label lbState;
		protected DataGrid oGrid;
		protected System.Web.UI.WebControls.Label LbSection;
		protected Admin.Controls.ButtonImage btnSitdownAuto;
		protected System.Web.UI.WebControls.CheckBox Checkbox1;
		protected System.Web.UI.WebControls.DropDownList ddSitdownType_Auto;
		protected System.Web.UI.WebControls.DropDownList ddMaxNumber_Auto;
		protected System.Web.UI.WebControls.DropDownList ddSitdownType_Add;
		protected System.Web.UI.WebControls.DropDownList ddMaxNumber_Add;
		protected System.Web.UI.WebControls.DropDownList ddSitdownType_Policy;
		protected System.Web.UI.WebControls.TextBox txtMaxNumber; 
		protected Controls.ButtonImage btnStandUpwp;

        public enum enControlFor
        {
        	Process=0,
			Tournament=1,
			TournamentSitEndGo=2
	}

       private enControlFor mProcessType =enControlFor.Process;   
       
	   private void Page_Load(object sender, EventArgs e) {}

       protected string GetCheckBoxHtml(object oRow)
       {
		   Admin.Components.MaintenancePage pg= (Admin.Components.MaintenancePage) this.Page; 
           return pg.GetCheckBoxHtml(oRow);        	
       }

        protected void TargetReaction()
        {
		//	if (!IsPostBack)
		//	{

			ddMaxNumber_Add.Visible=(mProcessType==enControlFor.Process);
			txtMaxNumber.Visible= (mProcessType!=enControlFor.Process);
			btnStandUpwp.Visible  = (mProcessType==enControlFor.Process);

				oGrid.Columns[3].Visible =true; 
				Admin.Components.MaintenancePage pg= (Admin.Components.MaintenancePage) this.Page; 
				DataTable tb=null;
				switch (mProcessType)
				{
					case enControlFor.Process :
						tb = pg.DBase.GetDataTable(Config.DbGetGameProcessList); 
						oGrid.Columns[3].Visible =true;  
						oGrid.Columns[4].Visible =false;  
						oGrid.Columns[5].Visible =false;  
						break;
					case enControlFor.Tournament:
						tb = pg.DBase.GetDataTable(Config.DbGetTournamentList,"@CategoryTypeID",1); 
						oGrid.Columns[3].Visible =false; 
						btnSitdownAuto.Visible =false;
						chAuto.Visible =false;
						oGrid.Columns[3].Visible =false;  
						oGrid.Columns[4].Visible =true;  
						oGrid.Columns[5].Visible =true;  
						break;
					case enControlFor.TournamentSitEndGo:
						tb = pg.DBase.GetDataTable(Config.DbGetTournamentList,"@CategoryTypeID",2); 
						oGrid.Columns[3].Visible =false; 
						btnSitdownAuto.Visible =false;
						chAuto.Visible =false;
						oGrid.Columns[3].Visible =false;  
						oGrid.Columns[4].Visible =true;  
						oGrid.Columns[5].Visible =true;  
						break;
				}
						FillList(ddProcesses , tb.DefaultView ) ; 
		//	}
        }

		public bool CanBeVisible
		{
			get {return (ddProcesses.Items.Count >0 );}
			set{}
		}

        public enControlFor Target
        {
        	get{return mProcessType;}
			set
			{
				mProcessType=value;
				TargetReaction();
				LbSection.Text =GetTableHeader();
			}
        }


		protected string GetTableHeader()
		{
			switch(mProcessType)
			{
				case enControlFor.Process :
					return "Processes";
				case enControlFor.Tournament :
					return "Tournaments";
				case enControlFor.TournamentSitEndGo :
					return "Sit and Go";
				default:
					return "";
			}
		}

		protected void btnAddBots_Click(object sender, EventArgs e)
		{
			ApiControl ac=  Config.GetApIEngine(); 
			int mxNumber= txtMaxNumber.Visible ? Utils.GetInt(txtMaxNumber.Text) : Utils.GetInt(ddMaxNumber_Add.SelectedValue );
			ac.AddBots(Utils.GetInt( ddProcesses.SelectedValue),Utils.GetInt(ddSitdownType_Add.SelectedValue ),	mxNumber, ApiTarget );
		}

		protected void btnStandUp_Click(object sender, EventArgs e)
		{
			string IDs=this.GetCheckedValues(Common.Config.MainCheckboxName); 
			if (IDs==String.Empty) return; 
			ApiControl ac=  Config.GetApIEngine(); 
			ac.StandupBots(IDs,Utils.GetInt(ddProcesses.SelectedValue ), ApiTarget ); 
		}

		protected void btnStandUpAll_Click(object sender, EventArgs e)
		{
			ApiControl ac=  Config.GetApIEngine(); 
			ac.StandupAllBots(Utils.GetInt( ddProcesses.SelectedValue), ApiTarget) ;
		}

		protected void btnStandUpwp_Click(object sender, EventArgs e)
		{
			ApiControl ac=  Config.GetApIEngine(); 
			ac.StandupAllBotsWP(ApiTarget) ;
		}

		protected void btnSetupPolicy_Click(object sender, EventArgs e)
		{
			string IDs=this.GetCheckedValues(Common.Config.MainCheckboxName); 
			if (IDs==String.Empty) return; 
			ApiControl ac=  Config.GetApIEngine(); 
			ac.SetupBotsPolicy(IDs,Utils.GetInt( ddSitdownType_Policy.SelectedValue),Utils.GetInt(ddProcesses.SelectedValue ), ApiTarget ); 
		}

		protected void btnSitdownAuto_Click(object sender, EventArgs e)
		{
			ApiControl ac=  Config.GetApIEngine(); 
			ac.BotsSitdownAuto(chAuto.Checked, Utils.GetInt( ddSitdownType_Auto.SelectedValue),Utils.GetInt(ddMaxNumber_Auto.SelectedValue ), ApiTarget ) ;
		}

        protected  ApiMsg.enProcessFormTarget ApiTarget
        {
        	get
        	{
				switch(mProcessType)
				{
					case enControlFor.Process :
						return ApiMsg.enProcessFormTarget.Process;
					case enControlFor.Tournament :
						return ApiMsg.enProcessFormTarget.Tournament ;
					case enControlFor.TournamentSitEndGo :
						return ApiMsg.enProcessFormTarget.Tournament;
					default:
						return ApiMsg.enProcessFormTarget.Process;
				}
        	}
        }


		protected void btnGetInfo_Click(object sender, EventArgs e)
		{
			Session[GetTableHeader()+"DataSource"]=null;
			BindData();
		}

		public string GetCheckedValues(string sInputName)
		{
			String sAllParams = "" + Request[sInputName];
			String sIDs = "";
			if ( sAllParams != "" )
			{
				foreach(string sVal in sAllParams.Split(','))
				{
					if ( sIDs != "" )
						sIDs += "," + sVal ;
					else
						sIDs =  sVal ;
				}
			}
			return sIDs;
		}

		private  void FillList(ListControl oList, DataView oData)
		{
			int sIdx=oList.SelectedIndex; 
			oList.Items.Clear();
			if ( oData != null )
			{
				string sTextFld =  "";
				if ( mProcessType==enControlFor.Process)  
					sTextFld =  "ProcessName";
				else
					sTextFld =  "TournamentName";

				string sValueFld = "id";

				oList.Items.Clear();
				foreach(DataRowView oDR in oData)
				{
					oList.Items.Add(new ListItem(oDR[sTextFld].ToString(), oDR[sValueFld].ToString()));
				}
				if (sIdx >=0 && oList.Items.Count -1 >= sIdx ) oList.SelectedIndex =sIdx; 
			}
		}

		private void BindData()
		{
			oGrid.DataSource=null;
			if (Session[GetTableHeader()+"DataSource"]==null)
			{
				CreateDataSource();
			}
			if ( Session[GetTableHeader()+"DataSource"] !=null)
			{
				DataTable tb= (DataTable) Session[GetTableHeader()+"DataSource"];
				oGrid.DataSource =tb.DefaultView; 
				oGrid.DataBind();
			}
		}

		private void CreateDataSource()
		{
			ApiControl ac=  Config.GetApIEngine(); 
			string rez=ac.GetBotsInfo(Utils.GetInt( ddProcesses.SelectedValue), ApiTarget); 
			if (rez == String.Empty) return;
			GetInfoasDS(rez); 
			return ;
		}

		private void GetInfoasDS(string rez)
		{
			try
			{
				XMLDoc  xd=new XMLDoc(rez,false) ;
				XmlNodeList nl= xd.GetNodeListByPathOnly("bot_gettableinfo") ;
				if (nl==null || nl.Count ==0)
				{
					lbState.Text ="Error in XML string";
					return;
				}
				string result= xd.GetAttributeInnerText(nl[0],"result"); 
				if (result != "0")
				{
					lbState.Text ="Error response";
					return;
				}
				nl=xd.GetNodeListByPathOnly("bot_gettableinfo/"+(mProcessType==enControlFor.Process ?"chair":"bot")) ;
				DataTable tb=GetTable();
				foreach(XmlNode nd in nl)
				{
					string chair="0";
					string id ="0";
					string type ="0";
					string processid ="0";
					if (mProcessType==enControlFor.Process)
					{
						string stateid = xd.GetAttributeInnerText(nd, "stateid"); 
						if (stateid == "2")
						{
							id= xd.GetAttributeInnerText(nd,"id"); 
							if ( mProcessType==enControlFor.Process )  
							{
								chair = xd.GetAttributeInnerText(nd,"position"); 
							}
						}
						else
							continue;
					}
					else
					{
						id= xd.GetAttributeInnerText(nd,"id"); 
						type= xd.GetAttributeInnerText(nd,"type"); 
						processid= xd.GetAttributeInnerText(nd,"processid"); 
					}
						string loginname= xd.GetAttributeInnerText(nd,"loginname"); 
						DataRow dr = tb.NewRow();
						dr["id"]=Utils.GetInt(id);
						dr["loginname"]=loginname;
						if (mProcessType==enControlFor.Process)
							dr["chairid"]=Utils.GetInt(chair);
						else
						{
							dr["Type"]=Utils.GetInt(type);
							dr["ProcessID"]=Utils.GetInt(processid);
						}
						tb.Rows.Add(dr);  
				}
				Session[GetTableHeader()+"DataSource"]=tb;
			}
			catch (Exception ex)
			{
				Log.Write(ex);  
				lbState.Text ="Error get info";
			}
		}


		private DataTable GetTable()
		{
			DataTable tb = new DataTable() ;
				tb.Columns.Add("id",Type.GetType("System.Int32"));
				tb.Columns.Add("Chairid",Type.GetType("System.Int32"));
				tb.Columns.Add("LoginName",Type.GetType("System.String"));
				tb.Columns.Add("Type",Type.GetType("System.Int32"));
				tb.Columns.Add("ProcessID",Type.GetType("System.Int32"));
			return tb; 
		}

		private void oGrid_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			BindData();
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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.oGrid.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.oGrid_PageIndexChanged);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
