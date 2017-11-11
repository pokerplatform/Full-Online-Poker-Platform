unit uServerErrorMessages;

interface

Const


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
sUS_ERR_REGISTERNEWUSERFAILED  = 'Register new user failed';
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
sUS_ERR_USERALREADYEXIST       = 'The username you have chosen is already taken. Please choose another one';//'User already exists';
US_ERR_WRONGREQUESTFORMAT      = US_ERR_ERROR + 10;
sUS_ERR_WRONGREQUESTFORMAT     = 'Wrong request format';
US_ERR_UNKNOWNACTION           = US_ERR_ERROR + 11;
sUS_ERR_UNKNOWNACTION          = 'Unknown action in request';
US_ERR_WRONGREQUESTPARAM       = US_ERR_ERROR + 12;
sUS_ERR_WRONGREQUESTPARAM      = 'Wrong parameter in request';
US_ERR_ALREADYLOGGED           = US_ERR_ERROR + 13;
sUS_ERR_ALREADYLOGGED          = 'Wrong parameter in request';
US_ERR_EMAILALREADYEXIST       = US_ERR_ERROR + 14;
sUS_ERR_EMAILALREADYEXIST      = 'Email address already exists. Please enter a different one';
US_ERR_EMAILANDLOGINALREADYEXIST   = US_ERR_ERROR + 15;
sUS_ERR_EMAILANDLOGINALREADYEXIST  = 'Email or login already exists';
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

  TO_ERR_ERROR                    = 8000;
  TO_ERR_CREATENEWFAILED          = TO_ERR_ERROR + 0;
  sTO_ERR_CREATENEWFAILED         = 'CreateNewTournament failed';
  TO_ERR_CREATEOBJECTERROR        = TO_ERR_ERROR + 1;
  sTO_ERR_CREATEOBJECTERROR       = 'CreateOleObject failed';
  TO_ERR_GETDEFAULTPROPERTYFAILED = TO_ERR_ERROR + 2;
  sTO_ERR_GETDEFAULTPROPERTYFAILED = 'GetDefaultProperty for GameProcess failed';
  TO_ERR_WROUNGTOURNAMENTID       = TO_ERR_ERROR + 3;
  sTO_ERR_WROUNGTOURNAMENTID      = 'Wrong TournamnetID';
  TO_ERR_WRONGSTATE               = TO_ERR_ERROR + 4;
  sTO_ERR_WRONGSTATE              = 'Wrong state';
  TO_ERR_WRONGXMLFILE             = TO_ERR_ERROR + 5;
  sTO_ERR_WRONGXMLFILE            = 'Wrong XML file';
  TO_ERR_UNKNOWNACTION            = TO_ERR_ERROR + 6;
  sTO_ERR_UNKNOWNACTION           = 'Unknown action';
  TO_ERR_WRONGREQUESTPARAM        = TO_ERR_ERROR + 7;
  sTO_ERR_WRONGREQUESTPARAM       = 'Wrong request parameter';
  TO_ERR_SQLCOMMANDERROR          = TO_ERR_ERROR + 8;
  sTO_ERR_SQLCOMMANDERROR         = 'SqlAdaptor.ExecuteCommand failed';
  TO_ERR_USERALREADYREGISTERED    = TO_ERR_ERROR + 9;
  sTO_ERR_USERALREADYREGISTERED   = 'User already registerd';
  TO_ERR_NOACCOUNT                = TO_ERR_ERROR + 10;
  sTO_ERR_NOACCOUNT               = 'User has not account';
  TO_ERR_NOTENOUGHMONEY           = TO_ERR_ERROR + 11;
  sTO_ERR_NOTENOUGHMONEY          = 'Not enogh money';
  TO_ERR_NOTENOUGHENTRANTS        = TO_ERR_ERROR + 12;
  sTO_ERR_NOTENOUGHENTRANTS       = 'Entrants for tournamnet < 2';
  TO_ERR_APIFAILURE               = TO_ERR_ERROR + 13;
  sTO_ERR_APIFAILURE              = 'Api failure';
  TO_ERR_USERTOGAMEPROCESSFAILURE = TO_ERR_ERROR + 14;
  sTO_ERR_USERTOGAMEPROCESSFAILURE = 'Can not assosiate User with GameProcess';
  TO_ERR_NOTOURNAMENTS            = TO_ERR_ERROR + 15;
  sTO_ERR_NOTOURNAMENTS           = 'No tournaments found';
  TO_ERR_WRONGGAMEENGINEID        = TO_ERR_ERROR + 16;
  sTO_ERR_WRONGGAMEENGINEID       = 'Wrong GameEngine ID';
  TO_ERR_NOUSERFORRESIT           = TO_ERR_ERROR + 17;
  sTO_ERR_NOUSERFORRESIT          = 'No user available for resiting';
  TO_ERR_NOPLACEFORRESIT          = TO_ERR_ERROR + 18;
  sTO_ERR_NOPLACEFORRESIT         = 'No place available for resiting';
  TO_ERR_TOURNAMENTPASSWORD       = TO_ERR_ERROR + 21;
  sTO_ERR_TOURNAMENTPASSWORD      = 'Access denied. Please check password!';
  TO_ERR_TOURNAMENTBYUSERID       = TO_ERR_ERROR + 22;
  sTO_ERR_TOURNAMENTBYUSERID      = 'Access denied. You are not allowed to register in this tournament.';

  TO_ERR_REBUYISNOTALLOWED        = TO_ERR_ERROR + 23;
  sTO_ERR_REBUYISNOTALLOWED       = 'Rebuy is not allowed.';
  TO_ERR_MAXIMUMREBUYCOUNTED      = TO_ERR_ERROR + 24;
  sTO_ERR_MAXIMUMREBUYCOUNTED     = 'Rebuy count is over.';
  TO_ERR_WRONGATTRIBUT            = TO_ERR_ERROR + 25;
  sTO_ERR_WRONGATTRIBUT           = 'Wrong atribute.';
  TO_ERR_USERFINISHEDTOURNAY      = TO_ERR_ERROR + 26;
  sTO_ERR_USERFINISHEDTOURNAY     = 'You finished tournament.';
  TO_ERR_USERNOTALLOWEDFORREBUY   = TO_ERR_ERROR + 27;
  sTO_ERR_USERNOTALLOWEDFORREBUY  = 'You are not allowed to rebuy.';

