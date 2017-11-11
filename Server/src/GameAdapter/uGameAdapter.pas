unit uGameAdapter;

interface

uses
 Windows, Classes, SysUtils, SyncObjs,
 xmldom, XMLIntf, msxmldom, XMLDoc,
 uGameProcessThread, uXMLActions, uGameConnector, uPokerGameEngine, uLocker;

const
  LogProcessCount_Sec = 1000;
  ObsoleteProcessTime_Sec = 1000;

//xml consts
  XML_TAG_BOT_SIT_DOWN_AUTO         = 'bot_sitdown_auto';
  XML_TAG_BOT_SIT_DOWN              = 'bot_sitdown';
  XML_TAG_BOT_STAND_UP_ALL          = 'bot_standup_all';
  XML_TAG_PROCESS                   = 'process';

  XML_ATR_AUTO                      = 'auto';
  XML_ATR_MAX_NUMBER_PER_PROCESS    = 'maxnumberperprocess';
  XML_ATR_ID                        = 'id';
  XML_ATR_GUID                      = 'guid';
  XML_ATR_PLAY_POLICITY_TYPE        = 'type';

  PPTA_NAME                         = 'name';
  PPTA_VALUE                        = 'value';
  PP_LOWER_STAKES_LIMIT             = 'Lower Limit Of The Stakes';
  PP_MAX_CHAIRS_COUNT               = 'Maximum Chairs Count';
  PP_MIN_GAMERS_FOR_START           = 'Minimum Gamers To Start Hand';
  PP_TYPE_OF_STAKES                 = 'Type of Stakes';
  PPCN_TYPE_OF_STAKES_FIXED_LIMIT   =  1;
  PPCN_TYPE_OF_STAKES_POT_LIMIT     =  2;
  PPCN_TYPE_OF_STAKES_NO_LIMIT      =  3;
  PPCN_NAME_OF_STAKES_POT_LIMIT     =  'PL';
  PPCN_NAME_OF_STAKES_NO_LIMIT      =  'NL';

type
  TGameAdapter = class
  private
    FBotsAutomaticSitDown: Boolean;
    FBotsPerProcess: Integer;
    FBotsPlayPolicity: Integer;


    FProcesses_CriticalSection: TLocker;
    FGameProcessList: array of TGameProcessThread;

    FLastCheckProcessActivity: TDateTime;
    FLastLogProcessCount: TDateTime;

    function AddProcess(ProcessID: Integer; var GameProcessThread: TGameProcessThread): Boolean;
    function FindProcess(ProcessID: Integer; var GameProcessThread: TGameProcessThread): Boolean;
    procedure RemoveProcess(ProcessThread: TGameProcessThread);

    procedure DoSetDefaultProperties(ActionXML: IXMLNode);
    procedure DoGetDefaultProperties(ActionXML: IXMLNode);
    procedure DoUpdateProcessStatus(ActionXML: IXMLNode);
    procedure DoGetHand(ActionXML: IXMLNode);
    procedure DoGetHandText(ActionXML: IXMLNode);
    procedure DoCreatePrivateTable(ActionXML: IXMLNode);
    procedure DoProcessGameAction(ActionXML: IXMLNode);
    procedure ProcessGA_Action(ProcessID: Integer; ActionText: String);

    //bots addition
    procedure DoStandUpByAllProcesses(ActionXML: IXMLNode);
    procedure DoProcessBotSitDownAuto(ActionXML: IXMLNode);
    procedure DoProcessBotSitDownToProcesses(ActionXML: IXMLNode);

    procedure DoProcessActionByAllProcesses(ActionXML: IXMLNode);  overload;
    procedure DoProcessActionByAllProcesses(sAction: String); overload;

    procedure SendAdminResponce(nResult: Integer; sMsg, sGuid: string);
    function GetProcessDefaultProperties: String;
    function FindProcessIndex(ProcessID: Integer;
      var ProcessIndex: Integer): Boolean;

  public
    // methods
    procedure ProcessAction(ActionXML: IXMLNode);
    procedure ProcessGameAction(ProcessID: Integer; ActionText: String);
    function ActiveProcesses: Integer;
    procedure RingUp;
    procedure Stop;

    // constructor & destructor
    constructor Create;
    destructor Destroy; override;
  end;

  procedure ReinitAllProcesses;

implementation

uses
    uCommonDataModule
  , uLogger
  , uAPI
  , uSQLAdapter
  , uAccount
  , uEMail
  , uObjectPool
  , uErrorConstants
  , uXMLConstants
  , uSettings
  , DateUtils
  , DB;


// Administration routines

procedure ReinitAllProcesses;
var
  SQL: TSQLAdapter;
  API: TAPI;
  Account: TAccount;
  rs: TDataSet;
  //
  nProcessID: Integer;
