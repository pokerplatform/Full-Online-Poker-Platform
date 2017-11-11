unit uSessionProcessor;

interface

uses
  Windows, Classes, Contnrs, Sockets, SyncObjs, ActiveX, WinSock,
  DXSock, DXServerCore, SysUtils, StrUtils, DateUtils,
  SBServer, SBClient, SBSessionPool, SBConstants, SBX509,
  uSessionUtils, uSettings, uLocker;

const
  cntSocketMinSendBufferLength = 1024 * 2;
  cntSocketMaxSendBufferLength = 1024 * 8;
  cntSocketReceiveBufferLength = 1024 * 16;
  cntStartCommandSignature = '&1&1&1';
  cntEndCommandSignature = '&2&2&2';
  cntMaxAllowedIterationCounter = 30;
  cntKeepAlivePacket: String = '<ping/>';
  cntKAPSignature: String = '<ping';
  cntKAPSignatureLength = 5;
  cntKeepAliveTime_Sec = 5;
  cntKeepAliveTimeOut_Sec = 300;

type
  TTrafficType = (ttDirect, ttCompressed, ttXMLSocket);

  TSessionProcessor = class;
  TSocketType = (stClient, stServer);
  TSessionOpenedEvent = procedure (ASessionProcessor: TSessionProcessor; var ASessionID: Integer) of object;
  TSessionClosedEvent = procedure (ASessionProcessor: TSessionProcessor) of object;
  TSessionCommandEvent = procedure (ASessionProcessor: TSessionProcessor; const ACommand: String) of object;

  TSessionProcessor = class
  private
    FClientSocket: TCustomIpClient;
    FServerSocket: TDXSock;
    FClientThread: TThread;
    FSocketType: TSocketType;
    FTrafficType: TTrafficType;
    FTrafficTypeConfirmed: Boolean;
    FSecuredTraffic: Boolean;
    FSleepInterval: Integer;
    FSleepCount: Integer;
    FStopSleep: Boolean;

    FSessionOpenedEvent: TSessionOpenedEvent;
    FSessionClosedEvent: TSessionClosedEvent;
    FSessionCommandEvent: TSessionCommandEvent;

    FSecureServer: TElSecureServer;
    FSecureClient: TElSecureClient;

    FSessionID: Integer;
    FConnected: Boolean;
    FRunning: Boolean;
    FConstantIP: Boolean;

    FReceiveBuffer: String;
    FOutputBuffer: TStringList;
    FOutputBuffer_CriticalSection: TLocker;

    function  GetRemoteHost: String;
    function  AnalyseReceiveBuffer: Boolean;

    // Socket Handlers
    procedure TCPClientError(Sender: TObject; SocketError: Integer);
    procedure TCPClientDisconnect(Sender: TObject);

    // Secure Handlers
    procedure HandleSertificateValidate(Sender: TObject;
      X509Certificate: TElX509Certificate; var Validate: boolean);
    procedure HandleSend(Sender: TObject; Buffer: pointer; Size: longint);
    procedure HandleReceive(Sender: TObject;
      Buffer: pointer; MaxSize: longint; out Written: longint);
    procedure HandleData(Sender: TObject; Buffer: pointer; Size: longint);
    procedure HandleServerCloseConnection(Sender: TObject; CloseDescription: Integer);
    procedure HandleClientCloseConnection(Sender: TObject; CloseDescription: TSBCLoseReason);
  public
    property Connected: Boolean read FConnected;
    property RemoteHost: String read GetRemoteHost;
    property SessionID: Integer read FSessionID;
    property ConstantIP: Boolean read FConstantIP;
    property TrafficType: TTrafficType read FTrafficType;
    property SecuredTraffic: Boolean read FSecuredTraffic;
    property ClientThread: TThread read FClientThread;

    procedure SendCommand(const ACommand: String);
    procedure ProcessSession;
    procedure Stop;

    constructor Create(AClientSocket: TObject; AClientThread: TThread;
      ASleepInterval, ASleepCount: Integer;
      ASocketType: TSocketType; ASecuredTraffic: Boolean;
      ASessionOpenedEvent: TSessionOpenedEvent; ASessionClosedEvent: TSessionClosedEvent;
      ASessionCommandEvent: TSessionCommandEvent);
    destructor  Destroy; override;
  end;

implementation

uses
  uCommonDataModule, uLogger;


{ TSessionProcessor }

