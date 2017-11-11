using System;
using System.Data;
using System.Web.UI.WebControls;
using Admin.Components;
using Admin.Controls;
using Common;
using DesktopAPIEngine;

namespace Admin.Tournaments
{
	/// <summary>
	/// Summary description for GameProcessMaintenance.
	/// </summary>
	public class TournamentMaintenance : MaintenancePage
	{
		protected DataGrid oGrid;
		protected int nType=1;
	
		protected override void Page_Load(object sender, EventArgs e)
		{
			nType=Utils.GetInt ( Request["type"]);
			if (nType==0) nType=1;

			if ( oSGridPager != null )
			{
				oParentGrid = oSGridPager.GridObject;
				oSGridPager.oCustParams.Add ("@CategoryTypeID"); 
				oSGridPager.oCustParams.Add (nType); 
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
			if ( !IsPostBack )
			{
			    Session["TournamentMaintenanceUrl"]=Request.Url.AbsoluteUri;   
				Session["LastUrl"]=Request.Url.AbsoluteUri;   
			}
		}

		public TournamentMaintenance()
		{
			nEditPageNum     = Config.PageTournamentDetails;
			sDbDeleteQuery   = Config.DbDeleteTournament;
			sGridSourceQuery = Config.DbGetTournamentList;
		}

		protected  override void btnAdd_Click(object sender, EventArgs e)
		{
			if ( nEditPageNum > 0 )
			{
				Redirect(nEditPageNum,"?type="+nType.ToString());
			}
		}

		protected override void BindGrid()
		{
			PrepareHyperLinkColumn(1, "TournamentName", "id","type="+nType.ToString());
			PrepareHyperLinkColumn(2, "TournamentStartTime", "id","type="+nType.ToString());
			PrepareHyperLinkColumn(3, "TournamentFinishTime", "id","type="+nType.ToString());
			PrepareHyperLinkColumn(4, "TournamentType", "id","type="+nType.ToString());
			PrepareHyperLinkColumn(5, "TournamentLevel", "id","type="+nType.ToString());
			PrepareHyperLinkColumn(6, "TournamentStatus", "id","type="+nType.ToString());
			PrepareHyperLinkColumn(7, "CategoryName", "id","type="+nType.ToString());
			PrepareHyperLinkColumn(8, "TotalPrize", "id","type="+nType.ToString());
			PrepareHyperLinkColumn(9, "TournamentUserCount", "id","type="+nType.ToString());
			base.BindGrid();
		}

		protected void DoPause(bool pause)
		{
			ApiControl  tc =Config.GetApIEngine() ;
			try
			{
				string sIDs= GetCheckedValues(Config.MainCheckboxName);
				string [] s= sIDs.Split(new char [] {','});
				int l;
				for (l=0;l<s.Length ;l++)
				{
					if (s[l] != String.Empty) 
					{
						if (pause)
						  tc.UpdateSelectedTournamentsStatus(2,Utils.GetInt(s[l]));
						else
						  tc.UpdateSelectedTournamentsStatus(1,Utils.GetInt(s[l]));
					}
				}
			}
			finally
			{
				BindGrid();
				tc=null;
			}
		}

		protected void btnTournPause_Click(object sender, EventArgs e)
		{
			DoPause(true);
		}

		protected void btnTournResume_Click(object sender, EventArgs e)
		{
			DoPause(false);
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
			this.oGrid.ItemDataBound += new DataGridItemEventHandler(this.oGrid_ItemDataBound);

		}
		#endregion

		private void oGrid_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			if (e.Item.Cells[10].Controls.Count >0)
			{
				ButtonImage ct=( (ButtonImage) e.Item.Cells[10].Controls[1]);
				ct.NavigateUrl ="..\\Users\\UsersMaintenance.aspx?ProcessIDForUsers=" +((DataRowView)  e.Item.DataItem)[0].ToString()+
													"&IsTournament=1&Status="+((DataRowView)  e.Item.DataItem)[6].ToString();
			}
		}
	}
}
