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
    BuyIn: Currency;
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
    Players: TDataList;
    TournamentLobbyForm: TTournamentLobbyForm;
    TakingForm: TTakingForm;
    CurrentState: TProcessState;
    CurrentCommandReceived: Integer;
    CurrentTableID: Integer;

    constructor Create(AOwner: TComponent; AID: Integer; AName: String);
    destructor  Destroy; override;
  end;

  TTournamentModule = class(TDataModule)
    FinishProcessTimer: TTimer;
    UpdateTimer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FinishProcessTimerTimer(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  private
    FTournaments: TStringList;
    FTournamentLimit: Integer;

    function FindTournament(TournamentID: Integer): TTournamentProcess;
    procedure CheckForStart(curTournament: TTournamentProcess);

    procedure Run_GetInfo(XMLRoot: IXMLNode);
    procedure Run_GetPlayers(XMLRoot: IXMLNode);
    procedure Run_GetProcesses(XMLRoot: IXMLNode);
    procedure Run_GetProcessPlayers(XMLRoot: IXMLNode);
    procedure Run_Register(XMLRoot: IXMLNode);
    procedure Run_TournamentEvent(XMLRoot: IXMLNode);
    procedure UpdateTournamentData;
    procedure SetTournamentLimit(const Value: Integer);
    procedure StopLoading(ID1, ID2: Integer);
  public
    property  TournamentLimit: Integer read FTournamentLimit write SetTournamentLimit;

    procedure StartTournament(TournamentID: Integer; AName: String);
    procedure StopTournament(TournamentID: Integer);
    procedure UpdateLoginState;

    procedure RunCommand(XMLRoot: IXMLNode);

    procedure Do_ViewLobby(TournamentID: Integer);
    procedure Do_Register(TournamentID: Integer);
    procedure Do_Login(TournamentID: Integer);
    procedure Do_ChooseTable(TournamentID, ProcessID: Integer);
    procedure Do_ObserveTable(TournamentID, ProcessID: Integer);
    procedure Do_PlayerDetails(TournamentID, UserID: Integer);
    procedure Do_Finish(TournamentID: Integer);
  end;

var
  TournamentModule: TTournamentModule;

implementation

uses
  uLogger, uConstants, uUserModule, uParserModule, uLobbyModule,
  uConversions, uThemeEngineModule, uSessionModule;

{$R *.dfm}


{ TTournamentProcess }

constructor TTournamentProcess.Create(AOwner: TComponent; AID: Integer; AName: String);
begin
  CurrentState := psNone;

  TakingForm := TTakingForm.CreateParented(0);
  TakingForm.SetOnCloseEvent(TournamentModule.StopLoading, AID, 0);
  if pos('tournament', lowercase(AName)) > 0 then
    TakingForm.StatusLabel.Caption := AName + cstrTournamentLoading
  else
    TakingForm.StatusLabel.Caption := AName + cstrTournamentWord + cstrTournamentLoading;
  TakingForm.Show;

  ID := AID;
  Name := AName;
  TournamentType := 0;
  TournamentState := 0;
  BuyIn := 0;
  Registered := false;
  MainInfo := '';
  AdvancedInfo := '';
  PrizePoolInfo := '';
  PrizesInfo := '';
  CurrentCommandReceived := 0;
  CurrentTableID := 0;
  Tables := TDataList.Create(0, nil);
  TablePlayers := TDataList.Create(0, nil);
  Players := TDataList.Create(0, nil);
  TournamentLobbyForm := TTournamentLobbyForm.CreateParented(0);
  TournamentLobbyForm.ID := AID;
  TournamentLobbyForm.Name := AName;
end;

destructor TTournamentProcess.Destroy;
begin
  Tables.Free;
  TablePlayers.Free;
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
        if strNode = 'totournamentevent' then
          Run_TournamentEvent(XMLNode);

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
        curTournament.TournamentType, curTournament.TournamentState);

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
      end;
      curTournament.TournamentLobbyForm.UpdatePlayerList(curTournament.Players);

      CheckForStart(curTournament);
    end;
  end;
end;

procedure TTournamentModule.Run_GetProcesses(XMLRoot: IXMLNode);
{
<object name="tournament">
  <togetplayerlist tournamentid="123" result="0|...">
    <process id="1" name="Table 1/3" playerscount="12" minstack="1" avgstack="2" maxstack="3"/>
    ...
  </togetplayerlist>
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
          curTournament.TournamentType, curTournament.TournamentState);
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
        curTournament.TournamentType, curTournament.TournamentState);
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

  if Action = 'start' then
  begin
    Logger.Add('TournamentModule.Run_TournamentEvent action is "start"', llBase);
    StartTournament(TournamentID, TournamentName);
    ProcessModule.StartTournamentTable(ProcessID, TournamentID, TournamentName, ProcessName);
    ThemeEngineModule.ShowMessage(Msg);
  end;

  if Action = 'changetable' then
  begin
    Logger.Add('TournamentModule.Run_TournamentEvent action is "changetable"', llBase);
    StartTournament(TournamentID, TournamentName);
    ProcessModule.ChangeTournamentTable(OldProcessID, ProcessID, TournamentID,
      TournamentName, ProcessName, Msg);
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
      newTournament.TournamentType, newTournament.TournamentState)
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
        TournamentType, TournamentState);
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
    if not curTournament.TablePlayers.Find(ProcessID, curProcess) then
      curProcess := curTournament.TablePlayers.Add(ProcessID);
    curTournament.CurrentTableID := ProcessID;
    curTournament.TournamentLobbyForm.UpdateTablePlayerList(ProcessID, curProcess);
    ParserModule.Send_GetTournamentProcessPlayers(TournamentID, ProcessID);
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
        curTournament.Name, curProcess.ValuesAsString['name']);
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
      Conversions.Cur2Str(curTournament.BuyIn, RealMoneyCurrencyID)) then
      ParserModule.Send_GetTournamentRegister(TournamentID, UserModule.UserID);
end;

procedure TTournamentModule.Do_Login(TournamentID: Integer);
begin
  UserModule.Login;
end;

procedure TTournamentModule.Do_ViewLobby(TournamentID: Integer);
begin
  LobbyModule.ShowLobby;
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
      ParserModule.Send_GetTournamentProcessPlayers(curTournament.ID, curTournament.CurrentTableID);
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
        curTournament.TournamentType, curTournament.TournamentState);
    end;

end;


end.
