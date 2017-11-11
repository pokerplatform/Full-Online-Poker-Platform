using System;
using Admin.Components;

namespace Admin.Games
{
	public class Bots : MaintenancePage
	{
	
		protected Admin.Controls.Bots botProcess;
		protected Admin.Controls.Bots  botTourn;
		protected Admin.Controls.Bots botSitGo;

		protected override void Page_Load(object sender, EventArgs e)
		{
			botProcess.Target =Admin.Controls.Bots.enControlFor.Process;
			botProcess.Visible = botProcess.CanBeVisible;
            botTourn.Target =Admin.Controls.Bots.enControlFor.Tournament; 
			botTourn.Visible = botTourn.CanBeVisible;
			botSitGo.Target = Admin.Controls.Bots.enControlFor.TournamentSitEndGo ;
			botSitGo.Visible = botSitGo.CanBeVisible;
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
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

	}
}
