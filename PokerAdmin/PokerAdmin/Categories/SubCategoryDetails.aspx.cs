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

using Common;
using Common.Web;

namespace Admin.Categories
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class SubCategoryDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.DropDownList comboCategory;
		protected System.Web.UI.WebControls.DropDownList comboStatus;
		protected System.Web.UI.WebControls.DataGrid gridRelatedProcess;
		protected System.Web.UI.HtmlControls.HtmlTableRow rowRelatedProcesses;
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnSubCategoryID;
	
		protected int nSubCategoryID = 0;
		protected int nStatusID = 1;
		protected System.Web.UI.WebControls.ListBox lstPresentStats;
		protected System.Web.UI.WebControls.ListBox lstOtherStats;
		protected System.Web.UI.HtmlControls.HtmlTableRow rowStats;
		protected System.Web.UI.HtmlControls.HtmlTable tblStats;
		protected int nCategoryID = 1;

		protected Controls.ButtonImage btnUp;
		protected Controls.ButtonImage btnDown;
		protected Controls.ButtonImage btnAttach;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnStatsList;
		protected System.Web.UI.WebControls.CustomValidator CustomValidator1;
		protected Controls.ButtonImage btnDetach;

		private void Page_Load(object sender, System.EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nSubCategoryID = GetMainParamInt(hdnSubCategoryID);

			BackPageUrl= (string) Session["SubCategoryMaintenanceUrl"];

			if ( !IsPostBack )
			{
				GetData();
				PreparePage();
				BindStatsList();
			}
			rowRelatedProcesses.Visible = (nSubCategoryID > 0);
			InitJS();
		}
	

		/// <summary>
		/// Fill both combo boxes
		/// </summary>
		protected void PreparePage()
		{
			DBase.FillList(comboStatus, nStatusID, Config.DbDictionaryStatus, false);
			DBase.FillList(comboCategory, nCategoryID, Config.DbDictionaryCategoryPoker, false);

			btnAttach.Text="&#8592;";
			btnDetach.Text="&#8594;";
			btnUp.Text="&#8593;";
			btnDown.Text="&#8595;";
		}

		/// <summary>
		/// Retrieve data will be placed on the page from the database
		/// </summary>
		protected void GetData()
		{
			if ( nSubCategoryID > 0 )
			{
				DataRow oDR = GetFirstRow(Config.DbGetSubCategoryDetails, new object[]{"@ID", nSubCategoryID});
				if ( oDR != null )
				{
					nStatusID = Utils.GetInt(oDR["StatusID"]);
					nCategoryID = Utils.GetInt(oDR["CategoryID"]);
					txtName.Text = oDR["Name"].ToString();

					BindRelatedProcessList();
				}
			}
		}

		protected void InitJS()
		{
			//Attach
			btnAttach.NavigateUrl = "Attach";
			btnAttach.oLink.Attributes["onclick"] = "Attach(); return false;";

			//Detach
			btnDetach.NavigateUrl = "Detach";
			btnDetach.oLink.Attributes["onclick"] = "Detach(); return false;";

			//Up
			btnUp.NavigateUrl = "Up";
			btnUp.oLink.Attributes["onclick"] = "UpRow(); return false;";

			//Up
			btnDown.NavigateUrl = "Down";
			btnDown.oLink.Attributes["onclick"] = "DownRow(); return false;";
			

			//Dbl click events
			lstPresentStats.Attributes["onDblClick"] = "Detach(); return false;";
			lstOtherStats.Attributes["onDblClick"] = "Attach(); return false;";
		}

		protected void BindStatsList()
		{
			tblStats.Visible = ( nSubCategoryID > 0 );
			if ( tblStats.Visible )
			{
				DataTable oDT = GetDataTable(Config.DbGetSubCategoryStatsPresent, new object[]{"@SubCategoryID", nSubCategoryID});
				Core.FillList(lstPresentStats, oDT);
				oDT = GetDataTable(Config.DbGetSubCategoryStatsOther, new object[]{"@SubCategoryID", nSubCategoryID});
				Core.FillList(lstOtherStats, oDT);
			}
		}
		protected void BindRelatedProcessList()
		{
			if ( rowRelatedProcesses.Visible )
			{
				DataTable oDT = GetDataTable(Config.DbGetSubCategoryRelatedProcess, new object[]{"@SubCategoryID", nSubCategoryID});
				if ( oDT != null && oDT.Rows.Count > 0 )
				{
					gridRelatedProcess.DataSource = oDT;
					gridRelatedProcess.DataBind();
				}
				else
				{
					rowRelatedProcesses.Visible = false;
				}
			}
		}

		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			string tranName = "UpdateSubCategoryStats";
			DBase.BeginTransaction(tranName);

			//1. Save/update Subcategory details
			SqlCommand oCmd = DBase.GetCommand(Config.DbSaveSubCategoryDetails);
			SqlParameterCollection oParams = oCmd.Parameters;

			oParams.Add("@ID", nSubCategoryID);
			oParams.Add("@Name", txtName.Text);
			oParams.Add("@StatusID", Core.GetSelectedValueInt(comboStatus));
			oParams.Add("@CategoryID", Core.GetSelectedValueInt(comboCategory));

			int nRes = DBase.ExecuteReturnInt(oCmd);
			if ( nRes <= 0 )
			{
				lblInfo.ForeColor = Color.Red;
				switch( nRes )
				{
					case -1:
						lblInfo.Text = "Typed category name already exists";
						break;
					default:
						lblInfo.Text = "Database error occured";
						break;
				}
				DBase.RollbackTransaction(tranName);
				return;
			}


			//2. update SubCategoryStats table
			DataTable oDT = DBase.GetDataTableBatch(string.Format(Config.DbUpdateSubCategoryStats, nRes));
			DataColumn[] PrimaryKeyArray = new DataColumn[2];
			PrimaryKeyArray[0] = oDT.Columns["SubCategoryID"];
			PrimaryKeyArray[1] = oDT.Columns["StatsTypeID"];
			oDT.PrimaryKey = PrimaryKeyArray;

			try
			{
				//a. Delete rows that are not any more in the list
				string[] statsList = hdnStatsList.Value.Split(',');
				int statsLen = statsList.Length;
				if (hdnStatsList.Value == "") statsLen = 0;
				int k = 0;
				while (k < oDT.Rows.Count)
				{
					DataRow oRow = oDT.Rows[k];
					bool bFind = false;
					for (int i=0; i<statsLen; i++)
					{
						if (oRow["StatsTypeID"].ToString()==statsList[i]) 
						{
							bFind = true;
						}
					}
					if (!bFind) 
					{
						oRow.Delete();
					}
					k++;
				}

				//b. Add/update order for the list
				for (int i=0; i<statsLen; i++)
				{
					DataRow oRow = oDT.Rows.Find(new object[]{nRes, statsList[i]});
					if (oRow==null)
					{
						oDT.Rows.Add(new object[]{nSubCategoryID, statsList[i], i+1});
					}
					else
					{
						if (Convert.ToInt32(oRow["Order"]) != i+1)
						{
							oRow["Order"] = i+1;
						}
					}
				}
			}
			catch(Exception oEx)
			{
				Log.Write(this, "DataTable operations Error: " + oEx.Message);
				DBase.RollbackTransaction(tranName);
				lblInfo.Text = "DataBase error occured during updating table";
				lblInfo.ForeColor = Color.Red;
				return;
			}

			bool bRes = DBase.Update(oDT);
			if (bRes)
			{
				DBase.CommitTransaction(tranName);
				hdnSubCategoryID.Value = nRes.ToString();
				StoreBackID(nRes);
				lblInfo.Text = "Category details have been saved";
				lblInfo.ForeColor = Color.Green;

				Response.Redirect(GetGoBackUrl());

				nSubCategoryID = nRes;
				BindStatsList();
				rowRelatedProcesses.Visible = true;
				BindRelatedProcessList();
			}
			else
			{
				DBase.RollbackTransaction(tranName);
				lblInfo.Text = "DataBase error occured during updating table";
				lblInfo.ForeColor = Color.Red;
			}

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

