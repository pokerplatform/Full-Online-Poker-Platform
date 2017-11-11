unit uUser;

interface

uses
  xmldom, XMLIntf, msxmldom, XMLDoc, SysUtils
//PO
  , uLogger
  ;

const

  VALIDATIONEMAIL       = 1;
  ETemplQOMPID          = 2;
  ETemplReferalID       = 3;
  ETemplBonusDepositID  = 4;

type
  TUser = class
  private
    procedure Log(MethodName, LogData: String; LogType: TLogType);
    //
    function Login(SessionID: Integer; const LoginUserName, Password: String; out UserID: Integer; var IsEmailValid : integer): integer;
    procedure NotifyGameAdaptor(SessionID: integer);
    function HashEmail(s : string) : integer;

  public
    function ProcessAction(ActionsNode: IXMLNode): Integer;

    function SendUserProfile(const UserID: Integer): Integer;
    function RegisterNewUser(SessionID: Integer; const LoginUserName: String;
      const Password: String; const FirstName: String; const LastName: String;
      const Email: String; const Location: String; SexID: Integer; ShowLocation: Integer;
      AffiliateID: Integer; out UserID: Integer): Integer;
    function LoginUser(SessionID: Integer; const LoginUserName: String;
      const Password: String; out UserID: Integer): Integer;
    function LogoutUser(SessionID: Integer): Integer;
    function GetProfile(SessionID: Integer; UserID: Integer): Integer;
    function UpdateProfile(SessionID: Integer; UserID: Integer; const FirstName: String;
      const LastName: String; EmailAlerts: Integer; BuddyAlerts: Integer;
      const Location: String; ShowLocation: Integer; SexID: Integer;
      AvatarID: Integer): Integer;
    function TransferMoneyTo(SessionId: Integer; UserId, Amount: Integer; TransferFrom, TransferTo: String): Integer;
    function GetLocation(SessionId,UserId: Integer;PlayerName: String): Integer;
    function ChangePassword(SessionID: Integer; UserID: Integer;
      const NewPassword: String; const OldPassword: String): Integer;
    function ForgotPassword(SessionID: Integer; const LoginUserName: String;
      const FirstName: String; const LastName: String;
      const Email: String; const Location: String; SexID, EmailDirection: Integer): Integer;
    function SendValidationEmail(SessionID: Integer; UserID: Integer;
      const Email: String; JunkMail: Integer): Integer;
    function Validate(SessionID: Integer; UserID: Integer;
      ValidationCode: Integer): Integer;
    function UserStatistics(SessionID: Integer; UserID: Integer;
      out LastLoginTime: String; out TotalLoggedIn: Int64): Integer;
    function ChangeStatus(SessionID: Integer; UserID: Integer;
      UserStatusID: Integer): Integer;

  end;

implementation

uses
  StrUtils
//PO
  , uXMLConstants
  , uErrorConstants
  , uCommonDataModule
  , uSQLAdapter
  , uEmail
  , DB;

{ TUser }

function TUser.ProcessAction(ActionsNode: IXMLNode): Integer;
var
  SessionID     : Integer;
  Node          : IXMLNode;
  Cnt           : Integer;
  ActionName    : string;
  LastLoginTime : String;
  TotalLoggedIn : int64;
  UserID        : integer;
  Response      : String;
  nEmailDirection: Integer;
