unit uErrorConstants;

(*
********************************************************************
** Project po
** unit goal: Project Constants Textes
********************************************************************
Started: 08/15/2003 Roman Romanchuk (roma@OffshoreCreations.com.ua)

*)

interface

Const


//==================================================================
// Object Standard Messages


// ***********************************************
// **                 Common            0-1000  **
// ***********************************************

PO_NOERRORS                            = 0;
PO_ERR_GETTINGXMLASSTRINGFROMSQL       = 1;
PO_ERR_CANNOTCREATESQLADAPTOR          = 2;
PO_ERR_SQLADAPTORINSTANCEFAIL          = 3;
PO_ERR_CANNOTROLLBACKOPENTRANSACTION   = 4;
PO_ERR_CANNOTSENDBROADCASTMESSAGE      = 5;

// ***********************************************
// **               poClientAdaptor   1000-1499 **
// ***********************************************
CA_ERR_NEEDUPDATE                     = 1001;
CA_PC_UserDoesNotExists               = 1101;
CA_PC_UserDisconnected                = 1102;
CA_PC_UserBlocked                     = 1103;
CA_PC_ServerError                     = 1199;

// ***********************************************
// **               poCollaboration   1500-1799 **
// ***********************************************

CO_ERR_WRONGXMLPACKET                    = 1501;
CO_ERR_CANNOTCRETEAPI                    = 1502;
CO_ERR_CANNOTPROVIDEAPIPACKET            = 1503;
CO_ERR_CANNOTCRETEFILEMANAGER            = 1504;
CO_ERR_CANNOTPROVIDEFILEMANAGERPACKET    = 1505;
CO_ERR_CANNOTCRETEUSER                   = 1506;
CO_ERR_CANNOTPROVIDEUSERPACKET           = 1507;
CO_ERR_CANNOTCRETETOURNAMENT             = 1508;
CO_ERR_CANNOTPROVIDETOURNAMENTPACKET     = 1509;
CO_ERR_CANNOTCRETEGAMEADAPTER            = 1510;
CO_ERR_CANNOTPROVIDEGAMEADAPTERPACKET    = 1511;
CO_ERR_CANNOTCRETEACCOUNT                = 1512;
CO_ERR_CANNOTPROVIDEACCOUNTPACKET        = 1513;
CO_ERR_CANNOTCRETEBUDDYWAGER             = 1514;
CO_ERR_CANNOTPROVIDEBUDDYWAGERPACKET     = 1515;
CO_ERR_WHENPERFORMGAMEACTIVITY           = 1516;




// ***********************************************
// **               poSQLAdaptor3     1800-1999 **
// ***********************************************


SL_ERR_CANNOTCREATESQLCONNECTION            = 1800;
SL_ERR_CANNOTCREATESQLCOMMAND               = 1801;
SL_ERR_CANNOTSETPROCNAME                    = 1802;
SL_ERR_CANNOTADDPARAM                       = 1803;
SL_ERR_CANNOTGETPARAM                       = 1804;
SL_ERR_CANNOTSTARTTRANSACTION               = 1805;
SL_ERR_CANNOTCOMMITTRANSACTION              = 1806;
SL_ERR_CANNOTROLLBACKACTION                 = 1807;
SL_ERR_CANNOTSAVEBLOB                       = 1808;
SL_ERR_CANNOTGETSTATEID                     = 1809;
SL_ERR_CANNOTEXECUTESQL                     = 1810;
SL_ERR_CANNOTEXECUTECOMMAND                 = 1811;
SL_ERR_CANNOTGETCONNECTIONSTRING            = 1812;
SL_ERR_CANNOTEXECUTEFORXML                  = 1813;
SL_ERR_METHODODONTSUPPORTED                 = 1814;
SL_ERR_CANNOTGETBLOB                        = 1815;

//SO_ERR_ = 10;

// ***********************************************
// **               poGameAdaptor     2000-2499 **
// ***********************************************