constructor TSessionProcessor.Create(
  AClientSocket: TObject; AClientThread: TThread; ASleepInterval, ASleepCount: Integer;
  ASocketType: TSocketType; ASecuredTraffic: Boolean;
  ASessionOpenedEvent: TSessionOpenedEvent;
  ASessionClosedEvent: TSessionClosedEvent;
  ASessionCommandEvent: TSessionCommandEvent);
var
  Loop: Integer;
begin
  inherited Create;

  // Set default values for variables
  FSecureServer := nil;
  FSecureClient := nil;
  FClientSocket := nil;
  FServerSocket := nil;

  FSessionID := 0;
  FConnected := False;
  FRunning := False;
  FSleepInterval := ASleepInterval;
  FSleepCount := ASleepCount;

  FReceiveBuffer := '';
  FOutputBuffer := TStringList.Create;
  FOutputBuffer_CriticalSection := CommonDataModule.ThreadLockHost.Add('outputbuffer');

  // Set variables from parameters
  FSocketType := ASocketType;
  FSecuredTraffic := ASecuredTraffic;

  FTrafficType := ttDirect;
  FTrafficTypeConfirmed := False;

  FSessionOpenedEvent := ASessionOpenedEvent;
  FSessionClosedEvent := ASessionClosedEvent;
  FSessionCommandEvent := ASessionCommandEvent;

  FClientThread := AClientThread;
  if FSocketType = stServer then
    FServerSocket := TDXSock(AClientSocket)
  else
    FClientSocket := TCustomIpClient(AClientSocket);

  if FSocketType = stClient then
    with FClientSocket do
    begin
      OnError := TCPClientError;
      OnDisconnect := TCPClientDisconnect;
    end;

  if FSecuredTraffic then
  begin
    if FSocketType = stServer then
    begin
      FSecureServer := TElSecureServer.Create(nil);
      FSecureServer.OnSend := HandleSend;
      FSecureServer.OnReceive := HandleReceive;
      FSecureServer.OnData := HandleData;
      FSecureServer.OnCloseConnection := HandleServerCloseConnection;
      FSecureServer.OnCertificateValidate := HandleSertificateValidate;
      for Loop := SB_SUITE_FIRST to SB_SUITE_LAST do
        FSecureServer.CipherSuites[Loop] := False;
      FSecureServer.CipherSuites[SB_SUITE_DH_ANON_RC4_MD5] := True;
    end
    else
    begin
      FSecureClient := TElSecureClient.Create(nil);
      FSecureClient.OnSend := HandleSend;
      FSecureClient.OnReceive := HandleReceive;
      FSecureClient.OnData := HandleData;
      FSecureClient.OnCloseConnection := HandleClientCloseConnection;
      FSecureClient.OnCertificateValidate := HandleSertificateValidate;
      for Loop := SB_SUITE_FIRST to SB_SUITE_LAST do
        FSecureClient.CipherSuites[Loop] := False;
      FSecureClient.CipherSuites[SB_SUITE_DH_ANON_RC4_MD5] := True;
    end;
  end;

  FConstantIP := CommonDataModule.ConstantIPs.IndexOf(GetRemoteHost) >= 0;
end;

destructor TSessionProcessor.Destroy;
begin
  while FRunning do
  begin
    Stop;
    Sleep(10);
  end;

  if FSecureServer <> nil then
    FSecureServer.Free;

  if FSecureClient <> nil then
    FSecureClient.Free;

  FOutputBuffer.Free;

  CommonDataModule.ThreadLockHost.Del(FOutputBuffer_CriticalSection);

  inherited;
end;


function TSessionProcessor.GetRemoteHost: String;
begin
  Result := '';
  if FSocketType = stServer then
    Result := FServerSocket.PeerIPAddress
  else
    Result := FClientSocket.RemoteHost;
end;

function TSessionProcessor.AnalyseReceiveBuffer: Boolean;
var
  StartCommandPos: Integer;
  EndCommandPos: Integer;
  curCommand: String;
  IterationCounter: Integer;
