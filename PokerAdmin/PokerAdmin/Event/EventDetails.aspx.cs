using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using Admin.CommonUse;
using Admin.Components;
using Common;
using Common.Web;

namespace Admin.Event
{
	/// <summary>
	/// Summary description for EventDetails.
	/// </summary>
	public class EventDetails : Common.Web.Page
	{
		#region Controls
		protected int nEventID = 0;
		protected int nCategoryID = 0;
		protected int nStateID = 0;
		protected string sGuid = "";
		protected string jsInitialize = "";
		
		//Remarks: Constants below present values from SQL Tables (dictionaries)
		const int statePending  = 1;
		const int stateReady  = 2;
		const int stateActive = 3;
		const int stateProcessing = 4;

		const int periodFull = 1;
		const int periodHalf = 2;

		const int typeML = 1;
		const int typeSpread = 2;
		const int typeOu = 3;

		const int againstHome = 0;
		const int againstAway = 1;

		const int defaultEuroRate = 2;

		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnEventID;
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.DropDownList comboCategory;
		protected System.Web.UI.WebControls.DropDownList comboSubCategory;
		protected System.Web.UI.HtmlControls.HtmlTableRow EventStatus;
		protected System.Web.UI.WebControls.DropDownList comboDate;
		protected System.Web.UI.WebControls.DropDownList comboTime;
		protected System.Web.UI.WebControls.DropDownList comboHomeSpread;
		protected System.Web.UI.WebControls.DropDownList comboTotalOU;
		protected System.Web.UI.WebControls.TextBox txtHomeML;
		protected System.Web.UI.WebControls.TextBox txtAwayML;
		protected System.Web.UI.WebControls.TextBox txtHomeSpread;
		protected System.Web.UI.WebControls.TextBox txtTotalOU;
		protected System.Web.UI.WebControls.TextBox txtHomeTeam;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnSubCategoryList;
		protected System.Web.UI.WebControls.DropDownList comboAway;
		protected System.Web.UI.WebControls.DropDownList comboHome;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTeamList;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator2;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator3;
		protected System.Web.UI.WebControls.DropDownList comboHomeSpreadHalf;
		protected System.Web.UI.WebControls.DropDownList comboTotalOUHalf;
		protected System.Web.UI.WebControls.TextBox txtHomeSpreadHalf;
		protected System.Web.UI.WebControls.TextBox txtTotalOUHalf;
		protected System.Web.UI.WebControls.TextBox txtAwayScore;
		protected System.Web.UI.WebControls.TextBox txtHomeScore;
		protected System.Web.UI.WebControls.Label lblAwayScore;
		protected System.Web.UI.WebControls.Label lblHomeScore;
		protected System.Web.UI.WebControls.Label lblAwayScoreHalf;
		protected System.Web.UI.WebControls.TextBox txtAwayScoreHalf;
		protected System.Web.UI.WebControls.Label lblHomeScoreHalf;
		protected System.Web.UI.WebControls.TextBox txtHomeScoreHalf;
		protected Controls.ButtonImage btnProcess;
		protected Controls.ButtonImage btnSave;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnStateID;
		protected System.Web.UI.WebControls.CompareValidator CompareValidator1;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnGuid;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnResultHomeSpread;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnResultHomeSpreadHalf;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnResultTotalOU;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnResultTotalOUHalf;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnResultHomeML;
		protected System.Web.UI.WebControls.DropDownList comboHomeTeam;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnResultAwayML;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnJsInitialize;
		protected Controls.ButtonImage btnConfirm;
		#endregion

		#region PageLoad / GetPageData
		private void Page_Load(object sender, System.EventArgs e)
		{
			nEventID = GetMainParamInt(hdnEventID);
			nStateID = Utils.GetInt(hdnStateID.Value);
			BackPageUrl= (string) Session["EventMaintenanceUrl"];
			if (nStateID<=0)
			{
				nStateID = statePending;
			}
			sGuid = hdnGuid.Value;
			if (sGuid==null)
			{
				sGuid = "";
			}

			if ( !IsPostBack )
			{
				if ( nEventID > 0 )
				{
					GetPageData();
				}
				FillComboBoxes();
				DisplayControls();
				InitJS();
			}
		}

