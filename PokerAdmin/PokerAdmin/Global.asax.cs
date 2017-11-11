using System;
using System.Collections;
using System.Data;
using System.IO;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using Common.Web;
using DesktopBaseClasses;

namespace Admin 
{
	/// <summary>
	/// Summary description for Global.
	/// </summary>
	public class Global : HttpApplication
	{
		private static ArrayList arrAllowed = new ArrayList();

		public Global()
		{
			InitializeComponent();
		}	
		
		protected void Session_Start(Object sender, EventArgs e)
		{
			Session["UserType"]="A";
			try
			{
				if (Config.GetConfigValue("UseBan").ToLower() != "true")
				{
					Session["IPAllowed"]=true;
					return;
				}
				DataRow oDR;
				Page pg=new Page();
				string rIP=Context.Request.UserHostAddress;
				Session["IPClient"]=rIP;
				oDR =pg.DBase.GetFirstRow(Config.DbCheckAllowedIP, "@IP",rIP);
				if (oDR ==null) 
				{
					Session["IPAllowed"]=false;
					FormsAuthentication.SignOut();
				}
				else
				{
					Session["IPAllowed"]=true;
				}
			}
			catch
			{Session["IPAllowed"]=false;}
		}

		protected void Application_BeginRequest(Object sender, EventArgs e)
		{

		}

		protected void Application_EndRequest(Object sender, EventArgs e)
		{

		}

		protected void Application_AuthenticateRequest(Object sender, EventArgs e)
		{
			DataRow oDR;
			Page pg=new Page();
		
			if ( !Request.IsAuthenticated )
			{
				string pageName = Request.FilePath.ToLower();
				if ( arrAllowed.Contains(pageName) )
				{	//Not authorized but page is allowed to view
					Context.User = new GenericPrincipal(new GenericIdentity("0"), null);
				}
			}
			else
			{
				string [] tt=Context.User.Identity.Name.Split(':');
				if (tt.Length !=3)
				{FormsAuthentication.SignOut();}
				else
				{
					oDR =pg.DBase.GetFirstRow(Config.DbCheckLogin, "@Login", tt[1], "@Password",tt[2]);
					if (oDR ==null)
					{FormsAuthentication.SignOut();}
				}
			}
		}

		protected void Application_Error(Object sender, EventArgs e)
		{

		}

