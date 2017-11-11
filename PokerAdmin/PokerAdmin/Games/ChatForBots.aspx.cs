using System;
using System.Collections;
using System.Data;
using System.Web.UI.WebControls;
using Admin.Components;
using Admin.Controls;
using Common;
using DataGridCustomColumns;

namespace Admin.Games
{
	/// <summary>
	/// Summary description for ChatForBots.
	/// </summary>
	public class ChatForBots  : MaintenancePage
	{
		protected DataGrid oGrid;
		protected DataGrid vGrid;
		protected Label lbStatus;
        protected ButtonImage btnAddVarinats;  
		protected ButtonImage btnDeleteVarinats;  

		private int  MapID=-1;

		protected override void Page_Load(object sender, EventArgs e)
		{
			btnAddVarinats.Visible =false;
			btnDeleteVarinats.Visible =false;
			if (!IsPostBack) GridBind();
			SetMapID();
		}


		private void SetMapID()
		{
			if (ViewState["Bots_Map_ID"] !=null )
			{
				MapID=Utils.GetInt(ViewState["Bots_Map_ID"]); 
				lbStatus.Text ="Variants for Map ID "+ MapID.ToString(); 
				btnAddVarinats.Visible =true;
				btnDeleteVarinats.Visible =true;
			}
		}

		private void GridBind()
		{
			DropDownColumn DDC =null;
			DDC = (DropDownColumn) oGrid.Columns[3];
			ArrayList  AL =new ArrayList() ;
			AL.Add("CHIT-CHAT");
			AL.Add("BCP_JOIN_TABLE");
			AL.Add("BCP_SIT_DOWN");
			AL.Add("BCP_FOLDS");
			AL.Add("BCP_GOES_ALL_IN");
			AL.Add("BCP_SIT_OUT");
			AL.Add("BCP_LEAVE_TABLE");
			DDC.DataSource = AL;

			DataTable tb = DBase.GetDataTable(Config.DBGetBotChatListMap); 
        oGrid.DataSource = tb.DefaultView;
		oGrid.DataBind() ; 
      }

		protected override void btnDelete_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(Config.DBDeleteBotChatListMap);
			GridBind();
		}

		protected override void btnAdd_Click(object sender, EventArgs e)
		{
			//int ret=
				DBase.ExecuteReturnInt(Config.DBSaveBotChatListMap,"@ID",-1);
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
			this.oGrid.PageIndexChanged += new DataGridPageChangedEventHandler(this.oGrid_PageIndexChanged);
			this.oGrid.CancelCommand += new DataGridCommandEventHandler(this.oGrid_CancelCommand);
			this.oGrid.EditCommand += new DataGridCommandEventHandler(this.oGrid_EditCommand);
			this.oGrid.UpdateCommand += new DataGridCommandEventHandler(this.oGrid_UpdateCommand);
			this.oGrid.SelectedIndexChanged += new EventHandler(this.oGrid_SelectedIndexChanged);
			this.vGrid.PageIndexChanged += new DataGridPageChangedEventHandler(this.vGrid_PageIndexChanged);
			this.vGrid.CancelCommand += new DataGridCommandEventHandler(this.vGrid_CancelCommand);
			this.vGrid.EditCommand += new DataGridCommandEventHandler(this.vGrid_EditCommand);
			this.vGrid.UpdateCommand += new DataGridCommandEventHandler(this.vGrid_UpdateCommand);
			this.Load += new EventHandler(this.Page_Load);
			this.PreRender += new EventHandler(this.ChatForBots_PreRender);

		}
		#endregion

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
		    DropDownList CustomDDL   = ( DropDownList) e.Item.Cells[3].Controls[0];
            int idx  = Utils.GetInt(CustomDDL.SelectedValue);
			//int ret=
				DBase.ExecuteReturnInt(Config.DBSaveBotChatListMap,"@ID",int.Parse(e.Item.Cells[2].Text),
                                    "@keywords", ((TextBox)e.Item.Cells[4].Controls[0]).Text, 
				                    "@actiontypeid",idx );
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
			ViewState["Bots_Map_ID"]=MapID;
			SetMapID();
			GridBindVariant();
		}

		protected  void btnAddVarinats_Click(object sender, EventArgs e)
		{
			if (MapID<0) return;
			DBase.ExecuteReturnInt(Config.DBSaveBotChatVariant,"@ID",-1,"@mapid",MapID);
			GridBindVariant();
		}

		protected  void btnDeleteVarinats_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(Config.DBDeleteBotChatVariant);
			GridBindVariant();
		}

		private void GridBindVariant()
		{
			DataTable tb = DBase.GetDataTable(Config.DBGetBotChatVariantList,"@mapid",MapID); 
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
			DBase.ExecuteReturnInt(Config.DBSaveBotChatVariant,"@ID",int.Parse(e.Item.Cells[2].Text),
				"@postvariant", ((TextBox)e.Item.Cells[3].Controls[0]).Text, "@mapid",MapID );
			vGrid.EditItemIndex = -1;
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
