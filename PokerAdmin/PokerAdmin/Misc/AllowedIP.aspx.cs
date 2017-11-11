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
	/// Summary description for AllowedIP.
	/// </summary>
	public class AllowedIP : Common.Web.Page
	{
		protected System.Web.UI.WebControls.CheckBoxList chkIpList;
		protected System.Web.UI.WebControls.RegularExpressionValidator RegularExpressionValidator1;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.TextBox txtIP;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			if ( !IsPostBack )
			{
				BindList();
			}
		}

		protected void BindList()
		{
			chkIpList.DataSource = GetDataTable(Config.DbGetAllowedIP);
			chkIpList.DataBind();
		}

		protected void btnAdd_click(object sender, System.EventArgs e)
		{
			if ( txtIP.Text != string.Empty )
			{
				AddItemSql(txtIP.Text);
				BindList();
			}
		}

		protected void btnDelete_click(object sender, System.EventArgs e)
		{
			RemoveItemsSql();
			BindList();
		}

		protected void AddItemSql(string NewIP)
		{
			DBase.Execute(Config.DbSaveAllowedIP, new object[]{"@ip", NewIP});
		}

		protected void RemoveItemsSql()
		{
			DataTable oDT = DBase.GetDataTableBatch("select ip from AllowedIP");

			foreach(DataRow oDR in oDT.Rows)
			{
				ListItem oLI = chkIpList.Items.FindByText(oDR["IP"].ToString());
				if ( oLI != null && oLI.Selected )
				{
					oDR.Delete();
				}
			}

			DBase.Update(oDT);
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
