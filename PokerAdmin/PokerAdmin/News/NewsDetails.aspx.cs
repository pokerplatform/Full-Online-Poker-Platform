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

using Common;
using Common.Web;
using Admin.CommonUse;

namespace Admin.News
{
	/// <summary>
	/// Summary description for OutcomeDetails.
	/// </summary>
	public class NewsDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator2;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnEventID;

		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnNewsID;
		protected int nNewsID = 0;
		protected System.Web.UI.WebControls.TextBox txtSubject;
		protected System.Web.UI.WebControls.Label lblDate;
		protected System.Web.UI.WebControls.TextBox txtBody;
		protected int nEventID = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{
			nNewsID = GetMainParamInt(hdnNewsID);
			if ( !IsPostBack )
			{
				GetPageData();
			}
		}
		private void GetPageData()
		{
			if (nNewsID>0)
			{
				DataRow oDR = GetFirstRow(Config.DbGetEventNewsDetails, new object[]{"@ID", nNewsID});
				if ( oDR != null )
				{
					txtSubject.Text = oDR["Subject"].ToString();
					txtBody.Text    = oDR["Body"].ToString();
					lblDate.Text    = oDR["NewsDate"].ToString();
					hdnEventID.Value = Utils.GetInt(oDR["EventID"]).ToString();
				}
			}
			
		}


		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			//Invoke Com Api method to process outcomes
			ComProperty oCom = new ComProperty();
			string comData = string.Format("<objects xmlns='nsAction'><object name='pobuddywager.buddywager'><actions xmlns='nsAction'><sbmovetoticker newsid='{0}'/></actions></object></objects>", nNewsID);
			string sResult = oCom.InvokeMember(Config.ComApi, Config.ComApiCreateRemind,  0, 0, DateTime.Now, comData, "", "");
			if (sResult==null)
			{
				lblInfo.ForeColor = Color.Red;
				lblInfo.Text = "Com Error occured.";
				return;
			}

			int nRes = 0;
			int nEventID = GetParamInt(Config.ParamEventID);
			if (nEventID <= 0)
			{
				nEventID = Utils.GetInt(hdnEventID.Value);
			}

			string strNewsDate = "";
			if ( nEventID > 0 )
			{
				SqlCommand oCmd = DBase.GetCommand(Config.DbSaveEventNewsDetails);
				SqlParameterCollection oParams = oCmd.Parameters;

				oParams.Add("@EventNewsID", nNewsID);
				oParams.Add("@EventID", nEventID);
				oParams.Add("@Subject", txtSubject.Text);
				oParams.Add("@Body", txtBody.Text);
				SqlParameter oParam = new SqlParameter("@NewsDate", System.Data.SqlDbType.DateTime);
				oParam.Direction = ParameterDirection.Output;
				oParams.Add(oParam);

				nRes = DBase.ExecuteReturnInt(oCmd);
				strNewsDate = oParams["@NewsDate"].Value.ToString();
			}
			else nRes = -10;

			if ( nRes > 0 )
			{
				hdnNewsID.Value = nRes.ToString();
				StoreBackID(nRes);
				lblDate.Text= strNewsDate;

				lblInfo.ForeColor = Color.Green;
				lblInfo.Text = "News details have been saved";

				Response.Redirect(GetGoBackUrl());
			}
			else
			{
				switch( nRes )
				{
					case -10:
						lblInfo.Text = "Not specified event! (Parameter error)";
						break;
					case 0:
						lblInfo.Text = "Database error occured";
						break;
					default:
						lblInfo.Text = "Unknown error occured";
						break;
				}
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
