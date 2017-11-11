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

using Admin.CommonUse;
using Common;
using Common.Web;

namespace Admin.Tournaments
{
	/// <summary>
	/// Summary description for TournamentPrizes.
	/// </summary>
	public class TournamentPrizeDetails : Common.Web.Page
	{
		int nTournamentPrizeID = 0;
		int nPrizeNumber = 0;
		int nValueType=0;
		int nCurrencyID=0;
		string xmlTournamentPrize = "";
		protected PrizeTable oPrize = new PrizeTable();
		public Controls.ButtonImage btnSave;
		public Controls.ButtonImage btnCancel;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTournamentPrizeXML;
		protected System.Web.UI.WebControls.TextBox lblInfo;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTournamentPrizeID;
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.TextBox txFrom;
		protected System.Web.UI.WebControls.TextBox txToFinish;
		protected System.Web.UI.WebControls.Panel panelPrizesList;
		protected System.Web.UI.HtmlControls.HtmlSelect PrefList;
		protected System.Web.UI.WebControls.CustomValidator CustomValidator1;
		protected System.Web.UI.WebControls.TextBox Textbox1;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnPostBackType;
		protected System.Web.UI.WebControls.Label Label1;
		protected System.Web.UI.WebControls.Label Label2;
		protected System.Web.UI.WebControls.DropDownList cbPrizeValueType;
		protected System.Web.UI.WebControls.DropDownList cbCurrency;
	
		protected PrizeData prData=new PrizeData(); 

		private void Page_Load(object sender, System.EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nTournamentPrizeID = GetMainParamInt(hdnTournamentPrizeID);
			xmlTournamentPrize = hdnTournamentPrizeXML.Value;

			if ( Session["TournamentPrizeMaintenanceUrl"] !=null)
				BackPageUrl=(string) Session["TournamentPrizeMaintenanceUrl"];    
			else
				BackPageUrl= "TournamentPrizeMaintenance.asp";    

			if ( !IsPostBack )
			{
				GetData(true);
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

	  protected void AddPrize()
		{
			if (Common.Utils.GetInt(txFrom.Text)<=0 ||   Common.Utils.GetInt(txToFinish.Text)<=0) return; 
			string tn=prData.CreateIntervalTable(txFrom.Text,txToFinish.Text);
			if (tn != String.Empty)
				prData.CreateDataTable(tn ,"1","1","100","",true);
			string xml=prData.DataSetToXML(nPrizeNumber,Utils.GetInt(cbCurrency.SelectedValue),Utils.GetInt(cbPrizeValueType.SelectedValue));
			hdnTournamentPrizeXML.Value =xml;
			xmlTournamentPrize=xml;
		}


		protected void SavePrize()
		{

			if (cbPrizeValueType.SelectedValue != Config.PrizeValueAny)
			{

				string stat=prData.CheckPercent(); 

				if (stat != String.Empty)
				{
					lblInfo.Text =stat;
					lblInfo.Visible =true; 
					return;
				}
			}

			string xml=prData.DataSetToXML(nPrizeNumber,Utils.GetInt(cbCurrency.SelectedValue),Utils.GetInt(cbPrizeValueType.SelectedValue));
			hdnTournamentPrizeXML.Value =xml;
			xmlTournamentPrize=xml;


			//Save values to DB
			int nRes = 0;
			nRes = DBase.ExecuteReturnInt(Config.DbSaveTournamentPrizeDetails, "@ID", nTournamentPrizeID,
																													"@name", txtName.Text, "@PrizeXml", xmlTournamentPrize,
																													"@CurrencyTypeID",Utils.GetInt(cbCurrency.SelectedValue) ,
																													"@PrizeValueType",Utils.GetInt(cbPrizeValueType.SelectedValue)); 
			if ( nRes > 0 )
			{
				nTournamentPrizeID = nRes;
				hdnTournamentPrizeID.Value = nTournamentPrizeID.ToString();
				StoreBackID(nTournamentPrizeID);
				lblInfo.Text = "Tournament Prize Table was saved";
				lblInfo.ForeColor = Color.Green;
				lblInfo.Visible =true; 

				Response.Redirect(GetGoBackUrl());
			}
			else
			{
				if (nRes==-1) ShowError("Such tournament prize name already exists");
				else ShowError("Database error occured");
			}

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

		protected void GetData( bool FromBase)
		{
			if( FromBase)
			{
				if (nTournamentPrizeID>0)
				{
					DataRow oDR = GetFirstRow(Config.DbGetTournamentPrizeDetails, new object[]{"@ID", nTournamentPrizeID});
					if ( oDR != null )
					{
						if (oDR["PaySchemaXML"]!=null) xmlTournamentPrize = oDR["PaySchemaXML"].ToString();
						nValueType=Utils.GetInt ( oDR["PrizeValueType"]);
						nCurrencyID=Utils.GetInt ( oDR["CurrencyTypeID"]);
						txtName.Text=oDR["name"].ToString() ;
					}
				}
				DBase.FillList(cbPrizeValueType,nValueType,Config.DbDictionaryTournPrizeValueType,false);  
				DBase.FillList(cbCurrency,nCurrencyID,Config.DbDictionaryCurrency,false);
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
