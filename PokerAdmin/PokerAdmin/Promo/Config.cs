using System;
using Common;

namespace Promo
{
	/// <summary>
	/// Summary description for Config.
	/// </summary>
	public class Config
	{
		public Config(){}

		protected	static  System.Configuration.AppSettingsReader oSettingsReader = new System.Configuration.AppSettingsReader();

		public  static  string      SiteRoot			= GetSiteRoot();
		public  static  string   SiteRootFull			= GetSiteRootFull();
		public	static	string	ImageFolder			= SiteRoot + "img/";
		public	static	string	ImageFolderFull			= SiteRootFull + "img/";
		public	static	string	CommonCssPath		= Config.SiteRoot + "styles.css";

		#region ButtonImage control
		public	const	string	DefaultHyperButtonNavigateUrl = "action";
		public	static	string	ButtonImageLeftImage = ImageFolder + "btn_left.gif";
		public	static	string	ButtonImageBodyImage = ImageFolder + "btn_bg.gif";
		public	static	string	ButtonImageBodyImageFull = ImageFolderFull + "btn_bg.gif";
		public	static	string	ButtonImageRightImage = ImageFolder + "btn_right.gif";
		#endregion
		public	static	string	ImageLogoName		= GetImageLogoName();

		public	const	string	DbGetSkinsDetails  = "admGetSkinDetails";
		public	const	string	DbSaveAffiliateDetails = "admSaveAffiliateDetails";
		public	const	string	DbCheckAffiliateLogin		= "admCheckAffiliateLogin";
		public	const	string	DbGetAffiliateInfo = "admGetAffiliateInfo";
		public	const	string	DbGetAffiliateStats="admGetAffiliateStats";
		public	const	string	DbGetDictionaryCountry="admDictionaryCountry";
		public	const	string	DbGetDictionaryState="admDictionaryState";

		private	static string GetSiteRoot()
		{
			string url = GetConfigValue("SiteBaseUrl");
			if ( url != string.Empty )
			{
				Uri oUri = new Uri(url);
				url = oUri.LocalPath;
			}
			return url;
		}

		private	static string GetSiteRootFull()
		{
			return ""+ GetConfigValue("SiteBaseUrl");
		}

		private	static string GetImageLogoName()
		{
			string s=GetConfigValue("ImageLogoName");
			return ""+s ;
		}

		/// <summary>
		/// Returns string containing value of specified 
		/// key from applications .config file
		/// </summary>
		/// <param name="sKeyName">Name of the key to return value from</param>
		/// <returns></returns>
		public  static  string  GetConfigValue(string sKeyName)
		{
			string sVal = string.Empty;
			try
			{
				sVal = Convert.ToString(oSettingsReader.GetValue(sKeyName, System.Type.GetType("System.String")));
			}
			catch
			{}
			return sVal;
		}

	}
}
