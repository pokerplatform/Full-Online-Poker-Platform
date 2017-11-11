unit uActionClient;

// OffshoreCreations Inc. (C) 2004
// Author: Maxim Korablev

interface

uses
  SysUtils, Classes, ExtCtrls, Forms,
  Windows, Messages, Sockets, SyncObjs,
  uSessionProcessor, uSessionUtils;

const
  cntConnectPacketResendTime_Sec = 100;

type
  TActionClient = class(TThread)
  private
    FClientSocket: TTCPClient;
    FSessionProcessor: TSessionProcessor;
    FActionDispatcherID: Integer;
    FDispHost: String;
    FDispPort: String;
    FConnected: Boolean;
    FConnectAllowed: Boolean;
    FLastConnectPacketResendTime: TDateTime;

    procedure OnSessionOpened(ASessionProcessor: TSessionProcessor; var ASessionID: Integer);
    procedure OnSessionClosed(ASessionProcessor: TSessionProcessor);
    procedure OnSessionCommand(ASessionProcessor: TSessionProcessor; const ACommand: String);
    procedure SendCommand(ActionXML: String);
    function GetConnectString: String;
  protected
    procedure Execute; override;
  public
    property Connected: Boolean read FConnected;
    property ActionDispatcherID: Integer read FActionDispatcherID;

    procedure SendAction(ActionXML: String);
    procedure Connect;
    procedure Disconnect;

    constructor Create(ActionDispatcherID: Integer; ADispHost, ADispPort: String);
    destructor Destroy; override;
  end;

implementation

uses
  uCommonDataModule, uLogger, uXMLConstants, uSettings, uServiceDataModule,
  DateUtils;

{ TActionClient }

constructor TActionClient.Create(ActionDispatcherID: Integer; ADispHost, ADispPort: String);
begin
  inherited Create(True);

  FConnected := False;
  FConnectAllowed := False;
  FActionDispatcherID := ActionDispatcherID;
  FDispHost := ADispHost;
  FDispPort := ADispPort;
  FLastConnectPacketResendTime := Now;

  FSessionProcessor := nil;
  FClientSocket := nil;

  CommonDataModule.Log(ClassName, 'Create', inttostr(FActionDispatcherID) + ': ' +
    'Created sucessfully, ActionDispatcherID: ' + inttostr(ActionDispatcherID) +
    ', Host: ' + ADispHost + ', Port: ' + ADispPort, ltBase);
  Resume;
end;

destructor TActionClient.Destroy;
begin
  Disconnect;
  Terminate;
  WaitFor;

  CommonDataModule.Log(ClassName, 'Destroy', inttostr(FActionDispatcherID) + ': ' +
    'Destroyed successfully', ltBase);

  inherited;
end;

procedure TActionClient.Connect;
begin
  FConnectAllowed := True;
  if FConnected and
    (SecondsBetween(Now, FLastConnectPacketResendTime) > cntConnectPacketResendTime_Sec) then
  begin
    SendCommand(GetConnectString);
    FLastConnectPacketResendTime := Now;
  end;
end;

procedure TActionClient.Disconnect;
begin
  FConnectAllowed := False;
  try
    if FSessionProcessor <> nil then
      FSessionProcessor.Stop;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Disconnect', E.Message, ltException);
  end;
end;

procedure TActionClient.OnSessionClosed(ASessionProcessor: TSessionProcessor);
begin
  FConnected := False;
  FConnectAllowed := False;
end;

procedure TActionClient.OnSessionOpened(ASessionProcessor: TSessionProcessor;
  var ASessionID: Integer);
begin
  ASessionID := FActionDispatcherID;

  // Send invitation to the ActionDispatcherServer
  SendCommand(GetConnectString);
  FLastConnectPacketResendTime := Now;
  FConnected := True;
end;

function TActionClient.GetConnectString: String;
begin
  Result := '';

  if stClientAdapter in CommonDataModule.ServiceModes then
    Result := Result + '<type name="' + OBJ_CLIENTADAPTER + '"/>';

  if stActionProcessor in CommonDataModule.ServiceModes then
    Result := Result + '<type name="' + OBJ_ACTIONProcessor + '"/>';

  if stActionDispatcher in CommonDataModule.ServiceModes then
    Result := Result + '<type name="' + OBJ_ACTIONDISPATCHER + '"/>';

  if stMSMQReader in CommonDataModule.ServiceModes then
    Result := Result + '<type name="' + OBJ_MSMQReader + '"/>';

  if stMSMQWriter in CommonDataModule.ServiceModes then
    Result := Result + '<type name="' + OBJ_MSMQWriter + '"/>';

  if stReminder in CommonDataModule.ServiceModes then
    Result := Result + '<type name="' + OBJ_REMINDER + '"/>';

  if stTournament in CommonDataModule.ServiceModes then
    Result := Result + '<type name="' + OBJ_TOURNAMENT + '"/>';

  if stGameAdapter in CommonDataModule.ServiceModes then
    Result := Result + '<type name="' + OBJ_GameAdapter + '"/>';

  Result := '<connect ' +
    AD_ServiceName + '="' + CommonDataModule.ServiceName + '" ' +
    AD_ActionDispatcherID + '="' + inttostr(CommonDataModule.ActionDispatcherID) +
    '" port="' + inttostr(CommonDataModule.ClientAdapterPort) + '">' +
    Result + '</connect>';