begin
  // create pool objects
  SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
  API := CommonDataModule.ObjectPool.GetAPI;
  Account := CommonDataModule.ObjectPool.GetAccount;

  try
    rs := SQL.Execute('exec gaGetAllTerminatedProcesses');

    while not rs.EOF do
    begin
      nProcessID := rs.FieldByName('id').AsInteger;

      // reset participant info
      if API.SetParticipantCount(nProcessID, 0, 0) <> PO_NOERRORS then begin
        CommonDataModule.Log('GameAdapter', 'ReinitAllProcesses',
          '[ERROR] On execute FApi.SetParticipantCount; Params: ProcessID=' +
          IntToStr(nProcessID), ltError);
      end;

      // reinit table
      if API.InitProcess(nProcessID) <> PO_NOERRORS then begin
        CommonDataModule.Log('GameAdapter', 'ReinitAllProcesses',
          '[ERROR] On execute FApi.InitProcess; Params: ProcessID=' +
          IntToStr(nProcessID), ltError);
      end;

      // return all money
      if Account.ReturnAllMoneyFromGameProcess(nProcessID) <> PO_NOERRORS then begin
        CommonDataModule.Log('GameAdapter', 'ReinitAllProcesses',
          '[ERROR] On execute FAcc.ReturnAllMoneyFromGameProcess; Params: ProcessID=' +
          IntToStr(nProcessID), ltError);
      end;

      rs.Next;
    end;

  finally
    // free pool objects
    CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);
    CommonDataModule.ObjectPool.FreeAPI(API);
    CommonDataModule.ObjectPool.FreeAccount(Account);
  end;

  CommonDataModule.Log('GameAdapter', 'ReinitAllProcesses', 'Done', ltBase);
end;


{ TGameAdapter }

constructor TGameAdapter.Create;
begin
  inherited;

  try
    FBotsAutomaticSitDown := False;
    FBotsPerProcess       := -1;
    FBotsPlayPolicity     := 1;

    SetLength(FGameProcessList, 0);
    FProcesses_CriticalSection := CommonDataModule.ThreadLockHost.Add('gameadapter');

    FLastCheckProcessActivity := Now - 1;
    FLastLogProcessCount := Now - 1;
    CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create',E.Message, ltException);
  end;
end;

destructor TGameAdapter.Destroy;
begin
  try
    FLastCheckProcessActivity := Now - 1;
    FLastLogProcessCount := Now - 1;
    RingUp;

    Stop;

    FGameProcessList := nil;
    
    CommonDataModule.ThreadLockHost.Del(FProcesses_CriticalSection);
    CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;

  inherited;
end;


// Game Process List

function TGameAdapter.FindProcessIndex(ProcessID: Integer;
  var ProcessIndex: Integer): Boolean;
var
  Loop: Integer;
  curProcess: TGameProcessThread;
begin
  Result := False;
  ProcessIndex := -1;

  for Loop := 0 to Length(FGameProcessList) - 1 do
  try
    curProcess := FGameProcessList[Loop];
    if curProcess <> nil then
      if curProcess.ProcessID = ProcessID then
      begin
        ProcessIndex := Loop;
        Result := True;
        Break;
      end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'FindProcessIndex', E.Message, ltException);
  end;
end;

function TGameAdapter.FindProcess(ProcessID: Integer;
  var GameProcessThread: TGameProcessThread): Boolean;
var
  ProcessIndex: Integer;
begin
  Result := FindProcessIndex(ProcessID, ProcessIndex);
  if Result then
    GameProcessThread := FGameProcessList[ProcessIndex]
  else
    GameProcessThread := nil;
end;

function TGameAdapter.AddProcess(ProcessID: Integer;
  var GameProcessThread: TGameProcessThread): Boolean;
var
  Loop: Integer;
  EmptyIndex: Integer;
  curProcess: TGameProcessThread;
begin
  EmptyIndex := -1;
  GameProcessThread := nil;

  FProcesses_CriticalSection.Lock;
  try
    if FindProcess(ProcessID, GameProcessThread) then
      Result := True
    else
    begin
      try
        GameProcessThread := TGameProcessThread.Create(ProcessID);
      except
        on E: Exception do
        begin
          CommonDataModule.Log(ClassName, 'AddProcess', E.Message, ltException);
          GameProcessThread := nil;
        end;
      end;

      Result := GameProcessThread <> nil;
      if Result then
      begin
        for Loop := 0 to Length(FGameProcessList) - 1 do
        begin
          curProcess := FGameProcessList[Loop];
          if curProcess = nil then
          begin
            EmptyIndex := Loop;
            Break;
          end;
        end;

        if EmptyIndex = -1 then
        begin
          EmptyIndex := Length(FGameProcessList);
          SetLength(FGameProcessList, EmptyIndex + 1);
        end;

        FGameProcessList[EmptyIndex] := GameProcessThread;
      end;
    end;
  finally
    FProcesses_CriticalSection.UnLock;
  end;
end;

procedure TGameAdapter.RemoveProcess(ProcessThread: TGameProcessThread);
var
  ProcessIndex: Integer;
begin
  if FindProcessIndex(ProcessThread.ProcessID, ProcessIndex) then
  try
    begin
      FProcesses_CriticalSection.Lock;
      try
        FGameProcessList[ProcessIndex] := nil;
      finally
        FProcesses_CriticalSection.UnLock;
      end;
    end;
    ProcessThread.Free;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'RemoveProcess', E.Message, ltException);
  end;
end;

function TGameAdapter.ActiveProcesses: Integer;
var
  Loop: Integer;
  curProcess: TGameProcessThread;
begin
  Result := 0;
  for Loop := 0 to Length(FGameProcessList) - 1 do
  begin
    curProcess := FGameProcessList[Loop];
    if curProcess <> nil then
      Result := Result + 1;
  end;
end;

procedure TGameAdapter.Stop;
var
  Loop: Integer;
  curProcess: TGameProcessThread;
begin
  FProcesses_CriticalSection.Lock;
  try
    for Loop := 0 to Length(FGameProcessList) - 1 do
    try
      curProcess := FGameProcessList[Loop];
      if curProcess <> nil then
        curProcess.Free;
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'Stop', E.Message, ltException);
    end;
    SetLength(FGameProcessList, 0);
  finally
    FProcesses_CriticalSection.UnLock;
  end;
