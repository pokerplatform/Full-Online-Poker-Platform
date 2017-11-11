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
using CrystalDecisions.CrystalReports.Engine;   
using CrystalDecisions.Shared;

using Common;
using Common.Web ; 

namespace Admin.Reports
{
	/// <summary>
	/// Summary description for ViewForm.
	/// </summary>
	public class ViewForm :  Common.Web.Page 
	{
		protected CrystalDecisions.Web.CrystalReportViewer CrView;
		private int m_rptID;
		private DateTime m_dtb;
		private DateTime m_dte;
		private bool m_chM;
		private bool m_chNM;
		private int  m_uid=0;
		private string  m_struid="";
		private string  m_strloginname="";
		private string  m_strmacaddress="";
		private int m_noBots=0;
		private DataSet ds=null;

		private void Page_Load(object sender, System.EventArgs e)
		{
			try
			{
				m_rptID=int.Parse(Request["RepID"]);
				ArrayList ar =(ArrayList)Session["CrystalRepPrm_"+m_rptID.ToString()];
				if (ar == null || ar.Count ==0) return;
				bool prmaslist =Utils.GetBool(((String[]) ar[0])[1]);
				foreach( String[] _str in ar)
				{
					switch (_str[0])
					{
						case "db":
							m_dtb=DateTime.Parse(_str[1]);
							break;
						case "de":
							m_dte=DateTime.Parse(_str[1]);
							break;
						case "chm":
							m_chM=bool.Parse(_str[1]) ;
							break;
						case "chn_m":
							m_chNM=bool.Parse(_str[1]) ;
                            break;
						case "uid":
							if (!prmaslist)
							{
								m_uid=int.Parse(_str[1]); 
								m_struid =_str[1];
							}
							else
								m_struid =_str[1];
							break;
						case "loginname":
							m_strloginname=_str[1];
							break;
						case "macaddress":
							m_strmacaddress=_str[1];
                           break;
						case "nobots":
							m_noBots=Utils.GetInt(_str[1]); 
							break;
					}
				}

				CreateReport();
			}
			catch (Exception ex)
			{
                Common.Log.Write(this,ex);  				 
				CrView.Visible =false;
			}
		}

 
		protected void CreateReport()
		{
			string repName="RepDs_"+m_rptID.ToString();
/*			DateTime dtBegin=DateTime.Now.AddMonths(-10);
			DateTime dtEnd=DateTime.Now ;*/
			ReportDoc rdc=new ReportDoc(Config.DbConnectionString, Utils.GetInt(Config.GetConfigValue("SQLCommandTimeout")),DBase);
			GetDataSet(rdc, repName);

			if (Config.GetConfigValue("TestRegime")== "true")
			{
				Log.Write(this, Config.GetConfigValue("ReportFilesPath")+"\\"+GetReportName());
				if (ds != null)
				{
					Log.Write(this,"Tables : "+ds.Tables.Count.ToString()  );   
					if (ds.Tables.Count>0)
					{
						Log.Write(this,"Table Name : "+ds.Tables[0].TableName);   
						Log.Write(this,"Rows : "+ds.Tables[0].Rows.Count.ToString()  );   
					}
				}
				else
					Log.Write(this,"ds is NULL" );   
			}

			CrystalDecisions.CrystalReports.Engine.ReportDocument r_d=rdc.GetReportDocument(Config.GetConfigValue("ReportFilesPath")+"\\"+GetReportName(), ds); 
			TableLogOnInfo logOnInfo = new TableLogOnInfo ();
			logOnInfo = r_d.Database.Tables[ds.Tables[0].TableName].LogOnInfo;

	/*		// Set the connection information for the table in the report.
			logOnInfo.ConnectionInfo.ServerName = rdc.m_DBLogonInfo.Server  ;
			logOnInfo.ConnectionInfo.DatabaseName =rdc.m_DBLogonInfo.Database;
			logOnInfo.ConnectionInfo.UserID = rdc.m_DBLogonInfo.User  ;
			logOnInfo.ConnectionInfo.Password = rdc.m_DBLogonInfo.Password ;
			logOnInfo.TableName = ds.Tables[0].TableName;*/
			CrView.LogOnInfo.Add(logOnInfo);   
			if (Config.GetConfigValue("TestRegime")== "true")
			{
				Log.Write(this,"LogOn Info was set :" + logOnInfo.ToString()  );   
			}
			CrView.ReportSource = r_d;
		}


