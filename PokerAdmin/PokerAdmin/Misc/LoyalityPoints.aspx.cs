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
using Common ; 
using Common.Web;

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for BonusRules.
	/// </summary>
	public class LoyalityPoints : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Table tblMain;
		protected System.Web.UI.WebControls.Label lblError;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			if(!IsPostBack)
			{
				BindData();
			}

		}

		private void BindData()
		{
			DataTable oDT = DBase.GetDataTable(Config.DbGetLoyalityPoints);
			foreach(DataRow oDR in oDT.Rows)
			{
				//create table row
				TableRow oTR = new TableRow();;
				oTR.CssClass = "cssReportItemOdd";
				//create table cell and populate it with text of config name
				TableCell oTC = new TableCell();
				oTC.Text = oDR["Name"].ToString();
				oTR.Cells.Add(oTC);

				oTC = new TableCell();
				int nID = Utils.GetInt(oDR["id"]);
				TextBox oTB = new TextBox();
				oTB.MaxLength = 30;
				oTB.Width=Unit.Percentage(100);
				oTB.ID = string.Format("MinValueForPoint_{0}", nID);
				oTB.Text = oDR["MinValueForPoint"].ToString();
				oTC.Controls.Add(oTB);
				oTR.Cells.Add(oTC);

				oTC = new TableCell();
				 nID = Utils.GetInt(oDR["id"]);
				 oTB = new TextBox();
				oTB.MaxLength = 30;
				oTB.Width=Unit.Percentage(100);
				oTB.ID = string.Format("PointsValue_{0}", nID);
				oTB.Text = oDR["PointsValue"].ToString();
				oTC.Controls.Add(oTB);
				oTR.Cells.Add(oTC);

				oTC = new TableCell();
				 nID = Utils.GetInt(oDR["id"]);
				 oTB = new TextBox();
				oTB.MaxLength = 50;
				oTB.Width=Unit.Percentage(100);
				oTB.ID = string.Format("NameSQLProcedure_{0}", nID);
				oTB.Text = oDR["NameSQLProcedure"].ToString();
				oTC.Controls.Add(oTB);
				oTR.Cells.Add(oTC);

				//add rows to table
				tblMain.Rows.Add(oTR);
			}
		}

		private int GetID(string sKey, string Key)
		{
			if (sKey.StartsWith(Key))
			{
				return Utils.GetInt(sKey.Substring(Key.Length));
			}
			else
				return -1;
		}

		private void SetValue(DataView oDV,int nID,string fld,string sKey)
		{
			oDV.RowFilter = string.Format("[id]={0}", nID);
			if ( oDV.Count == 1)
			{	// Update exists row
				oDV[0][fld] = Request[sKey];
			}
		}

		public void btnSave_click(object sender, System.EventArgs e)
		{
			bool bRes = false;
			//Start transaction - we need update all records or none
			DBase.BeginTransaction("admWebSaveLoyalityPoints");
			DataTable oDT = DBase.GetDataTableBatch(Config.DbUpdateLoyalityPoints);
			if ( oDT != null )
			{
				DataView oDV = new DataView(oDT);
                int nID=0;
				foreach(string sKey in Request.Form.AllKeys)
				{
					nID =GetID(sKey,"MinValueForPoint_");
					if ( nID > 0 )   SetValue(oDV, nID,"MinValueForPoint",sKey);
					nID =GetID(sKey,"PointsValue_");
					if ( nID > 0 )   SetValue(oDV, nID,"PointsValue",sKey);
					nID =GetID(sKey,"NameSQLProcedure_");
					if ( nID > 0 )   SetValue(oDV, nID,"NameSQLProcedure",sKey);
				}

				bRes = DBase.Update(oDT);
			}

			if ( bRes )
			{
				//Commit successful transaction
				DBase.CommitTransaction("admWebSaveLoyalityPoints");
				BindData();
				lblError.Text = "Data has been saved";
				lblError.ForeColor = Color.Green;
			}
			else
			{
				//Rollback transaction in error ocurred
				DBase.RollbackTransaction("admWebSaveLoyalityPoints");
				lblError.Text = "DataBase error occured";
				lblError.ForeColor = Color.Red;
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
