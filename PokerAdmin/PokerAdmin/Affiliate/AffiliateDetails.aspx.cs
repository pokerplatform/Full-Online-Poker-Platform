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
using System.Web.Mail;

using Common;
using Common.Web;
using Common.Com;
using Admin.CommonUse;

namespace Admin.Affiliate
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class AffiliateDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
	
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected Controls.ButtonImage btnSave;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnAffiliateID;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator2;
		protected System.Web.UI.WebControls.TextBox txtEmail;
		protected System.Web.UI.WebControls.RegularExpressionValidator RegularExpressionValidator1;
		protected System.Web.UI.WebControls.DropDownList ddStatus;
		protected System.Web.UI.WebControls.CheckBox chDeny;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnState;
		protected System.Web.UI.WebControls.DropDownList ddSkins;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator3;
		protected System.Web.UI.WebControls.TextBox txtPassword;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator9;
		protected System.Web.UI.WebControls.TextBox txtBeneficiaryName;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator10;
		protected System.Web.UI.WebControls.TextBox txtAddress;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator11;
		protected System.Web.UI.WebControls.TextBox txtCity;
		protected System.Web.UI.WebControls.DropDownList ddState;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator12;
		protected System.Web.UI.WebControls.TextBox txtZip;
		protected System.Web.UI.WebControls.DropDownList ddCountry;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator5;
		protected System.Web.UI.WebControls.TextBox txtFirstName;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator6;
		protected System.Web.UI.WebControls.TextBox txtLastName;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator7;
		protected System.Web.UI.WebControls.TextBox txtTitle;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator8;
		protected System.Web.UI.WebControls.TextBox txtPhone;
		protected System.Web.UI.WebControls.TextBox txtFax;
		protected int nAffiliateID = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{
			nAffiliateID = GetMainParamInt(hdnAffiliateID);
			BackPageUrl= (string )Session["AffiliateMaintenanceUrl"];    
			if ( !IsPostBack )
			{
				DBase.FillList(ddStatus,"admDictionaryStatusForAffiliate",false); 
				DBase.FillList(ddSkins ,"admGetDictionarySkins",false); 
				DBase.FillList(ddState,Config.DbDictionaryState,false);  
				DBase.FillList(ddCountry, Config.DbDictionaryCountry,false);
				ddSkins.Items.RemoveAt(0);  
				GetData();
			}
		}
	

		/// <summary>
		/// Retrieve DB data to place to the page
		/// </summary>
		protected void GetData()
		{
			if (nAffiliateID>0)
			{
				DataRow oDR = GetFirstRow(Config.DbGetAffiliateDetails, new object[]{"@ID", nAffiliateID});
				if ( oDR != null )
				{
					txtName.Text = oDR["Name"].ToString();
					txtEmail.Text= oDR["EmailFrom"].ToString();
					string st=oDR["StatusID"].ToString();
					Common.Web.Core.SelectItemByValue(ddStatus, st);   
					st=oDR["SkinsID"].ToString();
					Common.Web.Core.SelectItemByValue(ddSkins,st); 
					if (st=="5") chDeny.Enabled =true; 
					txtPassword.Text=oDR["Password"].ToString();
					Common.Web.Core.SelectItemByValue(ddState,oDR["StateID"].ToString());
					txtBeneficiaryName.Text=oDR["BeneficiaryName"].ToString();
					txtAddress.Text=oDR["MailingAddress"].ToString();
					txtCity.Text=oDR["City"].ToString();
					txtZip.Text =oDR["Zip"].ToString();
					Common.Web.Core.SelectItemByValue(ddCountry,oDR["CountryID"].ToString());
					txtFirstName.Text=oDR["FirstName"].ToString();
					txtLastName.Text=oDR["LastName"].ToString();
					txtTitle.Text=oDR["Title"].ToString();
					txtPhone.Text=oDR["Phone"].ToString();
					txtFax.Text=oDR["Fax"].ToString();   
					hdnState.Value =st;
				}
			}
		}

		protected void btnReturn_Click(object sender, System.EventArgs e)
		{
			string CustomerSupportListUrl = FindPageAbsoluteUrl(Config.PageAffiliateMaintenance);
			Response.Redirect(CustomerSupportListUrl);
		}

		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			string tranName = "SaveAffiliate";
			DBase.BeginTransaction(tranName);
			bool rez=false;
            lblInfo.Text ="";
			lblInfo.ForeColor = Color.Red;

			try
			{
				if (chDeny.Checked )
				{
					DBase.Execute(Config.DbDeleteAffiliate,new object[] {"@IDs",nAffiliateID.ToString() });  
					btnReturn_Click(null,null);
					return;
				}

				//1. Save/Update affiliate in DB
				int nRes = DBase.ExecuteReturnInt(Config.DbSaveAffiliateDetails,
					"@ID", nAffiliateID, "@Name", txtName.Text,"@EmailFrom",txtEmail.Text,"@StatusID",int.Parse( ddStatus.SelectedValue ),
					"@SkinsID",int.Parse( ddSkins.SelectedValue ),"@Password",txtPassword.Text,"@BeneficiaryName",txtBeneficiaryName.Text ,"@MailingAddress",
					txtAddress.Text,"@City",txtCity.Text ,"@StateID",int.Parse(ddState.SelectedValue) ,"@Zip",txtZip.Text ,
					"@CountryID",int.Parse(ddCountry.SelectedValue),"@FirstName",txtFirstName.Text  ,
					"@LastName",txtLastName.Text ,"@Title",txtTitle.Text ,"@Phone",txtPhone.Text ,"@Fax",txtFax.Text  );
				if (nRes<=0)
				{
					switch( nRes )
					{
						case -1:
							lblInfo.Text = "Such Affiliate name already exists";
							break;
						default:
							lblInfo.Text = "Database error occured";
							break;
					}
					DBase.RollbackTransaction(tranName);
					return;
				}
				// Everything is Ok
				DBase.CommitTransaction(tranName);
				nAffiliateID = nRes;
				hdnAffiliateID.Value = nRes.ToString();
				StoreBackID(nRes);
				lblInfo.Text = "Affiliate has been saved";
				lblInfo.ForeColor = Color.Green;

				if (hdnState.Value != ddStatus.SelectedValue && ddStatus.SelectedValue =="4")
				{
					string val=Config.GetDbConfigValue(DBase,18);  //Template name for affiliates
					if (val==String.Empty) 
					{
						rez=true;
						return;
					}
					DataTable tb=DBase.GetDataTable(Config.DbGetEmailTemplateDetailsByName,"@Name", val);
					if (tb==null)
					{
						rez=true;
						return;
					}
					if (tb.Rows.Count <=0) 
					{
						rez=true;
						return;
					}
					val=Config.GetDbConfigValue(DBase,1); // Admin Email
					if (val==String.Empty) 
					{
						rez=true;
						return;
					}
					CommonUse.CSentMail.Send(DBase,txtEmail.Text,val,tb.Rows[0]["subject"].ToString() ,  //Send message as autoresponder
						tb.Rows[0]["body"].ToString().Replace("<BR>","\n").Replace("<br>","\n").Replace("&nbsp;"," "),3  , MailFormat.Text);   
				}
			}
			catch(Exception ex)
			{
				Common.Log.Write(this,ex);   
				DBase.RollbackTransaction(tranName);
				lblInfo.Text = "Error occured";
				lblInfo.ForeColor = Color.Red;
			}
			finally
			{
				if (rez)
				{
					lblInfo.Text+= "  Error send Email";
					lblInfo.ForeColor = Color.Red;
				}
				if (lblInfo.ForeColor != Color.Red) 
					btnReturn_Click(null,null);
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
