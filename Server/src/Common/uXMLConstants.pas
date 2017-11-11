unit uXMLConstants;

// OffshoreCreations Inc. (C) 2004
// Author: Roman Romanchuk

interface

const

    PO_OBJECTS                = 'objects';
    PO_OBJECT                 = 'object';
    PO_DEFAULTRESPONSEPACKET  = '<'+PO_OBJECT+'/>';
    PO_LEFTOBJECTBRACKET      = '<'+PO_OBJECT+'>';
    PO_RIGHTOBJECTBRACKET     = '</'+PO_OBJECT+'>';
    PO_LEFTOBJECTSBRACKET     = '<'+PO_OBJECTS+'>';
    PO_RIGHTOBJECTSBRACKET    = '</'+PO_OBJECTS+'>';

    PO_ATTRID                 = 'id';
    PO_ATTRNAME               = 'name';
    PO_ATTRSESSIONID          = 'sessionid';
    PO_ATTRPROCESSID          = 'processid';
    PO_ATTRRESULT             = 'result';
    PO_ATTRISREQUESTED        = 'isrequested';
    PO_CONNECT                = 'connect';
    PO_GETDEFPROP             = 'getdefprop';
    PO_SETDEFPROP             = 'setdefprop';
    PO_ADMGETHAND             = 'admgethand';
    PO_ADMGETHANDTEXT         = 'admgethandtext';
    PO_ATTRGUID               = 'guid';


// ***********************************************
// **                   Api                     **
// ***********************************************
    OBJ_API                      = 'api';
    AP_GETCATEGORIES             = 'apgetcategories';
    AP_GETPROCESSES              = 'apgetprocesses';
    AP_GETPROCESSINFO            = 'apgetprocessinfo';
    AP_UPDATEPROCESS             = 'apupdateprocess';
    AP_CREATEPROCESS             = 'apcreateprocess';
    AP_DELETEPROCESS             = 'apdeleteprocess';
    AP_GETCURRENCIES             = 'apgetcurrencies';
    AP_GETSTATS                  = 'apgetstats';
    AP_GETSUMMARY                = 'apgetsummary';
    AP_UPDATESUMMARY             = 'apupdatesummary';
    AP_GETCOUNTRIES              = 'apgetcountries';
    AP_REGISTERATWAITINGLIST     = 'apregisteratwaitinglist';
    AP_UNREGISTERFROMWAITINGLIST = 'apunregisterfromwaitinglist';
    AP_GETSTATES                 = 'apgetstates';
    AP_GETNOTES                  = 'apgetnotes';
    AP_SAVENOTES                 = 'apsavenotes';
    AP_CLONEPROCESS              = 'apcloneprocess';
    AP_GETRECORDEDHANDHISTORY    = 'apgetrecordedhandhistory';
    AP_GETRECORDEDHANDS          = 'apgetrecordedhands';
    AP_SAVERECORDEDHANDS         = 'apsaverecordedhands';
    AP_REQUESTHANDHISTORY        = 'aprequesthandhistory';
    AP_CHECKHANDID               = 'apcheckhandid';
    AP_CUSTOMSUPPORT             = 'apcustomsupport';
    AP_GETWAITINGLISTINFO        = 'apgetwaitinglistinfo';
    AP_RESETALLIN                = 'apresetallin';
    AP_GETLEADERBOARD            = 'apgetleaderboard';
    AP_SPARKLECHEATS             = 'sparklecheats';
    AP_SAVEHANDHISTORY           = 'apsavehandhistory';

    // For each process notification
    AP_DISCONNECT                = 'apdisconnect';
    AP_RECONNECT                 = 'apreconnect';
    AP_SETPARTICIPANTASLOGGED    = 'apsetparticipantaslogged';   //
    AP_CHATALLOW                 = 'apchatallow';
    AP_KICKOFUSER                = 'apkickofuser';
    AP_LEAVETABLE                = 'apleavetable';

// ***********************************************
// **                   Account                 **
// ***********************************************
    OBJ_ACCOUNT       = 'account';
    AO_MAKESTAKE      = 'aomakestake';
    AO_WONSTAKE       = 'aowonstake';
    AO_GETBALANCEINFO = 'aogetbalanceinfo';
    AO_CANCELSTAKE    = 'aocancelstake';
    AO_TAKESTAKE      = 'aotakestake';

    AO_CreateNew                = 'aocreatenew';
    AO_Deposit                  = 'aodeposit';
    AO_Withdrawal               = 'aowithdrawal';
    AO_ReservAmount             = 'aoreservamount';
    AO_ReturnAmount             = 'aoreturnamount';
    AO_MoneyExchange            = 'aomoneyexchange';
    AO_GetReservedBalanceInfo   = 'aogetreservedbalanceinfo';
    AO_ChangeStatus             = 'aochangestatus';
    AO_GetReservedAmount        = 'aogetreservedamount';
    AO_GetUserCurrencyBalance   = 'aogetusercurrencybalance';
    AO_MakeTx                   = 'aomaketx';
    AO_GetMailingAddress        = 'aogetmailingaddress';
    AO_UpdateMailingAddress     = 'aochangemailingaddress';
    AO_TransactionHistory       = 'aogethistory';
    AO_CalculateRake            = 'admcalculaterake';
    AO_UserGroupsAllocation     = 'admusergroupsallocation';
    AO_ChangeBalance            = 'aochangebalance';
    AO_PromoCards               = 'aopromocards';

