using System.Data;
using System.IO;
using Common;
using Common.Db;
using DesktopAPIEngine;
using DesktopBaseClasses;

namespace Admin
{
	/// <summary>
	/// Summary description for Config.
	/// </summary>
	public class Config : Common.Config
	{
		public Config()	{}

		public	const	bool	IsCookiePersistent	= true;

		public	static	string	ImageFolder			= SiteRoot + "img/";
		public	static	string	ImageFolderFull			= SiteRootFull + "img/";
		public	static	string	CommonCssPath		= Config.SiteRoot + "styles.css";

		public	static	string	TempFolder		    = "Temp";
		public  static  string PrizeValueAny = "2";

		public static string Mini_TourneyID="17";
		public static string NonMini_TourneyIDs="1,2,3,4,5,6";
		public static string GameInstallerURL = Config.GetConfigValue("GameInstallerURL"); 

		public static  string cnstBaseRegPath  = Config.GetConfigValue("ServiceBaseRegPath");
		public static string cnstServiceRegPath  = cnstBaseRegPath+Config.GetConfigValue("ServiceSubRegPath");

		public static string IsHandLogCompressed  = Config.GetConfigValue("isHandLogCompressed").ToLower();
		

        public static int glbCommandAnswerTimeout=Utils.GetInt ( Config.GetConfigValue("CommandAnswerTimeout")); 
	
        public static string ClientFilesBatchSQL="select ID, Name, Version, ContentTypeID,width,height from [Skinsfiles] where skinsid={0} order by ID";

		public static ApiControl GetApIEngine()
		{
			return new ApiControl(Config.DbConnectionString ,  cnstServiceRegPath, glbCommandAnswerTimeout, null,  MessageEngineLoader.enMsgEngineType.MSMQ);
		}

		#region Custom cuntrols related
		#region ButtonImage control
		public	const	string	DefaultHyperButtonNavigateUrl = "action";
		public	static	string	ButtonImageLeftImage = ImageFolder + "btn_left.gif";
		public	static	string	ButtonImageBodyImage = ImageFolder + "btn_bg.gif";
		public	static	string	ButtonImageBodyImageFull = ImageFolderFull + "btn_bg.gif";
		public	static	string	ButtonImageRightImage = ImageFolder + "btn_right.gif";
		#endregion
		#region PageHeader
		public	static	string	ImageLogoName		=  Config.GetConfigValue("ImageLogoName");
		#endregion
		#region GridPager
		public	static	string	GridPagerGoFirst	= ImageFolder + "GoFirst.gif";
		public	static	string	GridPagerGoLast		= ImageFolder + "GoLast.gif";
		public	static	string	GridPagerGoPrev		= ImageFolder + "GoPrev.gif";
		public	static	string	GridPagerGoNext		= ImageFolder + "GoNext.gif";
		public	static	string	GridPagerGoFirstDisabled	= ImageFolder + "GoFirstDisabled.gif";
		public	static	string	GridPagerGoLastDisabled		= ImageFolder + "GoLastDisabled.gif";
		public	static	string	GridPagerGoPrevDisabled		= ImageFolder + "GoPrevDisabled.gif";
		public	static	string	GridPagerGoNextDisabled		= ImageFolder + "GoNextDisabled.gif";
		public	const	string	PageNum  	 = "@pageNum";
		public	const	string	PageSize     = "@pageSize";

		#endregion
		#region ASP.NET menu related
		public	static	string	MenuDataPath		= SiteRoot + "Menu/menuData.xml";
		public	static	string	MenuCssPath			= SiteRoot + "Menu/menuStyle.css";
		public	static	string	MenuImageFolder		= SiteRoot + "Menu/img/";
		public	static	string	ApplicationMenuXml	= "AspNetMenuXml";
		#endregion
		#endregion

