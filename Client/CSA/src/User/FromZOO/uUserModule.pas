//      Project: Poker
//         Unit: uUserModule.pas
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es): TUserModule
//  Description: Login and Logout using existing connection session,
//               Get, update, store profile, store user settings

unit uUserModule;

interface

uses
  SysUtils, Classes, uZipCrypt, Dialogs, Controls, Forms, ShellAPI, Windows,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uChangePlayerLogoForm, uDataList,
  uSessionModule, ExtCtrls;

const
  UserPasswordMagicWord = 'Z0oGam$sRegCryPt';

type
  TUserModule = class(TDataModule)
    LoginActionDelayTimer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure LoginActionDelayTimerTimer(Sender: TObject);
  private
    FLogged: Boolean;
    FUserPassword: String;
    FUserName: String;
    FUserPasswordCryptKey: TSecurityKey128;
    FOnLogged: TSessionEvent;
    FOnNewUserRegistered: TSessionEvent;
    FOnNewUser: TSessionEvent;
    FOnLogin: TSessionEvent;
    FOnLoginFailed: TSessionEvent;
    FOnNewUserFailed: TSessionEvent;
    FAutoSave: Boolean;
    FUserID: Integer;
    FOnActionLogin: TSessionEvent;
    FOnChangePassword: TSessionEvent;
    FOnChangeValidateEMail: TSessionEvent;
    FOnChangedPassword: TSessionEvent;
    FOnChangePasswordFailed: TSessionEvent;
    FOnValidateEMailFailed: TSessionEvent;
    FOnValidatedEMail: TSessionEvent;
    FOnChangedProfile: TSessionEvent;
    FOnChangeProfile: TSessionEvent;
    FOnChangeProfileFailed: TSessionEvent;
    FUserEMail: String;
    FUserSexID: Integer;
    FUserLocation: String;
    FUserFirstName: String;
    FUserLastName: String;
    FUserShowLocation: Boolean;
    FUserTotalLoggedSeconds: Integer;
    FUserLastLoggedTime: String;
    FUserEMailValidated: Boolean;
    FUserChatAllow: Boolean;

    FOnForgotPassword: TSessionEvent;
    FOnForgottedPassword: TSessionEvent;
    FOnForgotPasswordFailed: TSessionEvent;
    FOnGetProfileForChangeEMail: TSessionEvent;
    FOnGetProfile: TSessionEvent;
    FOnGetProfileForCashier: TSessionEvent;

    FPlayerLogoID: Integer;
    FPlayerLogoFileName: String;
    FPlayerLogoInited: Boolean;
    FChangePlayerLogoForm: TChangePlayerLogoForm;

    FPopupMessages: TDataList;
    FOnPopupMessages: TSessionEvent;
    FOnPopupMessagesHistory: TSessionEvent;

    procedure Run_NewUser(XMLRoot: IXMLNode);
    procedure Run_Login(XMLRoot: IXMLNode);
    procedure Run_Logout(XMLRoot: IXMLNode);
    procedure Run_GetStatistics(XMLRoot: IXMLNode);
    procedure Run_ChangePassword(XMLRoot: IXMLNode);
    procedure Run_ForgotPassword(XMLRoot: IXMLNode);
    procedure Run_GetProfile(XMLRoot: IXMLNode);
    procedure Run_UpdateProfile(XMLRoot: IXMLNode);
    procedure Run_ChangeEmail(XMLRoot: IXMLNode);
    procedure Run_ValidateEmail(XMLRoot: IXMLNode);
    procedure Run_PopupMessage(XMLRoot: IXMLNode);
    procedure Run_PopupMessageHistory(XMLRoot: IXMLNode);

    procedure SetOnLogged(const Value: TSessionEvent);
    procedure SetOnLogin(const Value: TSessionEvent);
    procedure SetOnNewUser(const Value: TSessionEvent);
    procedure SetOnNewUserRegistered(const Value: TSessionEvent);
    procedure SetOnLoginFailed(const Value: TSessionEvent);
    procedure SetOnNewUserFailed(const Value: TSessionEvent);
    procedure SetOnActionLogin(const Value: TSessionEvent);
    procedure SetOnChangePassword(const Value: TSessionEvent);
    procedure SetOnChangeValidateEMail(const Value: TSessionEvent);
    procedure SetOnChangedPassword(const Value: TSessionEvent);
    procedure SetOnChangePasswordFailed(const Value: TSessionEvent);
    procedure SetOnValidatedEMail(const Value: TSessionEvent);
    procedure SetOnValidateEMailFailed(const Value: TSessionEvent);
    procedure SetOnChangedProfile(const Value: TSessionEvent);
    procedure SetOnChangeProfile(const Value: TSessionEvent);
    procedure SetOnChangeProfileFailed(const Value: TSessionEvent);
    procedure SetOnForgotPassword(const Value: TSessionEvent);
    procedure SetOnForgotPasswordFailed(const Value: TSessionEvent);
    procedure SetOnForgottedPassword(const Value: TSessionEvent);
    procedure SetOnGetProfileForChangeEMail(const Value: TSessionEvent);
    procedure SetOnGetProfile(const Value: TSessionEvent);
    procedure SetOnGetProfileForCashier(const Value: TSessionEvent);
    procedure SetPlayerLogoFileName(const Value: String);
    procedure SetOnPopupMessages(const Value: TSessionEvent);
    procedure SetPopupMessages(const Value: TDataList);
    procedure SetOnPopupMessagesHistory(const Value: TSessionEvent);

    procedure Clear;
    procedure LoadLoginData;
    procedure UpdateLoginState;
    procedure Do_PlayerLogoLoaded(XMLNode: IXMLNode);
    procedure Do_PlayerLogoShow(XMLNode: IXMLNode);
    procedure Do_PlayerLogoFinish(XMLNode: IXMLNode);
    procedure PlayerLogoInit;
    procedure UpdateChatState;
  public
    property  Logged: Boolean read FLogged;
    property  UserName: String read FUserName;
    property  UserPassword: String read FUserPassword;
    property  UserID: Integer read FUserID;
    property  UserEMail: String read FUserEMail;
    property  UserEMailValidated: Boolean read FUserEMailValidated;
    property  UserFirstName: String read FUserFirstName;
    property  UserLastName: String read FUserLastName;
    property  UserLocation: String read FUserLocation;
    property  UserShowLocation: Boolean read FUserShowLocation;
    property  UserSexID: Integer read FUserSexID;
    property  AutoSave: Boolean read FAutoSave;
    property  UserLastLoggedTime: String read FUserLastLoggedTime;
    property  UserTotalLoggedSeconds: Integer read FUserTotalLoggedSeconds;
    property  UserChatAllow: Boolean read FUserChatAllow;

    property  OnLogin: TSessionEvent read FOnLogin write SetOnLogin;
    property  OnActionLogin: TSessionEvent read FOnActionLogin write SetOnActionLogin;
    property  OnLogged: TSessionEvent read FOnLogged write SetOnLogged;
    property  OnLoginFailed: TSessionEvent read FOnLoginFailed write SetOnLoginFailed;

    property  OnNewUser: TSessionEvent read FOnNewUser write SetOnNewUser;
    property  OnNewUserRegistered: TSessionEvent read FOnNewUserRegistered write SetOnNewUserRegistered;
    property  OnNewUserFailed: TSessionEvent read FOnNewUserFailed write SetOnNewUserFailed;

    property  OnChangePassword: TSessionEvent read FOnChangePassword write SetOnChangePassword;
    property  OnChangedPassword: TSessionEvent read FOnChangedPassword write SetOnChangedPassword;
    property  OnChangePasswordFailed: TSessionEvent read FOnChangePasswordFailed write SetOnChangePasswordFailed;

    property  OnForgotPassword: TSessionEvent read FOnForgotPassword write SetOnForgotPassword;
    property  OnForgottedPassword: TSessionEvent read FOnForgottedPassword write SetOnForgottedPassword;
    property  OnForgotPasswordFailed: TSessionEvent read FOnForgotPasswordFailed write SetOnForgotPasswordFailed;

    property  OnChangeValidateEMail: TSessionEvent read FOnChangeValidateEMail write SetOnChangeValidateEMail;
    property  OnValidatedEMail: TSessionEvent read FOnValidatedEMail write SetOnValidatedEMail;
    property  OnValidateEMailFailed: TSessionEvent read FOnValidateEMailFailed write SetOnValidateEMailFailed;

    property  OnGetProfile: TSessionEvent read FOnGetProfile write SetOnGetProfile;
    property  OnGetProfileForChangeEMail: TSessionEvent read FOnGetProfileForChangeEMail write SetOnGetProfileForChangeEMail;
    property  OnGetProfileForCashier: TSessionEvent read FOnGetProfileForCashier write SetOnGetProfileForCashier;

    property  OnChangeProfile: TSessionEvent read FOnChangeProfile write SetOnChangeProfile;
    property  OnChangedProfile: TSessionEvent read FOnChangedProfile write SetOnChangedProfile;
    property  OnChangeProfileFailed: TSessionEvent read FOnChangeProfileFailed write SetOnChangeProfileFailed;

    property  PopupMessages: TDataList read FPopupMessages write SetPopupMessages;
    property  OnPopupMessages: TSessionEvent read FOnPopupMessages write SetOnPopupMessages;
    property  OnPopupMessagesHistory: TSessionEvent read FOnPopupMessagesHistory write SetOnPopupMessagesHistory;


    property  PlayerLogoID: Integer read FPlayerLogoID;
    property  PlayerLogoFileName: String read FPlayerLogoFileName write SetPlayerLogoFileName;

    procedure Login;
    procedure AutoLogin;
    procedure Logout;
    procedure NewUser;
    procedure ChangeValidateEmail;
    procedure ChangePassword;
    procedure ForgotPassword;
    procedure ChangeProfile;

    procedure Do_Login(strUserName, strUserPassword: String; SaveInfo: Boolean);
    procedure Do_Logged;
    procedure Do_CancelLogin;
    procedure Do_NewUser(LoginName, Password, FirstName, LastName,
      EMail, Location: String; ShowLocation: Boolean; SexID: Integer);
    procedure Do_ChangePassword(OldPassword, NewPassword: String;
      SaveInfo: Boolean);
    procedure Do_ChangeEMail(EMailAddress: String);
    procedure Do_ValidateEMail(ValidationCode: Integer);
    procedure Do_ValidateEmailClose;
    procedure Do_UpdateProfile(FirstName, LastName, Location: String;
      ShowLocation: Boolean; SexID: Integer);
    procedure Do_ForgotPassword(LoginName, FirstName, LastName, EMail,
      Location: String; SexID: Integer);

    procedure RunCommand(XMLRoot: IXMLNode);

    procedure ChangePlayerLogo;
    procedure Do_PlayerLogoCommand(Command: String);
    procedure Do_PlayerLogoClosed;

    function GetUserSessionInfo: String;

  end;

