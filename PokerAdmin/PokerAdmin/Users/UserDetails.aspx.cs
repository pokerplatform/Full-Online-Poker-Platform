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

namespace Admin.Users
{
	/// <summary>
	/// Summary description for SubCategoryDetails.
	/// </summary>
	public class UserDetails : Common.Web.Page
	{
		protected System.Web.UI.WebControls.Label lblInfo;
		protected System.Web.UI.WebControls.DropDownList comboStatus;
	
		protected int nSexID = 1;
		protected int nStateID = 0;
		protected int nCountryID = 0;
		protected int nStatusID = 1;
		protected System.Web.UI.WebControls.TextBox txtFirstName;
		protected System.Web.UI.WebControls.DropDownList comboSex;
		protected System.Web.UI.WebControls.TextBox txtLastName;
		protected System.Web.UI.WebControls.TextBox txtEmail;
		protected System.Web.UI.WebControls.TextBox txtLocation;
		protected System.Web.UI.WebControls.TextBox txtLogin;
		protected System.Web.UI.WebControls.TextBox txtPassword;
		protected System.Web.UI.WebControls.TextBox txtRetypePassword;
		protected System.Web.UI.WebControls.Label lblPasswordWarning;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator2;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator3;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator5;
		protected System.Web.UI.WebControls.CustomValidator CustomValidator1;
		protected System.Web.UI.WebControls.RequiredFieldValidator ReqValidatorPassword;
		protected System.Web.UI.WebControls.RequiredFieldValidator ReqValidatorRetypePassword;
		protected System.Web.UI.WebControls.RegularExpressionValidator RegularExpressionValidatorEmail;
		protected System.Web.UI.WebControls.TextBox txtAddress;
		protected System.Web.UI.WebControls.TextBox txtCity;
		protected System.Web.UI.WebControls.TextBox txtZip;
		protected System.Web.UI.WebControls.TextBox txtPhone;
		protected System.Web.UI.WebControls.DropDownList comboState;
		protected System.Web.UI.WebControls.DropDownList comboCountry;
		protected Controls.ButtonImage btnSave;
		protected Controls.ButtonImage btnCancel;
		protected Controls.ButtonImage btnUserAccount;
		protected System.Web.UI.HtmlControls.HtmlTableRow rowStats;
		protected System.Web.UI.HtmlControls.HtmlTableRow rowRelatedProcesses;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hdnUserID;
		protected System.Web.UI.WebControls.CheckBox ChatCheck;
		protected System.Web.UI.WebControls.Label lbUserInfo;
		protected System.Web.UI.WebControls.DataGrid oGrid;
		protected int nUserID = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{
			lblInfo.EnableViewState = false;
			nUserID = GetMainParamInt(hdnUserID);
			
            lbUserInfo.Text =" User ID is <B>"+ nUserID.ToString()+"</B>";  

			if ( Session["UsersMaintenanceUrl"] !=null)
				BackPageUrl=(string) Session["UsersMaintenanceUrl"];    
			else
				BackPageUrl= "UsersMaintenance.aspx";    

			if ( !IsPostBack )
			{
				GetData();
				PreparePage();
			}
		}
	
		/// <summary>
		/// Fill both combo boxes
		/// </summary>
		protected void PreparePage()
		{
			DBase.FillList(comboSex, nSexID, Config.DbDictionarySex, false);
			DBase.FillList(comboState, nStateID, Config.DbDictionaryState, false);
			DBase.FillList(comboCountry, nCountryID, Config.DbDictionaryCountry, false);
			DBase.FillList(comboStatus, nStatusID, Config.DbDictionaryStatus, false);

			comboState.Items.Insert(0, new ListItem("- Select State -", "0"));
			comboCountry.Items.Insert(0, new ListItem("- Select Country -", "0"));
			comboState.Items.FindByValue(nStateID.ToString()).Selected = true;
			comboCountry.Items.FindByValue(nCountryID.ToString()).Selected = true;
		}

