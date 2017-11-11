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
  uMacTool, uConstants, uDataList, uCommonDataModule, uBotConnection;

type
  TServerObject = (poAPI, poFileManager, poUser, poGameAdaptor, poAccount,
    potournament, poBuddyWager);

  TParserModule = class(TDataModule)
  private
    function XMLInit(BotConnection: TBotConnection;
      XMLDoc: TXMLDocument; ServerObject: TServerObject;
      var XMLRoot: IXMLNode; RootName: String): Boolean;
    function XMLSend(BotConnection: TBotConnection;
      XMLDoc: TXMLDocument): Boolean;
  public
    // Dispatch
    function Send_Connect(BotConnection: TBotConnection): Boolean;

    // References
    function Send_GetReferences(BotConnection: TBotConnection): Boolean;

    // Lobby
    function Send_UpdateSummary(BotConnection: TBotConnection): Boolean;
    function Send_GetProcesses(BotConnection: TBotConnection;
      SubCategoryID: Integer): Boolean;
    function Send_GetProcessInfo(BotConnection: TBotConnection;
      ProcessID: Integer): Boolean;
    function Send_UpdateLobbyInfo(BotConnection: TBotConnection;
      SubCategoryID, ProcessID: Integer): Boolean;
    function Send_CustomSupport(BotConnection: TBotConnection;
      msgSubject, msgBody: String): Boolean;

    // Process
    function Send_GetNotes(BotConnection: TBotConnection;
      ForUserID: Integer): Boolean;
    function Send_SaveNotes(BotConnection: TBotConnection;
      ForUserID: Integer; Notes: String): Boolean;
    function Send_SaveRecordedHands(BotConnection: TBotConnection;
      RecordedHandList: TDataList): Boolean;
    function Send_GetRecordedHands(BotConnection: TBotConnection): Boolean;
    function Send_LoadRecordedHand(BotConnection: TBotConnection;
      HandID: Integer): Boolean;
    function Send_RequestHandHistory(BotConnection: TBotConnection;
      HandID, LastHands, Direction: Integer): Boolean;
    function Send_CheckHandID(BotConnection: TBotConnection;
      HandID, Order: Integer; Comment: String): Boolean;
    function Send_ResetAllin(BotConnection: TBotConnection): Boolean;

    function Send_GetWaitingListInfo(BotConnection: TBotConnection;
      ProcessID: Integer): Boolean;
    function Send_RegisterWaitingList(BotConnection: TBotConnection;
      ProcessID, GroupID, PlayersCount: Integer): Boolean;
    function Send_UnregisterWaitingList(BotConnection: TBotConnection;
      ProcessID, GroupID: Integer): Boolean;
    function Send_DeclineWaitingList(BotConnection: TBotConnection;
      ProcessID: Integer; Reason: String): Boolean;

    // Tournament
    function Send_GetTournaments(BotConnection: TBotConnection): Boolean;
    function Send_GetTournamentInfo(BotConnection: TBotConnection;
      TournamentID: Integer): Boolean;
    function Send_GetTournamentLobbyInfo(BotConnection: TBotConnection;
      TournamentID: Integer): Boolean;
    function Send_GetTournamentPlayers(BotConnection: TBotConnection;
      TournamentID: Integer): Boolean;
    function Send_GetTournamentProcesses(BotConnection: TBotConnection;
      TournamentID: Integer): Boolean;
    function Send_GetTournamentProcessPlayers(BotConnection: TBotConnection;
      TournamentID, ProcessID: Integer): Boolean;
    function Send_GetTournamentRegister(BotConnection: TBotConnection;
      TournamentID: Integer): Boolean;

    // File manager
    function Send_GetFileInfo(BotConnection: TBotConnection;
      FileID: Integer): Boolean;
    function Send_GetSystemFiles(BotConnection: TBotConnection): Boolean;
    function Send_GetProcessFiles(BotConnection: TBotConnection;
      ProcessID: Integer): Boolean;

    // User
    function Send_Register(BotConnection: TBotConnection;
      LoginName, Password, FirstName, LastName, EMail, Location: String;
      ShowLocation: Boolean; SexID: Integer): Boolean;
    function Send_ForgotPassword(BotConnection: TBotConnection;
      LoginName, FirstName, LastName, EMail, Location: String; SexID: Integer): Boolean;
    function Send_ChangePassword(BotConnection: TBotConnection;
      NewPassword, OldPassword: String): Boolean;
    function Send_ChangeEMail(BotConnection: TBotConnection;
      EMail: String): Boolean;
    function Send_ValidateEMail(BotConnection: TBotConnection;
      ValidationCode: Integer): Boolean;
    function Send_GetProfile(BotConnection: TBotConnection): Boolean;
    function Send_UpdateProfile(BotConnection: TBotConnection;
      FirstName, LastName, Location: String; ShowLocation, EMailAlerts, BuddyAlerts: Boolean;
      AvatarID, SexID: Integer): Boolean;
    function Send_GetStatistics(BotConnection: TBotConnection): Boolean;
    function Send_Login(BotConnection: TBotConnection;
      LoginName, Password: String): Boolean;
    function Send_Logout(BotConnection: TBotConnection): Boolean;
    function Send_PopupMessagesHistory(BotConnection: TBotConnection): Boolean;

    // Account
    function Send_GetBalanceInfo(BotConnection: TBotConnection): Boolean;
    function Send_GetMailingAddress(BotConnection: TBotConnection): Boolean;
    function Send_ChangeMailingAddress(BotConnection: TBotConnection;
      FirstName,LastName, Address1, Address2, City, Province, ZIP, Phone: String;
      StateID, CountryID: Integer): Boolean;
    function Send_Deposit(BotConnection: TBotConnection;
      CurrencyTypeID: Integer; Amount: Currency; PaymentSystem: TPaymentSystem; number, cvv,
      expmonth, expyear: String): Boolean;
    function Send_Withdrawal(BotConnection: TBotConnection;
      CurrencyID: Integer; Amount: Currency): Boolean;
    function Send_GetTransactionHistory(BotConnection: TBotConnection;
      CurrencyTypeID, TopLast: Integer; DateStart, DateFrom: TDateTime): Boolean;
  end;

