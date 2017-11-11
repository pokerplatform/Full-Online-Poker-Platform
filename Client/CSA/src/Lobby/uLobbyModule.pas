unit uLobbyModule;

interface

uses
  SysUtils, Classes, ShellAPI, Windows, Forms,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uConstants,
  uProcessModule,
  uSessionModule,
  uDataList, ExtCtrls;

type
  TLobbyAction = (laNone,
    laExit,
    laLogin,
    laNewAccount,
    laCashier,
    laWaitingList,
    laHidePlayMoneyTables,
    lahidewelcomemessage,
    laHideNoLimitTables,
    laHideLimitTables,
    laAllInsRemaining,
    laRequestAllInsReset,
    laRecordedHands,
    laRequestHandHistory,
    laViewStatistics,
    laTrunsferFunds,
    laFindPlayer,
    laChangeProfile,
    laChangeAvatar,
    laChangeValidateEmail,
    laChangeMailingAddress,
    laChangePassword,
    laUse4ColorsDeck,
    laEnableAnimation,
    laEnableChatBubbles,
    laEnableSounds,
    laReverseStereoPanning,
    laHelp,
    laGameRules,
    laTip,
    laNews,
    laWhatsNew,
    laWhyChoose,
    laAbout,
    laleaderboardsforthisweek,
    laleaderboardsforthismonth,
    laleaderboardsforthisyear,
    laleaderboardsforpreviousweek,
    laleaderboardsforpreviousmonth,
    laleaderboardsforpreviousyear,
    laleaderpoints,
    lahidecompletetables,
    lahiderunningtables,
    lahidefulltables,
    laGetMoreChips,
    labikiniforum,
    lasendlogfile
    );


  TLobbyModule = class(TDataModule)
    SendProcessesTimer: TTimer;
    SendProcessInfoTimer: TTimer;
    UpdateTimer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure SendProcessesTimerTimer(Sender: TObject);
    procedure SendProcessInfoTimerTimer(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  private
    FWorking: Boolean;

    FStats: TDataList;
    FData: TDataList;

    FCurrentColumns: TDataList;
    FCurrentProcesses: TDataList;
    FCurrentProcessesInfo: TDataList;

    FCurrentCategoryID: Integer;
    FCurrentSubCategoryID: Integer;
    FCurrentProcessID: Integer;
    FCurrentSortAscending: Boolean;
    FCurrentSortStatsID: Integer;
    FCurrentProcessIDPosition: Integer;

    FPlayersCount: Integer;
    FProcessesCount: Integer;

    FPlayMoneyProcessCount: Integer;

    FOnStartWork: TSessionEvent;
    FOnStopWork: TSessionEvent;
    FOnUpdateSummary: TSessionEvent;
    FOnUpdateCategories: TSessionEvent;
    FOnUpdateProcesses: TSessionEvent;
    FOnUpdateProcessInfo: TSessionEvent;
    FOnCustomSupportSent: TSessionEvent;
    FOnCustomSupport: TSessionEvent;
    FOnCustomSupportFailed: TSessionEvent;
    FOnShowLobby: TSessionEvent;
    FOnMinimizeLobby: TSessionEvent;
    FBannerFileName: String;
    FOnUpdateOptions: TSessionEvent;
    FLobbyActivated: Boolean;
    FServerTime: String;
    FServerLongDateTime: string;
    FNoLimitProcessCount: Integer;
    FLimitProcessCount: Integer;
    FLPProcessCount: Integer;
    FShowProcessInfo: Boolean;
    FOldProcessCount: Integer;
    FLeaderBoardToTime: String;
    FLeaderBoardFromTime: String;
    FLeaderBoards: TDataList;
    FLeaderBoardRequestType: string;
    FCurrentProcessesCount: Integer;
    FisTournament: Boolean;
    FBalanceInfoUpdated: Boolean;

    procedure SetOnStartWork(const Value: TSessionEvent);
    procedure SetOnStopWork(const Value: TSessionEvent);
    procedure SetOnUpdateCategories(const Value: TSessionEvent);
    procedure SetOnUpdateProcesses(const Value: TSessionEvent);
    procedure SetOnUpdateProcessInfo(const Value: TSessionEvent);
    procedure SetOnUpdateSummary(const Value: TSessionEvent);
    procedure SetOnCustomSupport(const Value: TSessionEvent);
    procedure SetOnCustomSupportFailed(const Value: TSessionEvent);
    procedure SetOnCustomSupportSent(const Value: TSessionEvent);
    procedure SetOnMinimizeLobby(const Value: TSessionEvent);
    procedure SetOnShowLobby(const Value: TSessionEvent);
    procedure SetBannerFileName(const Value: String);
    procedure SetOnUpdateOptions(const Value: TSessionEvent);

    procedure Run_UpdateSummary(XMLRoot: IXMLNode);
    procedure Run_GetStats(XMLRoot: IXMLNode);
    procedure Run_GetCategories(XMLRoot: IXMLNode);
    procedure Run_GetProcesses(XMLRoot: IXMLNode);
    procedure Run_CreateProcess(XMLRoot: IXMLNode);
    procedure Run_UpdateProcess(XMLRoot: IXMLNode);
    procedure Run_DeleteProcess(XMLRoot: IXMLNode);
    procedure Run_GetProcessInfo(XMLRoot: IXMLNode);
    procedure Run_GetTournamentInfo(XMLRoot: IXMLNode);
    procedure Run_CustomSupport(XMLRoot: IXMLNode);
    procedure Run_GetLeaderBoard(XMLRoot: IXMLNode);
    procedure Run_GetLeaderPoints(XMLRoot: IXMLNode);

    procedure UpdateSummary;
    procedure UpdateCategories;
    procedure UpdateProcesses;
    procedure UpdateProcesses_Sort(IndexFrom, IndexTo: Integer);
    procedure UpdateProcesses_StakesSort(IndexFrom, IndexTo: Integer);
    procedure UpdateProcessInfo;
    procedure UpdateOptions;
    procedure SetLobbyActivated(const Value: Boolean);

    //procedure ProcessesSort;
    procedure SetOldProcessCount(const Value: Integer);
    procedure SetFShowProcessInfo(const Value: Boolean);

    function ChooseCurrentGameType(XMLSub: IXMLNode): Boolean;
    procedure SetisTournament(const Value: Boolean);
    procedure SetBalanceInfoUpdated(const Value: Boolean);
public
    // Lobby state
    property LobbyActivated: Boolean read FLobbyActivated write SetLobbyActivated;

    // Collections
    property Stats: TDataList read FStats;
    property Data: TDataList read FData;

    // Current Collections
    property CurrentColumns: TDataList read FCurrentColumns;
    property CurrentProcesses: TDataList read FCurrentProcesses;
    property CurrentProcessesInfo: TDataList read FCurrentProcessesInfo;
    property CurrentProcessesCounts: Integer read FCurrentProcessesCount;
    property LeaderBoards: TDataList read FLeaderBoards;

    // Current IDs
    property CurrentCategoryID: Integer read FCurrentCategoryID;
    property CurrentSubCategoryID: Integer read FCurrentSubCategoryiD;
    property CurrentProcessID: Integer read FCurrentProcessID;
    property CurrentSortAscending: Boolean read FCurrentSortAscending;
    property CurrentSortStatsID: Integer read FCurrentSortStatsID;
    property CurrentProcessIDPosition: Integer read FCurrentProcessIDPosition;
    property PlayMoneyProcessCount: Integer read FPlayMoneyProcessCount;
    property NoLimitProcessCount: Integer read FNoLimitProcessCount;
    property LimitProcessCount: Integer read FLimitProcessCount;
    property LPProcessCount: Integer read FLPProcessCount;

    property LeaderBoardFromTime: String read FLeaderBoardFromTime;
    property LeaderBoardToTime: String read FLeaderBoardToTime;
    property LeaderBoardRequestType: string read FLeaderBoardRequestType;

    property PlayersCount: Integer read FPlayersCount;
    property ProcessesCount: Integer read FProcessesCount;
    property ServerTime: String read FServerTime;
    property ServerLongDateTime: string read FServerLongDateTime;

    property OnStartWork: TSessionEvent read FOnStartWork write SetOnStartWork;
    property OnStopWork: TSessionEvent read FOnStopWork write SetOnStopWork;
    property OnShowLobby: TSessionEvent read FOnShowLobby write SetOnShowLobby;
    property OnMinimizeLobby: TSessionEvent read FOnMinimizeLobby write SetOnMinimizeLobby;

    property OnUpdateSummary: TSessionEvent read FOnUpdateSummary write SetOnUpdateSummary;
    property OnUpdateCategories: TSessionEvent read FOnUpdateCategories write SetOnUpdateCategories;
    property OnUpdateProcesses: TSessionEvent read FOnUpdateProcesses write SetOnUpdateProcesses;
    property OnUpdateProcessInfo: TSessionEvent read FOnUpdateProcessInfo write SetOnUpdateProcessInfo;
    property OnUpdateOptions: TSessionEvent read FOnUpdateOptions write SetOnUpdateOptions;

    property OnCustomSupport: TSessionEvent read FOnCustomSupport write SetOnCustomSupport;
    property OnCustomSupportSent: TSessionEvent read FOnCustomSupportSent write SetOnCustomSupportSent;
    property OnCustomSupportFailed: TSessionEvent read FOnCustomSupportFailed write SetOnCustomSupportFailed;

    property BannerFileName: String read FBannerFileName write SetBannerFileName;
    property ShowProcessInfo : Boolean read FShowProcessInfo write SetFShowProcessInfo;
    property isTournament : Boolean read FisTournament write SetisTournament;
    property OldProcessCount : Integer read FOldProcessCount write SetOldProcessCount;

    property BalanceInfoUpdated: Boolean read FBalanceInfoUpdated write SetBalanceInfoUpdated;

    procedure StartWork;
    procedure StopWork;
    procedure ShowLobby;
    procedure MinimizeLobby;
    procedure UpdateLoginState;

    procedure Do_ChooseCategory(NewCategoryID: Integer);
    procedure Do_ChooseSubCategory(NewSubcategoryID: Integer);
    procedure Do_SortProcesses(NewSortStatsID: Integer);
    procedure Do_ChooseProcess(NewProcessID, NewProcessIndex: Integer);
    procedure Do_JoinProcess(NewProcessID: Integer);
    procedure Do_Action(Action: TLobbyAction);

    procedure Do_SendLogFile;

    procedure Do_CustomSupport;
    procedure Do_SendCustomSupportMessage(msgSubject, msgBody: String);

    procedure RunCommand(XMLRoot: IXMLNode);

    procedure WB_Set3DBorderStyle(Sender: TObject; bValue: Boolean);
    procedure WB_SetBorderStyle(Sender: TObject; BorderStyle: String);
    procedure WB_SetBorderColor(Sender: TObject; BorderColor: String);
  end;

var
  LobbyModule: TLobbyModule;

implementation

uses
  uLogger,
  uParserModule,
  uCashierModule,
  uUserModule,
  uThemeEngineModule,
  uTournamentModule, StrUtils, MSHTML, SHDocVw, uTournamentLeaderBoardForm ,
  uWelcomeMessageForm, uAboutForm, DateUtils, uHTTPPostThread,
  uSessionUtils;

{$R *.dfm}

{ TLobbyModule }

procedure TLobbyModule.DataModuleCreate(Sender: TObject);
begin
  FLobbyActivated := False;

  FStats := TDataList.Create(0, nil);
  FData := TDataList.Create(0, nil);

  FLeaderBoards := TDataList.Create(0,nil);

  FStats.Clear;
  FData.Clear;
  FLeaderBoards.Clear;

  FWorking := false;

  FBannerFileName := '';

  FCurrentCategoryID := 0;
  FCurrentSubCategoryID := 0;
  FCurrentProcessID := 0;
  FCurrentSortAscending := false;
  FCurrentSortStatsID := StatID_Stakes;
  FCurrentProcessIDPosition := 0;

  FPlayersCount := 0;
  FProcessesCount := 0;
  FServerTime := '';
  FServerLongDateTime := '';

  FPlayMoneyProcessCount := 0;

  FCurrentColumns := nil;
  FCurrentProcesses := nil;
  FCurrentProcessesInfo := nil;

  FOnUpdateSummary := nil;
  FOnUpdateCategories := nil;
  FOnUpdateProcessInfo := nil;
  FOnUpdateProcesses := nil;
  FOnStartWork := nil;
  FOnStopWork := nil;

  SendProcessesTimer.Interval := UpdateInfoTimeSec;
  SendProcessInfoTimer.Interval := UpdateInfoTimeSec;
  UpdateTimer.Interval := UpdateInfoTimeSec * 10000;
end;

procedure TLobbyModule.DataModuleDestroy(Sender: TObject);
begin
  UpdateTimer.Enabled := false;
  SendProcessesTimer.Enabled := false;
  SendProcessInfoTimer.Enabled := false;
  FStats.Free;
  FData.Free;
  FLeaderBoards.Free
end;


// Get/Set procedures

procedure TLobbyModule.SetOnUpdateOptions(const Value: TSessionEvent);
begin
  FOnUpdateOptions := Value;
end;

procedure TLobbyModule.SetOldProcessCount(const Value: Integer);
begin
  FOldProcessCount := Value;
end;

procedure TLobbyModule.SetBannerFileName(const Value: String);
begin
  FBannerFileName := Value;
end;

procedure TLobbyModule.SetOnStartWork(const Value: TSessionEvent);
begin
  FOnStartWork := Value;
end;

procedure TLobbyModule.SetOnStopWork(const Value: TSessionEvent);
begin
  FOnStopWork := Value;
end;

procedure TLobbyModule.SetOnMinimizeLobby(const Value: TSessionEvent);
begin
  FOnMinimizeLobby := Value;
end;

procedure TLobbyModule.SetOnShowLobby(const Value: TSessionEvent);
begin
  FOnShowLobby := Value;
end;

procedure TLobbyModule.SetOnUpdateCategories(const Value: TSessionEvent);
begin
  FOnUpdateCategories := Value;
end;

procedure TLobbyModule.SetOnUpdateProcesses(const Value: TSessionEvent);
begin
  FOnUpdateProcesses := Value;
end;

procedure TLobbyModule.SetOnUpdateProcessInfo(const Value: TSessionEvent);
begin
  FOnUpdateProcessInfo := Value;
end;

procedure TLobbyModule.SetOnUpdateSummary(const Value: TSessionEvent);
begin
  FOnUpdateSummary := Value;
end;

procedure TLobbyModule.SetOnCustomSupport(const Value: TSessionEvent);
begin
  FOnCustomSupport := Value;
end;

procedure TLobbyModule.SetOnCustomSupportFailed(
  const Value: TSessionEvent);
begin
  FOnCustomSupportFailed := Value;
end;

procedure TLobbyModule.SetOnCustomSupportSent(const Value: TSessionEvent);
begin
  FOnCustomSupportSent := Value;
end;

// Run external commands

procedure TLobbyModule.RunCommand(XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Add('LobbyModule.RunCommand started', llExtended);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := lowercase(XMLNode.NodeName);
        Logger.Add('LobbyModule.RunCommand found ' + strNode, llExtended);

        if strNode = 'apgetprocessinfo' then
          Run_GetProcessInfo(XMLNode)
        else
        if strNode = 'togettournamentinfo' then
          Run_GetTournamentInfo(XMLNode)
        else   
        if strNode = 'togetleaderboard' then
          Run_GetLeaderBoard(XMLNode)
        else
        if strNode = 'togetleaderpoints' then
            Run_GetLeaderPoints(XMLNode)
        else     
        if strNode = 'apupdateprocess' then
          Run_UpdateProcess(XMLNode)
        else
        if strNode = 'apcreateprocess' then
          Run_CreateProcess(XMLNode)
        else
        if strNode = 'apdeleteprocess' then
          Run_DeleteProcess(XMLNode)
        else
        if (strNode = 'apgetprocesses') or (strNode = 'togettournaments') then
          Run_GetProcesses(XMLNode)
        else
        if strNode = 'apgetcategories' then
          Run_GetCategories(XMLNode)
        else
        if strNode = 'apgetstats' then
          Run_GetStats(XMLNode)
        else
        if strNode = 'apupdatesummary' then
          Run_UpdateSummary(XMLNode)
        else
        if strNode = 'apcustomsupport' then
          Run_CustomSupport(XMLNode);

      end;
  except
    Logger.Add('LobbyModule.RunCommand failed', llBase);
  end;
end;

procedure TLobbyModule.Run_UpdateSummary(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apupdatesummary players="2134" processes="576"/>
</object>
}
begin
  FPlayersCount := XMLRoot.Attributes['players'];
  FProcessesCount := XMLRoot.Attributes['processes'];
  FServerTime := (XMLRoot.Attributes['servertime']);
  FServerLongDateTime := (XMLRoot.Attributes['serverlongdatetime']);

  UpdateSummary;
end;


procedure TLobbyModule.Run_GetStats(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apgetstats result="0|...">
    <stats id="1" name="Player Count" propertyid="1"/>
    <stats id="2" name="Watchers"     propertyid="1"/>
    <stats id="3" name="Bet"          propertyid="3"/>
    <stats id="4" name="Game Status"  propertyid="7"/>
  </apgetstats>
</object>
}
var
  ErrorCode: Integer;
  ItemsCount: Integer;

  Loop    : Integer;
  XMLNode : IXMLNode;
  newItem : TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    ItemsCount := XMLRoot.ChildNodes.Count;
    FStats.ClearItems(ItemsCount);

    for Loop := 0 to ItemsCount - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      newItem := FStats.AddItem(XMLNode.Attributes[XMLATTRNAME_ID], Loop);
      newItem.Name := XMLNode.Attributes[XMLATTRNAME_NAME];
      newItem.Value := XMLNode.Attributes['propertyid'];
    end;
    if (SessionModule.SessionState = poConnecting) or (SessionModule.SessionState = poReconnecting) then
      SessionModule.Do_Synchronized;
  end;
end;

procedure TLobbyModule.Run_GetCategories(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apgetcategories result="0|...">
    <category id="1" name="Poker"/>
      <subcategory id="1" name="Texas Hold'em"/>
      <subcategory id="2" name="Omaha Hi"/>
      <subcategory id="3" name="Omaha Hi/Lo"/>
      <subcategory id="4" name="7 Card Stud Hi"/>
    <category/>
    <category id="2" name="Tetris"/>
    <category id="3" name="Chess"/>
    <category id="4" name="Solitaire"/>
  </apgetcategories>
</object>
}
var
  ErrorCode: Integer;

  Loop    : Integer;
  CatCount: Integer;
  XMLNode : IXMLNode;

  Loop2   : Integer;
  SubCount: Integer;
  XMLSub  : IXMLNode;

  curCategory: TDataList;
  curSubcategory: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    CatCount := XMLRoot.ChildNodes.Count;
    FData.Clear;
    FData.ClearItems(CatCount);
    FCurrentColumns := nil;
    FCurrentProcesses := nil;
    FCurrentProcessesInfo := nil;

    for Loop := 0 to CatCount - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      curCategory := FData.AddItem(XMLNode.Attributes[XMLATTRNAME_ID], Loop);
      curCategory.Name := XMLNode.Attributes[XMLATTRNAME_Name];
      SubCount := XMLNode.ChildNodes.Count;
      curCategory.ClearItems(SubCount + 2);

      for Loop2 := 0 to SubCount - 1 do
      begin
        XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
        curSubcategory := curCategory.AddItem(XMLSub.Attributes[XMLATTRNAME_ID], Loop2);
        curSubcategory.Name := XMLSub.Attributes[XMLATTRNAME_Name];
        curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] := 0;
        curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] := 0;
        curSubCategory.Add(SubCategoryColumnsItemID);
        curSubCategory.Add(SubCategoryProcessesItemID);
        curSubCategory.Add(SubCategoryProcessesInfoItemID);
      end;

      curSubcategory := curCategory.AddItem(SitAndGoSubCategoryID, SubCount);
      curSubcategory.Name := SitAndGoSubCategoryName;
      curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] := 0;
      curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] := 0;
      curSubCategory.Add(SubCategoryColumnsItemID);
      curSubCategory.Add(SubCategoryProcessesItemID);
      curSubCategory.Add(SubCategoryProcessesInfoItemID);{}

      curSubcategory := curCategory.AddItem(TournamentSubCategoryID, SubCount+1);
      curSubcategory.Name := TournamentSubCategoryName;
      curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] := 0;
      curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] := 0;
      curSubCategory.Add(SubCategoryColumnsItemID);
      curSubCategory.Add(SubCategoryProcessesItemID);
      curSubCategory.Add(SubCategoryProcessesInfoItemID);{}

    end;

    if (SessionModule.SessionState = poConnecting) or (SessionModule.SessionState = poReconnecting) then
      SessionModule.Do_Synchronized;

    UpdateCategories;
  end;