GA_ERR_CORRUPTREQUESTXML                         = 2001;
GA_ERR_UNKNOWNACTION                             = 2002;
GA_ERR_CORRUPTREQUESTARGUMENTS                   = 2003;
GA_ERR_CANNOTADDXMLCHILDNODE                     = 2101;
GA_ERR_CANNOPROCESSSPECACTION                    = 2102;
GA_ERR_CANNOTEXECUTESQL                          = 2103;
GA_ERR_WHENACCOUNTREQUEST                        = 2104;
GA_ERR_WHENTABLEREINIT                           = 2105;
GA_ERR_CANNOTCREATEAPIREMINDER                   = 2106;
GA_ERR_UNDEFINEDHANDID                           = 2107;
GA_ERR_ONEXECUTEAPI                              = 2108;

// ***********************************************
// **                 poApi           2500-2999 **
// ***********************************************

AP_ERR_CORRUPTREQUESTXML                         = 2501;
AP_ERR_UNKNOWNACTION                             = 2502;
AP_ERR_CORRUPTREQUESTARGUMENTS                   = 2503;
sAP_ERR_CORRUPTREQUESTARGUMENTS                  = 'Invalid argument'; 
AP_ERR_CANNOTADDXMLCHILDNODE                     = 2601;
AP_ERR_CANNOTSAVEGAMESTATE                       = 2602;
AP_ERR_CANNOTGETGAMESTATE                        = 2603;
AP_ERR_GAMESTATENOTFOUND                         = 2604;
AP_ERR_CANNOTGETGAMESTATS                        = 2605;
AP_ERR_GAMESTATSNOTFOUND                         = 2607;
AP_ERR_CANNOTSETGAMESTATS                        = 2608;
AP_ERR_PREPARENOTIFPACKET                        = 2609;
AP_ERR_CANNOTGETPROCESSSTATSSUBSCRIBERS          = 2610;
AP_ERR_CANNOTCREATEGAMESTATS                     = 2611;
AP_ERR_CANNOTGETPROCESSINFO                      = 2612;
AP_ERR_CANNOTGETCURRENCYINFO                     = 2613;
AP_ERR_CANNOTGETGAMEPROCESSINFO                  = 2614;
AP_ERR_CANNOTCREATEGAMEENGINE                    = 2615;
AP_ERR_CANNOTATTACHPARTICIPANTTOTHEPROCESS       = 2616;
AP_ERR_CANNOTDETACHPARTICIPANTFROMTHEPROCESS     = 2617;
AP_ERR_CANNOTPROCESSSTEP                         = 2618;
AP_ERR_CANNOTGETSYSTEMSUMMARY                    = 2619;
AP_ERR_CANNOTCREATEGAMESTATE                     = 2620;
AP_ERR_CANNOTGETPARTICIPANTINFO                  = 2621;
AP_ERR_PARTICIPANTISNOTLOGGEDON                  = 2623;
AP_ERR_CANNOTCOMMITSQLTRANSACTION                = 2624;
AP_ERR_CANNOTBEGINSQLTRANSACTION                 = 2625;
AP_ERR_CANNOTROLLBACKSQLTRANSACTION              = 2626;
AP_ERR_CANNOTCREATEACCOUNTOBJECT                 = 2627;
AP_ERR_CANNOTRESERVEMONEY                        = 2628;
AP_ERR_CANNOTRETURNEMONEY                        = 2629;
AP_ERR_CANNOTFINISHHAND                          = 2630;
AP_ERR_CANNOTSTARTHAND                           = 2631;
AP_ERR_CANNOTCREATEACTIONLOG                     = 2632;
AP_ERR_HANDALREADYFINISHED                       = 2633;
AP_ERR_CANNOTINITXMLWHENTOURCREATING             = 2634;
AP_ERR_CANNOTPROCESSPROPERTIESWHENTOURCREATING   = 2635;
AP_ERR_CANNOTLOGACTIVITY                         = 2636;
AP_ERR_CANNOTSETPARTICIPANTCOUNT                 = 2637;
AP_ERR_CANNOTCLONEGAMEPROCESS                    = 2638;
AP_ERR_CANNOTINITGAMEPROCESS                     = 2639;
AP_ERR_CANNOTREGISTERATWAITINGLIST               = 2640;
sAP_ERR_CANNOTREGISTERATWAITINGLIST              = 'Unknown error on register at waiting list';
AP_ERR_CANNOTGETUSERIDBYSESSIONID                = 2641;
sAP_ERR_CANNOTGETUSERIDBYSESSIONID               = 'User is not logged';
AP_ERR_CANNOPREPARERESPONSENODE                  = 2642;
AP_ERR_CANNOTUNREGISTERFROMWAITINGLIST           = 2643;
AP_ERR_CANNOTGETNEXTFROMWAITINGLIST              = 2644;
AP_ERR_CANNOTRETURNTOWAITINGLISTANDUNLOCK        = 2645;
AP_ERR_CANNOTGETUSERBALANCE                      = 2646;
AP_ERR_CANNOTHANDFEE                             = 2647;
AP_ERR_CANNOTHANDLOST                            = 2648;
AP_ERR_CANNOTHANDWON                             = 2649;
AP_ERR_CANNOTGETUSERNOTE                         = 2650;
AP_ERR_CANNOTSAVEUSERNOTE                        = 2651;
AP_ERR_CANNOTGETHANDHISTORY                      = 2652;
AP_ERR_CANNOTCREATETXDOC                         = 2653;
AP_ERR_CANNOMAKEHANDRESULT                       = 2654;
AP_ERR_CANNOTGETWAITERSCOUNT                     = 2655;
AP_ERR_CANNOTSTOREFAVORITEGAMES                  = 2656;
AP_ERR_CANNOTREMOVEEXISTSFAVORITEGAMES           = 2657;
AP_ERR_CANNOTGETRECORDERHAND                     = 2658;
AP_ERR_CANNOTCORRECTHANDHISTORY                  = 2659;
AP_ERR_POKERTYPEUNDEFINED                        = 2660;
AP_ERR_TROUBLEWITHDEALCARDS                      = 2661;
AP_ERR_TROUBLEWITHRANKINGREMOVING                = 2662;
AP_ERR_CANNOTGETPROCESSIDBYHANDID                = 2663;
AP_ERR_HANDNOTFOUND                              = 2664;
AP_ERR_CANNOTSAVESUBJECT                         = 2665;
AP_ERR_CANNOTGETWAITINGLISTINFO                  = 2666;
AP_ERR_TEXTHISTCANNOTINIT                        = 2667;
AP_ERR_WRONGPROCSTATE                            = 2668;
AP_ERR_CANNOTMAKEPROCESSSTRINGINFO               = 2669;
AP_ERR_CANNOTGETADDITIONALINFOFROMSQL            = 2670;
AP_ERR_CANNOTPREPAREHANDTEXTOUTPUT               = 2671;
AP_ERR_CANNOTCREATEEMAILOBJECT                   = 2672;
AP_ERR_CANNOTSENDEMAIL                           = 2673;
AP_ERR_CANNOTPREPARESUBJECTANDHEADER             = 2674;
AP_ERR_USERNOTFOUND                              = 2675;
AP_ERR_CANNOTSETUPREMIND                         = 2676;
AP_ERR_CANNOTGETTOURNAMENTINFO                   = 2677;
AP_ERR_CANNOTGETUSERSESSION                      = 2678;
AP_ERR_CANNOTRESERVEMONEYFORTOURNAMENT           = 2679;
AP_ERR_CANNOTTAKETOURNAMENTPRIZE                 = 2680;
AP_ERR_WRONGREQUESTDATA                          = 2681;
AP_ERR_CANNOTUNRESERVEMONEYFORTOURNAMENT         = 2682;
AP_ERR_CANNOTCREATETOURNEYREMIND                 = 2683;
AP_ERR_CANNOTGETRESERVEMAP                       = 2684;
AP_ERR_USERCANNOUTMAKEALLIN                      = 2685;
AP_ERR_METHODDONTSUPPORT                         = 2686;
AP_ERR_CANNOTGETCHECKSUM                         = 2687;
AP_ERR_CANNOTSETCHECKSUM                         = 2688;
AP_ERR_CANNOTSETGAMETYPEID                       = 2689;
// waiting list results
AP_ERR_ALLREADYRESERVED_BYPROCESS_ONWAITINGLIST  = 2690;
sAP_ERR_ALLREADYRESERVED_BYPROCESS_ONWAITINGLIST = 'Allready reserved by process';
AP_ERR_ALLREADYGAMER_BYPROCESS_ONWAITINGLIST     = 2691;
sAP_ERR_ALLREADYGAMER_BYPROCESS_ONWAITINGLIST    = 'You is gamer at process';
AP_ERR_MAXIMUM_MEMBERS_IS_OCCURED_ATWAITINGLIST  = 2692;
sAP_ERR_MAXIMUM_MEMBERS_IS_OCCURED_ATWAITINGLIST = 'Maximum members is occured at the waiting list';
AP_ERR_ALLREADYRESERVED_BYGROUP_ONWAITINGLIST    = 2693;
sAP_ERR_ALLREADYRESERVED_BYGROUP_ONWAITINGLIST   = 'Allready reserved by process group';
AP_ERR_ALLREADYGAMER_BYGROUP_ONWAITINGLIST       = 2694;
sAP_ERR_ALLREADYGAMER_BYGROUP_ONWAITINGLIST      = 'You is gamer at process group';
AP_ERR_SQLERROR                                  = 2695;

