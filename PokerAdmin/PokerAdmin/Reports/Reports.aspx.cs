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
using Common.Web ; 
using System.Text; 
using System.Data.SqlClient;  

namespace Admin.Reports
{
	public class Reports : Common.Web.Page 
	{
		protected System.Web.UI.WebControls.Label Label1;
		protected System.Web.UI.HtmlControls.HtmlInputText txdtFrom;
		protected System.Web.UI.WebControls.Label Label2;
		protected System.Web.UI.HtmlControls.HtmlInputText txdtTo;
		protected System.Web.UI.HtmlControls.HtmlInputCheckBox chMoney;
		protected System.Web.UI.HtmlControls.HtmlInputCheckBox chPlayMoney;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnCurrDate;
		protected System.Web.UI.HtmlControls.HtmlInputText txPID;
		protected System.Web.UI.HtmlControls.HtmlInputText txLoginName;
		protected System.Web.UI.WebControls.Label lbResult;
		protected System.Web.UI.HtmlControls.HtmlInputText txDiscretCount;
		protected System.Web.UI.HtmlControls.HtmlSelect slIntrType;
		protected System.Web.UI.HtmlControls.HtmlInputCheckBox chnoBots;
		protected System.Web.UI.HtmlControls.HtmlInputText txtMACAddress;
		protected System.Web.UI.WebControls.Panel pn;
		protected System.Web.UI.HtmlControls.HtmlInputCheckBox chValueAsList;
		protected System.Web.UI.HtmlControls.HtmlInputButton selBtFrom;
		protected System.Web.UI.HtmlControls.HtmlInputButton selBtTo;
		protected System.Web.UI.HtmlControls.HtmlSelect ddReport;

		private void Page_Load(object sender, System.EventArgs e)
		{

			if(this.IsStartupScriptRegistered("clientScript"))
				this.RegisterStartupScript("clientScript", "");

			if(!IsPostBack)
			{
				ddReport.Items.Add(new ListItem("[Select Report]","0"));     
				ddReport.Items.Add(new ListItem("Unique Players","1"));     
				ddReport.Items.Add(new ListItem("Number of hands played","2"));     
				ddReport.Items.Add(new ListItem("Number of concurrent players","3"));
				/*ddReport.Items.Add(new ListItem("Minimum # of concurrent players","4"));*/
				ddReport.Items.Add(new ListItem("Biggest Chip Hand","5")); 
				ddReport.Items.Add(new ListItem("Number of players who played a game","6")); 
				ddReport.Items.Add(new ListItem("Average # of hands played","7")); 
				ddReport.Items.Add(new ListItem("Average time spent on system","8")); 
				ddReport.Items.Add(new ListItem("Full Transaction History for Player","9"));     
				//ddReport.Items.Add(new ListItem("Most active players","10")); 
				ddReport.Items.Add(new ListItem("Most wins for any individual player","11")); 
				ddReport.Items.Add(new ListItem("Most active Players","12")); 
				ddReport.Items.Add(new ListItem("Players that never played a game","13")); 
				ddReport.Items.Add(new ListItem("Most Popular Games","14")); 
				ddReport.Items.Add(new ListItem("Least Popular Games","15")); 
				ddReport.Items.Add(new ListItem("Client Session History with LoginNames","16")); 
				ddReport.Items.Add(new ListItem("Current Balance","17")); 
				ddReport.Items.Add(new ListItem("Last Login Time","18")); 
				ddReport.Items.Add(new ListItem("Number PIDs on Machines","19")); 
				ddReport.Items.Add(new ListItem("Specific Machine History","20")); 
				ddReport.Items.Add(new ListItem("Collusion Hands Played","21")); 
				ddReport.Items.Add(new ListItem("Player Game History","22")); 
				ddReport.Items.Add(new ListItem("Daily Ranks Individual","23")); 

				slIntrType.Items.Add(new ListItem("Minute","1")) ; 
				slIntrType.Items.Add(new ListItem("Hour","2")) ; 
				slIntrType.Items.Add(new ListItem("Day","3")) ; 
				slIntrType.Items.Add(new ListItem("Month","4")) ; 

				slIntrType.SelectedIndex =1; 

		//		    txdtFrom.Disabled =true;   
				    txdtFrom.Value = DateTime.Now.ToString("d");
				    txdtTo.Value =  txdtFrom.Value;
					selBtTo.Disabled =false; 
					selBtFrom.Disabled =false; 
				    chnoBots.Checked =true;
					txdtTo.Disabled =true;   
				    chMoney.Disabled=true;
				    chPlayMoney.Disabled=true;
					txPID.Disabled =true;
				    txLoginName.Disabled =true;
				    txtMACAddress.Disabled =true;
			}
    	}
		public string GetCssPageUrl()
		{
			return Config.CommonCssPath;
		}
		protected void btnCreateReport_Click(object sender, System.EventArgs e)
		{
			try
			{
				if(ddReport.Value=="0")
				{
					Reports_PreRender(null,null);
					return;
				}
				ItemSelected();
				Session["RepDs_"+ddReport.Value]=null;
				Session["CrystalRepPrm_"+ddReport.Value]=null;

				int ret =OnLineReport(Utils.GetInt(ddReport.Value)) ;
				if(ret>=0) return;

				ArrayList ar=new ArrayList();
				ar.Add(new String[] {"valueaslist",chValueAsList.Checked.ToString() });
				if (txdtFrom.Disabled  ==false)
				{
					ar.Add(new String[] {"db",txdtFrom.Value.Trim()});
					ar.Add(new String[] {"de",txdtTo.Value.Trim()});
				}
				if (chMoney.Disabled  ==false)
				{
					ar.Add(new String[] {"chm",chMoney.Checked.ToString()});
					ar.Add(new String[] {"chn_m",chPlayMoney.Checked.ToString()});
				}
				if (txPID.Disabled ==false)
				{
					if (chValueAsList.Checked ==false)
					{
						int uID=Utils.GetInt(txPID.Value);
						if (uID==0 && txLoginName.Value != String.Empty)
						{
							uID=DBase.ExecuteReturnInt("wntGetUserID",new object[]{"@LoginName",txLoginName.Value} );
						}
						ar.Add(new String[] {"uid",uID.ToString()});
					}
					else
					{
						ar.Add(new String[] {"uid",txPID.Value });
						ar.Add(new String[] {"loginname",CheckStringPrm(  txLoginName.Value)});
					}
				}
				if (txtMACAddress.Disabled ==false)
						ar.Add(new String[] {"macaddress",CheckStringPrm(txtMACAddress.Value)});
				         ar.Add(new String[] {"nobots",(chnoBots.Checked?"1":"0")});

				Session["CrystalRepPrm_"+ddReport.Value]=ar;

				String scriptString = "<script language=JavaScript>";
				scriptString += " window.open('"+Config.SiteBaseUrl +"Reports/ViewForm.aspx?RepID="+ddReport.Value+"');ItemSelected();</script>";

				if(!this.IsStartupScriptRegistered("clientScript"))
					this.RegisterStartupScript("clientScript", scriptString);
			}
			catch (Exception ex)
			{
				Log.Write(this,ex); 
			}
		}