end;

procedure TLobbyModule.Run_GetProcesses(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apgetprocesses  subcategoryid="1" result="0|...">
    <columns>
      <stats id="1" order="1"/>
      <stats id="2" order="4"/>
      <stats id="3" order="2"/>
      <stats id="4" order="3"/>
    </columns>
    <processes>
      <process id="1" name="Money table #123" currencyid="1" groupid="1">
        <stats id="1" value="12"/>
        <stats id="2" value="2.57"/>
        <stats id="4" value="456"/>
        <stats id="7" value="Waiting..."/>
      </process>
      <process id="1" name="Tournament" currencyid="2" groupid="1">
        <stats id="1" value="12"/>
        <stats id="5" value="Tetris"/>
        <stats id="8" value="456"/>
        <stats id="9" value="Waiting..."/>
      </process>
    </processes>
  </apgetprocesses>
</object>


**** OR

<object name="lobby">
  <togettournaments kind="0" result="0|..." activetournamentscount="7" activaplayerscount="100">
    <columns>
      <stats id="1" order="1"/>
      <stats id="2" order="4"/>
      <stats id="3" order="2"/>
      <stats id="4" order="3"/>
    </columns>
    <processes>
      <process id="1" name="Tournament #1" currencyid="2" groupid="1" types=",1,2,4,6,">
        <stats id="1" value="12"/>
        <stats id="5" value="Holdem"/>
        <stats id="8" value="456"/>
        <stats id="9" value="Announced"/>
      </process>
    </processes>
  </apgetprocesses>
</object>

}
var
  ErrorCode: Integer;

  Loop    : Integer;
  XMLNode : IXMLNode;
  strNode : String;
  Loop2   : Integer;
  XMLSub  : IXMLNode;
  Loop3   : Integer;
  XMLStat : IXMLNode;
  strTemp : String;

  curCategory: TDataList;
  curSubCategory: TDataList;
  curSubCategoryID: Integer;

  curColumns: TDataList;
  curColumn: TDataList;
  curStats: TDataList;
  curColumnID: Integer;

  curProcesses: TDataList;
  curProcess: TDataList;
  curProcessID: Integer;
  nPlayers: Integer;

  nPlayerCount: Integer;
  nProcessCount: Integer;

  ProcessesCount: Integer;
  kind: byte;
  TournamentStatusID: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    if XMLRoot.HasAttribute(XMLATTRNAME_SUBCATEGORYID) then
      curSubCategoryID := XMLRoot.Attributes[XMLATTRNAME_SUBCATEGORYID]
    else
    begin
      if XMLRoot.HasAttribute(XMLATTRNAME_KIND) then
      begin
        kind := XMLRoot.Attributes[XMLATTRNAME_KIND];
       if kind = 2 then
        curSubCategoryID := SitAndGoSubCategoryID
       else
        curSubCategoryID := TournamentSubCategoryID;
      end;
    end;

    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(curSubCategoryID, curSubCategory) then
      begin
        nPlayerCount := 0;
        nProcessCount := 0;
        FCurrentColumns := nil;
        FCurrentProcesses := nil;

        for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
        begin
          XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
          strNode := lowercase(XMLNode.NodeName);

          if strNode = XMLNODENAME_COLUMNS then
          begin
            curColumns := curSubCategory.Add(SubCategoryColumnsItemID);
            curColumns.ClearData(0);
            curColumns.ClearItems(XMLNode.ChildNodes.Count);

            for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            begin
              XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
              curColumnID := XMLSub.Attributes[XMLATTRNAME_ID];
              if FStats.Find(curColumnID, curStats) then
              begin
                curColumn := curColumns.AddItem(curColumnID, Loop2);
                curColumn.Name  := curStats.Name;
                curColumn.Value := curStats.Value;
                curColumn.ValuesAsInteger['order'] := XMLSub.Attributes['order'];
              end
              else
              begin
                curColumn := curColumns.AddItem(curColumnID, Loop2);
                curColumn.Name  := inttostr(curColumnID);
                curColumn.Value := 4;
                curColumn.ValuesAsInteger['order'] := XMLSub.Attributes['order'];
              end;
            end;
            curColumns.SortItems('order', true, true);
          end;

          if strNode = XMLNODENAME_PROCESSES then
          begin
            curProcesses := curSubCategory.Add(SubCategoryProcessesItemID);
             ProcessesCount := 0;
            for loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            begin
             XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
             if ChooseCurrentGameType(XMLSub) then
               inc(ProcessesCount);
            end;
            curProcesses.ClearItems(ProcessesCount);
              ProcessesCount := 0;
            for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            begin
              XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
             if ChooseCurrentGameType(XMLSub) then
             begin
              curProcessID := XMLSub.Attributes[XMLATTRNAME_ID];
              curProcess := curProcesses.AddItem(curProcessID, ProcessesCount);
              inc(ProcessesCount);
              curProcess.ClearData(XMLSub.ChildNodes.Count + 8);
              curProcess.ClearItems(0);
              curProcess.Name := XMLSub.Attributes[XMLATTRNAME_NAME];
              if curProcess.Name = '' then
                if (curSubCategoryID = TournamentSubCategoryID) or (curSubCategoryID = SitAndGoSubCategoryID) then
                  curProcess.Name := 'Tournament #' + inttostr(curProcessID)
                else
                  curProcess.Name := 'Table #' + inttostr(curProcessID);
              curProcess.Value := XMLSub.Attributes['groupid'];

              strTemp := ' ';
              for Loop3 := 0 to XMLSub.ChildNodes.Count - 1 do
              begin
                XMLStat := XMLSub.ChildNodes.Nodes[Loop3];
                curProcess.ValueNames[Loop3] := XMLStat.Attributes[XMLATTRNAME_ID];
                curProcess.Values[Loop3] :=XMLStat.Attributes['value'];

                if curProcess.ValueNames[Loop3] = inttostr(StatID_Stakes) then
                if pos('/', curProcess.Values[Loop3]) < 1 then
                  strTemp := copy(curProcess.Values[Loop3], 1, 3);
              end;

              curProcess.ValueNames[curProcess.ValueCount - 1] := 'currencyid';
              curProcess.Values[curProcess.ValueCount - 1] := XMLSub.Attributes['currencyid'];
              curProcess.ValueNames[curProcess.ValueCount - 2] := inttostr(StatID_TableName);
              curProcess.Values[curProcess.ValueCount - 2] := curProcess.Name;
              curProcess.ValueNames[curProcess.ValueCount - 3] := DATANAME_STAKESORT;
              curProcess.Values[curProcess.ValueCount - 3] := strTemp;

              curProcess.ValueNames[curProcess.ValueCount - 4] := XMLNODENAME_ACTIONDISPATCHERID;
              if XMLSub.HasAttribute(XMLNODENAME_ACTIONDISPATCHERID) then
                curProcess.Values[curProcess.ValueCount - 4] :=
                  XMLSub.Attributes[XMLNODENAME_ACTIONDISPATCHERID]
              else
                curProcess.Values[curProcess.ValueCount - 4] := 0;

              curProcess.ValueNames[curProcess.ValueCount - 5] := inttostr(StatID_GameType);
              strTemp := '';
              if XMLSub.HasAttribute(XMLNODENAME_GAMETYPEID) then
              case strtointdef(XMLSub.Attributes[XMLNODENAME_GAMETYPEID], 0) of
                1: strTemp := 'Hold''em';
                2: strTemp := 'Omaha';
                3: strTemp := 'Omaha Hi/Lo';
                4: strTemp := '7 Stud';
                5: strTemp := '7 Stud Hi/Lo';
              end;
              curProcess.Values[curProcess.ValueCount - 5] := strTemp;

              curProcess.ValueNames[curProcess.ValueCount - 6] := inttostr(StatID_Chairs);
              if XMLSub.HasAttribute(XMLNODENAME_CHAIRSCOUNT) then
                curProcess.Values[curProcess.ValueCount - 6] :=
                  XMLSub.Attributes[XMLNODENAME_CHAIRSCOUNT]
              else
                curProcess.Values[curProcess.ValueCount - 6] := 0;

              curProcess.ValueNames[curProcess.ValueCount - 7] := inttostr(StatID_TournamentID);
              curProcess.Values[curProcess.ValueCount - 7] := curProcess.ID;

              TournamentStatusID := 0;
              strTemp := curProcess.ValuesAsString[IntToStr(StatID_TournamentState)];
              if strTemp <> '' then
              begin
                if strTemp = 'Registering' then
                 TournamentStatusID := 1
                else
                if strTemp = 'Running' then
                 TournamentStatusID := 2
                else
                if strTemp = 'Announced' then
                 TournamentStatusID := 3
                else
                if strTemp = 'Completed' then
                 TournamentStatusID := 4
                else
                if strTemp = 'Closed' then
                 TournamentStatusID := 5
                else
                if strTemp = 'Break started' then
                 TournamentStatusID := 6
                else
                if strTemp = 'Pause by admin' then
                 TournamentStatusID := 7
                else
                if strTemp = 'Stopped' then
                 TournamentStatusID := 8;
              end;

              curProcess.ValueNames[curProcess.ValueCount - 8] := XMLNODENAME_TOURNAMENTSTATEID;
              curProcess.Values[curProcess.ValueCount - 8] := TournamentStatusID;

              nPlayers := curProcess.ValuesAsInteger[inttostr(StatID_PlayersCount)];
              strTemp := curProcess.ValuesAsString[inttostr(StatID_TournamentPlayers)];
             if strTemp <> '' then
             begin
              StrTemp := copy(strTemp,1,pos('of',strTemp)-2);
              if strTemp <> '' then
                nPlayers := nPlayers + curProcess.ValuesAsInteger[inttostr(StatID_PlayersCount)] +
                StrToInt(strTemp)
              else
                nPlayers := nPlayers + curProcess.ValuesAsInteger[inttostr(StatID_PlayersCount)] +
                StrToInt(curProcess.ValuesAsString[inttostr(StatID_TournamentPlayers)]);
             end;

              if nPlayers > 0 then
              begin
                nPlayerCount := nPlayerCount + nPlayers;
                nProcessCount := nProcessCount + 1;
              end;
             end
            end;


            if XMLRoot.HasAttribute('activaplayerscount') then
              nPlayerCount := XMLRoot.Attributes['activaplayerscount'];
            if XMLRoot.HasAttribute('activetournamentscount') then
              nProcessCount := XMLRoot.Attributes['activetournamentscount'];
            curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] := nPlayerCount;
            curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] := nProcessCount;

         end;
        end;

      if curSubCategory.ID = FCurrentSubCategoryID then
        UpdateProcesses;

      if (SessionModule.SessionState = poConnecting) or (SessionModule.SessionState = poReconnecting) then
        SessionModule.Do_Synchronized;
    end;
  end;
