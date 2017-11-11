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

namespace Admin.Games
{
	/// <summary>
	/// Summary description for GameProcessMaintenance.
	/// </summary>
	public class GamesMaintenance : Components.MaintenancePage
	{
		protected System.Web.UI.WebControls.DataGrid oGrid;
	
		public GamesMaintenance()
		{
			nEditPageNum     = Config.PageGamesMaintenance;
			sDbDeleteQuery   = Config.DbDeleteGame;
			sGridSourceQuery = Config.DbGetGameList;
		}
		protected override void BindGrid()
		{
			//PrepareHyperLinkColumn(1, "EngineName", "id");
			//PrepareHyperLinkColumn(2, "ComVersion", "id");
			PrepareHyperLinkColumn(0, "EngineName", "");
			PrepareHyperLinkColumn(1, "ComVersion", "");
			base.BindGrid();
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

		}
		#endregion
	}
}