// ***********************************************
// **               poBuddyWager    3000-3499 **
// ***********************************************

BW_ERR_CORRUPTREQUESTXML                         = 3000;
BW_ERR_CORRUPTREQUESTARGUMENTS                   = 3001;
BW_ERR_UNKNOWNACTION                             = 3002;
BW_ERR_CANNOTADDXMLCHILDNODE                     = 3003;
BW_ERR_CANNOTGETCATEGORIES                       = 3004;
BW_ERR_CANNOTGETMYWAGERS                         = 3005;
BW_ERR_CANNOTMAKEBET                             = 3006;
BW_ERR_USERHAVENOTDOLLARACCOUNT                  = 3007;
SB_ERR_YOUDONTHAVEENOUGHTMONEY                   = 3008;
SB_ERR_CANNOTGETBALANCEINFO                      = 3009;
BW_ERR_CANNOTGETBALANCEINFO                      = 3010;
BW_ERR_STAKEVALUEISLARGE                         = 3011;
BW_ERR_CANNOTCREATEREMINDER                      = 3012;
BW_ERR_CANNOTCORRECTEVENTINFOAFTERBETTING        = 3013;
BW_ERR_CANNOTTAKEBET                             = 3014;
BW_ERR_INVALIDSTAKEVALUEOFTAKER                  = 3015;
BW_ERR_CANNOTCANCELBET                           = 3016;
BW_ERR_CANNOTCLEARREMINDER                       = 3017;
BW_ERR_CANNOTBROADCAST                           = 3018;
BW_ERR_CANNOTCANCELBUDDYWAGERSTATUS              = 3019;
BW_ERR_EXISTSOPPONNETS                           = 3020;
BW_ERR_CANNOTSETFAVORITETEAM                     = 3021;
BW_ERR_YOUDONTHAVEENOUGHTMONEY                   = 3022;
BW_ERR_CANNOTCHANGEEVENTSTATE                    = 3023;
BW_ERR_CANNOTDOWONSTAKE                          = 3024;
BW_ERR_CANNOTCREATEACCOUNTOBJECT                 = 3025;
BW_ERR_CANNOTEEXECUTESQL                         = 3026;
BW_ERR_CANNOTGETFIELDSFROMRECORDSET              = 3027;
BW_ERR_CANNOTPROCESSWONSTAKE                     = 3028;
BW_ERR_CANNOTGETDATAFOREVENTBETSRESOLVING        = 3029;