end;

procedure TLobbyModule.Run_CreateProcess(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apcreateprocess processid="1" subcategoryid="1" name="Money table #123"
    currencyid="1"  groupid="1" result="0|...">
    <stats id="1" value="17"/>
    <stats id="5" value="Tetris"/>
    <stats id="8" value="458"/>
    <stats id="9" value="Playing..."/>
  </apcreateprocess>
</object>
}
var
  ErrorCode: Integer;
  XMLStat : IXMLNode;
  curCategory: TDataList;
  curSubCategory: TDataList;
  curProcesses: TDataList;
  curProcess: TDataList;
  curProcessID: Integer;
  Loop: Integer;
  nPlayers: Integer;
  strTemp: String;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(XMLRoot.Attributes[XMLATTRNAME_SUBCATEGORYID], curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesItemID, curProcesses) then
        begin
         //ChooseCurrentGameType()
          curProcessID := XMLRoot.Attributes[XMLATTRNAME_PROCESSID];
          curProcess := curProcesses.Add(curProcessID);
          curProcess.ClearData(XMLRoot.ChildNodes.Count + 2);
          curProcess.ClearItems(0);
          curProcess.Name := XMLRoot.Attributes[XMLATTRNAME_NAME];
          if curProcess.Name = '' then
            if curSubCategory.ID = TournamentSubCategoryID then
              curProcess.Name := 'Tournament #' + inttostr(curProcessID)
            else
              curProcess.Name := 'Table #' + inttostr(curProcessID);
          curProcess.Value := XMLRoot.Attributes['groupid'];

          strTemp := ' ';
          for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
          begin
            XMLStat := XMLRoot.ChildNodes.Nodes[Loop];
            curProcess.ValueNames[Loop] := XMLStat.Attributes[XMLATTRNAME_ID];
            curProcess.Values[Loop] :=XMLStat.Attributes['value'];

            if curProcess.ValueNames[Loop] = inttostr(StatID_Stakes) then
            if pos('/', curProcess.Values[Loop]) < 1 then
              strTemp := copy(curProcess.Values[Loop], 1, 3);
          end;

          curProcess.ValueNames[curProcess.ValueCount - 3] := DATANAME_STAKESORT;
          curProcess.Values[curProcess.ValueCount - 3] := strTemp;
          curProcess.ValueNames[curProcess.ValueCount - 2] := inttostr(StatID_TableName);
          curProcess.Values[curProcess.ValueCount - 2] := curProcess.Name;
          curProcess.ValueNames[curProcess.ValueCount - 1] := 'currencyid';
          curProcess.Values[curProcess.ValueCount - 1] := XMLRoot.Attributes['currencyid'];

          {nPlayers := curProcess.ValuesAsInteger[inttostr(StatID_PlayersCount)] +
            curProcess.ValuesAsInteger[inttostr(StatID_TournamentPlayers)];{}
            nPlayers := 0;
          if nPlayers > 0 then
          begin
            curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] :=
              curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] + nPlayers;
            curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] :=
              curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] + 1;
          end;

          if curSubCategory.ID = FCurrentSubCategoryID then
            UpdateProcesses;
        end;