		#region Name of pages
		public	const	int		PageLogin					= 1;
		public	const	int		PageSubCategoryMaintenance	= 2;
		public	const	int		PageSubCategoryDetails		= 3;
		public	const	int		PageGameProcessMaintenance	= 4;
		public	const	int		PageGameProcessDetails		= 5;
		public	const	int		PageGameMaintenance	    	= 6;
		public	const	int		PageGameDetails				= 7;
		public	const	int		PageGameDetailsFile         = 8;
		public	const	int		PageUserMaintenance			= 9;
		public	const	int		PageUserDetails				= 10;
		public	const	int		PageEmailTemplateMaintenance= 11;
		public	const	int		PageEmailTemplateDetails	= 12;
		public	const	int		PageTxHistoryList			= 13;
		public	const	int		PageTxHistoryDetails 	    = 14;
		public	const	int		PageGameHistoryList			= 15;
		public	const	int		PageGameHistoryDetails		= 16;
		public	const	int		PageSBCategoryMaintenance	= 17;
		public	const	int		PageSBCategoryDetails		= 18;
		public	const	int		PageJsMoveListItems			= 19;
		public	const	int		PageSBSubCategoryMaintenance= 20;
		public	const	int		PageSBSubCategoryDetails	= 21;
		public	const	int		PageEventMaintenance		= 22;
		public	const	int		PageEventDetails			= 23;
		public	const	int		PageTournamentMaintenance	= 24;
		public	const	int		PageTournamentDetails		= 25;
		public	const	int		PageTournamentDetailsPrize	= 26;
		public  const	int		PageTournamentPrizeMaintenance = 27;
		public  const	int		PageTournamentPrizeDetails  = 28;
		public	const	int		PageOptions				    = 29;
		public	const	int		PageGameLogMaintenance		= 30;
		public	const	int		PageGameLogDetails		    = 31;
		public	const	int		PageTeaserList				= 32;
		public	const	int		PageTeaserDetails			= 33;
		public	const	int		PageOutcomeDetails			= 34;
		public	const	int		PageGamesMaintenance		= 35;
		public	const	int		PageTxDetails				= 36;
		public	const	int		PageNewsDetails				= 37;
		public	const	int		PageJsMenuLoader			= 38;
		public	const	int		PageUserDetailsAccount      = 39;
		public	const	int		PageSupportMaintenance      = 40;
		public	const	int		PageSupportDetails          = 41;
		public	const	int		PageGameHistoryUserList     = 42;
		public	const	int		PageClientApplicationFile   = 43;
		public	const	int		PageGameHistoryPlay		    = 44;
		public	const	int		PageEventDetailsPrototype   = 45;
		public	const	int		PageAllowedIpList			= 46;
		public	const	int		PageAffiliateMaintenance    = 47;
		public	const	int		PageAffiliateDetails		= 48;
		public	const	int		PageCsJsMenuLoader			= 49;
		public	const	int		PageReportUser				= 50;
		public	const	int		PageAffiliateReports		= 51;
		public	const	int		PageReports		= 55;
		public	const	int		PageSentEmails		= 56;
		public	const	int		PageSentEmailDetails		= 57;
		public	const	int		PageMassMailer		= 58;
		public	const	int		PageLiveStats		= 59;
		public	const	int		PageSearchFinishedTournaments=60;
		public	const	int		PageTableName=61;
		public	const	int		PageBanUser=62;
		public	const	int		PageSkinsMaintenance    = 63;
		public	const	int		PageSkinsDetails   = 64;
		public	const	int		PageAvatars=65;
		public	const	int		PageActionDispatchers=66;
		public	const	int		PageTournamentBettings	= 67;
		public	const	int		PageTournamentBettingsMaintenance=68;
		public	const	int		PageTournamentBettingsTmpl=69;
		public	const	int		PageInvitedUsers=70;
		public	const	int		PageBots=71;
		public	const	int		PageChatForBots=72;
		public	const	int		PagePushingContent=73;
		public	const	int		PageForcedExits=74;
		public	const	int		PagePushingContentUsers=75;
		public	const	int		PagePushingContentProcesses=76;

