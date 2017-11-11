using System;
using System.Collections;
using System.Collections.Specialized;
using System.Web.UI.WebControls;
using Admin.Controls;
using Common;
using Common.Web;
using Common.WebControls;
using DesktopAPIEngine;

namespace Admin.Components
{

	public  class  ButtonImageEventsData
	{
		 public string btID=String.Empty ;
		 public string btDBQuery=String.Empty;
         
		public ButtonImageEventsData(){}
		public ButtonImageEventsData(string cID, string cQuery)
		{btID=cID; btDBQuery = cQuery;}

		public override  bool Equals(object obj)
		{
			bool ret=false;
			try
			{
				if(obj == null) return false;
				if (((ButtonImageEventsData) obj).btID.ToLower()== btID.ToLower())  ret = true;
			}
			catch
				{ret = false;}

				return ret;	
		}

		public override int GetHashCode()
		{
			return base.GetHashCode ();
		}

	}

	/// <summary>
	/// Summary description for MaintenancePage.
	/// </summary>
	public class MaintenancePage : Page
	{

		protected int nEditPageNum = 0;

		protected ButtonImage btnAdd;
		protected ButtonImage btnDelete;
		protected ButtonImage btnEnable;
		protected ButtonImage btnDisable;
		protected ButtonImage btnSearchAgain;

		protected string sDbEnableQuery = string.Empty;
		protected string sDbDisableQuery = string.Empty;
		protected string sDbDeleteQuery = string.Empty;

        protected ArrayList arButtonImageEvents =new ArrayList(); 

		protected string sGridSourceQuery = string.Empty;

		protected SmartGridPager oSGridPager = null;
	//	protected Controls.GridPager oGridPager = null;
		protected DataGrid oParentGrid = null;
		protected GridFilter oFilter = null;

		protected string sUrlFormatString = string.Empty;

		public MaintenancePage(){}

		protected virtual void Page_Load(object sender, EventArgs e)
		{
			/*if ( oGridPager != null )
			{
				oParentGrid = oGridPager.GridObject;
			}*/
			if ( oSGridPager != null )
			{
				oParentGrid = oSGridPager.GridObject;
			}
			if ( oFilter != null )
			{
				oFilter.SqlProcedureName = sGridSourceQuery;
				oFilter.PrepareGridSource();
				if ( !IsPostBack )
				{
					BindGrid();
				}
			}
		}

		protected  virtual void btnButtonImage_Click(object sender, EventArgs e)
		{
			int l;
			ButtonImageEventsData bi= new ButtonImageEventsData(((ButtonImage) sender).ID,""); 
            if ((l=arButtonImageEvents.IndexOf(bi))<0) return; 
			ModifySetOfRecordsFromCombo(((ButtonImageEventsData)arButtonImageEvents[l]).btDBQuery);
			BindGrid();
		}

		protected  virtual void btnAdd_Click(object sender, EventArgs e)
		{
			if ( nEditPageNum > 0 )
			{
				Redirect(nEditPageNum);
			}
		}

		protected virtual void btnDeleteTournament_Click(object sender, EventArgs e)
		{
			string sIDs = GetCheckedValues(Config.MainCheckboxName);
			ApiControl  oTourn=Config.GetApIEngine(); 
			string []ss=sIDs.Split(new char[] {','});
			int k=0;
			for(k=0;k<ss.Length;k++)
			{
				int iid=Utils.GetInt(ss[k]);
				if (iid >0)
				{
					oTourn.DropTournament(iid);
				}
			}		

			ModifySetOfRecordsFromCombo(sIDs, sDbDeleteQuery);
			BindGrid();

			oTourn=null;
		}

		protected virtual void btnDeleteProcess_Click(object sender, EventArgs e)
		{
			string sIDs = GetCheckedValues(Config.MainCheckboxName);
			ModifySetOfRecordsFromCombo(sIDs, sDbDeleteQuery);
			BindGrid();
		}