		//
		private void GetPageData()
		{
			//Get Event Info
			DataRow oDR = GetFirstRow(Config.DbGetEventDetails, new object[]{"@EventID", nEventID});
			if ( oDR != null )
			{
				nCategoryID = Utils.GetInt(oDR["CategoryID"]);
				AddJsVariable("SubCategoryID", oDR["SubCategoryID"].ToString());
				AddJsVariable("AwayTeamID", oDR["AwayTeamID"].ToString());
				AddJsVariable("HomeTeamID", oDR["HomeTeamID"].ToString());
				if (oDR["StartDate"]!=null)
				{
					DateTime StartDate = Convert.ToDateTime(oDR["StartDate"]);
					AddJsVariable("StartDate", StartDate.ToShortDateString());
					if (StartDate.Minute<10)
					{
						AddJsVariable("StartTime", StartDate.Hour + ":" + StartDate.Minute + "0");
					}
					else
					{
						AddJsVariable("StartTime", StartDate.Hour + ":" + StartDate.Minute);
					}

					txtAwayScore.Text     = oDR["awayScore"].ToString();
					txtAwayScoreHalf.Text = oDR["awayHalfTimeScore"].ToString();
					txtHomeScore.Text     = oDR["homeScore"].ToString();
					txtHomeScoreHalf.Text = oDR["homeHalfTimeScore"].ToString();

					nStateID = Utils.GetInt(oDR["EventStateID"]);
					hdnStateID.Value = nStateID.ToString();
					sGuid = oDR["StartSchedule"].ToString();
				}
			}

			//Get Outcome Info
			DataTable oDT = GetDataTable(Config.DbGetEventOutcomeList, new object[]{"@EventID", nEventID});
			foreach(DataRow oRow in oDT.Rows)
			{
				int BetTypeID = Utils.GetInt(oRow["BetTypeID"]);
				int isHome = Utils.GetInt(oRow["isHome"]);
				int PeriodID = Utils.GetInt(oRow["PeriodID"]);
				string OutcomeResultID = oRow["OutcomeResultID"].ToString();
				string BetValue = oRow["BetValue"].ToString();
				decimal nRate = Utils.GetDecimal(oRow["Rate"]);
				string Rate = "";
				if (nRate != defaultEuroRate)
				{
					Rate = Components.BetPriceConvert.Euro2Usa(nRate).ToString();
				}

				//HomeSpread
				if ((BetTypeID==typeSpread) && (isHome==againstHome) && (PeriodID==periodFull))
				{
					txtHomeSpread.Text = Rate;
					hdnResultHomeSpread.Value = OutcomeResultID;
					AddJsVariable("PointHomeSpread", BetValue);
				}
				if ((BetTypeID==typeSpread) && (isHome==againstHome) && (PeriodID==periodHalf))
				{
					txtHomeSpreadHalf.Text = Rate;
					hdnResultHomeSpreadHalf.Value = OutcomeResultID;
					AddJsVariable("PointHomeSpreadHalf", BetValue);
				}

				//Over Under
				if ((BetTypeID==typeOu) && (isHome==againstHome) && (PeriodID==periodFull))
				{
					txtTotalOU.Text = Rate;
					hdnResultTotalOU.Value = OutcomeResultID;
					AddJsVariable("PointOu", BetValue);
				}
				if ((BetTypeID==typeOu) && (isHome==againstHome) && (PeriodID==periodHalf))
				{
					txtTotalOUHalf.Text = Rate;
					hdnResultTotalOUHalf.Value = OutcomeResultID;
					AddJsVariable("PointOuHalf", BetValue);
				}

				//Money Line
				if ((BetTypeID==typeML) && (isHome==againstHome))
				{
					txtHomeTeam.Text = Rate;
					hdnResultHomeML.Value = OutcomeResultID;
					AddJsVariable("PointMLHome", "1");
				}
				if ((BetTypeID==typeML) && (isHome==againstAway))
				{
					hdnResultAwayML.Value = OutcomeResultID;
				}
			}
		}