		public	const	int		PageDefault	= PageSubCategoryMaintenance;
		#endregion

		#region Name of params
		public	const	string	ParamUserID			= "UserID";
		public	const	string	ParamEventID		= "EventID";
		public	const	string	ParamTournamentID	= "TournamentID";
		public	const	string	PrizeNumber	= "PrizeNumber";
		public	const	string	ParamTournamentPrizeID = "TournamentPrizeID";
		public	const	string	ParamCategoryID		= "CategoryID";
		public	const	string	ParamSubCategoryID	= "SubCategoryID";
		public	const	string	ParamGameProcessID	= "GameProcessID";
		public	const	string	ParamGameID			= "GameID";
		public	const	string	ParamEmailTemplateID= "EmailTemplateID";
		public	const	string	ParamTxID			= "TxID";
		public	const	string	ParamHandID			= "HandID";
		public	const	string	ParamGroupID		= "GroupID";
		public	const	string	ParamGameLogID		= "GameLogID";
		public	const	string	ParamTeaserTableID	= "TeaserTableID";
		public	const	string	ParamOutcomeID		= "OutcomeID";
		public	const	string	ParamNewsID		    = "NewsID";
		public	const	string	ParamSupportID	    = "SupportID";
		public	const	string	ParamMenu			= "showMenu";
		public	const	string	ParamBack			= "showBack";
		public	const	string	ParamAffiliateID	= "AffiliateID";
		public	const	string	ParamSentEmailID	    = "SentEmailID";
		#endregion

		#region Database
		#region Dictionaries
		public	const	string	DbDictionaryStatus	        = "admDictionaryStatus";
		public	const	string	DbDictionaryCategory        = "admDictionaryCategory";
		public	const	string	DbDictionaryCategoryPoker   = "admDictionaryCategoryPoker";
		public	const	string	DbDictionarySex             = "admDictionarySex";
		public	const	string	DbDictionaryGameEngine      = "admDictionaryGameEngine";
		public	const	string	DbDictionaryTournamentPrize = "admDictionaryTournamentPrize";
		public	const	string	DbDictionaryCurrency        = "admDictionaryCurrency";
		public	const	string	DbDictionarySubCategory     = "admDictionarySubCategory";
		public	const	string	DbDictionaryContentType     = "admDictionaryContentType";
		public	const	string	DbDictionaryTournamentCategory="admGetDictionaryTournamentCategory";
		
		//public	const	string	DbDictionaryContentType     = "admDictionaryContentType";
		public	const	string	DbDictionaryState			= "admDictionaryState";
		public	const	string	DbDictionaryCountry			= "admDictionaryCountry";
		public	const	string	DbDictionarySupportStatus   = "admDictionarySupportStatus";
		public	const	string	DbGetDictionaryOutcomeResultList = "admGetDictionaryOutcomeResultList";
		public	const	string	DbDictionaryQualification   = "admDictionaryQualification";
		#endregion

		#region Affiliate
		public	const	string	DbDeleteSkin	   = "admDeleteSkin";
		public	const	string	DbGetSkinsList	   = "admGetSkinsList";
		public	const	string	DbGetSkinsDetails  = "admGetSkinDetails";
		public	const	string	DbSaveSkinsDetails = "admSaveSkinsDetails";
		public	const	string	DbDeleteAffiliate	   = "admDeleteAffiliate";
		public	const	string	DbGetAffiliateList	   = "admGetAffiliateList";
		public	const	string	DbGetAffiliateDetails  = "admGetAffiliateDetails";
		public	const	string	DbSaveAffiliateDetails = "admSaveAffiliateDetails";
		public	const	string	DbGetAffiliateInfo = "admGetAffiliateInfo";
		public	const	string	DbGetAffiliateInfoForAll = "admGetAffiliateInfoForAll";

