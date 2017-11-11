unit uTournamentModule;

interface

uses
  SysUtils, Classes, Forms,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uTakingForm,
  uTournamentLobbyForm,
  uDataList, ExtCtrls,
  uProcessModule;

type
  TTournamentProcess = class
  public
    ID: Integer;
    Name: String;
    TournamentType: Integer;
    TournamentState: Integer;
    StartingChips: string;
    BuyIn: Currency;
    Fee: Currency;
    CurrencyTypeID: Integer;
    Registered: Boolean;
    MainInfo: String;
    AdvancedInfo: String;
    PrizePoolInfo: String;
    URL: String;
    Pot: Currency;
    WinnersCount: Integer;
    PrizesInfo: String;
    Tables: TDataList;
    TablePlayers: TDataList;
    TournamentLevels: TDataList;
    TournamentPrizes: TDataList;
    Players: TDataList;
    TournamentLobbyForm: TTournamentLobbyForm;
    TakingForm: TTakingForm;
    CurrentState: TProcessState;
    CurrentCommandReceived: Integer;
    CurrentTableID: Integer;
    AutoRebuy: Boolean;
    RebuyCount: Integer;
    RebuyAllowed: Boolean;
    AddonAllowed: Boolean;

    constructor Create(AOwner: TComponent; AID: Integer; AName: String);
    destructor  Destroy; override;
  end;

  TTournamentModule = class(TDataModule)
    FinishProcessTimer: TTimer;
    UpdateTimer: TTimer;
    RegisterInfoTimer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FinishProcessTimerTimer(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure RegisterInfoTimerTimer(Sender: TObject);
  private
    FTournaments: TStringList;
    FTournamentLimit: Integer;
    FTournamentID: Integer;
    FTournamentName: String;
    FMsg: String;
    FGetPlayersCount: Integer;

    function FindTournament(TournamentID: Integer): TTournamentProcess;
    procedure CheckForStart(curTournament: TTournamentProcess);

    procedure Run_GetInfo(XMLRoot: IXMLNode);
    procedure Run_GetPlayers(XMLRoot: IXMLNode);
    procedure Run_GetProcesses(XMLRoot: IXMLNode);
    procedure Run_GetProcessPlayers(XMLRoot: IXMLNode);
    procedure Run_Register(XMLRoot: IXMLNode);
    procedure Run_UnRegister(XMLRoot: IXMLNode);
    procedure Run_TournamentEvent(XMLRoot: IXMLNode);
    procedure Run_GetLevelsInfo(XMLRoot: IXMLNode);
    procedure Run_Rebuy(XMLRoot: IXMLNode);

    procedure UpdateTournamentData;
    procedure SetTournamentLimit(const Value: Integer);
    procedure StopLoading(ID1, ID2: Integer);
  public
    property  TournamentLimit: Integer read FTournamentLimit write SetTournamentLimit;

    procedure StartTournament(TournamentID: Integer; AName: String);
    procedure StopTournament(TournamentID: Integer);
    procedure UpdateLoginState;

    function GetTournament(TournamentID: Integer): TTournamentProcess;

    procedure RunCommand(XMLRoot: IXMLNode);

    procedure Do_ViewLobby(TournamentID: Integer);
    procedure Do_Register(TournamentID: Integer); overload;
    procedure Do_UnRegister(TournamentID: Integer);
    procedure Do_Register(TournamentID: Integer; Password: String); overload;
    procedure Do_Login(TournamentID: Integer);
    procedure Do_ChooseTable(TournamentID, ProcessID: Integer);
    procedure Do_ObserveTable(TournamentID, ProcessID: Integer);
    procedure Do_PlayerDetails(TournamentID, UserID: Integer);
    procedure Do_Finish(TournamentID: Integer);
    procedure Do_ChooseTournamentInfo(TournamentID: Integer);
    procedure Do_Addon(TournamentID: Integer; Value: Integer);
    procedure Do_AutoRebuy(TournamentID: Integer; Value: Integer);
  end;

var
  TournamentModule: TTournamentModule;

implementation

uses
  uLogger, uConstants, uUserModule, uParserModule, uLobbyModule,
  uConversions, uThemeEngineModule, uSessionModule, uPictureMessageForm, Dialogs,
  uPasswordForm;

{$R *.dfm}


{ TTournamentProcess }

constructor TTournamentProcess.Create(AOwner: TComponent; AID: Integer; AName: String);
begin
  CurrentState := psNone;

  {TakingForm := TTakingForm.CreateParented(0);
  TakingForm.SetOnCloseEvent(TournamentModule.StopLoading, AID, 0);
  if pos('tournament', lowercase(AName)) > 0 then
    TakingForm.StatusLabel.Caption := AName + cstrTournamentLoading
  else
    TakingForm.StatusLabel.Caption := AName + cstrTournamentWord + cstrTournamentLoading;
  TakingForm.Show;{}

  ID := AID;
  Name := AName;
  TournamentType := 0;
  TournamentState := 0;
  BuyIn := 0;
  CurrencyTypeID := 1;
  Registered := false;
  MainInfo := '';
  AdvancedInfo := '';
  PrizePoolInfo := '';
  PrizesInfo := '';
  CurrentCommandReceived := 0;
  CurrentTableID := 0;
  Tables := TDataList.Create(0, nil);
  TablePlayers := TDataList.Create(0, nil);
  TournamentLevels := TDataList.Create(0, nil);
  TournamentPrizes := TDataList.Create(0, nil);
  Players := TDataList.Create(0, nil);
  TournamentLobbyForm := TTournamentLobbyForm.CreateParented(0);
  TournamentLobbyForm.ID := AID;
  TournamentLobbyForm.Name := AName;
end;

destructor TTournamentProcess.Destroy;
begin
  Tables.Free;
  TablePlayers.Free;
  TournamentLevels.Free;
  TournamentPrizes.Free;
  Players.Free;
  TournamentLobbyForm.Free;

  if TakingForm <> nil then
  begin
    TakingForm.Free;
    TakingForm.OnClose := nil;
  end;
end;


{ TTournamentModule }

procedure TTournamentModule.DataModuleCreate(Sender: TObject);
begin
  UpdateTimer.Interval := UpdateInfoTimeSec * 1000;
  FTournaments := TStringList.Create;
  FTournamentLimit := 0;
  FGetPlayersCount := 0;
end;

procedure TTournamentModule.DataModuleDestroy(Sender: TObject);
var
  curObj: TObject;
begin
  while FTournaments.Count > 0 do
  begin
    curObj := FTournaments.Objects[0];
    if curObj <> nil then
      (curObj as TTournamentProcess).Free;
    FTournaments.Delete(0);
  end;

  FTournaments.Free;
end;

procedure TTournamentModule.SetTournamentLimit(const Value: Integer);
begin
  FTournamentLimit := Value;
end;

function TTournamentModule.FindTournament(
  TournamentID: Integer): TTournamentProcess;
var
  nInd: Integer;
begin
  Result := nil;
  nInd := FTournaments.IndexOf(inttostr(TournamentID));
  if nInd >= 0 then
    Result := FTournaments.Objects[nInd] as TTournamentProcess;
end;

// XML Commands parsing


procedure TTournamentModule.RunCommand(XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Add('TournamentModule.RunCommand started', llExtended);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := lowercase(XMLNode.NodeName);
        Logger.Add('TournamentModule.RunCommand found ' + strNode, llExtended);

        if strNode = 'togetinfo' then
          Run_GetInfo(XMLNode)
        else
        if strNode = 'togetplayers' then
          Run_GetPlayers(XMLNode)
        else
        if strNode = 'togetprocesses' then
          Run_GetProcesses(XMLNode)
        else
        if strNode = 'togetprocessplayers' then
          Run_GetProcessPlayers(XMLNode)
        else
        if strNode = 'toregister' then
          Run_Register(XMLNode)
        else
        if strNode = 'tounregister' then
          Run_UnRegister(XMLNode)
        else
        if strNode = 'totournamentevent' then
          Run_TournamentEvent(XMLNode);
        if strNode = 'togetlevelsinfo' then
          Run_GetLevelsInfo(XMLNode)
        else
        if strNode = 'torebuy' then
          Run_Rebuy(XMLNode);
      end;
  except
    Logger.Add('TournamentModule.RunCommand failed', llBase);
  end;
end;

procedure TTournamentModule.Run_GetInfo(XMLRoot: IXMLNode);
{
<object name="tournament">
  <togetinfo result="0|..." tournamentid="123" type="1" state="1">
    <base>
      <data value="Poker World-Wide Super-Puper Tournament"/>
      <data value="Pot limit Hol'em. Buy-In: $30+$3"/>
      <data value="Tournament in progress."/>
      <data value="Registration closed."/>
    </base>
    <prizerules>
      <data value="The prize pool structure has been modified."/>
      <data value="Click the 'Details' button to view detailed info."/>
      <data value=""/>
      <data value="Good luck!"/>
    </prizerules>
    <advanced>
      <data value="Tournament started: October 3, 2003 1:00 PM ET (running 2h 17 min)"/>
      <data value="Next break: in 53 min."/>
      <data value="Level 9: blinds 300/600"/>
      <data value="Next level: in 8 min. blinds 400/800"/>
      <data value="95 enrance, currently 11 players in 2 tables"/>
      <data value="Stacks: 31785-largest, 12954-average, 5664-smallest"/>
      <data value=""/>
      <data value=""/>
    </advanced>
    <prizepool pot="$20000" winnerscount="5">
      <data value="1st $1000">
      <data value="2nd $900">
      <data value="3rd $800">
      <data value="4th $700">
      <data value="5th $600">
    </prizepool>
  </togettournamentinfo>
</object>
}
var
  ErrorCode: Integer;

  curTournament: TTournamentProcess;

  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
  Loop2: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    curTournament := FindTournament(XMLRoot.Attributes['tournamentid']);
    if curTournament <> nil then
    begin
      curTournament.TournamentType := XMLRoot.Attributes['type'];
      curTournament.TournamentState := XMLRoot.Attributes['state'];
      curTournament.BuyIn := Conversions.Str2Cur(XMLRoot.Attributes['buyin']);
      if XMLRoot.HasAttribute('fee') then
       curTournament.Fee := Conversions.Str2Cur(XMLRoot.Attributes['fee']);

      if XMLRoot.HasAttribute('rebuyallowed') then
      begin
       curTournament.RebuyAllowed := XMLRoot.Attributes['rebuyallowed'] = 1;
      end;

      if XMLRoot.HasAttribute('rebuycount') then
       curTournament.RebuyCount := XMLRoot.Attributes['rebuycount'];

      if XMLRoot.HasAttribute('currencytypeid') then
      curTournament.CurrencyTypeID := XMLRoot.Attributes['currencytypeid'];


      if XMLRoot.HasAttribute('addonallowed') then
        curTournament.AddonAllowed := XMLRoot.Attributes['addonallowed'] = 1;


      for Loop := 0 to XMLRoot.ChildNodes.Count -1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := XMLNode.NodeName;

        if strNode = 'base' then
        begin
          curTournament.MainInfo := '';
          for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            curTournament.MainInfo := curTournament.MainInfo +
              XMLNode.ChildNodes.Nodes[Loop2].Attributes['value'] + #13#10;
        end;

        if strNode = 'prizerules' then
        begin
          curTournament.URL := cstrTournamentPrizesPool;
          curTournament.PrizePoolInfo := '';
          for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            curTournament.PrizePoolInfo := curTournament.PrizePoolInfo +
              XMLNode.ChildNodes.Nodes[Loop2].Attributes['value'] + #13#10;
        end;

        if strNode = 'advanced' then
        begin
          curTournament.AdvancedInfo := '';
          for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            curTournament.AdvancedInfo := curTournament.AdvancedInfo +
              XMLNode.ChildNodes.Nodes[Loop2].Attributes['value'] + #13#10;
        end;

        if strNode = 'prizepool' then
        begin
          curTournament.Pot := Conversions.Str2Cur(XMLNode.Attributes['pot']);
          curTournament.WinnersCount := strtointdef(XMLNode.Attributes['winnerscount'], 0);
          curTournament.PrizesInfo := '';
          for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            curTournament.PrizesInfo := curTournament.PrizesInfo +
              XMLNode.ChildNodes.Nodes[Loop2].Attributes['value'] + #13#10;
        end;
      end;

      curTournament.TournamentLobbyForm.UpdateInfo(curTournament.MainInfo,
        curTournament.AdvancedInfo, curTournament.PrizesInfo,
        curTournament.PrizePoolInfo, curTournament.URL,
        curTournament.Pot, curTournament.WinnersCount);
      curTournament.TournamentLobbyForm.UpdateState(curTournament.Name,
        UserModule.Logged, curTournament.Registered,
        curTournament.TournamentType, curTournament.TournamentState, curTournament.RebuyAllowed, curTournament.AutoRebuy, curTournament.AddonAllowed);

      CheckForStart(curTournament);
    end;
  end;
end;

procedure TTournamentModule.Run_GetPlayers(XMLRoot: IXMLNode);
{
<object name="tournament">
  <togetplayers tournamentid="123" result="0|...">
    <player place="1" userid="345" name="Vasya" city="EarthCore" finished="0|1" value="12435"/>
    ...
  </togetplayers>
</object>
}
var
  ErrorCode: Integer;
  curTournament: TTournamentProcess;
  Loop: Integer;
  XMLNode: IXMLNode;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    curTournament := FindTournament(XMLRoot.Attributes['tournamentid']);
    if curTournament <> nil then
    begin
      curTournament.Players.ClearData(0);
      curTournament.Players.ClearItems(XMLRoot.ChildNodes.Count);
      for Loop := 0 to XMLRoot.ChildNodes.Count -1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        curTournament.Players.AddItem(XMLNode.Attributes['userid'], Loop).LoadFromXML(XMLNode);
        if (XMLNode.HasAttribute('autorebuy')) and (FGetPlayersCount = 0) then
        begin
         if XMLNode.Attributes['userid'] = UserModule.UserID then
         begin
          curTournament.AutoRebuy := XMLNode.Attributes['autorebuy'] = 1;{}
          curTournament.TournamentLobbyForm.UpdateState(curTournament.Name,
                       UserModule.Logged, curTournament.Registered,
                       curTournament.TournamentType, curTournament.TournamentState,
                       curTournament.RebuyAllowed, curTournament.AutoRebuy, curTournament.AddonAllowed);
         end;
        end;
      end;

      if curTournament.Registered then
         FGetPlayersCount := 1;

      curTournament.TournamentLobbyForm.UpdatePlayerList(curTournament.Players);

      CheckForStart(curTournament);
    end;
  end;
end;

procedure TTournamentModule.Run_GetProcesses(XMLRoot: IXMLNode);
{
  <object name="tournament" id="0">
  <togetprocesses tournamentid="59" result="0">
          <process id="3631"
           actiondispatcherid ="1"
           name="Tournament #59 0"
           playerscount="3"
           minstack="1000.00"
           avgstack="1000.00"
           maxstack="1000.00" />

    ...
  </togetprocesses>
</object>
}
var
  ErrorCode: Integer;
  curTournament: TTournamentProcess;
  Loop: Integer;
  XMLNode: IXMLNode;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    curTournament := FindTournament(XMLRoot.Attributes['tournamentid']);
    if curTournament <> nil then
    begin
      curTournament.Tables.ClearData(0);
      curTournament.Tables.ClearItems(XMLRoot.ChildNodes.Count);
      for Loop := 0 to XMLRoot.ChildNodes.Count -1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        curTournament.Tables.AddItem(XMLNode.Attributes['id'], Loop).LoadFromXML(XMLNode);
      end;
      curTournament.Tables.SortItems('name', true, true);
      curTournament.TournamentLobbyForm.UpdateTableList(curTournament.Tables);
      Do_ChooseTable(curTournament.ID, curTournament.CurrentTableID);

      CheckForStart(curTournament);
    end;
  end;
end;

procedure TTournamentModule.Run_GetProcessPlayers(XMLRoot: IXMLNode);
{
<object name="tournament">
  <togetprocessplayers tournamentid="123" processid="543245">
    <player place="1" userid="345" name="Vasya" city="EarthCore" value="12435"/>
    ...
  </togetprocessplayers>
</object>
}
var
  ErrorCode: Integer;
  curTournament: TTournamentProcess;
  Loop: Integer;
  XMLNode: IXMLNode;
  curTable: TDataList;
  curTableID: Integer;
  curUser: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    curTournament := FindTournament(XMLRoot.Attributes['tournamentid']);
    if curTournament <> nil then
    begin
      curTableID := XMLRoot.Attributes['processid'];
      if curTournament.TablePlayers.Find(curTableID, curTable) then
      begin
        curTable.ClearData(0);
        curTable.ClearItems(XMLRoot.ChildNodes.Count);
        for Loop := 0 to XMLRoot.ChildNodes.Count -1 do
        begin
          XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
          curTable.AddItem(XMLNode.Attributes['userid'], Loop).LoadFromXML(XMLNode);
        end;
        curTable.SortItems('value', false, true);
        curTournament.TournamentLobbyForm.UpdateTablePlayerList(curTableID, curTable);

        curTournament.Registered := curTournament.Players.Find(UserModule.UserID, curUser);
        curTournament.TournamentLobbyForm.UpdateState(curTournament.Name,
          UserModule.Logged, curTournament.Registered,
          curTournament.TournamentType, curTournament.TournamentState, curTournament.RebuyAllowed,curTournament.AutoRebuy,curTournament.AddonAllowed);
      end;
      CheckForStart(curTournament);
    end;
  end;
end;

procedure TTournamentModule.Run_Register(XMLRoot: IXMLNode);
{
<object name="tournament">
  <toregister tournamentid="123" result="0|..."/>
</object>
}
var
  ErrorCode: Integer;
  curTournament: TTournamentProcess;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
  begin
    curTournament := FindTournament(XMLRoot.Attributes['tournamentid']);
    if curTournament <> nil then
    begin
      UpdateTournamentData;
      ThemeEngineModule.ShowMessage(cstrTournamentRegistered + curTournament.Name);
      curTournament.Registered := true;
      curTournament.TournamentLobbyForm.UpdateState(curTournament.Name,
        UserModule.Logged, curTournament.Registered,
        curTournament.TournamentType, curTournament.TournamentState,curTournament.RebuyAllowed,curTournament.AutoRebuy, curTournament.AddonAllowed);
    end;
  end
  else
    ThemeEngineModule.ShowWarning(cstrTournamentRegisterFailed);
end;

procedure TTournamentModule.Run_UnRegister(XMLRoot: IXMLNode);
{
<object name="tournament">
  <tounregister tournamentid="123" result="0|..."/>
</object>
}
var
  ErrorCode: Integer;
  curTournament: TTournamentProcess;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
  begin
    curTournament := FindTournament(XMLRoot.Attributes['tournamentid']);
    if curTournament <> nil then
    begin
      UpdateTournamentData;
      ThemeEngineModule.ShowMessage(cstrTournamentUnRegistered + curTournament.Name);
      curTournament.Registered := false;
      curTournament.TournamentLobbyForm.UpdateState(curTournament.Name,
        UserModule.Logged, curTournament.Registered,
        curTournament.TournamentType, curTournament.TournamentState,curTournament.RebuyAllowed,curTournament.AutoRebuy,curTournament.AddonAllowed);
    end;
  end
  else
    ThemeEngineModule.ShowWarning(cstrTournamentRegisterFailed);

end;


procedure TTournamentModule.Run_TournamentEvent(XMLRoot: IXMLNode);
{
<object name="tournament">
  <totournamentevent action="start|changetable"
   msg="Tournament will started in 30 seconds."
   tournamentid="123" tournamentname="Tournament #1234"
   processid="234" processname="1234 4" [oldprocessid="237"]/>
</object>
}
var
  Action: String;
  TournamentID: Integer;
  TournamentName: String;
  ProcessID: Integer;
  OldProcessID: Integer;
  ProcessName: String;
  Msg: String;
  CurTournament: TTournamentProcess;
  ActionDispatcherId: Integer;
  BreakDuration: Integer;
  OldTournamentID: Integer;
begin
  Msg := XMLRoot.Attributes['msg'];

  if XMLRoot.HasAttribute('action') then
    Action := lowercase(XMLRoot.Attributes['action'])
  else
    Action := '';

  if XMLRoot.HasAttribute('tournamentid') then
    TournamentID := strtointdef(XMLRoot.Attributes['tournamentid'], 0)
  else
    TournamentID := 0;
  if XMLRoot.HasAttribute('tournamentname') then
    TournamentName := XMLRoot.Attributes['tournamentname']
  else
    TournamentName := 'Tournament #' + inttostr(TournamentID);

  if XMLRoot.HasAttribute('oldprocessid') then
    OldProcessID := strtointdef(XMLRoot.Attributes['oldprocessid'], 0)
  else
    OldProcessID := 0;
  if XMLRoot.HasAttribute('processid') then
    ProcessID := strtointdef(XMLRoot.Attributes['processid'], 0)
  else
    ProcessID := 0;
  if XMLRoot.HasAttribute('processname') then
    ProcessName := XMLRoot.Attributes['processname']
  else
    ProcessName := inttostr(TournamentID) + ' ' + inttostr(ProcessID);

  if XMLRoot.HasAttribute('actiondispatcherid') then
   ActionDispatcherId := XMLRoot.Attributes['actiondispatcherid']
  else
   ActionDispatcherId := 0;

  if XMLRoot.HasAttribute('oldtournamentid') then
   OldTournamentID := XMLRoot.Attributes['oldtournamentid']
  else
   OldTournamentID := 0;

  if XMLRoot.HasAttribute('breakduration') then
   BreakDuration := XMLRoot.Attributes['breakduration']
  else
   BreakDuration := 0;

  curTournament := FindTournament(TournamentId);

  if Action = 'start' then
  begin
    Logger.Add('TournamentModule.Run_TournamentEvent action is "start"', llBase);
    StartTournament(TournamentID, TournamentName);
    ProcessModule.StartTournamentTable(ProcessID, TournamentID,ActionDispatcherId, TournamentName, ProcessName, BreakDuration);
    //ThemeEngineModule.ShowMessage(Msg);
    //PictureMessageForm.ShowForm(pmTournamentStart,'',0);
    //ProcessModule.Do_TournamentStart(ProcessID,60);
  end;

 if CurTournament <> nil then
 begin
  if Action = 'changetable' then
  begin
    PictureMessageForm.ShowForm(pmChangeTable,'',0);
    Logger.Add('TournamentModule.Run_TournamentEvent action is "changetable"', llBase);
    StartTournament(TournamentID, TournamentName);
    ProcessModule.ChangeTournamentTable(OldProcessID, ProcessID, TournamentID,ActionDispatcherID,
      TournamentName, ProcessName, Msg);
  end;

  if (Action = 'break') and (BreakDuration > 0) then
  begin
    CurTournament.RebuyAllowed := false;
    ProcessModule.Do_BreakStart(ProcessID,Breakduration);
    ProcessModule.UpdateOptions;
  end;

  if Action = 'endbreak' then
    PictureMessageForm.Close;

  if Action = 'finishtournament' then
  begin
   CurTournament.RebuyAllowed := false;
   PictureMessageForm.ShowForm(pmTournamentOver,Msg);{}
  end;

  if Action = 'congratulations' then
   PictureMessageForm.ShowForm(pmPrizeInfo,Msg);

  if Action = 'userlost' then
   ThemeEngineModule.ShowMessage(Msg);
 end;

  if Action = 'autoregistration' then
  begin
   FTournamentID := TournamentID;
   FTournamentName := TournamentName;
   FMsg := Msg;
   
   curTournament := FindTournament(OldTournamentID);
   if curTournament <> nil then
     Do_Finish(OldTournamentID);

   RegisterInfoTimer.Enabled := true;
  end;{}
end;

procedure TTournamentModule.Run_GetLevelsInfo(XMLRoot: IXMLNode);
{
<object name="tournament">
  <togetlevelsinfo result="0|..." tournamentid="123"/>
  <levels>
    <level number="1" blinds="100/200" ante="50" time="10"/>
    ...
  </levels>
  <prizes>
    <prize name="Base Prize">
      <data value="$40">
      ...
    </prize>
  </prizes>
</object>
}
var
  ErrorCode: Integer;
  curTournament: TTournamentProcess;
  Loop, Loop1, Loop3: Integer;
  XMLNode,XMLNode1,XMLChildNode: IXMLNode;
  curLevelsData,curPrizesData, curItem: TDataList;
  TournamentID: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    TournamentID := XMLRoot.Attributes['tournamentid'];
    curTournament := FindTournament(TournamentID);
    if curTournament <> nil then
    begin
     curTournament.StartingChips := XMLRoot.Attributes['startingchips'];
      for Loop1 := 0 to XMLRoot.ChildNodes.Count-1 do
      begin
       XMLNode := XMLRoot.ChildNodes[Loop1];

       //levels
       if XMLNode.NodeName = 'levels' then
       begin
         if not curTournament.TournamentLevels.Find(TournamentID, curLevelsData) then
            curLevelsData := curTournament.TournamentLevels.Add(TournamentID);
         curLevelsData.ClearData(0);
         curLevelsData.ClearItems(XMLNode.ChildNodes.Count);
         for Loop := 0 to XMLNode.ChildNodes.Count-1 do
         begin
           curItem := curLevelsData.AddItem(Loop,Loop);
           XMLChildNode := XMLNode.ChildNodes.Nodes[Loop];
           curItem.ValuesAsString['blinds'] := XMLChildNode.Attributes['blinds'];
           curItem.ValuesAsString['ante'] := XMLChildNode.Attributes['ante'];
           curItem.ValuesAsString['time'] := XMLChildNode.Attributes['time'];
         end;
       end;

        //prizes
       if XMLNode.NodeName = 'prizes' then
       begin
         if not curTournament.TournamentPrizes.Find(TournamentID, curPrizesData) then
              curPrizesData := curTournament.TournamentPrizes.Add(TournamentID);
           for Loop3 := 0 to XMLNode.ChildNodes.Count-1 do
           begin
            XMLNode1 := XMLNode.ChildNodes[Loop3];
           if XMLNode1.HasAttribute('name') then
            if XMLNode1.Attributes['name'] = 'Base Prize' then
            begin
              curPrizesData.ClearData(0);
              curPrizesData.ClearItems(XMLNode1.ChildNodes.Count);
              for Loop := 0 to XMLNode1.ChildNodes.Count-1 do
              begin
                curItem := curPrizesData.AddItem(Loop,Loop);
                XMLChildNode := XMLNode1.ChildNodes.Nodes[Loop];
                curItem.ValuesAsString['value'] := XMLChildNode.Attributes['value'];
              end;
            end;
           end;
       end;
      end;
     curTournament.TournamentLobbyForm.CreateTournamentInfoForm(IntToStr(TournamentID),
                  curTournament.StartingChips,curLevelsData,curPrizesData);
   end;
  end;

end;

procedure TTournamentModule.Run_Rebuy(XMLRoot: IXMLNode);
var
  ErrorCode: Integer;
  curTournament: TTournamentProcess;
begin
  if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
  begin
   if XMLRoot.HasAttribute('tournamentid') then
   begin
    curTournament := FindTournament(XMLRoot.Attributes['tournamentid']);
    if curTournament <> nil then
    begin
     ThemeEngineModule.ShowMessage('You added ' + curTournament.StartingChips + ' chips for tournament.' );
     curTournament.TournamentLobbyForm.EnableAddonButton;
    end;
   end;
  end;
end;

// Start and stop tournament window

procedure TTournamentModule.StartTournament(TournamentID: Integer; AName: String);
var
  newTournament: TTournamentProcess;
begin
  newTournament := FindTournament(TournamentID);
  if newTournament <> nil then
    newTournament.TournamentLobbyForm.StartWork(newTournament.Name,
      UserModule.Logged, newTournament.Registered,
      newTournament.TournamentType, newTournament.TournamentState, newTournament.BuyIn,
      newTournament.RebuyCount, newTournament.RebuyAllowed, newTournament.AutoRebuy, newTournament.AddonAllowed)
  else
    if (FTournamentLimit > 0) and (FTournaments.Count >= FTournamentLimit) then
      ThemeEngineModule.ShowWarning(cstrLimitation + inttostr(FTournamentLimit) + ' tournaments. ' +
        cstrThanks)
    else
    begin
      newTournament := TTournamentProcess.Create(Self, TournamentID, AName);
      newTournament.CurrentState := psLoading;
      ParserModule.Send_GetTournamentLobbyInfo(TournamentID);
      ParserModule.Send_GetTournamentPlayers(TournamentID);
      ParserModule.Send_GetTournamentProcesses(TournamentID);

      FTournaments.AddObject(inttostr(TournamentID), newTournament);
      Logger.Add('TournamentModule.StartTournament ID: ' + inttostr(TournamentID) + ': ' + AName, llBase);
    end;
end;

procedure TTournamentModule.CheckForStart(curTournament: TTournamentProcess);
var
  curUser: TDataList;
begin
  if curTournament.CurrentState = psLoading then
  begin
    curTournament.CurrentCommandReceived := curTournament.CurrentCommandReceived + 1;
    if curTournament.CurrentCommandReceived >= 3 then
    with curTournament do
    begin
      if TakingForm <> nil then
      begin
        TakingForm.Free;
        TakingForm.OnClose := nil;
        TakingForm := nil;
      end;

      CurrentState := psWorking;
      Registered := curTournament.Players.Find(UserModule.UserID, curUser);
      TournamentLobbyForm.StartWork(curTournament.Name,
        UserModule.Logged, Registered,
        TournamentType, TournamentState, curTournament.BuyIn, curTournament.RebuyCount,
        curTournament.RebuyAllowed, curTournament.AutoRebuy, curTournament.AddonAllowed);
      LobbyModule.MinimizeLobby;
      UpdateTimer.Enabled := true;
    end;
  end;
end;

procedure TTournamentModule.StopTournament(TournamentID: Integer);
var
  nInd: Integer;
  curTournament: TTournamentProcess;
begin
  nInd := FTournaments.IndexOf(inttostr(TournamentID));
  if nInd >= 0 then
  begin
    curTournament := FTournaments.Objects[nInd] as TTournamentProcess;
    if curTournament <> nil then
      curTournament.Free;
    FTournaments.Delete(nInd);
  end;

  if FTournaments.Count = 0 then
  begin
    UpdateTimer.Enabled := false;
    if SessionModule.SessionState = poRunning then
      LobbyModule.ShowLobby;
  end;

  Logger.Add('TournamentModule.StopTournament ID: ' + inttostr(TournamentID), llBase);
end;


// Calls from form

procedure TTournamentModule.Do_ChooseTable(TournamentID, ProcessID: Integer);
var
  curTournament: TTournamentProcess;
  curProcess: TDataList;
begin
  curTournament := FindTournament(TournamentID);
  if curTournament <> nil then
  begin
    {if not curTournament.TablePlayers.Find(ProcessID, curProcess) then
      curProcess := curTournament.TablePlayers.Add(ProcessID);{}
    curTournament.CurrentTableID := ProcessID;
    curTournament.TournamentLobbyForm.UpdateTablePlayerList(ProcessID, curTournament.Players);
    //ParserModule.Send_GetTournamentProcessPlayers(TournamentID, ProcessID);
  end;
end;

procedure TTournamentModule.Do_ObserveTable(TournamentID, ProcessID: Integer);
var
  curTournament: TTournamentProcess;
  curProcess: TDataList;
begin
  curTournament := FindTournament(TournamentID);
  if curTournament <> nil then
    if curTournament.Tables.Find(ProcessID, curProcess) then
      ProcessModule.StartTournamentTable(ProcessID, curTournament.ID,
        curProcess.ValuesAsInteger['actiondispatcherid'],
        curTournament.Name,curProcess.ValuesAsString['name']);
end;

procedure TTournamentModule.Do_PlayerDetails(TournamentID,
  UserID: Integer);
var
  curTournament: TTournamentProcess;
  curProcess: TDataList;
  curTable: TDataList;
  curUser: TDataList;
  text: String;
  Loop: Integer;
begin
  curTournament := FindTournament(TournamentID);
  if curTournament <> nil then
    if curTournament.Players.Find(UserID, curUser) then
    begin
      text := 'PlayerID: ' + curUser.ValuesAsString['name'] + #13#10 +
        'City: ' + curUser.ValuesAsString['city'] + #13#10;

      if curUser.ValuesAsString['finished'] = '1' then
        text := text + 'Finished. Place #' + curUser.ValuesAsString['place']
      else
        for Loop := 0 to curTournament.TablePlayers.Count - 1 do
        begin
          curTable := curTournament.TablePlayers.Items(Loop);
          if curTable.Find(UserID, curUser) then
            if curTournament.Tables.Find(curTable.ID, curProcess) then
              text := text + 'Playing in table: ' + curProcess.ValuesAsString['name'] + #13#10 +
                'Money in play: ' + curUser.ValuesAsString['value'];
        end;
      ThemeEngineModule.ShowModalMessage(text);
    end;
end;

procedure TTournamentModule.Do_Register(TournamentID: Integer);
var
  curTournament: TTournamentProcess;
begin
  curTournament := FindTournament(TournamentID);
  if curTournament <> nil then
    if ThemeEngineModule.AskQuestion(cstrTournamentRegister1 + curTournament.Name +
      cstrTournamentRegister2 +
      Conversions.Cur2Str(curTournament.BuyIn + curTournament.Fee, curTournament.CurrencyTypeID)) then
    begin
      if curTournament.TournamentType <> RestrictedTournamentTypeID then
       ParserModule.Send_GetTournamentRegister(TournamentID,'')
      else
       PasswordForm.ShowForm(TournamentID);
    end;
end;

procedure TTournamentModule.Do_Register(TournamentID: Integer;
  Password: String);
begin
    ParserModule.Send_GetTournamentRegister(TournamentID,Password);
end;

procedure TTournamentModule.Do_UnRegister(TournamentID: Integer);
var
  curTournament: TTournamentProcess;
begin
  curTournament := FindTournament(TournamentID);
  if curTournament <> nil then
    ParserModule.Send_GetTournamentUnregister(TournamentID);
end;

procedure TTournamentModule.Do_Login(TournamentID: Integer);
begin
  UserModule.Login;
end;

procedure TTournamentModule.Do_ViewLobby(TournamentID: Integer);
begin
  LobbyModule.ShowLobby;
end;

procedure TTournamentModule.Do_ChooseTournamentInfo(TournamentID: Integer);
begin
  ParserModule.Send_GetTournamentLevelsInfo(TournamentID);
end;

procedure TTournamentModule.StopLoading(ID1, ID2: Integer);
begin
  FinishProcessTimer.Tag := ID1;
  FinishProcessTimer.Enabled := true;
end;

procedure TTournamentModule.Do_Finish(TournamentID: Integer);
var
  curTournament: TTournamentProcess;
begin
  curTournament := FindTournament(TournamentID);
  if curTournament <> nil then
  begin
    curTournament.TournamentLobbyForm.Hide;
    FinishProcessTimer.Tag := TournamentID;
    FinishProcessTimer.Enabled := true;
  end;
end;

procedure TTournamentModule.FinishProcessTimerTimer(Sender: TObject);
begin
  FinishProcessTimer.Enabled := false;
  StopTournament((Sender as TComponent).Tag);
end;


procedure TTournamentModule.UpdateTimerTimer(Sender: TObject);
begin
  if FTournaments.Count > 0 then
    UpdateTournamentData
  else
    UpdateTimer.Enabled := false;
end;

procedure TTournamentModule.UpdateTournamentData;
var
  Loop: Integer;
  curTournament: TTournamentProcess;
begin
  if FTournaments.Count > 0 then
    for Loop := 0 to FTournaments.Count - 1 do
    begin
      curTournament := FTournaments.Objects[Loop] as TTournamentProcess;
      ParserModule.Send_GetTournamentLobbyInfo(curTournament.ID);
      ParserModule.Send_GetTournamentPlayers(curTournament.ID);
      ParserModule.Send_GetTournamentProcesses(curTournament.ID);
      //ParserModule.Send_GetTournamentProcessPlayers(curTournament.ID, curTournament.CurrentTableID);
    end;
end;

procedure TTournamentModule.UpdateLoginState;
var
  Loop: Integer;
  curUser: TDataList;
  curTournament: TTournamentProcess;
begin
  UpdateTournamentData;

  if FTournaments.Count > 0 then
    for Loop := 0 to FTournaments.Count - 1 do
    begin
      curTournament := FTournaments.Objects[Loop] as TTournamentProcess;
      curTournament.Registered := curTournament.Players.Find(UserModule.UserID, curUser);
      curTournament.TournamentLobbyForm.UpdateState(curTournament.Name, UserModule.Logged, curTournament.Registered,
        curTournament.TournamentType, curTournament.TournamentState, curTournament.RebuyAllowed,curTournament.AutoRebuy, curTournament.AddonAllowed);
    end;

end;

procedure TTournamentModule.RegisterInfoTimerTimer(Sender: TObject);
begin
  RegisterInfoTimer.Enabled := false;

  ThemeEngineModule.ShowModalMessage(FMsg);
  StartTournament(FTournamentID,FTournamentName);
end;

procedure TTournamentModule.Do_Addon(TournamentID: Integer; Value: Integer);
begin
  ParserModule.Send_TournamentRebuy(TournamentID, Value);
end;

procedure TTournamentModule.Do_AutoRebuy(TournamentID, Value: Integer);
var
 curTournament: TTournamentProcess;
begin
  curTournament := FindTournament(TournamentID);
  if curTournament <> nil then
  begin
    curTournament.AutoRebuy := Value = 1;
    ParserModule.Send_TournamentAutoRebuy(TournamentID,Value);
  end;
end;


function TTournamentModule.GetTournament(
  TournamentID: Integer): TTournamentProcess;
begin
 Result := FindTournament(TournamentID);
end;

end.