		private void AddJsVariable(string theName, string theValue)
		{
			jsInitialize += String.Format("{0}='{1}';", theName, theValue);
		}

		private void InitJS()
		{
			if (IsPostBack)
			{
				if (nStateID >= stateReady)
				{
					jsInitialize = hdnJsInitialize.Value;
				}
				else
				{
					AddJsVariable("SubCategoryID", Request["comboSubCategory"]);
					AddJsVariable("AwayTeamID", Request["comboAway"]);
					AddJsVariable("HomeTeamID", Request["comboHome"]);
					AddJsVariable("StartDate", Request["comboDate"]);
					AddJsVariable("StartTime", Request["comboTime"]);

					AddJsVariable("PointHomeSpread", Request["comboHomeSpread"]);
					AddJsVariable("PointHomeSpreadHalf", Request["comboHomeSpreadHalf"]);
					AddJsVariable("PointOu", Request["comboTotalOU"]);
					AddJsVariable("PointOuHalf", Request["comboTotalOUHalf"]);
					AddJsVariable("PointMLHome", Request["comboHomeTeam"]);
					AddJsVariable("PointMLAway", Request["comboAwayTeam"]);
				}
			}
			AddJsVariable("DisplayResult", Convert.ToInt32(nStateID >= stateReady).ToString());

			Page.RegisterStartupScript("pageLoad","<script>" + jsInitialize + "</script>");
			hdnJsInitialize.Value = jsInitialize;

			comboCategory.Attributes["onchange"] = "FillSubCategory();FillPoint();FillTeam();return false;";
			comboSubCategory.Attributes["onchange"] = "FillPoint();FillTeam();return false;";

			btnConfirm.NavigateUrl = "Confirm";
			btnConfirm.oLink.Attributes["onclick"] = "return getConfirm();";

			btnProcess.NavigateUrl = "Process";
			btnProcess.oLink.Attributes["onclick"] = "return getProcess();";

			txtHomeScore.Attributes["onchange"] = "Calculate();";
			txtHomeScoreHalf.Attributes["onchange"] = "Calculate();";
			txtAwayScore.Attributes["onchange"] = "Calculate();";
			txtAwayScoreHalf.Attributes["onchange"] = "Calculate();";
		}
		#endregion

		#region Display controls
		private void DisplayControls()
		{
			bool bReady  = (nStateID == stateReady);
			bool bActive = (nStateID >= stateActive);
			bool bConfirm = bReady || bActive;
			bool bSave  = nEventID > 0;

			//btnSave.Visible = !bConfirm;
			btnSave.Visible = !bSave;
			btnConfirm.Visible = (bSave) && (!bConfirm);
			btnProcess.Visible = bReady;

			if (bReady || bActive) DisableAllControls();
			if (bActive) return;

			//Score fields
			HideControl(lblAwayScore, bConfirm, bReady);
			HideControl(lblHomeScore, bConfirm, bReady);
			HideControl(txtAwayScore, bConfirm, bReady);
			HideControl(txtHomeScore, bConfirm, bReady);

			//Half Time Score fields
			HideControl(lblAwayScoreHalf, bConfirm, bReady);
			HideControl(lblHomeScoreHalf, bConfirm, bReady);
			HideControl(txtAwayScoreHalf, bConfirm, bReady);
			HideControl(txtHomeScoreHalf, bConfirm, bReady);
		}

		private void HideControl(WebControl webControl, bool bConfirm, bool bReady)
		{
			webControl.Visible = bConfirm;
			webControl.Enabled = bReady;
		}