// ***********************************************
// **               poSchedule        3500-3999 **
// ***********************************************

SC_ERR_CANTOPENMSMQQUEUE                = 3501;
SC_ERR_CANTRECEIVEMESSAGEFROMQUEUE      = 3502;
SC_ERR_CANTANALYSEMESSAGE               = 3503;
SC_ERR_CANTCREATEMSMQQUEUE              = 3504;
SC_ERR_CANTFREESERVICECONTENT           = 3505;
SC_ERR_REQUESTISNOTHAVEVALIDXMLFORMAT   = 3506;
SC_ERR_WHENREQUESTPROCESSING            = 3507;
SC_ERR_CANNOTADDREMIND                  = 3508;
SC_ERR_CANNOTCHANGEREMIND               = 3509;
SC_ERR_CANNOTREMOVEREMIND               = 3510;
SC_ERR_CANNOTRESETREMIND                = 2511;
SC_ERR_CANNOTGETDIAGNOSTIC              = 3512;
SC_ERR_WRONGREQUESTDATAFORMAT           = 3513;
SC_ERR_REMINDALREADYEXISTS              = 3514;
SC_ERR_CANNOTINSERTREMINDBYDATE         = 3515;
SC_ERR_ERRORWHENLOOKINGFORCOPY          = 3516;
SC_ERR_WHENDIAGNOSTICPREPARED           = 3517;
SC_ERR_CANNOTSHOWDIAGNOSTIC             = 3518;
SC_ERR_CANNORESETTIMEKEEPER             = 3519;
SC_ERR_REMINDNOTFOUND                   = 3520;
SC_ERR_CANTINITSCHEDULESERVICE          = 3521;
SC_ERR_CANNOTPROVIDEREMIND              = 3522;
SC_ERR_CANNOMIRRORADDING                = 3523;
SC_ERR_CANNOMIRRORCHANGING              = 3524;
SC_ERR_CANNOMIRRORREMOVING              = 3525;
SC_ERR_CANNOMIRRORRESETING              = 3526;
SC_ERR_CANNOTREFLECTREMINDCHANGES       = 3527;
SC_ERR_CANNOTPROVIDESQLREFLECTION       = 3528;
SCH_ERR_CANNOTRESTOREFROMDATATBASE      = 3529;
SCH_ERR_CANNOTRESETTIMEKEEPERONSTART    = 3530;
SCH_ERR_CANNOTRESETMSMQONSTART          = 3531;