end;

// RingUp - periodical maintenance

procedure TGameAdapter.RingUp;
var
  Loop: Integer;
  curProcess: TGameProcessThread;
begin
  try
    // check for Process stopping and remove
    if SecondsBetween(Now, FLastCheckProcessActivity) > 3 * CommonDataModule.RefreshTime then
    begin
      FProcesses_CriticalSection.Lock;
      try
        for Loop := 0 to Length(FGameProcessList) - 1 do
        begin
          curProcess := FGameProcessList[Loop];
          if curProcess <> nil then
          try
            if (curProcess.ProcessState = psStopped) or
              (SecondsBetween(Now, curProcess.LastTimeActivity) > ObsoleteProcessTime_Sec) then
            begin
              FGameProcessList[Loop] := nil;
              curProcess.Free;
            end;
          except
            on E: Exception do
              CommonDataModule.Log(ClassName, 'RingUp', E.Message, ltException);
          end;
        end;
      finally
        FProcesses_CriticalSection.UnLock;
      end;
      FLastCheckProcessActivity := Now;
    end;

    // Log Process Count and send info to ActionDispatcher
    if SecondsBetween(Now, FLastLogProcessCount) > LogProcessCount_Sec then
    begin
        CommonDataModule.Log(ClassName, 'RingUp',
          'ProcessesCount=' + inttostr(ActiveProcesses), ltBase);
      FLastLogProcessCount := Now;
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'RingUp', E.Message, ltException);
  end;
end;


// Actions Processing

procedure TGameAdapter.ProcessAction(ActionXML: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
  try
    XMLNode := ActionXML.ChildNodes.Nodes[Loop];
    strNode := XMLNode.NodeName;

    if strNode = GA_ACTION then
      DoProcessGameAction(XMLNode)
    else
    if strNode = PO_SETDEFPROP then
      DoSetDefaultProperties(XMLNode)
    else
    if strNode = PO_GETDEFPROP then
      DoGetDefaultProperties(XMLNode)
    else
    if strNode = GA_PROCESSESSTATUS then
      DoUpdateProcessStatus(XMLNode)
    else
    if strNode = PO_ADMGETHAND then
      DoGetHand(XMLNode)
    else
    if strNode = PO_ADMGETHANDTEXT then
      DoGetHandText(XMLNode)
    else
    if strNode = GA_CreatePrivateTable then
      DoCreatePrivateTable(XMLNode)
    else
    if (strNode = GA_BOT_SIT_DOWN_AUTO) then
      DoProcessBotSitDownAuto(XMLNode)
    else
    if (strNode = GA_BOT_SIT_DOWN) then
      DoProcessBotSitDownToProcesses(XMLNode)
    else
    if (strNode = GA_BOT_STAND_UP_ALL) then
      DoStandUpByAllProcesses(XMLNode)
    else
      DoProcessGameAction(XMLNode);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ProcessAction', E.Message + ' on: ' +
      XMLNode.XML, ltException);
  end;
end;


procedure TGameAdapter.DoSetDefaultProperties(ActionXML: IXMLNode);
var
  FGameConnector: TGameConnector;
  aGameProcessThread: TGameProcessThread;
  nRes, nProcessID: Integer;
  sRes, sData, sGuid: string;
  aNode: IXMLNode;
begin
  aNode := ActionXML;

  sGuid := '';
  if aNode.HasAttribute(PO_ATTRGUID) then
    sGuid := aNode.Attributes[PO_ATTRGUID];

  nRes := 0;

  nProcessID := -1;
  if not aNode.HasChildNodes then begin
    nRes := GA_ERR_CORRUPTREQUESTXML;
    CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
      '[ERROR] XML has not child nodes. XML=[' + aNode.XML + ']',
      ltError
    );

    sData :=
    '<setdefprop result="' + IntToStr(nRes) + '" ' +
      'id="' + IntToStr(nProcessID) + '"' +
    '/>';
    CommonDataModule.SendAdminMSMQ(sData, sGuid);
    Exit;
  end;
  if aNode.HasAttribute('processid') then
    nProcessID := StrToIntDef(aNode.Attributes['processid'], -1);
  if (nProcessID > 0) then
  begin
    FindProcess(nProcessID, aGameProcessThread);
    if aGameProcessThread = nil then
    begin
      FGameConnector := TGameConnector.Create;
      try
        nRes := FGameConnector.InitGameProcess(nProcessID, aNode.ChildNodes[0].XML, sRes);
        if nRes <> 0 then
          CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
            '[ERROR] On execute FGameConnector.InitGameProcess: ProcessID=' +
              IntToStr(nProcessID) + ', Reason=' + sRes + ', Action=' + aNode.ChildNodes[0].XML, ltError);
      finally
        FGameConnector.Free;
      end;
    end;
  end else begin
    CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
      '[ERROR]: Incorrect ProcessID=' + IntToStr(nProcessID) + ', Action=' + aNode.XML,
      ltError
    );
    nRes := GA_ERR_UNKNOWNACTION;
  end;
  sData :=
  '<setdefprop result="' + IntToStr(nRes) + '" ' +
    'id="' + IntToStr(nProcessID) + '"' +
  '/>';
  CommonDataModule.SendAdminMSMQ(sData, sGuid);
end;