		private void DisableAllControls()
		{
			foreach(Control control in Page.Controls)
			{
				System.Type type = control.GetType();
				if (type.FullName == "System.Web.UI.HtmlControls.HtmlForm")
				{
					foreach(Control formControl in control.Controls)
					{
						WebControl webControl = formControl as WebControl;
						if (webControl != null) webControl.Enabled = false;
						Label label = formControl as Label;
						if (label != null) label.Enabled = true;
					}
				}
			}
		}
		#endregion

		#region Fill ComBoxes
		private void FillComboBoxes()
		{
			GetCategoriesCombo();
			PrepareJSCombos();
		}

		private void GetCategoriesCombo()
		{
			DBase.FillList(comboCategory, nCategoryID, Config.DbGetSBCategoryListSimple, false);
		}

		private void PrepareJSCombos()
		{
			DataTable oDT = GetDataTable(Config.DbGetSBSubCategoryAndTeamList);
			DataView  oDV = new DataView(oDT);
			string insideRowDelimeter = ",";
			string betweenRowDelimeter = ";";
			string subCategoryList = "";
			string TeamList = "";
			int oldSubCategoryID = -1;
			int newSubCategoryID = -1;
			foreach(DataRowView oDR in oDV)
			{
				newSubCategoryID = Utils.GetInt(oDR["SubCategoryID"]);
				if (newSubCategoryID != oldSubCategoryID)
				{
					//Subcategories Names
					subCategoryList += oDR["CategoryID"].ToString() + insideRowDelimeter;
					subCategoryList += oDR["SubCategoryID"].ToString() + insideRowDelimeter;
					subCategoryList += oDR["SubCategoryName"].ToString() + insideRowDelimeter;
					oldSubCategoryID = newSubCategoryID;

					//Spread and Ou intervals
					subCategoryList += oDR["SpreadFrom"] + insideRowDelimeter;
					subCategoryList += oDR["SpreadTo"] + insideRowDelimeter;
					subCategoryList += oDR["SpreadStep"] + insideRowDelimeter;
					subCategoryList += oDR["OuFrom"]+ insideRowDelimeter;
					subCategoryList += oDR["OuTo"] + insideRowDelimeter;
					subCategoryList += oDR["OuStep"] + betweenRowDelimeter;
				}
				
				//Team Names
				TeamList += oDR["SubCategoryID"].ToString() + insideRowDelimeter;
				TeamList += oDR["TeamID"].ToString() + insideRowDelimeter;
				TeamList += oDR["TeamName"].ToString() + betweenRowDelimeter;
			}
			if ((subCategoryList.Length>0) &&
				(subCategoryList.LastIndexOf(betweenRowDelimeter) == subCategoryList.Length - betweenRowDelimeter.Length))
			{
				subCategoryList = subCategoryList.Substring(0, subCategoryList.Length - betweenRowDelimeter.Length);
			}
			hdnSubCategoryList.Value = subCategoryList;

			hdnTeamList.Value = TeamList;
		}

		#endregion


		#region Save/Confirm/Process Event Handlers
		protected void btnConfirm_Click(object sender, System.EventArgs e)
		{
			//1. Invoke Com
			object StartDate = Utils.GetDbDate(Request["comboDate"] + " " + Request["comboTime"] + ":00");
			string sRet = InvokeCom(StartDate, sGuid, stateActive);  //Comments: when now will be StartDate system changes status to stateActive
			if (sRet == null) return;
			sGuid = sRet;

			//2. Save changes in DB
			if (!SaveData(stateReady)) return;

			//Everything is Ok
			lblInfo.ForeColor = Color.Green;
			lblInfo.Text = "Event was went for birds";
			nStateID = stateReady;
			hdnStateID.Value = nStateID.ToString();
			hdnGuid.Value = sGuid;

			//Response.Redirect(GetGoBackUrl());

			InitJS();
			DisplayControls();
		}