var
  UserModule: TUserModule;

implementation

uses
  uLogger,
  uConversions,
  uConstants,
  uTCPSocketModule,
  uProcessModule,
  uParserModule,
  uThemeEngineModule,
  uFileManagerModule;

{$R *.dfm}

{ TLoginModule }

procedure TUserModule.DataModuleCreate(Sender: TObject);
begin
  FPopupMessages := TDataList.Create(0, nil);
  Clear;
  FChangePlayerLogoForm := nil;
  FPlayerLogoFileName := '';
  FPlayerLogoID := -1;
  FPlayerLogoInited := false;
  FUserPasswordCryptKey := GenerateKey128(UserPasswordMagicWord);
end;

procedure TUserModule.DataModuleDestroy(Sender: TObject);
begin
  Clear;
  FPopupMessages.Free;
  Logger.Add('UserModule.DataModuleDestroy');
end;

procedure TUserModule.Clear;
begin
  FPopupMessages.Clear;
  FUserID := 0;
  FLogged := false;
  FUserPassword := '';
  FUserName := '';
  FAutoSave := false;
  FUserEMailValidated := false;
  FUserChatAllow := false;
end;


// Set properties procedures

procedure TUserModule.SetOnPopupMessagesHistory(
  const Value: TSessionEvent);
