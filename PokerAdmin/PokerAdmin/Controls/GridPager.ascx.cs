namespace Admin.Controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	using Common.Web;
	/// <summary>
	///		Summary description for GridPager.
	/// </summary>
	public abstract class GridPager : System.Web.UI.UserControl, System.Web.UI.INamingContainer
	{
		public string Grid = string.Empty;
		public string GridFilter = string.Empty;
		public string CssClass = string.Empty;
		public string EditCssClass = string.Empty;
		public string ItemCssClass = string.Empty;
		public object DataSource = null;

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
                public int PagerCurrentPage
                {
                	get
                        {
                        	return Common.Utils.GetInt(txtPageNum.Text);
                        }
                }
                public int PagerItemsPerPage
                {
                	get
                        {
                        	return Common.Utils.GetInt(txtItemsPerPage.Text);
                        }
                }
		private void Page_Load(object sender, System.EventArgs e)
		{
			lblPageCount.EnableViewState = false;
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
                                if (PagerCurrentPage!=0)
                                {
					oGrid.CurrentPageIndex = PagerCurrentPage-1;
                                }
                                if (PagerItemsPerPage!=0)
                                {
                                	oGrid.PageSize = PagerItemsPerPage;
                                }
                                else
                                {
					txtItemsPerPage.Text = oGrid.PageSize.ToString();
                                }
			}
		}

		public void OnPageIndexChanged(object source, System.Web.UI.ImageClickEventArgs e)
		{
			if ( oGrid != null )
			{
				int ps = PagerItemsPerPage;
				if ( ps > 0 )
				{
					oGrid.PageSize = ps;
					switch( (source as ImageButton).CommandName )
					{
						case "First":
							oGrid.CurrentPageIndex = 0;
							break;
						case "Prev":
							if ( oGrid.CurrentPageIndex > 0 ) oGrid.CurrentPageIndex--;
							break;
						case "Next":
							oGrid.CurrentPageIndex++;
							break;
						case "Last":
							oGrid.CurrentPageIndex = 55555;
							break;
					}
				}
				else
				{
					DisablePaging();
				}
				if ( DataSource == null )
				{
					if ( oFilter != null )
					{
						DataSource = oFilter.GenerateDataSource();
					}
				}
				DataTable oDT = DataSource as DataTable;
				if ( oDT != null )
				{
					ValidateCurrentPage(oDT, oGrid.PageSize, oGrid.CurrentPageIndex);
					BindGrid(DataSource, true);
				}
			}
		}

		public void BindGrid(object dataSource)
		{
			BindGrid(dataSource, false);
		}
		private void BindGrid(object dataSource, bool bPrepared)
		{
			if ( oGrid != null )
			{
				DataSource = dataSource;
				if ( !bPrepared )
					ValidateCurrentPage(DataSource, PagerItemsPerPage, PagerCurrentPage - 1);
				else
				{
					ValidateCurrentPage(DataSource, PagerItemsPerPage, oGrid.CurrentPageIndex);
				}
				oGrid.DataSource = dataSource;
				oGrid.DataBind();
	                        string pagerParam  = GeneratePagerParamString();
                                (Page as Common.Web.Page).StoreFilter(pagerParam);
				AfterBind();
			}
		}

		private bool ValidateCurrentPage(object dataSource, int nPageSize, int nCurrentPage)
		{
			bool bRes = true;
			DataTable oDT = dataSource as DataTable;
			if ( nPageSize > 0 && oDT != null )
			{

				int nRows = oDT.Rows.Count;
				oGrid.PageSize = nPageSize;
				if ( nCurrentPage < 0 ) nCurrentPage = 0;
				if ( nCurrentPage == 55555 || nRows < (nCurrentPage+1)*nPageSize )
				{
					nCurrentPage = GetMaximumAllowedPage(nRows);
				}
				oGrid.AllowPaging = true;
				oGrid.CurrentPageIndex = nCurrentPage;
				oGrid.PageSize = nPageSize;
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
			txtPageNum.Text = string.Format("{0}", oGrid.CurrentPageIndex + 1);
			txtItemsPerPage.Text = oGrid.PageSize.ToString();
			if ( oGrid.AllowPaging )
			{
				lblPageCount.Text =  Convert.ToString(GetMaximumAllowedPage(((DataTable)DataSource).Rows.Count) + 1);
			}
			else
			{
				txtItemsPerPage.Text = "*";
			}
			PrepareButtons();
		}
		private int GetMaximumAllowedPage(int nRows)
		{
			int nPage = nRows / oGrid.PageSize;
			if ( nRows > 0 && nRows % oGrid.PageSize == 0)
			{
				nPage--;
			}
			return nPage;
		}


		private void InitGrid()
		{
			oGrid = (DataGrid)Page.FindControl(Grid);
			if ( oGrid == null )
			{
				oGridPager.Visible = false;
			}
			else
			{
				oGrid.AllowPaging = true;
				oGrid.PagerStyle.Visible = false;
                                if (PagerItemsPerPage==0)
                                {
					txtItemsPerPage.Text = oGrid.PageSize.ToString();
                                }
			}
		}
                private string GeneratePagerParamString()
                {
                	string pagerParam = "&" +
                        "oGridPager:txtItemsPerPage=" + oGrid.PageSize.ToString() + "&" +
                        "oGridPager:txtPageNum=" + (oGrid.CurrentPageIndex + 1).ToString();
                        return pagerParam;
                }

 		private void InitPager()
                {
                	if (!IsPostBack)
                        {
                        	if (Request["oGridPager:txtPageNum"]!=null)
                                {
					txtPageNum.Text = Request["oGridPager:txtPageNum"];
                                }
                        	if (Request["oGridPager:txtItemsPerPage"]!=null)
                                {
					txtItemsPerPage.Text = Request["oGridPager:txtItemsPerPage"];
                                }
                        }
                }
		private void PrepareButtons()
		{
			int nMaximumPages = Common.Utils.GetInt(lblPageCount.Text) - 1;
			PrepareButton(btnFirst, Config.GridPagerGoFirst, Config.GridPagerGoFirstDisabled, (oGrid.CurrentPageIndex > 0));
			PrepareButton(btnPrev, Config.GridPagerGoPrev, Config.GridPagerGoPrevDisabled, (oGrid.CurrentPageIndex > 0));
			PrepareButton(btnNext, Config.GridPagerGoNext, Config.GridPagerGoNextDisabled, (oGrid.CurrentPageIndex < nMaximumPages));
			PrepareButton(btnLast, Config.GridPagerGoLast, Config.GridPagerGoLastDisabled, (oGrid.CurrentPageIndex < nMaximumPages));
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

		private void InitFilter()
		{
			if ( GridFilter != string.Empty )
			{
				oFilter = (Common.WebControls.GridFilter)Page.FindControl(GridFilter);
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
			InitPager();
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