		protected void btnProcess_Click(object sender, System.EventArgs e)
		{
			string tranName = "ProcessEvent";
			DBase.BeginTransaction(tranName);
			//1. Save Event Score
			int nRes = DBase.ExecuteNonQuery(Config.DbSaveEventScore,
				"@EventID", nEventID, 
				"@HomeScore", txtHomeScore.Text,
				"@AwayScore", txtAwayScore.Text,
				"@HomeScoreHalf", txtHomeScoreHalf.Text,
				"@AwayScoreHalf", txtAwayScoreHalf.Text,
				"@StateID", stateProcessing); 
			if (nRes<0)
			{
				ShowError("DataBase error occured");
				DBase.RollbackTransaction(tranName);
				return;
			}

			//2. Update Outcomes
			DataTable oDT = DBase.GetDataTableBatch(string.Format(Config.DbUpdateOutcome, nEventID));
			DataColumn[] PrimaryKeyArray = new DataColumn[1];
			PrimaryKeyArray[0] = oDT.Columns["ID"];
			oDT.PrimaryKey = PrimaryKeyArray;

			int HomeScore     = Utils.GetInt(txtHomeScore.Text);
			int HomeScoreHalf = Utils.GetInt(txtHomeScoreHalf.Text);
			int AwayScore     = Utils.GetInt(txtAwayScore.Text);
			int AwayScoreHalf = Utils.GetInt(txtAwayScoreHalf.Text);

			foreach(DataRow oRow in oDT.Rows)
			{
				int BetTypeID = Utils.GetInt(oRow["BetTypeID"]);
				int IsHome    = Utils.GetInt(oRow["IsHome"]);
				int PeriodID  = Utils.GetInt(oRow["PeriodID"]);
				switch (BetTypeID)
				{
					case typeSpread:
						if (IsHome == againstHome)
						{
							oRow["WonValue"] = HomeScore - AwayScore;
						}
						else
						{
							oRow["WonValue"] = AwayScore - HomeScore;
						}

						if (PeriodID == periodFull)
						{
							oRow["OutcomeResultID"] = hdnResultHomeSpread.Value;
						}
						else
						{
							oRow["OutcomeResultID"] = hdnResultHomeSpreadHalf.Value;
						}
						break;
					case typeOu:
						oRow["WonValue"] = HomeScore + AwayScore;

						if (PeriodID == periodFull)
						{
							oRow["OutcomeResultID"] = hdnResultTotalOU.Value;
						}
						else
						{
							oRow["OutcomeResultID"] = hdnResultTotalOUHalf.Value;
						}
						break;
					case typeML:
						if (IsHome == againstHome)
						{
							oRow["OutcomeResultID"] = hdnResultHomeML.Value;
						}
						else
						{
							oRow["OutcomeResultID"] = hdnResultAwayML.Value;
						}
						break;
				}
			}


			bool bRes = DBase.Update(oDT);
			if (!bRes)
			{
				ShowError("DataBase error occured during puting results");
				DBase.RollbackTransaction(tranName);
				return;
			}

			//3. Processing Bets
			int nRes2 = DBase.ExecuteNonQuery(Config.DbProcessBetsOnEventFinish, "@EventID", nEventID);
			if (nRes2<0)
			{
				ShowError("DataBase error occured in nprocessing Bets");
				DBase.RollbackTransaction(tranName);
				return;
			}

			//Commit transaction
			DBase.CommitTransaction(tranName);


			//4. Invoke Com
			object StartDate = DateTime.Now;
			string sRet = InvokeCom(StartDate, sGuid, stateProcessing);
			if (sRet == null) return;
			sGuid = sRet;

			// Everything is Ok
			nStateID = stateProcessing; 
			hdnStateID.Value = nStateID.ToString();
			hdnGuid.Value = sGuid;
			lblInfo.ForeColor = Color.Green;
			lblInfo.Text = "Event was processed successfully";

			//Response.Redirect(GetGoBackUrl());

			GetPageData();
			InitJS();
			DisplayControls();
		}

		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			if (!SaveData(statePending)) return;

