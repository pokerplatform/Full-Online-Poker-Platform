unit uConstants;

interface

const

  // Application constants
  CSA_ID    = 1;
  CSA_Version = '2.5';
  CSA_Build = 200509010;
  CSA_DefaultAffiliateID = '1';
  CSA_DefaultAdvertisementID = '0';

  UpdateInfoTimeSec = 10;

  AppName = 'PokerSatellites';
  AppFileName = AppName + '.exe';
  AppUpdateFileName = AppName + '_Update.exe';
  BannerContentTypeID = 2;
  PlayerLogoContentTypeID = 7;
  FlashGameContentTypeID = 3;

  RemoteHost   = 'poker.offshorecreations.com';
  RemotePort   = 4000;
  ConnectFailedCountBeforeTerminate = 15;

  RegistryKey   = 'SOFTWARE\' + AppName + '\Settings';
  RegistryAffiliateIDName = 'AffiliateID';
  RegistryAdvertisementIDName = 'AdvertisementID';
  RegistryDebugKey = 'Logging';
  RegistryFormatXMLKey = 'FormatXML';
  RegistryDebugIdent    = '81020ECC60CC478FGFSG543GHGDSGSD3242285F658A342CDE4D1';
  RegistryDebugExtended = '5760B235FGADA4352SCXVFGH6532B1474764BF95D50C388E6AD5';
  RegistryDebugVerbose  = '4ED7D45ABB43495AHG43523FSGFDGDAF4FHF9FB9FA837CE341F7';
  RegistryMultiInstancesKey =   'E5F9DA2747BF474997AC596AG54FDSF45VCXVDF35345BCAA24C0';
  RegistryMultiInstancesValue = '05CBC7DF23A84693BE48A2056433GSDG654GDFSHD25C9F2FF262';


  // Session settings
  SessionShowPlayMoneyTables = 'ShowPlayMoneyTables';
  SessionShowNoLimitTables = 'ShowNoLimitTables';
  SessionShowLimitTables = 'ShowLimitTables';
  SessionShowLPTables = 'ShowLPTables';
  SessionHideCompletedTournamens = 'HideCompletedTournament';
  SessionHideRunningTournamens = 'HideRunningTournamens';
  SessionHideFullTables = 'HideFullTables';

  SessionHideWelcomeMessage = 'HideWelcomeMessage';

  SessionDeckColor = 'DeckColor';
  SessionUse4ColorsDeck = 'Use4ColorsDeck';
  SessionEnableAnimation = 'EnableAnimation';
  SessionEnableChatBubbles = 'EnableChatBubbles';
  SessionEnableSounds = 'EnableSounds';
  SessionReverseStereoPanning = 'ReverseStereoPanning';
  SessionChatMode = 'ChatMode';

  SessionUserName =     '47341A54D72C4A918F75CA04938308755454643DFGDDFGSDFDSD';
  SessionUserPassword = '2F7A31ADD6E44803870B67FSD54A47B74D9A0GSD534FGFS6546D';

  SessionProcessStatsOnTop = 'SessionStatisticsAlwaysOnTop';
  SessionProcessStatsPreserve = 'PreserveStatisticsNextSession';
  SessionProcessLogging = 'ProcessStatisticsLogging';

  SessionWebserviceHost = 'webservicehost';

  SessionMultiInstancesAllowed = 'SessionMultiInstancesAllowed';

  SessionGameVersion = 'SessionGameVersion';

  // Lobby constants
  StatID_TableName = 1;
  StatID_PlayersCount = 2;
  StatID_Stakes = 102;
  StatID_Chairs = 108;
  StatID_GameType = 202;
  StatID_Limit = 203;

  SubCategoryColumnsItemID = 1;
  SubCategoryProcessesItemID = 2;
  SubCategoryProcessesInfoItemID = 3;

  TournamentSubCategoryID = -7;
  SitAndGoSubCategoryID  = -8;
  TournamentSubCategoryName = 'Tournaments';
  SitAndGoSubCategoryName = 'Sit && Go''s';
  StatID_TournamentID = 200;
  StatID_TournamentDate = 201;
  StatID_TournamentPlayers = 206;
  StatID_TournamentState = 205;

  RestrictedTournamentTypeID = 3;

  FocusedRowBackgroundColor = $9995EB;
  GroupedRowBackgroundColor = $9995EB;
  TextColor = $0;//$7B4B09;

  LobbyInfoCaptionColor = $FFFFFF;

  ListViewBackgroundColor = $FFFFFF;
  ListViewRowBackgroundColor = $ABABE3;
  ListViewSelectedBackgroundColor = $9995EB;
  ListViewCurrentBackgroundColor = $9995EB;
  ListViewTextColor = $0;//$7B4B09;

  DATANAME_SORT = 'sort';
  DATANAME_PROCESSCOUNT = 'processcount';
  DATANAME_PLAYERCOUNT = 'playercount';
  DATANAME_DATEFROM = 'datefrom';
  DATANAME_DATETO = 'dateto';
  DATANAME_STAKESORT = 'stakenopotlimit';

  // Process constants
  ProcessStatsFileName = 'Statistics.xml';
  ProcessStatsLogFileName = 'StatisticsLog.xml';
  ProcessPrevHandsFileName = 'PreviousHands.xml';
  ProcessStatsRootName = 'GameStatistics';
  ProcessStatsLogRootName = 'GameStatisticsLog';

  // File manager constants
  FilesFolderName = 'Files\';
  FilesToDownloadFolderName = 'Download\';
  FileListXMLFileName = 'filelist.xml';
  FileListXMLRootNodeName = 'filelist';
  DATANAME_VERSION = 'version';
  DATANAME_SIZECOMPLETED = 'SizeCompleted';

  // Cashier constants
  PlayMoneyCurrencyID = 1;
  RealMoneyCurrencyID = 2;
  BonusCurrencyID = 3;
  LoyalityPointsID = 4;
  OutsideUSProvince = 1;
  TransactionHistoryTopLastRecords = 50;
  TransactionHistoryDateBefore = 30;

  // XML nodename and attributes
  XMLATTRNAME_ID = 'id';
  XMLATTRNAME_IdID = '200';
  XMLATTRNAME_CATEGORYID = 'categoryid';
  XMLATTRNAME_SUBCATEGORYID = 'subcategoryid';
  XMLATTRNAME_PROCESSID = 'processid';
  XMLATTRNAME_GAMETYPE = 'pokertype';
  XMLATTRNAME_NAME = 'name';
  XMLATTRNAME_ITEMNAME = 'itemname';
  XMLATTRNAME_ITEMVALUE = 'itemvalue';
  XMLATTRNAME_LOGINNAME = 'loginname';
  XMLATTRNAME_POINTS = 'points';
  XMLATTRNAME_DATE = '201';
  XMLATTRNAME_KIND = 'kind';
  XMLATTRNAME_USERID = 'userid';
  XMLATTRNAME_SESSIONID = 'sessionid';

  XMLNODENAME_CATEGORY = 'category';
  XMLNODENAME_SUBCATEGORY = 'subcategory';
  XMLNODENAME_PROCESSES = 'processes';
  XMLNODENAME_COLUMNS = 'columns';

  XMLNODENAME_ACTIONDISPATCHERID = 'actiondispatcherid';
  XMLNODENAME_GAMETYPEID = 'gametypeid';
  XMLNODENAME_CHAIRSCOUNT = 'chairscount';
  XMLNODENAME_TOURNAMENTSTATEID = 'tournamentstateid';

  // Strings
  cstrAbout = AppName + ' client software.'#13#10 +
              'All Rights Reserved 2003.'#13#10 +
              'For info, send email to info@' + AppName + '.com.'#13#10 +
              'Client application version: ';

  cstrQuitQuestion = 'Are you sure you want to quit?';
  cstrSettingsDeny = 'You must be logged in to your machine as an adminstrator to change these settings.';
  cstrNonLatinChars = 'We apologize for the inconvenience, however you can use only latin characters. Thank you for your understanding.';
  cstrNeedFlashVersion = 'You need to download and install Macromedia Flash Player 7 (http://www.macromedia.com/downloads/) before playing this game.';		

  // Loading and Connecting
  cstrLoading       = 'Loading...';
  cstrConnecting    = 'Connecting...';
  cstrUpdating      = 'Updating client software application...';
  cstrUpdatingFiles = 'Updating graphic files...';
  cstrConnectFailed = 'Network error occured. Reconnecting...';
  cstrSynchronizing = 'Synchronizing...';
  cstrNetworkStatusURL = 'http://www.' + AppName + '.com/networkstatus.html';
  cstrSoftwareUpdateFailed  = 'Software updating failed. Please try again later and if that error will continue, contact site administrator.';
  cstrFilesUpdateFailed  = 'Graphic files updating failed. Please try again later and if that error will continue, contact site administrator.';
  cstrServerUnreachable = 'Server is unreachable at this moment because of network problem or by other technical reasons. Please try again later and if that error will continue, contact site administrator.';
  cstrCSALogFile = 'CSA.log';

  // Lobby
  cstrLobbyRetrievingInfo = 'Retrieving Info...';
  cstrLobbyTotalPlayers = ' Total players';
  cstrLobbyTotalProcesses = ' Total active tables';
  cstrLobbySubCategoryPlayers = {SubcategoryName}' players';
  cstrLobbySubCategoryProcesses = {SubcategoryName}' Active tables';
  cstrLobbySubCategoryTournamentPlayers = ' Players';
  cstrLobbySubCategoryTournaments = {SubcategoryName}' Tournaments';
  cstrCustomSupportSent = 'Your message has sent to custom support service.';
  cstrCustomSupportFailed = 'Message sending failed. Please try again later.';
  cstrWaitingListNotAllowed = 'The waiting list is currently unavailable, please select an open table to play.';
  cstrWaitingListIsFull = 'The waiting list is currently unavailable, please select an open table to play.';
  cstrLobbyHelp = 'http://www.' + AppName + '.com/support_commonquestions.html';
  cstrLobbyGameRules = 'http://www.' + AppName + '.com/Rules.html';
  cstrLobbyTip = 'http://www.' + AppName + '.com/Tip.html';
  cstrLobbyNews = 'http://www.' + AppName + '.com/News.html';
  cstrLobbyWhatsNew = 'http://ww.' + AppName + '.com/WhatsNew.html';
  cstrLobbyWhyChoose = 'http://www.' + AppName + '.com/WhyChoose.html';
  cstrLobbyBikiniForum = 'http://www.bikinipoker.com/phpBB2/index.php';


  // User
  cstrUserNameEmpty      = 'Please fill in your User ID.';
  cstrUserNameInvalid    = 'Please check that your User ID no longer than 13 symbols and containing only latin characters and digits.';
  cstrUserPasswordEmpty  = 'Please fill in your password.';
  cstrUserPasswordInvalid= 'Please check that your password has to be 6 characters or longer and contain atleast 1 numeric and 1 alpha character.';
  cstrUserPassNotEqual   = 'Your password and confirm password do not match. Please try again.';
  cstrUserFirstNameEmpty = 'Please fill in your first name.';
  cstrUserLastNameEmpty  = 'Please fill in your last name.';
  cstrUserEMailEmpty     = 'Please fill in your email.';
  cstrUserEMailInvalid   = 'The email address you entered is invalid. Please enter a valid email address.';
  cstrUserLocationEmpty  = 'Please fill in your location.';
  cstrUserEmptyFields    = 'One of the required fields is empty, please try again.';
  cstrUserRegistered     = 'You have successfully registered!';
  cstrUserAgeRestriction = 'There is an age limit on ' + AppName + ':'#13#10 +
                           'All players must be the legal age of majority ' +
                           'in their jurisdiction or at least 18 years of age ' +
                           '(whichever is greater).'#13#10 +
                           'No persons under this age limit are permitted ' +
                           'to use the ' + AppName + ' software or services in any way.'#13#10 +
                           'Are you old enough to meet this requirement?'#13#10;
  cstrUserChangedPassword = 'Password have been changed successfully!';
  cstrUserChangePasswordFailed = 'Changing password failed!';
  cstrUserChangeEMail    = 'The validation code has been send to your e-mail postbox.';
  cstrUserValidatedEMail = 'The validation of your e-mail address have been done successfully!';
  cstrUserValidateEMailFailed = 'The validation of your e-mail address failed!';
  cstrUserValidationCodeEmpty = 'Please fill in the validation code.';
  cstrUserValidationCodeInvalid = 'The validation code you entered is invalid. Please correct.';
  cstrUserChangedProfile      = 'Your profile has been changed successfully!';
  cstrUserForgotPassword      = 'Your password has been sent to your e-mail postbox!';
  cstrEmailNotValidated = 'Please validate your email address.';
  cstrUserAmountEmpty   = 'Please fill in transfer amount';
  cstrUserPlayerIDEmpty = 'Please fill in Player ID';
  cstrUserNotNumbers = 'Please fill in integer value';
  cstrUserCantGetMoreChips3times = 'You can get play chips only 3 times an hour';
  cstrUserCantGetMoreChips = 'You can get play chips if your balance is less than 200';
  cstrUserGetMoreChips = 'Your play money balance has been successfully rised on 1000 points.';
  cstrUserLogoPosted = 'Your new image selection has been received and put a quene for screening.'+
                       'Screening time will vary based on the number of images submitted.' +
                       'Activation may take up to 5 days.' ;
  cstrUserPostError = 'Your image hasn''t been received!'; 

  // Cashier
  cstrCashierRealNameEmpty = 'Please fill in your name.';
  cstrCashierAddressEmpty  = 'Please fill in your address.';
  cstrCashierCityEmpty     = 'Please fill in your city.';
  cstrCashierStateEmpty    = 'Please fill in your state or province.';
  cstrCashierZIPEmpty      = 'Please fill in your ZIP or postal code.';
  cstrCashierPhoneEmpty    = 'Please fill in your phone.';
  cstrCashierCountryEmpty  = 'Please choose you country in drop-down list.';
  cstrCashierChangedMailingAddressNeeded = 'You need to fill your mailing address before buy chips or cash out!';
  cstrCashierChangedMailingAddress = 'Your mailing address has been changed successfully!';
  cstrCashierChangeMailingAddressFailed = 'Changing mailing address failed!';
  cstrCashierDepositSuccessfull = 'You deposited successfully.';
  cstrCashierDepositFailed = 'Your deposit failed.';
  cstrCashierWithdrawSuccessfull = 'You withdrawal successfully.';
  cstrCashierWithdrawFailed = 'Your withdraw failed.';
  cstrCashierDepositAmountIncorrect = 'Please fill in the amount '#13#10'(min $20, max $600).';
  cstrCashierWithdrawalAmountIncorrect = 'Please fill in the amount '#13#10'(min $0.10, max-your current balance).';
  cstrCashierCardNumberEmpty = 'Please fill in your account number.';
  cstrCashierCVVEmpty = 'Please fill in your CVV number.';
  cstrCashierInvalidDate = 'Wrong date! Please check that "Date from" is early then "Date to".';

  // Process
  cstrProcessCrashed1 = 'We apologize for the inconvenience, however ';
  cstrProcessCrashed2 = ' is stopped by technical reason. All in play money will be returned. Thank you for your understanding.';
  cstrProcessStatsCopyToClipboard = 'Your statistics was copied to the clipboard';
  cstrProcessRequestHandHistorySend = 'Your request will send to your postbox.';
  cstrLimitation = 'We apologize for the inconvenience, however it is our policy to limit simultaneous play to ';
  cstrThanks = 'Thank you for your understanding.';
  cstrProcessTakingNow = 'We apologize for the inconvenience, however you can loading only one table at a time. Please wait until another table is loaded and load this table again. Thank you for your understanding.';
  cstrWaitingListUnregisterTable = 'Are you sure you want to unjoin waiting list of table '{Table name};
  cstrWaitingListUnregisterGroup = 'Are you sure you want to unjoin group waiting list?';
  cstrWaitingListUnregister = 'Are you sure you want to unjoin this waiting list?';
  cstrWaitingListTimer1 = 'You have ';
  cstrWaitingListTimer2 = ' sec to claim your seat.';
  cstrRecordHandSlot = 'Empty slot';
  cstrRecordHandLabel = 'Click here to add replay of specific hand number';
  cstrRecordHandErase = 'Are you sure you want to erase hand?';

  // Tournament
  cstrTournamentWord = ' tournament';
  cstrTournamentLobbyWord = ' lobby';
  cstrTournamentLoading = ' is loading...';
  cstrTournamentFailed = ' loading failed.';
  cstrTournamentRegister1 = 'Are you sure you agree to register on ';
  cstrTournamentRegister2 = '. Buy-In is ';
  cstrTournamentRegistered = 'You are successfully registered on ';
  cstrTournamentUnRegistered = 'You are successfully unregistered on ';
  cstrTournamentRegisterFailed = 'Tournament registation failed.';
  cstrTournamentUnRegisterFailed = 'Tournament unregistation failed.';
  cstrTournamentPotSum = 'Total prize pool: ';
  cstrTournamentWinnersCount = ' places paid.';
  cstrTournamentPrizesPool = 'http://www.' + AppName + '.com/tournamentprizespool.html';
  cstrWelcomeMessageLink = 'http://www.pokersatellites.com/welcome.html';
  cstrBannerLink         = 'http://www.bikinipoker.com/ads/ad.gif'; //265x65

  type
    TPaymentSystem = (psVISA, psMasterCard, psFirePay, psNETeller);

implementation

end.