begin
  FOnPopupMessagesHistory := Value;
end;

procedure TUserModule.SetOnPopupMessages(const Value: TSessionEvent);
begin
  FOnPopupMessages := Value;
end;

procedure TUserModule.SetPopupMessages(const Value: TDataList);
begin
  FPopupMessages := Value;
end;

procedure TUserModule.SetPlayerLogoFileName(const Value: String);
begin
  FPlayerLogoFileName := Value;
end;

procedure TUserModule.SetOnGetProfileForCashier(
  const Value: TSessionEvent);
begin
  FOnGetProfileForCashier := Value;
end;

procedure TUserModule.SetOnGetProfileForChangeEMail(
  const Value: TSessionEvent);
begin
  FOnGetProfileForChangeEMail := Value;
end;

procedure TUserModule.SetOnGetProfile(const Value: TSessionEvent);
begin
  FOnGetProfile := Value;
end;

procedure TUserModule.SetOnForgotPassword(const Value: TSessionEvent);
begin
  FOnForgotPassword := Value;
end;

procedure TUserModule.SetOnForgotPasswordFailed(
  const Value: TSessionEvent);
begin
  FOnForgotPasswordFailed := Value;
end;

procedure TUserModule.SetOnForgottedPassword(const Value: TSessionEvent);
begin
  FOnForgottedPassword := Value;
end;

procedure TUserModule.SetOnChangedProfile(const Value: TSessionEvent);
begin
  FOnChangedProfile := Value;
end;