function GetServerErrorMessage(ErrorCode: Integer): String;

implementation

uses
  SysUtils;

function GetServerErrorMessage(ErrorCode: Integer): String;
begin

  case ErrorCode of

    // Account
    AC_ERR_CREATENEWACCOUNTFAILED    : Result := sAC_ERR_CREATENEWACCOUNTFAILED;
    AC_ERR_NOACCOUNT                 : Result := sAC_ERR_NOACCOUNT;
    AC_ERR_WITHDRAWALFAILED          : Result := sAC_ERR_WITHDRAWALFAILED;
    AC_ERR_NORESERVEDMONEY           : Result := sAC_ERR_NORESERVEDMONEY;
    AC_ERR_NOTENOUGHRESERVEDMONEY    : Result := sAC_ERR_NOTENOUGHRESERVEDMONEY;
    AC_ERR_NOTENOUGHMONEY            : Result := sAC_ERR_NOTENOUGHMONEY;
    AC_ERR_DEPOSITNOTALLOWED         : Result := sAC_ERR_DEPOSITNOTALLOWED;
    AC_ERR_WRONGCREDITCARD           : Result := sAC_ERR_WRONGCREDITCARD;
    AC_ERR_WRONGCREDITCARDTYPE       : Result := sAC_ERR_WRONGCREDITCARDTYPE;
    AC_ERR_WRONGRESPONSEFROMFIREPAY  : Result := sAC_ERR_WRONGRESPONSEFROMFIREPAY;
    AC_ERR_FIREPAYTRANSACTIONFAILED  : Result := sAC_ERR_FIREPAYTRANSACTIONFAILED;

    // User
    US_ERR_LOGINFAILED             : Result := sUS_ERR_LOGINFAILED;
    US_ERR_REGISTERNEWUSERFAILED   : Result := sUS_ERR_REGISTERNEWUSERFAILED;
    US_ERR_VALIDATIONFAILED        : Result := sUS_ERR_VALIDATIONFAILED;
    US_ERR_WRONGLOGINNAME          : Result := sUS_ERR_WRONGLOGINNAME;
    US_ERR_WRONGREQUEST            : Result := sUS_ERR_WRONGREQUEST;
    US_ERR_EMAILOBJERROR           : Result := sUS_ERR_EMAILOBJERROR;
    US_ERR_USERNOTFOUND            : Result := sUS_ERR_USERNOTFOUND;
    US_ERR_USERALREADYEXIST        : Result := sUS_ERR_USERALREADYEXIST;
    US_ERR_EMAILALREADYEXIST       : Result := sUS_ERR_EMAILALREADYEXIST; 
    US_ERR_WRONGREQUESTFORMAT      : Result := sUS_ERR_WRONGREQUESTFORMAT;
    US_ERR_ALREADYLOGGED           : Result := sUS_ERR_ALREADYLOGGED;
    US_ERR_USERSTATUSISDISABLED    : Result := sUS_ERR_USERSTATUSISDISABLED;
    US_ERR_USERSTATUSISDELETED     : Result := sUS_ERR_USERSTATUSISDELETED;
    US_ERR_USERNOTENOUGHMONEY      : Result := sUS_ERR_USERNOTENOUGHMONEY; 

    // Tournament
    TO_ERR_USERALREADYREGISTERED    : Result := sTO_ERR_USERALREADYREGISTERED;
    TO_ERR_NOACCOUNT                : Result := sTO_ERR_NOACCOUNT;
    TO_ERR_NOTENOUGHMONEY           : Result := sTO_ERR_NOTENOUGHMONEY;
    TO_ERR_NOTENOUGHENTRANTS        : Result := sTO_ERR_NOTENOUGHENTRANTS;
    TO_ERR_NOTOURNAMENTS            : Result := sTO_ERR_NOTOURNAMENTS;
    TO_ERR_WRONGGAMEENGINEID        : Result := sTO_ERR_NOUSERFORRESIT;
    TO_ERR_NOPLACEFORRESIT          : Result := sTO_ERR_NOPLACEFORRESIT;
    TO_ERR_TOURNAMENTPASSWORD       : Result := sTO_ERR_TOURNAMENTPASSWORD;
    TO_ERR_TOURNAMENTBYUSERID       : Result := sTO_ERR_TOURNAMENTBYUSERID;
    TO_ERR_REBUYISNOTALLOWED        : Result := sTO_ERR_REBUYISNOTALLOWED;
    TO_ERR_MAXIMUMREBUYCOUNTED      : Result := sTO_ERR_MAXIMUMREBUYCOUNTED;
    TO_ERR_WRONGATTRIBUT            : Result := sTO_ERR_WRONGATTRIBUT;
    TO_ERR_USERFINISHEDTOURNAY      : Result := sTO_ERR_USERFINISHEDTOURNAY;
    TO_ERR_USERNOTALLOWEDFORREBUY   : Result := sTO_ERR_USERNOTALLOWEDFORREBUY;
  else
    Result := 'Error #' + inttostr(ErrorCode) + '. Please contact customer support.';
  end;
end;

begin
end.


