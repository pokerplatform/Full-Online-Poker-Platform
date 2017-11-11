//      Project: Poker
//         Unit: uParserModule.pas
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es): TParserModule
//  Description: Parse and run commands received from remote host;
//               Create XML commands and send its to the server

unit uParserModule;

interface

uses
  SysUtils, Classes, Windows, Messages,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uConstants, uDataList, uZipCrypt;

type
  TServerObject = (poAPI, poFileManager, poUser, poGameAdaptor, poAccount, poTournament);

  TParserModule = class(TDataModule)
    ResponseXMLDoc: TXMLDocument;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FCommandRunned: Boolean;
    FCommandBuffer: TStringList;
    function XMLInit(XMLDoc: TXMLDocument; ServerObject: TServerObject;
      var XMLRoot: IXMLNode; RootName: String): Boolean;
    function XMLSend(XMLDoc: TXMLDocument): Boolean;
    procedure DisplayErrorMessage(ErrorCode: Integer);
  public
    procedure OnCommandReceived(ReceivedCommand: String);

    function GetResult(XMLNode: IXMLNode; var ErrorCode: Integer;
      ShowErrorMessage: Boolean): Boolean;

    // Dispatch
    function Send_Connect: Boolean;

    // References
    function Send_GetReferences: Boolean;

    // Lobby
    function Send_UpdateSummary: Boolean;
    function Send_GetProcesses(SubCategoryID: Integer): Boolean;
    function Send_GetProcessInfo(ProcessID: Integer): Boolean;
    function Send_UpdateLobbyInfo(SubCategoryID, ProcessID: Integer): Boolean;
    function Send_CustomSupport(msgSubject, msgBody: String): Boolean;

    // Process
    function Send_GetNotes(ForUserID: Integer): Boolean;
    function Send_SaveNotes(ForUserID: Integer; Notes: String): Boolean;
    function Send_SaveRecordedHands(RecordedHandList: TDataList): Boolean;
    function Send_GetRecordedHands: Boolean;
    function Send_LoadRecordedHand(HandID: Integer): Boolean;
    function Send_RequestHandHistory(HandID, LastHands,
      Direction: Integer): Boolean;
    function Send_CheckHandID(HandID, Order: Integer;
      Comment: String): Boolean;
    function Send_ResetAllin: Boolean;

    function Send_GetWaitingListInfo(ProcessID: Integer): Boolean;
    function Send_RegisterWaitingList(ProcessID, GroupID, PlayersCount: Integer): Boolean;
    function Send_UnregisterWaitingList(ProcessID, GroupID: Integer): Boolean;
    function Send_DeclineWaitingList(ProcessID: Integer; Reason: String): Boolean;

    // Tournament
    function Send_GetTournaments(CategoryID: Integer): Boolean;
    function Send_GetTournamentInfo(TournamentID: Integer): Boolean;
    function Send_GetTournamentLobbyInfo(TournamentID: Integer): Boolean;
    function Send_GetTournamentPlayers(TournamentID: Integer): Boolean;
    function Send_GetTournamentProcesses(TournamentID: Integer): Boolean;
    function Send_GetTournamentProcessPlayers(TournamentID, ProcessID: Integer): Boolean;
    function Send_GetTournamentRegister(TournamentID: Integer; Password: string): Boolean;
    function Send_GetTournamentUnregister(TournamentID: Integer): Boolean;
    function Send_GetTournamentLevelsInfo(TournamentID: Integer): Boolean;
    function Send_TournamentRebuy(TournamentID: Integer; Value: Integer): Boolean;
    function Send_TournamentAutoRebuy(TournamentID: Integer; Value: Integer):Boolean;

    //Tournament Leader Board
    function Send_GetTournamentLeaderBorad(UserId: Integer;TypeOfRequest: string): Boolean;
    function Send_GetTournamentLeaderPoints(UserId: Integer;FromTime, ToTime: String): Boolean;

    // File manager
    function Send_GetFileInfo(FileID: Integer): Boolean;
    function Send_GetSystemFiles: Boolean;
    function Send_GetProcessFiles(ProcessID: Integer): Boolean;
    function Send_GetPlayerLogo(UserId: Integer): Boolean;

    // User
    function Send_Register(LoginName, Password, FirstName, LastName, EMail, Location: String;
      ShowLocation: Boolean; SexID: Integer): Boolean;
    function Send_ForgotPassword(LoginName, FirstName, LastName, EMail, Location: String; SexID: Integer): Boolean;
    function Send_ChangePassword(NewPassword, OldPassword: String): Boolean;
    function Send_ChangeEMail(EMail: String): Boolean;
    function Send_ValidateEMail(ValidationCode: Integer): Boolean;
    function Send_GetProfile: Boolean;
    function Send_UpdateProfile(FirstName, LastName, Location: String;
      ShowLocation: Boolean; AvatarID, SexID: Integer): Boolean;
    function Send_TransferMoneyTo(UserId, Amount:Integer;TransferFrom,TransferTo:String):Boolean;
    function Send_FindPlayer(UserID: Integer;PlayerName:String):Boolean;
    function Send_GetStatistics: Boolean;
    function Send_Login(LoginName, Password: String): Boolean;
    function Send_Logout: Boolean;

    // Account
    function Send_GetBalanceInfo: Boolean;
    function Send_GetMailingAddress: Boolean;
    function Send_ChangeMailingAddress(FirstName,
      LastName, Address1, Address2, City, Province, ZIP, Phone: String;
      StateID, CountryID: Integer): Boolean;
    function Send_Deposit(CurrencyTypeID: Integer;
      Amount: Currency; PaymentSystem: TPaymentSystem; number, cvv,
      expmonth, expyear: String): Boolean;
    function Send_Withdrawal(CurrencyID: Integer; Amount: Currency): Boolean;
    function Send_GetTransactionHistory(CurrencyTypeID,
      TopLast: Integer; DateStart, DateFrom: TDateTime): Boolean;
    function Send_GetMoreChips(UserId: Integer): Boolean;
  end;

