unit uBotConnection;

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, AppEvnts, ExtCtrls, ShellAPI,
  xmldom, XMLIntf, msxmldom, XMLDoc, Dialogs,
  Registry, Contnrs,
  uDataList, uTCPSocketModule;

const
  cnstWaitForConnectAfterDisconnect_Sec = 15;

type
  TConnectionState = (csNone, csTerminating, csWaiting,
    csConnecting, csConnected, csDisconnected,
    csRegistering, csRegistered, csLogging, csLogged);

  TBotConnection = class
  private
    FBotID: Integer;
    FSessionID: Integer;
    FUserID: Integer;
    FProcessIDs: TList;
    FBotName: String;
    FDisconnects: Integer;
    FConnectionState: TConnectionState;
    FTCPConnection: TTCPSocketModule;
    FLastUpdateTime: TDateTime;
    FConnectionCount: Integer;

    procedure OnConnect;
    procedure OnDisconnect;
    procedure OnCommandReceived(Command: String);
  public
    property BotID: Integer read FBotID;
    property SessionID: Integer read FSessionID;
    property UserID: Integer read FUserID;
    property ProcessIDs: TList read FProcessIDs;
    property BotName: String read FBotName;
    property Disconnects: Integer read FDisconnects;
    property ConnectionState: TConnectionState read FConnectionState;
    property LastUpdateTime: TDateTime read FLastUpdateTime write FLastUpdateTime;
    function GetConnectionState: String;

    procedure Connect;
    procedure Disconnect;
    procedure Ping;
    procedure Wait;
    procedure LeaveTable(nProcessID: Integer);
    procedure JoinToProcess(nProcessID: Integer);

    procedure RegisteredAs(ASessionID: Integer);
    procedure LoggedAs(AUserID: Integer);
    function  SendCommand(Command: String): Boolean;

    constructor Create(ABotID: Integer; ABotName: String);
    destructor Destroy; override;
  end;

implementation

uses
  uLogger, uConstants, uCommonDataModule, uBotForm;

{ TBotConnection }

constructor TBotConnection.Create(ABotID: Integer; ABotName: String);
begin
  inherited Create;

  FBotID := ABotID;
  FSessionID := 0;
  FUserID := 0;
  FProcessIDs := TList.Create;
  FDisconnects := 0;
  FConnectionState := csNone;
  FConnectionCount := 0;
  FBotName := ABotName;
  FLastUpdateTime := Now;
  FTCPConnection := TTCPSocketModule.Create(nil);
  FTCPConnection.BotID := FBotID;
  FTCPConnection.OnConnect := OnConnect;
  FTCPConnection.OnDisconnect := OnDisconnect;
  FTCPConnection.OnCommandReceived := OnCommandReceived;

  Logger.Log(FBotID, ClassName, 'Create', 'Created sucessfully', ltBase);
end;

destructor TBotConnection.Destroy;
begin
  FConnectionState := csTerminating;
  Disconnect;
  FTCPConnection.Free;
  FProcessIDs.Free;
  FBotName := '';
  Logger.Log(FBotID, ClassName, 'Destroy', 'Destroyed sucessfully', ltBase);

  inherited;
end;

procedure TBotConnection.Connect;
var
  Index: Integer;
  strText: String;
  strList: TStringList;
