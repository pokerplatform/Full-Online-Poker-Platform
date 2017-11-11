//      Project: Poker
//         Unit: uTCPSocketModule.pas
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es): TTCPSocketModule
//  Description: Keep TCP (or SSL/TLS) connection with remote server
//               Connect, Disconnect, Send and Receive commands

unit uTCPSocketModule;

interface

uses
  Forms, Windows, SysUtils, Classes, ScktComp, ExtCtrls,
  uSessionUtils, SBX509, SBConstants, SBClient, uDataList;

const

  StartCommandSignature  = '&1&1&1';
  EndCommandSignature    = '&2&2&2';
  KeepAlivePacket = '<ping/>';

  DefaultPassPhrase      = 'P0ker';

type
  TSecurityMethod = (smNone, smSSL, smBlowFish);
  TConnectionEvent = procedure of object;
  TCommandReceived = procedure (ReceivedCommand: String) of object;

  TTCPSocketModule = class(TDataModule)
    PingTimer: TTimer;
    ReadDataTimer: TTimer;
    ElSecureClient: TElSecureClient;
    ClientSocket: TClientSocket;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure PingTimerTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure ElSecureClientCertificateValidate(Sender: TObject;
      Certificate: TElX509Certificate; var Validate: Boolean);
    procedure ElSecureClientCloseConnection(Sender: TObject;
      CloseReason: TSBCloseReason);
    procedure ElSecureClientData(Sender: TObject; Buffer: Pointer;
      Size: Integer);
    procedure ElSecureClientOpenConnection(Sender: TObject);
    procedure ElSecureClientReceive(Sender: TObject; Buffer: Pointer;
      MaxSize: Integer; out Written: Integer);
    procedure ElSecureClientSend(Sender: TObject; Buffer: Pointer;
      Size: Integer);
    procedure ReadDataTimerTimer(Sender: TObject);
  private
    FSecurityMethod: TSecurityMethod;

    FSendBuffer    : TDataList;
    FSendCounter   : Integer;
    FSocketBusy    : Boolean;
    FSendingNow    : Boolean;

    FReceiveBuffer : String;

    FConnected: Boolean;
    FRemoteHost: String;
    FRemotePort: Word;
    FCryptKey: TSecurityKey128;

    FOnCommandReceived: TCommandReceived;
    FOnDisconnect: TConnectionEvent;
    FOnConnect: TConnectionEvent;

    procedure Clear;

    procedure SetRemoteHost(const Value: String);
    procedure SetRemotePort(const Value: Word);

    procedure SetOnCommandReceived(const Value: TCommandReceived);
    procedure SetOnDisconnect(const Value: TConnectionEvent);
    procedure SetOnConnect(const Value: TConnectionEvent);

    procedure ReallySendText;
    function  SecureTextDecode(const Text: String): String;
    function  SecureTextEncode(const Text: String): String;
    procedure ReadData(const NewData: String);
  public
    property  Connected: Boolean read FConnected;
    property  SecurityMethod: TSecurityMethod read FSecurityMethod write FSecurityMethod;
    property  RemoteHost: String read FRemoteHost write SetRemoteHost;
    property  RemotePort: Word read FRemotePort write SetRemotePort;

    property  OnConnect: TConnectionEvent read FOnConnect write SetOnConnect;
    property  OnDisconnect: TConnectionEvent read FOnDisconnect write SetOnDisconnect;
    property  OnCommandReceived: TCommandReceived read FOnCommandReceived write SetOnCommandReceived;

    procedure Connect;
    procedure Disconnect;
    function  Send(Command: String): Boolean;
    procedure SetNewPassPhrase(PassPhrase: String);
    
    function DecodeBase64Text(Text: String): String;
    function EncodeBase64Text(Text: String): String;
  end;

var
  TCPSocketModule: TTCPSocketModule;

implementation

uses
  IdCoder, IdCoder3to4, IdCoderMIME, IdBaseComponent,
  uLogger;


{$R *.dfm}

{ TConnectionModule }

procedure TTCPSocketModule.DataModuleCreate(Sender: TObject);
begin
  FSecurityMethod := smNone;

  FSendBuffer := TDataList.Create(0, nil);
  Clear;
end;

procedure TTCPSocketModule.DataModuleDestroy(Sender: TObject);
begin
  Disconnect;
  Clear;
  FSendBuffer.Free;
end;