begin
  Result := False;
  curCommand := '';
  IterationCounter := 0;

  { checking incoming buffer }
  while FReceiveBuffer <> '' do
  begin
    { looking for the start command }
    if FTrafficTypeConfirmed then
    begin
      if FTrafficType = ttXMLSocket then
        StartCommandPos := 0
      else
      begin
        StartCommandPos := Pos(cntStartCommandSignature, FReceiveBuffer);
        if StartCommandPos = 0 then
        begin
          { start delimeter was not found }
          FReceiveBuffer := '';
          Break;
        end;
      end;
    end
    else
    begin
      { Determininh traffic type by signatures and first symbol }
      StartCommandPos := Pos(cntStartCommandSignature, FReceiveBuffer);
      if StartCommandPos > 0 then
      begin
        if FReceiveBuffer[StartCommandPos + 1] = cntZippedPacketSignature then
          FTrafficType := ttCompressed
        else
          FTrafficType := ttDirect;
        FTrafficTypeConfirmed := True;
      end
      else
      begin
        if FReceiveBuffer[1] = cntXMLStartSignature then
        begin
          FTrafficType := ttXMLSocket;
          FTrafficTypeConfirmed := True;
        end
        else
        begin
          { start delimeter was not found }
          FReceiveBuffer := '';
          Break;
        end;
      end;
    end;

    { looking for the end delimeter }
    if FTrafficType = ttXMLSocket then
      EndCommandPos := Pos(cntXMLEndSignature, FReceiveBuffer)
    else
      EndCommandPos := Pos(cntEndCommandSignature, FReceiveBuffer);
    if EndCommandPos = 0 then
      { end command delineter was not found }
      Break;

    if StartCommandPos > EndCommandPos then
    begin
      { truncating command buffer }
      FReceiveBuffer := copy(FReceiveBuffer, StartCommandPos, MaxInt);
      Continue;
    end;

    if FTrafficType = ttXMLSocket then
    begin
      { extracting full command block }
      curCommand := copy(FReceiveBuffer, 1, EndCommandPos - 1);

      { truncating command buffer }
      FReceiveBuffer := copy(FReceiveBuffer, EndCommandPos + Length(cntXMLEndSignature), MaxInt);
    end
    else
    begin
      { extracting full command block }
      curCommand := copy(FReceiveBuffer,
        StartCommandPos + Length(cntStartCommandSignature),
        EndCommandPos - StartCommandPos - Length(cntStartCommandSignature));

      { truncating command buffer }
      FReceiveBuffer := copy(FReceiveBuffer,
        EndCommandPos + Length(cntEndCommandSignature),
        MaxInt);
    end;

    if curCommand <> '' then
    try
      Result := True;

      if Assigned(FSessionCommandEvent) and (not FConstantIP) then
      begin
        if FTrafficType = ttCompressed then
          curCommand := UNZIP(curCommand);

        { raising an event }
        if (curCommand <> '') and
          (lowercase(copy(curCommand, 1, cntKAPSignatureLength)) <> cntKAPSignature) then
          FSessionCommandEvent(Self, curCommand);
      end;
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'AnalyseReceiveBuffer', E.Message, ltException);
    end;

    Inc(IterationCounter);
    if IterationCounter > cntMaxAllowedIterationCounter then
      Break;
  end;
end;

procedure TSessionProcessor.SendCommand(const ACommand: String);
  function ZipOrNot: String;
  begin
    if FTrafficType = ttCompressed then
      Result := ZIP(ACommand)
    else
      Result := ACommand;
  end;
begin
  try
    FOutputBuffer_CriticalSection.Lock;
    try
      FOutputBuffer.Add(ZipOrNot);
      FStopSleep := True;
    finally
      FOutputBuffer_CriticalSection.UnLock;
    end;
  except
    On E: Exception do
      CommonDataModule.Log(ClassName, 'SendCommand', E.Message, ltException);
  end;
end;

procedure TSessionProcessor.ProcessSession;
var
  ReceivedData: String;
  SendBuffer: String;
  BufSize: Integer;
  CanSend: Boolean;
  CanRead: Boolean;
  DataSent: Boolean;
  IterationCounter: Integer;
  SendKeepAlivePacketLastTime: TDateTime;
  ClientActivityLastTime: TDateTime;
