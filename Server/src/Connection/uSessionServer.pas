unit uSessionServer;

interface

uses
  Classes, Contnrs, SyncObjs, Sockets, SysUtils, DXSock, DXServerCore,
  uSessionProcessor, uLocker;

type
  TSessionServer = class
  private
    FTcpServer: TDXServerCore;
    FSleepInterval: Integer;
    FSleepCount: Integer;
    FSecuredTraffic: Boolean;
    FSessionOpenedEvent: TSessionOpenedEvent;
    FSessionClosedEvent: TSessionClosedEvent;
    FSessionCommandEvent: TSessionCommandEvent;

    FConnections: array of TSessionProcessor;
    FConnections_CriticalSection: TLocker;
    FAllowConnections: Boolean;

    procedure TcpServerAccept(ClientThread: TDXClientThread);
  public
    function ActiveConnections: Integer;
    function ConnectionCount: Integer;
    function Connections(Index: Integer): TSessionProcessor;
    function GetConnection(SessionID: Integer): TSessionProcessor;

    function  SendCommand(SessionsID: array of Integer; const Data: String;
      var SendResult: String): Boolean;
    procedure SendCommandToAll(const Data: String);
    procedure Start;
    procedure Stop;

    constructor Create(ASleepInterval, ASleepCount: Integer;
      ASecuredTraffic: Boolean; AServerPort: Integer;
      ASessionOpenedEvent: TSessionOpenedEvent; ASessionClosedEvent: TSessionClosedEvent;
      ASessionCommandEvent: TSessionCommandEvent);
    destructor  Destroy; override;
  end;


implementation

uses
  uCommonDataModule, uLogger, uSettings;


{ TSessionServer }

constructor TSessionServer.Create(ASleepInterval, ASleepCount: Integer;
  ASecuredTraffic: Boolean; AServerPort: Integer;
  ASessionOpenedEvent: TSessionOpenedEvent;
  ASessionClosedEvent: TSessionClosedEvent;
  ASessionCommandEvent: TSessionCommandEvent);
begin
  inherited Create;

  try
    FSleepInterval := ASleepInterval;
    FSleepCount := ASleepCount;
    FSecuredTraffic := ASecuredTraffic;
    FSessionOpenedEvent := ASessionOpenedEvent;
    FSessionClosedEvent := ASessionClosedEvent;
    FSessionCommandEvent := ASessionCommandEvent;

    SetLength(FConnections, 0);
    FConnections_CriticalSection := CommonDataModule.ThreadLockHost.Add('sessionserver');
    FAllowConnections := False;

    FTcpServer := TDXServerCore.Create(nil);
    FTcpServer.ThreadCacheSize := 1000;
    FTcpServer.UseThreadPool := B3False;
    FTcpServer.UseNagle := True;
    FTcpServer.UseSSL := False;
    FTcpServer.SocketQueueSize := 100;
    FTcpServer.ServerPort := AServerPort;
    FTcpServer.ServerType := stThreadBlocking;
    FTcpServer.OnNewConnect := TcpServerAccept;

    CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create',E.Message, ltException);
  end;
end;

destructor TSessionServer.Destroy;
var
  Loop: Integer;
begin
  try
    FTcpServer.OnNewConnect := nil;
    FTcpServer.Stop;

    for Loop := 0 to Length(FConnections) - 1 do
      if FConnections[Loop] <> nil then
      try
        FConnections[Loop].Stop;
      except
        on E: Exception do
          CommonDataModule.Log(ClassName, 'Destroy',
            'On stooping sessions:' + E.Message, ltException);
      end;

    while ActiveConnections > 0 do
      Sleep(1);

    SetLength(FConnections, 0);
    

    FTcpServer.Free;

    CommonDataModule.ThreadLockHost.Del(FConnections_CriticalSection);

    CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;
  
  inherited;
end;

function TSessionServer.SendCommand(SessionsID: array of Integer; const Data: String;
  var SendResult: String): Boolean;
var
  Loop: Integer;
  Loop2: Integer;
  SessionCount: Integer;
  Counter: Integer;