// ***********************************************
// **                   BuddyWager              **
// ***********************************************
    OBJ_BuddyWager               = 'buddywager';
    BW_GETCATEGORIES             = 'bwgetcategories';
    BW_GETMYWAGERS               = 'bwgetmywagers';
    BW_GETOUTCOMES               = 'bwgetoutcomes';
    BW_GETOFFERS                 = 'bwgetoffers';
    BW_MAKEOFFER                 = 'bwmakeoffer';
    BW_TAKEOFFER                 = 'bwtakeoffer';
    BW_CANCELOFFER               = 'bwcanceloffer';
    BW_DELETEOFFER               = 'bwdeleteoffer';
    BW_SETMYFAVORITES            = 'bwsetmyfavorites';
    BW_GETMYFAVORITES            = 'bwgetmyfavorites';
    BW_CHANGEEVENTSTATUS         = 'bwchangeeventstatus';
    BW_CHANGEEVENTSTATUS1        = 'sbchangeeventstatus';
    BW_RESOLVEEVENTBETLINES      = 'bwresolveeventbetlines';
    BW_RESOLVEEVENTBETLINES1     = 'sbresolveeventbetlines';
    BW_CLOSE                     = 'bwclose';
    BW_BUDDYALERT                = 'bwbuddyalert';


// ***********************************************
// **                 GameAdapter               **
// ***********************************************
    OBJ_GameAdapter           = 'gameadapter';
    GA_JOINPROCESS            = 'gajoinprocess';
    GA_ACTION                 = 'gaaction';
    GA_REINIT                 = 'gareinit';
    GA_DISCONNECT             = 'gadisconnect';
    GA_SETPARTICIPANTASLOGGED = 'gasetparticipantaslogged';
    GA_CHATALLOW              = 'gachatallow';
    GA_KICKOFUSER             = 'gakickofuser';
    GA_LEAVETABLE             = 'galeavetable';
    GA_PROCESSESSTATUS        = 'gaprocessesstatus';
    GA_CreatePrivateTable     = 'gacreateprivatetable';
     //bots addon
    GA_BOT_STAND_UP_ALL       = 'bot_standup_all';
    GA_BOT_SIT_DOWN           = 'bot_sitdown';
    GA_BOT_SIT_DOWN_AUTO      = 'bot_sitdown_auto';

// ***********************************************
// **                 FileManager               **
// ***********************************************
    OBJ_FILEMANAGER           = 'filemanager';
    FM_GETFILEINFO            = 'fmgetfileinfo';
    FM_GETPROCESSFILES        = 'fmgetprocessfiles';
    FM_GETSYSTEMFILES         = 'fmgetsystemfiles';
    FM_GETPLAYERLOGO          = 'fmgetplayerlogo';
    FM_GETPUSHINGCONTENTFILES = 'fmgetpushingcontentfiles';

// ***********************************************
// **                  Email                    **
// ***********************************************
    OBJ_EMAIL            = 'email';
    EM_SendUserEmail     = 'emsenduseremail';
    EM_SendAdminEmail    = 'emsendadminemail';
    EM_SendCustomEmail   = 'emsendcustomemail';


// ***********************************************
// **                  User                     **
// ***********************************************
    OBJ_USER                = 'user';
    UO_LOGINUSER            = 'uologin';
    UO_LOGOUTUSER           = 'uologout';
    UO_REGISTERNEWUSER      = 'uoregister';
    UO_GETPROFILE           = 'uogetprofile';
    UO_UPDATEPROFILE        = 'uoupdateprofile';
    UO_CHANGEPASSWORD       = 'uochangepassword';
    UO_USERSTATISTICS       = 'uogetstatistics';
    UO_CHANGESTATUS         = 'uochangestatus';
    UO_SENDVALIDATIONMAIL   = 'uochangeemail';
    UO_VALIDATE             = 'uovalidateemail';
    UO_FORGOTPASSWORD       = 'uoforgotpassword';
    UO_POPUPMESSAGESHISTORY = 'uopopupmessageshistory';
    UO_TRASFERMONEYTO       = 'uotransfermoneyto';
    UO_FINDPLAYER           = 'uofindplayer';