//SC_ERR_ = 10;

// ***********************************************
// **               poSQLAdaptor      4000-4499 **
// ***********************************************

//SQ_ERR_ = 10;
SQ_ERR_ERROR           = 4000;
SQ_ERR_CREATEDATASET   = SQ_ERR_ERROR + 0;
sSQ_ERR_CREATEDATASET  = 'Create dataset failed';
SQ_ERR_OPENDATASET     = SQ_ERR_ERROR + 1;
sSQ_ERR_OPENDATASET    = 'Open dataset failed';
SQ_ERR_EDITDATASET     = SQ_ERR_ERROR + 2;
sSQ_ERR_EDITDATASET    = 'Edit dataset failed';
SQ_ERR_EMPTYDATASET    = SQ_ERR_ERROR + 3;
sSQ_ERR_EMPTYDATASET   = 'Dataset is empty';
SQ_ERR_STATENOTFOUND   = SQ_ERR_ERROR + 4;
sSQ_ERR_STATENOTFOUND  = 'GameState not found';
SQ_ERR_INITFAILED      = SQ_ERR_ERROR + 5;
sSQ_ERR_INITFAILED     = 'Init failed';
SQ_ERR_CMDEXECUTEFAILED = SQ_ERR_ERROR + 6;
sSQ_ERR_CMDEXECUTEFAILED = 'AdoCommand.Execute failed';

// ***********************************************
// **               poFileManager     4500-4999 **
// ***********************************************

FM_ERR_CORRUPTREQUESTXML        = 4501;
FM_ERR_UNKNOWNACTION            = 4502;
FM_ERR_CORRUPTREQUESTARGUMENTS  = 4503;
FM_ERR_CANNOTADDXMLCHILDNODE    = 4601;
FM_ERR_SQLEXCEPTION             = 4602;
FM_ERR_FILENOTFOUND             = 4603;
FM_ERR_ENGINENOTFOUND           = 4604;

// ***********************************************
// **               poAccount         5000-5499 **
// ***********************************************

