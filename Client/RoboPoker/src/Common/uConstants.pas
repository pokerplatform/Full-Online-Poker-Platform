unit uConstants;

interface

{$DEFINE DumpItems_ON_MemoryDump}

const

  // Application constants
  CSA_ID    = 1;
  CSA_Version = '1.9 Build #';
  CSA_Build = 999999999;
  CSA_AffiliateID = 1;

  Shift_string_On_DumpMemory = '___';

  UpdateInfoTimeSec = 10;

  AppName = 'RoboPoker';
  AppFileName = AppName + '.exe';
  AppUpdateFileName = AppName + '_Update.exe';
  BannerContentTypeID = 2;
  BannerDefaultFileName = 'banner.swf';
  PlayerLogoContentTypeID = 7;
  PlayerLogoDefaultFileName = 'avatar.swf';
  FlashGameContentTypeID = 3;
  FlashGameDefaultFileName = 'poker.swf';

  RemoteHost   = 'saturn';//''poker.offshorecreations.com';
  RemotePort   = '4000';
  cntStayAliveCommand = '<ping/>';

  RegistryKey   = 'SOFTWARE\' + AppName + '\Settings';
  RegistryAffiliateIDName = 'AffiliateID';

  // Session settings
  SessionHidePlayMoneyTables = 'HidePlayMoneyTables';

  SessionDeckColor = 'DeckColor';
  SessionUse4ColorsDeck = 'Use4ColorsDeck';
  SessionEnableAnimation = 'EnableAnimation';
  SessionEnableChatBubbles = 'EnableChatBubbles';
  SessionEnableSounds = 'EnableSounds';
  SessionReverseStereoPanning = 'ReverseStereoPanning';
  SessionChatMode = 'ChatMode';

  // Lobby constants
  StatID_TableName = 1;
  StatID_PlayersCount = 2;
  StatID_Stakes = 102;

  SubCategoryColumnsItemID = 1;
  SubCategoryProcessesItemID = 2;
  SubCategoryProcessesInfoItemID = 3;

  DATANAME_SORT = 'sort';
  DATANAME_PROCESSCOUNT = 'processcount';
  DATANAME_PLAYERCOUNT = 'playercount';
  DATANAME_DATEFROM = 'datefrom';
  DATANAME_DATETO = 'dateto';
  DATANAME_STAKESORT = 'stakenopotlimit';

  // Bot constants
  BotListFileName = 'botlist.xml';
  BotLastIdentity = 'LastIdentity';
  BotRemoteHost = 'Host';
  BotRemotePort = 'Port';
  BotKeepConnected = 'KeepConnected';
  BotSSL = 'SSL';
  BotCompressTraffic = 'CompressTraffic';
  BotLogging = 'Logging';
  BotNewConnectionsPerSecond = 'NewConnectionsPerSecond';
  BotGenerationName = 'BotName';
  BotGenerationPassword = 'BotPassword';
  BotGenerationLocation = 'BotLocation';
  BotGenerationCount = 'BotCount';
  BotGenerationPrivate = 'BotPrivate';
  BotGenerationMale = 'BotMale';
  BotRefreshInterval = 'RefreshInterval';
  BotEmulateLobby = 'EmulateLobby';
  BotEmulateLobbyType = 'EmulateLobbyType';
  BotAutoSitCount = 'BotAutoSitCount';
  BotAutoLeaveOnGamers = 'BotAutoLeaveOnGamers';
  BotAutoSitGamers = 'BotAutoSitGamers';
  BotAutoSitTimeOut = 'BotAutoSitDownTimeOut';
  BotAutoResponseTimeOut = 'BotAutoResponseTimeOut';
  BotResponseTimeOutProcesses = 'BotResponseTimeOutProcesses';
  BotResponseTimeOutOnBotEntry = 'BotResponseTimeOutOnBotEntry';
  BotTimeOutOnHandTimeline = 'BotTimeOutOnHandTimeline';
  BotMailList = 'BotMailList';
  BotAllowManyTables = 'BotAllowManyTables';
  BotUseHeaders = 'BotUseHeaders';
  BotRestrictByNames = 'BotRestrictByNames';
  BotRestrictedNames = 'BotRestrictedNames';
  BotActionDispatcherIDList = 'BotActionDispatcherIDList';
  BotMaximumWorkTime = 'BotMaximumWorkTime';
  BotStopAfterMaximumWorkTime = 'BotStopAfterMaximumWorkTime';
  BotRestartAfterMaximumWorkTime = 'BotRestartAfterMaximumWorkTime';

  // Bot Controls
  EditCaption = 'Edit';
  SaveCaption = 'Save';
  RefreshNowCaption = 'Refresh Now';
  CancelCaption = 'Cancel';


  // Bot data
  // String
  BotLoginName    = 'LoginName';
  BotPassword     = 'Password';
  BotFirstName    = 'FirstName';
  BotLastName     = 'LastName';
  BotEMail        = 'EMail';
  BotLocation     = 'Location';
  // Boolean
  BotShowLocation = 'ShowLocation';
  BotEMailAlerts  = 'EMailAlerts';
  BotBuddyAlerts  = 'BuddyAlerts';
  // Integer
  BotAvatarID     = 'AvatarID';
  BotSexID        = 'SexID';

  // Process constants
  ProcessPrevHandsFileName = 'PreviousHands.xml';

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
  OutsideUSProvince = 1;
  TransactionHistoryTopLastRecords = 50;
  TransactionHistoryDateBefore = 30;

  // XML nodename and attributes
  XMLATTRNAME_ID = 'id';
  XMLATTRNAME_CATEGORYID = 'categoryid';
  XMLATTRNAME_SUBCATEGORYID = 'subcategoryid';
  XMLATTRNAME_PROCESSID = 'processid';
  XMLATTRNAME_GAMETYPE = 'pokertype';
  XMLATTRNAME_NAME = 'name';
  XMLATTRNAME_ITEMNAME = 'itemname';
  XMLATTRNAME_ITEMVALUE = 'itemvalue';

  XMLNODENAME_CATEGORY = 'category';
  XMLNODENAME_SUBCATEGORY = 'subcategory';
  XMLNODENAME_PROCESSES = 'processes';
  XMLNODENAME_COLUMNS = 'columns';
  XMLNODENAME_ACTIONDISPATCHERID = 'actiondispatcherid';
  XMLNODENAME_BOTSCOUNT = 'botscount';

  // Strings
  cstrQuitQuestion = 'Are you sure you want to quit?';
  cstrSettingsDeny = 'You must be logged in to your machine as an adminstrator to change these settings.';


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
  cstrWaitingListNotAllowed = 'Waiting list is not allowed in tournaments!';

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
  cstrTournamentRegisterFailed = 'Tournament registation failed.';
  cstrTournamentPotSum = 'Total prize pool: ';
  cstrTournamentWinnersCount = ' places paid.';
  cstrTournamentPrizesPool = 'http://www.' + AppName + '.com/tournamentprizespool.html';

  type
    TPaymentSystem = (psVISA, psMasterCard, psFirePay, psNETeller);

implementation

end.
