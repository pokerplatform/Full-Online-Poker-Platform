namespace Admin.Controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using System.Collections;

	using Common.Web;
	/// <summary>
	///		Summary description for GridPager.
	/// </summary>
	public abstract class SmartGridPager : System.Web.UI.UserControl, System.Web.UI.INamingContainer
	{
		#region Controls
		public string Grid = "oGrid"; //string.Empty;
		public string GridFilter = "oFilter"; //string.Empty;
		public string CssClass = string.Empty;
		public string EditCssClass = string.Empty;
		public string ItemCssClass = string.Empty;
		public object DataSource = null;
		public int rowCount = 0;
		public ArrayList oCustParams= new ArrayList(); 
		
		private Common.WebControls.GridFilter oFilter = null;
		private DataGrid oGrid = null;

		protected System.Web.UI.WebControls.Table oGridPager;
		protected System.Web.UI.WebControls.ImageButton btnFirst;
		protected System.Web.UI.WebControls.ImageButton btnPrev;
		protected System.Web.UI.WebControls.ImageButton btnNext;
		protected System.Web.UI.WebControls.ImageButton btnLast;
		protected TextBox txtPageNum;
		protected TextBox txtItemsPerPage;
		protected System.Web.UI.WebControls.RangeValidator rvCurrentPage;
		protected Label lblPageCount;
		#endregion

		public Common.WebControls.GridFilter FilterObject
		{
			get
			{
				return oFilter;
			}
		}
		public DataGrid GridObject
		{
			get
			{
				return oGrid;
			}
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			if ( !IsPostBack )
			{
				if ( oGrid != null )
				{
					oGridPager.CssClass = CssClass;
					oGridPager.Style["border-top"] = "none";
					foreach(TableCell oTC in oGridPager.Rows[0].Cells)
					{
						oTC.CssClass = ItemCssClass;
					}
					txtItemsPerPage.CssClass = EditCssClass;
					txtPageNum.CssClass = EditCssClass;
				}
			}
		}

		public void OnPageIndexChanged(object source, System.Web.UI.ImageClickEventArgs e)
		{
			if ( oGrid != null )
			{
				int curPageNum = Common.Web.Core.GetInt(txtPageNum);
				int pageSize = Common.Web.Core.GetInt(txtItemsPerPage);
				if ( pageSize > 0 )
				{
					switch( (source as ImageButton).CommandName )
					{
						case "First":
							curPageNum = 1;
							break;
						case "Prev":
							if (curPageNum > 1) curPageNum--;
							break;
						case "Next":
							curPageNum++;
							break;
						case "Last":
							GetRowCount();
							curPageNum = GetMaximumAllowedPage(rowCount);
							break;
					}
					txtPageNum.Text = Convert.ToString(curPageNum);
				}				
				else
				{
					DisablePaging();
				}
				if ( DataSource == null )
				{
					BindGrid();
				}
			}
		}

		public void BindGrid()
		{
			ValidateCurrentPage(DataSource, Core.GetInt(txtItemsPerPage), Core.GetInt(txtPageNum));
			int curPageNum = Common.Web.Core.GetInt(txtPageNum);
			int pageSize = Common.Web.Core.GetInt(txtItemsPerPage);
			oFilter.Clear(); 
			oFilter.ClearCustomSqlParam(); 
			for(int l=0; l<oCustParams.Count;l=l+2 )
			{
				oFilter.AppendCustomSqlParam(oCustParams[l].ToString() ,oCustParams[l+1]);   
			}
			oFilter.AppendCustomSqlParam(Admin.Config.PageNum, curPageNum);
			oFilter.AppendCustomSqlParam(Admin.Config.PageSize, pageSize);
			DataSource = oFilter.GenerateDataSource(false);
			BindGrid(DataSource);
			
		}
		private void BindGrid(object dataSource)
		{
			if ( oGrid != null )
			{
				oGrid.DataSource = dataSource;
				oGrid.DataBind();
				AfterBind();
			}
		}

		private bool ValidateCurrentPage(object dataSource, int nPageSize, int nCurrentPage)
		{
			bool bRes = true;
			if ( nPageSize > 0)
			{
				if (rowCount <= 0) GetRowCount();
				if (nCurrentPage < 1) nCurrentPage = 1;
				if (rowCount < (nCurrentPage)*nPageSize )
				{
					nCurrentPage = GetMaximumAllowedPage(rowCount);
					txtPageNum.Text = Convert.ToString(nCurrentPage);
				}
			}
			else
			{
				DisablePaging();
				bRes = false;
			}
			return bRes;
		}

		private void DisablePaging()
		{
			oGrid.AllowPaging = false;
			oGrid.CurrentPageIndex = 0;
		}

		private void AfterBind()
		{
			if (Core.GetInt(txtItemsPerPage) < rowCount)
			{
				lblPageCount.Text =  Convert.ToString(GetMaximumAllowedPage(rowCount));
			}
			else
			{
				txtItemsPerPage.Text = "*";
			}
			PrepareButtons();
		}
		private int GetMaximumAllowedPage(int nRows)
		{
			int pageSize = Common.Web.Core.GetInt(txtItemsPerPage);
			int nPage = nRows / pageSize + 1;
			if ( nRows > 0 && nRows % pageSize == 0)
			{
				nPage--;
			}
			return nPage;
		}


		protected void InitGrid()
		{
			oGrid = (DataGrid)Page.FindControl(Grid);
			if ( oGrid == null )
			{
				oGridPager.Visible = false;
			}
			else
			{
				txtPageNum.Text = "1";
				txtItemsPerPage.Text = oGrid.PageSize.ToString();
			}
		}

		private void PrepareButtons()
		{
			int curPageNum = Common.Web.Core.GetInt(txtPageNum);
			int nMaximumPages = Common.Utils.GetInt(lblPageCount.Text);
			PrepareButton(btnFirst, Config.GridPagerGoFirst, Config.GridPagerGoFirstDisabled, (curPageNum > 1));
			PrepareButton(btnPrev, Config.GridPagerGoPrev, Config.GridPagerGoPrevDisabled, (curPageNum > 1));
			PrepareButton(btnNext, Config.GridPagerGoNext, Config.GridPagerGoNextDisabled, (curPageNum < nMaximumPages));
			PrepareButton(btnLast, Config.GridPagerGoLast, Config.GridPagerGoLastDisabled, (curPageNum < nMaximumPages));
		}
		private void PrepareButton(ImageButton button, string sEnabled, string sDisabled, bool bEnabled)
		{
			if ( bEnabled )
			{
				button.ImageUrl = sEnabled;
				button.CausesValidation = true;
				button.Attributes["onclick"] = string.Empty;
			}
			else
			{
				button.ImageUrl = sDisabled;
				button.CausesValidation = false;
				button.Attributes["onclick"] = "return false;";
			}
		}

		protected void InitFilter()
		{
			if ( GridFilter != string.Empty )
			{
				oFilter = (Common.WebControls.GridFilter)Page.FindControl(GridFilter);
			}
		}


		private void GetRowCount()
		{
			if ( oFilter != null )
			{
				//foreach(oFilter.FilterItem oParam in oFilter..FilterItems)
				//{
					//if ( oParam.Type != FilterColumnType.None)
					//{
					//	AppendSqlParam(oParam.GridSourceParameter, oParam.Value);
					//	if ( oParam.Type == FilterColumnType.Range )
					//	{
					//		AppendSqlParam(oParam.GridSourceParameterAlt, oParam.ValueAlt);
					//	}
					//}
				//}
				//oDataSource  = this.DBase.GetDataTable(SqlProcedureName, oParams.ToArray());

				System.Collections.ArrayList oParams = new System.Collections.ArrayList();
				System.Collections.ArrayList oArray = oFilter.FilterItems;
				for(int i=0; i<oArray.Count; i++)
				{
					Common.WebControls.FilterItem oFilterItem = oArray[i] as Common.WebControls.FilterItem;
					if ( oFilterItem.Type != Common.WebControls.FilterColumnType.None && oFilterItem.Visible ==true)
					{
						oParams.Add(oFilterItem.GridSourceParameter);
						oParams.Add(oFilterItem.Value);
						if ( oFilterItem.Type == Common.WebControls.FilterColumnType.Range )
						{
							oParams.Add(oFilterItem.GridSourceParameterAlt);
							oParams.Add(oFilterItem.ValueAlt);
						}
					}
				}
				oParams.Add(Admin.Config.PageNum);
				oParams.Add(1);
				oParams.Add(Admin.Config.PageSize);
				oParams.Add(-1);

				//oDataSource  = this.DBase.GetDataTable(SqlProcedureName, oParams.ToArray());

				Common.Web.Page oPage = Page as Common.Web.Page;
				rowCount = oPage.DBase.ExecuteReturnInt(oFilter.SqlProcedureName, oParams.ToArray());
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
		
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new System.EventHandler(this.Page_Load);
			InitFilter();
			InitGrid();
		}
		#endregion
	}
}
