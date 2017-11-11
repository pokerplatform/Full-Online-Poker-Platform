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

using Common.WebControls;  
using Common.Web;

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for Avatars.
	/// </summary>
	public class Avatars : Common.Web.Page
	{
		protected System.Web.UI.WebControls.DropDownList ddStatus;
		protected System.Web.UI.WebControls.DataGrid oGrid;
	
		protected  void Page_Load(object sender, System.EventArgs e)
		{
			if(!IsPostBack) 
			{
				ddStatus.Items.Add(new ListItem("[All]","0"));   
				ddStatus.Items.Add(new ListItem("Pending","5"));   
				ddStatus.Items.Add(new ListItem("Approved","4"));   
				ddStatus.SelectedIndex =0; 
				Bind_Grid();
			}
		}

		protected void btnRefresh_Click(object sender, System.EventArgs e)
		{
			Bind_Grid();
		}

		private void Bind_Grid()
		{
			 DataTable tb=DBase.GetDataTable(Config.DbGetAvatarsList,"@StatusID",int.Parse(ddStatus.SelectedValue) );
			 Session["Avatars_DT"]=tb.Copy() ;
			 DataView dv=  tb.DefaultView;
			 oGrid.DataSource = tb.DefaultView;
			 oGrid.DataBind(); 
		}

		protected void btnDecline_Click(object sender, System.EventArgs e)
		{
			ArrayList sIDs= GetCheckedValuesToArray (Config.MainCheckboxName);
			if (sIDs.Count <=0) return;
			DataTable  dt =(DataTable)Session["Avatars_DT"] ;
			dt.Constraints.Clear();
			dt.Constraints.Add("cnst_ID_Avatars",dt.Columns["ID"],true);   
			string fPath=Config.GetConfigValue("AvatarUploadPath");
			foreach (string sr in sIDs )
			{
				int id=int.Parse(sr);
				int ret=DBase.ExecuteReturnInt(Config.DbDeleteAvatar ,"@id",id);
				DataRow dr=dt.Rows.Find(id) ;  
				fPath+= ("\\"+    dr["LoginName"]+"\\"+dr["File"]); 
				if (File.Exists(fPath)) File.Delete(fPath);  
			}
 			 Bind_Grid();
		}

		protected void btnAccept_Click(object sender, System.EventArgs e)
		{
			string sIDs= GetCheckedValues(Config.MainCheckboxName);
            if (sIDs==String.Empty) return;
			DBase.ExecuteReturnInt(Config.DbAcceptAvatar,"@ids",sIDs);
			Bind_Grid();
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
			this.oGrid.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.oGrid_PageIndexChanged);
			this.oGrid.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.oGrid_ItemDataBound);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void oGrid_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			Bind_Grid(); 
		}

		private void oGrid_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if (( e.Item.ItemType == ListItemType.Item) || 
				(e.Item.ItemType == ListItemType.AlternatingItem))
			{
				DataRowView dr=((DataRowView)  e.Item.DataItem);
				string nav=dr[1].ToString()+"/"+ dr[2].ToString();
				((HyperLink ) e.Item.Cells[2].Controls[0]).Text = dr["File"].ToString() ;
				((HyperLink ) e.Item.Cells[2].Controls[0]).NavigateUrl  = nav;
			}
		}
	}
}
