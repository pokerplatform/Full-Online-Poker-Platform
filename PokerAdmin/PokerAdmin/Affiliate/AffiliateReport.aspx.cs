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

namespace Admin.Affiliate
{
	/// <summary>
	/// Summary description for AffiliateReport.
	/// </summary>
	public class AffiliateReport: Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.TextBox txtDateTo;
		protected System.Web.UI.HtmlControls.HtmlInputCheckBox chSummary;
		protected System.Web.UI.WebControls.DropDownList ddAffiliates;
		protected System.Web.UI.WebControls.TextBox txtDateFrom;
		protected System.Web.UI.WebControls.DataGrid dgAllAffil;
		protected System.Web.UI.WebControls.DataGrid dgAffilPeriod;
		protected System.Web.UI.WebControls.Label lbMessage;
		protected System.Web.UI.WebControls.Label lbRakeSum;
		protected System.Web.UI.WebControls.Label lbSumCaption;
		protected System.Web.UI.HtmlControls.HtmlInputCheckBox chAllAffiliates;

		protected override void Page_Load(object sender, System.EventArgs e)
		{
				ddAffiliates.Enabled =!chAllAffiliates.Checked; 
			    chSummary.Disabled  = !chAllAffiliates.Checked; 
			    if(!chAllAffiliates.Checked) chSummary.Checked =false;  
			if(!IsPostBack)
			{
				lbRakeSum.Text="0";
				lbRakeSum.Visible =false;
				lbSumCaption.Visible =false;
				DBase.FillList(ddAffiliates, -1, Config.DbGetAffiliateList, false);
			}
		}

		protected void btnReport_Click(object sender, System.EventArgs e)
		{
			DataTable tb=null;
			dgAllAffil.Visible =false;
			dgAffilPeriod.Visible =false; 
			dgAffilPeriod.Columns[0].Visible =true;  
			dgAffilPeriod.Columns[1].Visible =true;  
			lbRakeSum.Text="0";
			lbRakeSum.Visible =false;
			lbSumCaption.Visible =false;

			if(!CheckDate(txtDateFrom.Text) || !CheckDate(txtDateTo.Text))
			{
				lbMessage.Text ="Enter correct values for [Date] fields, please";
				return;
			}

			if (chAllAffiliates.Checked && chSummary.Checked)
			{
				tb=DBase.GetDataTable(Config.DbGetAffiliateInfoForAll,new object[] {"@DateFrom",txtDateFrom.Text,"@DateTo",txtDateTo.Text } );
				dgAllAffil.Visible =true;
				dgAllAffil.DataSource =tb.DefaultView;
				dgAllAffil.DataBind(); 
			}
			if (chAllAffiliates.Checked && !chSummary.Checked)
			{
				tb=DBase.GetDataTable(Config.DbGetAffiliateInfo,new object[] {"@DateFrom",txtDateFrom.Text,"@DateTo",txtDateTo.Text } );
				dgAffilPeriod.Visible =true;
				dgAffilPeriod.DataSource =tb.DefaultView;
				dgAffilPeriod.DataBind(); 
			}
			if (!chAllAffiliates.Checked && !chSummary.Checked)
			{
				tb=DBase.GetDataTable(Config.DbGetAffiliateInfo,new object[] {"@AffiliateID",ddAffiliates.SelectedValue , "@DateFrom",txtDateFrom.Text,"@DateTo",txtDateTo.Text } );
				dgAffilPeriod.Columns[0].Visible =false;  
				dgAffilPeriod.Columns[1].Visible =false;  
				dgAffilPeriod.Visible =true;
				dgAffilPeriod.DataSource =tb.DefaultView;
				dgAffilPeriod.DataBind(); 
			}
			lbRakeSum.Visible =true;
			lbSumCaption.Visible =true;
			Session["AffiliateReportData"]=tb;
		}

		private bool CheckDate(string dt)
		{
			try
			{
				DateTime tm=Convert.ToDateTime(dt); 
			}
			catch
			{
				return false;
			}
			return true;
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
			this.dgAllAffil.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.dgAllAffil_PageIndexChanged);
			this.dgAllAffil.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgAllAffil_ItemDataBound);
			this.dgAffilPeriod.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.dgAffilPeriod_PageIndexChanged);
			this.dgAffilPeriod.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgAffilPeriod_ItemDataBound);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void dgAllAffil_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if((e.Item.ItemType == ListItemType.Item) || 	(e.Item.ItemType == ListItemType.AlternatingItem))
			{
				try
				{
					lbRakeSum.Text =Convert.ToString ((Convert.ToDouble( lbRakeSum.Text) + Convert.ToDouble(e.Item.Cells[2].Text)));
				}
				catch{}
			}
		}

		private void dgAffilPeriod_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if((e.Item.ItemType == ListItemType.Item) || 	(e.Item.ItemType == ListItemType.AlternatingItem))
			{
				try
				{
					lbRakeSum.Text =Convert.ToString ((Convert.ToDouble( lbRakeSum.Text) + Convert.ToDouble(e.Item.Cells[6].Text)));
				}
				catch{}
			}
		}

		private void dgAllAffil_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			dgAllAffil.CurrentPageIndex = e.NewPageIndex;
			dgAllAffil.DataSource =((DataTable)Session["AffiliateReportData"]).DefaultView;
			dgAllAffil.DataBind(); 
		}

		private void dgAffilPeriod_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			dgAffilPeriod.CurrentPageIndex = e.NewPageIndex;
			dgAffilPeriod.DataSource =((DataTable)Session["AffiliateReportData"]).DefaultView;
			dgAffilPeriod.DataBind(); 
		}


	}
}
