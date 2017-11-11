unit uBotForm;

interface

uses
  Dialogs, Windows, SysUtils, Forms, XMLDoc, XMLIntF, XMLDom, SyncObjs, Classes, Controls,
  StdCtrls, Spin, ComCtrls, ExtCtrls, Grids
  //
  , uBotProcessor
  , uBotClasses
  ;

type

  TBotForm = class(TForm)
    PanelInfo: TPanel;
    PanelCommonInfo: TPanel;
    SplitterUser: TSplitter;
    Panel1: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    sgUsers: TStringGrid;
    sgChairs: TStringGrid;
    Panel2: TPanel;
    lbQualifyUser: TLabel;
    lbCharacterUser: TLabel;
    cbUserQualify: TComboBox;
    cbUserCharacter: TComboBox;
    TrackBarUserMoney: TTrackBar;
    leUserMoney: TLabeledEdit;
    PanelCheckers: TPanel;
    btAllocateAllWatchers: TButton;
    btLeaveTableAll: TButton;
    btRefresh: TButton;
    Label2: TLabel;
    cbCurrTable: TComboBox;
    btSitDown: TButton;
    btLeaveTableGamer: TButton;
    btLeaveTableWatcher: TButton;
    btSetUpGamer: TButton;
    btSetUpWatcher: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrackBarUserMoneyChange(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
    procedure btSetUpGamerClick(Sender: TObject);
    procedure btSetUpWatcherClick(Sender: TObject);
    procedure cbCurrTableSelect(Sender: TObject);
    procedure btLeaveTableAllClick(Sender: TObject);
    procedure btSitDownClick(Sender: TObject);
    procedure btAllocateAllWatchersClick(Sender: TObject);
    procedure sgChairsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgUsersSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btLeaveTableGamerClick(Sender: TObject);
    procedure btLeaveTableWatcherClick(Sender: TObject);
  private
    FProcessorThread: TBotProcessorThread;
    FResponseThread: TBotResponseThread;
    FRefreshTread: TBotRefreshThread;
    { Private declarations }
    function GetTables: TBotTableList;
    //
    procedure On_sgChairsChange(nIndex: Integer);
    procedure On_sgUsersChange(nIndex: Integer);
    //
    procedure RefreshTables;
    procedure RefreshChairs;
    procedure CreateChairsHead;
    procedure RefreshWatchers;
    procedure CreateWatchersHead;
  protected
    procedure RefreshData(bRefreshTables, bRefreshChairs, bRefreshWatchers: Boolean);
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    property Tables: TBotTableList read GetTables;
    //
    procedure DumpMemory(Level: Integer = 0);
    { functions for define user response; result is responce xml as string }
    function RunCommand(gaActionNode: IXMLNode; UserID: Integer): string; //input gaaction processor
    function BotSitDown: string;
    function BotLeaveTable: string;
    function BotEntry(ProcessName, UserName: string; ProcessID, UserID: Integer): string;
    function BotMoreChips: string;
    procedure BotReconnect(UserID: Integer);
    procedure BotDisconnect(UserID: Integer);
  end;

var
  BotForm: TBotForm;
  CriticalSectionBot,
  CriticalSectionResponse,
  CriticalSectionRefresh: TCriticalSection;

implementation

uses DateUtils, Math
  //
  , uBotConstants
  , uLogger
  , uCommonDataModule
  , uConstants
  ;

{$R *.dfm}

procedure TBotForm.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params do begin
    Style := Style OR WS_SYSMENU AND (NOT WS_MAXIMIZE);
    ExStyle := ExStyle OR WS_EX_APPWINDOW;
    WndParent := HWND_DESKTOP;
  end;
end;

function TBotForm.BotEntry(ProcessName, UserName: string; ProcessID, UserID: Integer): string;
begin
  Result := FProcessorThread.BotEntry(ProcessName, UserName, ProcessID, UserID);
end;

function TBotForm.BotLeaveTable: string;
begin
//  Result := FBotFrame.BotLeaveTable;
end;

function TBotForm.BotMoreChips: string;
begin
//  Result := FBotFrame.BotMoreChips;
end;

function TBotForm.BotSitDown: string;
var
  aTable: TBotTable;
  aChair: TBotChair;
  aUser: TBotUser;
  nProcessID, nHandID, nUserID, nPos, nAmount: Integer;
begin
  CriticalSectionRefresh.Enter;
  try
    if (FRefreshTread.TableIndex < 0) or
       (FRefreshTread.ChairIndex < 0) or
       (FRefreshTread.WatchIndex < 0)
    then Exit;
    nProcessID := StrToIntDef(FRefreshTread.TableList[1].Strings[FRefreshTread.TableIndex], -1);
    nPos       := StrToIntDef(FRefreshTread.ChairList[0].Strings[FRefreshTread.ChairIndex], -1);
    nUserID    := StrToIntDef(FRefreshTread.WatchList[0].Strings[FRefreshTread.WatchIndex], -1);
    nAmount := FRefreshTread.AmountForSitDown;
  finally
    CriticalSectionRefresh.Leave;
  end;

  if (nProcessID <= 0) or (nPos < 0) or (nUserID <= 0) then Exit;

  CriticalSectionBot.Enter;
  try
    aTable := Tables.TableByProcessID(nProcessID);
    if (aTable = nil) then Exit;
    nHandID := aTable.HandID;

    aUser := aTable.Users.UserByID(nUserID);
    if (aUser = nil) then Exit;
    if not (aUser.IsBot and aUser.IsWatcher) then Exit;

    aChair := aTable.Chairs.ChairByPosition(nPos);
    if (aChair = nil) then Exit;
    if (aChair.User <> nil) then Exit;
    if (aChair.ReservationUserID > 0) and (aChair.ReservationUserID <> nUserID) then Exit;

    if (nAmount < aTable.MinBuyIn) or (nAmount > aTable.MaxBuyIn) then
      nAmount := aTable.DefBuyIn;
  finally
    CriticalSectionBot.Leave;
  end;

  Result := FProcessorThread.BotSitDown(nProcessID, nUserID, nHandID, nPos, nAmount/100);
end;

function TBotForm.GetTables: TBotTableList;
begin
  Result := FProcessorThread.Processor.Processes;
end;

function TBotForm.RunCommand(gaActionNode: IXMLNode; UserID: Integer): string;
var
  I: Integer;
  aNode: IXMLNode;
begin
  Logger.Log(UserID, ClassName, 'RunCommand', 'Entry with: ' + gaActionNode.XML, ltCall);
  Result := '';
  if not gaActionNode.HasChildNodes then Exit;

  for I:=0 to gaActionNode.ChildNodes.Count - 1 do begin
    aNode := gaActionNode.ChildNodes[I];
    FProcessorThread.RunCommand(aNode, UserID);
  end;
end;

procedure TBotForm.FormDestroy(Sender: TObject);
//var
//  I, nCountBuffers, nIterations, nMaxIteration: Integer;
//  arrTables: array of Integer;
begin
  FRefreshTread.Terminate;
  FRefreshTread.WaitFor;

{  CriticalSectionBot.Enter;
  try
    SetLength(arrTables, Tables.Count);
    nMaxIteration := Tables.Count * 3;
    for I:=Tables.Count - 1 downto 0 do begin
      arrTables[I] := Tables.Items[I].ProcessID;
    end;
    FProcessorThread.InputActions.Clear;
    FProcessorThread.FuncActions.Clear;
  finally
    CriticalSectionBot.Leave;
  end;

  CriticalSectionResponse.Enter;
  try
    FResponseThread.ImmResponses.Clear;
    FResponseThread.WaitResponses.Clear;
  finally
    CriticalSectionResponse.Leave;
  end;

  for I:=Low(arrTables) to High(arrTables) do begin
    FRefreshTread.LeaveTableAllBots(arrTables[I]);
  end;
  // deallocate array
  SetLength(arrTables, 0);

  nIterations := -1;
  repeat
    Inc(nIterations);

    CriticalSectionResponse.Enter;
    try
      nCountBuffers := FResponseThread.ImmResponses.Count + FResponseThread.WaitResponses.Count;
    finally
      CriticalSectionResponse.Leave;
    end;

    CriticalSectionBot.Enter;
    try
      nCountBuffers := nCountBuffers + FProcessorThread.FuncActions.Count;
    finally
      CriticalSectionBot.Leave;
    end;
    if nCountBuffers <= 0 then Break;
    Sleep(100);
  until nIterations > nMaxIteration;
}
  FRefreshTread.Free;
  FResponseThread.Free;
  FProcessorThread.Free;
end;

procedure TBotForm.FormCreate(Sender: TObject);
begin
  CreateChairsHead;
  CreateWatchersHead;

  FResponseThread  := TBotResponseThread.Create;
  FProcessorThread := TBotProcessorThread.Create(FResponseThread.ImmResponses, FResponseThread.WaitResponses);
  FRefreshTread := TBotRefreshThread.Create(FProcessorThread);
  FRefreshTread.OnRefresh := RefreshData;
end;

procedure TBotForm.FormShow(Sender: TObject);
var
  nTimeOut: Integer;
begin
  nTimeOut := CommonDataModule.SessionSettings.ValuesAsInteger[BotRefreshInterval];
  nTimeOut := IfThen(nTimeOut > 1, 1 - nTimeOut, 0);

  CriticalSectionRefresh.Enter;
  try
    FRefreshTread.NeedCloseForm := False;
    FRefreshTread.EnableRefresh := True;
    FRefreshTread.NeedRefreshTables := False;
    FRefreshTread.NeedRefreshChairs := False;
    FRefreshTread.NeedRefreshWatchers := False;
    FRefreshTread.LastTimeRefresh := IncSecond(Now, nTimeOut);
  finally
    CriticalSectionRefresh.Leave;
  end;
end;

procedure TBotForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FRefreshTread.EnableRefresh := False;
  FRefreshTread.NeedRefreshTables := False;
  FRefreshTread.NeedRefreshChairs := False;
  FRefreshTread.NeedRefreshWatchers := False;
  FRefreshTread.LastTimeRefresh := Now;
end;

procedure TBotForm.BotReconnect(UserID: Integer);
begin
  FProcessorThread.BotReconnect(UserID);
end;

procedure TBotForm.BotDisconnect(UserID: Integer);
begin
  FProcessorThread.BotDisconnect(UserID);
end;


procedure TBotForm.TrackBarUserMoneyChange(Sender: TObject);
begin
  leUserMoney.Text := CurrToStr(TrackBarUserMoney.Position);
end;

procedure TBotForm.RefreshData(bRefreshTables, bRefreshChairs, bRefreshWatchers: Boolean);
begin
  if bRefreshTables and bRefreshChairs and bRefreshWatchers then
    DumpMemory(-1);

  if bRefreshTables then RefreshTables;
  if bRefreshChairs then RefreshChairs;
  if bRefreshWatchers then RefreshWatchers;
  if FRefreshTread.NeedCloseForm then begin
    if Visible then
      Close;
    Exit;
  end;
end;

procedure TBotForm.RefreshTables;
var
  I, nCnt: Integer;
begin
  if FRefreshTread = nil then Exit;
  FRefreshTread.NeedRefreshTables := False;

  nCnt := FRefreshTread.TableList[1].Count;
  while (cbCurrTable.Items.Count < nCnt) do
    cbCurrTable.Items.Add('');
  while (cbCurrTable.Items.Count > nCnt) do
    cbCurrTable.Items.Delete(cbCurrTable.Items.Count-1);

  for I:=0 to nCnt-1 do
    cbCurrTable.Items[I] := FRefreshTread.TableList[0].Strings[I];
  cbCurrTable.ItemIndex := FRefreshTread.TableIndex;
end;

procedure TBotForm.RefreshChairs;
var
  I, J, nCnt: Integer;

  procedure ClearData;
  var
    K: Integer;
  begin
    CreateChairsHead;
    for K:=0 to sgChairs.ColCount - 1 do sgChairs.Cells[K, 1] := '';
  end;
begin
  if FRefreshTread = nil then Exit;
  FRefreshTread.NeedRefreshChairs := False;

  if (FRefreshTread.TableIndex < 0) then begin
    ClearData;
    Exit;
  end;

  nCnt := FRefreshTread.ChairList[0].Count;
  sgChairs.RowCount := Max(nCnt + 1, 2);
  if (sgChairs.RowCount <= 2) then begin
    ClearData;
  end;

  for I:=0 to nCnt-1 do begin
    for J:=Low(FRefreshTread.ChairList) to Min(sgChairs.ColCount-1, High(FRefreshTread.ChairList)) do
      sgChairs.Cells[J, I+1] := FRefreshTread.ChairList[J].Strings[I];
  end;
end;

procedure TBotForm.RefreshWatchers;
var
  I, J, nCnt: Integer;

  procedure ClearData;
  var
    K: Integer;
  begin
    for K:=0 to sgUsers.ColCount - 1 do sgUsers.Cells[K, 1] := '';
  end;
begin
  if FRefreshTread = nil then Exit;
  FRefreshTread.NeedRefreshWatchers := False;

  if (sgUsers.RowCount <= 2) then begin
    ClearData;
  end;

  if (FRefreshTread.TableIndex < 0) then begin
    ClearData;
    Exit;
  end;

  nCnt := FRefreshTread.WatchList[0].Count;
  sgUsers.RowCount := Max(nCnt + 1, 2);
  if (nCnt <= 0) then ClearData;
  for I:=0 to nCnt-1 do begin
    for J:=Low(FRefreshTread.WatchList) to Min(sgUsers.ColCount-1, High(FRefreshTread.WatchList)) do
      sgUsers.Cells[J, I+1] := FRefreshTread.WatchList[J].Strings[I];
  end;
end;

procedure TBotForm.btRefreshClick(Sender: TObject);
begin
  CriticalSectionRefresh.Enter;
  try
    FRefreshTread.NeedRefreshTables   := FRefreshTread.EnableRefresh;
    FRefreshTread.NeedRefreshChairs   := FRefreshTread.EnableRefresh;
    FRefreshTread.NeedRefreshWatchers := FRefreshTread.EnableRefresh;
  finally
    CriticalSectionRefresh.Leave;
  end;
end;

procedure TBotForm.btSetUpGamerClick(Sender: TObject);
var
  aTable: TBotTable;
  aUser: TBotUser;
  aChair: TBotChair;
  nPos, nProcessID: Integer;
begin
  if (FRefreshTread = nil) then Exit;
  CriticalSectionRefresh.Enter;
  try
    if (FRefreshTread.TableIndex < 0) or
       (FRefreshTread.ChairIndex < 0)
    then Exit;
    nProcessID := StrToIntDef(FRefreshTread.TableList[1].Strings[FRefreshTread.TableIndex], -1);
    nPos := StrToIntDef(FRefreshTread.ChairList[0].Strings[FRefreshTread.ChairIndex], -1);
    FRefreshTread.AmountForSitDown := StrToIntDef(leUserMoney.Text, 100) * 100;
  finally
    CriticalSectionRefresh.Leave;
  end;
  if (nProcessID <= 0) or (nPos < 0) then Exit;

  CriticalSectionBot.Enter;
  try
    aTable := Tables.TableByProcessID(nProcessID);
    if (aTable = nil) then Exit;

    aChair := aTable.Chairs.ChairByPosition(nPos);
    if (aChair = nil) then Exit;

    aUser := aChair.User;
    if (aUser = nil) then Exit;
    if not (aUser.IsBot) then Exit;
    aUser.GameQualification := TFixGameQualify(cbUserQualify.ItemIndex);
    aUser.Character         := TFixUserCharacter(cbUserCharacter.ItemIndex);
  finally
    CriticalSectionBot.Leave;
  end;
end;

procedure TBotForm.btSetUpWatcherClick(Sender: TObject);
var
  aTable: TBotTable;
  aUser: TBotUser;
  nUserID, nProcessID: Integer;
begin
  if (FRefreshTread = nil) then Exit;
  CriticalSectionRefresh.Enter;
  try
    if (FRefreshTread.TableIndex < 0) or
       (FRefreshTread.WatchIndex < 0)
    then Exit;
    nProcessID := StrToIntDef(FRefreshTread.TableList[1].Strings[FRefreshTread.TableIndex], -1);
    nUserID := StrToIntDef(FRefreshTread.WatchList[0].Strings[FRefreshTread.WatchIndex], -1);
    FRefreshTread.AmountForSitDown := StrToIntDef(leUserMoney.Text, 100) * 100;
  finally
    CriticalSectionRefresh.Leave;
  end;

  CriticalSectionBot.Enter;
  try
    aTable := Tables.TableByProcessID(nProcessID);
    if (aTable = nil) then Exit;

    aUser := aTable.Users.UserByID(nUserID);
    if (aUser = nil) then Exit;
    if not (aUser.IsBot) then Exit;
    aUser.GameQualification := TFixGameQualify(cbUserQualify.ItemIndex);
    aUser.Character         := TFixUserCharacter(cbUserCharacter.ItemIndex);
  finally
    CriticalSectionBot.Leave;
  end;
end;

procedure TBotForm.cbCurrTableSelect(Sender: TObject);
begin
  CriticalSectionRefresh.Enter;
  try
    FRefreshTread.TableIndex := cbCurrTable.ItemIndex;
  finally
    CriticalSectionRefresh.Leave;
  end;
end;

procedure TBotForm.CreateChairsHead;
begin
  sgChairs.RowCount := 2;

  sgChairs.Cells[0, 0] := 'Pos';
  sgChairs.Cells[1, 0] := 'D';
  sgChairs.Cells[2, 0] := 'Gamer name';
  sgChairs.Cells[3, 0] := 'Ammount';
  sgChairs.Cells[4, 0] := 'Qualify';
  sgChairs.Cells[5, 0] := 'Character';
  sgChairs.Cells[6, 0] := 'Is Bot';
end;

procedure TBotForm.CreateWatchersHead;
begin
  sgUsers.RowCount := 2;

  sgUsers.Cells[0, 0] := 'ID';
  sgUsers.Cells[1, 0] := 'Name';
  sgUsers.Cells[2, 0] := 'Qualify';
  sgUsers.Cells[3, 0] := 'Character';
  sgUsers.Cells[4, 0] := 'Is Bot';
end;

procedure TBotForm.btLeaveTableAllClick(Sender: TObject);
var
  nProcessID: Integer;
begin
  CriticalSectionRefresh.Enter;
  try
    if (FRefreshTread.TableIndex < 0) then Exit;
    nProcessID := StrToIntDef(FRefreshTread.TableList[1].Strings[FRefreshTread.TableIndex], -1);
    FRefreshTread.LeaveTableAllBots(nProcessID);
  finally
    CriticalSectionRefresh.Leave;
  end;
  if nProcessID <= 0 then Exit;
end;

procedure TBotForm.btSitDownClick(Sender: TObject);
begin
  BotSitDown;
end;

procedure TBotForm.btAllocateAllWatchersClick(Sender: TObject);
var
  nProcessID: Integer;
  aTable: TBotTable;
begin
  CriticalSectionRefresh.Enter;
  try
    if (FRefreshTread.TableIndex < 0) then Exit;
    nProcessID := StrToIntDef(FRefreshTread.TableList[1].Strings[FRefreshTread.TableIndex], -1);
  finally
    CriticalSectionRefresh.Leave;
  end;
  if nProcessID <= 0 then Exit;

  CriticalSectionBot.Enter;
  try
    aTable := Tables.TableByProcessID(nProcessID);
    if aTable = nil then Exit;
    { Allacate all by refresh thread }
    aTable.TimeOutForSitDown := IncSecond(Now, -1);
  finally
    CriticalSectionBot.Leave;
  end;
end;

procedure TBotForm.On_sgChairsChange(nIndex: Integer);
begin
  CriticalSectionRefresh.Enter;
  try
    FRefreshTread.ChairIndex := nIndex;
  finally
    CriticalSectionRefresh.Leave;
  end;
end;

procedure TBotForm.sgChairsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if (ARow <> sgChairs.Row) then On_sgChairsChange(ARow - 1);
end;

procedure TBotForm.On_sgUsersChange(nIndex: Integer);
begin
  CriticalSectionRefresh.Enter;
  try
    FRefreshTread.WatchIndex := nIndex;
  finally
    CriticalSectionRefresh.Leave;
  end;
end;

procedure TBotForm.sgUsersSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if (ARow <> sgUsers.Row) then On_sgUsersChange(ARow - 1);
end;

procedure TBotForm.btLeaveTableGamerClick(Sender: TObject);
var
  aTable: TBotTable;
  aUser: TBotUser;
  aChair: TBotChair;
  nUserID, nPos, nProcessID, nHandID: Integer;
begin
  if (FRefreshTread = nil) then Exit;
  CriticalSectionRefresh.Enter;
  try
    if (FRefreshTread.TableIndex < 0) or
       (FRefreshTread.ChairIndex < 0) 
    then Exit;
    nProcessID := StrToIntDef(FRefreshTread.TableList[1].Strings[FRefreshTread.TableIndex], -1);
    nPos := StrToIntDef(FRefreshTread.ChairList[0].Strings[FRefreshTread.ChairIndex], -1);
  finally
    CriticalSectionRefresh.Leave;
  end;
  if (nProcessID <= 0) or (nPos < 0) then Exit;

  CriticalSectionBot.Enter;
  try
    aTable := Tables.TableByProcessID(nProcessID);
    if (aTable = nil) then Exit;
    nHandID := aTable.HandID;

    aChair := aTable.Chairs.ChairByPosition(nPos);
    if (aChair = nil) then Exit;

    aUser := aChair.User;
    if (aUser = nil) then Exit;
    if not (aUser.IsBot) then Exit;
    nUserID := aUser.UserID;
  finally
    CriticalSectionBot.Leave;
  end;

  FProcessorThread.BotLeaveTable(nProcessID, nUserID, nHandID);
end;

procedure TBotForm.btLeaveTableWatcherClick(Sender: TObject);
var
  aTable: TBotTable;
  aUser: TBotUser;
  nUserID, nProcessID, nHandID: Integer;
begin
  if (FRefreshTread = nil) then Exit;
  CriticalSectionRefresh.Enter;
  try
    if (FRefreshTread.TableIndex < 0) or
       (FRefreshTread.WatchIndex < 0)
    then Exit;
    nProcessID := StrToIntDef(FRefreshTread.TableList[1].Strings[FRefreshTread.TableIndex], -1);
    nUserID := StrToIntDef(FRefreshTread.WatchList[0].Strings[FRefreshTread.WatchIndex], -1);
  finally
    CriticalSectionRefresh.Leave;
  end;
  if (nProcessID <= 0) or (nUserID <= 0) then Exit;

  CriticalSectionBot.Enter;
  try
    aTable := Tables.TableByProcessID(nProcessID);
    if (aTable = nil) then Exit;
    nHandID := aTable.HandID;

    aUser := aTable.Users.UserByID(nUserID);
    if (aUser = nil) then Exit;
    if not (aUser.IsBot) then Exit;
  finally
    CriticalSectionBot.Leave;
  end;

  FProcessorThread.BotLeaveTable(nProcessID, nUserID, nHandID);
end;

procedure TBotForm.DumpMemory(Level: Integer);
begin
  Exit;

  CriticalSectionResponse.Enter;
  try
    FResponseThread.DumpMemory(Level + 1);
  finally
    CriticalSectionResponse.Leave;
  end;

  CriticalSectionRefresh.Enter;
  try
    FRefreshTread.DumpMemory(Level + 1);
  finally
    CriticalSectionRefresh.Leave;
  end;

  CriticalSectionBot.Enter;
  try
    FProcessorThread.DumpMemory(Level + 1);
  finally
    CriticalSectionBot.Leave;
  end;
end;

initialization
  CriticalSectionBot      := TCriticalSection.Create;
  CriticalSectionResponse := TCriticalSection.Create;
  CriticalSectionRefresh  := TCriticalSection.Create;

finalization
  CriticalSectionBot.Free;
  CriticalSectionResponse.Free;
  CriticalSectionRefresh.Free;

end.
