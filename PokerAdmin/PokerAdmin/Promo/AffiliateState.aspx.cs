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
using System.IO;

using Common;

namespace Promo
{
	/// <summary>
	/// Summary description for AffiliateState.
	/// </summary>
	public class AffiliateState: Common.Web.Page
	{
		protected System.Web.UI.WebControls.Button btnSignUp;
		protected System.Web.UI.WebControls.TextBox txtLogin;
		protected System.Web.UI.WebControls.TextBox txtPassword;
		protected System.Web.UI.WebControls.Panel pnData;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnAffID;
		protected System.Web.UI.WebControls.Panel pnLogin;
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.LinkButton lbtToState;
		protected System.Web.UI.WebControls.Panel pnStat;
		protected System.Web.UI.WebControls.LinkButton lbtData;
		protected System.Web.UI.WebControls.Button btReport;
		protected System.Web.UI.WebControls.TextBox txtDateFrom;
		protected System.Web.UI.WebControls.TextBox txtDateTo;
		protected System.Web.UI.WebControls.DataGrid dgAffilPeriod;
		protected System.Web.UI.WebControls.Label lbSumCaption;
		protected System.Web.UI.WebControls.Label lbRakeSum;
		protected System.Web.UI.WebControls.Label lbInfo;
		protected System.Web.UI.WebControls.Image oImg;
		protected System.Web.UI.WebControls.Image Image1;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnSkinsID;
		protected System.Web.UI.WebControls.Image Image2;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			 ViewPanels();
		}

		public string GetCssPageUrl()
		{
			return Config.CommonCssPath;
		}

		private void ViewPanels()
		{
			bool hdPanels =(Utils.GetInt(hdnAffID.Value)>0);
			pnLogin.Visible =!hdPanels;
			pnData.Visible =false;
			pnStat.Visible =hdPanels;
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
			this.btnSignUp.Click += new System.EventHandler(this.btnSignUp_Click);
			this.lbtToState.Click += new System.EventHandler(this.lbtToState_Click);
			this.lbtData.Click += new System.EventHandler(this.lbtData_Click);
			this.btReport.Click += new System.EventHandler(this.btReport_Click);
			this.dgAffilPeriod.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.dgAffilPeriod_PageIndexChanged);
			this.dgAffilPeriod.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgAffilPeriod_ItemDataBound);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void btnSignUp_Click(object sender, System.EventArgs e)
		{
			lblInfo.ForeColor=Color.Red ;  
			DataRow oDR = GetFirstRow(Config.DbCheckAffiliateLogin, "@Login", txtLogin.Text, "@Password", txtPassword.Text);
			if ( oDR != null && Utils.GetInt(oDR["ID"]) > 0)
			{
				if (Utils.GetInt(oDR["StatusID"])==4)
				{
					hdnAffID.Value =oDR["ID"].ToString(); 
					hdnSkinsID.Value =oDR["SkinsID"].ToString(); 
/*					oImageBanner.ImageUrl =Config.GetConfigValue("SkinsBannerURL")+"Skin_"+hdnSkinsID.Value+"/Banner/"+Config.GetConfigValue("ImageBannerName"); 
					txtBannerURL.Text ="<table><tr><td><a href=\""+
						Config.GetConfigValue("InstallersUrl")+"Skin_"+hdnSkinsID.Value+"/Installer/"+
						string.Format(Config.GetConfigValue("InstallersFile"),hdnAffID.Value)+ 
						"\"><img src=\""+oImageBanner.ImageUrl+"\"></a></td></tr></table>"; */
					      Session["AffSgUP_SkinID"]=hdnSkinsID.Value;
					      Session["AffSgUP_AffID"]=hdnAffID.Value;
						  string fPath=Config.GetConfigValue("SkinsBannerPath")+"\\Skin_"+hdnSkinsID.Value+"\\Banner";
					       Session["AffSgUP_FilesList"]=Directory.GetFiles(fPath,"*.*");  
					//     Session["AffSgUP_FilesList"]==null || Session["AffSgUP_FilesList"]== "") return;

                     oDR = GetFirstRow(Config.DbGetAffiliateStats, "@AffID", oDR["ID"].ToString());
                     if (oDR ==null)
					 {lbInfo.Text ="";}
					else
					 {lbInfo.Text=String.Format("You have {0} referrals",oDR["ref"]);} 
				}
				else
				{
					hdnAffID.Value ="0";
					lblInfo.Text="You not approved by Administrator"; 
				}
			}
			else
			{
				hdnAffID.Value ="0";
				lblInfo.Text="Incorrect Login or Password"; 
			}
		 ViewPanels();
		}

		private void lbtToState_Click(object sender, System.EventArgs e)
		{
			pnData.Visible =false;
			pnStat.Visible =true;
		}

		private void lbtData_Click(object sender, System.EventArgs e)
		{
			pnData.Visible =true;
			pnStat.Visible =false;
		}

		private void btReport_Click(object sender, System.EventArgs e)
		{
			DataTable tb=null;
			dgAffilPeriod.Columns[0].Visible =true;  
			dgAffilPeriod.Columns[1].Visible =true;  
			lbRakeSum.Text="0";

			if(!CheckDate(txtDateFrom.Text) || !CheckDate(txtDateTo.Text))		return;

			tb=DBase.GetDataTable(Config.DbGetAffiliateInfo,new object[] {"@AffiliateID",Utils.GetInt(  hdnAffID.Value) , "@DateFrom",txtDateFrom.Text,"@DateTo",txtDateTo.Text } );
			dgAffilPeriod.Columns[0].Visible =false;  
			dgAffilPeriod.Columns[1].Visible =false;  
			dgAffilPeriod.DataSource =tb.DefaultView;
			dgAffilPeriod.DataBind(); 
			Session["ReportData"]=tb;
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

		private void dgAffilPeriod_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			dgAffilPeriod.CurrentPageIndex = e.NewPageIndex;
			dgAffilPeriod.DataSource =((DataTable)Session["ReportData"]).DefaultView;
			dgAffilPeriod.DataBind(); 
		}

	}
}
