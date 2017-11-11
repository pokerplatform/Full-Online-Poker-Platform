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
using System.Xml;
using System.Data.SqlClient;  

using Admin.CommonUse;
using Common;
using Common.Web;
using DesktopAPIEngine; 

namespace Admin.Tournaments
{
	/// <summary>
	/// Summary description for TournamentPrizes.
	/// </summary>
	public class TournamentDetailsPrize : Common.Web.Page
	{
		int nTournamentID = 0;
		int nPrizeNumber = 0;
		int nValueType=0;
		int nCurrencyID=0;
		string xmlTournamentPrize = "";
		int nTemplateID = 1;
		protected PrizeTable oPrize = new PrizeTable();
		protected Controls.ButtonImage btnSave;
		protected Controls.ButtonImage btnCancel;
		protected Controls.ButtonImage btnAddPrize;
	/*	protected Controls.ButtonImage btnAdd;
		protected Controls.ButtonImage btnDelete;*/
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTournamentID;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTournamentPrizeXML;
		protected System.Web.UI.WebControls.TextBox lblInfo;
		protected System.Web.UI.WebControls.DropDownList comboTemplate;
		protected System.Web.UI.WebControls.Table table;
		protected System.Web.UI.WebControls.Panel panelPrizesList;
		protected System.Web.UI.WebControls.TextBox txFrom;
		protected System.Web.UI.WebControls.TextBox txToFinish;
		protected System.Web.UI.HtmlControls.HtmlSelect PrefList;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnPostBackType;
		protected System.Web.UI.WebControls.DropDownList ddPrizeValueType;
		protected System.Web.UI.WebControls.Label Label1;
		protected System.Web.UI.WebControls.Label Label2;
		protected System.Web.UI.WebControls.DropDownList ddCurrency;

		protected PrizeData prData=new PrizeData(); 
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nTournamentID = GetMainParamInt(hdnTournamentID);
			nPrizeNumber=Utils.GetInt(Request[Config.PrizeNumber]); 
			xmlTournamentPrize = hdnTournamentPrizeXML.Value;
			PrefList.Items.Clear();  

			if ( Session["TournamentMaintenanceUrl"] !=null)
				BackPageUrl=(string) Session["TournamentMaintenanceUrl"];    
			else
				BackPageUrl= "TournamentMaintenance.asp";    

			if ( !IsPostBack )
			{
				GetData(true);
				PreparePage();
			}
			else
			{
				if (hdnPostBackType.Value != String.Empty)
				{
					GetData(false);
					switch(hdnPostBackType.Value)
					{
						case	"btnAddPrize":
							AddPrize();
							break;
						case	"btnSave":
							SavePrize();
							break;
					}
				}
				else
					GetData(true);
			}

		}


//  <tournamentprize prizetype="0" currencytype="1" valuetype="1"><players from="1" playersforfinish="1"><place from="1" to="1" prizeRate="100"/></players></tournamentprize> 

		protected void AddPrize()
		{
             if (Common.Utils.GetInt(txFrom.Text)<=0 ||   Common.Utils.GetInt(txToFinish.Text)<=0) return; 
			  string tn=prData.CreateIntervalTable(txFrom.Text,txToFinish.Text);
			  if (tn != String.Empty)
				  prData.CreateDataTable(tn ,"1","1","100","",true);
			  string xml=prData.DataSetToXML(nPrizeNumber,Utils.GetInt(ddCurrency.SelectedValue),Utils.GetInt(ddPrizeValueType.SelectedValue));
			  hdnTournamentPrizeXML.Value =xml;
			  xmlTournamentPrize=xml;
		}

		protected void SavePrize()
		{
			if (ddPrizeValueType.SelectedValue != Config.PrizeValueAny)
			{
				string stat=prData.CheckPercent(); 

				if (stat != String.Empty)
				{
					lblInfo.Text =stat;
					lblInfo.Visible =true; 
					return;
				}
			}

			string xml=prData.DataSetToXML(nPrizeNumber,Utils.GetInt(ddCurrency.SelectedValue),Utils.GetInt(ddPrizeValueType.SelectedValue));
			hdnTournamentPrizeXML.Value =xml;
			xmlTournamentPrize=xml;

			ApiControl  oTournament =Config.GetApIEngine() ;
			if (! oTournament.SetPrizePool(nTournamentID, xmlTournamentPrize))
			{
				ShowError("COM error occured");
				oTournament=null;
				return;
			}
			oTournament=null;
			lblInfo.Text = "Tournament Prizes were saved";
			lblInfo.ForeColor = Color.Green;
			lblInfo.Visible =true; 

			Response.Redirect(GetGoBackUrl());
		}