end;

procedure TActionClient.OnSessionCommand(ASessionProcessor: TSessionProcessor;
  const ACommand: String);
var
  Loop: Integer;
  EndPos: Integer;
  ProcessID: Integer;
  Command: String;
  Destinations: String;
  DestinationList: TStringList;
  SessionIDs: array of Integer;
begin
  if CommonDataModule.Logging then
    CommonDataModule.Log(ClassName, 'OnSessionCommand', inttostr(FActionDispatcherID) + ': ' +
      ACommand, ltResponse);

  if ACommand[1] = cntHeaderClientAdapterSignature then
  begin
    EndPos := Pos(cntHeaderEndSignature, ACommand);
    Command := copy(ACommand, EndPos + 1, MAXINT);
    Destinations := copy(ACommand, 2, EndPos - 2);
    SetLength(SessionIDs, 0);
    DestinationList := TStringList.Create;
    DestinationList.Text := StringReplace(copy(Destinations, 1, EndPos - 1),
      ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
    if DestinationList.Count > 0 then
    begin
      SetLength(SessionIDs, DestinationList.Count);
      for Loop := 0 to DestinationList.Count - 1 do
        SessionIDs[Loop] := strtointdef(DestinationList.Strings[Loop], 0);
    end;
    DestinationList.Free;
    CommonDataModule.NotifyClients(SessionIDs, Command);
  end
  else
  if ACommand[1] = cntHeaderGameAdapterSignature then
  begin
    EndPos := Pos(cntHeaderEndSignature, ACommand);
    ProcessID := strtointdef(copy(ACommand, 2, EndPos - 2), 0);
    Command := copy(ACommand, EndPos + 1, MAXINT);
    CommonDataModule.ProcessGameAction(ProcessID, Command);
  end
  else
  if ACommand[1] = cntUpdatePacketsSignature then
    CommonDataModule.ReceiveUpdatePacket(copy(ACommand, 2, MAXINT))
  else
    CommonDataModule.ProcessAction(ACommand);
end;

procedure TActionClient.SendAction(ActionXML: String);
begin
  if FConnected then
    SendCommand(ActionXML);
end;

procedure TActionClient.SendCommand(ActionXML: String);
begin
  FSessionProcessor.SendCommand(ActionXML);
  if CommonDataModule.Logging then
    CommonDataModule.Log(ClassName, 'SendCommand', 'ActionDispatcherID=' +
      inttostr(FActionDispatcherID) + ', Action: ' + ActionXML, ltRequest);
end;

procedure TActionClient.Execute;
begin
  inherited;

  CommonDataModule.Log(ClassName, 'Execute', inttostr(FActionDispatcherID) + ': ' +
    'Thread has been started', ltBase);
  repeat
    try
      repeat
        Sleep(10);
      until FConnectAllowed or Terminated;

      if Terminated then
        Break;

      FClientSocket := TTCPClient.Create(nil);
      try
        FClientSocket.BlockMode := bmBlocking;
        FClientSocket.RemoteHost := FDispHost;
        FClientSocket.RemotePort := FDispPort;

        FSessionProcessor := TSessionProcessor.Create(FClientSocket, Self, 10, 3,
          stClient, False, OnSessionOpened, OnSessionClosed, OnSessionCommand);
        try
          if FClientSocket.Connect then
          begin
            CommonDataModule.Log(ClassName, 'Execute', inttostr(FActionDispatcherID) + ': ' +
              'Connected', ltBase);

            // Start main processing loop
            FSessionProcessor.ProcessSession;
            CommonDataModule.Log(ClassName, 'Execute', inttostr(FActionDispatcherID) + ': ' +
              'Disconnected', ltBase);
          end
          else
            CommonDataModule.Log(ClassName, 'Execute', inttostr(FActionDispatcherID) + ': ' +
              'Can not connect to ActionServer', ltError);
        finally
          FSessionProcessor.Free;
        end;
      finally
        FClientSocket.Free;
      end;
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'Execute', inttostr(FActionDispatcherID) + ': ' +
          E.Message, ltException);
    end;
    FConnected := False;
    FConnectAllowed := False;
    FSessionProcessor := nil;
    FClientSocket := nil;
  until Terminated;

  CommonDataModule.Log(ClassName, 'Execute', 'Thread has been finished', ltBase);
end;

end.

