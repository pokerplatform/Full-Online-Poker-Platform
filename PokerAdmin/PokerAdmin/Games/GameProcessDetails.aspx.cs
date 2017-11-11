using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Admin.CommonUse;
using Admin.Controls;
using Common;
using Common.Web;
using DesktopAPIEngine;
using System.Globalization; 

namespace Admin.Games
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class GameProcessDetails : Page
	{
//		public static string poTexasEngine = "poTexasHoldem.TexasHoldem";
	
		protected int nEngineID = 1;
		protected int nStatusID = 1;
		protected int nCurrencyID = 1;
		protected int nSubCategoryID = 1;
		protected int nActDispID=0;
		protected ComProperty oCom = new ComProperty();
		protected Label lblInfo;
		protected TextBox txtName;
		protected Table table;
		protected HtmlInputHidden hdnGameProcessID;
		protected DropDownList comboCurrency;
		protected DropDownList comboSubCategory;
		protected DropDownList comboEngine;
		protected RequiredFieldValidator RequiredFieldValidator1;
		protected ButtonImage btnSave;
		protected ButtonImage btnReInit;
		protected ButtonImage btnInvitedU;
		protected int nGameProcessID = 0;
		protected DropDownList comboActDisp;
		protected TextBox txtActivatedTime;
		protected RequiredFieldValidator RequiredFieldValidator2;
		protected TextBox txtProtCode;
		protected TextBox txtCreator;
		protected DropDownList ddProtectedM;
		protected DropDownList ddHighlightedM;
		protected DropDownList ddMassWatchingAllowed;
		protected CheckBox chVisible;
		protected System.Web.UI.WebControls.TextBox txtReward;
		protected bool isMini=false;

		private void Page_Load(object sender, EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nGameProcessID = GetMainParamInt(hdnGameProcessID);

			if(Request["mini"]!=null && Request["mini"].ToString() =="1") isMini=true;
	
			if ( !IsPostBack )
			{
				GetData();
				PreparePage();
				if ((comboEngine.SelectedIndex>=0) && (nGameProcessID<=0)) FillEngineProperty();
				DropDownList ct= (DropDownList) table.FindControl("Tournament Type"); 
				ct.Enabled =false;
				if (isMini && nGameProcessID<=0 ) ct.SelectedIndex =ct.Items.Count -2; 
				Session["Tournament Type Process"]=ct.SelectedIndex.ToString(); 
			}
			BackPageUrl =(string) Session["GameProcessMaintenanceUrl"];
		}
	

		/// <summary>
		/// Fill page combo boxes
		/// </summary>
		protected void PreparePage()
		{
			DBase.FillList(comboEngine, nEngineID, Config.DbDictionaryGameEngine, false);
			DBase.FillList(comboCurrency, nCurrencyID, Config.DbDictionaryCurrency, false);
			DBase.FillList(comboSubCategory, nSubCategoryID, Config.DbDictionarySubCategory, false);
			DBase.FillList(comboActDisp,nActDispID,Config.DbGetActionDispatchersAsDictionary,false);  
			if (!isMini)
				Core.RemoveItemByValue(comboSubCategory, (object) Config.Mini_TourneyID);
			else
				Core.RemoveItemByValue(comboSubCategory, Config.NonMini_TourneyIDs);
		}

		/// <summary>
		/// Retrieve DB data to place to the page
		/// </summary>
		protected void GetData()
		{
			if (nGameProcessID>0)
			{
				DataRow oDR = GetFirstRow(Config.DbGetGameProcessDetails, new object[]{"@ID", nGameProcessID});
				if ( oDR != null )
				{
					txtName.Text     = oDR["Name"].ToString();
					nEngineID        = Utils.GetInt(oDR["GameEngineID"]);
					nCurrencyID      = Utils.GetInt(oDR["CurrencyTypeID"]);
					nSubCategoryID   = Utils.GetInt(oDR["SubCategoryID"]);
					nActDispID=  Utils.GetInt(oDR["ActionDispatcherID"]);
					txtActivatedTime.Text =oDR["ActivatedTime"].ToString(); 
					txtProtCode.Text= oDR["ProtectedCode"].ToString(); 
					txtReward.Text= oDR["RewardID"].ToString(); 
					chVisible.Checked =  (Utils.GetInt(oDR["Visible"])==1);
					txtCreator.Text=  oDR["CreatorUserID"].ToString(); 
					ddProtectedM.SelectedValue =oDR["ProtectedMode"].ToString() ;
					ddHighlightedM.SelectedValue = Utils.GetBool(oDR["IsHighlighted"])? "1":"0" ;
					ddMassWatchingAllowed.SelectedValue =Utils.GetBool(oDR["IsMassWatchingAllowed"])? "1":"0" ;
					string xmlString = oDR["SettingsXML"].ToString();
					oCom.FillTable(xmlString, "gameengine/properties/property", false, ref table);
				}
			}
			else
			{
				chVisible.Checked =  true;
                txtActivatedTime.Text=DateTime.Now.ToString(); 
			}
			ShowControls();
		}


		protected void ShowControls()
		{
			bool bRes = (nGameProcessID>0);
			//disable all controls on the page and enable some
			txtName.Enabled = !bRes;
			comboEngine.Enabled = !bRes;
			comboCurrency.Enabled = !bRes;
			comboSubCategory.Enabled = !bRes;
			comboActDisp.Enabled = !bRes; 
			btnSave.Visible = !bRes;
			btnReInit.Visible = bRes;
			btnInvitedU.Visible = (bRes ); //&& ddProtectedM.SelectedValue=="2")  ; 
			txtActivatedTime.Enabled = !bRes; 
			chVisible.Enabled = !bRes; 
			txtCreator.Enabled = !bRes; 
			txtProtCode.Enabled = !bRes; 
			txtReward.Enabled = !bRes; 
			ddHighlightedM.Enabled = !bRes; 
			ddMassWatchingAllowed.Enabled = !bRes; 
			ddProtectedM.Enabled = !bRes;  
		}

		protected void btnReInit_click(object sender, EventArgs e)
		{
			//1. Delete records in GameProcessState and GameProcessStats
			string xmlString = "";
			DataRow oDR = GetFirstRow(Config.DbReinitGameProcess, "@gameProcessID", nGameProcessID);
			if ( oDR != null )
			{
				xmlString = oDR["SettingsXML"].ToString();
			}
			else
			{
				ShowError("DB error occured during reiniting gameProcess");
				oCom.FillTable(xmlString, "gameengine/properties/property", false, ref table);
				return;
			}

			bool errorNumber = false;
			ApiControl oEngine =Config.GetApIEngine() ;
			    int pID=nGameProcessID;
			    nActDispID=Core.GetSelectedValueInt(comboActDisp);
				nEngineID = Core.GetSelectedValueInt(comboEngine);
				errorNumber = oEngine.InitGameProcess(nEngineID, (int)ApiMsg.enProcessFormTarget.Process,ref pID, xmlString,nActDispID);
			oEngine=null;

			if (!errorNumber)
			{
				Log.Write(this, "Init game process error");
				ShowError("Error occured. Game process wasn't reinited.");
				oCom.FillTable(xmlString, "gameengine/properties/property", false, ref table);
				return;
			}

			//3. Everything is Ok
			oCom.FillTable(xmlString, "gameengine/properties/property", false, ref table);
			lblInfo.Text = "Game process was reinited";
			lblInfo.ForeColor = Color.Green;

		}

		protected void btnInvitedU_click(object sender, EventArgs e)
		{
			Session["InvitedUsersBackUrl"]=Request.Url.AbsoluteUri;   
            Response.Redirect("InvitedUsers.aspx?processID=" +nGameProcessID.ToString()); 
		}
	
		protected void btnSave_Click(object sender, EventArgs e)
		{
			//1. Create new xml
			string xmlString = "";
			ApiControl oEngine =Config.GetApIEngine() ;

			try
			{

				DateTime actTime;
				try
				{
					actTime=DateTime.Parse(txtActivatedTime.Text,new CultureInfo("en-US"));   
				}
				catch
				{
					lblInfo.Text = "Incorrect value for Activated Time. Please enter valid date.";
                    return;
				}

				nEngineID = Core.GetSelectedValueInt(comboEngine);

				xmlString  = oEngine.GetDefaultProperty(nEngineID,ApiMsg.enProcessFormTarget.Process);

				xmlString = oCom.getFormXml(xmlString, "gameengine/properties/property", Page);
				xmlString = oCom.setAttributeValue(xmlString, "gameengine/properties/property","Tournament Type", (string) Session["Tournament Type Process"]); 
				if (xmlString==null) return;

				//2. Save values in DB
				nCurrencyID = Core.GetSelectedValueInt(comboCurrency);
				nSubCategoryID = Core.GetSelectedValueInt(comboSubCategory);
				nActDispID=Core.GetSelectedValueInt(comboActDisp);


				SqlCommand oCmd = DBase.GetCommand(Config.DbCreateFirstGameProcess);
				SqlParameterCollection oParams = oCmd.Parameters;

				oParams.Add("@Name", txtName.Text);
				oParams.Add("@GameEngineID", nEngineID);
				oParams.Add("@CurrencyTypeID", nCurrencyID);
				oParams.Add("@SubCategoryID", nSubCategoryID);
				oParams.Add("@SettingsXml", xmlString);
				oParams.Add("@ActionDispatcherID",nActDispID); 
				oParams.Add("@ActivatedTime",actTime); 
				oParams.Add("@ProtectedCode",txtProtCode.Text); 
				oParams.Add("@RewardID",txtReward.Text); 
				oParams.Add("@Visible",chVisible.Checked ? 1:0 ); 
				oParams.Add("@CreatorUserID",SqlDbType.Int ); 
				oParams["@CreatorUserID"].Value =0;
				oParams.Add("@ProtectedMode",Utils.GetInt( ddProtectedM.SelectedValue)); 
				oParams.Add("@IsHighlighted",Utils.GetInt( ddHighlightedM.SelectedValue)); 
				oParams.Add("@IsMassWatchingAllowed",Utils.GetInt( ddMassWatchingAllowed.SelectedValue)); 

				SqlParameter oParam = new SqlParameter("@GameProcessID", SqlDbType.Int);
				oParam.Direction = ParameterDirection.Output;
				oParams.Add(oParam);
				int Return = DBase.ExecuteReturnInt(oCmd);

				if (Return<=0)
				{
					if (Return<0)
						lblInfo.Text = "Such game process name already exists. Please try another one.";
					else
						lblInfo.Text = "Database error occured";
					oCom.FillTable(xmlString, "gameengine/properties/property", true, ref table);
					return;
				}

				int processID = Utils.GetInt(oParams["@GameProcessID"].Value);

				//3. Call InitGameProcess method of Com
				int pID=processID;
				if(!oEngine.InitGameProcess(nEngineID, (int)ApiMsg.enProcessFormTarget.Process,ref pID, xmlString,nActDispID))
				{
					Log.Write(this, "Init game process error");
					ShowError("Error occured. Game process wasn't created.");
					oCom.FillTable(xmlString, "gameengine/properties/property", true, ref table);
					return;
				}

				//4. Success message
				nGameProcessID = processID; 
				hdnGameProcessID.Value = nGameProcessID.ToString();
				lblInfo.Text = "Game process was created";
				lblInfo.ForeColor = Color.Green;
				oCom.FillTable(xmlString, "gameengine/properties/property", false, ref table);
				ShowControls();
			}
			finally
			{oEngine=null;}
		}


		private void ShowError(string sError)
		{
			lblInfo.Text = sError;
			lblInfo.ForeColor = Color.Red;
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
			this.comboEngine.SelectedIndexChanged += new System.EventHandler(this.comboEngine_SelectedIndexChanged);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void comboEngine_SelectedIndexChanged(object sender, EventArgs e)
		{
			FillEngineProperty();
		}


		/// <summary>
		/// Return table with default engine properties
		/// </summary>
		private void FillEngineProperty()
		{
			//Creating com objects and getting xml
			string xmlString = "";
			ApiControl oEngine =Config.GetApIEngine() ;
			xmlString = oEngine.GetDefaultProperty(1,ApiMsg.enProcessFormTarget.Process);
			oEngine=null;
			oCom.FillTable(xmlString, "gameengine/properties/property", true, ref table);
		}

	}
}

