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

namespace Admin.Support
{
	/// <summary>
	/// Summary description for LiveStats.
	/// </summary>
	public class LiveStats : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lbTAPPlay;
		protected System.Web.UI.WebControls.Label lbTATReal;
		protected System.Web.UI.WebControls.Label lbTATPlay;
		protected System.Web.UI.WebControls.Label lbPlayersSign;
		protected System.Web.UI.WebControls.Label lbTournRun;
		protected System.Web.UI.WebControls.Label lbTournFinish;
		protected System.Web.UI.WebControls.Label lbDeposits;
		protected System.Web.UI.WebControls.Label lbWithdr;
		protected System.Web.UI.WebControls.Label lbAffNew;
		protected System.Web.UI.WebControls.Label lbAffUnapp;
		protected System.Web.UI.WebControls.Label lbTAPReal;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			if (!IsPostBack)
			{
				BindData();
			}
		}

		private void BindData()
		{
			 DataSet ds=DBase.GetDataSet("admGetCurrentStats");
			 DataTable tb=ds.Tables[2];
			 if (tb==null) return;
			 if (tb.Rows.Count <=0) return;
			 DataRow dr=tb.Rows[0];
			 lbAffNew.Text = dr["AffSignup"].ToString() ;
			 lbAffUnapp.Text=dr["AffUnapproved"].ToString();
			 lbDeposits.Text =dr["Deposits"].ToString();
			 lbWithdr.Text=dr["Withdrawals"].ToString();
			 lbPlayersSign.Text=dr["NewPlayers"].ToString(); 
		     lbTAPReal.Text=dr["ActPlayersReal"].ToString();
			 lbTAPPlay.Text= dr["ActPlayersPlay"].ToString();
			 lbTATReal.Text=dr["ActTablesReal"].ToString();
			 lbTATPlay.Text=dr["ActTablesPlay"].ToString();
		     lbTournRun.Text=dr["ToutnRun"].ToString();
			 lbTournFinish.Text=dr["TournFinish"].ToString();
		}

		public string GetDate()
		{
			DateTime d=DateTime.Now; 
			return d.ToString("D");  
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