		protected void btnCopy_Click(object sender, System.EventArgs e)
		{
			xmlTournamentPrize = hdnTournamentPrizeXML.Value;
			int tempateID = Convert.ToInt32(comboTemplate.Items[comboTemplate.SelectedIndex].Value);
			DataRow oDR = GetFirstRow(Config.DbGetTournamentPrizeDetails, new object[]{"@ID", tempateID});
			if ( oDR != null )
			{
				if (oDR["PaySchemaXML"]!=null) xmlTournamentPrize = oDR["PaySchemaXML"].ToString();
				nValueType=Utils.GetInt ( oDR["PrizeValueType"]);
				nCurrencyID=Utils.GetInt ( oDR["CurrencyTypeID"]);
				ddCurrency.SelectedValue = oDR["CurrencyTypeID"].ToString();
				ddPrizeValueType.SelectedValue = oDR["PrizeValueType"].ToString(); 
			}
	//		oPrize.FillTable(ref xmlTournamentPrize, ref table, true, false);
			hdnTournamentPrizeXML.Value = xmlTournamentPrize;
			prData.XMLToDataSet(xmlTournamentPrize); 
		}
				  
		public void FillTables()
		{
			panelPrizesList.Controls.Clear();
			PrefList.Items.Clear();  

			foreach(DataTable tb in prData.DetDs.Tables)
			{
				if (tb.TableName.IndexOf("play_")<0) continue;
				string tbname=tb.TableName.Replace("play_","");
				if(prData.DetDs.Tables.Contains( tbname)==false) continue;
				Control oControl =  LoadControl( "../controls/PrizeGrid.ascx");
				Admin.Controls.PrizeGrid objPrize= (Admin.Controls.PrizeGrid)oControl;
				objPrize.InitControl(tb,prData.DetDs.Tables[tbname], PrefList); 
				panelPrizesList.Controls.Add(objPrize);
			}
		}
				  

		/// <summary>
		/// Fill page combo boxes
		/// </summary>
		protected void PreparePage()
		{
			DBase.FillList(comboTemplate, nTemplateID, Config.DbDictionaryTournamentPrize, false);
			DBase.FillList(ddPrizeValueType,nValueType,Config.DbDictionaryTournPrizeValueType,false);  
			DBase.FillList(ddCurrency,nCurrencyID,Config.DbDictionaryCurrency,false);
		}

		/// <summary>
		/// Retrieve DB data to place to the page
		/// </summary>
		protected void GetData( bool FromBase)
		{
			if( FromBase)
			{
				if (nTournamentID>0)
				{
					//DataRow oDR = GetFirstRow(Config.DbGetTournamentDetails, new object[]{"@ID", nTournamentID});
					DataRow oDR = GetFirstRow(Config.DbGetPrizeRulesDetails , new object[]{"@TournamentID", nTournamentID,"@PrizeNumber",nPrizeNumber});
					if ( oDR != null )
					{
						if (oDR["PaySchemaXML"]!=null) xmlTournamentPrize = oDR["PaySchemaXML"].ToString();
						nValueType=Utils.GetInt ( oDR["PrizeValueType"]);
						nCurrencyID=Utils.GetInt ( oDR["CurrencyTypeID"]);
					}
				}
				else 
				{
					ShowError("Incorrect Parameters");
					return;
				}
			}

	//		oPrize.FillTable(ref xmlTournamentPrize, ref table, true, false);
			hdnTournamentPrizeXML.Value = xmlTournamentPrize;
		    prData.XMLToDataSet(xmlTournamentPrize); 
		}

		private void ShowError(string sError)
		{
			lblInfo.Text = sError;
			lblInfo.ForeColor = Color.Red;
			lblInfo.Visible =true; 
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
			this.PreRender += new System.EventHandler(this.TournamentDetailsPrize_PreRender);

		}
		#endregion

		private void TournamentDetailsPrize_PreRender(object sender, System.EventArgs e)
		{
			FillTables();
		}



	}
}