begin
  FRunning := True;
  FConnected := True;
  SendBuffer := '';
  SetLength(ReceivedData, cntSocketReceiveBufferLength + 10);
  SendKeepAlivePacketLastTime := Now;
  ClientActivityLastTime := Now;

  CoInitialize(nil);

  try
    FOutputBuffer_CriticalSection.Lock;
    try
      FOutputBuffer.Clear;
    finally
      FOutputBuffer_CriticalSection.UnLock;
    end;

    if not FConstantIP then
    begin
      if Assigned(FSessionOpenedEvent) then
        FSessionOpenedEvent(Self, FSessionID);

      CommonDataModule.Log(ClassName, 'ProcessSession', 'Started for SessionID=' +
        inttostr(FSessionID) + ', RemoteHost=' + RemoteHost, ltBase);
    end;

    if FSecuredTraffic then
    begin
      if FSocketType = stServer then
        FSecureServer.Open;
      if FSocketType = stClient then
        FSecureClient.Open;
    end;

    { main socket loop }
    while FConnected do
    try
      FStopSleep := False;

      // Getting data to input buffer from socket
      if FSocketType = stServer then
        CanRead := (FServerSocket.CharactersToRead > 0) and
          (FServerSocket.Readable)
      else
        CanRead := FClientSocket.WaitForData;

      if CanRead then
      begin
        FStopSleep := True;

        if FSecuredTraffic then
        begin
          { notify secure server the data available }
          if FSocketType = stServer then
            FSecureServer.DataAvailable
          else
            FSecureClient.DataAvailable;
        end
        else
        begin
          { get data from socket buffer }
          if FSocketType = stServer then
            BufSize := FServerSocket.ReceiveBuf(ReceivedData[1], cntSocketReceiveBufferLength)
          else
            BufSize := FClientSocket.ReceiveBuf(ReceivedData[1], cntSocketReceiveBufferLength);
          if (BufSize > 0) and (BufSize <= cntSocketReceiveBufferLength) then
            FReceiveBuffer := FReceiveBuffer + copy(ReceivedData, 1, BufSize)
          else
            CommonDataModule.Log(ClassName, 'ProcessSession',
              'Invalid BufSize on reading', ltError);
        end;
      end;

      if AnalyseReceiveBuffer then
        ClientActivityLastTime := Now;

      // Get data to send from output buffer
      IterationCounter := 0;
      if SendBuffer = '' then
      repeat
        FOutputBuffer_CriticalSection.Lock;
        try
          if FOutputBuffer.Count > 0 then
          begin
            if FTrafficType = ttXMLSocket then
              SendBuffer := SendBuffer + FOutputBuffer.Strings[0] + cntXMLEndSignature
            else
              SendBuffer := SendBuffer + cntStartCommandSignature +
                FOutputBuffer.Strings[0] + cntEndCommandSignature;
            FOutputBuffer.Delete(0);
          end;
        finally
          FOutputBuffer_CriticalSection.UnLock;
        end;

        Inc(IterationCounter);
        if IterationCounter > cntMaxAllowedIterationCounter then
        begin
          CommonDataModule.Log(ClassName, 'ProcessSession',
            'IterationCounter on get output buffer on SessionID=' + inttostr(FSessionID), ltError);
          Break;
        end;
      until (Length(SendBuffer) > cntSocketMinSendBufferLength) or (FOutputBuffer.Count = 0);

      // Sending data to socket from output buffer
      DataSent := False;
      if SendBuffer <> '' then
      begin
        FStopSleep := True;
        
        if FSocketType = stServer then
          CanSend := FServerSocket.Writable
        else
          FClientSocket.Select(nil, @CanSend, nil);

        if CanSend then
        begin
          BufSize := Length(SendBuffer);
          if BufSize > cntSocketMaxSendBufferLength then
            BufSize := cntSocketMaxSendBufferLength;

          if FSecuredTraffic then
          begin
            if FSocketType = stServer then
              if FSecureServer.Active then
              begin
                FSecureServer.SendData(@(SendBuffer[1]), BufSize);
                DataSent := True;
              end
            else
              if FSecureClient.Active then
              begin
                FSecureClient.SendData(@(SendBuffer[1]), BufSize);
                DataSent := True;
              end;
          end
          else
          begin
            if FSocketType = stServer then
              FServerSocket.SendBuf(SendBuffer[1], BufSize)
            else
              FClientSocket.SendBuf(SendBuffer[1], BufSize);
            DataSent := True;
          end;

          if DataSent then
          begin
            if BufSize = Length(SendBuffer) then
              SendBuffer := ''
            else
              SendBuffer := Copy(SendBuffer, BufSize + 1, MAXINT);
          end
        end;
      end;

      // Sleep
      if not FStopSleep then
      begin
        if FSleepCount > 1 then
        begin
          IterationCounter := 1;
          while (IterationCounter < FSleepCount) and (not FStopSleep) do
          begin
            Sleep(FSleepInterval);
            Inc(IterationCounter);
          end;
        end
        else
          Sleep(FSleepInterval);
      end;

      // Send keep alive packet
      if SecondsBetween(Now, SendKeepAlivePacketLastTime) > cntKeepAliveTime_Sec then
      begin
        SendCommand(cntKeepAlivePacket);
        SendKeepAlivePacketLastTime := Now;
      end;

      // Disconnect on max inactivity time
      if SecondsBetween(Now, ClientActivityLastTime) > cntKeepAliveTimeOut_Sec then
      begin
        CommonDataModule.Log(ClassName, 'ProcessSession',
          'Abnormal session termination on SessionID=' + inttostr(FSessionID), ltError);
        FConnected := False;
      end;

      // Determine socket validity
      if FConnected then
      begin
        if FSocketType = stServer then
        begin
          FConnected := FConnected and FServerSocket.Connected;
          if (FServerSocket.Readable) and
            (FServerSocket.CharactersToRead = 0) then
            FConnected := False;
        end
        else
          FConnected := FConnected and
            FClientSocket.Connected and
            FClientSocket.Active;
      end;
    except
      on E:Exception do
        CommonDataModule.Log(ClassName, 'ProcessSession', E.Message, ltException);
    end;

    { Client has been disconnected }
    FConnected := False;
    if FSecuredTraffic then
    begin
      if FSocketType = stServer then
        FSecureServer.Close;
      if FSocketType = stClient then
        FSecureClient.Close;
    end;

    if FSocketType = stServer then
      FServerSocket.Disconnect
    else
      FClientSocket.Disconnect;

    if not FConstantIP then
    begin
      // Notify about disconnection
      if Assigned(FSessionClosedEvent) and (not FConstantIP) then
        FSessionClosedEvent(Self);

      CommonDataModule.Log(ClassName, 'ProcessSession', 'Finished for SessionID=' +
        inttostr(FSessionID) + ', RemoteHost=' + RemoteHost, ltBase);
    end;
  finally
    CoUninitialize;
  end;
  FRunning := False;
