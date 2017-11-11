using System;
using System.Collections;
using System.Data;
using System.Web.UI.WebControls;
using Admin.Components;
using Admin.Controls;
using Common;
using DataGridCustomColumns;
using System.Globalization; 

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for ChatForBots.
	/// </summary>
	public class ForcedExits  : MaintenancePage
	{
		protected DataGrid oGrid;
		protected Label lbStatus;  

		protected override void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack) GridBind();
		}

		private void GridBind()
		{
		DataTable tb = DBase.GetDataTable(Config.DbGetForcedExitsList); 
        oGrid.DataSource = tb.DefaultView;
		oGrid.DataBind() ; 
      }

		protected override void btnDelete_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(Config.DbDeleteForcedExits);
			GridBind();
		}

		protected override void btnAdd_Click(object sender, EventArgs e)
		{
			//int ret=
				DBase.ExecuteReturnInt(Config.DbSaveForcedExits,"@ID",-1);
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
			this.oGrid.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.oGrid_PageIndexChanged);
			this.oGrid.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_CancelCommand);
			this.oGrid.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_EditCommand);
			this.oGrid.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.oGrid_UpdateCommand);
			this.Load += new System.EventHandler(this.Page_Load);
			this.PreRender += new System.EventHandler(this.ChatForBots_PreRender);

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
			DateTime dt;
			decimal dc;
			try
			{
				dt= DateTime.Parse(((TextBox)e.Item.Cells[3].Controls[0]).Text,new CultureInfo("en-US")); 
			}
			catch { return;}
			try
			{
				dc= Decimal.Parse(((TextBox)e.Item.Cells[6].Controls[0]).Text,new CultureInfo("en-US"));
			}
			catch { return;}

				DBase.ExecuteReturnInt(Config.DbSaveForcedExits,"@ID",int.Parse(e.Item.Cells[2].Text),
                                    "@DateExit", dt, 
				                    "@Message",((TextBox)e.Item.Cells[4].Controls[0]).Text ,
				                    "@AmountReset", dc,
									"@WarningTimes",((TextBox)e.Item.Cells[5].Controls[0]).Text);
             oGrid.EditItemIndex = -1;
            GridBind();
		}

		private void oGrid_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			GridBind();
		}


		private void ChatForBots_PreRender(object sender, EventArgs e)
		{
			SetEditControlsWidth(oGrid);
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
