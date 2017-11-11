namespace Admin.Transactions
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;


	/// <summary>
	///		Summary description for GameHistory.
	/// </summary>
	public abstract class TournamentHistory : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.Label lblName;


		private void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
		}

		public string Details(System.Web.UI.Page page, int nTournamentID)
		{
			Common.Web.Page oPage  = page as Common.Web.Page;
			Common.Web.Core oDB = oPage.DBase;
			string sError = "";

			if (nTournamentID>0)
			{
				DataRow oDR = oDB.GetFirstRow(Config.DbGetTournamentDetails, new object[]{"@ID", nTournamentID});
				if ( oDR != null )
				{
					lblName.Text = "Tournament Name: " + oDR["TournamentName"].ToString();
				}
			}
			return sError;
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

		}
		#endregion
	}
}