begin
  Log('ProcessAction', 'Entry; Params: ActionsNode=' + ActionsNode.XML, ltCall);

  Node := ActionsNode.ChildNodes[0];
  SessionID := StrToIntDef(Node.Attributes[PO_ATTRSESSIONID], 0);
  // cycle through file
  for Cnt:=0 to ActionsNode.ChildNodes.Count-1 do begin
    try
      Node       := ActionsNode.ChildNodes[Cnt];
      ActionName := Lowercase(Node.NodeName);
      if ActionName = UO_LoginUser  then
        LoginUser(SessionID,
          Node.Attributes['loginname'], Node.Attributes['password'], UserID
        )
      else if ActionName = UO_LogoutUser then
        LogoutUser(SessionID)
      else if ActionName = uo_RegisterNewUser then
        RegisterNewUser(SessionID,
          Node.Attributes['loginname'],
            Node.Attributes['password'],
            Node.Attributes['firstname'],
            Node.Attributes['lastname'],
            Node.Attributes['email'],
            Node.Attributes['location'],
            StrToInt(Node.Attributes['sexid']),
            StrToInt(Node.Attributes['showlocation']),
            StrToIntDef(Node.Attributes['affiliateid'], 1), //by default it is Poker AffiliateID = 1
            UserID
        )
      else if ActionName = uo_GetProfile then
        GetProfile(SessionID, StrToInt(Node.Attributes['userid']))
      else if ActionName = uo_UpdateProfile then
        UpdateProfile(
          SessionID,
          StrToInt(Node.Attributes['userid']),
          Node.Attributes['firstname'],
          Node.Attributes['lastname'],
          0, 0,
//          StrToInt(Node.Attributes['emailalerts']),
//          StrToInt(Node.Attributes['buddyalerts']),
          Node.Attributes['location'],
          StrToInt(Node.Attributes['showlocation']),
          StrToInt(Node.Attributes['sexid']),
          StrToInt(Node.Attributes['avatarid'])
        )
      else if ActionName = UO_TRASFERMONEYTO then
        TransferMoneyTo(
           SessionID,
           StrToInt(Node.Attributes['userid']),
           StrToInt(Node.Attributes['amount']),
           Node.Attributes['transferfrom'],
           Node.Attributes['transferto']
        )
      else if ActionName = UO_FINDPLAYER then
        GetLocation(
           SessionID,
           StrToInt(Node.Attributes['userid']),
           Node.Attributes['playername']
        )
      else if ActionName = uo_ChangePassword then
        ChangePassword(SessionID,
          StrToInt(Node.Attributes['userid']),
          Node.Attributes['newpassword'],
          Node.Attributes['oldpassword']
        )
      else if ActionName = uo_UserStatistics then
        UserStatistics(SessionID,
          StrToInt(Node.Attributes['userid']),
          LastLoginTime,TotalLoggedIn
        )
      else if ActionName = uo_ChangeStatus then
        ChangeStatus(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['statusid'])
        )
      else if ActionName = uo_SendValidationMail then
        SendValidationEmail(SessionID,
          Node.Attributes['userid'],
          Node.Attributes['email'],
          1
        )
        // StrToInt(Node.Attributes['junkmail']))
      else if ActionName = uo_Validate then
        Validate(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['validationcode'])
        )
      else if ActionName = uo_ForgotPassword then begin
        nEmailDirection := 0; // to admin by defoult
        if Node.HasAttribute('emaildirection') then
          nEmailDirection := StrToIntDef(Node.Attributes['emaildirection'], 0);
        ForgotPassword(SessionID,
          Node.Attributes['loginname'],
          Node.Attributes['firstname'],
          Node.Attributes['lastname'],
          Node.Attributes['email'],
          Node.Attributes['location'],
          StrToInt(Node.Attributes['sexid']),
          nEmailDirection
        )
      end
      else begin
        // requested action not found
        Response   :=
          '<object name="user">' +
            '<uoprocessaction ' +
              'result="' + IntToStr(US_ERR_UNKNOWNACTION)+ '" ' +
              'actionname="' + ActionName +
            '"/>' +
          '</object>';
        if SessionID > 0 then
          CommonDataModule.NotifyUser(SessionID, Response);
      end;
    except
      on e : Exception do begin
        // wrong or missing parameter cause exception
        Log('ProcessAction', '[EXCEPTION]: ' + e.Message +
          '; Params: Data - ' + ActionsNode.XML,
          ltException
         );

         Result := US_ERR_ERROR;
         Response :=
           '<object name="user">' +
             '<uoaction result="'+IntToStr(US_ERR_WRONGREQUESTPARAM)+ '"/>' +
           '</object>';
        if SessionID > 0 then
           CommonDataModule.NotifyUser(SessionID,Response);
         Exit;
      end;
    end;
  end;

  Result := 0;
end;

function TUser.ChangePassword(SessionID, UserID: Integer;
  const NewPassword, OldPassword: String): Integer;
var
  SqlAdaptor      : TSQLAdapter;
  Response        : String;
