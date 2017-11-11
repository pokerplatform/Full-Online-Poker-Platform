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

using Common.WebControls;  
using Common.Web;

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for Chat.
	/// </summary>
	public class Chat : Components.MaintenancePage
	{
	
		int ProcID=0;
		protected System.Web.UI.WebControls.DropDownList ddGames;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnSelGame;
		int GameID=0;

		protected override void Page_Load(object sender, System.EventArgs e)
		{
             
            if (Request["isProcess"]=="1")
				ProcID=int.Parse(Request["ID"]);
            else 
				GameID=int.Parse(Request["ID"]);

			if (!IsPostBack)
			{
				hdnSelGame.Value="0";
                DataTable tb= DBase.GetDataTable("admGetGameProcessList2","@TournID",ProcID,"@GameProcID",GameID);   
				if (tb.Rows.Count >0) 
				{
					Core.SelectItemByValue(ddGames,tb.Rows[0]["ID"].ToString());    
					hdnSelGame.Value=tb.Rows[0]["ID"].ToString();
				}
				Core.FillList(ddGames,tb);
			}
				if (hdnSelGame.Value == String.Empty) 
					Core.SelectItemByValue(ddGames,hdnSelGame.Value);    
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
			this.ddGames.SelectedIndexChanged += new System.EventHandler(this.ddGames_SelectedIndexChanged);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void ddGames_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			hdnSelGame.Value=ddGames.SelectedValue;  
		}
	}
}
