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

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for MiscMaintenance.
	/// </summary>
	public class Options : Common.Web.Page
	{
		protected Controls.ButtonImage btnSave;
		protected System.Web.UI.WebControls.DataGrid oGrid;
		protected System.Web.UI.WebControls.Table tblMain;
		protected System.Web.UI.WebControls.Label lblError;

		protected string sPrevObjectName = string.Empty;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			lblError.EnableViewState = false;
			if ( !IsPostBack )
			{
				BindGrid();
			}
		}

		protected void BindGrid()
		{
			DataTable oDT = DBase.GetDataTable(Config.DbGetConfig);
			foreach(DataRow oDR in oDT.Rows)
			{
				//create table row
				TableRow oTR = new TableRow();;
				oTR.CssClass = "cssReportItemOdd";
				//create table cell and populate it with text of config name
				TableCell oTC = new TableCell();
				oTC.Text = GetObjectName(oDR);  //GetObjectName prevents to show the same names several times (first time it will be name, next time it will be &nbsp instead the same name
				oTR.Cells.Add(oTC);
				//create table cell and populate it with text of config detail name
				oTC = new TableCell();
				oTC.Text = oDR["PropertyName"].ToString();
				oTR.Cells.Add(oTC);
				//create table cell and populate it with config detail value
				oTC = new TableCell();
				int nID = Utils.GetInt(oDR["id"]);
				TextBox oTB = new TextBox();
				oTB.MaxLength = 7000;
				oTB.Width=Unit.Percentage(100);
				oTB.ID = string.Format("edtVal_{0}", nID);
				oTB.Text = oDR["PropertyValue"].ToString();
				oTC.Controls.Add(oTB);
				oTR.Cells.Add(oTC);
				//add rows to table
				tblMain.Rows.Add(oTR);
			}
		}


		protected void btnSave_click(object sender, System.EventArgs e)
		{
			bool bRes = false;
			//Start transaction - we need update all records or none
			DBase.BeginTransaction("admWebSaveOptions");
			DataTable oDT = DBase.GetDataTableBatch(Config.DbUpdateConfig);
			if ( oDT != null )
			{
				DataView oDV = new DataView(oDT);
				foreach(string sKey in Request.Form.AllKeys)
				{
					if ( sKey.StartsWith("edtVal_") )
					{
						int nID = Utils.GetInt(sKey.Substring(7));
						if ( nID > 0 ) // Must be positive integer
						{
							oDV.RowFilter = string.Format("[id]={0}", nID);
							if ( oDV.Count == 1)
							{	// Update exists row
								oDV[0]["PropertyValue"] = Request[sKey];
							}
						}
					}
				}

				bRes = DBase.Update(oDT);
			}

			if ( bRes )
			{
				//Commit successful transaction
				DBase.CommitTransaction("admWebSaveOptions");
				BindGrid();
				lblError.Text = "Data has been saved";
				lblError.ForeColor = Color.Green;
			}
			else
			{
				//Rollback transaction in error ocurred
				DBase.RollbackTransaction("admWebSaveOptions");
				lblError.Text = "DataBase error occured";
				lblError.ForeColor = Color.Red;
			}
		}


		#region Generate datagrid
		protected string GetObjectName(object oRow)
		{
			string sRes = "&nbsp;";
			DataRow oDR = (DataRow)oRow;
			string sName = oDR["ObjectName"].ToString();
			//string sName = ((DataRowView)oRow)["ObjectName"].ToString();
			if ( sName != sPrevObjectName )
			{
				sRes = sName;
				sPrevObjectName = sName;
			}
			return sRes;
		}

		protected string GetEdit(object oRow)
		{
			DataRowView oDR = (DataRowView)oRow;
			string sVal = Server.HtmlEncode(oDR["PropertyValue"].ToString());
			int nID = Utils.GetInt(oDR["id"]);
			return string.Format("<input type=text maxlength=\"7000\" name=edtVal_{0} id=edtVal_{0} style=\"width:100%\" value=\"{1}\">", nID, sVal);
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
