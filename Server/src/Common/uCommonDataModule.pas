unit uCommonDataModule;

// OffshoreCreations Inc. (C) 2004
// Author: Maxim Korablev

interface

uses
  SysUtils, Classes, ExtCtrls, Forms, Registry, AppEvnts, SyncObjs,
  Windows, Messages, ActiveX, WinSock, DateUtils,
  xmldom, XMLIntf, msxmldom, XMLDoc, MSMQ_TLB, NetCompress_TLB,
  // Server units
  uObjectPool, uLogger, uXMLConstants, uSettings,
  uAPI, uAccount, uEmail, uFileManager, uUser, uErrorConstants, uLocker;

const
  ccaEnabled = 1;
  ccaDisabled = 2;
  ccaOff = 3;
  ccaPPC = 4;

  prsEnabled = 1;
  prsDisabled = 2;
  prsPause = 3;
  ThreadLockerUnLockTimeOut = 1000;

type
  TServiceMode = (stNone, stClientAdapter, stActionProcessor, stActionDispatcher,
    stMSMQReader, stMSMQWriter, stReminder, stGameAdapter, stTournament);
  TServiceModes = set of TServiceMode;

  TRingUpThread = class (TThread)
  protected
    procedure Execute; override;
  end;

  TCommonDataModule = class
  private
    FServiceName: String;
    FServiceOriginalName: String;
    FServiceModes: TServiceModes;
    FIsStandalone: Boolean;

    FClientAdapterPort: Integer;
    FClientAdapterSSL: Boolean;
    FClientConnectionsAllowedStatus: Integer;

    FSQLServerHost: String;
    FSQLConnectionString: String;

    FActionDispatcherHost: String;
    FActionDispatcherPort: Integer;
    FActionDispatcherID: Integer;

    FLocalHost: String;
    FLocalIP: String;

    FMSMQHost: String;
    FMSMQPath: String;
    FAdminMSMQHost: String;
    FAdminMSMQPath: String;

    FLogFolder: String;
    FLogging: Boolean;

    FSMTPPort: Integer;
    FSMTPHost: String;
    FSMTPFrom: String;
    FAdminEmailAddress: String;

    FActionLogCache: TStringList;
    FActionLogCache_CriticalSection: TLocker;

    FLogger: TLogger;
    FObjectPool: TObjectPool;

    FRingUpThread: TRingUpThread;
    FProcessesStatus: Integer;

    FConstantIPs: TStringList;
    FRefreshTime: Integer;
    FLastUpdatePacketSentTime: TDateTime;

    FCompressor: _Zip;
    FThreadLockHost: TThreadLockHost;


    function GetNotifyAllPacket(const Data: String): String;

    procedure UpdateLocalHostAndIP;
    procedure RingUp;
    procedure SetClientConnectionsAllowedStatus(const Value: Integer);
    procedure SetProcessesStatus(const Value: Integer);
    procedure ReplicateSettings;
    procedure DoSettings(XMLNode: IXMLNode);
    procedure DoCommonActions(ActionXML: IXMLNode; var Handled: Boolean);
    procedure SendUpdatePacket;
    procedure SaveSettingsToRegistry;
  public
    // For DateTime Conversations
    ServiceSettings: String;
    DefaultDateTimeFormatSettings: TFormatSettings;
    AmericanDateTimeFormatSettings: TFormatSettings;
    Connected: Boolean;

    function BoolAsStr(Value: Boolean): String;
    function Compress(Data: String): String;
    function UnCompress(Data: String): String;

    // Settings
    property ServiceName: String read FServiceName;
    property ServiceModes: TServiceModes read FServiceModes;

    property ClientAdapterPort: Integer read FClientAdapterPort;
    property ClientAdapterSSL: Boolean read FClientAdapterSSL;
    property ClientConnectionsAllowedStatus: Integer read FClientConnectionsAllowedStatus
      write SetClientConnectionsAllowedStatus;
    property ProcessesStatus: Integer read FProcessesStatus write SetProcessesStatus;
    property ActionDispatcherHost: String read FActionDispatcherHost;
    property ActionDispatcherPort: Integer read FActionDispatcherPort;
    property ActionDispatcherID: Integer read FActionDispatcherID;
    property SQLServerHost: String read FSQLServerHost;
    property SQLConnectionString: String read FSQLConnectionString;
    property LocalHost: String read FLocalHost;
    property LocalIP: String read FLocalIP;
    property MSMQHost: String read FMSMQHost;
    property MSMQPath: String read FMSMQPath;
    property AdminMSMQHost: String read FAdminMSMQHost;
    property AdminMSMQPath: String read FAdminMSMQPath;
    property LogFolder: String read FLogFolder;
    property Logging: Boolean read FLogging;
    property AdminEmailAddress: String read FAdminEmailAddress;
    property SMTPHost: String read FSMTPHost;
    property SMTPPort: Integer read FSMTPPort;
    property SMTPFrom: String read FSMTPFrom;

    property ObjectPool: TObjectPool read FObjectPool;
    property ConstantIPs: TStringList read FConstantIPs;
    property RefreshTime: Integer read FRefreshTime;
    property ThreadLockHost: TThreadLockHost read FThreadLockHost;

    procedure ProcessAction(ActionXML: String);
    procedure ProcessSessionAction(SessionID: Integer; const ActionXML: String);
    procedure ProcessXMLAction(ActionXML: IXMLNode);

    procedure Log(const ClassName, MethodName, LogData : String; LogType: TLogType);

    procedure ProcessGameAction(ProcessID: Integer; const ActionText: String);
    procedure DispatchGameAction(ProcessID, ActionDispatcherID: Integer;
      const ActionText: String);
    procedure ActionLog(HandID: Integer; const Action: String);
    procedure SaveActionLog;

    procedure SendAdminMSMQ(const Body: String; const MsgLabel: String = '');
    procedure SendToAllServers(const Data: String);
    procedure ReceiveUpdatePacket(Data: String);

    procedure NotifyUser(SessionID: Integer; const Data: String; SendDirectly: Boolean = True);
    procedure NotifyUserByID(UserID: Integer; const Data: String);
    procedure NotifyUsers(SessionIDs: array of Integer; const Data: String);
    procedure NotifyUsersByID(UserIDs: array of Integer; const Data: String);
    procedure NotifyAllUsers(const Data: String);
    procedure NotifyClients(SessionIDs: array of Integer; Data: String);

    function GetNotifyUsersPacket(SessionIDs, UserIDs: array of Integer;
      const Data: String): String;

    constructor Create;
    procedure StartWork;
    destructor Destroy; override;
  end;