		protected virtual void btnDelete_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(sDbDeleteQuery);
			BindGrid();
		}
		protected void btnEnable_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(sDbEnableQuery,1);
			BindGrid();
		}
		protected void btnDisable_Click(object sender, EventArgs e)
		{
			ModifySetOfRecordsFromCombo(sDbDisableQuery,2);
			BindGrid();
		}
		protected void btnSearchAgain_Click(object sender, EventArgs e)
		{
			BindGrid();
		}

		protected override void AfterModifySetOfRecordsFromCombo(string sProcedureName,string sIDs,int typeAction)
		{
		}
		protected void PrepareHyperLinkColumnWithQueryString(int nColNum, string sDataField, string sDataNavigateField)
		{
			if ( sUrlFormatString == string.Empty )
			{
				string paramMenu = "?";
				NameValueCollection  s=Request.QueryString;
				int l;
				for(l=0;l<s.Count;l++)
				{
                   paramMenu += s.GetKey(l)+"="+Request[s.GetKey(l)].ToString()+"&"; 
				}

				if ((Request[Config.ParamMenu]!=null) && (Request[Config.ParamMenu]!=""))
				{
					paramMenu += Config.ParamMenu + "=" + Request[Config.ParamMenu] + "&";
				}
				PageInfo oPage = FindPage(nEditPageNum);
				if ( oPage != null ) sUrlFormatString = oPage.PageBaseUrl + paramMenu + oPage.PageMainParam + "={0}";
			}
			if ( sUrlFormatString != string.Empty )
			{
				Core.PrepareHyperLinkColumn(oParentGrid, nColNum, sDataField, sDataNavigateField, sUrlFormatString);
			}
		}

		protected void PrepareHyperLinkColumn(int nColNum, string sDataField, string sDataNavigateField)
		{
			PrepareHyperLinkColumn( nColNum, sDataField, sDataNavigateField,"");
		}
		protected void PrepareHyperLinkColumn(int nColNum, string sDataField, string sDataNavigateField, string CustomPrm)
		{
			if ( sUrlFormatString == string.Empty )
			{
				string paramMenu = "?";
				if ((Request[Config.ParamMenu]!=null) && (Request[Config.ParamMenu]!=""))
				{
					paramMenu += Config.ParamMenu + "=" + Request[Config.ParamMenu] + "&";
				}
				PageInfo oPage = FindPage(nEditPageNum);
				if ( oPage != null ) sUrlFormatString = oPage.PageBaseUrl + paramMenu + oPage.PageMainParam + "={0}";
			}
			if ( sUrlFormatString != string.Empty)
			{
				if (CustomPrm != String.Empty && sUrlFormatString.IndexOf(CustomPrm,0)<0 )
					sUrlFormatString+="&"+CustomPrm;
				Core.PrepareHyperLinkColumn(oParentGrid, nColNum, sDataField, sDataNavigateField, sUrlFormatString);
			}
		}

		protected void PrepareHyperLinkColumn(int nPageNum, int nColNum, string sDataField, string sDataNavigateField)
		{
			string sFormatStr = string.Empty;
			PageInfo oPage = FindPage(nPageNum);

			string paramMenu = "?";
			if ((Request[Config.ParamMenu]!=null) && (Request[Config.ParamMenu]!=""))
			{
				paramMenu += Config.ParamMenu + "=" + Request[Config.ParamMenu] + "&";
			}
			if ( oPage != null ) sFormatStr = oPage.PageBaseUrl + paramMenu + oPage.PageMainParam + "={0}";
			if ( sFormatStr != string.Empty )
			{
				Core.PrepareHyperLinkColumn(oParentGrid, nColNum, sDataField, sDataNavigateField, sFormatStr);
			}
		}
		protected virtual void BindGrid()
		{
			/*if ( oGridPager != null && oFilter != null )
			{
				oGridPager.BindGrid(oFilter.GenerateDataSource());
				string filterParam = oFilter.GenerateParamString();
				StoreFilter(filterParam);
			}
			else*/ if ( oSGridPager != null && oFilter != null )
			{
				oSGridPager.BindGrid();
				string filterParam = oFilter.GenerateParamString();
				StoreFilter(filterParam);
			}
		}

		#region Init Page section
		override protected void OnInit(EventArgs e)
		{
			InitializeComponent();
			base.OnInit(e);
		}

		private void InitializeComponent()
		{
			this.Load += new EventHandler(this.Page_Load);
		}
		#endregion
	}
}
