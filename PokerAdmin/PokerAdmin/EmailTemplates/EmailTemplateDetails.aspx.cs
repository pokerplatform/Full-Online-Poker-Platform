using System;
using System.IO;
using System.Text;
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
using Admin.EmailTemplates;

namespace Admin.EmailTemplates
{
	/// <summary>
	/// Summary description for TemplateEdit.
	/// </summary>
	public class EmailTemplateDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblError;
		protected System.Web.UI.WebControls.TextBox txtSubject;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvName;
		protected Controls.ButtonImage btnSave;
		protected System.Web.UI.HtmlControls.HtmlInputFile fileHtml;
		protected System.Web.UI.HtmlControls.HtmlTextArea txtBody;
		protected System.Web.UI.WebControls.Label lblName;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnFieldTemplateList;

		protected const string templateImageUrl = "{ImageUrl}";
		protected const string templateLetterBody = "{LetterBody}";

		protected int nTemplateID = 0;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			nTemplateID = GetMainParamInt();
			lblError.EnableViewState = false;
			BackPageUrl= (string) Session["EmailTemplateMaintenanceUrl"];
			if ( !IsPostBack )
			{
				GetData();
			}
			InitJavascript();
		}

		private void GetData()
		{
			DataRow oDR = GetFirstRow(Config.DbGetEmailTemplateDetails, new string[]{"@ID", nTemplateID.ToString()});
			if ( oDR != null )
			{	
				lblName.Text    = oDR["EmailTemplateName"].ToString();
				txtSubject.Text = oDR["Subject"].ToString();
				txtBody.Value   = oDR["Body"].ToString();
				hdnFieldTemplateList.Value = oDR["FieldTemplateList"].ToString();
			}
		}

		protected void InitJavascript()
		{
			btnSave.NavigateUrl = "SaveIt";
			btnSave.oLink.Attributes["onclick"] = "return beforeSubmit();";

			RegisterClientScriptBlock("popup", string.Format("<SCRIPT language=\"JavaScript\" id=\"clientJSDefinePopup\">{0}</SCRIPT>", GetPopupArray() ));
		}

		protected string GetPopupArray()
		{
			string FieldTemplateList = hdnFieldTemplateList.Value;
			DataTable oDT = GetDataTable(Config.DbGetFieldTemplateList, "@Names", FieldTemplateList);

			string sReturn = 
				"var menuStrings = new Array();\n"
				+"var menuStates = new Array();\n"
				+"var mergeTags = new Array();\n";
			for(int i=0;i<oDT.Rows.Count;i++)
			{
				DataRow oDR = oDT.Rows[i];
				sReturn += "menuStrings[" + i + "]=\"" + oDR["longName"].ToString() + "\";\n";
				sReturn += "menuStates[" + i + "]=0;\n";
				sReturn += "mergeTags[" + i + "]=\"" + oDR["templateName"].ToString()+"\";\n";
			}

			return sReturn;
		}

		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			int nRes = DBase.ExecuteReturnInt(Config.DbSaveEmailTemplate, "@ID", nTemplateID,
				"@Subject", txtSubject.Text, "@Body", Server.HtmlDecode(txtBody.Value),
				"@TemplateBody", templateLetterBody, "@TemplatePath", templateImageUrl,
				"@TemplatePathValue", Config.FileEmailTemplateUrl);
			if ( nRes > 0 )	
			{
				Redirect(GetGoBackUrl());
			}
			else
			{
				lblError.Text = "Database error occured";
				lblError.ForeColor = Color.Red;
			}
		}

		protected void btnUpload_Click(object sender, System.EventArgs e)
		{
			HttpPostedFile oFile = fileHtml.PostedFile;
			if ( oFile != null && oFile.ContentLength > 0 )
			{
				byte[] buff = new Byte[oFile.ContentLength];
				oFile.InputStream.Read(buff, 0, buff.Length);
				ASCIIEncoding enc = new ASCIIEncoding();
				txtBody.Value = enc.GetString(buff);
			}
			else
			{
				lblError.Text = "File is empty";
				lblError.ForeColor = Color.Red;
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