procedure TTCPSocketModule.Clear;
begin
  FSendBuffer.Clear;
  FSendCounter := 1;
  FReceiveBuffer := '';

  FSocketBusy    := false;
  FSendingNow    := false;

  FConnected    := false;
  FRemoteHost   := '';
  FRemotePort   := 0;
end;


// Set/Get properties

procedure TTCPSocketModule.SetRemoteHost(const Value: String);
begin
  FRemoteHost := Value;
end;

procedure TTCPSocketModule.SetRemotePort(const Value: Word);
begin
  FRemotePort := Value;
end;

procedure TTCPSocketModule.SetOnConnect(const Value: TConnectionEvent);
begin
  FOnConnect := Value;
end;

procedure TTCPSocketModule.SetOnDisconnect(const Value: TConnectionEvent);
begin
  FOnDisconnect := Value;
end;

procedure TTCPSocketModule.SetOnCommandReceived(
  const Value: TCommandReceived);
begin
  FOnCommandReceived := Value;
end;


// Connect procedures

procedure TTCPSocketModule.Connect;
var
  HostIsIP : boolean;
  Loop     : integer;
begin
  Logger.Add('ConnectionModule.Connect', llBase);
  try
    if not FConnected then
    begin
      if FSecurityMethod = smBlowFish then
      begin
        Logger.Add('ConnectionModule use BlowFish version', llVerbose);
        FCryptKey := GenerateKey128(DefaultPassPhrase);
      end;

      if FSecurityMethod = smSSL then
      begin
        Logger.Add('ConnectionModule use SSL version', llVerbose);
        for Loop := SB_SUITE_FIRST to SB_SUITE_LAST do
          ElSecureClient.CipherSuites[Loop] := false;

        ElSecureClient.CipherSuites[SB_SUITE_DH_ANON_RC4_MD5] := true;
        if not ElSecureClient.Enabled then
          ElSecureClient.Enabled := true;
      end;

      Logger.Add('ConnectionModule.Connect init TCP connection -' +
        ' Host: ' + FRemoteHost +
        ' Port: ' + inttostr(FRemotePort), llExtended);
      ClientSocket.Close;
      ClientSocket.Host    := '';
      ClientSocket.Address := '';
      ClientSocket.Service := '';
      ClientSocket.Port    := FRemotePort;

      HostIsIP := true;
      for Loop := 1 to length(FRemoteHost) do
        if not ((FRemoteHost[Loop]='.') or
           ((FRemoteHost[Loop]>='0') and (FRemoteHost[Loop]<='9'))) then
        begin
          HostIsIP := false;
          break;
        end;

      if HostIsIP then
        ClientSocket.Address := FRemoteHost
      else
        ClientSocket.Host    := FRemoteHost;

      ClientSocket.ClientType := ctNonBlocking;
      ClientSocket.Open;
    end;
  except
    Logger.Add('ConnectionModule.Connect failed', llBase);
  end;
end;

procedure TTCPSocketModule.SetNewPassPhrase(PassPhrase: String);
begin
  if FSecurityMethod = smBlowFish then
    FCryptKey := GenerateKey128(PassPhrase);
end;

procedure TTCPSocketModule.PingTimerTimer(Sender: TObject);
begin
  Send(KeepAlivePacket)
end;

procedure TTCPSocketModule.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Logger.Add('ConnectionModule.ClientSocketConnect', llBase);

  if (FSecurityMethod = smBlowFish) or (FSecurityMethod = smNone) then
  begin
    FConnected := true;

    if Assigned(FOnConnect) then
      FOnConnect;
    PingTimer.Enabled := true;
  end;

  if FSecurityMethod = smSSL then
  begin
    ElSecureClient.Open;
  end
end;


// Disconnect and error

procedure TTCPSocketModule.Disconnect;
begin
  Logger.Add('ConnectionModule.Disconnect', llBase);
  FConnected := false;
  FSendBuffer.Clear;
  FSendCounter := 1;
  FReceiveBuffer := '';
  PingTimer.Enabled := false;
  if FSecurityMethod = smSSL then
    if ElSecureClient.Active then
      ElSecureClient.Close;
  if ClientSocket.Active then
    ClientSocket.Close;
  if Assigned(FOnDisconnect) then
    FOnDisConnect;
end;

procedure TTCPSocketModule.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Logger.Add('ConnectionModule.ClientSocketDisconnect', llBase);
  Disconnect;
end;

procedure TTCPSocketModule.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Logger.Add('ConnectionModule.ClientSocketError: ' + inttostr(ErrorCode), llBase);
  ErrorCode := 0;
  Disconnect;
