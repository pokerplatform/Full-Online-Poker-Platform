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

using Common;
using Common.Web;
using Admin.CommonUse;

namespace Admin.Categories
{
	/// <summary>
	/// Summary description for SBCategoryDatails.
	/// </summary>
	public class SBCategoryDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnID;
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.WebControls.Table table;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnXML;
		protected PrizeTable oPrize = new PrizeTable();
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.CustomValidator CustomValidator1;
		protected Controls.ButtonImage btnAdd;
		protected Controls.ButtonImage btnDelete;
		string sXML = "";
		int nCategoryID = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{
			BackPageUrl= (string) Session["SBCategoryMaintenanceUrl"];    
			nCategoryID = GetMainParamInt(hdnID);
			oPrize.rowColNames = "Bet Count /  Play Money";
			sXML = hdnXML.Value;
			if ( !IsPostBack )
			{
				DataRow oDR = GetFirstRow(Config.DbGetSBCategoryDetails, new object[]{"@id", nCategoryID});
				if ( oDR != null )
				{
					txtName.Text = oDR["Name"].ToString();
					sXML = GenerateXML();
				}
				oPrize.FillTable(ref sXML, ref table, true, false);
				hdnXML.Value = sXML;
			}
			InitJS();
		}


		protected void InitJS()
		{
			//Add column/row
			btnAdd.NavigateUrl = "Add";
			btnAdd.oLink.Attributes["onclick"] = "AddNew(); return false;";

			//Delete column/rows
			btnDelete.NavigateUrl = "Delete";
			btnDelete.oLink.Attributes["onclick"] = "DeleteSelected(); return false;";
		}


		private void ShowError(string sError)
		{
			lblInfo.Text = sError;
			lblInfo.ForeColor = Color.Red;
		}


		/// <summary>
		/// Save event handler.
		/// </summary>
		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			//1. Get XML
			sXML = hdnXML.Value;
			oPrize.FillTable(ref sXML, ref table, true, false);  //fill table from xml

			//2. Save category in DB
			string tranNameTotal = "admSaveSBCategoryDetails";
			DBase.BeginTransaction(tranNameTotal);
			int nRes = DBase.ExecuteReturnInt(Config.DbSaveSBCategoryDetails, new object[]{"@id", nCategoryID, "@Name", txtName.Text});
			if (nRes<=0)
			{
				DBase.RollbackTransaction(tranNameTotal);
				lblInfo.ForeColor = Color.Red;
				switch( nRes )
				{
					case -1:
						lblInfo.Text = "Typed category name already exists";
						break;
					case 0 :
						lblInfo.Text = "Database error occured";
						break;
					default:
						lblInfo.Text = "Unknown error occured";
						break;
				}
				return;
			}	

            
			//3. Batch upload of Teaser Table
			try
			{
				DataTable xmlDT = oPrize.getDataTable(sXML); //DataTable from xml
				DataColumn[] PrimaryKeyArray = new DataColumn[3];
				PrimaryKeyArray[0] = xmlDT.Columns[PrizeTable.tblColName];
				PrimaryKeyArray[1] = xmlDT.Columns[PrizeTable.tblRowName];
				PrimaryKeyArray[2] = xmlDT.Columns[PrizeTable.tblValueName];
				xmlDT.PrimaryKey = PrimaryKeyArray;
				//using primary key we can update only recods that were changed
				DataTable oDT = DBase.GetDataTableBatch("select id, Points, BetCount, Rate, CategoryID from Teaser where categoryID = " + nRes.ToString() + " order by Points, BetCount");  //dataTable from SQL
				//clear all old data
				foreach(DataRow oDR in oDT.Rows)
				{
					DataRow oRow = xmlDT.Rows.Find(new object[3]{oDR["Points"].ToString(), oDR["BetCount"].ToString(), oDR["Rate"].ToString()});
					if (oRow!=null) oRow.Delete();
					else oDR.Delete();
				}
				//do we have any records to add 
				bool hasRecords = true;
				if (xmlDT.Rows.Count<1) hasRecords = false;
				if ((xmlDT.Rows.Count==1) && (xmlDT.Rows[0][PrizeTable.tblValueName].ToString()=="")) hasRecords = false;  //one record, but value is empty
				if (hasRecords)
				{
					//add new data
					foreach(DataRow oDR in xmlDT.Rows)
					{
						DataRow row = oDT.NewRow();
						row["Points"] = oDR[PrizeTable.tblColName];
						row["BetCount"] = oDR[PrizeTable.tblRowName];
						row["Rate"] = Utils.GetDecimal(oDR[PrizeTable.tblValueName]);
						row["CategoryID"] = nRes;
						oDT.Rows.Add(row);
					}
				}
				bool bRes = DBase.Update(oDT);
				if (!bRes)
				{
					DBase.RollbackTransaction(tranNameTotal);
					ShowError("DB error occured during Teaser data update.");
					return;
				}
			}
			catch(Exception oEx)
			{
				DBase.RollbackTransaction(tranNameTotal);
				ShowError("DB error occured during Teaser data update block.");
				Log.Write(this, oEx);
				return;
			}
			//End of Batch upload of Teaser Table
			 
			//4. Sucess message
			DBase.CommitTransaction(tranNameTotal);
			nCategoryID = nRes;
			StoreBackID(nRes);
			hdnID.Value = nRes.ToString();
			lblInfo.ForeColor = Color.Green;
			lblInfo.Text = "Category details have been saved";

			Response.Redirect(GetGoBackUrl());
		}


		protected string GenerateXML()
		{
			string nodeRootName  = PrizeTable.nodeRootName;
			string nodeColName   = PrizeTable.nodeColName;
			string nodeRowName   = PrizeTable.nodeRowName;
			string nodeValueName = PrizeTable.nodeValueName;

			string BetCount = "";
			string Points = "";
			string Rate = "";

			string oldValue = "";
			string retXml = ""; 
			retXml = "<" + nodeRootName + ">"; 
			DataTable oDT = DBase.GetDataTable(Config.DbGetCategoryTeaserList, "@CategoryID", nCategoryID);
			if (oDT.Rows.Count<=0) return "";
			foreach(DataRow oDR in oDT.Rows)
			{
				BetCount = "'" + oDR["BetCount"].ToString() + "'";
				Points	 = "'" + oDR["Points"].ToString() + "'";
				Rate	 = "'" + oDR["Rate"].ToString() + "'";
				if (oldValue!=Points){
					if (oldValue!="") retXml += "</" + nodeColName + ">";
					retXml += "<" + nodeColName + " from=" + Points + " to=" + Points + ">";
				}
				retXml += "<" + nodeRowName + " from=" + BetCount + " to=" + BetCount + " " + nodeValueName + "=" + Rate + "/>";
				oldValue = Points;
			}
			if (oldValue!="") retXml += "</" + nodeColName + ">";
			retXml += "</" + nodeRootName + ">"; 
			return retXml;
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