begin
  Logger.Log(FBotID, ClassName, 'Connect', 'Run', ltCall);

  FConnectionState := csConnecting;
  FConnectionCount := 0;
  case CommonDataModule.SessionSettings.ValuesAsInteger[BotSSL] of
    1: FTCPConnection.SecurityMethod := smSSL;
    2: FTCPConnection.SecurityMethod := smBlowFish;
  else
    FTCPConnection.SecurityMethod := smNone;
  end;

  strList := TStringList.Create;
  Randomize;

  strText := CommonDataModule.SessionSettings.ValuesAsString[BotRemoteHost];
  if strText = '' then
    strText := RemoteHost;

  if strText <> '' then
  begin
    strList.Text := StringReplace(strText, ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
    if strList.Count > 0 then
      if strList.Count = 1 then
        FTCPConnection.RemoteHost := strList.Strings[0]
      else
      begin
        Index := Random(strList.Count);
        if Index < 0 then
          Index := 0;
        if Index >= strList.Count then
          Index := strList.Count - 1;
        FTCPConnection.RemoteHost := strList.Strings[Index];
      end;
  end;

  strText := CommonDataModule.SessionSettings.ValuesAsString[BotRemotePort];
  if strText = '' then
    strText := RemotePort;

  if strText <> '' then
  begin
    strList.Text := StringReplace(strText, ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
    if strList.Count > 0 then
    begin
      if strList.Count = 1 then
        FTCPConnection.RemotePort := StrToIntDef(strList.Strings[0], 0)
      else
      begin
        Index := Random(strList.Count);
        if Index < 0 then
          Index := 0;
        if Index >= strList.Count then
          Index := strList.Count - 1;
        FTCPConnection.RemotePort := StrToIntDef(strList.Strings[Index], 0);
      end;
    end;
  end;

  strList.Free;

  if (FTCPConnection.RemoteHost <> '') and (FTCPConnection.RemotePort > 0) then
    FTCPConnection.Connect
end;

procedure TBotConnection.Disconnect;
begin
  if (FConnectionState <> csDisconnected) and (FConnectionState <> csWaiting) and
    (FConnectionState <> csTerminating) and (FConnectionState <> csNone) then
  begin
    Logger.Log(FBotID, ClassName, 'Disconnect', 'Run', ltCall);

    FSessionID := 0;
    FConnectionCount := 0;
    Inc(FDisconnects);

    FConnectionState := csWaiting;

    if FUserID > 0 then
      BotForm.BotDisconnect(FUserID);
    FTCPConnection.Disconnect;
  end;
end;

function TBotConnection.SendCommand(Command: String): Boolean;
begin
  Logger.Log(FBotID, ClassName, 'Send', Command, ltRequest);
  Result := FTCPConnection.Send(Command);
end;

procedure TBotConnection.OnCommandReceived(Command: String);
begin
  Logger.Log(FBotID, ClassName, 'OnCommandReceived', Command, ltResponse);
  CommonDataModule.ParseCommand(FBotID, Command);
end;

procedure TBotConnection.OnConnect;
begin
  Logger.Log(FBotID, ClassName, 'OnSocketConnected', 'Connected', ltCall);
  FConnectionState := csConnected;
end;

procedure TBotConnection.OnDisconnect;
begin
  Logger.Log(FBotID, ClassName, 'OnSocketDisconnected', 'Disconnected by Socket', ltCall);
  Disconnect;
end;

procedure TBotConnection.RegisteredAs(ASessionID: Integer);
begin
  if ASessionID > 0 then
  begin
    FSessionID := ASessionID;
    FConnectionState := csRegistered;
  end
  else
  begin
    Logger.Log(FBotID, ClassName, 'RegisteredAs',
      'Incorrect SessionID=' + inttostr(ASessionID), ltError);
    Disconnect;
  end;
end;

procedure TBotConnection.LoggedAs(AUserID: Integer);
begin
  if AUserID > 0 then
  begin
    FUserID := AUserID;
    FConnectionState := csLogged;
    if FUserID > 0 then
      BotForm.BotReconnect(FUserID);
  end
  else
    Logger.Log(FBotID, ClassName, 'LoggedAs',
      'Incorrect UserID=' + inttostr(AUserID), ltError);
end;

function TBotConnection.GetConnectionState: String;
begin
  case FConnectionState of
    csNone : Result := 'None';
    csTerminating : Result := 'Terminating';
    csWaiting : Result := 'Waiting';
    csConnecting : Result := 'Connecting';
    csConnected : Result := 'Connected';
    csDisconnected : Result := 'Disconnected';
    csRegistering : Result := 'Registering';
    csRegistered : Result := 'Registered';
    csLogging : Result := 'Logging';
    csLogged : Result := 'Logged';
  else
    Result := 'Unknown';
  end;
end;

procedure TBotConnection.Ping;
begin
  FTCPConnection.RingUp;
end;

procedure TBotConnection.Wait;
begin
  Inc(FConnectionCount);
  if FConnectionCount > cnstWaitForConnectAfterDisconnect_Sec then
    FConnectionState := csDisconnected;
end;

procedure TBotConnection.LeaveTable(nProcessID: Integer);
begin
  FProcessIDs.Remove(Pointer(nProcessID));
end;

procedure TBotConnection.JoinToProcess(nProcessID: Integer);
begin
  FProcessIDs.Remove(Pointer(nProcessID));
  FProcessIDs.Add(Pointer(nProcessID));
end;

end.