end;


// Send command

function TTCPSocketModule.Send(Command: String): Boolean;
begin
  Logger.Add('ConnectionModule.Send', llVerbose);
  Logger.Add(Command, llExtended);
  Result := false;
  if FConnected and (Command <> '') then
  try
    Command := StringReplace(Command, ' xmlns=""','',[rfReplaceAll, rfIgnoreCase]);

    if (FSecurityMethod = smBlowFish) or (FSecurityMethod = smNone) then
    begin
      FSendBuffer.Add(FSendCounter).Name :=
        StartCommandSignature + SecureTextEncode(Command) + EndCommandSignature;
      FSendCounter := FSendCounter + 1;  
      ReallySendText;
    end;

    if FSecurityMethod = smSSL then
      ElSecureClient.SendText(StartCommandSignature + Command + EndCommandSignature);

    Result := true;
  except
    Logger.Add('ConnectionModule.Send failed', llBase);
  end;
end;

procedure TTCPSocketModule.ReallySendText;
Var
  Command: string;
  BytesSent: integer;
begin
  if FSocketBusy or FSendingNow then
    exit;

  FSendingNow := true;

  if FSendBuffer.Count > 0 then
  try
    if ClientSocket.Active then
      while FSendBuffer.Count > 0 do
      begin
        FSocketBusy := true;
        Command := FSendBuffer.Items(0).Name;
        BytesSent := ClientSocket.Socket.SendText(Command);
        if ClientSocket.Active then
        begin
          if BytesSent < length(Command) then
            break
          else
          begin
            FSocketBusy := false;
            FSendBuffer.Delete(0);
          end
        end
        else
        begin
          FSocketBusy := false;
          FSendBuffer.Clear;
        end;
      end;
  except
    Logger.Add('ConnectionModule.ReallySendText failed', llBase);
  end
  else
    FSocketBusy := false;

  FSendingNow := false;
end;

procedure TTCPSocketModule.ClientSocketWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  FSocketBusy := false;
  ReallySendText;
end;


// Read command

procedure TTCPSocketModule.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  strText: String;
begin
  if (FSecurityMethod = smBlowFish) or (FSecurityMethod = smNone) then
    if not FConnected then
      exit
    else
    begin
      strText := Socket.ReceiveText;
      ReadData(strText);
    end;

  if FSecurityMethod = smSSL then
    ElSecureClient.DataAvailable;
end;

procedure TTCPSocketModule.ReadData(const NewData: String);
begin
  FReceiveBuffer := FReceiveBuffer + NewData;
  ReadDataTimer.Enabled := true;
end;

procedure TTCPSocketModule.ReadDataTimerTimer(Sender: TObject);
var
  strText: String;
  StartCommandPos, EndCommandPos: integer;
begin
  ReadDataTimer.Enabled := false;

  if FReceiveBuffer = '' then
    Exit;

  while True do
  begin
    StartCommandPos := pos(StartCommandSignature, FReceiveBuffer);
    if StartCommandPos = 0 then
    begin
      FReceiveBuffer := '';
      Break;
    end;

    EndCommandPos := pos(EndCommandSignature, FReceiveBuffer);
    if EndCommandPos = 0 then
      Break;

    if StartCommandPos > EndCommandPos then
    begin
      FReceiveBuffer := copy(FReceiveBuffer, StartCommandPos, MaxInt);
      Continue;
    end;

    strText := copy(FReceiveBuffer, StartCommandPos + length(StartCommandSignature),
      EndCommandPos - StartCommandPos - length(StartCommandSignature));

    if FSecurityMethod = smBlowFish then
      strText := SecureTextDecode(strText);

    FReceiveBuffer := copy(FReceiveBuffer, EndCommandPos + length(EndCommandSignature), MaxInt);

    //strText := UNZIP(strText);

    if (strText <> '') and (strText <> KeepAlivePacket) and Assigned(FOnCommandReceived) then
    begin
      Logger.Add('ConnectionModule Receive:', llVerbose);
      Logger.Add(strText, llVerbose);
      FOnCommandReceived(strText);
    end;
  end;
end;


// BlowFish/ZIP/Base64 Encoding/Decoding

function TTCPSocketModule.EncodeBase64Text(Text: String): String;
Var
  IdEncoderMIME : TIdEncoderMIME;
begin
  try
    IdEncoderMIME := TIdEncoderMIME.Create(Application) ;
    Result := IdEncoderMIME.EncodeString(Text);
    IdEncoderMIME.Free;
  except
    Logger.Add('TTCPSocketModule.EncodeBase64Text failed');
    Result := '';
  end;