		protected void Session_End(Object sender, EventArgs e)
		{

		}
		protected void Application_Start(Object sender, EventArgs e)
		{
			// Prepare pages list collection
			LogAdmin.LogInSingleFile =true;
			LogAdmin.ApplicationName = Path.GetFileName(Config.GetConfigValue("LogFile")); 
			Hashtable oList = new Hashtable();
			
			AddPageToList(oList, Config.PageLogin, string.Empty, "Login page", "Login.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSubCategoryMaintenance, string.Empty, "Subcategory List", "Categories/SubCategoryMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSubCategoryDetails, Config.ParamSubCategoryID, "Subcategory Details", "Categories/SubCategoryDetails.aspx", Config.PageSubCategoryMaintenance);
			AddPageToList(oList, Config.PageGameProcessMaintenance, string.Empty, "Game Process Maintenance", "Games/GameProcessMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageGameProcessDetails, Config.ParamGameProcessID, "Game Process Details", "Games/GameProcessDetails.aspx", Config.PageGameProcessMaintenance);
			AddPageToList(oList, Config.PageGameMaintenance, string.Empty, "Game Engine Maintenance", "Games/GameMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageGameDetails, Config.ParamGameID, "Game Engine Details", "Games/GameDetails.aspx", Config.PageGameMaintenance);
			AddPageToList(oList, Config.PageGameDetailsFile, Config.ParamGameID, "Game Engine Files", "Games/GameDetailsFile.aspx", Config.PageGameMaintenance);
			AddPageToList(oList, Config.PageUserMaintenance, string.Empty, "Users Maintenance", "Users/UsersMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageUserDetails, Config.ParamUserID, "User Details", "Users/UserDetails.aspx", Config.PageUserMaintenance);
			AddPageToList(oList, Config.PageUserDetailsAccount, Config.ParamUserID, "User Account", "Users/UserDetailsAccount.aspx", Config.PageUserDetails);
			AddPageToList(oList, Config.PageEmailTemplateMaintenance, string.Empty, "Email Templates List", "EmailTemplates/EmailTemplateMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageEmailTemplateDetails, Config.ParamEmailTemplateID, "Email Template Details", "EmailTemplates/EmailTemplateDetails.aspx", Config.PageEmailTemplateMaintenance);
			AddPageToList(oList, Config.PageTxHistoryList, string.Empty, "Transactions History", "Transactions/TxHistoryList.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageTxHistoryDetails, Config.ParamTxID, "Transaction History Details", "Transactions/TxHistoryDetails.aspx", Config.PageTxHistoryList);
			AddPageToList(oList, Config.PageGameHistoryUserList, string.Empty, "User Game History", "Transactions/GameHistoryUserList.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageGameHistoryList, string.Empty, "Games History", "Transactions/GameHistoryList.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageGameHistoryDetails, Config.ParamHandID, "Game History", "Transactions/GameHistoryDetails.aspx", Config.PageGameHistoryList);
			AddPageToList(oList, Config.PageGameHistoryPlay, Config.ParamHandID, "Game History Play", "Transactions/GameHistoryPlay.aspx", Config.PageGameHistoryList);
			AddPageToList(oList, Config.PageSBCategoryMaintenance, string.Empty, "BuddyWager Category List", "Categories/SBCategoryMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSBCategoryDetails, Config.ParamCategoryID, "BuddyWager Category Details", "Categories/SBCategoryDetails.aspx", Config.PageSBCategoryMaintenance);
			AddPageToList(oList, Config.PageJsMoveListItems, string.Empty, string.Empty, "Js/MoveListItems.js");
			AddPageToList(oList, Config.PageSBSubCategoryMaintenance, string.Empty, "BuddyWager SubCategory List", "Categories/SBSubCategoryMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSBSubCategoryDetails, Config.ParamSubCategoryID, "BuddyWager SubCategory Details", "Categories/SBSubCategoryDetails.aspx", Config.PageSBSubCategoryMaintenance);
			AddPageToList(oList, Config.PageEventMaintenance, string.Empty, "BuddyWager Events List", "Event/EventMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageEventDetails, Config.ParamEventID, "BuddyWager Event Details", "Event/EventDetails.aspx", Config.PageEventMaintenance);
			AddPageToList(oList, Config.PageTournamentMaintenance, string.Empty, "Tournaments List", "Tournaments/TournamentMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageTournamentDetails, Config.ParamTournamentID, "Tournament Details", "Tournaments/TournamentDetails.aspx", Config.PageTournamentMaintenance);
			AddPageToList(oList, Config.PageTournamentDetailsPrize, Config.ParamTournamentID, "Tournament Prizes", "Tournaments/TournamentDetailsPrize.aspx", Config.PageTournamentDetails);
			AddPageToList(oList, Config.PageTournamentPrizeMaintenance, string.Empty, "Tournament Prize Template Maintenance", "Tournaments/TournamentPrizeMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageTournamentPrizeDetails, Config.ParamTournamentPrizeID, "Tournament Prize Template Details", "Tournaments/TournamentPrizeDetails.aspx", Config.PageTournamentPrizeMaintenance);
			AddPageToList(oList, Config.PageOptions, string.Empty, "Options", "Misc/Options.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageGameLogMaintenance, string.Empty, "Game History", "Transactions/GameHistoryList.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageGameLogDetails, Config.ParamGameLogID, "Game History Details", "Transactions/GameHistoryDetails.aspx", Config.PageGameLogMaintenance);
			AddPageToList(oList, Config.PageTeaserList, string.Empty, "BuddyWager teasers maintenance", "Teaser/TeaserMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageTeaserDetails, Config.ParamTeaserTableID, "BuddyWager teaser details", "Teaser/TeaserDetails.aspx", Config.PageTeaserList);
			AddPageToList(oList, Config.PageOutcomeDetails, Config.ParamOutcomeID, "Outcome details", "Outcome/OutcomeDetails.aspx", Config.PageTeaserList);
			AddPageToList(oList, Config.PageNewsDetails, Config.ParamNewsID, "News details", "News/NewsDetails.aspx", Config.PageEventDetails);
			AddPageToList(oList, Config.PageJsMenuLoader, string.Empty, string.Empty, "Menu/Loader.js");
			AddPageToList(oList, Config.PageCsJsMenuLoader, string.Empty, string.Empty, "Menu/csMenu/Loader.js");
			AddPageToList(oList, Config.PageSupportMaintenance, string.Empty, "Customer Support List", "Support/SupportMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSupportDetails, Config.ParamSupportID, "Customer Support Details", "Support/SupportDetails.aspx", Config.PageSupportMaintenance);
			AddPageToList(oList, Config.PageClientApplicationFile, string.Empty, "Client Application Files", "Misc/ClientApplicationFile.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageAllowedIpList, string.Empty, "Allowed IP list", "Misc/AllowedIP.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageAffiliateMaintenance, string.Empty, "Affiliate List", "Affiliate/AffiliateMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageAffiliateDetails, Config.ParamAffiliateID, "Affiliate Details", "Affiliate/AffiliateDetails.aspx", Config.PageAffiliateMaintenance);
			AddPageToList(oList, Config.PageReportUser, String.Empty, "Report Users by Affiliates", "Reports/ReportUser.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageAffiliateReports , String.Empty, "Affiliate Reports", "Affiliate/AffiliateReport.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageReports , String.Empty, "Main Reports", "Reports/Reports.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSentEmails , String.Empty, "Sent Emails", "SentEmail/SentEmail.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSentEmailDetails , Config.ParamSentEmailID, "Sent Emails Details", "SentEmail/SentEmaildetails.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageMassMailer , String.Empty, "Mass Mailer", "Support/MassMailer.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageLiveStats , String.Empty, "Live Stats", "Support/LiveStats.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSearchFinishedTournaments , String.Empty, "Search Finished Tournaments", "Reports/SearchFinishedTournaments.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageTableName  , String.Empty, "Table Name", "Misc/TableName.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageBanUser  , String.Empty, "Ban Players", "Misc/BanUser.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSkinsMaintenance  , String.Empty, "Skins List", "Affiliate/SkinsMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageSkinsDetails, String.Empty, "Skins Details", "Affiliate/SkinsDetails.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageAvatars, String.Empty, "Avatars", "Misc/Avatars.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageActionDispatchers, String.Empty, "Action Dispatchers", "Misc/ActionDispatchers.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageTournamentBettings, String.Empty, "Tournament Bettings", "Tournaments/TournamentBettings.aspx", Config.PageTournamentDetails);
			AddPageToList(oList, Config.PageTournamentBettingsMaintenance, "BettingID", "Tournament Bettings Template Maintenance", "Tournaments/TournamentBettingsMaintenance.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageTournamentBettingsTmpl,"BettingID", "Tournament Betting Template", "Tournaments/TournamentBettingsTmpl.aspx", Config.PageTournamentDetails);
			AddPageToList(oList, Config.PageInvitedUsers,"ProcessID", "Invited Users", "Games/InvitedUsers.aspx", Config.PageGameProcessDetails);
			AddPageToList(oList, Config.PageBots,String.Empty, "Bots", "Games/Bots.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageChatForBots,String.Empty, "Chat for Bots", "Games/ChatForBots.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PagePushingContent,String.Empty, "Pushing Content", "Misc/PushingContent.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PageForcedExits,String.Empty, "Forced Exits", "Misc/ForcedExits.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PagePushingContentUsers,String.Empty, "Pushing Content as Users", "Misc/PushingContentUsers.aspx", Config.PageDefault);
			AddPageToList(oList, Config.PagePushingContentProcesses,String.Empty, "Pushing Content as Processes", "Misc/PushingContentProcesses.aspx", Config.PageDefault);

			
			AddPageToList(oList, Config.PageEventDetailsPrototype, Config.ParamEventID, "BuddyWager Event Details Prototype", "Event/EventDetailsPrototype.aspx", Config.PageEventMaintenance);
			
			Application[Config.ApplicationPagesList] = oList;
		}

/*
		private string GetMenuData()
		{
			StreamReader oSt = new StreamReader(Server.MapPath(Config.MenuDataPath));
			return oSt.ReadToEnd().Replace("{SiteRoot}", Config.SiteRoot);
		}
*/

		private void AddPageToList(Hashtable oList, int nPageNumber, string sMainParamName, string sPageName, string sPageRelativeUrl)
		{
			AddPageToList(oList, new PageInfo(sPageName, sPageRelativeUrl, nPageNumber, sMainParamName));
		}
/*
		private void AddPageToList(Hashtable oList, int nPageNumber, string sMainParamName, string sPageName, string sPageRelativeUrl, bool bAlwaysAllowed)
		{
			AddPageToList(oList, new PageInfo(sPageName, sPageRelativeUrl, nPageNumber, sMainParamName, bAlwaysAllowed));
		}
*/
		private void AddPageToList(Hashtable oList, int nPageNumber, string sMainParamName, string sPageName, string sPageRelativeUrl, int nDefaultBackPage)
		{
			AddPageToList(oList, new PageInfo(sPageName, sPageRelativeUrl, nPageNumber, sMainParamName, nDefaultBackPage));
		}
/*
		private void AddPageToList(Hashtable oList, int nPageNumber, string sMainParamName, string sPageName, string sPageRelativeUrl, int nDefaultBackPage, bool bAlwaysAllowed)
		{
			AddPageToList(oList, new PageInfo(sPageName, sPageRelativeUrl, nPageNumber, sMainParamName, nDefaultBackPage, bAlwaysAllowed));
		}
*/

		private void AddPageToList(Hashtable oList, PageInfo oPage)
		{
			string sUrl = oPage.PageRelativeUrl;
			if ( sUrl[0] != Path.AltDirectorySeparatorChar)
				sUrl =  Path.AltDirectorySeparatorChar + sUrl;
			oList[sUrl.ToLower()] = oPage;
			if ( !oPage.AuthorizationRequired )
			{
				arrAllowed.Add(oPage.PageBaseUrl.ToLower());
			}
		}

		protected void Application_End(Object sender, EventArgs e)
		{

		}
			
		#region Web Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
		}
		#endregion
	}
}