procedure TUserModule.SetOnChangeProfile(const Value: TSessionEvent);
begin
  FOnChangeProfile := Value;
end;

procedure TUserModule.SetOnChangeProfileFailed(const Value: TSessionEvent);
begin
  FOnChangeProfileFailed := Value;
end;

procedure TUserModule.SetOnValidatedEMail(const Value: TSessionEvent);
begin
  FOnValidatedEMail := Value;
end;

procedure TUserModule.SetOnValidateEMailFailed(const Value: TSessionEvent);
begin
  FOnValidateEMailFailed := Value;
end;

procedure TUserModule.SetOnChangedPassword(const Value: TSessionEvent);
begin
  FOnChangedPassword := Value;
end;

procedure TUserModule.SetOnChangePasswordFailed(
  const Value: TSessionEvent);
begin
  FOnChangePasswordFailed := Value;
end;

procedure TUserModule.SetOnChangePassword(const Value: TSessionEvent);
begin
  FOnChangePassword := Value;
end;

procedure TUserModule.SetOnChangeValidateEMail(const Value: TSessionEvent);
begin
  FOnChangeValidateEMail := Value;
end;

procedure TUserModule.SetOnActionLogin(const Value: TSessionEvent);
begin
  FOnActionLogin := Value;
end;

procedure TUserModule.SetOnLoginFailed(const Value: TSessionEvent);
begin
  FOnLoginFailed := Value;
end;

procedure TUserModule.SetOnNewUserFailed(const Value: TSessionEvent);
begin
  FOnNewUserFailed := Value;
end;

procedure TUserModule.SetOnLogged(const Value: TSessionEvent);
begin
  FOnLogged := Value;
end;

procedure TUserModule.SetOnLogin(const Value: TSessionEvent);
begin
  FOnLogin := Value;
end;

procedure TUserModule.SetOnNewUser(const Value: TSessionEvent);
begin
  FOnNewUser := Value;
end;

procedure TUserModule.SetOnNewUserRegistered(const Value: TSessionEvent);
begin
  FOnNewUserRegistered := Value;
end;


// Parsing