		private string CheckStringPrm(string stprm)
		{
			string[] spl =stprm.Split(',');
			string bf="";
			foreach(string st in spl)
			{
				if (st.Trim().Length >0)
				{
					bf+="'"+st.Trim()+"'"+",";
				}
			}
			return bf.TrimEnd(',');
		}

		private int OnLineReport(int mID)
		{
			int ret=-1;
			DateTime m_dtb=DateTime.Now ;
			DateTime m_dte=DateTime.Now;
			DataSet ds;
			lbResult.Text ="";
			int uID=0;
			string dtPref="From "+txdtFrom.Value+" to " +txdtTo.Value;

			try
			{
				if (txdtFrom.Disabled ==false)
				{
					m_dtb=DateTime.Parse(txdtFrom.Value.Trim());
					m_dte=DateTime.Parse(txdtTo.Value.Trim());
				}
				if (txPID.Disabled ==false)	
				{
					uID =Utils.GetInt(txPID.Value);
					if (uID==0 && txLoginName.Value != String.Empty)
					{
						uID=DBase.ExecuteReturnInt("wntGetUserID",new object[]{"@LoginName",txLoginName.Value} );
					}
				}
			}
			catch (Exception ex)
			{
				Log.Write(this,ex); 
				return 1;
			}

			ReportDoc rdc=new ReportDoc(Config.DbConnectionString,600,DBase);

			switch(mID)
			{
				case 3:
					 int Intr =Utils.GetInt(txDiscretCount.Value);
					 if (Intr <=0) return 2;
					 int iType= Utils.GetInt(slIntrType.Value);
					ds= rdc.CreateReportSource("wntConcurrentPlayers","ConcurrentPlayers",new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,
																				"@Interval",Intr,"@IntervalType"	,iType,"@NoBots",chnoBots.Checked?1:0}); 
					if (ds.Tables[0].Rows.Count >0)
						lbResult.Text  = dtPref+"<br>Maximum concurrent players: "+
							ds.Tables[0].Rows[0]["Maximum"].ToString()+ "<br>Minimum concurrent players: "  +ds.Tables[0].Rows[0]["Minimum"].ToString();
					else
						lbResult.Text  = dtPref+" No data";
					ret=0;
  					break;
				case 5:
						ds= rdc.CreateReportSource("wntBiggestHand","BiggestHand",new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@NoBots",chnoBots.Checked?1:0 }); 
					if (ds.Tables[0].Rows.Count >0)
						lbResult.Text  = dtPref+"<br>Biggest Chip Hand ID: "+
							ds.Tables[0].Rows[0]["HandID"].ToString()+ "<br>Amount: "  +ds.Tables[0].Rows[0]["Amount"].ToString();
					else
						lbResult.Text  = dtPref+" Biggest Chip Hand ID: 0  , Amount: 0";
					ret=0;
					break;
				case 6:
					ds= rdc.CreateReportSource("wntUsersSignupAndPlay","UsersSignupAndPlay",new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@NoBots",chnoBots.Checked?1:0 }); 
					if (ds.Tables[0].Rows.Count >0)
						lbResult.Text  = dtPref+"<br>Players registered: "+
							ds.Tables[0].Rows[0]["Registered"].ToString()+ "<br>Played a game: "  +ds.Tables[0].Rows[0]["Played"].ToString();
					else
						lbResult.Text  = dtPref+" Registered: 0  , Played a game: 0";
					ret=0;
					break;
				case 8:
					ds= rdc.CreateReportSource("wntTimeSpendByUser","TimeSpendByUser",
						new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@UserID",uID,"@NoBots",chnoBots.Checked?1:0}); 
					if (ds.Tables[0].Rows.Count >0)
						lbResult.Text  = dtPref+"<br>Average Time Spent on the System is "+ds.Tables[0].Rows[0]["SpentTime"].ToString()+ " minutes per user ";
					else
						lbResult.Text  = dtPref+"<br>Average Time Spent on the System is 0";
					ret=0;
					break;

			}

			return ret;
		}

		private void  ItemSelected()
		{
			txdtFrom.Disabled =false; 
			txdtTo.Disabled =false; 
			chMoney.Disabled =false;
			chPlayMoney.Disabled =false;
			txPID.Disabled =true;
			txLoginName.Disabled =true;
			txDiscretCount.Disabled=true;
			slIntrType.Disabled =true;
			txtMACAddress.Disabled =true;
			chValueAsList.Checked =false; 
            
			switch(ddReport.Value)
			{
				case "0":
					txdtFrom.Disabled =false; 
					txdtTo.Disabled =false; 
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					break;
				case "3":
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					txDiscretCount.Disabled=false;
					slIntrType.Disabled =false;
					break;
				case "1":
				case "5":
				case "6":
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					break;
                case "2": 
				case "11": 
					txPID.Disabled =false;
					txLoginName.Disabled =false;
					break;
				case "7":	   
				case "8":	   
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					txPID.Disabled =false;
					txLoginName.Disabled =false;
					break;
				case "9":	   
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					txPID.Disabled =false;
					txLoginName.Disabled =false;
					break;
				case "10":	   
				case "13":	   
				case "14":	   
				case "15":	   
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					break;
				case "16":
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					txLoginName.Disabled =false;
					txPID.Disabled =false;
					chValueAsList.Checked =true; 
					break;
				case "17":
				case "18":
					txLoginName.Disabled =false;
					txPID.Disabled =false;
					txdtFrom.Disabled =true; 
					txdtTo.Disabled =true; 
					selBtTo.Disabled =true; 
					selBtFrom.Disabled =true; 
					chValueAsList.Checked =true; 
					break;
				case "19":
				case "20":
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					txtMACAddress.Disabled =false;
					chValueAsList.Checked =true; 
					break;
				case "21":
                case "22":
					chMoney.Disabled =true;
					chPlayMoney.Disabled =true;
					txtMACAddress.Disabled =true;
					chValueAsList.Checked =true; 
					break;
				case "23":
					chValueAsList.Checked =true; 
					break;
			}
		}


		private void Reports_PreRender(object sender, System.EventArgs e)
		{
/*			if(this.IsStartupScriptRegistered("clientScript"))
				this.RegisterStartupScript("clientScript", "");*/
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
			this.PreRender += new System.EventHandler(this.Reports_PreRender);

		}
		#endregion

	}
}
