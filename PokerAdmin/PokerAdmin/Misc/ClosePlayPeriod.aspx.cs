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
using DesktopAPIEngine; 

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for ClosePlayPeriod.
	/// </summary>
	public class ClosePlayPeriod : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lbStatus;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnDisbledItem;
		protected System.Web.UI.WebControls.TextBox txtFrom;
		protected System.Web.UI.WebControls.TextBox txtTo;
		protected System.Web.UI.WebControls.CheckBox chAsSecondary;
		protected System.Web.UI.WebControls.CheckBox chAsResendTB;
		protected System.Web.UI.WebControls.DataGrid dgPeriod;

		private void Page_Load(object sender, System.EventArgs e)
		{
			if (! IsPostBack )
			{
				hdnDisbledItem.Value ="-1";
				DoDataBind();
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
			this.dgPeriod.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgPeriod_ItemCommand);
			this.dgPeriod.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.dgPeriod_PageIndexChanged);
			this.dgPeriod.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgPeriod_CancelCommand);
			this.dgPeriod.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgPeriod_EditCommand);
			this.dgPeriod.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgPeriod_UpdateCommand);
			this.dgPeriod.DeleteCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgPeriod_DeleteCommand);
			this.dgPeriod.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgPeriod_ItemDataBound);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		void DoDataBind()
		{
			DataTable tb=DBase.GetDataTable(Config.DbGetPlayPeriod);   
			dgPeriod.DataSource = tb.DefaultView;
			try
			{
				dgPeriod.DataBind();
			}
			catch
			{
				if (dgPeriod.CurrentPageIndex<0)  
					dgPeriod.CurrentPageIndex=0;
				else if (dgPeriod.CurrentPageIndex > dgPeriod.PageCount -1)
				{
					if( dgPeriod.PageCount >0)
						dgPeriod.CurrentPageIndex=dgPeriod.PageCount -1;
					else
						dgPeriod.CurrentPageIndex=0;
				}
				dgPeriod.DataBind();
			}
		}		

		private void dgPeriod_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			lbStatus.Text="";
			int mID=Utils.GetInt(e.Item.Cells[0].Text);
			DateTime dtFrom;
			DateTime dtTo;
			hdnDisbledItem.Value ="-1";  
			try
			{
				dtFrom= DateTime.Parse(((TextBox)(e.Item.Cells[1].Controls[0])).Text); 
			}
			catch
			{
				lbStatus.Text="Error Date From Value";
				lbStatus.ForeColor =Color.Red;
				return;
			}
			try
			{
				dtTo= DateTime.Parse(((TextBox)(e.Item.Cells[2].Controls[0])).Text); 
			}
			catch
			{
				lbStatus.Text="Error Date To Value";
				lbStatus.ForeColor =Color.Red;
				return;
			}

			if(dtFrom >= dtTo)
			{
				lbStatus.Text="Error Date Interval";
				lbStatus.ForeColor =Color.Red;
				return;
			}

			DBase.Execute(Config.DbSavePlayPeriod, new object[]{"@ID",mID,"@DateFrom",dtFrom,"@DateTo",dtTo});   
			dgPeriod.EditItemIndex = -1;
			DoDataBind();
		}

		private void dgPeriod_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			 if (e.Item.DataItem ==null) return;
			    bool rez=((bool)((DataRowView)e.Item.DataItem).Row ["IsClosed"]);
					e.Item.Cells[7].Text=(rez==true?"Yes":"No");
			((LinkButton)  e.Item.Cells[6].Controls[0]).Enabled =!rez;  
			if ((Utils.GetInt(hdnDisbledItem.Value)) == e.Item.ItemIndex)
			{
				((LinkButton)  e.Item.Cells[5].Controls[0]).Enabled =false;  
				((LinkButton)  e.Item.Cells[6].Controls[0]).Enabled =false;  
			}
		}

		private void dgPeriod_DeleteCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			lbStatus.Text="";
		     int mID=Utils.GetInt(e.Item.Cells[0].Text);
			DBase.Execute(Config.DbDeletePlayPeriod,new object[] {"@ID",mID});   
			DoDataBind();
		}

		private void dgPeriod_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			lbStatus.Text="";
			dgPeriod.CurrentPageIndex = e.NewPageIndex;
			DoDataBind();
		}

		private void dgPeriod_CancelCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			lbStatus.Text="";
			dgPeriod.EditItemIndex = -1;
			hdnDisbledItem.Value ="-1";  
			DoDataBind();
		}

		private void dgPeriod_EditCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			lbStatus.Text="";
			dgPeriod.EditItemIndex = e.Item.ItemIndex;
			hdnDisbledItem.Value =e.Item.ItemIndex.ToString();  
			DoDataBind();
		}

		protected  void  btEnableCln_Click(object sender, System.EventArgs e)
		{
			ApiControl  admC =Config.GetApIEngine() ;
			try
			{
				admC.ChangeClientConnectionsAllowedStatus(1); 
				lbStatus.Text="Client Connections Enabled";
				lbStatus.ForeColor =Color.Green;  
			}
			catch
			{
				lbStatus.Text="Error during enable Client Connections";
				lbStatus.ForeColor =Color.Red;  
			}
			finally
			{
				admC=null;				
			}
		}
		protected  void  btSystemShut_Click(object sender, System.EventArgs e)
		{
			ApiControl  admC =Config.GetApIEngine() ;
			try
			{
				admC.ChangeClientConnectionsAllowedStatus(4); 
				lbStatus.Text="Client Connections Allowed Status changed to Shutdown";
				lbStatus.ForeColor =Color.Green;  
			}
			catch
			{
				lbStatus.Text="Client Connections Allowed Status change error";
				lbStatus.ForeColor =Color.Red;  
			}
			finally
			{
               admC=null;				
			}
		}

		protected  void btnAddRow_Click(object sender, System.EventArgs e)
		{
			DBase.Execute(Config.DbSavePlayPeriod, new object[]{"@ID",-1,"@DateFrom",DateTime.Now ,"@DateTo",DateTime.Now});   
			DoDataBind();
		}

		protected  void btnCreateWeekly_Click(object sender, System.EventArgs e)
		{
			try
			{
				lbStatus.Text="";
				DateTime dtb=DateTime.Parse( txtFrom.Text);
				DateTime dte=DateTime.Parse( txtTo.Text);
				CreateReport(dtb,dte, Reports.cpReportType.Weekly,chAsSecondary.Checked );
			}
			catch
			{
				lbStatus.Text="Error Parameters";
				lbStatus.ForeColor =Color.Red;  
			}
		}

		private void CreateReport(DateTime dtb,DateTime dte,Reports.cpReportType type,bool asSec)
		{
             Reports.IClosePeriodReport rp=null;  
			switch  (Config.GetConfigValue("ClosePeriodReportType") )
			{
				case "1":
					rp= new Reports.wntReport(dtb,dte,type,asSec);
					break;
				case "2":
					rp= new Reports.cmlReport(dtb,dte,type,asSec);
					break;
                default: 
					lbStatus.Text="Error report type";
					lbStatus.ForeColor =Color.Red;  
					return;
			}

			 if (rp.CreateReport())
			{
				lbStatus.Text="Report created ("+rp.ReportFile +")";
				lbStatus.ForeColor =Color.Green;  
			}
			else
			{
				lbStatus.Text="Error create report";
				lbStatus.ForeColor =Color.Red;  
			}
		}

		private void dgPeriod_ItemCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			if (e.CommandName =="Report")
			{
				try
				{
					lbStatus.Text="";
					DateTime dtb=DateTime.Parse( e.Item.Cells[1].Text);
					DateTime dte=DateTime.Parse( e.Item.Cells[2].Text);
					CreateReport(dtb,dte, Reports.cpReportType.PlayPeriod,chAsResendTB.Checked );
				}
				catch
				{
					lbStatus.Text="Error Parameters";
					lbStatus.ForeColor =Color.Red;  
				}
			}
			else if (e.CommandName =="Reset")
			{
				try
				{
					lbStatus.Text="";
					int PerID = Utils.GetInt(e.Item.Cells[0].Text);
					if (PerID<=0) return;
					if (DBase.ExecuteReturnInt(Config.DbClosePeriod, new object[]{"@PeriodID", PerID}) !=0)   
					{
						lbStatus.Text="Error Execute";
						lbStatus.ForeColor =Color.Red;  
					}
					else
					{
						DBase.Execute("accUpdatePlayMoneyBalances");   
						lbStatus.Text="Period Closed";
						lbStatus.ForeColor =Color.Green;  
						DoDataBind();
					}
				}
				catch
				{
					lbStatus.Text="Error Execute";
					lbStatus.ForeColor =Color.Red;  
				}
			}
		}

	}
}