//AC_ERR_ = 10;
AC_ERR_ERROR                   = 5000;
AC_ERR_SQLCOMMANDERROR         = AC_ERR_ERROR + 0;
sAC_ERR_SQLCOMMANDERROR        = 'SqlAdaptor.ExecuteCommand failed';
AC_ERR_SQLEMPTYDATASET         = AC_ERR_ERROR + 1;
sAC_ERR_SQLEMPTYDATASET        = 'SqlAdaptor return empty data set';
AC_ERR_CREATENEWACCOUNTFAILED  = AC_ERR_ERROR + 2;
sAC_ERR_CREATENEWACCOUNTFAILED = 'Create new account failed';
AC_ERR_NOACCOUNT               = AC_ERR_ERROR + 3;
sAC_ERR_NOACCOUNT              = 'Account not found';
AC_ERR_WITHDRAWALFAILED        = AC_ERR_ERROR + 4;
sAC_ERR_WITHDRAWALFAILED       = 'Not enough money';
AC_ERR_GAMEPROCESSNOTFOUND     = AC_ERR_ERROR + 5;
sAC_ERR_GAMEPROCESSNOTFOUND    = 'GameProcess not found';
AC_ERR_NORESERVEDMONEY         = AC_ERR_ERROR + 6;
sAC_ERR_NORESERVEDMONEY        = 'No reserved money';
AC_ERR_NOTENOUGHRESERVEDMONEY  = AC_ERR_ERROR + 7;
sAC_ERR_NOTENOUGHRESERVEDMONEY = 'No reserved money';
AC_ERR_WRONGREQUEST            = AC_ERR_ERROR + 8;
sAC_ERR_WRONGREQUEST           = 'Wrong request';
AC_ERR_WRONGREQUESTFORMAT      = AC_ERR_ERROR + 9;
sAC_ERR_WRONGREQUESTFORMAT     = 'Wrong request format';
AC_ERR_WRONGREQUESTPARAM       = AC_ERR_ERROR + 10;
sAC_ERR_WRONGREQUESTPARAM      = 'Wrong parameter in request';
AC_ERR_NOTENOUGHMONEY          = AC_ERR_ERROR + 11;
sAC_ERR_NOTENOUGHMONEY         = 'Not enough money';
AC_ERR_DEPOSITNOTALLOWED       = AC_ERR_ERROR + 12;
sAC_ERR_DEPOSITNOTALLOWED      = 'Deposit not allowed';
AC_ERR_WRONGCREDITCARD         = AC_ERR_ERROR + 13;
sAC_ERR_WRONGCREDITCARD        = 'Wrong Credit Card';
AC_ERR_WRONGCREDITCARDTYPE     = AC_ERR_ERROR + 14;
sAC_ERR_WRONGCREDITCARDTYPE    = 'Unknown credit card type';
AC_ERR_WRONGRESPONSEFROMFIREPAY = AC_ERR_ERROR + 15;
sAC_ERR_WRONGRESPONSEFROMFIREPAY = 'Wrong response string from FirePay';
AC_ERR_FIREPAYTRANSACTIONFAILED  = AC_ERR_ERROR + 16;
sAC_ERR_FIREPAYTRANSACTIONFAILED = 'FirePay transaction failed';
//
AC_ERR_WITHDRAWALFAILED_NOTONLINE  = AC_ERR_ERROR + 17;
sAC_ERR_WITHDRAWALFAILED_NOTONLINE = 'User is not online now';
AC_ERR_WITHDRAWALFAILED_WRONGUSERID  = AC_ERR_ERROR + 18;
sAC_ERR_WITHDRAWALFAILED_WRONGUSERID = 'UserID not correspond userID From ClientSession';
AC_ERR_WITHDRAWALFAILED_CREDITCARDSNOTFOUND  = AC_ERR_ERROR + 19;
sAC_ERR_WITHDRAWALFAILED_CREDITCARDSNOTFOUND = 'Credit cards not found';
AC_ERR_WITHDRAWALFAILED_INSUFFICIENTFUNDS  = AC_ERR_ERROR + 20;
sAC_ERR_WITHDRAWALFAILED_INSUFFICIENTFUNDS = 'Insufficient funds';
AC_ERR_WITHDRAWALFAILED_USERACCOUNTNOTFOUND  = AC_ERR_ERROR + 21;
sAC_ERR_WITHDRAWALFAILED_USERACCOUNTNOTFOUND = 'User account not found';
AC_ERR_WITHDRAWALFAILED_AMOUNTISNULL  = AC_ERR_ERROR + 22;
sAC_ERR_WITHDRAWALFAILED_AMOUNTISNULL = 'Request amount parameter for withdrawal is 0';
AC_ERR_PROMOCARD_NOTFOUNT = AC_ERR_ERROR + 23;
sAC_ERR_PROMOCARD_NOTFOUNT = 'Promo card not found';
AC_ERR_PROMOCARD_USED = AC_ERR_ERROR + 24;
sAC_ERR_PROMOCARD_USED = 'Promo card already used';

// ***********************************************
// **               poUser            5500-5999 **
// ***********************************************