end;

procedure TLobbyModule.Run_DeleteProcess(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apdeleteprocess processid="5" result="0|..."/>
<object/>
}
var
  ErrorCode: Integer;
  curProcess: TDataList;
  curProcesses: TDataList;
  curSubCategory: TDataList;
  curCategory: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesItemID, curProcesses) then
          if curProcesses.Find(XMLRoot.Attributes[XMLATTRNAME_PROCESSID], curProcess) then
          begin
            curProcesses.Remove(curProcess.ID);
            if curSubCategory.ID = FCurrentSubCategoryID then
              UpdateProcesses;
          end;
end;

procedure TLobbyModule.Run_UpdateProcess(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apupdateprocess processid="1" result="0|...">
    <stats id="1" value="17"/>
    <stats id="5" value="Tetris"/>
    <stats id="8" value="458"/>
    <stats id="9" value="Playing..."/>
  </apupdateprocess>
</object>
}
var
  ErrorCode: Integer;
  curProcess: TDataList;
  curProcesses: TDataList;
  curSubCategory: TDataList;
  curCategory: TDataList;
  Loop   : Integer;
  XMLStat : IXMLNode;
  nPlayers: Integer;
  strTemp: String;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesItemID, curProcesses) then
          if curProcesses.Find(XMLRoot.Attributes[XMLATTRNAME_PROCESSID], curProcess) then
          begin
            nPlayers := curProcess.ValuesAsInteger[inttostr(StatID_PlayersCount)] +
              curProcess.ValuesAsInteger[inttostr(StatID_TournamentPlayers)];
            if nPlayers > 0 then
            begin
              curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] :=
                curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] - nPlayers;
              curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] :=
                curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] - 1;
            end;

            for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
            begin
              XMLStat := XMLRoot.ChildNodes.Nodes[Loop];
              curProcess.ValuesAsString[XMLStat.Attributes[XMLATTRNAME_ID]] :=
                XMLStat.Attributes['value'];
            end;

            strTemp := curProcess.ValuesAsString[inttostr(StatID_Stakes)];
            if pos('/', strTemp) < 1 then
              curProcess.ValuesAsString[DATANAME_STAKESORT] := copy(strTemp, 1, 3)
            else
              curProcess.ValuesAsString[DATANAME_STAKESORT] := '';

            nPlayers := curProcess.ValuesAsInteger[inttostr(StatID_PlayersCount)] +
              curProcess.ValuesAsInteger[inttostr(StatID_TournamentPlayers)];
            if nPlayers > 0 then
            begin
              curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] :=
                curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] + nPlayers;
              curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] :=
                curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] + 1;
            end;

            if curSubCategory.ID = FCurrentSubCategoryID then
              UpdateProcesses;

          end;
end;