procedure TGameAdapter.DoGetDefaultProperties(ActionXML: IXMLNode);
var
  sData, sGuid: string;
  aNode: IXMLNode;
begin
  aNode := ActionXML;

  sGuid := '';
  if aNode.HasAttribute(PO_ATTRGUID) then
    sGuid := aNode.Attributes[PO_ATTRGUID];

  sData := GetProcessDefaultProperties;
  if sData <> '' then
    CommonDataModule.SendAdminMSMQ(sData, sGuid);
end;

function TGameAdapter.GetProcessDefaultProperties: String;
var
  FGameConnector: TGameConnector;
  nRes: Integer;
  sRes: string;
begin
  Result := '';
  try
    FGameConnector := TGameConnector.Create;
    try
      nRes := FGameConnector.GetDefaultProperties(Result, sRes);
      if (nRes <> 0) then
      begin
        CommonDataModule.Log(ClassName, 'GetProcessDefaultProperties',
          'On execute FGameConnector.GetDefaultProperties: ' + sRes, ltError);
      end;
    finally
      FGameConnector.Free;
    end;
  except
    On E: Exception do
      CommonDataModule.Log(ClassName, 'GetProcessDefaultProperties', E.Message, ltException);
  end;
end;

procedure TGameAdapter.DoGetHand(ActionXML: IXMLNode);
var
  FApi: TAPI;
  nRes, nID: Integer;
  sData, sGuid: string;
  aNode: IXMLNode;
begin
  aNode := ActionXML;

  sGuid := '';
  if aNode.HasAttribute(PO_ATTRGUID) then
    sGuid := aNode.Attributes[PO_ATTRGUID];

  sData := '';

  nID := -1;
  if aNode.HasAttribute(PO_ATTRID) then
    nID := StrToIntDef(aNode.Attributes[PO_ATTRID], -1);

  if (nID <= 0) then begin
    CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
      '[ERROR] On Admin request get recorded hand: Not exists or incorrect attribute id=' + IntToStr(nID),
      ltError
    );
    sData :=
      '<gaaction result="' + IntToStr(GA_ERR_UNDEFINEDHANDID) + '" ' +
        'id="' + IntToStr(nID) + '"' +
      '/>';
  end else begin
    FApi := CommonDataModule.ObjectPool.GetAPI;
    try
      nRes := FApi.GetPersonalHandHistory(-1, nID, 0, sData);
      if nRes <> 0 then begin
        CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
          '[ERROR] On Execute FApi.GetPersonalHandHistory: Return result= ' + IntToStr(nRes) + '.' +
            ' Parameters: UserID= 0, HandID= ' + IntToStr(nID) + ' RemoveOtherRanking= 0',
          ltError
        );
        sData :=
          '<gaaction result="' + IntToStr(nRes) + '" ' +
            'id="' + IntToStr(nID) + '"' +
          '/>';
      end;
    finally
      CommonDataModule.ObjectPool.FreeAPI(FApi);
    end;
  end;
  if sData = '' then begin
    CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
      '[ERROR] On Execute FApi.GetPersonalHandHistory: Return patameter sData is empty.' +
        ' Parameters: UserID= 0, HandID= ' + IntToStr(nID) + ' RemoveOtherRanking= 0',
      ltError
    );
    sData :=
      '<gaaction result="' + IntToStr(GA_ERR_ONEXECUTEAPI) + '" ' +
        'id="' + IntToStr(nID) + '"' +
      '/>';
  end;

  CommonDataModule.SendAdminMSMQ(sData, sGuid);
end;

procedure TGameAdapter.DoGetHandText(ActionXML: IXMLNode);
var
  FApi: TAPI;
  nRes, nID: Integer;
  sData, sGuid: string;
  aNode: IXMLNode;
begin
  aNode := ActionXML;

  sGuid := '';
  if aNode.HasAttribute(PO_ATTRGUID) then
    sGuid := aNode.Attributes[PO_ATTRGUID];

  sData := '';

  nID := -1;
  if aNode.HasAttribute(PO_ATTRID) then
    nID := StrToIntDef(aNode.Attributes[PO_ATTRID], -1);

  if (nID <= 0) then begin
    CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
      '[ERROR] On Admin request get recorded hand as text: Not exists or incorrect attribute id=' + IntToStr(nID),
      ltError
    );
  end else begin
    FApi := CommonDataModule.ObjectPool.GetAPI;
    try
      nRes := FApi.GetPersonalHandHistoryAsText(-1, nID, sData);
      if (nRes <> 0) then begin
        CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
          '[ERROR] On Execute FApi.GetPersonalHandHistoryAsText: Return result =' + IntToStr(nRes) + '; HandID=' + IntToStr(nID),
          ltError
        );
        sData := '';
      end;
    finally
      CommonDataModule.ObjectPool.FreeAPI(FApi);
    end;
  end;

  CommonDataModule.SendAdminMSMQ(sData, sGuid);
end;

procedure TGameAdapter.DoUpdateProcessStatus(ActionXML: IXMLNode);
var
  nStatusID: Integer;
  sGuid: string;
  aNode: IXMLNode;
begin
  aNode := ActionXML;

  sGuid := '';
  if aNode.HasAttribute(PO_ATTRGUID) then
    sGuid := aNode.Attributes[PO_ATTRGUID];

  nStatusID := -1;
  if aNode.HasAttribute('statusid') then
    nStatusID := StrToIntDef(aNode.Attributes['statusid'], -1);

  if nStatusID in [1,2,3] then
    CommonDataModule.ProcessesStatus := nStatusID
  else
    CommonDataModule.Log(ClassName, 'CheckOnAdminAction',
      '[ERROR]: Incorrect attribute statusid=' + IntToStr(nStatusID),
      ltError
    );