		public const string pathAffiliatePrefix  = "Skin_";

		public static string GetAffiliateSubFolder(int affID, bool instDir,bool AsURL)
		{
			string dir=pathAffiliatePrefix+affID.ToString();  
			if (instDir) dir+=(AsURL?"/":"\\")+"Installer";
			return dir;
		}

		public static string GetAffiliatePath(int affID, bool instDir,bool AsURL)
		{
			string dir= AsURL?Config.FileUploadUrl : Config.FileUploadPath;
			dir=dir.TrimEnd(new char[] {(AsURL?'/':'\\')}); 
			dir+=(AsURL?"/":"\\")+GetAffiliateSubFolder(affID, instDir, AsURL);
			if (!AsURL)
			{
				if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
			}
			return dir;
		}

		public static string GetPushingContentPath(int ContentID,bool AsURL)
		{
			string dir= AsURL?Config.FileUploadUrl : Config.FileUploadPath;
			dir=dir.TrimEnd('/').TrimEnd('\\') ; 
			dir+=(AsURL?"/":"\\")+"PushingContent"+ (AsURL?"/":"\\")+ContentID.ToString();
			if (!AsURL)
			{
				if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
			}
			return dir;
		}

		#endregion


		#region BuddyWager categories
		public	const	string	DbGetSBCategoryList		= "admGetSBCategoryList";
		public	const	string	DbDeleteSBCategory		= "admDeleteSBCategory";
		public	const	string	DbDeleteSBSubCategory	= "admDeleteSBSubCategory";
		public	const	string	DbGetSBSubCategoryList	= "admGetSBSubCategoryList";
		public	const	string	DbSaveSBCategoryDetails	= "admSaveSBCategoryDetails";
		public	const	string	DbGetSBCategoryDetails	= "admGetSBCategoryDetails";
		public	const	string	DbGetDictionarySBCategoryList = "admGetDictionarySBCategoryList";
		public	const	string	DbGetSBSubCategoryDetails	= "admGetSBSubCategoryDetails";
		public	const	string	DbSaveSBSubCategory		= "admSaveSBSubCategoryDetails";
		public	const	string	DbGetSBCategoryListSimple	= "admGetSBCategoryListSimple";
		public	const	string	DbGetSBSubCategoryListForCategory= "admGetSBSubCategoryListForCategory";
		#endregion

		#region BuddyWager events
		public	const	string	DbDeleteEvent			    = "admDeleteEvent";
		public	const	string	DbGetEventList			    = "admGetEventList";
		public	const	string	DbGetEventDetails		    = "admGetEventDetails";
		public	const	string	DbSaveEvent				    = "admSaveEvent";
		public	const	string	DbUpdateEvent			    = "admUpdateEvent";
		public	const	string	DbProcessEventFinish	    = "admProcessBetsOnEventFinish";
		public	const	string	DbGetSBSubCategoryAndTeamList = "admGetSBSubCategoryAndTeamList";
		public	const	string	DbUpdateOutcome		        = "select ID, EventID, BetTypeID, isHome, PeriodID, Rate, BetValue, OutcomeResultID, WonValue  from Outcome where EventID = {0}";
		public	const	string	DbGetEventOutcomeList	    = "admGetEventOutcomeList";
		public	const	string	DbUpdateEventState          = "admUpdateEventState";
		public	const	string	DbSaveEventScore            = "admSaveEventScore";
		public	const	string	DbProcessBetsOnEventFinish  = "admProcessBetsOnEventFinish";
		#endregion

		#region BuddyWager outcome
		public	const	string	DbDeleteEventOutcomes	 = "admDeleteEventOutcomes";
		public	const	string	DbGetOutcomeDetails		 = "admGetOutcomeDetails";
		public	const	string	DbSaveOutcomeDetails	 = "admSaveOutcomeDetails";
		public	const	string	DbGetDictionaryBetType	 = "admGetDictionaryBetType";
		public	const	string	DbGetDictionaryOutcomeResult = "admGetDictionaryOutcomeResult";
		public	const	string	DbGetEventOutcomeResults = "admGetEventOutcomeResults";
		public	const	string	DbSaveOutcomeTable	     = "admSaveOutcomeTable";
		#endregion