// ***********************************************
// **                 Tournament                **
// ***********************************************
    OBJ_TOURNAMENT         = 'tournament';
    TO_GET_INFO            = 'togetinfo';
    TO_GET_PLAYERS         = 'togetplayers';
    TO_GET_PROCESSES       = 'togetprocesses';
//    anGetProcessPlayers    = 'togetprocessplayers';
    TO_GET_TOURNAMENT_INFO = 'togettournamentinfo';
    TO_GET_TOURNAMENTS     = 'togettournaments';
    TO_REGISTER            = 'toregister';
    TO_UNREGISTER          = 'tounregister';
    TO_REBUY               = 'torebuy';
    TO_AUTO_REBUY          = 'toautorebuy';
    TO_GET_LEADERBOARD     = 'togetleaderboard';
    TO_GET_LEADERPOINTS    = 'togetleaderpoints';
    TO_GET_LEVELS_INFO     = 'togetlevelsinfo';

// ***********************************************
// **                 ClientAdapter             **
// ***********************************************
    OBJ_CLIENTADAPTER             = 'clientadapter';
    CA_NOTIFY                     = 'canotify';
    CA_NOTIFYALL                  = 'canotifyall';
    CA_CONNECTIONSALLOWED         = 'caconnectionsallowed';
    CA_SessionIDs                 = 'casessionids';
    CA_UserIDs                    = 'causerids';
    CA_MainChat                   = 'camainchat';
    CA_PrivateChatInit            = 'caprivatechatinit';
    CA_PrivateChat                = 'caprivatechat';
    CA_PrivateChatError           = 'caprivatechaterror';
    CA_BuddyListUpdate            = 'cabuddylistupdate';
    CA_BuddyListAction            = 'cabuddylistaction';
    CA_PrivateMessage             = 'caprivatemessage';


// ***********************************************
// **                 ActionDispatcher          **
// ***********************************************
    OBJ_ACTIONDISPATCHER          = 'actiondispatcher';



// ***********************************************
// **                 ActionProcessor           **
// ***********************************************
    OBJ_ACTIONProcessor           = 'actionprocessor';



// ***********************************************
// **                   MSMQReader              **
// ***********************************************
    OBJ_MSMQReader                = 'msmqreader';

// ***********************************************
// **                   MSMQWriter              **
// ***********************************************
    OBJ_MSMQWriter                = 'msmqwriter';
    MW_Message                    = 'mwmessage';


// ***********************************************
// **                 Reminder                  **
// ***********************************************
    OBJ_REMINDER      = 'reminder';
    SC_CREATEREMIND   = 'createremind';
    SC_CHANGEREMIND   = 'changeremind';
    SC_REMOVEREMIND   = 'removeremind';
    SC_RESETREMIND    = 'resetremind';
    SC_DIAGNOSTIC     = 'diagnostic';

// ***********************************************
// **            CommonDataModule               **
// ***********************************************
    OBJ_COMMON      = 'common';
    CM_Settings     = 'cmsettings';
    CM_ClientConnectionsStatus = 'cmclientconnectionstatus';
    CM_ProcessesStatus = 'cmprocessstatus';
    CM_SendAdminMSMQ = 'cmsendadminmsmq';


// ***********************************************
// **            ActionDispatcher               **
// ***********************************************
    OBJ_ACTIONDISP  = 'actiondisp';
    AD_Signatute    = 'adsign';
    AD_ServiceID = 'adserviceid';
    AD_SendToAll    = 'adsendtoall';
    AD_SendToAllGameAdapters  = 'gasendtoall';
    AD_SendToAllClientAdapters  = 'casendtoall';
    AD_ClientConnect     = 'adclientconnect';
    AD_ClientDisconnect  = 'adclientdisconnect';
    AD_ProcessStopped = 'adprocessstopped';
    AD_ServiceList = 'services';
    AD_ServiceName = 'servicename';
    AD_ActionDispatcherID = 'actiondispatcherid';



// ***********************************************
// **               CSA                         **
// ***********************************************
    APP_LOBBY                      = 'lobby';
    APP_CHAT                       = 'chat';
    APP_USER                       = 'user';
    APP_FILEMANAGER                = 'filemanager';
    APP_CONVERSIONS                = 'conversions';
    APP_PROCESS                    = 'process';
    APP_CASHIER                    = 'cashier';
    APP_SPORTSBOOK                 = 'sportsbook';
    APP_BUDDYWAGER                 = 'buddywager';
    APP_TOURNAMENT                 = 'tournament';

implementation

end.



