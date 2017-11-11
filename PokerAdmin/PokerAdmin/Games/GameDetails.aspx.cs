using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Reflection;
using System.Xml;
using System.IO;

using Common;
using Common.Web;
using Common.Com;

namespace Admin.Games
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class GameDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
	
		protected int nComNameID = 1;
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.DropDownList comboComName;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnGameEngineID;
		protected System.Web.UI.WebControls.Label lblVersion;
		protected System.Web.UI.WebControls.Label lblComName;
		protected Controls.ButtonImage btnSave;
		protected int nGameEngineID = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nGameEngineID = GetMainParamInt(hdnGameEngineID);
			BackPageUrl= (string) Session["GameMaintenanceUrl"];		
			if ( !IsPostBack )
			{
				GetData();
			}
		}
	

		/// <summary>
		/// Retrieve DB data to place to the page
		/// </summary>
		protected void GetData()
		{
			if (nGameEngineID>0)
			{
				//
			}
			else
			{
				//DataTable dt = DBase.GetDataTable(Config.DbGetGameList);
			}
		}


		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(GetGoBackUrl());
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