		#region BuddyWager News
		public	const	string	DbGetEventNews		   = "admGetEventNews";
		public	const	string	DbDeleteEventNews	   = "admDeleteEventNews";
		public	const	string	DbGetEventNewsDetails  = "admGetEventNewsDetails";
		public	const	string	DbSaveEventNewsDetails = "admSaveEventNewsDetails";
		#endregion

		#region BuddyWager teaser
		//public	const	string	DbGetTeaserList		= "admGetTeaserList";
		//public	const	string	DbDeleteTeaser		= "admDeleteTeaser";
		//public	const	string	DbGetTeaserTableDetails	= "admGetTeaserTableDetails";
		//public	const	string	DbSaveTeaserTableDetails= "admSaveTeaserTableDetails";
		public	const	string	DbGetCategoryTeaserList = "admGetCategoryTeaserList";
		#endregion

		#region Subcategories
		public	const	string	DbEnableSubCategory		 = "admEnableSubCategory";
		public	const	string	DbDisableSubCategory	 = "admDisableSubCategory";
		public	const	string	DbDeleteSubCategory		 = "admDeleteSubCategory";
		public	const	string	DbGetSubCategoryList	 = "admGetSubCategoryList";
		public	const	string	DbGetSubCategoryDetails	 = "admGetSubCategoryDetails";
		public	const	string	DbSaveSubCategoryDetails = "admSaveSubCategoryDetails";
		public	const	string	DbGetSubCategoryRelatedProcess	= "admGetSubCategoryRelatedProcess";
		public	const	string	DbGetSubCategoryStatsPresent	= "admGetSubCategoryStatsPresent";
		public	const	string	DbGetSubCategoryStatsOther		= "admGetSubCategoryStatsOther";
		public	const	string	DbUpdateSubCategoryStats		= "select SubCategoryID, StatsTypeID, [Order] from SubCategoryStats where SubCategoryID = {0}";
		public	const	string	DbGetSubcategoryTeam		    = "admGetSubcategoryTeam";
		public	const	string	DbSaveTeamTable                 = "admSaveTeamTable";
		#endregion


		#region Users
		public	const	string	DbGetUserList	  = "admGetUserList";
		public	const	string	DbEnableChat      = "admEnableChat";
		public	const	string	DbDisableChat     = "admDisableChat";
		public	const	string	DbEnableUser      = "admEnableUser";
		public	const	string	DbDisableUser     = "admDisableUser";
		public	const	string	DbDeleteUser      = "admDeleteUser";
		public	const	string	DbGetUserListByProcess	  = "admGetUserListByProcess";
		public	const	string	DbGetUserListByTournament ="admGetUserListByTournament";
		public	const	string	DbGetUserDetails  = "admGetUserDetails";
		public	const	string	DbSaveUserDetails = "admSaveUserDetails";
		public	const	string	DbGetUserDetailsAccount = "admGetUserDetailsAccount";
		public const string DbGetUserID ="wntGetUserID";
		public	const	string	DbGetUsersAsDictionary="admGetUsersAsDictionary";
		public const  string DbGetClientSessionHistory="admGetClientSessionHistory";
		#endregion