begin
  SendResult := '';
  Result := False;

  if Length(SessionsID) = 0 then
  begin
    SendResult := 'SessionsID is empty';
    Exit;
  end;

  if Length(FConnections) = 0 then
  begin
    SendResult := 'No connections';
    Exit;
  end;

  Counter := 0;
  SessionCount := Length(SessionsID);

  for Loop := 0 to Length(FConnections) - 1 do
    if FConnections[Loop] <> nil then
    try
      for Loop2 := 0 to SessionCount - 1 do
        if FConnections[Loop].SessionID = SessionsID[Loop2] then
        begin
          FConnections[Loop].SendCommand(Data);
          Result := True;
          Inc(Counter);
          Break;
        end;
      if Counter = SessionCount then
        Break;
    except
    end;

  if Counter = SessionCount then
    SendResult := 'Sent successfully'
  else
    SendResult := 'Sent partially';
end;

procedure TSessionServer.SendCommandToAll(const Data: String);
var
  Loop: Integer;
begin
  for Loop := 0 to Length(FConnections) - 1 do
    if FConnections[Loop] <> nil then
    try
      FConnections[Loop].SendCommand(Data);
    except
      on E:Exception do
        CommonDataModule.Log(ClassName, 'SendCommandToAll', E.Message, ltException);
    end;
end;

procedure TSessionServer.Stop;
begin
  FAllowConnections := False;
  FTcpServer.Stop;
end;

procedure TSessionServer.Start;
begin
  FAllowConnections := True;
  FTcpServer.Start;
end;

function TSessionServer.ActiveConnections: Integer;
var
  Loop: Integer;
begin
  Result := 0;

  for Loop := 0 to Length(FConnections) - 1 do
    if FConnections[Loop] <> nil then
      Inc(Result);
end;

function TSessionServer.ConnectionCount: Integer;
begin
  Result := Length(FConnections);
end;

procedure TSessionServer.TcpServerAccept(ClientThread: TDXClientThread);
var
  curSessionProcessor: TSessionProcessor;
  Loop: Integer;
  Index: Integer;
begin
  if not FAllowConnections then
    Exit;

  { create client }
  curSessionProcessor := TSessionProcessor.Create(
    ClientThread.Socket, ClientThread, FSleepInterval, FSleepCount, stServer,
    FSecuredTraffic, FSessionOpenedEvent, FSessionClosedEvent, FSessionCommandEvent);

  FConnections_CriticalSection.Lock;
  try
    Index := -1;
    for Loop := 0 to Length(FConnections) - 1 do
      if FConnections[Loop] = nil then
      begin
        Index := Loop;
        Break;
      end;

    if Index < 0 then
    begin
      Index := Length(FConnections);
      SetLength(FConnections, Index + 10);
      for Loop := Index to Length(FConnections) - 1 do
        FConnections[Loop] := nil;
    end;

    FConnections[Index] := curSessionProcessor;
  finally
    FConnections_CriticalSection.UnLock;
  end;

  { process client connection session }
  try
    curSessionProcessor.ProcessSession;
  except
    on E:Exception do
      CommonDataModule.Log(ClassName, 'TcpServerAccept', E.Message, ltException);
  end;

  { delete client }
  FConnections_CriticalSection.Lock;
  try
    FConnections[Index] := nil;
  finally
    FConnections_CriticalSection.UnLock;
  end;

  curSessionProcessor.Free;
end;

function TSessionServer.Connections(Index: Integer): TSessionProcessor;
begin
  Result := nil;
  if (Index >= 0) and (Index < Length(FConnections)) then
    Result := FConnections[Index];
end;

function TSessionServer.GetConnection(SessionID: Integer): TSessionProcessor;
var
  Loop: Integer;
begin
  Result := nil;
  for Loop := 0 to Length(FConnections) - 1 do
    if FConnections[Loop] <> nil then
      if TSessionProcessor(FConnections[Loop]).SessionID = SessionID then
      begin
        Result := TSessionProcessor(FConnections[Loop]);
        Break;
      end;
end;

end.

