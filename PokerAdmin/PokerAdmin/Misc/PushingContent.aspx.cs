using System;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web; 
using Admin.Components;
using Admin.Controls;
using Common;
using Common.Web;
using System.Globalization; 
using DataGridCustomColumns;

namespace Admin.Misc
{
	public class PushingContent  : Page //MaintenancePage
	{
		protected DataGrid oGrid;
		protected DataGrid vGrid;
		protected Label lbStatus;
		protected DropDownList combo_0;  
		protected ButtonImage btnAddFile;
		protected ButtonImage btnDeleteFile;
		protected System.Web.UI.WebControls.Panel pnUpload;
		protected System.Web.UI.WebControls.DropDownList ddContentType;

		private int  MapID=-1;

		protected void Page_Load(object sender, EventArgs e)
		{
			Session["PushingContent_BackURL"]=Request.Url.AbsoluteUri;    
			btnAddFile.Visible =false;
			btnDeleteFile.Visible =false;
			pnUpload.Visible =false;
			if (!IsPostBack)
			{
				GridBind();
				DBase.FillList(ddContentType,Config.DbGetPushingContentTypes,false);
			}
			SetMapID();
		}


		private void SetMapID()
		{
			if (ViewState["PushContent_Map_ID"] !=null )
			{
				MapID=Utils.GetInt(ViewState["PushContent_Map_ID"]); 
				lbStatus.Text ="Files for Pushing Content ID "+ MapID.ToString(); 
				pnUpload.Visible =true;
				btnAddFile.Visible =true;
				btnDeleteFile.Visible =true;
			}
		}

		public string BrowseHtml(object oRow)
		{
			if ( vGrid.EditItemIndex <0 ) return "";
			string sName = ((DataRowView)oRow)[Config.SqlDefaultIdColumnName].ToString();
			return string.Format("<input type='file' style='width:200' name='{0}'>", sName);
		}

		private void GridBind()
		{
			DataTable tb = DBase.GetDataTable(Config.DbGetPushingContentList); 
        oGrid.DataSource = tb.DefaultView;
		oGrid.DataBind() ; 
      }

		protected  void btnDelete_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(Config.DbDeletePushingContentList);
			GridBind();
		}