			lblInfo.ForeColor = Color.Green;
			lblInfo.Text = "Event details have been saved";

			InitJS();
			DisplayControls();		
		}


		private bool SaveData(int stateID)
		{
			string tranName = "SaveEvent";
			DBase.BeginTransaction(tranName);
			//1. Save/Update Event
			object StartDate = Utils.GetDbDate(Request["comboDate"] + " " + Request["comboTime"] + ":00");
			int nRes = DBase.ExecuteReturnInt(Config.DbSaveEvent, 
				"@EventID", nEventID,
				"@StateID", stateID,
				"@StartSchedule", sGuid,
				"@SubCategoryID", Request["comboSubCategory"],
				"@AwayTeamID", Request["comboAway"],
				"@HomeTeamID", Request["comboHome"],
				"@StartDate", StartDate);
			if (nRes <= 0)
			{
				ShowError("Database error occured");
				DBase.RollbackTransaction(tranName);
				return false;
			}

			//2. Update Outcomes
			decimal Rate = 0;
			decimal Point = 0;
			bool isSave = false;
			string sPoint = "";
			DataTable oDT = DBase.GetDataTableBatch(string.Format(Config.DbUpdateOutcome, nRes));
			DataColumn[] PrimaryKeyArray = new DataColumn[4];
			PrimaryKeyArray[0] = oDT.Columns["EventID"];
			PrimaryKeyArray[1] = oDT.Columns["BetTypeID"];
			PrimaryKeyArray[2] = oDT.Columns["isHome"];
			PrimaryKeyArray[3] = oDT.Columns["PeriodID"];
			oDT.PrimaryKey = PrimaryKeyArray;

			//Home Spread
			Rate = Utils.GetDecimal(txtHomeSpread.Text);
			sPoint = Request["comboHomeSpread"];
			Point = Utils.GetDecimal(sPoint);
			isSave = isNumber(sPoint);
			UpdateRow(oDT, nRes, typeSpread, againstHome, periodFull, Rate, Point, isSave);
			UpdateRow(oDT, nRes, typeSpread, againstAway, periodFull, -Rate, -Point, isSave);
			Rate = Utils.GetDecimal(txtHomeSpreadHalf.Text);
			sPoint = Request["comboHomeSpreadHalf"];
			Point = Utils.GetDecimal(sPoint);
			isSave = isNumber(sPoint);
			UpdateRow(oDT, nRes, typeSpread, againstHome, periodHalf, Rate, Point, isSave);
			UpdateRow(oDT, nRes, typeSpread, againstAway, periodHalf, -Rate, -Point, isSave);
			//Over Under
			Rate = Utils.GetDecimal(txtTotalOU.Text);
			sPoint = Request["comboTotalOU"];
			Point = Utils.GetDecimal(sPoint);
			isSave = isNumber(sPoint);
			UpdateRow(oDT, nRes, typeOu, againstHome, periodFull, Rate, Point, isSave);
			UpdateRow(oDT, nRes, typeOu, againstAway, periodFull, -Rate, -Point, isSave);
			Rate = Utils.GetDecimal(txtTotalOUHalf.Text);
			sPoint = Request["comboTotalOUHalf"];
			Point = Utils.GetDecimal(sPoint);
			isSave = isNumber(sPoint);
			UpdateRow(oDT, nRes, typeOu, againstHome, periodHalf, Rate, Point, isSave);
			UpdateRow(oDT, nRes, typeOu, againstAway, periodHalf, -Rate, -Point, isSave);
			//ML
			Rate = Utils.GetDecimal(txtHomeTeam.Text);
			sPoint = Request["comboHomeTeam"];
			Point = Utils.GetDecimal(sPoint);
			isSave = isNumber(sPoint);
			UpdateRow(oDT, nRes, typeML, againstHome, periodFull, Rate, Point, isSave);
			UpdateRow(oDT, nRes, typeML, againstAway, periodFull, -Rate, -Point, isSave);

			bool bRes = DBase.Update(oDT);
			if (!bRes)
			{
				ShowError("DataBase error occured during saving Outcomes");
				DBase.RollbackTransaction(tranName);
				return false;
			}


			// Everything is Ok
			DBase.CommitTransaction(tranName);
			nEventID = nRes;
			StoreBackID(nRes);
			hdnEventID.Value = nRes.ToString();
			return true;
		}