		private bool GetDataSet(ReportDoc rdc,string repName)
		{
			object [] ob=null;
			if (Session[repName ] !=null)
			{
				ds=(DataSet)Session[repName];
				return true;
			}

			switch(m_rptID)
			{
				case 1:
					ds= rdc.CreateReportSource("wntUsersSignup","UsersSignup",new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@NoBots",m_noBots}); 
					break;
				case 2:
                    ob=new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@CurrencyPlay",m_chNM?1:0,"@CurrencyMoney",m_chM?1:0, "@UserID",m_uid,"@NoBots",m_noBots};
					ds= rdc.CreateReportSource("wntHandsPlayed","HandsPlayed",ob); 
					break;
				case 7:
					ob=new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@UserID",m_uid,"@NoBots",m_noBots};
					ds= rdc.CreateReportSource("wntHandsPlayedByUser","HandsPlayedByUser",ob); 
					break;
				case 8:
					ob=new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@UserID",m_uid,"@NoBots",m_noBots};
					ds= rdc.CreateReportSource("wntTimeSpendByUser","TimeSpendByUser",ob); 
					break;
				case 9:
					ob=new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte, "@UserID", m_uid,"@NoBots",m_noBots };
					ds= rdc.CreateReportSource("wntUserTransations","UserTransations",ob); 
					break;
				case 11:
					int crType=2;
					if (m_chNM)
						crType=1;
					else if (m_chM)
						crType=2;
 
					ob=new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@CurrencyTypeID",crType, "@UserID",m_uid,"@NoBots",m_noBots};
					ds= rdc.CreateReportSource("wntMostWinsForPlayer","MostWinsForPlayer",ob); 
					break;
				case 12:
					ob=new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@CurrencyPlay",m_chNM?1:0,"@CurrencyMoney",m_chM?1:0,"@NoBots",m_noBots};
					ds= rdc.CreateReportSource("wntMostActivePlayers","MostActivePlayers",ob); 
					break;
				case 13:
					ds= rdc.CreateReportSource("wntNotPlayedPlayers","NotPlayedPlayers",new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@NoBots",m_noBots }); 
					break;
				case 14:
					ds= rdc.CreateReportSource("wntMostPopularGames","MostPopularGames",new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@NoBots",m_noBots }); 
					break;
				case 15:
					ds= rdc.CreateReportSource("wntMostPopularGames","LeastPopularGames",new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@asLeast",1,"@NoBots",m_noBots }); 
					break;
				case 16:
					ds= rdc.CreateReportSource("rptClientSessionHistoryWithLoginNames","ClientSessionHistoryWithLoginNames",
						                 new object[]{"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@NoBots",m_noBots,
					                                               "@LoginNames",m_strloginname,"@UIDs",m_struid}); 
					break;
				case 17:
					ds= rdc.CreateReportSource("rptCurrentBalanceQuery","CurrentBalance",
						new object[]{"@NoBots",m_noBots,"@CurrencyPlay",m_chNM?1:0,"@CurrencyMoney",m_chM?1:0,
										"@LoginNames",m_strloginname,"@UIDs",m_struid}); 
					break;
				case 18:
					ds= rdc.CreateReportSource("rptLastLoginTimeQuery","LastLoginTime",
						new object[]{"@NoBots",m_noBots,"@LoginNames",m_strloginname,"@UIDs",m_struid}); 
					break;
				case 19:
					ds= rdc.CreateReportSource("rptNumberPIDSonMachines","NumberPIDsonMachines",
						new object[]{"@NoBots",m_noBots,"@LoginNames",m_strloginname,"@UIDs",m_struid, 
					                             "@dtBegin",m_dtb ,"@dtEnd",m_dte ,"@MACAddress",m_strmacaddress}); 
					break;
				case 20:
					ds= rdc.CreateReportSource("rptSpecificMachineHistory","SpecificMachineHistory",
						new object[]{"@NoBots",m_noBots,"@LoginNames",m_strloginname,"@UIDs",m_struid, 
										"@dtBegin",m_dtb ,"@dtEnd",m_dte ,"@MACAddress",m_strmacaddress}); 
					break;
				case 21:
					ds= rdc.CreateReportSource("rptCollusionHandsPlayed","CollusionHandsPlayed",
						new object[]{"@NoBots",m_noBots,"@LoginNames",m_strloginname,"@UIDs",m_struid, 
										"@dtBegin",m_dtb ,"@dtEnd",m_dte }); 
					break;
				case 22:
					ds= rdc.CreateReportSource("rptPlayerGameHistory","PlayerGameHistory",
						new object[]{"@NoBots",m_noBots,"@LoginNames",m_strloginname,"@UIDs",m_struid, 
										"@dtBegin",m_dtb ,"@dtEnd",m_dte }); 
					break;
				case 23:
					ds= rdc.CreateReportSource("rptDailyRanksIndividual","DailyRanksIndividual",
						new object[]{"@NoBots",m_noBots,"@LoginNames",m_strloginname,"@UIDs",m_struid, 
										"@dtBegin",m_dtb ,"@dtEnd",m_dte,"@CurrencyPlay",m_chNM?1:0,"@CurrencyMoney",m_chM?1:0 }); 
					break;
				default:
					return false;
			}

				Session[repName]=ds;
                return true; 
		}

		private string GetReportName() 
		{
			switch(m_rptID)
			{
				case 1:
					return "UsersSignup.rpt";
				case 2:
					return "HandsPlayed.rpt";
				case 7:
					return "HandsPlayedByUser.rpt";
				case 8:
					return "TimeSpendByUser.rpt";
				case 9:
					return "UserTransations.rpt";
				case 11:
					return "MostWinsForPlayer.rpt";
				case 12:
					return "MostActivePlayers.rpt";
				case 13:
					return "NotPlayedPlayers.rpt";
				case 14:
					return "MostPopularGames.rpt";
				case 15:
					return "LeastPopularGames.rpt";
				case 16:
					return "ClientSessionHistoryWithLoginNames.rpt";
				case 17:
					return "CurrentBalance.rpt";
				case 18:
					return "LastLoginTime.rpt";
				case 19:
					return "NumberPIDsonMachines.rpt";
				case 20:
					return "SpecificMachineHistory.rpt";
				case 21:
					return "CollusionHandsPlayed.rpt";
				case 22:
					return "PlayerGameHistory.rpt";
				case 23:
					return "DailyRanksIndividual.rpt";
				default:
					return "";
			}
		}

		private bool  DTFromString(String dtString,ref DateTime dt)
		{
			try
			{
				dt=DateTime.Parse(dtString); 
				return true;
			}
			catch
			{return false;}
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