procedure TUserModule.RunCommand(XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Add('UserModule.RunCommand started', llExtended);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := XMLNode.NodeName;
        Logger.Add('UserModule.RunCommand found ' + strNode, llExtended);

        if strNode = 'uoregister' then
          Run_NewUser(XMLNode)
        else
        if strNode = 'uologin' then
          Run_Login(XMLNode)
        else
        if strNode = 'uologout' then
          Run_Logout(XMLNode)
        else
        if strNode = 'uogetstatistics' then
          Run_GetStatistics(XMLNode)
        else
        if strNode = 'uogetprofile' then
          Run_GetProfile(XMLNode)
        else
        if strNode = 'uoupdateprofile' then
          Run_UpdateProfile(XMLNode)
        else
        if strNode = 'uochangepassword' then
          Run_ChangePassword(XMLNode)
        else
        if strNode = 'uoforgotpassword' then
          Run_ForgotPassword(XMLNode)
        else
        if strNode = 'uochangeemail' then
          Run_ChangeEmail(XMLNode)
        else
        if strNode = 'uovalidateemail' then
          Run_ValidateEmail(XMLNode)
        else
        if strNode = 'uopopupmessages' then
          Run_PopupMessage(XMLNode)
        else
        if strNode = 'uopopupmessageshistory' then
          Run_PopupMessageHistory(XMLNode);
      end;
  except
    Logger.Add('UserModule.RunCommand failed', llBase);
  end;
end;


// Register New User

procedure TUserModule.NewUser;
var
  NeedCancel: Boolean;
begin
  UpdateLoginState;
  ThemeEngineModule.ShowModalMessage('Please visit www.zoo-games.com to register for a Zoo Games Account');
  ShellExecute(0, pchar('open'), pchar('http://www.zoo-games.com/web/join.cfm'), nil, nil, SW_RESTORE);
  Exit;

  NeedCancel := true;
//  if ThemeEngineModule.AskQuestion(cstrUserAgeRestriction) then
    if Assigned(FOnNewUser) then
    begin
      FOnNewUser;
      NeedCancel := false;
    end;
  if NeedCancel then
    Do_CancelLogin;
end;

procedure TUserModule.Do_NewUser(LoginName, Password, FirstName, LastName,
  EMail, Location: String; ShowLocation: Boolean; SexID: Integer);
begin
  ParserModule.Send_Register(LoginName, Password, FirstName, LastName,
    EMail, Location, ShowLocation, SexID);
  FUserName := LoginName;
  FUserPassword := Password;
  FAutoSave := false;
end;

procedure TUserModule.Run_NewUser(XMLRoot: IXMLNode);
{
<object name="user">
  <uoregister result="0|..." userid="1213">
</object>
}
var
  ErrorCode: Integer;
begin
  FUserID := 0;
  FLogged := false;
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
  begin
    Logger.Add('User registered and logged as ' + FUserName, llExtended);
    FUserID := strtointdef(XMLRoot.Attributes['userid'], 0);
    FLogged := FUserID > 0;
    if Assigned(FOnNewUserRegistered) then
      FOnNewUserRegistered;
    FAutoSave := true;
    UpdateLoginState;
  end
  else
    if Assigned(FOnNewUserFailed) then
      FOnNewUserFailed;

  Do_Logged;
end;


// Login

procedure TUserModule.LoadLoginData;
var
  strTMP: String;
begin
  try
    strTMP := SessionModule.SessionSettings.ValuesAsString[SessionUserName];
    if strTMP <> '' then
      FUserName := UnzipDecrypt(strTMP, FUserPasswordCryptKey);
    strTMP := SessionModule.SessionSettings.ValuesAsString[SessionUserPassword];
    if strTMP <> '' then
      FUserPassword := UnzipDecrypt(strTMP, FUserPasswordCryptKey);
    FAutoSave := True;
  except
    FUserName := '';
    FUserPassword := '';
    FAutoSave := False;
  end;
end;

procedure TUserModule.Login;
begin
  if (FUserName = '') or (FUserPassword = '') then
    LoadLoginData;

  if Assigned(FOnLogin) then
    FOnLogin;
end;

procedure TUserModule.AutoLogin;
begin
  FOnActionLogin := nil;
  if (FUserName = '') or (FUserPassword = '') then
    LoadLoginData;
  if (FUserName <> '') and (FUserPassword <> '') then
    ParserModule.Send_Login(FUserName, FUserPassword);
end;

procedure TUserModule.Do_Login(strUserName, strUserPassword: String;
  SaveInfo: Boolean);
begin
  FUserName := strUserName;
  FUserPassword := strUserPassword;
  FAutoSave := SaveInfo;
  ParserModule.Send_Login(strUserName, strUserPassword);
end;

procedure TUserModule.Run_Login(XMLRoot: IXMLNode);
{
<object name="user">
  <uologin result="0|..." userid="1213" emailvalidated="0|1">
</object>
}
var
  ErrorCode: Integer;
begin
  FUserID := 0;
  FLogged := false;
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
  begin
    Logger.Add('User logged as ' + FUserName, llExtended);
    FUserID := strtointdef(XMLRoot.Attributes['userid'], 0);
    FLogged := FUserID > 0;
    FUserEMailValidated := false;
    if XMLRoot.HasAttribute('emailvalidated') then
      FUserEMailValidated := XMLRoot.Attributes['emailvalidated'] = '1';
    UpdateLoginState;
  end;
  Do_Logged;
end;

procedure TUserModule.Do_Logged;
begin
  if FAutoSave then
  begin
    SessionModule.SessionSettings.ValuesAsString[SessionUserName] :=
      ZipCrypt(FUserName, FUserPasswordCryptKey);
    SessionModule.SessionSettings.ValuesAsString[SessionUserPassword] :=
      ZipCrypt(FUserPassword, FUserPasswordCryptKey);
  end
  else
  begin
    SessionModule.SessionSettings.ValuesAsString[SessionUserName] := '';
    SessionModule.SessionSettings.ValuesAsString[SessionUserPassword] := '';
  end;
  SessionModule.SaveToRegistry;

  if FLogged then
  begin
    ParserModule.Send_GetProfile(FUserID);
    ParserModule.Send_GetStatistics(FUserID);

    if Assigned(FOnLogged) then
      FOnLogged;
    LoginActionDelayTimer.Enabled := true;
  end
  else
  begin
    FUserID := 0;
    FUserName := '';
    FUserPassword := '';
    FAutoSave := false;
    if Assigned(FOnLoginFailed) then
      FOnLoginFailed;
  end;
end;

procedure TUserModule.LoginActionDelayTimerTimer(Sender: TObject);
begin
  LoginActionDelayTimer.Enabled := false;
  if Assigned(FOnActionLogin) then
    FOnActionLogin;
end;

procedure TUserModule.Logout;
begin
  if FLogged then
    ParserModule.Send_Logout(FUserID);
  Clear;
  UpdateLoginState;
end;

procedure TUserModule.Do_CancelLogin;
begin
  FOnActionLogin := nil;
  UpdateLoginState;
end;

procedure TUserModule.UpdateLoginState;
begin
  if SessionModule.SessionState <> poTerminating then
    ProcessModule.UpdateLoginState;
end;

procedure TUserModule.UpdateChatState;
begin
  if SessionModule.SessionState <> poTerminating then
    ProcessModule.UpdateChatState;
end;

// Password

procedure TUserModule.ChangePassword;
begin
  if Logged then
  begin
    FOnActionLogin := nil;
    if Assigned(FOnChangePassword) then
      FOnChangePassword;
  end
  else
  begin
    FOnActionLogin := ChangePassword;
    Login;
  end;
end;

procedure TUserModule.Do_ChangePassword(OldPassword, NewPassword: String; SaveInfo: Boolean);
begin
  ParserModule.Send_ChangePassword(FUserID, NewPassword, OldPassword);
  FUserPassword := NewPassword;
  FAutoSave := SaveInfo;
  if SaveInfo then
  begin
    SessionModule.SessionSettings.ValuesAsString[SessionUserName] :=
      ZipCrypt(FUserName, FUserPasswordCryptKey);
    SessionModule.SessionSettings.ValuesAsString[SessionUserPassword] :=
      ZipCrypt(FUserPassword, FUserPasswordCryptKey);
  end
  else
  begin
    SessionModule.SessionSettings.ValuesAsString[SessionUserName] := '';
    SessionModule.SessionSettings.ValuesAsString[SessionUserPassword] := '';
  end;
  SessionModule.SaveToRegistry;
end;

procedure TUserModule.Run_ChangePassword(XMLRoot: IXMLNode);
{
<object name="user">
  <uochangepassword result="0|..."/>
</object>
}
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    if Assigned(FOnChangedPassword) then
      FOnChangedPassword;
  end
  else
  begin
    if Assigned(FOnChangePasswordFailed) then
      FOnChangePasswordFailed;
  end
end;


// Forgot password

procedure TUserModule.ForgotPassword;
begin
  if not UserModule.Logged then
  begin
    if Assigned(FOnLogged) then
      FOnLogged;
    if Assigned(FOnForgotPassword) then
      FOnForgotPassword;
  end;
end;

procedure TUserModule.Do_ForgotPassword(LoginName, FirstName, LastName, EMail, Location: String;
  SexID: Integer);
begin
  ParserModule.Send_ForgotPassword(LoginName, FirstName, LastName,
    EMail, Location, SexID);
end;

procedure TUserModule.Run_ForgotPassword(XMLRoot: IXMLNode);
{
<object name="user">
  <uoforgotpassword result="0|..."/>
</object>
}
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
  begin
    if Assigned(OnForgottedPassword) then
      OnForgottedPassword;
  end
  else
  begin
    if Assigned(OnForgotPasswordFailed) then
      OnForgotPasswordFailed;
  end
end;


// Get/Change Profile

procedure TUserModule.ChangeProfile;
begin
  if Logged then
  begin
    FOnActionLogin := nil;
    if Assigned(FOnChangeProfile) then
      FOnChangeProfile;
  end
  else
  begin
    FOnActionLogin := ChangeProfile;
    Login;
  end;
end;

procedure TUserModule.Run_UpdateProfile(XMLRoot: IXMLNode);
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
  begin
    ParserModule.Send_GetProfile(FUserID);
    if Assigned(FOnChangedProfile) then
      FOnChangedProfile;
  end
  else
  begin
    if Assigned(FOnChangeProfileFailed) then
      FOnChangeProfileFailed;
  end
end;

procedure TUserModule.Do_UpdateProfile(FirstName, LastName, Location: String;
  ShowLocation: Boolean; SexID: Integer);
var
  AvatarID: Integer;
begin
  AvatarID := FPlayerLogoID;
  if SexID = 1 then
    if AvatarID = 2 then
      AvatarID := 1;
  if SexID = 2 then
    if AvatarID = 1 then
      AvatarID := 2;

  ParserModule.Send_UpdateProfile(FUserID, FirstName, LastName,
    Location, ShowLocation, AvatarID, SexID);
end;

procedure TUserModule.Run_GetProfile(XMLRoot: IXMLNode);
{
<object name="user">
  <uogetprofile result="0|..."
                userid="1213" 
                loginname="Player"
                firstname="John"
                lastname="Smith"
                email="player@mail.com"
                emailvalidated="0|1"
                showlocation="0|1"
                location="neverland"
                avatarid="0"
                sexid="0"
            		chatallow="0|1"
                />
</object>
}
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    FUserFirstName := XMLRoot.Attributes['firstname'];
    FUserLastName := XMLRoot.Attributes['lastname'];
    FUserEMail := XMLRoot.Attributes['email'];
    FUserLocation := XMLRoot.Attributes['location'];
    FUserShowLocation := XMLRoot.Attributes['showlocation'] = '1';
    FPlayerLogoID := strtointdef(XMLRoot.Attributes['avatarid'], 0);
    FUserSexID := strtointdef(XMLRoot.Attributes['sexid'], 0);
    if XMLRoot.HasAttribute('emailvalidated') then
      FUserEMailValidated := XMLRoot.Attributes['emailvalidated'] = '1';
    if XMLRoot.HasAttribute('chatallow') then
      FUserChatAllow := XMLRoot.Attributes['chatallow'] = '1';

    if Assigned(FOnGetProfile) then
      FOnGetProfile;
    if Assigned(FOnGetProfileForChangeEMail) then
      FOnGetProfileForChangeEMail;
    if Assigned(FOnGetProfileForCashier) then
      FOnGetProfileForCashier;
    if (FChangePlayerLogoForm <> nil) and (not FPlayerLogoInited) then
      PlayerLogoInit;

    UpdateChatState;
  end
end;


// Get statistics

procedure TUserModule.Run_GetStatistics(XMLRoot: IXMLNode);
{
<object name="user">
  <uogetstatistics result="0|..."
                   userid="1213" 
                   lastloggedtime="2003/08/25 13:51:09"
                   totalloggedseconds="873614526">
</object>
}
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    FUserLastLoggedTime := XMLRoot.Attributes['lastloggedtime'];
    FUserTotalLoggedSeconds := strtointdef(XMLRoot.Attributes['totalloggedseconds'], 0);
    if Assigned(FOnGetProfileForCashier) then
      FOnGetProfileForCashier;
  end
end;


// Validate email

procedure TUserModule.ChangeValidateEmail;
begin
  if Logged then
  begin
    FOnActionLogin := nil;
    if Assigned(FOnChangeValidateEMail) then
      FOnChangeValidateEMail;
  end
  else
  begin
    FOnActionLogin := ChangeValidateEmail;
    Login;
  end;
end;

procedure TUserModule.Do_ChangeEMail(EMailAddress: String);
begin
  ParserModule.Send_ChangeEMail(FUserID, EMailAddress);
end;

procedure TUserModule.Run_ChangeEmail(XMLRoot: IXMLNode);
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
    ThemeEngineModule.ShowMessage(cstrUserChangeEMail);
  ParserModule.Send_GetProfile(FUserID);
end;

procedure TUserModule.Do_ValidateEMail(ValidationCode: Integer);
begin
  ParserModule.Send_ValidateEMail(FUserID, ValidationCode);
end;

procedure TUserModule.Do_ValidateEmailClose;
begin
  ParserModule.Send_GetProfile(FUserID);
end;

procedure TUserModule.Run_ValidateEmail(XMLRoot: IXMLNode);
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
  begin
    FUserEMailValidated := true;
    if Assigned(FOnValidatedEMail) then
      FOnValidatedEMail;
  end
  else
  begin
    if Assigned(FOnValidateEMailFailed) then
      FOnValidateEMailFailed;
  end;
  ParserModule.Send_GetProfile(FUserID);
end;


// Change Player Logo

procedure TUserModule.ChangePlayerLogo;
begin
  if Logged then
  begin
    FOnActionLogin := nil;
    if (FChangePlayerLogoForm = nil) and (FPlayerLogoFileName <> '') then
    begin
      FChangePlayerLogoForm := TChangePlayerLogoForm.Create(Self);
      FChangePlayerLogoForm.Load(FileManagerModule.FilesPath + FPlayerLogoFileName);
    end;
  end
  else
  begin
    FOnActionLogin := ChangePlayerLogo;
    Login;
  end;
end;

procedure TUserModule.Do_PlayerLogoClosed;
begin
  FChangePlayerLogoForm := nil;
end;

procedure TUserModule.Do_PlayerLogoCommand(Command: String);
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
  strRoot: String;
begin
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := Command;
      RequestXMLDoc.Active := true;
      XMLRoot := RequestXMLDoc.DocumentElement;
      strRoot := XMLRoot.NodeName;

      if strRoot = 'loaded' then
        Do_PlayerLogoLoaded(XMLRoot);

      if strRoot = 'readytoshow' then
        Do_PlayerLogoShow(XMLRoot);

      if strRoot = 'finish' then
        Do_PlayerLogoFinish(XMLRoot);

    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ChangeAvatarForm.ShockwaveFlashFSCommand failed', llBase);
  end;
end;

procedure TUserModule.Do_PlayerLogoLoaded(XMLNode: IXMLNode);
{
  <loaded width="790" height="540"/>
}
begin
  if FChangePlayerLogoForm <> nil then
  begin
    FChangePlayerLogoForm.SetSize(StrToIntDef(XMLNode.Attributes['width'], 400),
      StrToIntDef(XMLNode.Attributes['height'], 300));
    if FPlayerLogoID >= 0 then
      PlayerLogoInit;
  end;
end;

procedure TUserModule.PlayerLogoInit;
{
  <init avatarid="3" sexid="1">
    <logo filename="logo3.swf"/>
  </init>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
begin
  FPlayerLogoInited := true;
  if FChangePlayerLogoForm <> nil then
  begin
    try
      RequestXMLDoc := TXMLDocument.Create(Self);
      try
        RequestXMLDoc.Active := false;
        RequestXMLDoc.XML.Text := '<init/>';
        RequestXMLDoc.Active := true;
        XMLRoot := RequestXMLDoc.DocumentElement;
        XMLRoot.Attributes['avatarid'] := FPlayerLogoID;
        XMLRoot.Attributes['sexid'] := FUserSexID;

        FileManagerModule.FillAvatarsFiles(XMLRoot);
        FChangePlayerLogoForm.Send(XMLRoot.XML);
      finally
        RequestXMLDoc.Active := false;
        RequestXMLDoc.Free;
      end;
    except
      Logger.Add('UserModule.Do_PlayerLogoLoaded failed', llBase);
    end;
  end;
end;

procedure TUserModule.Do_PlayerLogoShow(XMLNode: IXMLNode);
{
  <readytoshow/>
}
begin
  if FChangePlayerLogoForm <> nil then
    FChangePlayerLogoForm.Start;
end;

procedure TUserModule.Do_PlayerLogoFinish(XMLNode: IXMLNode);
{
  <finish avatarid="12"/>
}
var
  NewPlayerLogoID: Integer;
begin
  NewPlayerLogoID := StrToIntDef(XMLNode.Attributes['avatarid'], FPlayerLogoID);
  if NewPlayerLogoID <> FPlayerLogoID then
    ParserModule.Send_UpdateProfile(FUserID, FUserFirstName, FUserLastName,
      FUserLocation, FUserShowLocation, NewPlayerLogoID, FUserSexID);
  if FChangePlayerLogoForm <> nil then
    FChangePlayerLogoForm.Stop;
end;


// Popup Mesage

procedure TUserModule.Run_PopupMessage(XMLRoot: IXMLNode);
{
<object name="user">
  <uopopupmessages>
    <message type="1|2|3" title="" header="" footer="" date="2003-02-25 02:47 PM">
      <data value=""/>
      <data value=""/>
      <data value=""/>
      <data value=""/>
    </message>
    ...
  </uopopupmessages>
</object>
}
begin
  if XMLRoot.ChildNodes.Count > 0 then
  begin
    FPopupMessages.Clear;
    FPopupMessages.LoadFromXML(XMLRoot, true);
    if Assigned(FOnPopupMessages) then
      FOnPopupMessages;
  end;
end;


procedure TUserModule.Run_PopupMessageHistory(XMLRoot: IXMLNode);
{
<object name="user">
  <uopopupmessageshistory>
    <message type="1|2|3" title="" header="" footer="" date="2003-02-25 02:47 PM">
      <data value=""/>
      <data value=""/>
      <data value=""/>
      <data value=""/>
    </message>
    ...
  </uopopupmessageshistory>
</object>
}
begin
  if XMLRoot.ChildNodes.Count > 0 then
  begin
    FPopupMessages.Clear;
    FPopupMessages.LoadFromXML(XMLRoot, true);
    if Assigned(FOnPopupMessagesHistory) then
      FOnPopupMessagesHistory;
  end;
end;


// Logout

procedure TUserModule.Run_Logout(XMLRoot: IXMLNode);
begin
  FLogged := False;
  ThemeEngineModule.ShowWarning(XMLRoot.Attributes['reason']);
  SessionModule.TerminateApplication;
end;

function TUserModule.GetUserSessionInfo: String;
begin
  Result := '';
  if SessionModule.SessionSettings.ValuesAsBoolean[RegistryDebugKey] and
    (SessionModule.SessionSettings.ValuesAsString[RegistryDebugIdent] = RegistryDebugVerbose) then
  begin
    Result := ' :: SessionID=' + inttostr(SessionModule.SessionID) + ', ';
    if not FLogged then
      Result := Result + 'Not logged'
    else
      Result := Result + 'UserName="' + UserModule.UserName + '", ' +
        'UserID=' + inttostr(UserModule.UserID);
  end;
end;

end.