end;

procedure TGameAdapter.DoProcessGameAction(ActionXML: IXMLNode);
var
  ProcessID: Integer;
begin
  ProcessID := 0;
  if ActionXML.HasAttribute(PO_ATTRPROCESSID) then
    ProcessID := strtointdef(ActionXML.Attributes[PO_ATTRPROCESSID], 0);

  if ProcessID > 0 then
    ProcessGA_Action(ProcessID, ActionXML.XML)
  else
    CommonDataModule.Log(ClassName, 'DoProcessGameAction', 'ProcessID=0', ltError);
end;

procedure TGameAdapter.ProcessGA_Action(ProcessID: Integer; ActionText: String);
var
  curProcess: TGameProcessThread;
  sAction: String;
begin
  if CommonDataModule.ProcessesStatus = 3 then
  begin
    CommonDataModule.Log(ClassName, 'ProcessGameAction',
      'Action not processed because ProcessesStatus = 3', ltError);
    Exit;
  end;

  if ProcessID > 0 then
  begin
    if not FindProcess(ProcessID, curProcess) then
    begin
      AddProcess(ProcessID, curProcess);

      //bots addon
      if (FBotsAutomaticSitDown) then
      begin
        //notify all process about auto on
        sAction:= '<gaaction processid="%d" sessionid="0">' +
                    '<'+XML_TAG_BOT_SIT_DOWN + ' ' +
                        XML_ATR_MAX_NUMBER_PER_PROCESS + '="' + IntToStr(FBotsPerProcess) + '" ' +
                        XML_ATR_PLAY_POLICITY_TYPE + '="'+ IntToStr(FBotsPlayPolicity) +'" ' +
                    '/>' +
                  '</gaaction>';

        if Assigned(curProcess) then
          curProcess.ProcessAction(Format(sAction, [curProcess.ProcessID]));
      end;//if
    end;//if

    if curProcess <> nil then
      if curProcess.ProcessState = psStopped then
        RemoveProcess(curProcess)
      else
        curProcess.ProcessAction(ActionText);
  end
  else
    CommonDataModule.Log(ClassName, 'ProcessGA_Action', 'ProcessID=0', ltError);
end;

procedure TGameAdapter.ProcessGameAction(ProcessID: Integer; ActionText: String);
var
  XMLDoc: IXMLDocument;
begin
  if (ProcessID > 0) and (lowercase(copy(ActionText, 1, 9)) = '<gaaction') then
    ProcessGA_Action(ProcessID, ActionText)
  else
  try
    XMLDoc := TXMLDocument.Create(nil);
    try
      XMLDoc.XML.Text := '<objects><object name="' + OBJ_GameAdapter + '">' +
        ActionText + '</object></objects>';
      XMLDoc.Active := True;
      ProcessAction(XMLDoc.DocumentElement.ChildNodes.Nodes[0]);
    finally
      XMLDoc.Active := false;
      XMLDoc := nil;
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ProcessGameAction', E.Message, ltException);
  end;
end;


procedure TGameAdapter.DoStandUpByAllProcesses(ActionXML: IXMLNode);
var
  nIndx,
  ProcessID: Integer;
  sAction,
  sReason,
  sGuid: String;
  XMLProcessNode: IXMLNode;
  Process: TGameProcessThread;
  nResult: Integer;
begin

  sGuid := '';
  if ActionXML.HasAttribute(XML_ATR_GUID) then sGuid := ActionXML.Attributes[XML_ATR_GUID];

  if (CommonDataModule.ProcessesStatus = 3) then begin
    sReason := 'Action not processed because ProcessesStatus = 3';
    nResult := 1;
    CommonDataModule.Log(ClassName, 'ProcessGameAction', sReason, ltError);

    SendAdminResponce(nResult, sReason, sGuid);
    Exit;
  end;//if

  nResult:= 0;
  sReason:= '';
  sAction:= '<gaaction processid="%d" sessionid="0"><bot_standup_all/></gaaction>';

  if (ActionXML.ChildNodes.Count = 0) then begin
    //notify all processes
    try
      for nIndx:= 0 to Length(FGameProcessList) - 1 do
      begin
        Process := FGameProcessList[nIndx];
        if Process <> nil then
        begin
          ProcessID:= Process.ProcessID;
          Process.ProcessAction(Format(sAction, [ProcessID]));
        end;
      end;//for
    except
      on E: Exception do begin
        nResult:= 1;
        sReason:= 'Exception While Processing Notification Of All Processes';
        CommonDataModule.Log(ClassName, 'DoProcessActionByAllProcesses', 'While Processing Notification Of All Processes [' + E.Message + ']', ltException);
      end;//on
    end;//try-except
  end else begin

    //notify processes from list
    try
      XMLProcessNode:= ActionXML.ChildNodes.First;
      while Assigned(XMLProcessNode) do begin
        ProcessID:= XMLProcessNode.Attributes[XML_ATR_ID];
        Process:= nil;

        if FindProcess(ProcessID, Process) then begin
          Process.ProcessAction(Format(sAction, [ProcessID]));
        end;//for

        XMLProcessNode:= XMLProcessNode.NextSibling;
      end;//while
    except
      on E: Exception do begin
        nResult:= 2;
        sReason:= 'Exception While Processing Notification Of Processes From List';
        CommonDataModule.Log(ClassName, 'DoProcessActionByAllProcesses', 'While Processing Notification Of Processes From List ['+E.Message+']', ltException);
      end;//on
    end;//try-except

  end;//if

  //send to admin site result op prcessing
  SendAdminResponce(nResult, sReason, sGuid);
