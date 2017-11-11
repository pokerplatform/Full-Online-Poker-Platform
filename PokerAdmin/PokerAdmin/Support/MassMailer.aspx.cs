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
using System.Text.RegularExpressions ; 
using System.Web.Mail;

namespace Admin.Support
{
	/// <summary>
	/// Summary description for MassMailer.
	/// </summary>
	public class MassMailer : Common.Web.Page
	{
		protected System.Web.UI.WebControls.TextBox txtAdr;
		protected System.Web.UI.WebControls.TextBox txtmessage;
		protected System.Web.UI.WebControls.TextBox txtSubject;
		protected System.Web.UI.WebControls.Label lbNotSent;
		protected System.Web.UI.WebControls.DropDownList ddTmpl;
		protected System.Web.UI.WebControls.Button btFill;
		protected System.Web.UI.WebControls.DropDownList ddSendAs;
		protected System.Web.UI.WebControls.Label lblInfo;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			if (!IsPostBack)
			{
				DBase.FillList(ddTmpl,"admGetEmailTemplateForList",false);
				ddSendAs.Items.Add(new ListItem("Text",MailFormat.Text.ToString()));      
				ddSendAs.Items.Add(new ListItem("HTML",MailFormat.Html.ToString()));      
			}
		}

		protected void btnSend_Click(object sender, System.EventArgs e)
		{
            string [] adr = txtAdr.Text.Split(',');  
			string strNotSent="";
			lblInfo.ForeColor =Color.Red;
			lblInfo.Text ="";
			Regex rx=new Regex(@"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");  
			string admAddr=Config.GetDbConfigValue(DBase,  1);
			if (!rx.IsMatch(admAddr))
			{
				lblInfo.Text ="Email Address of Administrator is'nt correct";
				return;
			}
			int notSent=0;
			if (txtSubject.Text.Trim() ==String.Empty)
			{
				lblInfo.Text ="Enter subject , please";
				return;
			}
			foreach (string sadr in adr)
			{
				string tadr=sadr.Trim(); 
				if (!rx.IsMatch(tadr))
				{
					Common.Log.Write(this,"Email address is'nt correct :"+tadr);  
					notSent ++;
					strNotSent+=(tadr+"<br>");
				}
				else
				{
					MailFormat mf=  ddSendAs.SelectedValue.ToLower()=="html"?MailFormat.Html : MailFormat.Text ;  
					if (CommonUse.CSentMail.Send(DBase,tadr, admAddr,txtSubject.Text,txtmessage.Text,mf) !=0)
						notSent++; 
					strNotSent+= (tadr+"<br>");
				}
			}

			if(notSent ==0)
			{
				lblInfo.Text ="Mail Sent OK";
				lblInfo.ForeColor =Color.Green;  
			}
			else
			{
				lblInfo.Text =String.Format( "Mail has'nt been send to {0} addresses",notSent); 
				lbNotSent.Text=strNotSent;
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
			this.btFill.Click += new System.EventHandler(this.btFill_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void btFill_Click(object sender, System.EventArgs e)
		{
			 if (ddTmpl.Items.Count <=0) return; 
		      DataTable tb=DBase.GetDataTable(Config.DbGetEmailTemplateDetails,"@ID",int.Parse( ddTmpl.SelectedValue));
			 if (tb==null) return;
			 if(tb.Rows.Count <=0) return;
			 txtSubject.Text=tb.Rows[0]["subject"].ToString() ; 
			 txtmessage.Text=tb.Rows[0]["body"].ToString() ; 
		}

	}
}
