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

namespace Promo
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class AffiliateSignup : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
	
		protected System.Web.UI.WebControls.TextBox txtName;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator2;
		protected System.Web.UI.WebControls.TextBox txtEmail;
		protected System.Web.UI.WebControls.RegularExpressionValidator RegularExpressionValidator1;
		protected System.Web.UI.WebControls.Button btnSignUp;
		protected System.Web.UI.WebControls.DropDownList ddSkins;
		protected System.Web.UI.WebControls.Button btSelectSkin;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnAffiliateID;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator3;
		protected System.Web.UI.WebControls.CheckBox chAgree;
		protected System.Web.UI.WebControls.TextBox txtPassword;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator4;
		protected System.Web.UI.WebControls.TextBox txtPasswordRet;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator5;
		protected System.Web.UI.WebControls.TextBox txtFirstName;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator9;
		protected System.Web.UI.WebControls.TextBox txtBeneficiaryName;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator10;
		protected System.Web.UI.WebControls.TextBox txtAddress;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator11;
		protected System.Web.UI.WebControls.TextBox txtCity;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator6;
		protected System.Web.UI.WebControls.TextBox txtLastName;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator7;
		protected System.Web.UI.WebControls.TextBox txtTitle;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator8;
		protected System.Web.UI.WebControls.TextBox txtPhone;
		protected System.Web.UI.WebControls.TextBox txtFax;
		protected System.Web.UI.WebControls.DropDownList ddState;
		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator12;
		protected System.Web.UI.WebControls.TextBox txtZip;
		protected System.Web.UI.WebControls.DropDownList ddCountry;
		protected System.Web.UI.WebControls.Image oImg;
		protected System.Web.UI.WebControls.Image Image1;
		protected System.Web.UI.WebControls.Image Image2;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnSkinID;

		private void Page_Load(object sender, System.EventArgs e)
		{
			if (!IsPostBack)
			{
				DBase.FillList( ddSkins,"admGetDictionarySkins",false);
				DBase.FillList(ddCountry, Config.DbGetDictionaryCountry,false);
				DBase.FillList(ddState,Config.DbGetDictionaryState,false);
				ddSkins.Items.RemoveAt(0);  
				Session["AffiliateSignup_SkinsID"]=ddSkins.SelectedValue;  
			}
		}

		public string GetCssPageUrl()
		{
			return Config.CommonCssPath;
		}
	
	/*	public string GetBannerURL()
		{
			return Config.GetConfigValue("SkinsBannerURL")+"/Skin_"+ nSkinID.ToString()+"/Banner/"+Config.GetConfigValue("ImageBannerName");  
		}*/

		private void btnSignUp_Click(object sender, System.EventArgs e)
		{

		    int nSkinID = 0;
			nSkinID=Common.Utils.GetInt(ddSkins.SelectedValue); 
			if (nSkinID<=0) return;

			if(!chAgree.Checked)
			{
				lblInfo.Text = "You must agree to the Affiliate Agreement";
				return;
			}

			if (txtPassword.Text != txtPasswordRet.Text)
			{
				lblInfo.Text = "Re-Typed password not equal to Password";
				return;
			}

			string tranName = "SaveAffiliate";

			try
			{
				DBase.BeginTransaction(tranName);

				//1. Save/Update affiliate in DB
				int nRes = DBase.ExecuteReturnInt(Config.DbSaveAffiliateDetails,
					"@ID", -1, "@Name", txtName.Text,"@EmailFrom",txtEmail.Text,"@StatusID",5,"@SkinsID",nSkinID
					,"@Password",txtPassword.Text,"@BeneficiaryName",txtBeneficiaryName.Text ,"@MailingAddress",
					txtAddress.Text,"@City",txtCity.Text ,"@StateID",int.Parse(ddState.SelectedValue) ,"@Zip",txtZip.Text ,
					"@CountryID",int.Parse(ddCountry.SelectedValue),"@FirstName",txtFirstName.Text  ,
					"@LastName",txtLastName.Text ,"@Title",txtTitle.Text ,"@Phone",txtPhone.Text ,"@Fax",txtFax.Text );
				if (nRes<=0)
				{
					switch( nRes )
					{
						case -1:
							lblInfo.Text = "Such Affiliate Login already exists";
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
				lblInfo.Text = "Affiliate has been saved";
				lblInfo.ForeColor = Color.Green;
				Response.Redirect("Signupcomplete.aspx?SkinsID="+nSkinID.ToString() ); 
			}
			catch (Exception ex)
			{
				Log.Write(this,ex); 
				DBase.RollbackTransaction(tranName);
				lblInfo.Text = "Error occured during save data";
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
			this.ddSkins.SelectedIndexChanged += new System.EventHandler(this.ddSkins_SelectedIndexChanged);
			this.btnSignUp.Click += new System.EventHandler(this.btnSignUp_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void ddSkins_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			Session["AffiliateSignup_SkinsID"]=ddSkins.SelectedValue;  
		}


	}
}

