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

namespace Admin.Categories
{
	/// <summary>
	/// Summary description for SBSubCategoryDetails.
	/// </summary>
	public class SBSubCategoryDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.WebControls.DropDownList comboCategory;

		protected Controls.ButtonImage btnSave;
		protected Controls.ButtonImage btnTeamAdd;
		protected Controls.ButtonImage btnTeamDelete;

		protected int nSubCategoryID = 0;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnID;
		protected System.Web.UI.WebControls.Table tblTeam;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnTeamCSV;
		protected System.Web.UI.WebControls.CustomValidator CustomValidator1;
		protected System.Web.UI.WebControls.TextBox txtSpreadFrom;
		protected System.Web.UI.WebControls.TextBox txtSpreadTo;
		protected System.Web.UI.WebControls.TextBox txtSpreadStep;
		protected System.Web.UI.WebControls.TextBox txtOuFrom;
		protected System.Web.UI.WebControls.TextBox txtOuTo;
		protected System.Web.UI.WebControls.TextBox txtOuStep;
		protected int nCategoryID = 0;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
				nSubCategoryID = GetMainParamInt(hdnID);

			BackPageUrl= (string) Session["SBSubCategoryMaintenanceUrl"];

			if ( !IsPostBack )
			{
				DataRow oDR = GetFirstRow(Config.DbGetSBSubCategoryDetails, new object[]{"@id", nSubCategoryID});
				if ( oDR != null )
				{
					//btnSave.Visible = false;
					txtName.Text       = oDR["Name"].ToString();
					nCategoryID        = Utils.GetInt(oDR["CategoryID"]);
					txtSpreadFrom.Text = oDR["SpreadFrom"].ToString();
					txtSpreadTo.Text   = oDR["SpreadTo"].ToString();
					txtSpreadStep.Text = oDR["SpreadStep"].ToString();
					txtOuFrom.Text     = oDR["OuFrom"].ToString();
					txtOuTo.Text       = oDR["OuTo"].ToString();
					txtOuStep.Text     = oDR["OuStep"].ToString();

					txtName.Enabled       = false;
					comboCategory.Enabled = false;
					txtSpreadFrom.Enabled = false;
					txtSpreadTo.Enabled   = false;
					txtSpreadStep.Enabled = false;
					txtOuFrom.Enabled     = false;
					txtOuTo.Enabled       = false;
					txtOuStep.Enabled     = false;
				}
				DBase.FillList(comboCategory, nCategoryID, Config.DbGetDictionarySBCategoryList, false);
				BindTeam();
			}
			InitJS();
		}

		private void BindTeam()
		{
			DataTable oDT = GetDataTable(Config.DbGetSubcategoryTeam, new object[]{"@SubcategoryID", nSubCategoryID});
			DataView  oDV = new DataView(oDT);
			//string insideRowDelimeter = ",";
			string betweenRowDelimeter = ";";
			string csvTeam = "";
			foreach(DataRowView oDR in oDV)
			{
				csvTeam += oDR["Name"].ToString();
				csvTeam += betweenRowDelimeter;
			}
			if ((csvTeam.Length>0) &&
				(csvTeam.LastIndexOf(betweenRowDelimeter) == csvTeam.Length - betweenRowDelimeter.Length))
			{
				csvTeam = csvTeam.Substring(0, csvTeam.Length - betweenRowDelimeter.Length);
			}
			hdnTeamCSV.Value = csvTeam;
		}


		protected void InitJS()
		{
			//Add Team
			btnTeamAdd.NavigateUrl = "New";
			btnTeamAdd.oLink.Attributes["onclick"] = "AddNewRow(); return false;";

			//Delete Team
			btnTeamDelete.NavigateUrl = "Delete";
			btnTeamDelete.oLink.Attributes["onclick"] = "DeleteSelectedRow(); return false;";
		}


		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			int nRes = nSubCategoryID;
			string tranName = "SaveSubcategory";
			DBase.BeginTransaction(tranName);

			//1. Save subcategory info
			if (nSubCategoryID<=0)
			{
				nRes = DBase.ExecuteReturnInt(Config.DbSaveSBSubCategory, 
					new object[]{"@id", nSubCategoryID, 
									"@CategoryID", Core.GetSelectedValueInt(comboCategory), 
									"@name", txtName.Text,
									"@SpreadFrom", txtSpreadFrom.Text,
									"@SpreadTo", txtSpreadTo.Text,
									"@SpreadStep", txtSpreadStep.Text,
									"@OuFrom", txtOuFrom.Text,
									"@OuTo", txtOuTo.Text,
									"@OuStep", txtOuStep.Text});

				if (nRes<=0)
				{
					lblInfo.ForeColor = Color.Red;
					switch( nRes )
					{
						case -1:
							lblInfo.Text = "Typed subcategory name already exists";
							break;
						case 0 :
							lblInfo.Text = "Database error occured";
							break;
						default:
							lblInfo.Text = "Unknown error occured";
							break;
					}
					DBase.RollbackTransaction(tranName);
					return;
				}	
			}

			//2. Update Team info
			int nRes2 = DBase.ExecuteNonQuery(Config.DbSaveTeamTable, "@SubcategoryID", nRes,
				"@TeamValues", hdnTeamCSV.Value);
			if (nRes2 < 0)
			{
				DBase.RollbackTransaction(tranName);
				lblInfo.Text = "DB erors occured during processing Team Table";
				lblInfo.ForeColor = Color.Red;
				return;
			}

			DBase.CommitTransaction(tranName);
			lblInfo.ForeColor = Color.Green;
			lblInfo.Text = "SubCategory details have been saved";
			StoreBackID(nRes);
			hdnID.Value = nRes.ToString();
			//BindTeam();

			Response.Redirect(GetGoBackUrl());
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