		#region Game processes
		public	const	string	DbAddInvitedUser="admAddInvitedUser";
		public	const	string	DbDeleteInvitedUsers="admDeleteInvitedUsers";
		public	const	string	DbGetInvitedUsersList	   = "admGetInvitedUsersList";
		public	const	string	DbGetGameProcessList	   = "admGetGameProcessList";
		public	const	string	DbEnableGameProcess		   = "admEnableGameProcess";
		public	const	string	DbDisableGameProcess 	   = "admDisableGameProcess";
		public	const	string	DbDeleteGameProcess	  	   = "admDeleteGameProcess";
		public	const	string	DbGetGameEngineDetails     = "admGetGameEngineDetails";
		public	const	string	DbCreateFirstGameProcess   = "apiCreateFirstGameProcess";
		public	const	string	DbGetGameProcessDetails	   = "admGetGameProcessDetails";
		public	const	string	DbReinitGameProcess	       = "admReinitGameProcess";
		#endregion

		#region Transaction
		public	const	string	DbGetGameLogList	  = "admGetGameLogList";
		public	const	string	DbGetGameLogUserList  = "admGetGameLogUserList";
		public	const	string	DbGetGameLogDetails   = "admGetGameLogDetails";
		public	const	string  DbGetTxHistoryList    = "admGetTxHistoryList";  
		public	const	string  DbGetTxHistoryDetails = "admGetTxHistoryDetails"; 
		public	const	string  DbSaveTransaction     = "admSaveTransaction";
		public	const	string  DbGetContentTypeSkinFile = "admGetContentTypeSkinFile";
		public	const	string  DbGetGameLog = "admGetGameLog";
		#endregion

		#region Tournament
		public	const	string	DbGetTournamentMaxID	     = "admGetTournamentMaxID";
		public	const	string	DbGetTournamentList	       = "admGetTournamentList";
		public	const	string	DbDeleteTournament	       = "admDeleteTournament";
		public	const	string	DbGetTournamentDetails     = "admGetTournamentDetails";
		public	const	string	DbUpdateTournamentSettings = "admUpdateTournamentSettings";
		public	const	string	DbUpdateTournamentPrize    = "admUpdateTournamentPrize";
        public	const	string	DbGetTournamentBettingsXML="srvtouGetTournamentBettingsXML";
		public	const	string	DbGetTournamentBettingsXMLTmpl="srvtouGetTournamentBettingsXMLTmpl";
		public	const	string	DbSaveTournamentBettingsXMLTmpl="srvtouSetTournamentBettingsXMLTmpl";
        public	const	string	DbGetTournamentBettingsTmplList="admGetTournamentBettingsTmplList";
		public	const	string	DbDeleteTournamentBettingsTmpl="admDeleteTournamentBettingsTmpl";

		public	const	string	DbGetTournamentPrizeList     = "admGetTournamentPrizeList";
		public	const	string	DbDeleteTournamentPrize	     = "admDeletePrizeTournament";
		public	const	string	DbSaveTournamentPrizeDetails = "admSaveTournamentPrizeDetails";
		public	const	string	DbGetTournamentPrizeDetails  = "admGetTournamentPrizeDetails";
		public	const string DbDictionaryTournPrizeValueType ="admDictionaryTournPrizeValueType";
		public	const string DbGetPrizeRulesDetails="admGetPrizeRulesDetails";
		public	const string DbGetPrizeRulesList="admGetPrizeRulesList";

		#endregion

		#region Games
		public    const string DBSaveBotChatVariant="admSaveBotChatVariant";
		public    const string DBGetBotChatVariantList="admGetBotChatVariantList";
		public    const string DBDeleteBotChatVariant="admDeleteBotChatVariant";
		public    const string DBDeleteBotChatListMap="admDeleteBotChatListMap";
		public    const string DBGetBotChatListMap="admGetBotChatListMap";
		public    const string DBSaveBotChatListMap="admSaveBotChatListMap";
		public	const	string	DbGetGameList = "admGetGameList";
		public	const	string	DbDeleteGame  = "admDeleteGame";
		public	const	string	DbGetGameEngineFileList	    = "admGetGameEngineFileList";
		public	const	string	DbDeleteFileRelated	        = "admDeleteFileRelated";
		public	const	string	DbSaveGameEngineFile        = "admSaveGameEngineFile";
		public	const	string	DbGetFileDetails            = "admGetFileDetails";
		#endregion