var
  CommonDataModule: TCommonDataModule;

implementation

uses
  StrUtils, uSQLAdapter, uSessionUtils, uActionDispatcher, uActionServer;

{ TCommonDataModule }

// Create and Destroy

constructor TCommonDataModule.Create;
var
  Reg: TRegINIFile;
  PortPos: Integer;
begin

  FLogging := False;
  FLogger := nil;

  Connected := False;
  FIsStandalone := False;
  FLastUpdatePacketSentTime := Now;

  FThreadLockHost := TThreadLockHost.Create(ThreadLockerUnLockTimeOut);

  FActionLogCache := TStringList.Create;
  FActionLogCache_CriticalSection := FThreadLockHost.Add('actionlogcashe');

  DefaultDateTimeFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  DefaultDateTimeFormatSettings.ShortTimeFormat := 'hh:nn:ss.zzz';
  DefaultDateTimeFormatSettings.LongDateFormat := 'yyyy-mm-dd';
  DefaultDateTimeFormatSettings.LongTimeFormat := 'hh:nn:ss.zzz';
  DefaultDateTimeFormatSettings.DateSeparator := '-';
  DefaultDateTimeFormatSettings.TimeSeparator := ':';

  AmericanDateTimeFormatSettings.ShortDateFormat := 'mm/dd/yyyy';
  AmericanDateTimeFormatSettings.ShortTimeFormat := 'hh:nn ampm';
  AmericanDateTimeFormatSettings.LongDateFormat := 'mm/dd/yyyy';
  AmericanDateTimeFormatSettings.LongTimeFormat := 'hh:nn:ss ampm';
  AmericanDateTimeFormatSettings.DateSeparator := '/';
  AmericanDateTimeFormatSettings.TimeSeparator := ':';
  AmericanDateTimeFormatSettings.TimeAMString  := 'AM';
  AmericanDateTimeFormatSettings.TimePMString  := 'PM';

  FCompressor := CoZip.Create;

  // Get network host name and IP
  FLocalHost := cntDefaultLocalIP;
  FLocalIP := cntDefaultLocalIP;
  UpdateLocalHostAndIP;

  // Set variables by default
  FServiceModes := [stActionProcessor, stActionDispatcher, stMSMQReader, stMSMQWriter,
    stClientAdapter, stGameAdapter, stTournament, stReminder];
  FClientAdapterPort := cntDefaultClientAdapterPort;
  FClientAdapterSSL := True;
  FClientConnectionsAllowedStatus := ccaEnabled;
  FActionDispatcherHost := FLocalIP;
  FActionDispatcherPort := cntDefaultActionDispatcherPort;
  FActionDispatcherID := cntDefaultActionDispatcherID;
  FSQLServerHost := FLocalIP;
  FSQLConnectionString := cntDefaultSQLConnectionString;
  FMSMQHost := FLocalHost;
  FMSMQPath := cntDefaultMSMQPATH;
  FAdminMSMQHost := FLocalHost;
  FAdminMSMQPath := cntDefaultAdminMSMQPATH;
  FLogging := True;
  FLogFolder := ExtractFileDrive(Forms.Application.ExeName) + cntDefaultLogFolder;
  FSMTPPort := cntDefaultSMTPPort;
  FSMTPHost := FLocalIP;
  FSMTPFrom := cntDefaultSMTPFrom + FLocalIP;
  FAdminEmailAddress := cntDefaultAdminEmailAddress + FLocalIP;
  FProcessesStatus := 1;
  FRefreshTime := 10;

  FServiceName := ExtractFileName(Forms.Application.ExeName);
  FServiceName := copy(FServiceName, 1, Length(FServiceName) - 4);
  FServiceOriginalName := FServiceName;

  PortPos := pos('_', FServiceName);
  if PortPos > 0 then
    FServiceOriginalName := copy(FServiceName, 1, PortPos - 1);

  // Load Registry settings
  Reg := TRegINIFile.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.Access := KEY_READ;

  if Reg.OpenKey('SOFTWARE\' + FServiceOriginalName + '\ServerSettings', False) then
  begin
    FSQLServerHost := Reg.ReadString('', cntSQLServerHost, FSQLServerHost);
    FSQLConnectionString := Reg.ReadString('', cntSQLConnectionString, FSQLConnectionString);
    FMSMQHost := Reg.ReadString('', cntMSMQHost, FMSMQHost);
    FMSMQPath := Reg.ReadString('', cntMSMQPath, FMSMQPath);
    FAdminMSMQHost := Reg.ReadString('', cntAdminMSMQHost, FAdminMSMQHost);
    FAdminMSMQPath := Reg.ReadString('', cntAdminMSMQPath, FAdminMSMQPath);
    FLogFolder := Reg.ReadString('', cntLogFolder, FLogFolder);
    FLogging := Reg.ReadString('', cntLogging, '1') = '1';

    FClientAdapterPort := Reg.ReadInteger('', cntClientAdapterPort, FClientAdapterPort);
    FClientAdapterSSL := Reg.ReadString('', cntClientAdapterSSL, '1') = '1';
    FClientConnectionsAllowedStatus := Reg.ReadInteger('', cntClientConnectionsAllowedStatus, FClientConnectionsAllowedStatus);
    FProcessesStatus := Reg.ReadInteger('', cntProcessesStatus, FProcessesStatus);
    FActionDispatcherHost := Reg.ReadString('', cntActionDispatcherHost, FActionDispatcherHost);
    FActionDispatcherPort := Reg.ReadInteger('', cntActionDispatcherPort, FActionDispatcherPort);
    FActionDispatcherID := Reg.ReadInteger('', cntActionDispatcherID, FActionDispatcherID);

    FAdminEmailAddress := Reg.ReadString('', cntAdminEmailAddress, FAdminEmailAddress);
    FSMTPFrom := Reg.ReadString('', cntSMTPFrom, FSMTPFrom);
    FSMTPHost := Reg.ReadString('', cntSMTPHost, FSMTPHost);
    FSMTPPort := Reg.ReadInteger('', cntSMTPPort, FSMTPPort);

    FRefreshTime := Reg.ReadInteger('', cntRefreshTime, FRefreshTime);

    FConstantIPs := TStringList.Create;
    FConstantIPs.Text := StringReplace(Reg.ReadString('', cntConstantIPs, ''),
      ',', #13#10, [rfReplaceAll, rfIgnoreCase]);

    FServiceModes := [];
    if Reg.ReadString('', cntIsActionProcessor, '1') = '1' then
      FServiceModes := FServiceModes + [stActionProcessor];
    if Reg.ReadString('', cntIsActionDispatcher, '1') = '1' then
    begin
      FServiceModes := FServiceModes + [stActionDispatcher];
    end;
    if Reg.ReadString('', cntIsActionDispatcher, '1') = '2' then
    begin
      FServiceModes := FServiceModes + [stActionDispatcher];
      FIsStandalone := True;
    end;
    if Reg.ReadString('', cntIsMSMQReader, '1') = '1' then
    begin
      FServiceModes := FServiceModes + [stMSMQReader];
    end;
    if Reg.ReadString('', cntIsMSMQWriter, '1') = '1' then
    begin
      FServiceModes := FServiceModes + [stMSMQWriter];
    end;
    if Reg.ReadString('', cntIsClientAdapter, '1') = '1' then
    begin
      FServiceModes := FServiceModes + [stClientAdapter];
    end;
    if Reg.ReadString('', cntIsGameAdapter, '1') = '1' then
    begin
      FServiceModes := FServiceModes + [stGameAdapter];
    end;
    if Reg.ReadString('', cntIsTournament, '1') = '1' then
    begin
      FServiceModes := FServiceModes + [stTournament];
    end;
    if Reg.ReadString('', cntIsReminder, '1') = '1' then
    begin
      FServiceModes := FServiceModes + [stReminder];
    end;

    Reg.CloseKey;
  end
  else
  begin
    Reg.Access := KEY_WRITE;
    if Reg.OpenKey('SOFTWARE\' + FServiceOriginalName + '\ServerSettings', True) then
    begin
      Reg.WriteString('', cntMSMQHost, FMSMQHost);
      Reg.WriteString('', cntMSMQPath, FMSMQPath);
      Reg.WriteString('', cntAdminMSMQHost, FAdminMSMQHost);
      Reg.WriteString('', cntAdminMSMQPath, FAdminMSMQPath);
      Reg.WriteString('', cntSQLServerHost, FSQLServerHost);
      Reg.WriteString('', cntSQLConnectionString, FSQLConnectionString);
      Reg.WriteString('', cntLogging, BoolAsStr(FLogging));
      Reg.WriteString('', cntLogFolder, FLogFolder);
      Reg.WriteInteger('', cntClientAdapterPort, FClientAdapterPort);
      Reg.WriteString('', cntClientAdapterSSL, BoolAsStr(FClientAdapterSSL));
      Reg.WriteInteger('', cntClientConnectionsAllowedStatus, FClientConnectionsAllowedStatus);
      Reg.WriteInteger('', cntProcessesStatus, FProcessesStatus);
      Reg.WriteString('', cntActionDispatcherHost, FActionDispatcherHost);
      Reg.WriteInteger('', cntActionDispatcherPort, FActionDispatcherPort);
      Reg.WriteInteger('', cntActionDispatcherID, FActionDispatcherID);

      Reg.WriteInteger('', cntSMTPPort, FSMTPPort);
      Reg.WriteString('', cntSMTPHost, FSMTPHost);
      Reg.WriteString('', cntSMTPFrom, FSMTPFrom);
      Reg.WriteString('', cntAdminEmailAddress, FAdminEmailAddress);

      Reg.WriteString('', cntIsClientAdapter, BoolAsStr(stClientAdapter in FServiceModes));
      Reg.WriteString('', cntIsActionProcessor, BoolAsStr(stActionProcessor in FServiceModes));
      if not FIsStandalone then
        Reg.WriteString('', cntIsActionDispatcher, BoolAsStr(stActionDispatcher in FServiceModes))
      else
        Reg.WriteString('', cntIsActionDispatcher, '2');
      Reg.WriteString('', cntIsMSMQReader, BoolAsStr(stMSMQReader in FServiceModes));
      Reg.WriteString('', cntIsMSMQWriter, BoolAsStr(stMSMQWriter in FServiceModes));
      Reg.WriteString('', cntIsReminder, BoolAsStr(stReminder in FServiceModes));
      Reg.WriteString('', cntIsTournament, BoolAsStr(stTournament in FServiceModes));
      Reg.WriteString('', cntIsGameAdapter, BoolAsStr(stGameAdapter in FServiceModes));
      Reg.CloseKey;
    end;
  end;

  Reg.Free;

  if PortPos > 0 then
  begin
    FClientAdapterPort := strtointdef(copy(FServiceName, PortPos + 1, MAXINT), FClientAdapterPort);
    FServiceModes := FServiceModes - [stActionDispatcher, stMSMQReader, stMSMQWriter, stTournament];
  end
  else
  if not FIsStandalone then
    FServiceModes := FServiceModes - [stClientAdapter, stGameAdapter];

  ServiceSettings := 'ServiceName=' + FServiceName +
    ', LocalHost=' + FLocalHost +
    ', LocalIP=' + FLocalIP +
    ', ConstantIPs=' + StringReplace(FConstantIPs.Text, #13#10, ',', [rfReplaceAll]) +
    ', RefreshTime=' + inttostr(FRefreshTime) +
    ', ClientAdapterPort=' + inttostr(FClientAdapterPort) +
    ', ClientAdapterSSL=' + BoolAsStr(FClientAdapterSSL) +
    ', ClientConnectionsAllowedStatus=' + inttostr(FClientConnectionsAllowedStatus) +
    ', ActionDispatcherHost=' + FActionDispatcherHost +
    ', ActionDispatcherPort=' + inttostr(FActionDispatcherPort) +
    ', ActionDispatcherID=' + inttostr(FActionDispatcherID) +
    ', MSMQHost=' + FMSMQHost +
    ', MSMQPath=' + FMSMQPath +
    ', AdminMSMQHost=' + FAdminMSMQHost +
    ', AdminMSMQPath=' + FAdminMSMQPath +
    ', SMTPPort=' + inttostr(FSMTPPort) +
    ', SMTPHost=' + FSMTPHost +
    ', SMTPFrom=' + FSMTPFrom +
    ', AdminEmailAddress=' + FAdminEmailAddress +
    ', SQLConnectionString=' + FSQLConnectionString + FSQLServerHost +
    ', ServiceModes=';
  if stClientAdapter in FServiceModes then
    ServiceSettings := ServiceSettings + 'ClientAdapter+';
  if stActionProcessor in FServiceModes then
    ServiceSettings := ServiceSettings + 'ActionProcessor+';
  if stActionDispatcher in FServiceModes then
    ServiceSettings := ServiceSettings + 'ActionDispatcherServer+'
  else
    ServiceSettings := ServiceSettings + 'ActionDispatcherClient+';
  if stMSMQReader in FServiceModes then
    ServiceSettings := ServiceSettings + 'MSMQReader+';
  if stMSMQWriter in FServiceModes then
    ServiceSettings := ServiceSettings + 'MSMQWriter+';
  if stReminder in FServiceModes then
    ServiceSettings := ServiceSettings + 'Reminder+';
  if stTournament in FServiceModes then
    ServiceSettings := ServiceSettings + 'Tournament+';
  if stGameAdapter in FServiceModes then
    ServiceSettings := ServiceSettings + 'GameAdapter+';

end;

procedure TCommonDataModule.StartWork;
begin
  FLogger := TLogger.Create(FLogFolder, FServiceName);
  Log(ClassName, 'DataModuleCreate', 'Created successfully with settings:' +
    ServiceSettings, ltBase);

  // Create Additional Objects
  FObjectPool := TObjectPool.Create(FRefreshTime);
  FRingUpThread := TRingUpThread.Create(False);{}
end;

destructor TCommonDataModule.Destroy;
begin
  FRingUpThread.Terminate;

  SaveActionLog;

  FRingUpThread.WaitFor;
  FRingUpThread.Free;

  FActionLogCache.Free;
  

  FObjectPool.Free;
  FConstantIPs.Free;


  Log(ClassName, 'DataModuleDestroy', 'Destroyed successfully', ltBase);
  FLogger.Free;

  CommonDataModule.ThreadLockHost.Del(FActionLogCache_CriticalSection);

  FCompressor := CoZip.Create;


end;

procedure TCommonDataModule.UpdateLocalHostAndIP;
const
  WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  if WSAStartup(WSVer, wsaData) = 0 then
  begin
    if GetHostName(@Buf, 128) = 0 then
    begin
      FLocalHost := StrPas(@Buf);
      P := GetHostByName(@Buf);
      if P <> nil then
        FLocalIP := iNet_ntoa(PInAddr(p^.h_addr^)^);
    end;
    WSACleanup;
  end;
end;

function TCommonDataModule.BoolAsStr(Value: Boolean): String;
begin
  if Value then
    Result := '1'
  else
    Result := '0';
end;

procedure TCommonDataModule.SaveSettingsToRegistry;
var
  Reg: TRegINIFile;
begin
  try
    Reg := TRegINIFile.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey('SOFTWARE\' + FServiceOriginalName + '\ServerSettings', True) then
      begin
        Reg.WriteInteger('', cntClientConnectionsAllowedStatus, FClientConnectionsAllowedStatus);
        Reg.WriteInteger('', cntProcessesStatus, FProcessesStatus);
        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;
  except
    on E: Exception do
      Log(ClassName, 'SaveRegistrySettings', E.Message, ltException);
  end;
end;

// Process and Dispatch Action XML

procedure TCommonDataModule.ProcessAction(ActionXML: String);
var
  XMLDoc: IXMLDocument;
begin
  try
    XMLDoc := TXMLDocument.Create(nil);
    try
      XMLDoc.XML.Text := ActionXML;
      XMLDoc.Active := True;
      ProcessXMLAction(XMLDoc.DocumentElement);
    finally
      XMLDoc.Active := false;
      XMLDoc := nil;
    end;
  except
    on E: Exception do
      Log(ClassName, 'ProcessAction', E.Message + ', Action:' + ActionXML, ltException);
  end;
end;

procedure TCommonDataModule.ProcessSessionAction(SessionID: Integer; const ActionXML: String);
var
  XMLDoc: IXMLDocument;
  XMLRoot: IXMLNode;
  Loop: Integer;
  XMLNode: IXMLNode;
  Loop2: Integer;
  XMLNode2: IXMLNode;
begin
  try
    XMLDoc := TXMLDocument.Create(nil);
    try
      XMLDoc.XML.Text := ActionXML;
      XMLDoc.Active := True;

      XMLRoot := XMLDoc.DocumentElement;

      // Add SessionID attribute to each action node
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
        begin
          XMLNode2 := XMLNode.ChildNodes.Nodes[Loop2];
          XMLNode2.Attributes[PO_ATTRSESSIONID] := inttostr(SessionID);
        end;
      end;

      // Parse the action
      ProcessXMLAction(XMLDoc.DocumentElement);
    finally
      XMLDoc.Active := false;
      XMLDoc := nil;
    end;
  except
    on E: Exception do
      Log(ClassName, 'ProcessAction', E.Message + ', SessionID=' + inttostr(SessionID) +
        ', Action:' + ActionXML, ltException);
  end;
end;

procedure TCommonDataModule.ProcessXMLAction(ActionXML: IXMLNode);
{
<objects>
  <object name="poObject|psService"> // Level of objects processing
    <action>                         // "sessionid" attributes in each action node
    ...
    </action>
  ...
</objects>
}
var
  XMLNode: IXMLNode;
  Loop: Integer;
  strNode: String;
  Handled: Boolean;
  Account: TAccount;
  API: TAPI;
  Email: TEmail;
  FileManager: TFileManager;
  User: TUser;
begin
  if lowercase(ActionXML.NodeName) <> PO_OBJECTS then
    Log(ClassName, 'ProcessAction',
      'Can not recognise the objects action: ' + ActionXML.XML, ltError)
  else
  begin
    for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
    try
      XMLNode := ActionXML.ChildNodes.Nodes[Loop];
      strNode := lowercase(XMLNode.Attributes[PO_ATTRNAME]);
      Handled := False;

      // Account
      if strNode = OBJ_ACCOUNT then
      begin
        Handled := True;
        Account := ObjectPool.GetAccount;
        try
          Account.ProcessAction(XMLNode);
        finally
          ObjectPool.FreeAccount(Account);
        end;
      end
      else
      // API
      if strNode = OBJ_API then
      begin
        Handled := True;
        API := ObjectPool.GetAPI;
        try
          API.ProcessAction(XMLNode);
        finally
          ObjectPool.FreeAPI(API);
        end;
      end
      else
      // Email
      if strNode = OBJ_EMAIL then
      begin
        Handled := True;
        Email := ObjectPool.GetEmail;
        try
          Email.ProcessAction(XMLNode);
        finally
          ObjectPool.FreeEmail(Email);
        end;
      end
      else
      // FileManager
      if strNode = OBJ_FILEMANAGER then
      begin
        Handled := True;
        FileManager := ObjectPool.GetFileManager;
        try
          FileManager.ProcessAction(XMLNode);
        finally
          ObjectPool.FreeFileManager(FileManager);
        end;
      end
      else
      // User
      if strNode = OBJ_USER then
      begin
        Handled := True;
        User := ObjectPool.GetUser;
        try
          User.ProcessAction(XMLNode);
        finally
          ObjectPool.FreeUser(User);
        end;
      end
      else
      // Settings
      if strNode = OBJ_COMMON then
      begin
        Handled := True;
        DoCommonActions(XMLNode, Handled);
      end;

      if not Handled then
        ActionDispatcher.ProcessAction(XMLNode, Handled);

      if not Handled then
        Log(ClassName, 'ProcessAction',
          'Can not recognise the action: ' + ActionXML.XML, ltError);
    except
      on E: Exception do
        Log(ClassName, 'ProcessAction', E.Message + ', Node:' + XMLNode.XML, ltException);
    end;
  end;
  strNode := '';
end;

procedure TCommonDataModule.DoCommonActions(ActionXML: IXMLNode; var Handled: Boolean);
var
  XMLNode: IXMLNode;
  Loop: Integer;
  strNode: String;
begin
  Handled := False;
  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
  begin
    XMLNode := ActionXML.ChildNodes.Nodes[Loop];
    strNode := XMLNode.NodeName;

    if strNode = CM_Settings then
    begin
      Handled := True;
      DoSettings(XMLNode);
    end;
  end;
end;

procedure TCommonDataModule.DoSettings(XMLNode: IXMLNode);
begin
  FClientConnectionsAllowedStatus := XMLNode.Attributes[CM_ClientConnectionsStatus];
  FProcessesStatus := XMLNode.Attributes[CM_ProcessesStatus];
end;

procedure TCommonDataModule.ReplicateSettings;
begin
  SendToAllServers(
    '<objects><object name="' + OBJ_ACTIONDISP + '" sendtoall="1">' +
    '<' + AD_SendToAll + '>' +
    '<objects><object name="' + OBJ_COMMON + '"><' + CM_Settings + ' ' +
      CM_ClientConnectionsStatus + '="' + inttostr(FClientConnectionsAllowedStatus) + '" ' +
      CM_ProcessesStatus + '="' + inttostr(FProcessesStatus) + '"' +
    '/></object></objects>' +
    '</' + AD_SendToAll + '>' +
    '</object></objects>');
end;

procedure TCommonDataModule.Log(const ClassName, MethodName,
  LogData: String; LogType: TLogType);
begin
  if (Self <> nil) and (FLogger <> nil) then
  begin
    if FLogging then
      FLogger.Log(ClassName, MethodName, LogData, LogType);
    if (LogType = ltException) or (LogType = ltError) or (LogType = ltBase) then
      FLogger.SystemLog(ClassName, MethodName, LogData, LogType);
  end;
end;


// Send MSMQ to Admin site or Desktop tool

procedure TCommonDataModule.SendAdminMSMQ(const Body: String; const MsgLabel: String = '');
var
  mqMsg       : MSMQMessage;
  Transaction : OleVariant;
  mqInfo      : TMSMQQueueInfo;
  mqQueue     : IMSMQQueue2;
  XMLDoc: IXMLDocument;
begin
  if not (stMSMQWriter in FServiceModes) then
  begin
    Log(ClassName, 'SendAdminMSMQ', 'Send MSMQ message remotely: ' +
      'Message: ' + Body + ', Label: ' + MsgLabel, ltCall);

    try
      XMLDoc := TXMLDocument.Create(nil);
      try
        XMLDoc.XML.Text := '<objects><object name="' + OBJ_MSMQWriter + '">' +
          '<' + MW_Message + '/></object></objects>';
        XMLDoc.Active := True;
        with XMLDoc.DocumentElement.ChildNodes.Nodes[0].ChildNodes.Nodes[0] do
        begin
          Attributes['body'] := Body;
          Attributes['label'] := MsgLabel;
        end;
        ProcessXMLAction(XMLDoc.DocumentElement);
      finally
        XMLDoc.Active := false;
        XMLDoc := nil;
      end;
    except
      on E: Exception do
        Log(ClassName, 'SendAdminMSMQ', E.Message, ltException);
    end;

    Exit;
  end;

  mqInfo := nil;
  try
    mqInfo := TMSMQQueueInfo.Create(nil);
    mqInfo.PathName := FAdminMSMQHost + FAdminMSMQPATH;
    mqQueue := nil;
  except
    on E:Exception do begin
      Log( ClassName, 'SendAdminMSMQ',
        'SendMSMQMessage (Create) [EXCEPTION]: ' + E.Message,
        ltException
      );

      mqQueue.Close;
      mqInfo.Free;
      Exit;
    end;
  end;

  try
    // MQSQ create
    mqQueue := mqInfo.Open(MQ_SEND_ACCESS, MQ_DENY_NONE);
  except
    on E:Exception do begin
      Log( ClassName, 'SendAdminMSMQ',
        'SendMSMQMessage (Open) [EXCEPTION]: ' + E.Message,
        ltException
      );

      mqQueue.Close;
      mqInfo.Free;
      Exit;
    end;
  end;

  try
    // Message prepare and send
    Transaction:=MQ_NO_TRANSACTION;
    mqMsg := CoMSMQMessage.Create;
    if MsgLabel = '' then
      mqMsg.Label_ := 'POKER'
    else
      mqMsg.Label_ := MsgLabel;
    mqMsg.Body := Body;
  except
    on E:Exception do begin
      Log( ClassName, 'SendAdminMSMQ',
        'SendMSMQMessage (Prepare) [EXCEPTION]: ' + E.Message,
        ltException
      );

      mqMsg := nil;
      mqQueue.Close;
      mqInfo.Free;
      Exit;
    end;
  end;

  try
    // Send
    mqMsg.Send(mqQueue, Transaction);
    mqMsg := nil;
  except
    on E:Exception do begin
      Log( ClassName, 'SendAdminMSMQ',
        'SendMSMQMessage (Send) [EXCEPTION]: ' + E.Message,
        ltException
      );

      mqMsg := nil;
      mqQueue.Close;
      mqInfo.Free;
      exit;
    end;
  end;

  mqQueue.Close;
  mqInfo.Free;

  Log(ClassName, 'SendAdminMSMQ', FAdminMSMQHost + FAdminMSMQPATH +
    ', Message: ' + Body + ', Label: ' + MsgLabel, ltCall);
end;

// Statuses

procedure TCommonDataModule.SetClientConnectionsAllowedStatus(const Value: Integer);
begin
  if FClientConnectionsAllowedStatus <> Value then
  begin
    FClientConnectionsAllowedStatus := Value;
    SaveSettingsToRegistry;
    ReplicateSettings;
  end;
end;

procedure TCommonDataModule.SetProcessesStatus(const Value: Integer);
begin
  if FProcessesStatus <> Value then
  begin
    FProcessesStatus := Value;
    SaveSettingsToRegistry;
    ReplicateSettings;
  end;
end;

procedure TCommonDataModule.RingUp;
begin
  try
    FThreadLockHost.RingUp;
    ActionDispatcher.RingUp;
    FObjectPool.RingUp;
    SaveActionLog;
    SendUpdatePacket;
  except
    on e: Exception do
      CommonDataModule.Log(ClassName, 'Execute', E.Message, ltException);
  end;
end;

{ TRingUpThread }

procedure TRingUpThread.Execute;
var
  Email: TEMail;
begin
  inherited;

  while True do
  try
    if (CommonDataModule <> nil) and (ActionDispatcher <> nil) then
      Break;
    Sleep(1);
  except
  end;

  Coinitialize(nil);
  try
    CommonDataModule.Log(ClassName, 'Execute', 'Thread has been started', ltBase);

    Email := CommonDataModule.ObjectPool.GetEmail;
    try
      Email.SendAdminEmail(0, 0,
        'Service was started: ' + CommonDataModule.LocalIP + ' (' + CommonDataModule.LocalHost +
        ') at ' + DateTimeToStr(Now), CommonDataModule.ServiceSettings);
    finally
      CommonDataModule.ObjectPool.FreeEmail(Email);
    end;
  except
  end;

  repeat
  try
    CommonDataModule.RingUp;
    Sleep(1000);
  except
    on e: Exception do
      CommonDataModule.Log(ClassName, 'Execute', E.Message, ltException);
  end;
  until Terminated;

  try
    Email := CommonDataModule.ObjectPool.GetEmail;
    try
      Email.SendAdminEmail(0, 0,
        'Service was stopped: ' + CommonDataModule.LocalIP + ' (' + CommonDataModule.LocalHost +
        ') at ' + DateTimeToStr(Now), CommonDataModule.ServiceSettings);
    finally
      CommonDataModule.ObjectPool.FreeEmail(Email);
    end;

    CommonDataModule.Log(ClassName, 'Execute', 'Thread has been finished', ltBase);
  except
  end;

  Couninitialize;
end;


// User notifications

function TCommonDataModule.GetNotifyAllPacket(const Data: String): String;
begin
  Result :=
    '<objects><object name="' + OBJ_ACTIONDISP + '">' +
    '<' + CA_NOTIFYALL + '>' +
    Data +
    '</' + CA_NOTIFYALL + '></object></objects>';
end;

function TCommonDataModule.GetNotifyUsersPacket(SessionIDs: array of Integer;
  UserIDs: array of Integer; const Data: String): String;
var
  Destinations: String;
  Loop: Integer;
begin
  Destinations := '';

  // Fill sessions
  Destinations := ' ' + CA_SessionIDs + '="';
  if Length(SessionIDs) > 0 then
  begin
    for Loop := 0 to Length(SessionIDs) - 1 do
    begin
      Destinations := Destinations + inttostr(SessionIDs[Loop]);
      if Loop < (Length(SessionIDs) - 1) then
        Destinations := Destinations + ',';
    end;
  end;
  Destinations := Destinations + '" ' + CA_UserIDs + '="';

  // Fill users
  if Length(UserIDs) > 0 then
  begin
    for Loop := 0 to Length(UserIDs) - 1 do
    begin
      Destinations := Destinations + inttostr(UserIDs[Loop]);
      if Loop < (Length(UserIDs) - 1) then
        Destinations := Destinations + ',';
    end;
  end;
  Destinations := Destinations + '"';

  if Destinations <> '' then
  Result :=
    '<objects><object name="' + OBJ_ACTIONDISP + '">' +
    '<' + CA_NOTIFY + Destinations + '>' +
    Data +
    '</' + CA_NOTIFY + '></object></objects>';
  Destinations := '';
end;

procedure TCommonDataModule.NotifyUser(SessionID: Integer; const Data: String;
  SendDirectly: Boolean = True);
begin
  if SessionID > 0 then
    ActionDispatcher.NotifyUsers([SessionID], [], Data, SendDirectly)
  else
    Log(ClassName, 'NotifyUser', 'SessionID=0', ltError);
end;

procedure TCommonDataModule.NotifyUserByID(UserID: Integer; const Data: String);
begin
  if UserID > 0 then
    ActionDispatcher.NotifyUsers([], [UserID], Data)
  else
    Log(ClassName, 'NotifyUserByID', 'UserID=0', ltError);
end;

procedure TCommonDataModule.NotifyUsers(SessionIDs: array of Integer; const Data: String);
begin
  if Length(SessionIDs) > 0 then
    ActionDispatcher.NotifyUsers(SessionIDs, [], Data)
  else
    Log(ClassName, 'NotifyUsers', 'SessionIDs is empty', ltError);
end;

procedure TCommonDataModule.NotifyUsersByID(UserIDs: array of Integer; const Data: String);
begin
  if Length(UserIDs) > 0 then
    ActionDispatcher.NotifyUsers([], UserIDs, Data)
  else
    Log(ClassName, 'NotifyUsersByID', 'UserIDs is empty', ltError);
end;

procedure TCommonDataModule.NotifyAllUsers(const Data: String);
begin
  ProcessAction(GetNotifyAllPacket(Data));
end;

procedure TCommonDataModule.NotifyClients(SessionIDs: array of Integer; Data: String);
begin
  ActionDispatcher.NotifyClients(SessionIDs, Data);
end;


// ActionLog

procedure TCommonDataModule.ActionLog(HandID: Integer; const Action: String);
begin
  FActionLogCache_CriticalSection.Lock;
  try
    FActionLogCache.AddObject(Action, Pointer(HandID));
  finally
    FActionLogCache_CriticalSection.UnLock;
  end;
end;

procedure TCommonDataModule.SaveActionLog;
var
  FSql: TSQLAdapter;
  HandID: Integer;
  Action: String;
  WorkFinished: Boolean;
  IterationCounter: Integer;
begin
  try
    if FActionLogCache.Count > 0 then
    begin
      FSql := FObjectPool.GetSQLAdapter;
      try
        WorkFinished := False;
        IterationCounter := 0;

        repeat
          HandID := 0;
          Action := '';
          FActionLogCache_CriticalSection.Lock;
          try
            if FActionLogCache.Count > 0 then
            begin
              HandID := Integer(FActionLogCache.Objects[0]);
              Action := FActionLogCache.Strings[0];
              FActionLogCache.Delete(0);
            end
            else
              WorkFinished := True;
          finally
            FActionLogCache_CriticalSection.UnLock;
          end;

          if (HandID > 0) and (Action <> '') then
          try
            FSql.Execute('update GameLog set [Data]=''' + Compress(Action) +
             ''' where Id=' + IntToStr(HandID));
          except
            on E:Exception do
            begin
              CommonDataModule.Log(ClassName, 'SaveActionLog', E.Message, ltException);
              WorkFinished := True;
            end;
          end;

          Inc(IterationCounter);
        until WorkFinished or (IterationCounter > 100);
      finally
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      end;
    end;
  except
    on E:Exception do
      CommonDataModule.Log(ClassName, 'SaveActionLog', E.Message, ltException);
  end;
end;


// Game Action processing

procedure TCommonDataModule.ProcessGameAction(ProcessID: Integer; const ActionText: String);
begin
  ActionDispatcher.ProcessGameAction(ProcessID, ActionText);
end;

procedure TCommonDataModule.DispatchGameAction(ProcessID, ActionDispatcherID: Integer;
  const ActionText: String);
begin
  ActionDispatcher.DispatchGameAction(ProcessID, ActionDispatcherID, ActionText);
end;

procedure TCommonDataModule.SendUpdatePacket;
var
  curAPI: TAPI;
  curSQL: TSQLAdapter;
  SummaryText: String;
  ProcessesText: String;
begin
  if (stActionDispatcher in FServiceModes) and
    (FActionDispatcherID = cntDefaultActionDispatcherID) and
    (SecondsBetween(Now, FLastUpdatePacketSentTime) > FRefreshTime) then
  begin
    curAPI := FObjectPool.GetAPI;
    curSQL := ObjectPool.GetSQLAdapter;
    try
      SummaryText := curAPI.GetSummaryXMLString(curSQL);
      ProcessesText := curAPI.GetProcessesXMLString(cntDefaultSubCategoryID, 0, 0, curSQL);

      FObjectPool.GetSummaryCache.SetCachedString(1, SummaryText);
      FObjectPool.GetProcessesCache.SetCachedString(cntDefaultSubCategoryID, ProcessesText, 0);

      ActionDispatcher.SendToAllActionClients(cntUpdatePacketsSignature + SummaryText +
        cntUpdatePacketsSignature + ProcessesText);

      FLastUpdatePacketSentTime := Now;
    finally
      FObjectPool.FreeSQLAdapter(curSQL);
      FObjectPool.FreeAPI(curAPI);
    end;
  end;
end;

procedure TCommonDataModule.ReceiveUpdatePacket(Data: String);
var
  sePos: Integer;
begin
  sePos := Pos(cntUpdatePacketsSignature, Data);
  if sePos > 0 then
  begin
    FObjectPool.GetSummaryCache.SetCachedString(1, copy(Data, 1, sePos - 1));
    FObjectPool.GetProcessesCache.SetCachedString(cntDefaultSubCategoryID,
      copy(Data, sePos + 1, MAXINT));
  end;
end;

procedure TCommonDataModule.SendToAllServers(const Data: String);
begin
  if FLogging then
    Log(ClassName, 'SendToAllServers', Data, ltRequest);
  if stActionDispatcher in FServiceModes then
    ProcessAction(Data)
  else
    ActionDispatcher.SendToAllActionServers(Data);
end;


function TCommonDataModule.Compress(Data: String): String;
begin
  Result := FCompressor.Compress(Data);
  if Result = '' then
    CommonDataModule.Log(ClassName, 'Compress', 'Error on compressing: ' +
      FCompressor._Error, ltError);
end;

function TCommonDataModule.UnCompress(Data: String): String;
begin
  Result := FCompressor.Extract(Data);
  if Result = '' then
    CommonDataModule.Log(ClassName, 'Compress', 'Error on decompressing: ' +
      FCompressor._Error, ltError);
end;


end.