procedure TLobbyModule.Run_GetProcessInfo(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apgetprocessinfo processid="37" result="0">
    <group name="Players:" value="4">
      <data name="Player 1" city="Sim-City" value="$1000"/>
      <data name="Player 2" city="Sim-Town" value="$2000"/>
      <data name="Player 3" city="Sim-Village" value="$3000"/>
    </group>
    <group name="Waiting list:" value="1/2"/>
    <group name="Watchers:" value="3"/>
  </apgetprocessinfo>
</object>
}
var
  ErrorCode: Integer;

  Loop: Integer;
  XMLNode: IXMLNode;
  Loop2: Integer;
  XMLSub: IXMLNode;

  curCategory: TDataList;
  curSubCategory: TDataList;
  curProcessesInfo: TDataList;
  curProcessInfo: TDataList;
  curData: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesInfoItemID, curProcessesInfo) then
        begin
          curProcessInfo := curProcessesInfo.Add(XMLRoot.Attributes[XMLATTRNAME_PROCESSID]);
          curProcessInfo.Clear;

          for Loop := 0 to XMLRoot.ChildNodes.Count -1 do
          begin
            XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
            curData := curProcessInfo.Add((Loop + 1) * 100);
            curData.Name := XMLNode.Attributes[XMLATTRNAME_NAME];
            curData.ValuesAsString['value'] := XMLNode.Attributes['value'];
            curData.ValuesAsBoolean['isgroup'] := true;

            for Loop2 := 0 to XMLNode.ChildNodes.Count -1 do
            begin
              XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
              curData := curProcessInfo.Add((Loop + 1 ) * 100 + Loop2 + 1);
              curData.Name := XMLSub.Attributes[XMLATTRNAME_NAME];
              curData.ValuesAsString['city'] := XMLSub.Attributes['city'];
              curData.ValuesAsString['value'] := XMLSub.Attributes['value'];
              curData.ValuesAsBoolean['isgroup'] := false;
            end;
          end;

          if FCurrentProcessID = curProcessInfo.ID then
            UpdateProcessInfo;
        end;
end;

procedure TLobbyModule.Run_GetTournamentInfo(XMLRoot: IXMLNode);
{
<object name="lobby">
  <togettournamentinfo id="1" kind="0" result="0">
    <data value="Poker World-Wide Super-Puper Tournament"/>
    <data value="Pot limit Hol'em. Buy-In: $30+$3"/>
    <data value="Tournament in progress."/>
    <data value="Registration closed."/>
  </togettournamentinfo>
</object>
}
var
  ErrorCode: Integer;

  Loop: Integer;
  XMLNode: IXMLNode;

  curCategory: TDataList;
  curSubCategory: TDataList;
  curProcessesInfo: TDataList;
  curProcessInfo: TDataList;
  curData: TDataList;
  kind: byte;
  CurSubCategoryID: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    if Data.Find(FCurrentCategoryID, curCategory) then
    begin
     if XMLRoot.HasAttribute('kind') then
     begin
      kind := XMLRoot.Attributes['kind'];
      if kind = 2 then
       CurSubCategoryID := SitAndGoSubCategoryID
      else
       CurSubCategoryID := TournamentSubCategoryID;
     end
     else
       CurSubCategoryID := TournamentSubCategoryID;

      if curCategory.Find(CurSubCategoryID, curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesInfoItemID, curProcessesInfo) then
        begin
          curProcessInfo := curProcessesInfo.Add(XMLRoot.Attributes['tournamentid']);
          curProcessInfo.Clear;

          for Loop := 0 to XMLRoot.ChildNodes.Count -1 do
          begin
            XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
            curData := curProcessInfo.Add(Loop + 1);
            curData.Name := XMLNode.Attributes['value'];
            if XMLNode.HasAttribute('mastertournamentid') then
            begin
            // curData.Name := '';
             curProcessInfo.ValuesAsString['mastertournamentid'] := XMLNode.Attributes['mastertournamentid'];
             curData.ValuesAsBoolean['issatellited'] := true;
            end
            else
            curData.ValuesAsBoolean['issatellited'] := false;
            curData.ValuesAsBoolean['isgroup'] := true;
          end;

          if FCurrentProcessID = curProcessInfo.ID then
            UpdateProcessInfo;
        end;
   end;
end;


procedure TLobbyModule.Run_GetLeaderBoard(XMLRoot: IXMLNode);
{
<object name="lobby">
  <togetleaderboard fromtime="12/23/05" totime="34/23/05">
    <player loginame="Ivan" points="120.67">
    ..
  </togettournamentinfo>
</object>
}
var Loop: Integer;
    XMLNode: IXMLNode;
    CurrentLeaderBoard: TDataList;
begin
      FLeaderBoardFromTime := XMLRoot.Attributes['fromtime'];
      FLeaderBoardToTime := XMLRoot.Attributes['totime'];
      FLeaderBoardRequestType := XMLRoot.Attributes['requesttype'];
      FLeaderBoards.Clear;
      FLeaderBoards.ClearItems(XMLRoot.ChildNodes.Count);

      for Loop := 0 to XMLRoot.ChildNodes.Count -1 do
      begin
        CurrentLeaderBoard := FLeaderBoards.AddItem(Loop,Loop);
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        CurrentLeaderBoard.ValuesAsString['loginname'] := XMLNode.Attributes['loginname'];
        CurrentLeaderBoard.ValuesAsCurrency['points'] := XMLNode.Attributes['points'];{}
      end;

  TournamentLeaderBoardForm.ShowForm;
end;

procedure TLobbyModule.Run_GetLeaderPoints(XMLRoot: IXMLNode);
{
<object name="lobby">
  <togetleaderpoints>
    '<data message="Tournament Leader Points has been sent to: hotmail.com"/>'+
    ..
  </togetleaderpoints>
</object>
}
var XMLNode: IXMLNode;
begin
     XMLNode := XMLRoot.ChildNodes.Nodes[0];
      ThemeEngineModule.ShowMessage(XMLNode.Attributes['message']);
end;


// Start and stop of showing visual window

procedure TLobbyModule.StartWork;
begin
  if FWorking then
    ShowLobby
  else
  begin
   if SessionModule.SessionSettings.ValuesAsString[RegistryMultiInstancesKey] <> RegistryMultiInstancesValue then
     UserModule.AutoLogin;
   UserModule.LastPlayerGetsMoreChipsTime := IncMinute(Now,-21);
     FWorking := true;
     if Assigned(FOnStartWork) then
       FOnStartWork;
  end;
end;

procedure TLobbyModule.StopWork;
begin
  if FWorking and Assigned(FOnStopWork) then
    FOnStopWork;
  FWorking := false;
end;

procedure TLobbyModule.ShowLobby;
begin
  if FWorking and Assigned(FOnShowLobby) then
    FOnShowLobby;
end;

procedure TLobbyModule.MinimizeLobby;
begin
  if FWorking and Assigned(FOnMinimizeLobby) then
    FOnMinimizeLobby;
end;


// Update procedures

procedure TLobbyModule.UpdateSummary;
begin
  if FWorking and Assigned(FOnUpdateSummary) then
    FOnUpdateSummary;
end;

procedure TLobbyModule.UpdateCategories;
var
  curCategory: TDataList;
  BadSubCategoryID: Boolean;
  curSubCategory: TDataList;
  Changed: Boolean;
begin
  Changed := false;
  
  if FCurrentCategoryID <= 0 then
  begin
    FCurrentCategoryID := 0;
    FCurrentSubCategoryID := 0;
    FCurrentProcessID := 0;

    if Data.Count > 0 then
      FCurrentCategoryID := Data.Items(0).ID;
  end;

  BadSubCategoryID := true;
  if Data.Find(FCurrentCategoryID, curCategory) then
    if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
      BadSubCategoryID := false;


  if BadSubCategoryID then
  begin
    FCurrentSubCategoryID := 0;
    FCurrentProcessID := 0;
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Count > 0 then
      begin
        FCurrentSubCategoryID := curCategory.Items(4).ID;
        FisTournament := true;  // if default subcategory is tournament
        Changed := true;
      end;
  end;

  if FWorking and Assigned(FOnUpdateCategories) then
    FOnUpdateCategories;

  if Changed or (SessionModule.SessionState = poConnecting) or
    (SessionModule.SessionState = poReConnecting) then
    Do_ChooseSubCategory(FCurrentSubCategoryID);

  UpdateSummary;
end;

function TLobbyModule.ChooseCurrentGameType(XMLSub: IXMLNode): Boolean;
var
  ShowPlayMoneyTables, ShowNoLimitTables,ShowLimitTables, ShowLPTables: Boolean;
  HideFullTables: Boolean;
  limit: string;
  currencyID: Integer;
  Loop: Integer;
  XMLStat: IXMLNode;
  State: String;
  HideCompletedTournaments, HideRunningTournamens: Boolean;
  flag: Boolean;
  Chairs, Players: Integer;