//US_ERR_ = 10;
US_ERR_ERROR                   = 5500;
US_ERR_SQLCOMMANDERROR         = US_ERR_ERROR + 0;
sUS_ERR_SQLCOMMANDERROR        = 'SqlAdaptor.ExecuteCommand failed';
US_ERR_SQLEMPTYDATASET         = US_ERR_ERROR + 1;
sUS_ERR_SQLEMPTYDATASET        = 'SqlAdaptor return empty data set';
US_ERR_LOGINFAILED             = US_ERR_ERROR + 2;
sUS_ERR_LOGINFAILED            = 'Login incorrect';
US_ERR_REGISTERNEWUSERFAILED   = US_ERR_ERROR + 3;
sUS_ERR_REGISTERNEWUSERFAILED  = 'RegisterNewUser failed';
US_ERR_VALIDATIONFAILED        = US_ERR_ERROR + 4;
sUS_ERR_VALIDATIONFAILED       = 'Wrong validation code';
US_ERR_WRONGLOGINNAME          = US_ERR_ERROR + 5;
sUS_ERR_WRONGLOGINNAME         = 'Wrong login name';
US_ERR_WRONGREQUEST            = US_ERR_ERROR + 6;
sUS_ERR_WRONGREQUEST           = 'Wrong request';
US_ERR_EMAILOBJERROR           = US_ERR_ERROR + 7;
sUS_ERR_EMAILOBJERROR          = 'Error creating Email object';
US_ERR_USERNOTFOUND            = US_ERR_ERROR + 8;
sUS_ERR_USERNOTFOUND           = 'User not found';
US_ERR_USERALREADYEXIST        = US_ERR_ERROR + 9;
sUS_ERR_USERALREADYEXIST       = 'User already exists';
US_ERR_WRONGREQUESTFORMAT      = US_ERR_ERROR + 10;
sUS_ERR_WRONGREQUESTFORMAT     = 'Wrong request format';
US_ERR_UNKNOWNACTION           = US_ERR_ERROR + 11;
sUS_ERR_UNKNOWNACTION          = 'Unknown action in request';
US_ERR_WRONGREQUESTPARAM       = US_ERR_ERROR + 12;
sUS_ERR_WRONGREQUESTPARAM      = 'Wrong parameter in request';
US_ERR_ALREADYLOGGED           = US_ERR_ERROR + 13;
sUS_ERR_ALREADYLOGGED          = 'Wrong parameter in request';
US_ERR_EMAILALREADYEXIST       = US_ERR_ERROR + 14;
sUS_ERR_EMAILALREADYEXIST      = 'Email already exists';
US_ERR_EMAILANDLOGINALREADYEXIST   = US_ERR_ERROR + 15;
sUS_ERR_EMAILANDLOGINALREADYEXIST  = 'Email and login already exists';
US_ERR_USERSTATUSISDISABLED    = US_ERR_ERROR + 16;
sUS_ERR_USERSTATUSISDISABLED   = 'Your login account is disabled';
US_ERR_USERSTATUSISDELETED     = US_ERR_ERROR + 17;
sUS_ERR_USERSTATUSISDELETED    = 'Your login account is deleted';
US_ERR_USERNOTENOUGHMONEY     = US_ERR_ERROR + 18;
sUS_ERR_USERNOTENOUGHMONEY    = 'Not enough money';

// ***********************************************
// **                 poChat          6000-6499 **
// ***********************************************

//CH_ERR_ = 10;

// ***********************************************
// **                 poEmail         6500-6999 **
// ***********************************************

//EM_ERR_ = 10;
EM_ERR_ERROR                    = 6500;
EM_ERR_SQLCOMMANDERROR          = EM_ERR_ERROR + 0;
sEM_ERR_SQLCOMMANDERROR         = 'SqlAdaptor.ExecuteCommand failed';
EM_ERR_NOEMAIL                  = EM_ERR_ERROR + 1;
aEM_ERR_NOEMAIL                 = 'Wrong UserID or Email absent';
EM_ERR_MSMQINFOCREATE           = EM_ERR_ERROR + 2;
sEM_ERR_MSMQINFOCREATE          = 'MSMQQueueInfo create failed';
EM_ERR_MSMQMESSAGECREATE        = EM_ERR_ERROR + 3;
sEM_ERR_MSMQMESSAGECREATE       = 'MSMQMessage create failed';
EM_ERR_TEMPLATENOTFOUND         = EM_ERR_ERROR + 4;
sEM_ERR_TEMPLATENOTFOUND        = 'Template not found';
EM_ERR_WRONGTEMPLATEFORMAT      = EM_ERR_ERROR + 5;
sEM_ERR_WRONGTEMPLATEFORMAT     = 'Wrong template format';
EM_ERR_WRONGREQUEST             = EM_ERR_ERROR + 6;
sEM_ERR_WRONGREQUEST            = 'Wrong request';
EM_ERR_CANNOTSEND               = EM_ERR_ERROR + 7;
sEM_ERR_CANNOTSEND              = 'Can not send email';