end;

procedure TGameAdapter.DoProcessBotSitDownAuto(ActionXML: IXMLNode);
var
  sAction,
  sReason,
  sGuid: string;
  nRes: Integer;
begin
  nRes := 0;
  sReason:= '';

  sGuid := '';
  if (ActionXML.HasAttribute(XML_ATR_GUID)) then
    sGuid := ActionXML.Attributes[XML_ATR_GUID];

  if (not ActionXML.HasAttribute(XML_ATR_AUTO)) then begin
    nRes := 1;
    sReason := 'Command has not attribute ' + XML_ATR_AUTO;
    SendAdminResponce(nRes, sReason, sGuid);
    Exit;
  end;

  FBotsAutomaticSitDown:= Boolean(Integer(ActionXML.Attributes[XML_ATR_AUTO]));
  try
    if (FBotsAutomaticSitDown) then begin
      if (ActionXML.HasAttribute(XML_ATR_MAX_NUMBER_PER_PROCESS)) and
         (ActionXML.HasAttribute(XML_ATR_PLAY_POLICITY_TYPE))     then begin

        //gettings settings
        FBotsPerProcess   := ActionXML.Attributes[XML_ATR_MAX_NUMBER_PER_PROCESS];
        FBotsPlayPolicity := ActionXML.Attributes[XML_ATR_PLAY_POLICITY_TYPE];

        //notify all process about auto on
        sAction:= '<'+XML_TAG_BOT_SIT_DOWN + ' ' +
                    XML_ATR_MAX_NUMBER_PER_PROCESS + '="' + IntToStr(FBotsPerProcess) + '" ' +
                    XML_ATR_PLAY_POLICITY_TYPE + '="'+ IntToStr(FBotsPlayPolicity) +'" ' +
                  '/>';

        DoProcessActionByAllProcesses(sAction);

      end else begin
        FBotsAutomaticSitDown := False;
        FBotsPerProcess       := -1;
      end;//if

    end else begin
      FBotsPerProcess:= -1;
    end;//if

  except
    on E: Exception do begin
      nRes := 2;
      sReason:= 'Exception While Processing';
      CommonDataModule.Log(ClassName, 'DoProcessBotSitDownAuto', 'While Processing ['+E.Message+']', ltException);
    end;//on
  end;//try-except


  //send to admin site result op prcessing
  SendAdminResponce(nRes, sReason, sGuid);
end;

procedure TGameAdapter.DoProcessActionByAllProcesses(sAction: String);
var
  nIndx,
  ProcessID: Integer;
  Process: TGameProcessThread;
begin

  if (CommonDataModule.ProcessesStatus = 3) then begin
    CommonDataModule.Log(ClassName, 'ProcessGameAction',
      'Action not processed because ProcessesStatus = 3', ltError);
    Exit;
  end;//if

  sAction:= '<gaaction processid="%d" sessionid="0">'+ sAction +'</gaaction>';

  //notify all processes
  try
    for nIndx:= 0 to Length(FGameProcessList) - 1 do
    begin
      Process := FGameProcessList[nIndx];
      if Process <> nil then
      begin
        ProcessID:= Process.ProcessID;
        Process.ProcessAction(Format(sAction, [ProcessID]));
      end;
    end;//for
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'DoProcessActionByAllProcesses', 'While Processing Notification Of All Processes [' + E.Message + ']', ltException);
    end;//on
  end;//try-except
end;

procedure TGameAdapter.DoProcessActionByAllProcesses(ActionXML: IXMLNode);
begin
  DoProcessActionByAllProcesses(ActionXML.XML);
end;

procedure TGameAdapter.DoProcessBotSitDownToProcesses(ActionXML: IXMLNode);
var
  sAction, sGuid: string;
  I,
  nProcessID,
  memBotsPerProcess,
  memBotsPlayPolicity: Integer;
  memBotsAutomaticSitDown: Boolean;
  aChNode: IXMLNode;
begin

  { Backup Bots values }
  memBotsAutomaticSitDown := FBotsAutomaticSitDown;
  FBotsAutomaticSitDown := False;
  memBotsPerProcess := FBotsPerProcess;
  memBotsPlayPolicity := FBotsPlayPolicity;

  try
    sGuid := '';
    if ActionXML.HasAttribute(XML_ATR_GUID) then
      sGuid := ActionXML.Attributes[XML_ATR_GUID];

    if (ActionXML.HasAttribute(XML_ATR_MAX_NUMBER_PER_PROCESS)) and
       (ActionXML.HasAttribute(XML_ATR_PLAY_POLICITY_TYPE))     then begin

      //gettings settings
      FBotsPerProcess   := ActionXML.Attributes[XML_ATR_MAX_NUMBER_PER_PROCESS];
      FBotsPlayPolicity := ActionXML.Attributes[XML_ATR_PLAY_POLICITY_TYPE];

      //notify all process about auto on
      for I:=0 to ActionXML.ChildNodes.Count - 1 do begin
        aChNode := ActionXML.ChildNodes[I];
        if (aChNode.NodeName <> XML_TAG_PROCESS) then Continue;
        if not aChNode.HasAttribute(XML_ATR_ID) then Continue;
        nProcessID := StrToIntDef(aChNode.Attributes[XML_ATR_ID], -1);
        if (nProcessID <= 0) then Continue;

        sAction:=
          '<' + GA_ACTION + ' processid="' + IntToStr(nProcessID) + '" sessionid="0">' +
            '<'+XML_TAG_BOT_SIT_DOWN + ' ' +
              XML_ATR_MAX_NUMBER_PER_PROCESS + '="' + IntToStr(FBotsPerProcess) + '" ' +
              XML_ATR_PLAY_POLICITY_TYPE + '="'+ IntToStr(FBotsPlayPolicity) +'" ' +
            '/>' +
          '</' + GA_ACTION + '>';

        ProcessGA_Action(nProcessID, sAction)
      end;

    end;//if

  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'DoProcessBotSitDownToProcesses', 'While Processing ['+E.Message+']', ltException);
    end;//on
  end;//try-except

  { Restore Bots values }
  FBotsAutomaticSitDown := memBotsAutomaticSitDown;
  FBotsPerProcess := memBotsPerProcess;
  FBotsPlayPolicity := memBotsPlayPolicity;