begin
 if not isTournament then
 begin
  Result := false;
  ShowPlayMoneyTables := SessionModule.SessionSettings.ValuesAsBoolean[SessionShowPlayMoneyTables];
  ShowNoLimitTables := SessionModule.SessionSettings.ValuesAsBoolean[SessionShowNoLimitTables];
  ShowLimitTables := SessionModule.SessionSettings.ValuesAsBoolean[SessionShowLimitTables];
  ShowLPTables := SessionModule.SessionSettings.ValuesAsBoolean[SessionShowLPTables];
  HideFullTables := SessionModule.SessionSettings.ValuesAsBoolean[SessionHideFullTables];

  for Loop := 0 to XMLSub.ChildNodes.Count - 1 do
  begin
    XMLStat := XMLSub.ChildNodes.Nodes[Loop];
    if XMLStat.Attributes[XMLATTRNAME_ID] = StatID_Limit then
     limit := XMLStat.Attributes['value'];

    if XMLStat.Attributes[XMLATTRNAME_ID] = StatID_Chairs then
     chairs := XMLStat.Attributes['value'];

    if XMLStat.Attributes[XMLATTRNAME_ID] = StatID_PlayersCount then
     Players := XMLStat.Attributes['value'];
  end;

  if XMLSub.HasAttribute('currencyid') then
    currencyID := XMLSub.Attributes['currencyid']
  else
   exit;

  if ShowPlayMoneyTables then
  begin
   if  (currencyID <> 2) and (currencyID <> 4) then
     Result := true;
  end
  else
  if ShowNoLimitTables then
  begin
    if (currencyID = 2) and (limit = 'Fixed') then
      Result := true;
  end
  else
  if ShowLimitTables then
  begin
    if  (currencyID = 2) and (limit <> 'Fixed') then
     Result := true;
  end
  else
  if ShowLPTables then
  begin
    if currencyID = 4 then
     result := true;
  end;

  if HideFullTables then
  begin
    if chairs = Players then
      result := false
  end;
 end
 else
 begin
   HideCompletedTournaments := SessionModule.SessionSettings.ValuesAsBoolean[SessionHideCompletedTournamens];
   HideRunningTournamens := SessionModule.SessionSettings.ValuesAsBoolean[SessionHideRunningTournamens];

   flag := false;

    for Loop := 0 to XMLSub.ChildNodes.Count - 1 do
    begin
      XMLStat := XMLSub.ChildNodes.Nodes[Loop];
      if XMLStat.Attributes[XMLATTRNAME_ID] = StatID_TournamentState then
      begin
       State := XMLStat.Attributes['value'];
       break;
      end
    end;
  {  if HideCompletedTournaments  then
   begin
     if State = 'Completed' then
      flag := true;
   end;{}
   if state = 'Stopped' then
    flag := true;
   if HideCompletedTournaments and HideRunningTournamens then
   begin
    if (State = 'Completed') or (State = 'Running') then
     flag := true;
   end
   else
   if HideCompletedTournaments and not HideRunningTournamens then
   begin
     if State = 'Completed' then
      flag := true;
   end
   else
   if not HideCompletedTournaments and HideRunningTournamens then
   begin
     if State = 'Running' then
      flag := true;
   end;{}
   Result := not flag;
 end;
end;


procedure TLobbyModule.UpdateProcesses;
var
  BadProcessID: Boolean;
  curCategory: TDataList;
  curSubCategory: TDataList;
  curProcess: TDataList;
  curColumn: TDataList;
  Loop: Integer;
  OldProcessID: Integer;
begin
  BadProcessID := true;
  OldProcessID := FCurrentProcessID;

  FCurrentColumns := nil;
  FCurrentProcesses := nil;

  if Data.Find(FCurrentCategoryID, curCategory) then
    if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
      if curSubCategory.Find(SubCategoryColumnsItemID, FCurrentColumns) then
        if curSubCategory.Find(SubCategoryProcessesItemID, FCurrentProcesses) then
          if curSubCategory.Find(SubCategoryProcessesInfoItemID, FCurrentProcessesInfo) then
            if FCurrentProcesses.Find(FCurrentProcessID, curProcess) then
              BadProcessID := false;

  if FCurrentColumns <> nil then
    if FCurrentColumns.Count > 0 then
    begin
      curColumn := nil;


      if FCurrentColumns.Find(FCurrentSortStatsID, curColumn) then
        curColumn.ValuesAsBoolean[DATANAME_SORT] := FCurrentSortAscending
      else{}
      if ((FCurrentSubCategoryID = TournamentSubCategoryID) and
         FCurrentColumns.Find(StatID_TournamentDate, curColumn)) or
         ((FCurrentSubCategoryID <> TournamentSubCategoryID) and
         FCurrentColumns.Find(StatID_Stakes, curColumn)) then
         curColumn.ValuesAsBoolean[DATANAME_SORT] := true;


      if curColumn = nil then
      begin
        curColumn := FCurrentColumns.Items(0);
        curColumn.ValuesAsBoolean[DATANAME_SORT] := true;
      end;

      FCurrentSortStatsID := curColumn.ID;
      FCurrentSortAscending := curColumn.ValuesAsBoolean[DATANAME_SORT];

      if FCurrentProcesses <> nil then
        if FCurrentProcesses.Count > 0 then
        begin

          FOldProcessCount := FCurrentProcesses.Count;

          FCurrentProcesses.SortItems('currencyid', false);

         // UpdateProcesses_Sort(0, FPlayMoneyProcessCount - 1);
          UpdateProcesses_Sort(0, FCurrentProcesses.Count - 1);{}
        end;
    end;

  if BadProcessID then
  begin
    FCurrentProcessIDPosition := 0;
    FCurrentProcessID := 0;
  end;

  if FCurrentProcessID = 0 then
    if FCurrentProcesses <> nil then
      if FCurrentProcesses.Count > 0 then
        FCurrentProcessID := FCurrentProcesses.Items(0).ID;

  if FCurrentProcesses <> nil then
    for Loop := 0 to FCurrentProcesses.Count - 1 do
      if FCurrentProcesses.Items(Loop).ID = FCurrentProcessID then
      begin
        FCurrentProcessIDPosition := Loop;
        break;
      end;

  UpdateSummary;
  if (FCurrentProcessID <> OldProcessID)
    or (SessionModule.SessionState = poConnecting) or
      (SessionModule.SessionState = poReConnecting) then
    begin
      Do_ChooseProcess(FCurrentProcessID, FCurrentProcessIDPosition);
      SendProcessInfoTimer.Enabled := true;
    end;
  if FWorking and Assigned(FOnUpdateProcesses) then
    FOnUpdateProcesses;

   {FShowProcessInfo := true;
  if (ShowPlayMoneyTables) and (FPlayMoneyProcessCount = 0) or
    (ShowNoLimitTables) and (FNoLimitProcessCount = 0) or
    (ShowLimitTables) and (FLimitProcessCount = 0) or
    (ShowLPTables) and (FLPProcessCount = 0) then
     FShowProcessInfo := false;{}
 {  if FShowAll then
    FShowProcessInfo := true;{}
end;


procedure TLobbyModule.UpdateProcesses_Sort(IndexFrom, IndexTo: Integer);
var
  IsNumber, isDate: Boolean;
  Loop: Integer;
  StartIndex: Integer;
begin
  if FCurrentSortStatsID = StatID_Stakes then
  begin
    FCurrentProcesses.SortItems(DATANAME_STAKESORT, true, false, IndexFrom, IndexTo);

      StartIndex := -1;
      for Loop := IndexFrom to IndexTo do
        if FCurrentProcesses.Items(Loop).ValuesAsString[DATANAME_STAKESORT] > ' ' then
        begin
          StartIndex := Loop;
          break;
        end;

      if StartIndex > IndexFrom then
      begin
        UpdateProcesses_StakesSort(IndexFrom, StartIndex - 1);
        UpdateProcesses_StakesSort(StartIndex, IndexTo);
      end
      else
        UpdateProcesses_StakesSort(IndexFrom, IndexTo);
  end
  else
  if  FCurrentSortStatsID = StatID_TournamentDate then
  begin
    IsNumber := false;
    isDate := true;
    StartIndex := 0;
    FCurrentProcesses.SortItems(XMLNODENAME_TOURNAMENTSTATEID,true);
    for Loop := IndexFrom to IndexTo-1 do
    begin
     if FCurrentProcesses.Items(Loop).ValuesAsString[IntToStr(StatID_TournamentState)] <>
        FCurrentProcesses.Items(Loop+1).ValuesAsString[IntToStr(StatID_TournamentState)] then
     begin
      FCurrentProcesses.SortItems(inttostr(FCurrentSortStatsID), FCurrentSortAscending,
        IsNumber, StartIndex, Loop,isDate);
        StartIndex := Loop + 1;
     end;
    end;
    FCurrentProcesses.SortItems(inttostr(FCurrentSortStatsID), FCurrentSortAscending,
        IsNumber, StartIndex, Loop,isDate);
  end
  else
  begin
    IsNumber := false;
    FCurrentProcesses.SortItems(inttostr(FCurrentSortStatsID), FCurrentSortAscending,
      IsNumber, IndexFrom, IndexTo);
  end;   {}
end;

procedure TLobbyModule.UpdateProcesses_StakesSort(IndexFrom, IndexTo: Integer);
var
  Loop: Integer;
  LoopFrom: Integer;
  CurGroupID: Integer;
  PlayersCountStats: String;
begin
  FCurrentProcesses.SortItems(inttostr(FCurrentSortStatsID),
    FCurrentSortAscending, true, IndexFrom, IndexTo);

  PlayersCountStats := inttostr(StatID_PlayersCount);
  LoopFrom := IndexFrom;
  CurGroupID := FCurrentProcesses.Items(IndexFrom).Value;

  for Loop := IndexFrom + 1 to IndexTo do
  begin
    if FCurrentProcesses.Items(Loop).Value <> CurGroupID then
    begin
      FCurrentProcesses.SortItems(PlayersCountStats, false, true, LoopFrom, Loop - 1);
      LoopFrom := Loop;
      CurGroupID := FCurrentProcesses.Items(Loop).Value;
    end;
  end;

  FCurrentProcesses.SortItems(PlayersCountStats, false, true, LoopFrom, IndexTo);
end;

procedure TLobbyModule.UpdateProcessInfo;
begin
  if FWorking and Assigned(FOnUpdateProcessInfo) then
    FOnUpdateProcessInfo;
end;


// Visual procedures

procedure TLobbyModule.Do_ChooseCategory(NewCategoryID: Integer);
begin
  FCurrentCategoryID := NewCategoryID;
  UpdateCategories;
end;

procedure TLobbyModule.Do_ChooseSubCategory(NewSubcategoryID: Integer);
begin
  FCurrentSubCategoryID := NewSubcategoryID;
  UpdateProcesses;
  UpdateTimerTimer(UpdateTimer);
  UpdateTimer.Enabled := true;
  if  (NewSubcategoryID = TournamentSubCategoryID) and (FCurrentSortStatsID <> StatID_TournamentDate) then
   Do_SortProcesses(StatID_TournamentDate);
end;

procedure TLobbyModule.Do_SortProcesses(NewSortStatsID: Integer);
var
  curColumn: TDataList;
begin
  if CurrentColumns = nil then
    exit;

  if LobbyModule.CurrentColumns.Find(NewSortStatsID, curColumn) then
  begin
    if FCurrentSortStatsID <> NewSortStatsID then
      FCurrentSortAscending := true
    else
      FCurrentSortAscending := not curColumn.ValuesAsBoolean[DATANAME_SORT];

    curColumn.ValuesAsBoolean[DATANAME_SORT] := FCurrentSortAscending;
    FCurrentSortStatsID := NewSortStatsID;
    UpdateProcesses;
  end;
end;

procedure TLobbyModule.Do_ChooseProcess(NewProcessID, NewProcessIndex: Integer);
begin
 {if not FShowAll then
 begin
  if SessionModule.SessionSettings.ValuesAsBoolean[SessionShowPlayMoneyTables] and
   (NewProcessIndex >= FPlayMoneyProcessCount) then
   exit;
 if SessionModule.SessionSettings.ValuesAsBoolean[SessionShowNoLimitTables] and
   (NewProcessIndex >= FNoLimitProcessCount) then
   exit;

   if SessionModule.SessionSettings.ValuesAsBoolean[SessionShowLimitTables] and
   (NewProcessIndex >= FLimitProcessCount) then
   exit;

   if SessionModule.SessionSettings.ValuesAsBoolean[SessionShowLPTables] and
   (NewProcessIndex >= FLPProcessCount) then
    exit;
 end;    {}
  if FCurrentProcessID <> NewProcessID then
    SendProcessInfoTimer.Enabled := true;

  FCurrentProcessID := NewProcessID;
  FCurrentProcessIDPosition := NewProcessIndex;
  UpdateProcessInfo;
end;

procedure TLobbyModule.Do_JoinProcess(NewProcessID: Integer);
var
  curCategory: TDataList;
  curSubCategory: TDataList;
  curProcesses: TDataList;
  curProcess: TDataList;
begin
  if FCurrentSubCategoryID = TournamentSubCategoryID then
  begin
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(TournamentSubCategoryID, curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesItemID, curProcesses) then
          if curProcesses.Find(NewProcessID, curProcess) then
            TournamentModule.StartTournament(NewProcessID, curProcess.Name);
  end
  else
  if FCurrentSubCategoryID = SitAndGoSubCategoryID then
  begin
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(SitAndGoSubCategoryID, curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesItemID, curProcesses) then
          if curProcesses.Find(NewProcessID, curProcess) then
            TournamentModule.StartTournament(NewProcessID, curProcess.Name);
  end
  else
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesItemID, curProcesses) then
          if curProcesses.Find(NewProcessID, curProcess) then
            ProcessModule.StartTable(NewProcessID,curProcess.ValuesAsInteger[XMLNODENAME_ACTIONDISPATCHERID],
                                     curSubCategory.Name, curProcess.Name);
end;

procedure TLobbyModule.Do_Action(Action: TLobbyAction);
begin
  case Action of

    laExit:
      SessionModule.CloseApplication;

    laNewAccount:
      UserModule.NewUser;

    laLogin:
      UserModule.Login;

    laCashier:
      CashierModule.StartWork;

    laWaitingList:
      if (FCurrentSubCategoryID <> TournamentSubCategoryID) and (FCurrentSubCategoryID <> SitAndGoSubCategoryID) then
        ProcessModule.WaitingList
      else
        ThemeEngineModule.ShowWarning(cstrWaitingListNotAllowed);

    laHidePlayMoneyTables:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowPlayMoneyTables] := true;
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowNoLimitTables] := false;
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowLimitTables] := false;
      SessionModule.SaveToRegistry;
      FCurrentProcessIDPosition := 0;
      FCurrentProcessID := 0;
      {UpdateProcesses;
      UpdateProcessInfo;{}
      Do_ChooseSubCategory(CurrentSubCategoryID);
    end;

    laHideNoLimitTables:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowNoLimitTables] := false;
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowLimitTables] := true;
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowPlayMoneyTables] := false;
      SessionModule.SaveToRegistry;
      FCurrentProcessIDPosition := 0;
      FCurrentProcessID := 0;
      {UpdateProcesses;
      UpdateProcessInfo;{}
      Do_ChooseSubCategory(CurrentSubCategoryID);
    end;

    laHideLimitTables:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowLimitTables] := false;
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowNoLimitTables] := true;
      SessionModule.SessionSettings.ValuesAsBoolean[SessionShowPlayMoneyTables] := false;
      SessionModule.SaveToRegistry;
      FCurrentProcessIDPosition := 0;
      FCurrentProcessID := 0;
      {UpdateProcesses;
      UpdateProcessInfo;{}
      Do_ChooseSubCategory(CurrentSubCategoryID);
    end;
    lahidewelcomemessage:
      SessionModule.SessionSettings.ValuesAsBoolean[SessionHideWelcomeMessage] :=
       not SessionModule.SessionSettings.ValuesAsBoolean[SessionHideWelcomeMessage];
    laAllInsRemaining:
      ProcessModule.AllInsRemaining;

    laRequestAllInsReset:
      ProcessModule.RequestAllInsReset;

    laRecordedHands:
      ProcessModule.RecordedHands;

    laRequestHandHistory:
      ProcessModule.RequestHandHistory;

    laViewStatistics:
      ProcessModule.ViewStatistics;

    laTrunsferFunds:
      UserModule.Do_TransferFunds;

    laFindPlayer :
      UserModule.Do_OpenFindPlayerForm;

    laChangeProfile:
      UserModule.ChangeProfile;

    laChangeAvatar:
      UserModule.ChangePlayerLogo;

    laChangeValidateEmail:
      UserModule.ChangeValidateEmail;

    laChangeMailingAddress:
      CashierModule.ChangeMailingAddress;

    laChangePassword:
      UserModule.ChangePassword;

    laUse4ColorsDeck:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionUse4ColorsDeck] :=
        not SessionModule.SessionSettings.ValuesAsBoolean[SessionUse4ColorsDeck];
      SessionModule.SaveToRegistry;
      ProcessModule.UpdateOptions;
      UpdateOptions;
    end;

    laEnableAnimation:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableAnimation] :=
        not SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableAnimation];
      SessionModule.SaveToRegistry;
      ProcessModule.UpdateOptions;
      UpdateOptions;
    end;

    laEnableChatBubbles:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableChatBubbles] :=
        not SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableChatBubbles];
      SessionModule.SaveToRegistry;
      ProcessModule.UpdateOptions;
      UpdateOptions;
    end;

    laEnableSounds:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableSounds] :=
        not SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableSounds];
      SessionModule.SaveToRegistry;
      ProcessModule.UpdateOptions;
      UpdateOptions;
    end;

    lahidecompletetables:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionHideCompletedTournamens] :=
        not SessionModule.SessionSettings.ValuesAsBoolean[SessionHideCompletedTournamens];
      SessionModule.SaveToRegistry;

      {UpdateProcesses;
      UpdateProcessInfo;{}
      Do_ChooseSubCategory(CurrentSubCategoryID);
    end;

    lahiderunningtables:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionHideRunningTournamens] :=
        not SessionModule.SessionSettings.ValuesAsBoolean[SessionHideRunningTournamens];
      SessionModule.SaveToRegistry;
      {UpdateProcesses;
      UpdateProcessInfo;{}
      Do_ChooseSubCategory(CurrentSubCategoryID);
    end;

    lahidefulltables:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionHideFullTables] :=
        not SessionModule.SessionSettings.ValuesAsBoolean[SessionHideFullTables];
      SessionModule.SaveToRegistry;
      {UpdateProcesses;
      UpdateProcessInfo;{}
      Do_ChooseSubCategory(CurrentSubCategoryID);
    end;
    laReverseStereoPanning:
    begin
      SessionModule.SessionSettings.ValuesAsBoolean[SessionReverseStereoPanning] :=
        not SessionModule.SessionSettings.ValuesAsBoolean[SessionReverseStereoPanning];
      SessionModule.SaveToRegistry;
      ProcessModule.UpdateOptions;
      UpdateOptions;
    end;

    laHelp:
    begin
      ShellExecute(0,pchar('open'),pchar(cstrLobbyHelp),nil,nil,SW_RESTORE);
    end;

    laGameRules:
    begin
      ShellExecute(0,pchar('open'),pchar(cstrLobbyGameRules),nil,nil,SW_RESTORE);
    end;

    laTip:
    begin
      ShellExecute(0,pchar('open'),pchar(cstrLobbyTip),nil,nil,SW_RESTORE);
    end;

    laNews:
    begin
       WelcomeMessageForm.ShowModal;
      //ShellExecute(0,pchar('open'),pchar(cstrLobbyNews),nil,nil,SW_RESTORE);
    end;

    laWhatsNew:
    begin
      ShellExecute(0,pchar('open'),pchar(cstrLobbyWhatsNew),nil,nil,SW_RESTORE);
    end;

    laWhyChoose:
    begin
      ShellExecute(0,pchar('open'),pchar(cstrLobbyWhyChoose),nil,nil,SW_RESTORE);
    end;

    laAbout:
    begin
      {ThemeEngineModule.ShowMessage(cstrAbout + CSA_Version + #13#10 +
        'Serial number: ' + inttostr(CSA_Build) + #13#10 +
        SessionModule.SessionSettings.ValuesAsString[SessionGameVersion]);{}
       AboutForm.ShowModal;
    end;
    labikiniforum:
      ShellExecute(0,pchar('open'),pchar(cstrLobbyBikiniForum),nil,nil,SW_RESTORE);

    laleaderboardsforthisweek:
     UserModule.Do_GetLeaderBoardthisweek;

    laleaderboardsforthismonth:
     UserModule.Do_GetLeaderBoardthismonth;

    laleaderboardsforthisyear:
     UserModule.Do_GetLeaderBoardthisyear;

    laleaderboardsforpreviousweek:
     UserModule.Do_GetLeaderBoardpreviousweek;

    laleaderboardsforpreviousmonth:
     UserModule.Do_GetLeaderBoardpreviousmonth;

    laleaderboardsforpreviousyear:
     UserModule.Do_GetLeaderBoardpreviousyear;

    laleaderpoints:
      UserModule.Do_LeaderPointsRequest;

    laGetMoreChips:
    begin
      ParserModule.Send_GetBalanceInfo;
      BalanceInfoUpdated := true;
    end;

    lasendlogfile:
      Do_SendLogFile;
  end;
end;

procedure TLobbyModule.UpdateOptions;
begin
  if Assigned(FOnUpdateOptions) then
    FOnUpdateOptions;
end;


// Timers

procedure TLobbyModule.SendProcessesTimerTimer(Sender: TObject);
begin
  SendProcessesTimer.Enabled := false;
  if FCurrentSubCategoryID = TournamentSubCategoryID then
    ParserModule.Send_GetTournaments(TournamentSubCategoryID)
  else
  if FCurrentSubCategoryID = SitAndGoSubCategoryID then
    ParserModule.Send_GetTournaments(SitAndGoSubCategoryID)
  else
    if FCurrentSubCategoryID > 0 then
      ParserModule.Send_GetProcesses(FCurrentSubCategoryID);
end;

procedure TLobbyModule.SendProcessInfoTimerTimer(Sender: TObject);
begin
  SendProcessInfoTimer.Enabled := false;
  if FCurrentProcessID > 0 then
  begin
    if FCurrentSubCategoryID = TournamentSubCategoryID then
      ParserModule.Send_GetTournamentInfo(FCurrentProcessID)
    else
    if FCurrentSubCategoryID = SitAndGoSubCategoryID then
      ParserModule.Send_GetTournamentInfo(FCurrentProcessID)
    else
      ParserModule.Send_GetProcessInfo(FCurrentProcessID);
  end;
end;

procedure TLobbyModule.UpdateTimerTimer(Sender: TObject);
begin
  if (FCurrentSubCategoryID = TournamentSubCategoryID) or (FCurrentSubCategoryID = SitAndGoSubCategoryID) then
  begin
    ParserModule.Send_UpdateSummary;
    SendProcessesTimerTimer(SendProcessesTimer);
    SendProcessInfoTimerTimer(SendProcessInfoTimer);
  end
  else
    ParserModule.Send_UpdateLobbyInfo(FCurrentSubCategoryID, FCurrentProcessID);
end;


// Do procedures

procedure TLobbyModule.Do_SendCustomSupportMessage(msgSubject,
  msgBody: String);
begin
  ParserModule.Send_CustomSupport(msgSubject, msgBody);
end;

procedure TLobbyModule.Do_CustomSupport;
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;
    if not UserModule.UserEMailValidated then
    begin
      ThemeEngineModule.ShowWarning(cstrEmailNotValidated);
      UserModule.ChangeValidateEmail;
    end
    else
      if Assigned(FOnCustomSupport) then
        FOnCustomSupport
  end
  else
  begin
    UserModule.OnActionLogin := Do_CustomSupport;
    UserModule.Login;
  end;
end;

procedure TLobbyModule.Run_CustomSupport(XMLRoot: IXMLNode);
{
<object name="lobby">
  <apcustomsupport result="0|..."/>
</object>
}
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    if Assigned(OnCustomSupportSent) then
      OnCustomSupportSent;
  end
  else
    if Assigned(OnCustomSupportFailed) then
      OnCustomSupportFailed;
end;

procedure TLobbyModule.UpdateLoginState;
begin
  UpdateSummary;
end;


// Acvitated/Minimized

procedure TLobbyModule.SetLobbyActivated(const Value: Boolean);
begin
  if FLobbyActivated <> Value then
  begin
    FLobbyActivated := Value;
    if Value then
      UpdateTimerTimer(UpdateTimer);

    UpdateTimer.Enabled := False;
    if FLobbyActivated then
      UpdateTimer.Interval := UpdateInfoTimeSec * 1000
    else
      UpdateTimer.Interval := UpdateInfoTimeSec * 10000;
    UpdateTimer.Enabled := True;
    Logger.Add('UpdateTimer interval=' + inttostr(UpdateTimer.Interval));
  end;
end;

procedure TLobbyModule.WB_SetBorderColor(Sender: TObject; BorderColor: String);
{
  BorderColor: Can be specified in HTML pages in two ways.
               1) by using a color name (red, green, gold, firebrick, ...)
               2) or by using numbers to denote an RGB color value. (#9400D3, #00CED1,...)

  See: http://msdn.microsoft.com/library/default.asp?url=/workshop/author/dhtml/
    reference/properties/borderstyle.asp
}

var
  Document : IHTMLDocument2;
  Element : IHTMLElement;
begin
  Document := TWebBrowser(Sender).Document as IHTMLDocument2;
  if Assigned(Document) then
  begin
    Element := Document.Body;
    if Element <> nil then
    begin
      Element.Style.BorderColor := BorderColor;
    end;
  end;
end;

procedure TLobbyModule.WB_SetBorderStyle(Sender: TObject; BorderStyle: String);
{
  BorderStyle values:

  'none'         No border is drawn
  'dotted'       Border is a dotted line. (as of IE 5.5)
  'dashed'       Border is a dashed line. (as of IE 5.5)
  'solid'        Border is a solid line.
  'double'       Border is a double line
  'groove'       3-D groove is drawn
  'ridge'        3-D ridge is drawn
  'inset'        3-D inset is drawn
  'window-inset' Border is the same as inset, but is surrounded by an additional single line
  'outset'       3-D outset is drawn

  See: http://msdn.microsoft.com/library/default.asp?url=/workshop/author/dhtml/
    reference/properties/borderstyle.asp
}

var
  Document : IHTMLDocument2;
  Element : IHTMLElement;
begin
  Document := TWebBrowser(Sender).Document as IHTMLDocument2;
  if Assigned(Document) then
  begin
    Element := Document.Body;
    if Element <> nil then
    begin
      Element.Style.BorderStyle := BorderStyle;
    end;
  end;
end;

procedure TLobbyModule.WB_Set3DBorderStyle(Sender: TObject; bValue: Boolean);
{
  bValue: True: Show a 3D border style
          False: Show no border
}
var
  Document : IHTMLDocument2;
  Element : IHTMLElement;
  StrBorderStyle: string;
begin
  Document := TWebBrowser(Sender).Document as IHTMLDocument2;
  if Assigned(Document) then
  begin
    Element := Document.Body;
    if Element <> nil then
    begin
      case BValue of
        False: StrBorderStyle := 'none';
        True: StrBorderStyle := '';
      end;
      Element.Style.BorderStyle := StrBorderStyle;
    end;
  end;
end;



procedure TLobbyModule.SetFShowProcessInfo(const Value: Boolean);
begin
  FShowProcessInfo := Value;
end;


procedure TLobbyModule.SetisTournament(const Value: Boolean);
begin
  FisTournament := Value;
end;


procedure TLobbyModule.SetBalanceInfoUpdated(const Value: Boolean);
begin
  FBalanceInfoUpdated := Value;
end;

procedure TLobbyModule.Do_SendLogFile;
var
 StringZipFile: TStringStream;
 StringList: TStringList;
 Buf: string;
 Loop: Integer;
 WebServiceHost: String;
begin
 Logger.SaveBuffers;
 if FileExists(SessionModule.AppPath+cstrCSALogFile) then
 begin
  try
    StringList := TStringList.Create;
    StringList.LoadFromFile(SessionModule.AppPath+cstrCSALogFile);
    WebServiceHost := SessionModule.SessionSettings.ValuesAsString[SessionWebserviceHost];
    if StringList.Count > 10000 then
    begin
     for Loop := StringList.count-1 downto StringList.count-1 - 10000 do
      buf := buf + #13#10 +StringList.Strings[Loop];
    end
    else
     buf := StringList.Text;

     Buf := Zip(Buf);
     
     StringZipFile := TStringStream.Create(buf);
     Buf := EncodeBase64(StringZipFile.DataString);
     THTTPPostThread.Create(Self,Buf,StringZipFile.Size,StringZipFile.Size,'CSA.pack',WebServiceHost,
                            'CSALogs\'+IntToStr(UserModule.UserID),0,false);
   finally
    StringList.Free;
   end;
 end;{}

end;

end.