		#region Login
		public	const	string	DbCheckLogin		= "admCheckLogin";
		public	const	string	DbCheckAllowedIP= "admCheckAllowedIP";
		#endregion

		#region Email Template
		public	const	string	DbGetEmailTemplateList    = "admGetEmailTemplateList";
		public	const	string	DbGetEmailTemplateDetails = "admGetEmailTemplateDetails";
		public	const	string  DbSaveEmailTemplate       = "admSaveEmailTemplate";
		public	const	string	DbGetFieldTemplateList    = "admGetFieldTemplateList";
		public	const	string	DbGetEmailTemplateDetailsByName="admGetEmailTemplateDetailsByName";
		#endregion
		
		#region File
		public	const	string	DbSaveFile		 = "admSaveFile";
		public	const	string	DbDeleteFile	 = "admDeleteFile";
		#endregion

		#region Support
		public	const	string	DbGetSupportList     = "admGetSupportList";
		public	const	string	DbGetSupportDetails  = "admGetSupportDetails";
		public	const	string	DbSaveSupportDetails = "admSaveSupportDetails";
		public	const	string	DbDeleteSupport="admDeleteSupport";
		#endregion

        public	const	string	DbGetDictionaryEmailSentBy="admGetDictionaryEmailSentBy";
		public	const	string	DbGetSentEmalsList="admGetSentEmalsList";
		public	const	string	DbGetSentEmalsDetails="admGetSentEmalsDetails";
		public	const	string	DbFindFinishedTournaments="admFindFinishedTournaments";


		#region Misc

		public const string DbDeleteForcedExits="admDeleteForcedExits";
		public const string DbSaveForcedExits="admSaveForcedExits";
		public const string DbGetForcedExitsList="admGetForcedExitsList";
		public const string DbGetPushingContentTypes="admGetPushingContentTypes";
		public const string DbGetPushingContentFileDetails="admGetPushingContentFileDetails";
        public const string DbDeletePushingContentFile="admDeletePushingContentFile";
		public const string DbGetPushingContentFilesList="admGetPushingContentFilesList";
		public const string DbSavePushingContentFile="admSavePushingContentFile";
		public const string DbSavePushingContentList="admSavePushingContentList";
		public const string DbDeletePushingContentList="admDeletePushingContentList";
		public const string DbGetPushingContentList="admGetPushingContentList";

		public const string DbGetPushingContentProcessesList="admGetPushingContentProcessesList";
		public const string DbDeletePushingContentProcesses="admDeletePushingContentProcesses";
		public const string DbSavePushingContentProcesses="admSavePushingContentProcesses";
		public const string DbGetProcessesForPushigContent="admGetProcessesForPushigContent";

        public const string DbGetPushingContentUsersList="admGetPushingContentUsersList";
		public const string DbDeletePushingContentUsers="admDeletePushingContentUsers";
		public const string DbSavePushingContentUsers="admSavePushingContentUsers";