		protected  void btnAdd_Click(object sender, EventArgs e)
		{
			//int ret=
				DBase.ExecuteReturnInt(Config.DbSavePushingContentList,"@ID",-1);
			GridBind();
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
			this.oGrid.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.oGrid_ItemDataBound);
			this.oGrid.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.oGrid_PageIndexChanged);
			this.oGrid.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_CancelCommand);
			this.oGrid.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_EditCommand);
			this.oGrid.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_UpdateCommand);
			this.oGrid.SelectedIndexChanged += new System.EventHandler(this.oGrid_SelectedIndexChanged);
			this.vGrid.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.vGrid_PageIndexChanged);
			this.vGrid.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.vGrid_CancelCommand);
			this.vGrid.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.vGrid_EditCommand);
			this.vGrid.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.vGrid_UpdateCommand);
			this.Load += new System.EventHandler(this.Page_Load);
			this.PreRender += new System.EventHandler(this.ChatForBots_PreRender);

		}
		#endregion

		private void oGrid_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if (e.Item.Cells[6].Controls.Count >0)
			{
				HyperLink ct=( (HyperLink) e.Item.Cells[6].Controls[0]);
				ct.NavigateUrl ="..\\Misc\\PushingContentUsers.aspx?ContentID=" +((DataRowView)  e.Item.DataItem)[0].ToString();
			}
			if (e.Item.Cells[7].Controls.Count >0)
			{
				HyperLink ct=( (HyperLink) e.Item.Cells[7].Controls[0]);
				ct.NavigateUrl ="..\\Misc\\PushingContentProcesses.aspx?ContentID=" +((DataRowView)  e.Item.DataItem)[0].ToString();
			}
		}

		private void oGrid_EditCommand(object source, DataGridCommandEventArgs e)
		{
			oGrid.EditItemIndex = e.Item.ItemIndex;
			GridBind();
		}

		private void oGrid_CancelCommand(object source, DataGridCommandEventArgs e)
		{
			oGrid.EditItemIndex = -1;
			GridBind();
		}

		private void oGrid_UpdateCommand(object source, DataGridCommandEventArgs e)
		{
			CultureInfo ci=new CultureInfo("en-US"); 

			DateTime dt;
			try
			{
				dt=DateTime.Parse(((TextBox)e.Item.Cells[4].Controls[0]).Text,ci);
			}
			catch{ return;}
			int ret=DBase.ExecuteReturnInt(Config.DbSavePushingContentList,"@ID",int.Parse(e.Item.Cells[2].Text),
                                    "@Name", ((TextBox)e.Item.Cells[3].Controls[0]).Text, 
				                    "@ActivateDate", dt );
             oGrid.EditItemIndex = -1;
            GridBind();
		}

		private void oGrid_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			GridBind();
		}

		private void oGrid_SelectedIndexChanged(object sender, EventArgs e)
		{
			MapID= Utils.GetInt(oGrid.Items[oGrid.SelectedIndex].Cells[2].Text);    
			ViewState["PushContent_Map_ID"]=MapID;
			SetMapID();
			GridBindVariant();
		}

		protected  void btnAddFile_Click(object sender, EventArgs e)
		{
			if (MapID<0) return;
			if (Request.Files.Count ==0) return;
			HttpPostedFile postFile = Request.Files["0"];
			if ((postFile.FileName =="") || (postFile.FileName==null)) return;
			int fileID=-1;
			CommonUse.PushContPostFile pf = new CommonUse.PushContPostFile(MapID);
			string sret=pf.SaveFile(this,postFile,1,1,Utils.GetInt(ddContentType.SelectedValue),  ref fileID); 
			if (sret != String.Empty) lbStatus.Text =sret; 
			GridBindVariant();
		}

		protected  void btnDeleteFile_Click(object sender, EventArgs e)
		{
			string sIDs = GetCheckedValues(Config.MainCheckboxName);
			if (sIDs == String.Empty ) return;
			CommonUse.PushContPostFile pf = new CommonUse.PushContPostFile(MapID);
             pf.DeleteFile(this,sIDs);  
			GridBindVariant();
		}

		private void GridBindVariant()
		{
			DataTable tb;
				DropDownColumn DDC =null;
				DDC = (DropDownColumn) vGrid.Columns[4];
				tb=DBase.GetDataTable(Config.DbGetPushingContentTypes); 
                DDC. DataSource =tb.DefaultView;
			tb = DBase.GetDataTable(Config.DbGetPushingContentFilesList,"@Contentid",MapID); 
			vGrid.DataSource = tb.DefaultView;
			vGrid.DataBind() ; 
		}


		private void vGrid_CancelCommand(object source, DataGridCommandEventArgs e)
		{
			vGrid.EditItemIndex = -1;
			GridBindVariant();
		}

		private void vGrid_EditCommand(object source, DataGridCommandEventArgs e)
		{
			vGrid.EditItemIndex = e.Item.ItemIndex;
			GridBindVariant();
		}

		private void vGrid_UpdateCommand(object source, DataGridCommandEventArgs e)
		{
			vGrid.EditItemIndex = -1;
			if (Request.Files.Count ==0) return;
			CommonUse.PushContPostFile pf = new CommonUse.PushContPostFile(MapID);
			HttpPostedFile postFile = Request.Files[e.Item.Cells[2].Text];

			DropDownList CustomDDL   = ( DropDownList) e.Item.Cells[4].Controls[0];
			int idx  = Utils.GetInt(CustomDDL.SelectedValue);

			    int fileID=Utils.GetInt(e.Item.Cells[2].Text) ;
				string sret=pf.SaveFile(this,postFile,Utils.GetInt (((TextBox)e.Item.Cells[7].Controls[0]).Text),
					            Utils.GetInt(((TextBox)e.Item.Cells[8].Controls[0]).Text),idx,ref fileID); 
				if (sret != String.Empty) lbStatus.Text =sret; 
			GridBindVariant();
		}

		private void vGrid_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			vGrid.CurrentPageIndex = e.NewPageIndex;
			GridBindVariant();
		}

		private void ChatForBots_PreRender(object sender, EventArgs e)
		{
			SetEditControlsWidth(oGrid);
            SetEditControlsWidth(vGrid);
			RemoveBrowse();
		}

		private void RemoveBrowse()
		{
			foreach(DataGridItem dgi in vGrid.Items)
			{
				if (vGrid.EditItemIndex <0 && dgi.Cells[8].Controls.Count>0 ) 
					dgi.Cells[9].Controls.Clear(); 
				else
				{
					if (vGrid.EditItemIndex >=0)
					{
						if ( dgi.Cells[2].Text != vGrid.Items[vGrid.EditItemIndex].Cells[2].Text) dgi.Cells[9].Controls.Clear(); 
					}
				}
			}
		}

        private void SetEditControlsWidth (DataGrid dg)
        {
			if (dg.EditItemIndex <0) return;
			foreach (TableCell tc in dg.Items[dg.EditItemIndex].Cells)
			{
				if (tc.Controls.Count ==0 ) continue;
				TextBox t= new TextBox();
				if (tc.Controls[0].GetType() == t.GetType() )
				{
					t= (TextBox) tc.Controls[0];
					t.Width =new Unit(100,UnitType.Percentage);
				}
				else
				{
					DropDownList pd= new DropDownList() ;
					if (tc.Controls[0].GetType() == pd.GetType() )
					{
						pd= (DropDownList) tc.Controls[0] ;
						pd.Width =new Unit(100,UnitType.Percentage);
					}
				}
			}
        }


	}
}