var
  ParserModule: TParserModule;

implementation

{$R *.dfm}

uses
  uLogger, uConversions;

// Common send commands

function TParserModule.XMLInit(BotConnection: TBotConnection;
  XMLDoc: TXMLDocument; ServerObject: TServerObject;
  var XMLRoot: IXMLNode; RootName: String): Boolean;
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
      poBuddyWager:
        XMLRoot.Attributes['name'] := 'buddywager';
    end;
    XMLRoot  := XMLRoot.AddChild(RootName);
    Result := true;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.XMLSend(BotConnection: TBotConnection;
  XMLDoc: TXMLDocument): Boolean;
var
  Command: String;
begin
  Result := false;
  if XMLDoc <> nil then
  try
    Command := XMLDoc.XML.Text;
    Result  := BotConnection.SendCommand(Command);
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;

  Command := '';
end;


// Send commands

// Dispatch

function TParserModule.Send_Connect(BotConnection: TBotConnection): Boolean;
{
<connect csaid="1" csabuild="1" affiliateid="1"/>
}
var
  InternalHost, InternalIP: String;
begin
  GetLocalHostAndIP(InternalHost, InternalIP);
  Result  := BotConnection.SendCommand('<connect csaid="' + inttostr(CSA_ID) +
    '" csabuild="' + inttostr(CSA_Build) +
    '" affiliateid="' + inttostr(CSA_AffiliateID) +
    '" advertisementid="1' +
    '" macaddress="' + GetMACAddress +
    '" internalip="' + InternalIP +
    '" internalhost="' + InternalHost +
    '"/>');

  InternalHost := '';
  InternalIP   := '';
end;


// References

function TParserModule.Send_GetReferences(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="api">
    <apgetcurrencies/>
    <apgetstats/>
    <apgetcategories/>
    <apgetcountries/>
    <apgetstates/>
  </object>
</objects>

}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apgetcountries/>' +
    '<apgetstates/>' +
    '<apgetcurrencies/>' +
    '<apgetstats/>' +
    '<apgetcategories/>' +
    '</object></objects>');
end;

// Lobby

function TParserModule.Send_UpdateSummary(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="api">
    <apupdatesummary/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apupdatesummary/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetProcesses(BotConnection: TBotConnection;
  SubCategoryID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetprocesses subcategoryid="1"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apgetprocesses subcategoryid="' + inttostr(SubCategoryID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetProcessInfo(BotConnection: TBotConnection;
  ProcessID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetprocessinfo processid="1213"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apgetprocessinfo processid="' + inttostr(ProcessID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_UpdateLobbyInfo(BotConnection: TBotConnection;
  SubCategoryID, ProcessID: Integer): Boolean;
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
  Result  := BotConnection.SendCommand(strXML + '</object></objects>');

  strXML := '';
end;

function TParserModule.Send_CustomSupport(BotConnection: TBotConnection;
  msgSubject, msgBody: String): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poAPI, XMLRoot, 'apcustomsupport');
      XMLRoot.Attributes['subject'] := msgSubject;
      XMLRoot.Attributes['message'] := msgBody;
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;