// ***********************************************
// **               poGameEngines     7000-7499 **
// ***********************************************




// ***********************************************
// **               poTornament       8000-9999 **
// ***********************************************
  AUTOSAVEINTERVAL = 10; // in minutes
  DELETEONFINISHINTERVAL = 24; // in hour
  WAITRESPONSEENDOFHAND = 15; // in minutes

// ERROR constants
  TS_ERR_COMMON                      = 8000;

  TS_ERR_CANTCREATEMSMQQUEUE         = 8001;
  TS_ERR_CANTOPENMSMQQUEUE           = 8002;
  TS_ERR_CANTRECEIVEMESSAGEFROMQUEUE = 8003;
  TS_ERR_CANTANALYSEMESSAGE          = 8004;

  TS_ERR_SQLERROR                    = 8005;
  TS_ERR_USERNOTFOUND                = 8006;
  TS_ERR_XMLPARCEERROR               = 8007;

  // error on register participant into DB
  TS_ERR_WROUNGTOURNAMENTID          = 8008;
  TS_ERR_USERALREADYREGISTERED       = 8009;
  TS_ERR_NOACCOUNT                   = 8010;
  TS_ERR_NOTENOUGHMONEY              = 8011;

  // error on register process into DB
  TS_ERR_ONEXECUTEINITENGINE         = 8012;
  // error in tournament logic
  TS_ERR_CANNOTSETSITTINGSTATUS      = 8013;
  TS_ERR_ONSENDCOMMAND               = 8014;
  TS_ERR_CANNOTSETRUNNINGSTATUS      = 8015;
  TS_ERR_CANNOTSETBREAKEND           = 8016;
  TS_ERR_CANNOTFOUNDUSER             = 8017;
  TS_ERR_CANNOTFOUNDPROCESS          = 8018;
  // error on timer event
  TS_ERR_NOTREGISTERATIONSTATUS      = 8019;
  //
  TS_ERR_MAXIMUMREGISTEREDALLOWED    = 8020;
  TS_ERR_PASSWORDISNOTVALID          = 8021;
  TS_ERR_ACCESSDENIEDBYINVITEDUSERS  = 8022;
  TS_ERR_REBUYISNOTALLOWED           = 8023;
  TS_ERR_MAXIMUMREBUYCOUNTED         = 8024;
  TS_ERR_WRONGATTRIBUTE              = 8025;
  TS_ERR_USERFINISHEDTOURNAY         = 8026;
  TS_ERR_USERHASFULLCHIPS            = 8027;
  // bots error
  TS_ERR_NOTENOGHBOTSFORREGISTRATION = 8200;
  //
  TO_ERR_WRONGGAMEENGINEID = 8201;
  TO_ERR_SQLCOMMANDERROR   = 8202;
  TO_ERR_GETDEFAULTPROPERTYFAILED = 8203;
  TO_ERR_WRONGXMLFILE      = 8204;
  TO_ERR_NOTMULTYTABLE     = 8205;
  TO_ERR_REGISTRATIONISMORETHENSTART = 8206;
// ***********************************************



// Constants used to retrievs information about GameProcessState
SQ_STATEFIELDNAME   = 'GameState';         // Game State Field name
SQ_STATETABLENAME   = 'GameProcessState';  // Table name

// Equivalent to (pdInput,pdOutput,pdInputOutput,pdReturnValue)
SQ_PARAMINPUT      = 1;
SQ_PARAMOUTPUT     = 2;
SQ_PARAMINOUT      = 3;
SQ_PARAMRETVAL     = 4;


implementation


begin
end.