		private bool isNumber(object theValue)
		{
			bool bResult  = false;
			try
			{
				decimal decValue = Convert.ToDecimal(theValue);
				bResult  = true;
			}
			catch{}
			return bResult;
		}

		private void UpdateRow(DataTable oDT, int EventID, int BetTypeID, int isHome, int PeriodID, decimal Rate, decimal BetValue, bool isSave)
		{
			if (Rate == 0)
			{
				Rate = defaultEuroRate;
			}
			else
			{
				Rate = Components.BetPriceConvert.Usa2Euro(Rate);
			}
			DataRow oRow = oDT.Rows.Find(new object[]{EventID, BetTypeID, isHome, PeriodID});
			if (oRow==null)
			{
				if (isSave)
				{
					oDT.Rows.Add(new object[]{System.DBNull.Value, EventID, BetTypeID, isHome, PeriodID, Rate, BetValue});
				}
			}
			else
			{
				if (isSave)
				{
					oRow["Rate"] = Rate;
					oRow["BetValue"] = BetValue;
				}
				else
				{
					oRow.Delete();
				}
			}
		}

		private void ShowError(string param)
		{
			lblInfo.ForeColor = Color.Red;
			lblInfo.Text = param;
			InitJS();
			DisplayControls();
		}

		#endregion

		#region Com
		public static DateTime GetDateTimeObj(object obj)
		{
			DateTime dtRes = Convert.ToDateTime("01/01/1900");
			try
			{
				dtRes = Convert.ToDateTime(obj);
			}
			catch{}
			return dtRes;
		}

		private string InvokeCom(object objDate, string sGuid, int stateID)
		{
			DateTime dtDate = GetDateTimeObj(objDate);
			AdminControls.ApiControlClass  oApi = new AdminControls.ApiControlClass();

		//	PokerControls.ApiClass oApi = (PokerControls.ApiClass)Common.Com.Remote.CreateCom("poApi.Api", Config.ComServer);

			int errorCode = 0;
			string sResult = "";
			if (stateID<stateProcessing)
			{
				string comData = string.Format("<objects xmlns='nsAction'><object name='pobuddywager.buddywager'><actions xmlns='nsAction'><sbchangeeventstatus eventid='{0}' eventstateid='{1}'/></actions></object></objects>", nEventID, stateID);
				if ((objDate == System.DBNull.Value) && (sGuid!=""))
				{
					errorCode = oApi.RemoveRemind(sGuid);
				}
				if (objDate != System.DBNull.Value)
				{
					if (sGuid=="")
					{
						errorCode = oApi.CreateRemind(0, 0, dtDate, comData, out sResult);
					}
					else  
					{
						oApi.ChangeRemind(0, 0, dtDate, comData, sGuid);
						if (errorCode == 0) sResult = sGuid;
					}
				}
			}
			else
			{
				string comData = string.Format("<objects xmlns='nsAction'><object name='pobuddywager.buddywager'><actions xmlns='nsAction'><sbresolveeventbetlines eventid='{0}'/></actions></object></objects>", nEventID);
				errorCode = oApi.CreateRemind(0, 0, dtDate, comData, out sResult);
			}

			oApi=null;
			if (errorCode != 0)
			{
				Log.Write(this, string.Format("Error code:\t{0}", errorCode));
				ShowError("Com Error occured.");
				return null;
			}

			return sResult;
		}

		#endregion

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