var
  ParserModule: TParserModule;

implementation

uses
  uLogger,
  uTCPSocketModule,
  uUserModule,
  uProcessModule,
  uConversions,
  uSessionModule,
  uThemeEngineModule,
  uServerErrorMessages,
  uLobbyModule,
  uCashierModule,
  uTournamentModule,
  uFileManagerModule,
  uMacTool;

{$R *.dfm}

// Common procedures

procedure TParserModule.DataModuleCreate(Sender: TObject);
begin
  FCommandBuffer := TStringList.Create;
  FCommandRunned := false;
  TCPSocketModule.OnCommandReceived := OnCommandReceived;
end;

procedure TParserModule.DataModuleDestroy(Sender: TObject);
begin
  TCPSocketModule.OnCommandReceived := nil;
  FCommandBuffer.Free;
end;


// On CommandReceivedEvent handler

procedure TParserModule.OnCommandReceived(ReceivedCommand: String);
var
  XMLRoot: IXMLNode;
  CurrentCommand: String;
  ObjName: String;
begin
  Logger.Add('ParserModule.RunCommand started', llExtended);

  if ReceivedCommand <> '' then
    FCommandBuffer.Add(ReceivedCommand);

  if FCommandRunned then
    exit;

  repeat
    if FCommandBuffer.Count > 0 then
    begin
      CurrentCommand := FCommandBuffer.Strings[0];
      FCommandBuffer.Delete(0);
      ObjName := '';

      if CurrentCommand <> '' then
      try
        ResponseXMLDoc.Active := false;
        ResponseXMLDoc.XML.Text := CurrentCommand;
        ResponseXMLDoc.Active := true;
        XMLRoot := ResponseXMLDoc.DocumentElement;

        if lowercase(XMLRoot.NodeName) = 'object' then
          ObjName := lowercase(XMLRoot.Attributes['name'])
        else
          ObjName := '';

        // Dispatch command
        if ObjName = 'process' then
          ProcessModule.RunCommand(XMLRoot)
        else
        if ObjName = 'lobby' then
          LobbyModule.RunCommand(XMLRoot)
        else
        if ObjName = 'tournament' then
          TournamentModule.RunCommand(XMLRoot)
        else
        if ObjName = 'user' then
          UserModule.RunCommand(XMLRoot)
        else
        if ObjName = 'cashier' then
          CashierModule.RunCommand(XMLRoot)
        else
        if ObjName = 'filemanager' then
          FileManagerModule.RunCommand(XMLRoot)
        else
        if ObjName = 'conversions' then
          Conversions.RunCommand(XMLRoot)
        else
        if ObjName = 'session' then
          SessionModule.RunCommand(XMLRoot)
        else
          Logger.Add('ParserModule.RunCommand - dont be recognized.', llExtended);

      except
        Logger.Add('ParserModule.RunCommand failed.', llBase);
      end;

    end;
  until FCommandBuffer.Count = 0;

  ResponseXMLDoc.Active := false;
  FCommandRunned := false;
end;

function TParserModule.GetResult(XMLNode: IXMLNode; var ErrorCode: Integer;
  ShowErrorMessage: Boolean): Boolean;
begin
  ErrorCode := -1;
  if XMLNode <> nil then
    if XMLNode.HasAttribute('result') then
      ErrorCode := strtointdef(XMLNode.Attributes['result'], -1);
  Result := ErrorCode = 0;
  if (not Result) and ShowErrorMessage then
    DisplayErrorMessage(ErrorCode);