end;

procedure TSessionProcessor.Stop;
begin
  FConnected := False;
  FStopSleep := True;
end;


// Secure layer handlers

procedure TSessionProcessor.HandleSend(Sender: TObject; Buffer: pointer; Size: Integer);
begin
  if FSocketType = stServer then
    FServerSocket.SendBuf(Buffer^, Size)
  else
    FClientSocket.SendBuf(Buffer^, Size);
end;

procedure TSessionProcessor.HandleReceive(Sender: TObject; Buffer: pointer;
  MaxSize: Integer; out Written: Integer);
begin
  if FSocketType = stServer then
    Written := FServerSocket.ReceiveBuf(Buffer^, MaxSize)
  else
    Written := FClientSocket.ReceiveBuf(Buffer^, MaxSize);

  if Written < 0 then
    Written := 0;
end;

procedure TSessionProcessor.HandleData(Sender: TObject; Buffer: pointer; Size: Integer);
var
  InData: String;
begin
  SetLength(InData, Size);
  Move(Buffer^, InData[1], Size);
  FReceiveBuffer := FReceiveBuffer + InData;
end;

procedure TSessionProcessor.HandleSertificateValidate(Sender: TObject;
  X509Certificate: TElX509Certificate; var Validate: boolean);
begin
  Validate := True;
end;

procedure TSessionProcessor.HandleServerCloseConnection(Sender: TObject;
  CloseDescription: integer);
var
  strReason: String;
begin
  if FConnected then
  begin
    Stop;
    case CloseDescription of
      cdCLOSED_BY_ERROR: strReason := 'By error reason';
      cdSESSION_CLOSED: strReason := 'By close reason';
    else
      strReason := 'By unknown reason';
    end;
    CommonDataModule.Log(ClassName, 'HandleServerCloseConnection', strReason, ltError);
  end;
end;

procedure TSessionProcessor.HandleClientCloseConnection(Sender: TObject;
  CloseDescription: TSBCLoseReason);
var
  strReason: String;
begin
  if FConnected then
  begin
    Stop;
    case CloseDescription of
      crError: strReason := 'By error reason';
      crClose: strReason := 'By close reason';
    else
      strReason := 'By unknown reason';
    end;
    CommonDataModule.Log(ClassName, 'HandleClientCloseConnection', strReason, ltError);
  end;
end;


// TCPClientSocket handlers
procedure TSessionProcessor.TCPClientDisconnect(Sender: TObject);
begin
  Stop;
end;

procedure TSessionProcessor.TCPClientError(Sender: TObject; SocketError: Integer);
begin
  if FConnected then
  begin
    Stop;
    CommonDataModule.Log(ClassName, 'TcpClientError', 'Error #' + inttostr(SocketError), ltError);
  end;
end;

end.