		public const string DbGetActionDispatchersAsDictionary="admGetActionDispatchersAsDictionary";
		public const string DbSaveActionDispatcher="admSaveActionDispatcher";
		public const string DbGetActionDispatchersList="admGetActionDispatchersList";
		public const string DbDeleteActionDispatcher="admDeleteActionDispatcher";
		public  const string DbDeleteAvatar="admDeleteAvatar";
		public  const string DbAcceptAvatar="admAcceptAvatar";
		public  const string DbGetAvatarsList="admGetAvatarList";
		public  const string DbGetBonusRules="admGetBonusRules";
		public	const	string	DbUpdateBonusRules	 = "SELECT [ID],[Name],MinValueForBonus,BonusValue,NameSQLProcedure FROM BonusRules";
		public	const	string	DbGetConfig		 = "admGetConfig";
		public	const	string	DbUpdateConfig	 = "select [id], PropertyValue from ConfigDetail";
		public	const	string	DbGetConfigValue = "admGetConfigValue";
		public	const	string	DbGetClientApplicationFileList       = "admGetClientApplicationFileList";
		public	const	string	DbGetClientApplicationFileListForXML = "admGetClientApplicationFileListForXML";
		public	const	string	DbGetAllowedIP	 = "admGetAllowedIP";
		public	const	string	DbSaveAllowedIP	 = "admSaveAllowedIP";
		public	const	string	DbGetExecutable	 = "admGetExecutable";
		public	const	string DbGetPlayPeriod="wntGetPlayPeriods";
		public	const	string DbDeletePlayPeriod="wntDeletePlayPeriod";
		public	const	string DbSavePlayPeriod="wntSavePlayPeriod";
		public	const	string DbClosePeriod="wntClosePeriod";
		public const string DbGetExoticNameList="admGetExoticNameList";
		public const string DbSaveExoticName="admSaveExoticName";
		public const string DbDeleteExoticName="admDeleteExoticName";
		public const string DbGetBanList="admGetBanList";
		public const string DbDeleteBan="admDeleteBan";
		public const string DbSaveBan="admSaveBan";
		#endregion

		#region Reports
		public	const	string	DbGetReportUserDetail = "admGetReportUserDetail";
		#endregion

		#endregion

		#region DB Config
		public static string GetDbConfigValue(Base DBase, object obj)
		{
			string sRes = string.Empty;
			DataRow oDR = DBase.GetFirstRow(DbGetConfigValue, "@ID", obj);
			if ( oDR != null )
			{
				sRes = oDR[0].ToString();
			}
			return sRes;
		}
		public enum DBConfig
		{
			DepositMinimum = 2,
			DepositMaxPerDay = 3,
			DepositMaxPerWeek = 4,
			DepositMaxPerMonth = 5,
			AdminEmail = 1,
			CustomerSupportEmail = 6,
			SMTPServer = 7
		}
		#endregion

		#region COM+
	//	public	static	string	ComServer		= GetConfigValue("ComServer");
	//	public	static	string	ComApplication	= GetConfigValue("ComApplication");

		/*public	static	string	ComTournament	= "PokerControls.Tournament";
		public	static	string	ComEngine		= "PokerControls.GenericPokerEngine";
*/
	/*	public	static	string	ComApi	        = "AdminControls.ApiControlClass";

		public	static	string	ComTournamentGetDefaultProperty = "GetDefaultProperty";
		public	static	string	ComTournamentInitTournament     = "InitTournament";
		public	static	string	ComApiCreateRemind              = "CreateRemind";
		public	static	string	ComApiChangeRemind              = "ChangeRemind";
		public	static	string	ComApiRemoveRemind              = "RemoveRemind";
		public	static	string	ComApiResetRemind               = "ResetRemind";*/
		#endregion

		#region Misc
		public	static	string	FileUploadPath       = GetConfigValue("FileUploadPath");
		public	static	string	FileUploadUrl        = GetConfigValue("FileUploadUrl");
		public	static	string	FileSkinsBat     = GetConfigValue("FileSkinsBat");
		public	static	string	FileSkinsNsi = GetConfigValue("FileSkinsNsi");
		public	static	string	FileSkinsTemplateNsi = GetConfigValue("FileSkinsTemplateNsi");
		public	static	string	FileEmailTemplateUrl = GetConfigValue("FileEmailTemplateUrl");
		public	static	string FileSecurityBat   = GetConfigValue("FileSecurityBat");

		#endregion

		#region Users
		public static string UserTypeCookie = "UserType";
		public static string UserIDCookie = "UserID";
		public static int UserTypeAdmin = 2;
		public static int UserTypeCustomerSupport = 3;
		public static string DbGetChips="apsGetChips";
		#endregion

	}

}