end;

procedure TParserModule.DisplayErrorMessage(ErrorCode: Integer);
begin
  ThemeEngineModule.ShowMessage(GetServerErrorMessage(ErrorCode));
end;


// Common send commands

function TParserModule.XMLInit(XMLDoc: TXMLDocument;
  ServerObject: TServerObject; var XMLRoot: IXMLNode; RootName: String): Boolean;
begin
  Result := false;
  try
    XMLDoc.Active := false;
    XMLDoc.XML.Text := '<objects/>';
    XMLDoc.Active := true;
    XMLRoot  := XMLDoc.DocumentElement.AddChild('object');

    case ServerObject of
      poAPI:
        XMLRoot.Attributes['name'] := 'api';
      poFileManager:
        XMLRoot.Attributes['name'] := 'filemanager';
      poGameAdaptor:
        XMLRoot.Attributes['name'] := 'gameadapter';
      poUser:
        XMLRoot.Attributes['name'] := 'user';
      poTournament:
        XMLRoot.Attributes['name'] := 'tournament';
      poAccount:
        XMLRoot.Attributes['name'] := 'account';
    end;
    XMLRoot  := XMLRoot.AddChild(RootName);
    Result := true;
  except
    Logger.Add('ParserModule.XMLInit failed', llBase);
  end;
end;

function TParserModule.XMLSend(XMLDoc: TXMLDocument): Boolean;
var
  Command: String;
begin
  Result := false;
  if XMLDoc <> nil then
  try
    Command := XMLDoc.XML.Text;
    Result  := TCPSocketModule.Send(Command);
  except
    Logger.Add('ParserModule.XMLSend failed', llBase);
  end;
end;


// Send commands

// Dispatch

function TParserModule.Send_Connect: Boolean;
{
<connect csaid="1" csabuild="1"
  affiliateid="1" advertisementid="0" macaddress="12-23-34-45-56-67"/>
}
var
  InternalHost: String;
  InternalIP: String;
begin
  GetLocalHostAndIP(InternalHost, InternalIP);
  Result  := TCPSocketModule.Send('<connect csaid="' + inttostr(CSA_ID) +
    '" csabuild="' + inttostr(CSA_Build) +
    '" affiliateid="' +
      SessionModule.SessionSettings.ValuesAsString[RegistryAffiliateIDName] +
    '" advertisementid="' +
      SessionModule.SessionSettings.ValuesAsString[RegistryAdvertisementIDName] +
    '" macaddress="' + GetMACAddress +
    '" internalip="' + InternalIP +
    '" internalhost="' + InternalHost +
    '"/>');
end;


// References

function TParserModule.Send_GetReferences: Boolean;
{
<objects>
  <object name="api">
    <apgetcountries/>
    <apgetstates/>
    <apgetcurrencies/>
    <apgetstats/>
    <apgetcategories/>
  </object>
</objects>

}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apgetcountries/>' +
    '<apgetstates/>' +
    '<apgetcurrencies/>' +
    '<apgetstats/>' +
    '<apgetcategories/>' +
    '</object></objects>');
end;

// Lobby

