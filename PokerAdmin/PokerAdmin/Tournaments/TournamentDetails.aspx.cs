using System;
using System.Data;
using System.Drawing;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Admin.CommonUse;
using Admin.Controls;
using Common;
using Common.Web;
using DesktopAPIEngine;

namespace Admin.Tournaments
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class TournamentDetails : Page
	{
		protected Label lblInfo;
	
		protected int nEngineID = 1;
		protected int nActDispID = 1;
		protected int nTournamentID = 0;

		protected enum TrnType
		{
			Tornament=1,
			 SitAndGo=2
		}

		protected TrnType enType=TrnType.Tornament ;

		protected ComProperty oCom = new ComProperty();
		protected ButtonImage btnSave;
		protected ButtonImage btnCancel;
		protected ButtonImage btnPrize1;
		protected ButtonImage btnPrize2;
		protected ButtonImage btnInvitedU;
		protected Table table;
		protected HtmlInputHidden hdnTournamentID;
		protected DropDownList comboEngine;
		protected DropDownList comboActDisp;

		private void Page_Load(object sender, EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nTournamentID = GetMainParamInt(hdnTournamentID);
			if (Request["type"] != null && Request["type"]=="2")   enType =  TrnType.SitAndGo; 
			
			if ( !IsPostBack )
			{
				GetData();
				PreparePage();
				if ((comboEngine.SelectedIndex>=0) && (nTournamentID<=0)) FillTournamentProperty();
				if (enType== TrnType.SitAndGo)
				{
					TextBox  ttc=(TextBox ) table.FindControl("Maximum Number of Registered Gamers");
					if (Utils.GetInt(ttc.Text ) <=1) ttc.Text ="2";  
				}
				DropDownList ct= (DropDownList) table.FindControl("Category"); 
				ct.Enabled =false;
				ct.SelectedValue = ((int)enType).ToString();  
				ct= (DropDownList) table.FindControl("Tournament Type"); 
				ct.Enabled =false;
				if (nTournamentID<=0)
				{
					ct.SelectedIndex =ct.Items.Count -1; 
					TextBox tb= (TextBox) table.FindControl("Tournament Name"); 
					tb.Text =String.Format("Tournament #{0}",GetTournamentNextId());
				}
				Session["Tournament Type Maintenance"]=ct.SelectedIndex.ToString(); 
			}
			BackPageUrl =(string) Session["TournamentMaintenanceUrl"];
		}
	

		private int GetTournamentNextId()
		{
			int mxInt = DBase.ExecuteReturnInt(Config.DbGetTournamentMaxID,null);
			return mxInt+1;
		}

		/// <summary>
		/// Fill page combo boxes
		/// </summary>
		protected void PreparePage()
		{
			DBase.FillList(comboEngine, nEngineID, Config.DbDictionaryGameEngine, false);
			DBase.FillList(comboActDisp,nActDispID,Config.DbGetActionDispatchersAsDictionary,false);  
		}

		/// <summary>
		/// Retrieve DB data to place to the page
		/// </summary>
		protected void GetData()
		{
			if (nTournamentID>0)
			{
				DataRow oDR = GetFirstRow(Config.DbGetTournamentDetails, new object[]{"@ID", nTournamentID});
				if ( oDR != null )
				{
					nEngineID        = Utils.GetInt(oDR["GameEngineID"]);
					nActDispID        = Utils.GetInt(oDR["ActionDispatcherID"]);
                    enType =  (TrnType) Utils.GetInt(oDR["CategoryTypeID"]);  
					string xmlString = oDR["SettingsXML"].ToString();
					oCom.FillTable(xmlString, false, ref table);

					//disable controls on the page
					comboEngine.Enabled = false;
					btnSave.Visible = false;

					//show Tornament Prizes button
					btnPrize1.Visible = true;
					btnPrize2.Visible = true;
					btnInvitedU.Visible = true;
				}
			} 
			else 
			{
				btnPrize1.Visible = false;  //hide Tornament Prizes button
				btnPrize2.Visible = false;
				btnInvitedU.Visible = false;
			}
			
		}

		protected void btnInvitedU_click(object sender, EventArgs e)
		{
			Session["InvitedUsersBackUrl"]=Request.Url.AbsoluteUri;   
			Response.Redirect(Config.SiteBaseUrl+ "Games/InvitedUsers.aspx?processID=" +nTournamentID.ToString()+"&IsTournament=1"); 
		}

		protected void btnSave_Click(object sender, EventArgs e)
		{
			ApiControl  oTournament =Config.GetApIEngine() ;
			int engineID;

			try
			{
				//1. Create new xml
				if (comboEngine.Items.Count<=0) return;

				engineID = Convert.ToInt32(comboEngine.Items[comboEngine.SelectedIndex].Value);
				string xmlString =  oTournament.GetDefaultProperty(engineID,
					(enType==TrnType.Tornament ?  ApiMsg.enProcessFormTarget.Tournament : ApiMsg.enProcessFormTarget.SitAndGo) );

				xmlString = oCom.getFormXml(xmlString, Page);
				xmlString = oCom.setAttributeValue(xmlString, "properties/property","Tournament Type", (string) Session["Tournament Type Maintenance"]); 
				xmlString = oCom.setAttributeValue(xmlString, "properties/property","Category", Utils.GetInt(enType).ToString() ); 

				if (xmlString==null)
				{
					Log.Write(this, "Some error occured. Object does not return error description");
					ShowError("Error occured while creating xml.");
					return;
				}

				//2. Call InitGameProcess method of Com
				//int sEngineID = Utils.GetInt(comboEngine.Items[comboEngine.SelectedIndex].Value);
				int sADispID = Utils.GetInt(comboActDisp.Items[comboActDisp.SelectedIndex].Value);
				int tournamentID = 0;
				oTournament.InitGameProcess(engineID,(int)(enType==TrnType.Tornament ?  
					ApiMsg.enProcessFormTarget.Tournament : ApiMsg.enProcessFormTarget.SitAndGo) ,ref tournamentID, xmlString, sADispID);
				if (tournamentID <= 0)
				{
					Log.Write(this, "Some error occured. Object does not return error description");
					ShowError("Object error. Tournament wasn't created.");
					Log.Write(this, "Object error. Tournament wasn't created.");
					return;
				}

				//3. Save xml in DB
				nTournamentID = tournamentID;
				DBase.Execute(Config.DbUpdateTournamentSettings, "@ID", nTournamentID, "@SettingsXml", xmlString); //delete game process in com error case


				//4. Success message
		//		StoreBackID(nTournamentID);
				hdnTournamentID.Value = nTournamentID.ToString();
				lblInfo.Text = "Tournament was created";
				lblInfo.ForeColor = Color.Green;
				GetData();
			}
			finally{oTournament=null;}
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
			this.comboEngine.SelectedIndexChanged += new EventHandler(this.comboEngine_SelectedIndexChanged);
			this.Load += new EventHandler(this.Page_Load);

		}
		#endregion

		private void comboEngine_SelectedIndexChanged(object sender, EventArgs e)
		{
		  FillTournamentProperty();
		}


		/// <summary>
		/// Return table with default tournament properties
		/// </summary>
		private void FillTournamentProperty()
		{
			if (comboEngine.Items.Count<=0) return;
			int engineID = Convert.ToInt32(comboEngine.Items[comboEngine.SelectedIndex].Value);
			ApiControl  oTournament =Config.GetApIEngine() ;
			string xmlString =  oTournament.GetDefaultProperty(engineID, 
				(enType==TrnType.Tornament ?  ApiMsg.enProcessFormTarget.Tournament : ApiMsg.enProcessFormTarget.SitAndGo) );
			oTournament=null;
			if (xmlString.Length == 0)//((xmlString == null) || (xmlString == ""))
			{
				Log.Write(this, "Some error occured. Object does not return error description");
				ShowError("Error occured while getting xml.");
				return;
			}

			oCom.FillTable(xmlString, true, ref table);
		}


		private void ShowError(string sError)
		{
			lblInfo.Text = sError;
			lblInfo.ForeColor = Color.Red;
		}

		protected void btnPrize1_Click(object sender, EventArgs e)
		{
			string prizePageUrl = FindPageAbsoluteUrl(Config.PageTournamentDetailsPrize);
			Response.Redirect(prizePageUrl + "?" + Config.ParamTournamentID + "=" + nTournamentID.ToString()+"&"+Config.PrizeNumber+"=0");
		}

		protected void btnBettings_Click(object sender, EventArgs e)
		{
			string prizePageUrl = FindPageAbsoluteUrl(Config.PageTournamentBettings);
			Response.Redirect(prizePageUrl + "?" + Config.ParamTournamentID + "=" + nTournamentID.ToString());
		}

		protected void btnPrize2_Click(object sender, EventArgs e)
		{
			string prizePageUrl = FindPageAbsoluteUrl(Config.PageTournamentDetailsPrize);
			Response.Redirect(prizePageUrl + "?" + Config.ParamTournamentID + "=" + nTournamentID.ToString()+"&"+Config.PrizeNumber+"=1");
		}


	}
}