end;

procedure TGameAdapter.SendAdminResponce(nResult: Integer; sMsg, sGuid: string);
var
  sBody: string;
begin
  if (sGuid = '') then Exit;

  sBody:= '<'+XML_TAG_BOT_SIT_DOWN_AUTO+' result="' + IntToStr(nResult) + '"';
  if (sMsg <> '') then sBody:= sBody + ' message="' + sMsg + '"';
  sBody:= sBody + ' ' + XML_ATR_GUID + '="' + sGuid +'"/>';

  CommonDataModule.SendAdminMSMQ(sBody, sGuid);
end;

procedure TGameAdapter.DoCreatePrivateTable(ActionXML: IXMLNode);
{
Request:
<objects>
  <object name="gameadapter">
      <gacreateprivatetable userid="1234" name="My Table" public="0|1"
      password="qwerty1" lowerstakes="2|4|5|10|12|30"
      activatedtime="12/31/2005 11:00 PM" minplayerstostart="2..8">
		<invited username="Mr. Smith"/>
		<invited username="Ms. Smith"/>
		...
</gacreateprivatetable>
  </object>
</objects>

Response:
<object name="lobby">
<gacreateprivatetable result="0|..." reason="Mr. Smith is invalid">
<object/>
}
var
  UserID: Integer;
  TableName: String;
  isPublic: Integer;
  Password: String;
  Stakes: String;
  SpacePos: Integer;
  LowerStakes: Integer;
  GameType: Integer;
  ActivatedTime: TDateTime;
  MinPlayersToStart: Integer;
  ActionDispactherID: Integer;
  XMLSettings: String;
  FSQL: TSQLAdapter;
  FAPI: TAPI;
  GameProcessID: Integer;
  GameProcessStatus: String;
  Loop: Integer;
  Success: Boolean;
  ResultCode: String;
  ResultReason: String;
  XMLDoc: IXMLDocument;
  XMLRoot: IXMLNode;
  XMLNode: IXMLNode;
  XMLName: String;