end;

function TTCPSocketModule.DecodeBase64Text(Text: String): String;
Var
  IdDecoderMIME : TIdDecoderMIME;
begin
  try
    IdDecoderMIME := TIdDecoderMIME.Create(Application) ;
    Result := IdDecoderMIME.DecodeString(Text);
    IdDecoderMIME.Free;
  except
    Logger.Add('TTCPSocketModule.DecodeBase64Text failed');
    Result := '';
  end;
end;

function TTCPSocketModule.SecureTextDecode(const Text: String): String;
begin
  if FSecurityMethod = smNone then
    Result := Text
  else
  try
    Result := UnzipDecrypt(Text, FCryptKey);
  except
    Result := '';
    Logger.Add('TCPSocketModule.SecureTextDecode failed', llBase);
  end;
end;

function TTCPSocketModule.SecureTextEncode(const Text: String): String;
begin
  if FSecurityMethod = smNone then
    Result := Text
  else
  try
    Result := ZipCrypt(Text, FCryptKey);
  except
    Result := '';
    Logger.Add('TCPSocketModule.SecureTextEncode failed', llBase);
  end;
end;


// SSL/TLS SecureBlackBox events

procedure TTCPSocketModule.ElSecureClientCertificateValidate(
  Sender: TObject; Certificate: TElX509Certificate; var Validate: Boolean);
begin
  if FSecurityMethod = smSSL then
    Validate := true;
end;

procedure TTCPSocketModule.ElSecureClientCloseConnection(Sender: TObject;
  CloseReason: TSBCloseReason);
var
  strReason: String;
begin
  if FSecurityMethod = smSSL then
  begin
    case CloseReason of
      crError: strReason := 'By error reason';
      crClose: strReason := 'By close reason';
    else
      strReason := 'By unknown reason';
    end;

    Logger.Add('ConnectionModule ElSecureClient disconnected: ' + strReason, llExtended);
    Disconnect;
  end;
end;

procedure TTCPSocketModule.ElSecureClientData(Sender: TObject;
  Buffer: Pointer; Size: Integer);
var
  strText: String;
begin
  if FSecurityMethod = smSSL then
  begin
    SetLength(strText, Size);
    Move(Buffer^, strText[1], Size);
    ReadData(strText);
  end;
end;

procedure TTCPSocketModule.ElSecureClientOpenConnection(Sender: TObject);
var
  strSSLVer: String;
begin
  if FSecurityMethod = smSSL then
  begin
    strSSLVer := '';
    if ElSecureClient.CurrentVersion = sbSSL2 then
      strSSLVer := 'SSL2'
    else
    if ElSecureClient.CurrentVersion = sbSSL3 then
      strSSLVer := 'SSL3'
    else
    if ElSecureClient.CurrentVersion = sbTLS1 then
      strSSLVer := 'TLS1';
    Logger.Add('ConnectionModule.ElSecureClientOpenConnection using '+ strSSLVer +
      ' and CipherSuite: ' + inttostr(ElSecureClient.CipherSuite), llBase);

    FConnected := true;
    PingTimer.Enabled := true;

    if Assigned(FOnConnect) then
      FOnConnect;
  end;
end;

procedure TTCPSocketModule.ElSecureClientReceive(Sender: TObject;
  Buffer: Pointer; MaxSize: Integer; out Written: Integer);
begin
  if FSecurityMethod = smSSL then
  begin
    Written := ClientSocket.Socket.ReceiveBuf(Buffer^, MaxSize);
    if Written < 0 then
      Written := 0;
{
    Logger.Add('ConnectionModule.ElSecureClientReceive: ' +
      inttostr(Written) + ' bytes: ', llVerbose);
}
  end;
end;

procedure TTCPSocketModule.ElSecureClientSend(Sender: TObject;
  Buffer: Pointer; Size: Integer);
var
  strText: String;
begin
  if FSecurityMethod = smSSL then
  begin
{
    Logger.Add('ConnectionModule.ElSecureClientSend: ' + inttostr(Size) + ' bytes', llVerbose);
}
    SetLength(strText, Size);
    Move(Buffer^, strText[1], Size);
    if strText <> '' then
    begin
      FSendBuffer.Add(FSendCounter).Name := strText;
      FSendCounter := FSendCounter + 1;
    end;

    ReallySendText;
  end;
end;


end.