		/// <summary>
		/// Retrieve data will be placed on the page from the database
		/// </summary>
		protected void GetData()
		{
			if (nUserID > 0 )
			{
				DataRow oDR = GetFirstRow(Config.DbGetUserDetails, new object[]{"@ID", nUserID});
				if ( oDR != null )
				{
					txtFirstName.Text = oDR["FirstName"].ToString();
					txtLastName.Text  = oDR["LastName"].ToString();
					txtEmail.Text     = oDR["Email"].ToString();
					txtLocation.Text  = oDR["Location"].ToString();
					txtLogin.Text     = oDR["LoginName"].ToString();
					txtAddress.Text   = oDR["Address"].ToString();
					txtZip.Text       = oDR["Zip"].ToString();
					txtPhone.Text     = oDR["Phone"].ToString();
					txtCity.Text      = oDR["City"].ToString();
					nStateID          = Utils.GetInt(oDR["StateID"]);
					nCountryID        = Utils.GetInt(oDR["CountryID"]);
					nSexID            = Utils.GetInt(oDR["SexID"]);
					nStatusID         = Utils.GetInt(oDR["StatusID"]);
					ChatCheck.Checked = (Utils.GetInt(oDR["ChatAccess"])== 0? false : true);
				}
			}
			ShowControls();
		}

		protected void ShowControls()
		{
			bool bRes = (nUserID > 0);
			btnUserAccount.Visible = bRes;
			lblPasswordWarning.Visible = bRes;
			ReqValidatorPassword.Visible = !bRes;
			ReqValidatorRetypePassword.Visible = !bRes;
			if (Request[Config.ParamBack]=="no") btnCancel.Visible = false;
		}

		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			
			int nRes = 0;

			SqlCommand oCmd = DBase.GetCommand(Config.DbSaveUserDetails);
			SqlParameterCollection oParams = oCmd.Parameters;

			//user Data
			oParams.Add("@ID", nUserID);
			oParams.Add("@FirstName", txtFirstName.Text);
			oParams.Add("@LastName", txtLastName.Text);
			oParams.Add("@Email", txtEmail.Text);
			oParams.Add("@Location", txtLocation.Text);
			oParams.Add("@StatusID", Core.GetSelectedValueInt(comboStatus));
			oParams.Add("@SexID", Core.GetSelectedValueInt(comboSex));
			oParams.Add("@LoginName", txtLogin.Text);
			oParams.Add("@Password", txtPassword.Text);
			//Mailing Address data
			oParams.Add("@Address", txtAddress.Text);
			oParams.Add("@City", txtCity.Text);
			oParams.Add("@Zip", txtZip.Text);
			oParams.Add("@Phone", txtPhone.Text);
			oParams.Add("@StateID", Core.GetSelectedValueInt(comboState));
			oParams.Add("@CountryID", Core.GetSelectedValueInt(comboCountry));
			oParams.Add("@ChatAccess",(ChatCheck.Checked ? 1: 0));

			nRes = DBase.ExecuteReturnInt(oCmd);
			if ( nRes > 0 )
			{
				nUserID = nRes;
				hdnUserID.Value = nRes.ToString();
				StoreBackID(nRes);
				lblInfo.Text = "User has been saved";
				lblInfo.ForeColor = Color.Green;

				Response.Redirect(GetGoBackUrl());

				ShowControls();
			}
			else
			{
				switch( nRes )
				{
					case -1:
						lblInfo.Text = "Such login name already exists";
						break;
					default:
						lblInfo.Text = "Database error occured";
						break;
				}
			}
			
		}

		protected void btnUserAccount_Click(object sender, System.EventArgs e)
		{
			string menuParam = "?" + Config.ParamMenu + "=" + Request[Config.ParamMenu] + "&";
			string pageUrl = FindPageAbsoluteUrl(Config.PageUserDetailsAccount);
			Response.Redirect(pageUrl + menuParam + Config.ParamUserID + "=" + nUserID.ToString());
		}

		protected void btnUserSession_Click(object sender, System.EventArgs e)
		{
            BindUserSession();
        }

		private void BindUserSession()
		{
			DataTable tb= DBase.GetDataTable(Config.DbGetClientSessionHistory,"@ID",nUserID);
			oGrid.DataSource =tb.DefaultView ;
			oGrid.DataBind(); 
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
			this.oGrid.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.oGrid_PageIndexChanged);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void oGrid_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			BindUserSession();
		}
	}
}