// Process

function TParserModule.Send_GetNotes(BotConnection: TBotConnection;
  ForUserID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetnotes userid="1213" foruserid="324"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apgetnotes userid="' + inttostr(BotConnection.UserID) + '" ' +
    'foruserid="' + inttostr(ForUserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_SaveNotes(BotConnection: TBotConnection;
  ForUserID: Integer; Notes: String): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poAPI, XMLRoot, 'apsavenotes');
      XMLRoot.Attributes['userid'] := inttostr(BotConnection.UserID);
      XMLRoot.Attributes['foruserid'] := inttostr(ForUserID);
      XMLRoot.Attributes['notes'] := Notes;
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

// Tournament

function TParserModule.Send_GetTournaments(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="tournament">
    <togettournaments/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="tournament">' +
    '<togettournaments/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentInfo(BotConnection: TBotConnection;
  TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togettournamentinfo tournamentid="1"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="tournament">' +
    '<togettournamentinfo tournamentid="' + inttostr(TournamentID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentLobbyInfo(BotConnection: TBotConnection;
  TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togetinfo tournamentid="123"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="tournament">' +
    '<togetinfo tournamentid="' + inttostr(TournamentID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentPlayers(BotConnection: TBotConnection;
  TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togetplayers tournamentid="123"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="tournament">' +
    '<togetplayers tournamentid="' + inttostr(TournamentID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentProcesses(BotConnection: TBotConnection;
  TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <togetprocesses tournamentid="123"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="tournament">' +
    '<togetprocesses tournamentid="' + inttostr(TournamentID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetTournamentProcessPlayers(BotConnection: TBotConnection;
  TournamentID, ProcessID: Integer): Boolean;
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
    Result  := BotConnection.SendCommand(
      '<objects><object name="tournament">' +
      '<togetprocessplayers tournamentid="' + inttostr(TournamentID) + '" ' +
      'processid="' + inttostr(ProcessID) + '"/>' +
      '</object></objects>');
end;

function TParserModule.Send_GetTournamentRegister(BotConnection: TBotConnection;
  TournamentID: Integer): Boolean;
{
<objects>
  <object name="tournament">
    <toregister Tournamentid="123" userid="345"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="tournament">' +
    '<toregister tournamentid="' + inttostr(TournamentID) + '" ' +
    'userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;


// File Manager

function TParserModule.Send_GetFileInfo(BotConnection: TBotConnection;
  FileID: Integer): Boolean;
{
<objects>
  <object name="filemanager">
    <fmgetfileinfo fileid="234"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="filemanager">' +
    '<fmgetfileinfo fileid="' + inttostr(FileID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetProcessFiles(BotConnection: TBotConnection;
  ProcessID: Integer): Boolean;
{
<objects>
  <object name="filemanager">
    <fmgetprocessfiles processid="234"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="filemanager">' +
    '<fmgetprocessfiles processid="' + inttostr(ProcessID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetSystemFiles(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="filemanager">
    <fmgetsystemfiles/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="filemanager">' +
    '<fmgetsystemfiles/>' +
    '</object></objects>');
end;


// User

function TParserModule.Send_Register(BotConnection: TBotConnection;
  LoginName, Password, FirstName, LastName, EMail, Location: String;
  ShowLocation: Boolean; SexID: Integer): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poUser, XMLRoot, 'uoregister');
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
      XMLRoot.Attributes['affiliateid'] := inttostr(CSA_AffiliateID);
      XMLRoot.Attributes['advertisementid'] := '1';
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_UpdateProfile(BotConnection: TBotConnection;
  FirstName, LastName, Location: String;
  ShowLocation, EMailAlerts, BuddyAlerts: Boolean;
  AvatarID, SexID: Integer): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poUser, XMLRoot, 'uoupdateprofile');
      XMLRoot.Attributes['userid'] := inttostr(BotConnection.UserID);
      XMLRoot.Attributes['firstname'] := FirstName;
      XMLRoot.Attributes['lastname'] := LastName;
      XMLRoot.Attributes['location'] := Location;
      XMLRoot.Attributes['avatarid'] := inttostr(AvatarID);
      XMLRoot.Attributes['sexid'] := inttostr(SexID);

      if ShowLocation then
        XMLRoot.Attributes['showlocation'] := '1'
      else
        XMLRoot.Attributes['showlocation'] := '0';

      if EMailAlerts then
        XMLRoot.Attributes['emailalerts'] := '1'
      else
        XMLRoot.Attributes['emailalerts'] := '0';

      if BuddyAlerts then
        XMLRoot.Attributes['buddyalerts'] := '1'
      else
        XMLRoot.Attributes['buddyalerts'] := '0';

      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_ForgotPassword(BotConnection: TBotConnection;
  LoginName, FirstName, LastName, EMail, Location: String; SexID: Integer): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poUser, XMLRoot, 'uoforgotpassword');
      XMLRoot.Attributes['loginname'] := LoginName;
      XMLRoot.Attributes['firstname'] := FirstName;
      XMLRoot.Attributes['lastname'] := LastName;
      XMLRoot.Attributes['email'] := EMail;
      XMLRoot.Attributes['location'] := Location;
      XMLRoot.Attributes['sexid'] := inttostr(SexID);
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_ChangePassword(BotConnection: TBotConnection;
  NewPassword, OldPassword: String): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poUser, XMLRoot, 'uochangepassword');
      XMLRoot.Attributes['userid'] := inttostr(BotConnection.UserID);
      XMLRoot.Attributes['newpassword'] := NewPassword;
      XMLRoot.Attributes['oldpassword'] := OldPassword;
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_ChangeEMail(BotConnection: TBotConnection;
  EMail: String): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poUser, XMLRoot, 'uochangeemail');
      XMLRoot.Attributes['userid'] := inttostr(BotConnection.UserID);
      XMLRoot.Attributes['email'] := EMail;
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_ValidateEMail(BotConnection: TBotConnection;
  ValidationCode: Integer): Boolean;
{
<objects>
  <object name="user">
    <uovalidateemail userid="1213" validationcode="1213"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="user">' +
    '<uovalidateemail userid="' + inttostr(BotConnection.UserID) + '" ' +
    'validationcode="' + inttostr(ValidationCode) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetProfile(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="user">
    <uogetprofile userid="1213"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="user">' +
    '<uogetprofile userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetStatistics(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="user">
    <uogetstatistics userid="1213"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="user">' +
    '<uogetstatistics userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_Login(BotConnection: TBotConnection;
  LoginName, Password: String): Boolean;
{
<objects>
  <object name="user">
    <uologin loginname="player" password="qwerty"/>
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
      XMLInit(BotConnection, RequestXMLDoc, poUser, XMLRoot, 'uologin');
      XMLRoot.Attributes['loginname'] := LoginName;
      XMLRoot.Attributes['password'] := Password;
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_Logout(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="user">
    <uologout userid="1213"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="user">' +
    '<uologout userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_PopupMessagesHistory(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="user">
    <uopopupmessageshistory userid="1213"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="user">' +
    '<uopopupmessageshistory userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;


// Account

function TParserModule.Send_GetTransactionHistory(BotConnection: TBotConnection;
  CurrencyTypeID, TopLast: Integer; DateStart, DateFrom: TDateTime): Boolean;
{
<objects>
  <object name="account">
    <aogethistory userid="123" currencytypeid="1"
    toplast="50" datestart="2003-11-10" dateend="2003-11-20"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="account">' +
    '<aogethistory userid="' + inttostr(BotConnection.UserID) + '" ' +
    'currencytypeid="' + inttostr(CurrencyTypeID) + '" ' +
    'toplast="' + inttostr(toplast) + '" ' +
    'datestart="' + Conversions.Date2ANSI(DateStart) + '" ' +
    'dateend="' + Conversions.Date2ANSI(DateFrom) + '" ' +
    '/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetBalanceInfo(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="account">
    <aogetbalanceinfo userid="50"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="account">' +
    '<aogetbalanceinfo userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_GetMailingAddress(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="account">
    <aogetmailingaddress userid="50"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="account">' +
    '<aogetmailingaddress userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_ChangeMailingAddress(BotConnection: TBotConnection;
  FirstName, LastName, Address1, Address2, City, Province, ZIP, Phone: String;
  StateID, CountryID: Integer): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poAccount, XMLRoot, 'aochangemailingaddress');
      XMLRoot.Attributes['userid'] := inttostr(BotConnection.UserID);
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
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_Deposit(BotConnection: TBotConnection;
  CurrencyTypeID: Integer; Amount: Currency;
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
      XMLInit(BotConnection, RequestXMLDoc, poAccount, XMLRoot, 'aodeposit');
      XMLRoot.Attributes['userid'] := inttostr(BotConnection.UserID);
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

      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_Withdrawal(BotConnection: TBotConnection;
  CurrencyID: Integer; Amount: Currency): Boolean;
{
<objects>
  <object name="account">
    <aowithdrawal userid="123" currencytypeid="1" amount="100.55"/>
  </object>
</objects>
}
begin
  Result := BotConnection.SendCommand(
    '<objects><object name="account">' +
    '<aowithdrawal userid="' + inttostr(BotConnection.UserID) + '" ' +
    'currencytypeid="' + inttostr(CurrencyID) + '" ' +
    'amount="' + Conversions.Cur2Str(Amount) + '"/>' +
    '</object></objects>');
end;


// Hand History

function TParserModule.Send_RequestHandHistory(BotConnection: TBotConnection;
  HandID, LastHands, Direction: Integer): Boolean;
{
<objects>
  <object name="api">
    <aprequesthandhistory userid="1213" lasthands="0|1..100" handid="324|0" direction="0|1"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<aprequesthandhistory userid="' + inttostr(BotConnection.UserID) + '" ' +
    'lasthands="' + inttostr(LastHands) + '" ' +
    'handid="' + inttostr(HandID) + '" ' +
    'direction="' + inttostr(Direction) + '"/>' +
    '</object></objects>');
end;


// Recorded Hands

function TParserModule.Send_SaveRecordedHands(BotConnection: TBotConnection;
  RecordedHandList: TDataList): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poAPI, XMLRoot, 'apsaverecordedhands');
      XMLRoot.Attributes['userid'] := inttostr(BotConnection.UserID);
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
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_GetRecordedHands(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="api">
    <apgetrecordedhands userid="1213"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apgetrecordedhands userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_LoadRecordedHand(BotConnection: TBotConnection;
  HandID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetrecordedhandhistory userid="1213" handid="123"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apgetrecordedhandhistory userid="' + inttostr(BotConnection.UserID) + '" ' +
    'handid="' + inttostr(HandID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_CheckHandID(BotConnection: TBotConnection;
  HandID, Order: Integer; Comment: String): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poAPI, XMLRoot, 'apcheckhandid');
      XMLRoot.Attributes['userid'] := inttostr(BotConnection.UserID);
      XMLRoot.Attributes['order'] := inttostr(Order);
      XMLRoot.Attributes['handid'] := inttostr(HandID);
      XMLRoot.Attributes['comment'] := Comment;
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;

function TParserModule.Send_ResetAllin(BotConnection: TBotConnection): Boolean;
{
<objects>
  <object name="api">
    <apresetallin userid="1213"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apresetallin userid="' + inttostr(BotConnection.UserID) + '"/>' +
    '</object></objects>');
end;

// Waiting List

function TParserModule.Send_GetWaitingListInfo(BotConnection: TBotConnection;
  ProcessID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apgetwaitinglistinfo processid="123"/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apgetwaitinglistinfo processid="' + inttostr(ProcessID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_RegisterWaitingList(BotConnection: TBotConnection;
  ProcessID, GroupID, PlayersCount: Integer): Boolean;
{
<objects>
  <object name="api">
    <apregisteratwaitinglist processid="" groupid="" playerscount=""/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apregisteratwaitinglist processid="' + inttostr(ProcessID) + '" ' +
    'groupid="' + inttostr(GroupID) + '" ' +
    'playerscount="' + inttostr(PlayersCount) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_UnregisterWaitingList(BotConnection: TBotConnection;
  ProcessID, GroupID: Integer): Boolean;
{
<objects>
  <object name="api">
    <apunregisterfromwaitinglist processid="" groupid=""/>
  </object>
</objects>
}
begin
  Result  := BotConnection.SendCommand(
    '<objects><object name="api">' +
    '<apunregisterfromwaitinglist processid="' + inttostr(ProcessID) + '" ' +
    'groupid="' + inttostr(GroupID) + '"/>' +
    '</object></objects>');
end;

function TParserModule.Send_DeclineWaitingList(BotConnection: TBotConnection;
  ProcessID: Integer; Reason: String): Boolean;
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
      XMLInit(BotConnection, RequestXMLDoc, poGameAdaptor, XMLRoot, 'gaaction');
      XMLRoot.Attributes['processid'] := inttostr(ProcessID);
      XMLNode := XMLRoot.AddChild('wldecline');
      XMLNode.Attributes['userid'] := inttostr(BotConnection.UserID);
      XMLNode.Attributes['reason'] := Reason;
      Result := XMLSend(BotConnection, RequestXMLDoc);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'XMLInit', E.Message, ltException);
  end;
end;




end.