function TParserModule.Send_UpdateSummary: Boolean;
{
<objects>
  <object name="api">
    <apupdatesummary/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apupdatesummary/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetProcesses(SubCategoryID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetprocesses subcategoryid="1"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apgetprocesses subcategoryid="' + inttostr(SubCategoryID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetProcessInfo(ProcessID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetprocessinfo processid="1213"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apgetprocessinfo processid="' + inttostr(ProcessID) + '"/>' +
    '</object></objects>');
end;


function TParserModule.Send_UpdateLobbyInfo(SubCategoryID, ProcessID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apupdatesummary/>
    <apgetprocesses subcategoryid="1"/>
    <apgetprocessinfo processid="1213"/>
  </object>
</objects>
}
var
  strXML: String;
begin
  strXML := '<objects><object name="api"><apupdatesummary/>';
  if SubCategoryID > 0 then
    strXML := strXML + '<apgetprocesses subcategoryid="' + inttostr(SubCategoryID) + '"/>';
  if ProcessID > 0 then
    strXML := strXML + '<apgetprocessinfo processid="' + inttostr(ProcessID) + '"/>';
  Result  := TCPSocketModule.Send(strXML + '</object></objects>');
end;

function TParserModule.Send_CustomSupport(msgSubject, msgBody: String): Boolean;
{
<objects>
  <object name="api">
    <apcustomsupport
     subject="all right"
     message="All functionality are worked good. You are great, guys!"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poAPI, XMLRoot, 'apcustomsupport');
      XMLRoot.Attributes['subject'] := msgSubject;
      XMLRoot.Attributes['message'] := msgBody;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_CustomSupport failed', llBase);
  end;
end;


// Process

function TParserModule.Send_GetNotes(ForUserID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetnotes userid="1213" foruserid="324"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apgetnotes userid="' + inttostr(UserModule.UserID) + '" ' +
    'foruserid="' + inttostr(ForUserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_SaveNotes(ForUserID: Integer; Notes: String): Boolean;
{
<objects>
  <object name="api">
    <apsavenotes userid="1213" foruserid="324"
     notes="He is the best poker player"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poAPI, XMLRoot, 'apsavenotes');
      XMLRoot.Attributes['userid'] := inttostr(UserModule.UserID);
      XMLRoot.Attributes['foruserid'] := inttostr(ForUserID);
      XMLRoot.Attributes['notes'] := Notes;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_SaveNotes failed', llBase);
  end;
end;

// Tournament

function TParserModule.Send_GetTournaments(CategoryID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togettournaments/>
  </object>
</objects>
}
var
 kind: byte;
begin
  if CategoryID = TournamentSubCategoryID then
   kind := 1
  else
  if CategoryID = SitAndGoSubCategoryID then
   kind := 2
  else
   kind := 0;
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<togettournaments kind="'+IntToStr(kind)+'"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentInfo(TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togettournamentinfo tournamentid="1"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<togettournamentinfo tournamentid="' + inttostr(TournamentID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentLobbyInfo(TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togetinfo tournamentid="123"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<togetinfo tournamentid="' + inttostr(TournamentID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentPlayers(TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togetplayers tournamentid="123"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<togetplayers tournamentid="' + inttostr(TournamentID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentProcesses(TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togetprocesses tournamentid="123"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<togetprocesses tournamentid="' + inttostr(TournamentID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentProcessPlayers(TournamentID, ProcessID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togetprocessplayers Tournamentid="123" processid="543245"/>
  </object>
</objects>
}
begin
  Result := true;
  if ProcessID > 0 then
    Result  := TCPSocketModule.Send(
      '<objects><object name="api">' +
      '<togetprocessplayers tournamentid="' + inttostr(TournamentID) + '" ' +
      'processid="' + inttostr(ProcessID) + '"/>' +
      '</object></objects>');
end;

function TParserModule.Send_GetTournamentRegister(TournamentID: Integer; Password: string): Boolean;
{
<objects>
  <object name="tournament">
    <toregister Tournamentid="123" userid="345"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="tournament">' +
    '<toregister tournamentid="' + inttostr(TournamentID) + '" ' +
    'userid="' + inttostr(UserModule.UserID) + '" ' +
    'password="' + Password + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentUnRegister(
  TournamentID: Integer): Boolean;
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="tournament">' +
    '<tounregister tournamentid="' + inttostr(TournamentID) + '" ' +
    'userid="' + inttostr(UserModule.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentLeaderBorad(UserId: Integer;TypeOfRequest: string):Boolean;
{
<objects>
  <object name="tournament">
    <togetleaderboard
                       userid="50"
                       type = "thisweek"
    	/>
  </object>
</objects>
}
begin
    Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<togetleaderboard userid="' + inttostr(UserId) + '" ' +
    'type="' + typeofrequest + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentLeaderPoints(UserId: Integer;
  FromTime, ToTime: String): Boolean;
{
<objects>
  <object name="tournament">
    <togetleaderpoints
                       userid="50"
                       fromtime="12/12/2005"
                       totime="14/12/2005"
    	/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<togetleaderpoints userid="' + inttostr(UserId) + '" ' +
    'fromtime="' + fromtime + '" '+ 'totime="' + totime + '"/>' +
    '</object></objects>');
end;


function TParserModule.Send_GetTournamentLevelsInfo(
  TournamentID: Integer): Boolean;
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<togetlevelsinfo tournamentid="' + inttostr(TournamentID) +'"/>'+
    '</object></objects>');
end;

function TParserModule.Send_TournamentRebuy(TournamentID: Integer;
  Value: Integer): Boolean;
begin
 Result  := TCPSocketModule.Send(
    '<objects><object name="tournament">' +
    '<torebuy tournamentid="' + inttostr(TournamentID) + '" ' +
    'userid="' + inttostr(UserModule.UserID) + '" ' +
    'value="'+ IntToStr(Value) +'"/>' +
    '</object></objects>');
end;

function TParserModule.Send_TournamentAutoRebuy(TournamentID,
  Value: Integer): Boolean;
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="tournament">' +
    '<toautorebuy tournamentid="' + inttostr(TournamentID) + '" ' +
    'userid="' + inttostr(UserModule.UserID) + '" ' +
    'value="'+ IntToStr(Value) +'"/>' +
    '</object></objects>');
end;

// File Manager

function TParserModule.Send_GetFileInfo(FileID: Integer): Boolean;
{
<objects>
  <object name="filemanager">
    <fmgetfileinfo fileid="234"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="filemanager">' +
    '<fmgetfileinfo fileid="' + inttostr(FileID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetProcessFiles(ProcessID: Integer): Boolean;
{
<objects>
  <object name="filemanager">
    <fmgetprocessfiles processid="234"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="filemanager">' +
    '<fmgetprocessfiles processid="' + inttostr(ProcessID) +
    '" affiliateid="' + SessionModule.SessionSettings.ValuesAsString[RegistryAffiliateIDName] +
    '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetSystemFiles: Boolean;
{
<objects>
  <object name="filemanager">
    <fmgetsystemfiles/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="filemanager">' +
    '<fmgetsystemfiles ' +
    'affiliateid="' + SessionModule.SessionSettings.ValuesAsString[RegistryAffiliateIDName] +
    '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetPlayerLogo(UserId: Integer): Boolean;
{
<objects>
  <object name="filemanager">
    <fmgetplayerlogo userid="1234"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="filemanager">' +
    '<fmgetplayerlogo userid="' + inttostr(UserID) + '"/>' +
    '</object></objects>');
end;


// User

function TParserModule.Send_Register(LoginName, Password, FirstName, LastName,
  EMail, Location: String; ShowLocation: Boolean; SexID: Integer): Boolean;
{
<objects>
  <object name="user">
      <uoregister loginname="Player"
                  password="qwerty"
                  firstname="John"
                  lastname="Smith"
                  email="player@mail.com"
                  showlocation = "0|1"
                  location="Somewhere in the Earth"
                  affiliateid="1"
                  advertisementid="0"
                  sexid="0"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poUser, XMLRoot, 'uoregister');
      XMLRoot.Attributes['loginname'] := LoginName;
      XMLRoot.Attributes['password'] := Password;
      XMLRoot.Attributes['firstname'] := FirstName;
      XMLRoot.Attributes['lastname'] := LastName;
      XMLRoot.Attributes['email'] := EMail;
      if ShowLocation then
        XMLRoot.Attributes['showlocation'] := '1'
      else
        XMLRoot.Attributes['showlocation'] := '0';
      XMLRoot.Attributes['location'] := Location;
      XMLRoot.Attributes['sexid'] := inttostr(SexID);
      XMLRoot.Attributes['affiliateid'] :=
        SessionModule.SessionSettings.ValuesAsString[RegistryAffiliateIDName];
      XMLRoot.Attributes['advertisementid'] :=
        SessionModule.SessionSettings.ValuesAsString[RegistryAdvertisementIDName];
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_Register failed', llBase);
  end;
end;

function TParserModule.Send_UpdateProfile(FirstName, LastName, Location: String;
  ShowLocation: Boolean; AvatarID, SexID: Integer): Boolean;
{
<objects>
  <object name="user">
      <uoupdateprofile userid="1213"
                       firstname="John"
                       lastname="Smith"
                       emailalerts="0|1"
                       buddyalerts="0|1"
                       showlocation="0|1"
                       location="neverland"
                       avatarid="0"
                       sexid="0"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poUser, XMLRoot, 'uoupdateprofile');
      XMLRoot.Attributes['userid'] := inttostr(UserModule.UserID);
      XMLRoot.Attributes['firstname'] := FirstName;
      XMLRoot.Attributes['lastname'] := LastName;
      XMLRoot.Attributes['location'] := Location;
      XMLRoot.Attributes['avatarid'] := inttostr(AvatarID);
      XMLRoot.Attributes['sexid'] := inttostr(SexID);

      if ShowLocation then
        XMLRoot.Attributes['showlocation'] := '1'
      else
        XMLRoot.Attributes['showlocation'] := '0';

      // for backward compatibility
      XMLRoot.Attributes['emailalerts'] := '0';
      XMLRoot.Attributes['buddyalerts'] := '0';

      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_UpdateProfile failed', llBase);
  end;
end;

function TParserModule.Send_TransferMoneyTo(UserId, Amount: Integer; TransferFrom,
  TransferTo: String): Boolean;
{
<objects>
  <object name="user">
       <uotransfermoneyto userid = "3321"
                          transferfrom = "Bill"
                          transferto = "John"
                          amount = "10"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin

  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poUser, XMLRoot, 'uotransfermoneyto');
      XMLRoot.Attributes['userid'] := UserId;
      XMLRoot.Attributes['amount'] := Amount;
      XMLRoot.Attributes['transferfrom'] := TransferFrom;
      XMLRoot.Attributes['transferto'] := TransferTo;

      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_transfermoneyto failed', llBase);
  end;
end;

function TParserModule.Send_FindPlayer(UserID: Integer;PlayerName: String): Boolean;
{
<objects>
  <object name="user">
       <uofindplayer  userid = "1234"
                      playername = "user"
                       />
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin

  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poUser, XMLRoot, 'uofindplayer');
      XMLRoot.Attributes['userid'] := UserID;
      XMLRoot.Attributes['playername'] := PlayerName;

      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_FindPlayer failed', llBase);
  end;

end;


function TParserModule.Send_ForgotPassword(LoginName, FirstName, LastName,
  EMail, Location: String; SexID: Integer): Boolean;
{
<objects>
  <object name="user">
      <uoforgotpassword loginname="1213"
                         firstname="John"
                         lastname="Smith"
                         email="player@mail.com"
                         location="neverland"
                         sexid="0"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poUser, XMLRoot, 'uoforgotpassword');
      XMLRoot.Attributes['emaildirection'] := '1'; // 0:  send to admin; 1: send to user 
      XMLRoot.Attributes['loginname'] := LoginName;
      XMLRoot.Attributes['firstname'] := FirstName;
      XMLRoot.Attributes['lastname'] := LastName;
      XMLRoot.Attributes['email'] := EMail;
      XMLRoot.Attributes['location'] := Location;
      XMLRoot.Attributes['sexid'] := inttostr(SexID);
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_ForgotPassword failed', llBase);
  end;
end;

function TParserModule.Send_ChangePassword(NewPassword, OldPassword: String): Boolean;
{
<objects>
  <object name="user">
      <uochangepassword userid="1213"
                       newpassword="12345"
                       oldpassword="qwerty"/>

  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poUser, XMLRoot, 'uochangepassword');
      XMLRoot.Attributes['userid'] := inttostr(UserModule.UserID);
      XMLRoot.Attributes['newpassword'] := NewPassword;
      XMLRoot.Attributes['oldpassword'] := OldPassword;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_ChangePassword failed', llBase);
  end;
end;

function TParserModule.Send_ChangeEMail(EMail: String): Boolean;
{
<objects>
  <object name="user">
    <uochangeemail userid="1213" email="player@mail.com"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poUser, XMLRoot, 'uochangeemail');
      XMLRoot.Attributes['userid'] := inttostr(UserModule.UserID);
      XMLRoot.Attributes['email'] := EMail;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_ChangeEMail failed', llBase);
  end;
end;

function TParserModule.Send_ValidateEMail(ValidationCode: Integer): Boolean;
{
<objects>
  <object name="user">
    <uovalidateemail userid="1213" validationcode="1213"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="user">' +
    '<uovalidateemail userid="' + inttostr(UserModule.UserID) + '" ' +
    'validationcode="' + inttostr(ValidationCode) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetProfile: Boolean;
{
<objects>
  <object name="user">
    <uogetprofile userid="1213"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="user">' +
    '<uogetprofile userid="' + inttostr(UserModule.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetStatistics: Boolean;
{
<objects>
  <object name="user">
    <uogetstatistics userid="1213"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="user">' +
    '<uogetstatistics userid="' + inttostr(UserModule.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_Login(LoginName, Password: String): Boolean;
{
<objects>
  <object name="user">
    <uologin
       loginname="player"
       password="qwerty"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poUser, XMLRoot, 'uologin');
      XMLRoot.Attributes['loginname'] := LoginName;
      XMLRoot.Attributes['password'] := Password;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_Login failed', llBase);
  end;
end;

function TParserModule.Send_Logout: Boolean;
{
<objects>
  <object name="user">
    <uologout userid="1213"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="user">' +
    '<uologout userid="' + inttostr(UserModule.UserID) + '"/>' +
    '</object></objects>');
end;



// Account

function TParserModule.Send_GetTransactionHistory(CurrencyTypeID, TopLast: Integer;
  DateStart, DateFrom: TDateTime): Boolean;
{
<objects>
  <object name="account">
    <aogethistory userid="123" currencytypeid="1"
    toplast="50" datestart="2003-11-10" dateend="2003-11-20"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="account">' +
    '<aogethistory userid="' + inttostr(UserModule.UserID) + '" ' +
    'currencytypeid="' + inttostr(CurrencyTypeID) + '" ' +
    'toplast="' + inttostr(toplast) + '" ' +
    'datestart="' + Conversions.Date2ANSI(DateStart) + '" ' +
    'dateend="' + Conversions.Date2ANSI(DateFrom) + '" ' +
    '/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetBalanceInfo: Boolean;
{
<objects>
  <object name="account">
    <aogetbalanceinfo userid="50"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="account">' +
    '<aogetbalanceinfo userid="' + inttostr(UserModule.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetMoreChips(UserId: Integer): Boolean;

{<objects>
  <object name="account">
      <aochangebalance userid="100" currencytypeid="2" amount="100|-100" type="1|2|3" reason="Blackjack game"/>
  </object>
  </objects>
}

begin
   Result := TCPSocketModule.Send(
    '<objects><object name="account">' +
      '<aochangebalance userid="' + inttostr(UserID) +'" '+
                        'currencytypeid="1" ' +
                        'amount="1000" ' +
                        'type="1" ' +
                        'reason="Player request"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetMailingAddress: Boolean;
{
<objects>
  <object name="account">
    <aogetmailingaddress userid="50"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="account">' +
    '<aogetmailingaddress userid="' + inttostr(UserModule.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_ChangeMailingAddress(FirstName, LastName, Address1,
  Address2, City, Province, ZIP, Phone: String; StateID, CountryID: Integer): Boolean;
{
<objects>
  <object name="account">
    	<aochangemailingaddress userid="50"
         firstname="John"
         lastname="Smith"
       	 address1="Independence street, 6549"
	       address2="3rd floor nalevo"
	       city="Las-Vegas"
	       countryid="1"
	       stateid="1"
         province="Nevada"
	       zip="95000"
	       phone="+100180080808080"
    	/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poAccount, XMLRoot, 'aochangemailingaddress');
      XMLRoot.Attributes['userid'] := inttostr(UserModule.UserID);
      XMLRoot.Attributes['firstname'] := FirstName;
      XMLRoot.Attributes['lastname'] := LastName;
      XMLRoot.Attributes['address1'] := Address1;
      XMLRoot.Attributes['address2'] := Address2;
      XMLRoot.Attributes['city'] := City;
      XMLRoot.Attributes['countryid'] := inttostr(CountryID);
      XMLRoot.Attributes['stateid'] := inttostr(StateID);
      XMLRoot.Attributes['province'] := Province;
      XMLRoot.Attributes['zip'] := ZIP;
      XMLRoot.Attributes['phone'] := Phone;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_ChangeMailingAddress failed', llBase);
  end;
end;

function TParserModule.Send_Deposit(CurrencyTypeID: Integer; Amount: Currency;
  PaymentSystem: TPaymentSystem; number, cvv, expmonth, expyear: String): Boolean;
{
<objects>
  <object name="account">
      <aodeposit userid="123" currencytypeid="2" amount="70.00">
        <card name="visa|mastercard|firepay" number="2000542567465" cvv="0845"
         expmonth="05" expyear="04"/>
        <neteller .../>
      </aodeposit>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
  XMLNode: IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poAccount, XMLRoot, 'aodeposit');
      XMLRoot.Attributes['userid'] := inttostr(UserModule.UserID);
      XMLRoot.Attributes['currencytypeid'] := inttostr(CurrencyTypeID);
      XMLRoot.Attributes['amount'] := Conversions.Cur2Str(Amount);

      if PaymentSystem <> psNETeller then
      begin
        XMLNode := XMLRoot.AddChild('card');
        if PaymentSystem = psVISA then
          XMLNode.Attributes['name'] := 'visa';
        if PaymentSystem = psMasterCard then
          XMLNode.Attributes['name'] := 'mastercard';
        if PaymentSystem = psFirePay then
          XMLNode.Attributes['name'] := 'firepay';

        XMLNode.Attributes['number'] := number;
        XMLNode.Attributes['cvv'] := cvv;
        XMLNode.Attributes['expmonth'] := expmonth;
        XMLNode.Attributes['expyear'] := expyear;
      end;

      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_Deposit failed', llBase);
  end;
end;

function TParserModule.Send_Withdrawal(CurrencyID: Integer;
  Amount: Currency): Boolean;
{
<objects>
  <object name="account">
    <aowithdrawal userid="123" currencytypeid="1" amount="100.55"/>
  </object>
</objects>
}
begin
  Result := TCPSocketModule.Send(
    '<objects><object name="account">' +
    '<aowithdrawal userid="' + inttostr(UserModule.UserID) + '" ' +
    'currencytypeid="' + inttostr(CurrencyID) + '" ' +
    'amount="' + Conversions.Cur2Str(Amount) + '"/>' +
    '</object></objects>');
end;


// Hand History

function TParserModule.Send_RequestHandHistory(HandID, LastHands, Direction: Integer): Boolean;
{
<objects>
  <object name="api">
    <aprequesthandhistory userid="1213" lasthands="0|1..100" handid="324|0" direction="0|1"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<aprequesthandhistory userid="' + inttostr(UserModule.UserID) + '" ' +
    'lasthands="' + inttostr(LastHands) + '" ' +
    'handid="' + inttostr(HandID) + '" ' +
    'direction="' + inttostr(Direction) + '"/>' +
    '</object></objects>');
end;


// Recorded Hands

function TParserModule.Send_SaveRecordedHands(RecordedHandList: TDataList): Boolean;
{
<objects>
  <object name="api">
      <apsaverecordedhands userid="1213">
        <hand order="1" handid="12" comment="I won all players!!!"/>
        <hand order="2" handid="13" comment="I won all players!!!"/>
        <hand order="3" handid="14" comment="I won all players!!!"/>
        <hand order="4" handid="15" comment="I won all players!!!"/>
        <hand order="5" handid="16" comment="I won all players!!!"/>
        ...
      </apsaverecordedhands >
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
  Loop: Integer;
  curData: TDataList;
  XMLNode: IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poAPI, XMLRoot, 'apsaverecordedhands');
      XMLRoot.Attributes['userid'] := inttostr(UserModule.UserID);
      for Loop := 0 to RecordedHandList.Count - 1 do
      begin
        curData := RecordedHandList.Items(Loop);
        if curData.ValuesAsInteger['handid'] > 0 then
        begin
          XMLNode := XMLRoot.AddChild('hand');
          XMLNode.Attributes['order'] := inttostr(curData.ID);
          XMLNode.Attributes['handid'] := inttostr(curData.ValuesAsInteger['handid']);
          XMLNode.Attributes['comment'] := curData.ValuesAsString['comment'];
        end;
      end;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_SaveRecordedHands failed', llBase);
  end;
end;

function TParserModule.Send_GetRecordedHands: Boolean;
{
<objects>
  <object name="api">
    <apgetrecordedhands userid="1213"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apgetrecordedhands userid="' + inttostr(UserModule.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_LoadRecordedHand(HandID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetrecordedhandhistory userid="1213" handid="123"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apgetrecordedhandhistory userid="' + inttostr(UserModule.UserID) + '" ' +
    'handid="' + inttostr(HandID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_CheckHandID(HandID, Order: Integer;
  Comment: String): Boolean;
{
<objects>
  <object name="api">
    <apcheckhandid userid="1" handid="123" order="1" comment="Holdem 3/6"/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot   : IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poAPI, XMLRoot, 'apcheckhandid');
      XMLRoot.Attributes['userid'] := inttostr(UserModule.UserID);
      XMLRoot.Attributes['order'] := inttostr(Order);
      XMLRoot.Attributes['handid'] := inttostr(HandID);
      XMLRoot.Attributes['comment'] := Comment;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_CheckHandID failed', llBase);
  end;
end;

function TParserModule.Send_ResetAllin: Boolean;
{
<objects>
  <object name="api">
    <apresetallin userid="1213"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apresetallin userid="' + inttostr(UserModule.UserID) + '"/>' +
    '</object></objects>');
end;

// Waiting List

function TParserModule.Send_GetWaitingListInfo(ProcessID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetwaitinglistinfo processid="123"/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apgetwaitinglistinfo processid="' + inttostr(ProcessID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_RegisterWaitingList(ProcessID, GroupID,
  PlayersCount: Integer): Boolean;
{
<objects>
  <object name="api">
    <apregisteratwaitinglist processid="" groupid="" playerscount=""/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apregisteratwaitinglist processid="' + inttostr(ProcessID) + '" ' +
    'groupid="' + inttostr(GroupID) + '" ' +
    'playerscount="' + inttostr(PlayersCount) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_UnregisterWaitingList(ProcessID, GroupID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apunregisterfromwaitinglist processid="" groupid=""/>
  </object>
</objects>
}
begin
  Result  := TCPSocketModule.Send(
    '<objects><object name="api">' +
    '<apunregisterfromwaitinglist processid="' + inttostr(ProcessID) + '" ' +
    'groupid="' + inttostr(GroupID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_DeclineWaitingList(ProcessID: Integer;
  Reason: String): Boolean;
{
<objects>
  <object name="gameadapter">
      <gaaction processid="1213">
        <wldecline userid="123" reason="later|unjoin|timeout"/>
      <gaaction/>
  </object>
</objects>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
  XMLNode: IXMLNode;
begin
  Result := false;
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      XMLInit(RequestXMLDoc, poGameAdaptor, XMLRoot, 'gaaction');
      XMLRoot.Attributes['processid'] := inttostr(ProcessID);
      XMLNode := XMLRoot.AddChild('wldecline');
      XMLNode.Attributes['userid'] := inttostr(UserModule.UserID);
      XMLNode.Attributes['reason'] := Reason;
      Result := XMLSend(RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ParserModule.Send_DeclineWaitingList failed', llBase);
  end;
end;




end.