begin
  // Get default settings of the process
  ResultReason := 'Error on creating Game engine';
  Success := False;
  GameProcessID := 0;
  UserID := 0;
  GameType := PPCN_TYPE_OF_STAKES_FIXED_LIMIT;
  XMLSettings := GetProcessDefaultProperties;
  if XMLSettings <> '' then
  try
    Success := True;
    // Get data from XML Node
    UserID := strtointdef(ActionXML.Attributes['userid'], 0);
    TableName := ActionXML.Attributes['name'];
    IsPublic := strtointdef(ActionXML.Attributes['public'], 0);
    Password := ActionXML.Attributes['password'];
    Stakes := ActionXML.Attributes['lowerstakes'];
    SpacePos := Pos(' ', Stakes);
    if SpacePos > 0 then
      LowerStakes := strtointdef(copy(Stakes, SpacePos + 1, MaxInt), 2)
    else
      LowerStakes := strtointdef(Stakes, 2);
    if Pos(PPCN_NAME_OF_STAKES_POT_LIMIT, Stakes) > 0 then
      GameType := PPCN_TYPE_OF_STAKES_POT_LIMIT;
    if Pos(PPCN_NAME_OF_STAKES_NO_LIMIT, Stakes) > 0 then
      GameType := PPCN_TYPE_OF_STAKES_NO_LIMIT;
    ActivatedTime := StrToDateTimeDef(ActionXML.Attributes['activatedtime'], Now);
    MinPlayersToStart := strtointdef(ActionXML.Attributes['minplayerstostart'], 2);

    if (UserID > 0) and (TableName <> '') then
    begin
      // Change process properties (Number of chairs, Lower stakes, Minimum number of players to start game)
      try
        XMLDoc := TXMLDocument.Create(nil);
        try
          XMLDoc.XML.Text := XMLSettings;
          XMLDoc.Active := True;
          XMLRoot := XMLDoc.DocumentElement.ChildNodes.Nodes[0];
          for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
          begin
            XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
            XMLName := XMLNode.Attributes[PPTA_NAME];
            if XMLName = PP_TYPE_OF_STAKES then
              XMLNode.Attributes[PPTA_VALUE] := GameType;
            if XMLName = PP_LOWER_STAKES_LIMIT then
              XMLNode.Attributes[PPTA_VALUE] := LowerStakes;
            if XMLName = PP_MAX_CHAIRS_COUNT then
              XMLNode.Attributes[PPTA_VALUE] := 8;
            if XMLName = PP_MIN_GAMERS_FOR_START then
              XMLNode.Attributes[PPTA_VALUE] := MinPlayersToStart;
          end;
          XMLSettings := XMLDoc.XML.Text;
        finally
          XMLDoc := nil;
        end;
      except
        on E: Exception do
        begin
          CommonDataModule.Log(ClassName, 'DoCreatePrivateTable', E.Message, ltException);
          Success := False;
          ResultReason := 'Error on changing table parameters';
        end;
      end;

      if Success then
      begin
        // Create the process
        FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
        try
          // Detect ActionDispatcherID
          ActionDispactherID := cntDefaultActionDispatcherID;
          FSQL.SetProcName('gaGetActionDispatcherID');
          FSQL.AddParam('ActionDispatcherID', ActionDispactherID, ptInputOutput, ftInteger);
          ActionDispactherID := strtointdef(FSQL.GetParam('ActionDispatcherID'), ActionDispactherID);

          FSQL.SetProcName('apiCreateFirstGameProcess');
          FSQL.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
          FSQL.AddParam('GameEngineID', 3, ptInput, ftInteger);
          FSQL.AddParam('Name', TableName, ptInput, ftString);
          FSQL.AddParam('CurrencyTypeID', 2, ptInput, ftInteger);
          FSQL.AddParam('SubCategoryID', 1, ptInput, ftInteger);
          FSQL.AddParam('SettingsXml', XMLSettings, ptInput, ftString);
          FSQL.AddParam('GameProcessID', GameProcessID, ptInputOutput, ftInteger);
          FSQL.AddParam('ActionDispatcherID', ActionDispactherID, ptInput, ftInteger);
          FSQL.AddParam('ActivatedTime', ActivatedTime, ptInput, ftDateTime);
          FSQL.AddParam('ProtectedCode', Password, ptInput, ftString);
          FSQL.AddParam('Visible', IsPublic, ptInput, ftInteger);
          FSQL.AddParam('CreatorUserID', UserID, ptInput, ftInteger);
          FSQL.AddParam('ProtectedMode', 1, ptInput, ftInteger);
          FSQL.AddParam('IsHighlighted', 0, ptInput, ftInteger);
          FSQL.AddParam('IsMassWatchingAllowed', 0, ptInput, ftInteger);
          FSQL.ExecuteCommand;
          Success := Success and (FSQL.GetParam('RETURN_VALUE') = 1);
          if not Success then
            ResultReason := 'Error on creating table';
          GameProcessID := strtointdef(FSQL.GetParam('GameProcessID'), 0);

          // Add Invited users
          if Success then
          begin
            // Add table creator
            if ActionXML.ChildNodes.Count > 0 then
              FSQL.Execute('insert into InvitedUsers (ProcessID, UserID) values (' +
                inttostr(GameProcessID) + ',' + inttostr(UserID) + ')');

            // Add other invited users
            for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
            begin
              FSQL.SetProcName('gaAddInvitedUser');
              FSQL.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
              FSQL.AddParam('GameProcessID', GameProcessID, ptInput, ftInteger);
              FSQL.AddParam('UserName', ActionXML.ChildNodes.Nodes[Loop].Attributes['username'],
                ptInput, ftString);
              FSQL.ExecuteCommand;
              Success := Success and (FSQL.Getparam('RETURN_VALUE') = 0);
              if not Success then
              begin
                ResultReason := 'Error on adding invited user ' +
                  ActionXML.ChildNodes.Nodes[Loop].Attributes['username'];
                Break;
              end;
            end;
          end;
        finally
          CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      CommonDataModule.Log(ClassName, 'DoCreatePrivateTable', E.Message, ltException);
      Success := False;
      ResultReason := 'Error on creating new table';
    end;
  end;

  // Init created process
  if Success then
  try
    FAPI := CommonDataModule.ObjectPool.GetAPI;
    try
      if FAPI.InitProcess(GameProcessID) = PO_NOERRORS then
      begin
        Success := True;
        ResultReason := 'Private table was successfully created';
      end
      else
      begin
        Success := False;
        ResultReason := 'Error on new table initialization';
      end;
    finally
      CommonDataModule.ObjectPool.FreeAPI(FAPI);
    end;
  except
    on E: Exception do
    begin
      CommonDataModule.Log(ClassName, 'DoCreatePrivateTable', E.Message, ltException);
      Success := False;
      ResultReason := 'Error on new table initialization';
    end;
  end;

  // Set status of the process into the database
  if GameProcessID > 0 then
  try
    FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      if Success then
        // Enable process if table was created successfully
        GameProcessStatus := '1'
      else
        // Disable process if table creation have failed
        GameProcessStatus := '2';
      FSQL.Execute('update gameprocess set statusid=' + GameProcessStatus +
        ' where [id]=' + inttostr(GameProcessID));
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
    end;
  except
    on E: Exception do
    begin
      CommonDataModule.Log(ClassName, 'DoCreatePrivateTable', E.Message, ltException);
      Success := False;
      ResultReason := 'Error on creating new table';
    end;
  end;

  // Send result response to creator
  if Success then
    ResultCode := '0'
  else
    ResultCode := '1';

  if UserID > 0 then
    CommonDataModule.NotifyUserByID(UserID,
      '<object name="lobby"><gacreateprivatetable result="' +
      ResultCode + '" reason="' + ResultReason + '"/></object>');
end;

end.
