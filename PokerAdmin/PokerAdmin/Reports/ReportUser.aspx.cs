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

namespace Admin.Reports
{
	/// <summary>
	/// Summary description for GameProcessMaintenance.
	/// </summary>
	public class ReportUser : Common.Web.Page //Components.MaintenancePage
	{
		public int nAffiliateID = 0;
		public int nSexID = 0;
		public int nQualificationID = 0;
		protected System.Web.UI.WebControls.DropDownList comboSex;
		protected System.Web.UI.WebControls.DataGrid oGrid;
		protected System.Web.UI.WebControls.DropDownList comboEmailVerified;
		protected Admin.Controls.GridPager oSGridPager;
	

		private void Page_Load(object sender, System.EventArgs e)
		{
			if ( !IsPostBack )
			{
				PrepareCombo();
			}
			BindGrid();  //it was put here because I need build table each time I load page and it also condition to show pager object properly
		}

/*		<!--			<asp:BoundColumn DataField="InitialMoneyUsersCount" HeaderText="Initial Money Users"></asp:BoundColumn>
		<asp:BoundColumn DataField="QualifiedUsersCount" HeaderText="Qualified Users"></asp:BoundColumn>-->*/

		protected void BindGrid()
		{
			nSexID = Utils.GetInt(comboSex.Items[comboSex.SelectedIndex].Value);
		//	nQualificationID = Utils.GetInt(comboQualification.Items[comboQualification.SelectedIndex].Value);
			int nEmailVerified = Utils.GetInt(comboEmailVerified.Items[comboEmailVerified.SelectedIndex].Value);
			object objEmailVerified = nEmailVerified;
			if (nEmailVerified < -1) objEmailVerified = System.DBNull.Value;
			DataTable oDT = DBase.GetDataTable(Config.DbGetReportUserDetail, 
				"@SexID", ToDBNull(nSexID),
		//		"@QualificationID", ToDBNull(nQualificationID),
				"@IsEmailVerified", objEmailVerified);
			oSGridPager.DataSource = oDT;
			oSGridPager.BindGrid(oDT);
		}

		protected void PrepareCombo()
		{
			DBase.FillList(comboSex, nSexID, Config.DbDictionarySex, false);
			comboSex.Items.Insert(0, "All");
	/*		DBase.FillList(comboQualification, nQualificationID, Config.DbDictionaryQualification, true);
			comboQualification.Items.Insert(0, "All");*/
		}

		protected void btnApplyFilter_Click(object sender, System.EventArgs e)
		{
			//BindGrid();
		}

		protected object ToDBNull(int iValue)
		{
			object ret = iValue;
			if (iValue <= 0)
			{
				ret = System.DBNull.Value;
			}
			return ret;
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
