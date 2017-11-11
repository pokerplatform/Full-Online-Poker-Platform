namespace Promo
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using System.IO;

	using Common;

	public class Banners : System.Web.UI.UserControl
	{
		private int SKID=0;
		private int AFFID=0;
		private string[] FilesList;
		private string _output="";
		private int imgNum=0;
		private string BannersPath="";

		private void Page_Load(object sender, System.EventArgs e)
		{
 	        if (Session["AffSgUP_SkinID"]==null) return;
			if (Session["AffSgUP_AffID"]==null) return;
			if (Session["AffSgUP_FilesList"]==null ) return;
            SKID=Utils.GetInt(Session["AffSgUP_SkinID"]);
			if (SKID==0) return;
			AFFID=Utils.GetInt(Session["AffSgUP_AffID"]);
			if (AFFID==0) return;
			FilesList = (string[])Session["AffSgUP_FilesList"];  
			if (FilesList.Length <=0) return;
            BannersPath=Config.GetConfigValue("SkinsBannerURL")+"Skin_"+SKID.ToString() +"/Banner/";
			foreach(string fn in FilesList)
			{SetText(Path.GetFileName(fn));}
		}

		private void SetText(string filename)
		{
			_output+="<TABLE align=\"center\"><TR><TD align=\"center\"><img src=\""+
			                   BannersPath+filename+"\"></TD></TR><TR><TD align='center'><TEXTAREA rows=\"5\" cols=\"40\" readonly=\"true\">"+
				               "<table><tr><td><a href=\""+Config.GetConfigValue("InstallersUrl")+"Skin_"+SKID.ToString() +"/Installer/"+
				          string.Format(Config.GetConfigValue("InstallersFile"),AFFID)+
                          "\"><img src=\""+BannersPath+filename+"\"></a></td></tr></table></TEXTAREA></TD></TR></TABLE>";  
			imgNum++;
		}


		override protected void Render( System.Web.UI.HtmlTextWriter output)
		{
			 output.Write(_output); 
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