begin
  Log('ChangePassword', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', NewPassword = ' + NewPAssword +
    ', OldPassword = ' + OldPassword,
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // stored procedure usrChangePassword
    SqlAdaptor.SetProcName('usrChangePassword');
    SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
    SqlAdaptor.AddParInt('UserID',UserID,ptInput);
    SqlAdaptor.AddParWString('NewPassword',NewPassword,ptInput);
    SqlAdaptor.AddParWString('OldPassword',OldPassword,ptInput);

    SqlAdaptor.ExecuteCommand;

    Result := SqlAdaptor.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('ChangePassword', '[EXCEPTION] On exec usrChangePassword: ' + e.Message + '; Params:' +
        ' SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID) +
        ', NewPassword = ' + NewPAssword +
        ', OldPassword = ' + OldPassword,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uochangepassword result="'+IntToStr(Result)+'"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

  Response   := '<object name="user"><uochangepassword result="'+IntToStr(Result)+'"/></object>';

  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  Result := 0;

  Log('ChangePassword', 'Exit; Result = ' + IntToStr(Result) + '; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', NewPassword = ' + NewPAssword +
    ', OldPassword = ' + OldPassword,
    ltCall
  );
end;

function TUser.ChangeStatus(SessionID, UserID,
  UserStatusID: Integer): Integer;
var
  SqlAdaptor : TSQLAdapter;
  Response   : String;
begin
  Log('ChangeStatus', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', UserStatus = ' + IntToStr(UserStatusID),
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    //  stored procedure usrChangeStatus
    SqlAdaptor.SetProcName('usrChangeStatus');
    SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
    SqlAdaptor.AddParInt('UserID',UserID,ptInput);
    SqlAdaptor.AddParInt('UserStatusID',UserStatusID,ptInput);

    SqlAdaptor.ExecuteCommand;

    Result := SqlAdaptor.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('ChangeStatus', '[EXCEPTION] On exec usrChangeStatus:' + e.Message + '; Params:' +
        ' SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID) +
        ', UserStatus = ' + IntToStr(UserStatusID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uochangestatus result="'+IntToStr(Result)+'"/></object>';

      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
  Response   := '<object name="user"><uochangestatus result="'+IntToStr(Result)+'"/></object>';

  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  Log('ChangeStatus', 'Exit; Result=' + IntToStr(Result) + '; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', UserStatus = ' + IntToStr(UserStatusID),
    ltCall
  );
end;

function TUser.ForgotPassword(SessionID: Integer;
  const LoginUserName, FirstName, LastName, Email, Location: String;
  SexID, EmailDirection: Integer): Integer;
var
  FSql        : TSQLAdapter;
  Response    : String;
  Data        : String;
  Password    : string;
  EmailObj    : TEmail;
begin
  Log('ForgotPassword', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', LoginName = ' + LoginUserName +
    ', FirstName = ' + FirstName +
    ', LastName = ' + LastName +
    ', Email = ' + Email +
    ', Location = ' + Location +
    ', SexID = ' + IntToStr(SexID) ,
    ltCall
  );

// stored procedure usrForgotPassword
  if (EmailDirection > 0) then begin
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      FSql.SetProcName('usrForgotPassword');
      FSql.AddParInt('RETURN_VALUE', 0, ptResult);
      FSql.AddParString('UserLoginName', LoginUserName, ptInput);
      FSql.AddParString('Password', Password, ptOutput);

      FSql.ExecuteCommand;

      Result   := FSql.GetParam('RETURN_VALUE');
      Password := FSql.GetParam('Password');

    except on e : Exception do
      begin
        Log('ForgotPassword', '[EXCEPTION] On Execute usrForgotPassword: ' +
          e.Message + '; Params: UserLoginName=' + LoginUserName, ltException);

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Result     := US_ERR_SQLCOMMANDERROR;
        Response   := '<object name="user"><uoforgotpassword result="'+IntToStr(Result)+
                        '"/></object>';
        CommonDataModule.NotifyUser(SessionID,Response);
        Exit;
      end;
    end;

    if Result <> 0 then begin
      Result := US_ERR_USERNOTFOUND;
      Response   := '<object name="user"><uoforgotpassword result="' + IntToStr(Result) +
                        '"/></object>';
      CommonDataModule.NotifyUser(SessionID, Response);
      Exit;
    end;
  end; // endif with EMailDirection > 0

  Data :=
    'I forgot password. Please send it to my email address.' + '<br>' +
    'My personal info is: ' + '<br>' +
    'LoginName - ' + LoginUserName + '<br>' +
    'FirstName - ' + FirstName + '<br>' +
    'LastName  - ' + LastName + '<br>' +
    'Email     - ' + Email  +  '<br>' +
    'Location  - ' + Location + '<br>' +
    'SexID     - ' + IntToStr(SexId) + '<br>' + '<br>';

  if (EmailDirection > 0) then Data := Data +
    'Password  - ' + Password + '<br>';

  Data := Data + '<br>' +
    'Best regards!' + '<br>' ;

  // Send user email to admin with user data
  EmailObj := CommonDataModule.ObjectPool.GetEmail;
  try
    // EMAIL   - user email address
    // CODE    - validation code
    // SUPPORT - email address for support

    if (EmailDirection > 0) then
      Result   := EmailObj.SendUserEmail(SessionID, 0, 'Forgot Password', Data)
    else
      Result   := EmailObj.SendAdminEmail(SessionID, 0, 'Forgot Password', Data);
  except
    on e : Exception do begin
      Log('ForgotPassword', '[EXCEPTION] On Execute EMail: ' +
        e.Message + '; Params:' + Data, ltException);

      CommonDataModule.ObjectPool.FreeEmail(EmailObj);
      Result     := US_ERR_EMAILOBJERROR;
      Response   := '<object name="user"><uoforgotpassword result="'+IntToStr(Result)+'"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response);

      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeEmail(EmailObj);

  Response   := '<object name="user"><uoforgotpassword result="'+IntToStr(Result)+
                '"/></object>';
  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response);

  Result := 0;

  Log('ForgotPassword', 'Exit; Rasult=' + IntToStr(Result) + '; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', LoginName = ' + LoginUserName +
    ', FirstName = ' + FirstName +
    ', LastName = ' + LastName +
    ', Email = ' + Email +
    ', Location = ' + Location +
    ', SexID = ' + IntToStr(SexID) ,
    ltCall
  );
end;

function TUser.GetProfile(SessionID, UserID: Integer): Integer;
var
  SqlAdaptor: TSQLAdapter;
  Response, sSql  : String;
begin
  Log('GetProfile', 'Entry; Params:' +
    ' ClientSessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID),
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  sSql := 'usrGetUserProfileXML ' + IntToStr(UserID);
  try
    try
      Response := SqlAdaptor.ExecuteForXML(sSql);
    except
      on e: Exception do begin
        Log('GetProfile', '[EXCEPTION] on exec [' + sSql +']: ' + e.Message +
          ';Params: UserID = ' + IntToStr(UserID),
          ltException
        );

        Result   := US_ERR_SQLCOMMANDERROR;
        Response := '<object name="user"><uogetprofile result="'+IntToStr(Result)+'"/></object>';

        if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
        else CommonDataModule.NotifyUserByID(UserID,Response);

        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
  end;

  if Response = '' then begin
    Log('GetProfile',
      '[WARNING]: User not found UserID=' + IntToStr(UserID),
      ltError);

    Result   := US_ERR_USERNOTFOUND;
    Response := '<object name="user"><uogetprofile result="'+IntToStr(Result)+'"/></object>';
  end;
  Response := '<object name="user">' + Response + '</object>';

  Result := 0;
  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  Log('GetProfile', 'Exit; Result=' + IntToStr(Result), ltCall);
end;

function TUser.LoginUser(SessionID: Integer; const LoginUserName,
  Password: String; out UserID: Integer): Integer;
var
  Response        : String;
  IsEmailValid    : integer;
begin
  Log('LoginUser', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', LoginName = ' + LoginUserName +
    ', Password = ' + Password,
    ltCall
  );

  Login(SessionID,LoginUserName,Password,UserID,IsEmailValid);
  case UserID of
     0: Result := US_ERR_LOGINFAILED;
    -1: Result := US_ERR_ALREADYLOGGED;
    -2: Result := US_ERR_USERSTATUSISDISABLED;
    -3: Result := US_ERR_USERSTATUSISDELETED;
  else
    Result := 0;
  end;
  if Result <> 0 then UserID := 0;

  Response   :=
    '<object name="user">' +
      '<uologin result="' + IntToStr(Result) + '" ' +
        'userid="' + IntToStr(UserID) + '" ' +
        'emailvalidated="' + IntToStr(IsEmailValid) + '"' +
      '/>' +
    '</object>';
  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  // notify GameAdaptor about login
  if Result = 0 then NotifyGameAdaptor(SessionID);

  Log('LoginUser','Exit; Result = ' + IntToStr(Result), ltCall);
end;

function TUser.LogoutUser(SessionID: Integer): Integer;
var
  SqlAdaptor      : TSQLAdapter;
begin
  Log('LogoutUser', 'Entry; Params: SessionID = ' + IntToStr(SessionID), ltCall);

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;

  try
  // stored procedure usrLogoutUser
    SqlAdaptor.SetProcName('usrLogoutUser');
    SqlAdaptor.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
    SqlAdaptor.AddParInt('ClientSessionID',SessionID,ptInput);

    SqlAdaptor.ExecuteCommand;

  except
    on e : Exception do begin
      Log('LogoutUser', '[EXCEPTION] On exec usrLogoutUser: ' + e.Message +
        '; Params: SessionID = ' + IntToStr(SessionID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

      Result     := US_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  end;

  Result     := 0;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

end;

function TUser.RegisterNewUser(SessionID: Integer;
  const LoginUserName, Password, FirstName, LastName, Email,
  Location: String; SexID, ShowLocation, AffiliateID: Integer;
  out UserID: Integer): Integer;
var
    SqlAdaptor      : TSQLAdapter;
    Response        : String;
    IsEmailValid        : integer;
begin
  Log('RegisterNewUser', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID)+
    ' ,LoginUserName = ' + LoginUserName +', Password = ' + Password +
    ' ,FirstName = ' + FirstName + ', LastName = ' + LastName +
    ' ,Email = ' + Email + ' ,Locatiob = ' + Location +
    ' ,SexID = ' + IntToStr(SexID) +
    ' ,ShowLocation = '+ IntToStr(ShowLocation),
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // Stored procedure usrRegisterNewUser
    SqlAdaptor.SetProcName('usrRegisterNewUser');
    SqlAdaptor.AddParInt('RETURN_VALUE',0, ptResult);
    SqlAdaptor.AddParWString('UserLoginName',LoginUserName,ptInput);
    SqlAdaptor.AddParWString('Password',Password,ptInput);
    SqlAdaptor.AddParWString('FirstName',FirstName,ptInput);
    SqlAdaptor.AddParWString('LastName',LastName,ptInput);
    SqlAdaptor.AddParString('Email',Email,ptInput);
    SqlAdaptor.AddParWString('Location',Location,ptInput);
    SqlAdaptor.AddParInt('SexID',SexID,ptInput);
    SqlAdaptor.AddParInt('AffiliateID',AffiliateID,ptInput);
    SqlAdaptor.AddParInt('ShowLoc',ShowLocation,ptInput);

    SqlAdaptor.ExecuteCommand();
    // returns UserID (if > 0 then Ok else failed)
    UserID := SqlAdaptor.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('RegisterNewUser', '[EXCEPTION] On execute usrRegisterNewUser: ' + e.Message +
        '; Params: UserLoginName = ' + LoginUserName +
        ', Password = ' + Password + ', FirstName = ' + FirstName +
        ', LastName = ' + LastName + ', Email = ' + Email +
        ', Location = ' + Location + ', SexID = ' + IntToStr(SexID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uoregister result="'+IntToStr(Result)+'"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

      Exit;
    end;
  end;

  if UserID > 0 then
    Result := 0
  else
  begin
    Result := US_ERR_USERALREADYEXIST;
    if UserID = -2 then
      Result := US_ERR_EMAILALREADYEXIST;

    Response   := '<object name="user"><uoregister result="'+IntToStr(Result)+'" userid="'+IntToStr(UserID)+'" emailvalidated="'+IntToStr(IsEmailValid)+'"/></object>';
    if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
    else CommonDataModule.NotifyUserByID(UserID,Response);

    Result := US_ERR_REGISTERNEWUSERFAILED;
    CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
    Exit;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

  Log('RegisterNewUser', 'Execute usrRegisterNewUser result=' + IntToStr(Result), ltCall);

  // login new user
  Result := Login(SessionID,LoginUserName,Password,UserID,IsEmailValid);

  Response   := '<object name="user"><uoregister result="'+IntToStr(Result)+'" userid="'+IntToStr(UserID)+'" emailvalidated="'+IntToStr(IsEmailValid)+'"/></object>';
  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  // if success notify GameAdaptor about login
  if Result = 0 then NotifyGameAdaptor(SessionID);

  // Disabled for current versions
  //SendValidationEmail(SessionID, UserID, Email, 1);

  Log('RegisterNewUser', 'Exit; Result = ' + IntToStr(Result), ltCall);
end;

function TUser.SendValidationEmail(SessionID, UserID: Integer;
  const Email: String; JunkMail: Integer): Integer;
var
    EmailObj    : TEmail;
    SqlAdaptor  : TSQLAdapter;
    Response    : String;
    Data        : String;

  function UserIDToString(curUserID: Integer): String;
  var
    Loop: Integer;
    strUserID: String;
  begin
    Result := '';
    Randomize;
    for Loop := 1 to 12 do
      Result := Result + chr(65 + random(20));
    strUserID := inttostr(curUserID);
    for Loop := 1 to length(strUserID) do
      Result := Result + chr(65 + strtointdef(strUserID[Loop], 0));
  end;
  
begin
  Log('SendValidationEmail', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', Email = ' + Email  +
    ', JankMail = ' + IntToStr(JunkMail),
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // Update user email
    SqlAdaptor.SetProcName('usrUpdateEmail');
    SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
    SqlAdaptor.AddParInt('UserID',UserID,ptInput);
    SqlAdaptor.AddParString('Email',Email,ptInput);
    SqlAdaptor.AddParInt('JunkMail',JunkMail,ptInput);

    SqlAdaptor.ExecuteCommand;

    Result := SqlAdaptor.GetParam('RETURN_VALUE');

  except
    on e: Exception do begin
      Log('SendValidationEmail', '[EXCEPTION] On exec usrUpdateEmail: ' + e.Message + '; Params:' +
        ' SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID) +
        ', Email = ' + Email  +
        ', JankMail = ' + IntToStr(JunkMail),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uochangeemail result="'+IntToStr(Result)+'"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

      Exit;
    end;
  end;

  Response   := '<object name="user"><uochangeemail result="'+IntToStr(Result)+'"/></object>';
  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

  EmailObj := CommonDataModule.ObjectPool.GetEmail;
  // Send user email with validation code
  try
    // EMAIL   - user email address
    // CODE    - validation code
    // SUPPORT - email address for support
    Data     :=
      'EMAIL=' + Email +
      ',CODE=' + IntToStr(HashEmail(Email)) +
      ',SUPPORT=' + EmailObj.GetEmailFromAddress(UserID) +
      ',DATA=' + UserIDToString(UserID);
    Result   := EmailObj.SendCustomEmail(SessionID,UserID,VALIDATIONEMAIL,Data);
  except
    on e : Exception do begin
      Log('SendValidationEmail', '[EXCEPTION]: On execute EmailObj.SendCustomEmail:' + e.Message + '; Params:' +
        ' SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID) +
        ', Email = ' + Email  +
        ', JankMail = ' + IntToStr(JunkMail),
        ltException
      );

      CommonDataModule.ObjectPool.FreeEmail(EmailObj);
      Result     := US_ERR_EMAILOBJERROR;
      Response   := '<object name="user"><uochangeemail result="'+IntToStr(Result)+'"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeEmail(EmailObj);

  Log('SendValidationEmail', 'Exit; Result=' + IntToStr(Result) + '; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', Email = ' + Email  +
    ', JankMail = ' + IntToStr(JunkMail),
    ltCall
  );
end;

function TUser.UpdateProfile(SessionID, UserID: Integer;
  const FirstName, LastName: String; EmailAlerts, BuddyAlerts: Integer;
  const Location: String; ShowLocation, SexID, AvatarID: Integer): Integer;
var
  SqlAdaptor      : TSQLAdapter;
  Response        : String;
begin

  Log('UpdateProfile', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID),
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // stored procedure usrUpdateUserProfile
    SqlAdaptor.SetProcName('usrUpdateUserProfile');
    SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
    SqlAdaptor.AddParInt('UserID',UserID,ptInput);
//        SqlAdaptor.AddParWString('UserLoginName',LoginUserName,ptInput);
    SqlAdaptor.AddParWString('FirstName',FirstName,ptInput);
    SqlAdaptor.AddParWString('LastName',LastName,ptInput);
    SqlAdaptor.AddParInt('EmailAlerts',EmailAlerts,ptInput);
    SqlAdaptor.AddParInt('BuddyAlerts',BuddyAlerts,ptInput);
//        SqlAdaptor.AddParString('Email',Email,ptInput);
    SqlAdaptor.AddParWString('Location',Location,ptInput);
    SqlAdaptor.AddParInt('SexID',SexID,ptInput);
    SqlAdaptor.AddParInt('AvatarID',AvatarID,ptInput);
    SqlAdaptor.AddParInt('ShowLocation',ShowLocation,ptInput);

    SqlAdaptor.ExecuteCommand;

    Result := SqlAdaptor.GetParam('RETURN_VALUE');

  except
    on e: Exception do begin
      Log('UpdateProfile', '[EXCEPTION] On exec usrUpdateUserProfile: ' + e.Message + '; Params:' +
        ' UserID = ' + IntToStr(UserID) +
        ', FirstName = '+ FirstName +
        ', LastName = ' + LastName +
        ', EmailAlerts = ' + IntToStr(EmailAlerts) +
        ', BuddyAlerts = ' + IntToStr(BuddyAlerts) +
        ', Location = ' + Location +
        ', SexID = ' + IntToStr(SexID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uoupdateprofile result="'+IntToStr(Result)+'"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

  if Result = 2 then begin
    Result := US_ERR_USERNOTFOUND
  end
  else begin
    if Result = 1 then begin
      Result := US_ERR_USERALREADYEXIST;
    end;
    if Result = 3 then begin
      Result := US_ERR_EMAILALREADYEXIST;
    end;
    if Result = 4 then begin
      Result := US_ERR_EMAILANDLOGINALREADYEXIST
    end;
  end;

  Response   := '<object name="user"><uoupdateprofile result="'+IntToStr(Result)+'"/></object>';

      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

  Log('UpdateProfile', 'Exit; Result=' + IntToStr(Result) + '; Params:' +
    ' SessionID=' + IntToStr(SessionID) +
    ', UserID=' + IntToStr(UserID),
    ltCall
  );
end;

function TUser.TransferMoneyTo(SessionId, UserId ,Amount: Integer; TransferFrom,    // Stores to database
  TransferTo: String): Integer;                                                     // players money transfers
var
  SqlAdaptor      : TSQLAdapter;
  Response        : String;
begin

  Log('TransferFrom', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + TransferFrom,
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // stored procedure usrTransferMoneyTo
    SqlAdaptor.SetProcName('usrTransferMoneyTo');
    SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
    SqlAdaptor.AddParString('TransferFrom',TransferFrom,ptInput);
    SqlAdaptor.AddParString('TransferTo',TransferTo,ptInput);
    SqlAdaptor.AddParInt('Amount',Amount,ptInput);

    SqlAdaptor.ExecuteCommand;

    Result := SqlAdaptor.GetParam('RETURN_VALUE');

  except
    on e: Exception do begin
      Log('TransferMoneyTo', '[EXCEPTION] On exec usrTransferMoneyTo: ' + e.Message + '; Params:' +
        ' TransferFrom = ' + TransferFrom +
        ', TransferTo = '+ TransferTo +
        ', Amount = ' + IntToStr(Amount),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uotransfermoneyto result="'+IntToStr(Result)+'"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

  if Result = -2 then begin
    Result := US_ERR_USERNOTFOUND
  end
  else
  if Result = -3 then
    Result := US_ERR_USERNOTENOUGHMONEY;

  Response   := '<object name="user"><uotransfermoneyto result="'+IntToStr(Result)+'"/></object>';

      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

  Log('TransferMoney', 'Exit; Result=' + IntToStr(Result) + '; Params:' +
    ' SessionID=' + IntToStr(SessionID) +
    ', UserID=' + IntToStr(UserID),
    ltBase
  );
end;

function TUser.GetLocation(SessionId,UserId: Integer; PlayerName: String): Integer;
var
  SqlAdaptor: TSQLAdapter;
  Response, sSql  : String;
begin
  Log('FindPlayer', 'Entry; Params:' +
    ' ClientSessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID),
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  sSql := 'usrGetUserLocation ' + PlayerName;
  try
    try
      Response := SqlAdaptor.ExecuteForXML(sSql);
    except
      on e: Exception do begin
        Log('GetProfile', '[EXCEPTION] on exec [' + sSql +']: ' + e.Message +
          ';Params: UserID = ' + IntToStr(UserID),
          ltException
        );

        Result   := US_ERR_SQLCOMMANDERROR;
        Response := '<object name="user"><uofindplayer result="'+IntToStr(Result)+'"/></object>';

        if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
        else CommonDataModule.NotifyUserByID(UserID,Response);

        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
  end;

  if Response = '' then begin
    Log('GetProfile',
      '[WARNING]: User not found UserID=' + IntToStr(UserID),
      ltError);

    Result   := US_ERR_USERNOTFOUND;
    Response := '<object name="user"><uofindplayer result="'+IntToStr(Result)+'"/></object>';
  end
  else
  Response := '<object name="user">' + Response + '</object>';

  Result := 0;

  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  Log('GetLocation', 'Exit; Result=' + IntToStr(Result), ltBase);
end;


function TUser.UserStatistics(SessionID, UserID: Integer;
  out LastLoginTime: String; out TotalLoggedIn: Int64): Integer;
var
  SqlAdaptor: TSQLAdapter;
  Response  : String;
begin
  Log('UserStatistics', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID),
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // stored procedure usrUserStatistics
    SqlAdaptor.SetProcName('usrUserStatistics');
    SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
    SqlAdaptor.AddParInt('UserID',UserID,ptInput);
    SqlAdaptor.AddParString('LastLoginTime',LastLoginTime,ptOutPut);
    SqlAdaptor.AddParam('TotalLoggedTime',TotalLoggedIn,ptOutPut,ftInteger);

    SqlAdaptor.ExecuteCommand;

    Result := SqlAdaptor.GetParam('RETURN_VALUE');

    if Result = 0 then begin
        LastLoginTime := SqlAdaptor.GetParam('LastLoginTime');
        TotalLoggedIn := SqlAdaptor.GetParam('TotalLoggedTime');
    end else begin
        LastLoginTime := '';  // wrong date
        TotalLoggedIn := 0;
    end;

  except
    on e : Exception do begin
      Log('UserStatistics', '[EXCEPTION] On exec usrUserStatistics:' + e.Message + '; Params:' +
        ' SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uogetstatistics result="' + IntToStr(Result) +
                    '"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

  Response :=
    '<object name="user"><uogetstatistics result="' + IntToStr(Result) +
      '" userid="' + IntToStr(UserID) +
      '" lastloggedtime="' + LastLoginTime +
      '" totalloggedseconds="'+IntToStr(TotalLoggedIn)+'"/></object>';

      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

  Log('UserStatistics', 'Exit; Result=' + IntToStr(Result) + '; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID),
    ltCall
  );
end;

function TUser.Validate(SessionID, UserID, ValidationCode: Integer): Integer;
var
  SqlAdaptor  : TSQLAdapter;
  Response    : String;
  Email       : string;
begin
  Log('Validate', 'Entry; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', ValidationCode = ' + IntToStr(ValidationCode),
    ltCall
  );

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // retrieves user Email
    SqlAdaptor.SetProcName('usrGetUserProfile');
    SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
    SqlAdaptor.AddParInt('UserID',UserID,ptInput);
    SqlAdaptor.AddParWString('FirstName','',ptOutPut);
    SqlAdaptor.AddParWString('LastName','',ptOutPut);
    SqlAdaptor.AddParWString('LoginName','',ptOutPut);
    SqlAdaptor.AddParString('Email','',ptOutPut);
    SqlAdaptor.AddParInt('EmailValidated',0,ptOutPut);
    SqlAdaptor.AddParInt('EmailAlerts',0,ptOutPut);
    SqlAdaptor.AddParInt('BuddyAlerts',0,ptOutPut);
    SqlAdaptor.AddParWString('Location','',ptOutPut);
    SqlAdaptor.AddParInt('SexID',0,ptOutPut);
    SqlAdaptor.AddParInt('AvatarID',0,ptOutPut);
    SqlAdaptor.AddParInt('ShowLocation',0,ptOutPut);
    SqlAdaptor.AddParString('NameQUID','',ptOutPut);
    SqlAdaptor.AddParInt('QOMPID',0,ptOutPut);
    SqlAdaptor.AddParam('BunusAccount',0,ptOutPut,ftCurrency);
    SqlAdaptor.AddParInt('ChatAllow',0,ptOutPut);

    SqlAdaptor.ExecuteCommand;

    Result   := SqlAdaptor.GetParam('RETURN_VALUE');
    Email    := SqlAdaptor.GetParam('Email');

  except
    on e : Exception do begin
      Log('Validate', '[EXCEPTION] On exec usrGetUserProfile:' + e.Message + '; Params:' +
        ' SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID) +
        ', ValidationCode = ' + IntToStr(ValidationCode),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uovalidateemail result="'+IntToStr(Result)+'"/></object>';
      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

      Exit;
    end;
  end;



  if Result <> 0 then Result := US_ERR_SQLEMPTYDATASET
  else if HashEmail(Email) <> ValidationCode then Result := US_ERR_VALIDATIONFAILED
  else
  begin
    try
      //  marks Email as Validated
      SqlAdaptor.SetProcName('usrMarkEmailAsValid');
      SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
      SqlAdaptor.AddParInt('UserID',UserID,ptInput);

      SqlAdaptor.ExecuteCommand;

      Result   := SqlAdaptor.GetParam('RETURN_VALUE');

    except
      on e : Exception do begin
        Log('Validate', '[EXCEPTION] On exec usrMarkEmailAsValid:' + e.Message + '; Params:' +
          ' UserID = ' + IntToStr(UserID),
          ltException
        );

        CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
        Result     := US_ERR_SQLCOMMANDERROR;
        Response   := '<object name="user"><uovalidateemail result="'+IntToStr(Result)+'"/></object>';

        if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
        else CommonDataModule.NotifyUserByID(UserID,Response);

        Exit;
      end;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

  Response   := '<object name="user"><uovalidateemail result="' + IntToStr(Result) + '"/></object>';

  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  Log('Validate', 'Exit; Result=' + IntToStr(Result) + '; Params:' +
    ' SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', ValidationCode = ' + IntToStr(ValidationCode),
    ltCall
  );
end;

procedure TUser.Log(MethodName, LogData: String; LogType: TLogType);
begin
  CommonDataModule.Log(ClassName, MethodName, LogData, LogType);
end;

function TUser.Login(SessionID: Integer; const LoginUserName,
  Password: String; out UserID: Integer;
  var IsEmailValid: integer): integer;
var
  SqlAdaptor      : TSQLAdapter;
  Response        : String;
  PrevSessionID   : Integer;
begin
  IsEmailValid := 0;

  SqlAdaptor := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // stored procedure usrLoginUser
    SqlAdaptor.SetProcName('usrLoginUser');
    SqlAdaptor.AddParInt('RETURN_VALUE',0,ptResult);
    SqlAdaptor.AddParInt('ClientSessionID',SessionID,ptInput);
    SqlAdaptor.AddParWString('UserLoginName',LoginUserName,ptInput);
    SqlAdaptor.AddParWString('Password',Password,ptInput);
    SqlAdaptor.AddParInt('IsEmailValid',0,ptOutPut);
    SqlAdaptor.AddParInt('PrevSessionID',0,ptOutPut);

    SqlAdaptor.ExecuteCommand;

//  returns UserID (if > 0 then Ok else failed)
    UserID := SqlAdaptor.GetParam('RETURN_VALUE');
    if UserID > 0 then
    begin
      IsEmailValid := Integer(SqlAdaptor.GetParam('IsEmailValid'));
      PrevSessionID := Integer(SqlAdaptor.GetParam('PrevSessionID'));
      if (PrevSessionID > 0) and (PrevSessionID <> SessionID) then
      begin
        CommonDataModule.NotifyUser(PrevSessionID,
          '<object name="user"><uologout reason="' +
          'You have been signed out because you signed in at another location' +
          '"/></object>');
{
        CommonDataModule.ProcessAction('<objects><object name="api"><apleavetable userid="' +
          inttostr(UserID) + '"/></object></objects>');
}          
      end;
    end;

  except
    on e : Exception do begin
      Log('Login', '[] On exec usrLoginUser:' + e.Message +
        '; Params: SessionID = ' + IntToStr(SessionID) +
        ', LoginUserName = ' + LoginUserName +
        ', Password = ' + Password,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);

      Result     := US_ERR_SQLCOMMANDERROR;
      Response   := '<object name="user"><uologin result="'+IntToStr(Result)+'" emailvalidated="'+IntToStr(IsEmailValid)+'"/></object>';

      if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
      else CommonDataModule.NotifyUserByID(UserID,Response);

      Exit;
    end;
  end;

  case UserID of
     0: Result := US_ERR_LOGINFAILED;
    -1: Result := US_ERR_ALREADYLOGGED;
    -2: Result := US_ERR_USERSTATUSISDISABLED;
    -3: Result := US_ERR_USERSTATUSISDELETED;
  else
    Result := 0;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdaptor);
end;

procedure TUser.NotifyGameAdaptor(SessionID: integer);
var
  Data : String;
begin
  Log('NotifyGameAdaptor', 'Entry; Params: SessionID=' + IntToStr(SessionID), ltCall);

  Data :=
    '<objects><object name="api">' +
      '<apsetparticipantaslogged sessionid="'+inttostr(SessionID)+'"/>' +
    '</object></objects>';
  CommonDataModule.ProcessAction(Data);

  Log('NotifyGameAdaptor', 'Exit; Params: SessionID=' + IntToStr(SessionID), ltCall);
end;

function TUser.SendUserProfile(const UserID: Integer): Integer;
begin
  Result := GetProfile(0, UserID);
end;


function TUser.HashEmail(s: string): integer;
var
  i, x: Integer;
begin
{ Hash for email;
  Parameters: s       - email address
  Returns:    Hash code (5 digits code)
}
  Result := 0;
  for i := 1 to Length(s) do begin
    Result := (Result shl 4) + Ord(s[i]);
    x := Result and $F0000000;
    if (x <> 0) then Result := Result xor (x shr 24);
    Result := Result and (not x);
  end;
  if Result > 99999 then Result := Result mod 100000;
  if Result < 10000 then Result := Result + 10000;
end;

end.
