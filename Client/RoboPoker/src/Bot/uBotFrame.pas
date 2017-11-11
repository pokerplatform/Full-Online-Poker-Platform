unit uBotFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, XMLDoc, XMLIntF, XMLDom,
  ComCtrls, Contnrs, SyncObjs
//
  , uBotProcessor
  , uBotClasses
  , uBotConstants
  , uBotActions, Spin
  ;

type

  TVisualizationResponse = procedure (
    sResponse: string; aVisualType: TFixVisualizationType; aActionType: TFixAction;
    Process: TBotTable = nil; aUser: TBotUser = nil
  ) of object;

  TBotResponse = class
  private
    FXML: string;
    FTable: TBotTable;
    FUser: TBotUser;
    FActionType: TFixAction;
    FVisualizationType: TFixVisualizationType;
    FDateEntry: TDateTime;
    procedure SetActionType(const Value: TFixAction);
    procedure SetXML(const Value: string);
    procedure SetVisualizationType(const Value: TFixVisualizationType);
    procedure SetDateEntry(const Value: TDateTime);
  public
    property XML: string read FXML write SetXML;
    property VisualizationType: TFixVisualizationType read FVisualizationType write SetVisualizationType;
    property ActionType: TFixAction read FActionType write SetActionType;
    property DateEntry: TDateTime read FDateEntry write SetDateEntry;
    property Table: TBotTable read FTable;
    property User: TBotUser read FUser;
    //
    constructor Create;
    destructor Destroy; override;
  end;

  TBotResponseList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TBotResponse;
  public
    property Items[nIndex: Integer]: TBotResponse read GetItems;
    //
    function Add(strXML: string; aVisualType: TFixVisualizationType; aActionType: TFixAction;
      DateEntry: TDateTime; aTable: TBotTable; aUser: TBotUser): TBotResponse;
    procedure Del(aItem: TBotResponse);
    function Find(aVisualType: TFixVisualizationType; aTable: TBotTable; aUser: TBotUser): TBotResponse;
    function FindByAllType(aVisualType: TFixVisualizationType; aActionType: TFixAction; aTable: TBotTable; aUser: TBotUser): TBotResponse;
    //
    procedure Clear; override;
    constructor Create;
    destructor Destroy; override;
  end;

  TBotFrame = class(TFrame)
    PanelInfo: TPanel;
    PanelTableInfo: TPanel;
    PanelCommonInfo: TPanel;
    PanelCheckers: TPanel;
    PanelTables: TPanel;
    sgTables: TStringGrid;
    GrBoxTablesFilter: TGroupBox;
    ComboBoxPokerType: TComboBox;
    ComboBoxStakeType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    lbTableID: TLabel;
    lbTableName: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lbTableType: TLabel;
    Label7: TLabel;
    lbTableCurrencySign: TLabel;
    Label6: TLabel;
    lbTableStakeType: TLabel;
    Label9: TLabel;
    lbTableUseAllIn: TLabel;
    Label10: TLabel;
    lbTableMinBuyIn: TLabel;
    lbTableMaxBuyIn: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lbTableDefBuyIn: TLabel;
    Label8: TLabel;
    lbTableTournamentType: TLabel;
    lbTableHandID: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lbTablePrevHandID: TLabel;
    Label15: TLabel;
    lbTableRound: TLabel;
    Label16: TLabel;
    lbTableRake: TLabel;
    Label20: TLabel;
    lbTableCards: TLabel;
    MemoTablePots: TMemo;
    Panel1: TPanel;
    sgUsers: TStringGrid;
    Label17: TLabel;
    Label18: TLabel;
    sgChairs: TStringGrid;
    Panel2: TPanel;
    SplitterUser: TSplitter;
    lbAvalableActionsUser: TLabel;
    lbUserButtons: TListBox;
    Label21: TLabel;
    lbUserID: TLabel;
    Label23: TLabel;
    lbUserName: TLabel;
    Label25: TLabel;
    lbUserPosition: TLabel;
    Label27: TLabel;
    lbUserState: TLabel;
    Label29: TLabel;
    lbUserInGame: TLabel;
    Label31: TLabel;
    lbUserAmmount: TLabel;
    Label33: TLabel;
    lbUserBetsAmmount: TLabel;
    Label22: TLabel;
    lbUserIsBot: TLabel;
    Label26: TLabel;
    lbUserLastAction: TLabel;
    Label30: TLabel;
    lbUserCards: TLabel;
    lbQualifyUser: TLabel;
    lbCharacterUser: TLabel;
    cbUserQualify: TComboBox;
    cbUserCharacter: TComboBox;
    grbChat: TGroupBox;
    TrackBarUserMoney: TTrackBar;
    leUserMoney: TLabeledEdit;
    btExecuteAction: TButton;
    cbUseCustomBotAnswer: TCheckBox;
    btAllocateAllWatchers: TButton;
    leChatEnter: TLabeledEdit;
    cbChatFilter: TComboBox;
    Label19: TLabel;
    MemoChat: TMemo;
    TimerAnswer: TTimer;
    pbTimeLimit: TProgressBar;
    btLeaveTableAll: TButton;
    seWaitOnResponse: TSpinEdit;
    Label24: TLabel;
    procedure sgTablesClick(Sender: TObject);
    procedure ComboBoxPokerTypeChange(Sender: TObject);
    procedure ComboBoxStakeTypeChange(Sender: TObject);
    procedure TrackBarUserMoneyChange(Sender: TObject);
    procedure sgUsersClick(Sender: TObject);
    procedure cbUserQualifyChange(Sender: TObject);
    procedure cbUserCharacterChange(Sender: TObject);
    procedure btExecuteActionClick(Sender: TObject);
    procedure sgChairsClick(Sender: TObject);
    procedure btAllocateAllWatchersClick(Sender: TObject);
    procedure sgChairsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgUsersEnter(Sender: TObject);
    procedure sgChairsEnter(Sender: TObject);
    procedure sgUsersDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbChatFilterChange(Sender: TObject);
    procedure leChatEnterKeyPress(Sender: TObject; var Key: Char);
    procedure cbUseCustomBotAnswerClick(Sender: TObject);
    procedure TimerAnswerTimer(Sender: TObject);
    procedure btLeaveTableAllClick(Sender: TObject);
  private
    { Private declarations }
    FProcessor: TBotProcessor;
    FCurrTable: TBotTable;
    FCurrChair: TBotChair;
    FCurrWatch: TBotUser;
    FCurrGamer: TBotUser;
    FChairsFocused: Boolean;
    FCloseAfterCommand: Boolean;
    // visualization
    FOnVisualizationCommand: TVisualizationCommands;
    FOnVisualizationResponse: TVisualizationResponse;
    FOnVisualizationButtons: TVisualizationButtons;
    FResponses: TBotResponseList;
    FNeedRefresh: Boolean;
    procedure SetResponses(const Value: TBotResponseList);
    function GetFirstEmptyChair: TBotChair;
    //
    procedure SetOnVisualizationCommand(const Value: TVisualizationCommands);
    procedure SetOnOnVisualizationResponse(const Value: TVisualizationResponse);
    procedure SetOnVisualizationButtons(const Value: TVisualizationButtons);
    //
    function GetTables: TBotTableList;
    procedure SetCurrTable(const Value: TBotTable);
    function GetCurrUser: TBotUser;
    //
    procedure ClearCurrTable;
    procedure RefreshCurrTable;
    procedure RefreshCurrChair;
    procedure ClearCurrUser;
    procedure RefreshButtons(aUser: TBotUser);
    procedure RefreshPots;
    procedure RefreshCurrUser(aUser: TBotUser; bRefreshButtons: Boolean);

    // for frame only
    procedure OnResponse(sResponse: string; aType: TFixVisualizationType; aActionType: TFixAction;
      DateEntry: TDateTime; Process: TBotTable; User: TBotUser);
    procedure OnCommand(aNode: IXMLNode; aType: TFixVisualizationType;
      Process: TBotTable; User: TBotUser);
    function OnButtons(aButtons: TBotAvailableAnswerList; aUser: TBotUser;
      ActiveButton: TBotAvailableAnswer): TBotAvailableAnswer;
    function GetFormOwner: TForm;
    procedure SetNeedRefresh(const Value: Boolean);
  public
    { Public declarations }
    property Responses: TBotResponseList read FResponses write SetResponses;
    property Processor: TBotProcessor read FProcessor;
    property Tables: TBotTableList read GetTables;
    property CurrTable: TBotTable read FCurrTable write SetCurrTable;
    property CurrChair: TBotChair read FCurrChair;
    property CurrUser: TBotUser read GetCurrUser;
    property FormOwner: TForm read GetFormOwner;
    property NeedRefresh: Boolean read FNeedRefresh write SetNeedRefresh;
    //
    property OnVisualizationCommand: TVisualizationCommands read FOnVisualizationCommand write SetOnVisualizationCommand;
    property OnVisualizationResponse: TVisualizationResponse read FOnVisualizationResponse write SetOnOnVisualizationResponse;
    property OnVisualizationButtons: TVisualizationButtons read FOnVisualizationButtons write SetOnVisualizationButtons;
    //
    procedure RefreshTables;
    procedure RefreshChairs;
    procedure RefreshWatchers;
    //
    { functions for define user response; result is xml responce as string }
    function RunCommand(gaActionNode: IXMLNode; UserID: Integer): string; //input gaaction processor
    function BotSitDown: string;
    function BotLeaveTable: string;
    function BotEntry(ProcessName, UserName: string; ProcessID, UserID: Integer): string;
    function BotMoreChips: string;
    function BotReconnect(UserID: Integer): string;
    function BotDisconnect(UserID: Integer): string;
    //
    procedure SetEventFrameFunctionsToNil;
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  CriticalSectionFrame: TCriticalSection;

implementation

uses StrUtils
//
  , uLogger, DateUtils;

{$R *.dfm}

{ TBotResponse }

constructor TBotResponse.Create;
begin
  inherited Create;
  FTable := nil;
  FUser  := nil;
end;

destructor TBotResponse.Destroy;
begin
  FTable := nil;
  FUser  := nil;
  inherited;
end;

procedure TBotResponse.SetActionType(const Value: TFixAction);
begin
  FActionType := Value;
end;

procedure TBotResponse.SetXML(const Value: string);
begin
  FXML := Value;
end;

procedure TBotResponse.SetVisualizationType(
  const Value: TFixVisualizationType);
begin
  FVisualizationType := Value;
end;

procedure TBotResponse.SetDateEntry(const Value: TDateTime);
begin
  FDateEntry := Value;
end;

{ TBotResponseList }

function TBotResponseList.Add(strXML: string;
  aVisualType: TFixVisualizationType; aActionType: TFixAction;
  DateEntry: TDateTime; aTable: TBotTable; aUser: TBotUser): TBotResponse;
begin
  Result := nil;
  if (aTable = nil) or (aUser = nil) then Exit;

  Result := FindByAllType(aVisualType, aActionType, aTable, aUser);
  if (Result <> nil) then Exit;

  Result := TBotResponse.Create;

  Result.FXML := strXML;
  Result.FVisualizationType := aVisualType;
  Result.FActionType := aActionType;
  Result.DateEntry := DateEntry;
  Result.FTable := aTable;
  Result.FUser  := aUser;

  inherited Add(Result as TObject);
end;

procedure TBotResponseList.Clear;
var
  I: Integer;
  aItm: TBotResponse;
begin
  { FTable & FUser can not be reliased }
  for I:=0 to Count - 1 do begin
    aItm := Items[I];
    aItm.FTable := nil;
    aItm.FUser  := nil;
  end;

  inherited;
end;

constructor TBotResponseList.Create;
begin
  inherited Create;
end;

procedure TBotResponseList.Del(aItem: TBotResponse);
begin
  if (aItem <> nil) then begin
    aItem.FTable := nil;
    aItem.FUser  := nil;
  end;

  inherited Remove(aItem);
end;

destructor TBotResponseList.Destroy;
var
  I: Integer;
  aItem: TBotResponse;
begin
  for I:=0 to Count - 1 do begin
    aItem := Items[I];
    aItem.FTable := nil;
    aItem.FUser  := nil;
  end;

  Clear;

  inherited;
end;

function TBotResponseList.Find(aVisualType: TFixVisualizationType;
  aTable: TBotTable; aUser: TBotUser): TBotResponse;
var
  I: Integer;
  aItm: TBotResponse;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aItm := Items[I];
    if (aItm.FVisualizationType = aVisualType) and
       (aItm.FTable             = aTable     ) and
       (aItm.FUser              = aUser      )
    then begin
      Result := aItm;
      Exit;
    end;
  end;
end;

function TBotResponseList.FindByAllType(aVisualType: TFixVisualizationType;
  aActionType: TFixAction; aTable: TBotTable;
  aUser: TBotUser): TBotResponse;
var
  I: Integer;
  aItm: TBotResponse;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aItm := Items[I];
    if (aItm.FVisualizationType = aVisualType) and
       (aItm.FActionType        = aActionType) and
       (aItm.FTable             = aTable     ) and
       (aItm.FUser              = aUser      )
    then begin
      Result := aItm;
      Exit;
    end;
  end;
end;

function TBotResponseList.GetItems(nIndex: Integer): TBotResponse;
begin
  Result := inherited Items[nIndex] as TBotResponse;
end;

{ TBotFrame }

constructor TBotFrame.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FProcessor := TBotProcessor.Create;
  FResponses := TBotResponseList.Create;

  FProcessor.Processes.OnVisualizationCommand  := OnCommand;
  FProcessor.Processes.OnEntryResponse := OnResponse;
  FProcessor.Processes.OnVisualizationButtons  := OnButtons;

  FCloseAfterCommand := True;

  FOnVisualizationCommand    := nil;
  FOnVisualizationResponse := nil;
  FOnVisualizationButtons    := nil;

  CurrTable := nil;
  FCurrChair := nil;
  FCurrWatch := nil;
  FCurrGamer := nil;
  FChairsFocused := True;
  FNeedRefresh := True;

  ClearCurrTable;
  ClearCurrUser;
end;

destructor TBotFrame.Destroy;
begin
  TimerAnswer.Enabled := False;

  FOnVisualizationCommand    := nil;
  FOnVisualizationResponse := nil;
  FOnVisualizationButtons    := nil;

  FCurrTable := nil;
  FCurrChair := nil;
  FCurrWatch := nil;
  FCurrGamer := nil;

  FProcessor.Free;
  FResponses.Free;

  inherited;
end;

function TBotFrame.GetTables: TBotTableList;
begin
  Result := FProcessor.Processes;
end;

procedure TBotFrame.OnResponse(sResponse: string;
  aType: TFixVisualizationType; aActionType: TFixAction;
  DateEntry: TDateTime; Process: TBotTable; User: TBotUser);
var
  I: Integer;
  aRsp: TBotResponse;
begin
  if ((Process = nil) or (User = nil)) and (sResponse <> '') then begin
    Logger.Log(-1, ClassName, 'OnResponse',
      '[Error]: Try send not empty XML when Process or User is nil. ' +
        'Parameters: XML=[' + sResponse + '], Type=' + GetFixVisualizationTypeAsString(aType) + ', ' +
        'Action=' + GetFixActionAsString(aActionType),
      ltError
    );
    Exit;
  end;

  { add to all list of resposes }
  if (aType in [VST_PROCINIT, VST_PROCSTATE]) or
     ( (aType = VST_ACTION) and
       (aActionType in [ACT_MORECHIPS, ACT_LEAVETABLE, ACT_SITDOWN, ACT_SITOUTNEXTHAND])
     )
  then begin
    { Visualization response }
    if (sResponse <> '') and Assigned(FOnVisualizationResponse) then
      FOnVisualizationResponse(sResponse, aType, aActionType, Process, User);

    if (aActionType = ACT_LEAVETABLE) then begin
      { Clear All Responses for User }
      TimerAnswer.Enabled := False;
      CriticalSectionFrame.Enter;
      I:=0;
      while I < FResponses.Count do begin
        aRsp := FResponses.Items[I];
        if (aRsp.FUser = User) then
          FResponses.Del(aRsp)
        else
          Inc(I);
      end;
      CriticalSectionFrame.Leave;
      TimerAnswer.Enabled := True;

//      User.Users.Del(User);
    end;
  end else begin
    { set answer of bots }
    if (aType = VST_ACTION) then begin
      if (Process = nil) or (User = nil) then begin
        Logger.Log(-1, ClassName, 'OnResponse',
          '[Error]: Try send action answer when Process or user is nil. ' +
            'Parameters: XML=[' + sResponse + '], Type=' + GetFixVisualizationTypeAsString(aType) + ', ' +
            'Action=' + GetFixActionAsString(aActionType),
          ltError
        );
        Exit;
      end else begin
        Logger.Log(User.UserID, ClassName, 'OnResponse',
          'Response action will be added to buffer; ' +
            'Parameters: XML=[' + sResponse + '], Type=' + GetFixVisualizationTypeAsString(aType) + ', ' +
            'Action=' + GetFixActionAsString(aActionType),
          ltCall
        );
      end;
    end;
    CriticalSectionFrame.Enter;
    FResponses.Add(sResponse, aType, aActionType, DateEntry, Process, User);
    CriticalSectionFrame.Leave;
  end;
end;

procedure TBotFrame.RefreshCurrTable;
var
  nID: Integer;
begin
  if not NeedRefresh then Exit;

  ClearCurrTable;
  btExecuteAction.Enabled := cbUseCustomBotAnswer.Checked;

  nID := StrToIntDef(sgTables.Cells[1, sgTables.Row], -1);
  CurrTable := Tables.TableByProcessID(nID);
  if (CurrTable = nil) then begin
    if FChairsFocused then begin
      RefreshWatchers;
      RefreshChairs;
    end else begin
      RefreshChairs;
      RefreshWatchers;
    end;
    Exit;
  end;

  with FCurrTable do begin
    lbTableID.Caption := IntToStr(ProcessID);
    lbTableName.Caption := Name;
    lbTableType.Caption := GameTypeName;
    lbTableCurrencySign.Caption := CurrencySign;
    lbTableStakeType.Caption := StakeTypeName;
    lbTableUseAllIn.Caption := IfThen(AllIn, 'True', 'False');
    lbTableMinBuyIn.Caption := CurrToStr(MinBuyIn / 100);
    lbTableMaxBuyIn.Caption := CurrToStr(MaxBuyIn / 100);
    lbTableDefBuyIn.Caption := CurrToStr(DefBuyIn / 100);
    lbTableTournamentType.Caption := TournamentTypeName;
    lbTableHandID.Caption := IntToStr(HandID);
    lbTablePrevHandID.Caption := IntToStr(PrevHandID);
    lbTableRound.Caption := IntToStr(Round);
    lbTableRake.Caption := CurrToStr(Rake / 100);
    lbTableCards.Caption := Cards.CardNames;
  end;

  if FChairsFocused then begin
    RefreshWatchers;
    RefreshChairs;
  end else begin
    RefreshChairs;
    RefreshWatchers;
  end;
end;

procedure TBotFrame.RefreshTables;
var
  I, nRow, nCnt: Integer;
  aTable: TBotTable;
begin
  if not NeedRefresh then Exit;

  sgTables.Cells[0, 0] := 'Name';
  sgTables.Cells[1, 0] := 'ID';

  for I:=0 to sgTables.ColCount - 1 do sgTables.Cells[I, 1] := '';

  nRow := 1;
  nCnt := 0;
  if Tables.Count > 0 then begin
    for I:=1 to Tables.Count do begin
      aTable := Tables.Items[I-1];
      { filters }
      if (ComboBoxPokerType.ItemIndex <> 0) then begin
        if ( (Integer(aTable.GameType) + 1) <> ComboBoxPokerType.ItemIndex ) then Continue;
      end;
      if (ComboBoxStakeType.ItemIndex <> 0) then begin
        if ( (Integer(aTable.StakeType) + 1) <> ComboBoxStakeType.ItemIndex ) then Continue;
      end;

      Inc(nCnt);
      sgTables.RowCount := nCnt + 1;

      sgTables.Cells[0, nCnt] := aTable.Name;
      sgTables.Cells[1, nCnt] := IntToStr(aTable.ProcessID);
      if (aTable = FCurrTable) then nRow := nCnt;
    end;
    if (nCnt = 0) then sgTables.RowCount := 2;
  end else begin
    sgTables.RowCount := 2;
  end;

  sgTables.Row := nRow;

  RefreshCurrTable;
end;

procedure TBotFrame.sgTablesClick(Sender: TObject);
var
  nID: Integer;
begin
  if Tables.Count <= 0 then Exit;
  if (sgTables.RowCount = 2) and (sgTables.Cells[1, 1] = '') then Exit;

  nID := StrToIntDef(sgTables.Cells[1, sgTables.Row], -1);
  CurrTable := Tables.TableByProcessID(nID);
  if (FCurrTable = nil) then Exit;
  RefreshCurrTable;
end;

procedure TBotFrame.ComboBoxPokerTypeChange(Sender: TObject);
begin
  RefreshTables;
end;

procedure TBotFrame.ComboBoxStakeTypeChange(Sender: TObject);
begin
  RefreshTables;
end;

procedure TBotFrame.SetCurrTable(const Value: TBotTable);
begin
  if (FCurrTable <> Value) then begin
    if (FCurrTable <> nil) then FCurrTable.CustomAnswer := False;
    FCurrChair := nil;
    FCurrWatch := nil;
    FCurrGamer := nil;
  end;
  FCurrTable := Value;
  if (FCurrTable <> nil) then begin
    cbUseCustomBotAnswer.Checked := FCurrTable.CustomAnswer;
    cbUseCustomBotAnswer.Visible := True;
  end else begin
    cbUseCustomBotAnswer.Checked := False;
    cbUseCustomBotAnswer.Visible := False;
  end;
end;

procedure TBotFrame.RefreshChairs;
var
  I, nRow: Integer;
  aChair: TBotChair;
  aUser: TBotUser;
begin
  if not NeedRefresh then Exit;

  sgChairs.Cells[0, 0] := 'Pos';
  sgChairs.Cells[1, 0] := 'Gamer';
  sgChairs.Cells[2, 0] := 'D';
  sgChairs.Cells[3, 0] := 'Ammount';
  sgChairs.Cells[4, 0] := 'Cards';

  for I:=0 to sgChairs.ColCount - 1 do sgChairs.Cells[I, 1] := '';
  if (FCurrTable = nil) then begin
    sgChairs.RowCount := 2;
    FCurrChair := nil;

    RefreshCurrChair;

    Exit;
  end;

  nRow := 1;
  if (FCurrTable.Chairs.Count > 0) then
    sgChairs.RowCount := FCurrTable.Chairs.Count + 1
  else
    sgChairs.RowCount := 2;

  if (FCurrTable.Chairs.Count > 0) then begin
    for I:=1 to FCurrTable.Chairs.Count do begin
      aChair := FCurrTable.Chairs.Items[I-1];
      aUser  := aChair.User;

      sgChairs.Cells[0, I] := IntToStr(aChair.Position);
      sgChairs.Cells[2, I] := IfThen(aChair.IsDialer > 0, 'D', '');
      sgChairs.Cells[4, I] := '';

      if (aUser = nil) then begin
        sgChairs.Cells[1, I] := 'Empty';
        sgChairs.Cells[3, I] := '';
      end else begin
        sgChairs.Cells[1, I] := aUser.Name;
        sgChairs.Cells[3, I] := CurrToStr(aUser.CurrAmmount/100);
        if (aUser.Cards.Count > 0) then begin
          if FCurrTable.Cards.Count > 0 then
            sgChairs.Cells[4, I] :=
              aUser.Cards.CardNames + ';     ' + FCurrTable.Cards.CardNames
          else
            sgChairs.Cells[4, I] := aUser.Cards.CardNames;
        end;
      end;
      if (aChair = FCurrChair) then nRow := I;
    end;
  end else begin
    sgChairs.RowCount := 2;
  end;

  sgChairs.Row := nRow;

  if FChairsFocused then RefreshCurrChair;
end;

procedure TBotFrame.RefreshCurrChair;
var
  aGamer: TBotUser;
begin
 if not NeedRefresh then Exit;

 if (FCurrTable = nil) then begin
    FCurrChair := nil;
    FCurrWatch := nil;
    FCurrGamer := nil;
    ClearCurrUser;

    Exit;
  end;

  if (FCurrChair = nil) then begin
    FCurrGamer  := nil;
    RefreshCurrUser(nil, False);
    Exit;
  end;

  aGamer := FCurrChair.User;
  RefreshCurrUser(aGamer, False);
  FCurrGamer := aGamer;
end;

procedure TBotFrame.RefreshCurrUser(aUser: TBotUser; bRefreshButtons: Boolean);
var
  nMoney: Integer;
  aFixChatSrc, aFixChatPriority: TFixChatSet;
begin
  if not NeedRefresh then Exit;

  if (aUser = nil) then begin
    ClearCurrUser;
    Exit;
  end;

  if bRefreshButtons then begin
    if FChairsFocused and (lbUserButtons.Count > 2) then
      RefreshButtons(aUser)
    else
      if (aUser = FCurrWatch) then RefreshButtons(aUser);
  end;

  with aUser do begin
    cbUserQualify.Visible := IsBot;
    cbUserCharacter.Visible := IsBot;
    lbQualifyUser.Visible := IsBot;
    lbCharacterUser.Visible := IsBot;
    leUserMoney.Visible := IsBot;
    leUserMoney.EditLabel.Caption := IfThen(IsWatcher, 'Money (Sit Down)', 'Money (More Chips)');
    grbChat.Visible := IsBot;

    TrackBarUserMoney.Visible := IsBot;
    TrackBarUserMoney.Min := Trunc( FCurrTable.MinBuyIn / 100 );
    TrackBarUserMoney.Max := Trunc( FCurrTable.MaxBuyIn / 100 );
    nMoney := Trunc( StrToCurrDef(leUserMoney.Text, FCurrTable.DefBuyIn / 100));
    TrackBarUserMoney.Position := nMoney;

    lbUserID.Caption := IntToStr(UserID);
    lbUserName.Caption := Name;
    lbUserPosition.Caption := IntToStr(Position);
    lbUserState.Caption := NameOfState;
    lbUserInGame.Caption := IfThen((InGame < 1), 'False', 'True');
    lbUserAmmount.Caption := CurrToStr(CurrAmmount / 100);;
    lbUserBetsAmmount.Caption := CurrToStr(BetsAmmount / 100);
    lbUserIsBot.Caption := IfThen(IsBot, 'True', 'False');
    lbUserLastAction.Caption := GetFixActionAsString(LastAction);
    lbUserCards.Caption := Cards.CardNames;

    cbUserQualify.ItemIndex := Integer(GameQualification);
    cbUserCharacter.ItemIndex := Integer(Character);

    case cbChatFilter.ItemIndex of
      0:
      begin
        aFixChatSrc := [Chat0, Chat1, Chat2];
        aFixChatPriority := [Chat0, Chat1, Chat2];
      end;
      1:
      begin
        aFixChatSrc := [Chat0, Chat1, Chat2];
        aFixChatPriority := [Chat0, Chat1];
      end;
      2:
      begin
        aFixChatSrc := [Chat0, Chat1, Chat2];
        aFixChatPriority := [Chat0];
      end;
      3:
      begin
        aFixChatSrc := [Chat0, Chat1];
        aFixChatPriority := [Chat0, Chat1, Chat2];
      end;
    else
      begin
        aFixChatSrc := [];
        aFixChatPriority := [];
      end;
    end;

    MemoChat.Lines.Text := Chats.GetItemsAsText(aFixChatSrc, aFixChatPriority);
    MemoChat.SelStart := Length(MemoChat.Text) - 1;
    MemoChat.SelLength := 0;
  end;
end;

procedure TBotFrame.ClearCurrUser;
var
  I: Integer;
begin
  { set default captions }
  for I:=0 to ComponentCount - 1 do begin
    if (Copy(Components[I].Name, 1, 6) = 'lbUser') then
      if (Components[I].ClassType = TLabel) then
        (Components[I] as TLabel).Caption := '...';
  end;

  cbUserQualify.Visible := False;
  cbUserCharacter.Visible := False;
  lbQualifyUser.Visible := False;
  lbCharacterUser.Visible := False;
  lbAvalableActionsUser.Visible := False;
  leUserMoney.Visible := False;
  TrackBarUserMoney.Visible := False;
  pbTimeLimit.Visible := False;

  lbUserButtons.Clear;
  lbUserButtons.Visible := False;
  btExecuteAction.Visible := False;

  grbChat.Visible := False;
  MemoChat.Clear;
end;

procedure TBotFrame.ClearCurrTable;
var
  I: Integer;
begin
  { set default captions }
  for I:=0 to ComponentCount - 1 do begin
    if (Copy(Components[I].Name, 1, 7) = 'lbTable') then
      if (Components[I].ClassType = TLabel) then
        (Components[I] as TLabel).Caption := '...';
  end;
end;

procedure TBotFrame.TrackBarUserMoneyChange(Sender: TObject);
begin
  leUserMoney.Text := CurrToStr(TrackBarUserMoney.Position);
end;

procedure TBotFrame.RefreshWatchers;
var
  I, nRow, nCnt: Integer;
  aUser: TBotUser;
begin
  if not NeedRefresh then Exit;

  sgUsers.Cells[0, 0]  := 'ID';
  sgUsers.Cells[1, 0] := 'Name';
  sgUsers.Cells[2, 0] := 'Qualify';
  sgUsers.Cells[3, 0] := 'Character';

  for I:=0 to sgUsers.ColCount - 1 do sgUsers.Cells[I, 1] := '';
  if (FCurrTable = nil) then begin
    sgUsers.RowCount := 2;
    FCurrWatch := nil;
    FCurrGamer := nil;

    RefreshCurrUser(nil, False);

    Exit;
  end;


  nRow := 1;
  nCnt := 0;

  if (FCurrTable.Users.CountOfBotWatchers > 0) then begin
    for I:=1 to FCurrTable.Users.Count do begin
      aUser  := FCurrTable.Users.Items[I-1];
      if not aUser.IsWatcher then Continue;

      Inc(nCnt);
      sgUsers.RowCount := nCnt + 1;

      sgUsers.Cells[0, nCnt] := IntToStr(aUser.UserID);// aTable.Name;
      sgUsers.Cells[1, nCnt] := aUser.Name;
      sgUsers.Cells[2, nCnt] := aUser.NameOfQualification;
      sgUsers.Cells[3, nCnt] := aUser.NameOfCharacter;

      if (aUser = FCurrWatch) then nRow := nCnt;
    end;
  end else begin
    sgUsers.RowCount := 2;
    FCurrWatch := nil;
  end;

  sgUsers.Row := nRow;

  if not FChairsFocused then begin
    FCurrWatch := FCurrTable.Users.UserByID(StrToIntDef(sgUsers.Cells[0, nRow], -1));
    RefreshCurrUser(FCurrWatch, False);
  end;
end;

procedure TBotFrame.sgUsersClick(Sender: TObject);
var
  nID: Integer;
  aUser: TBotUser;
begin
  FCurrWatch := nil;
  if (Tables.Count <= 0) or
     ((sgTables.RowCount = 2) and (sgTables.Cells[1, 1] = '')) or
     (FCurrTable = nil) or
     ((sgUsers.RowCount = 2) and (sgUsers.Cells[0, 1] = ''))
  then begin
    RefreshCurrUser(nil, False);
    Exit;
  end;
  if (FCurrTable.Users.Count <= 0) then begin
    RefreshCurrUser(nil, False);
    Exit;
  end;

  nID := StrToIntDef(sgUsers.Cells[0, sgUsers.Row], -1);
  aUser := FCurrTable.Users.UserByID(nID);
  FCurrWatch := aUser;
  if not FChairsFocused then RefreshCurrUser(aUser, True);
end;

procedure TBotFrame.cbUserQualifyChange(Sender: TObject);
begin
  if (CurrUser = nil) then Exit;
  CurrUser.GameQualification := TFixGameQualify(cbUserQualify.ItemIndex);
  if FChairsFocused then
    RefreshChairs
  else
    RefreshWatchers;
end;

procedure TBotFrame.cbUserCharacterChange(Sender: TObject);
begin
  if (CurrUser = nil) then Exit;
  CurrUser.Character := TFixUserCharacter(cbUserCharacter.ItemIndex);
  if FChairsFocused then
    RefreshChairs
  else
    RefreshWatchers;
end;

function TBotFrame.BotEntry(ProcessName, UserName: string; ProcessID, UserID: Integer): string;
var
  bNeedRefreshTables: Boolean;
begin
  FCloseAfterCommand := True;

  bNeedRefreshTables := (FCurrTable = nil) or (Tables.TableByProcessID(ProcessID) = nil);
  Result := FProcessor.BotEntry(ProcessName, UserName, ProcessID, UserID);
  if bNeedRefreshTables then
    RefreshTables
  else
    RefreshWatchers;
end;

function TBotFrame.BotLeaveTable: string;
begin
  if (FCurrTable = nil) then Exit;
  if (CurrUser   = nil) then Exit;
  if not CurrUser.IsBot then Exit;

  Result := FProcessor.BotLeaveTable(FCurrTable.ProcessID, CurrUser.UserID);
  if FChairsFocused then begin
    FCurrGamer := nil;
    RefreshChairs;
  end else begin
    FCurrWatch := nil;
    RefreshWatchers;
  end;
  RefreshCurrUser(CurrUser, True);
end;

function TBotFrame.BotMoreChips: string;
var
  nAmmount: Currency;
begin
  if (FCurrTable = nil) then Exit;
  if (FCurrChair = nil) then Exit;
  FCurrGamer := FCurrChair.User;
  if (FCurrGamer = nil) then Exit;
  if not FCurrGamer.IsBot then Exit;

  nAmmount := StrToCurrDef(leUserMoney.Text, FCurrTable.DefBuyIn/100);
  if ((nAmmount * 100 + FCurrGamer.CurrAmmount) > FCurrTable.MaxBuyIn) then
    nAmmount := FCurrTable.MaxBuyIn - FCurrGamer.CurrAmmount;
  Result := FProcessor.BotMoreChips(FCurrTable.ProcessID, FCurrGamer.UserID, nAmmount);

  RefreshCurrUser(CurrUser, False);
end;

function TBotFrame.BotSitDown: string;
var
  nAmmount: Currency;
begin
  if (FCurrTable = nil) then Exit;
  if (FCurrWatch = nil) then Exit;
  if not (FCurrWatch.IsBot and FCurrWatch.IsWatcher) then Exit;
  if (FCurrChair = nil) then Exit;
  if (FCurrChair.User <> nil) then Exit;

  nAmmount := StrToCurrDef(leUserMoney.Text, FCurrTable.DefBuyIn/100);
  Result := FProcessor.BotSitDown(FCurrTable.ProcessID, FCurrWatch.UserID, FCurrChair.Position, nAmmount);

  RefreshWatchers;
  RefreshChairs;
  RefreshCurrUser(CurrUser, True);
end;

function TBotFrame.RunCommand(gaActionNode: IXMLNode; UserID: Integer): string;
begin
  Result := FProcessor.RunCommand(gaActionNode, UserID);
  RefreshCurrTable;
end;

procedure TBotFrame.btExecuteActionClick(Sender: TObject);
var
  sName: string;
  aActType: TFixAction;
  nInd: Integer;
  strXML: string;
  aButton: TBotAvailableAnswer;
  bFoundCommand: Boolean;

  function DeleteAllStoredCommands: Boolean;
  var
    aResp: TBotResponse;
  begin
    CriticalSectionFrame.Enter;
    Result := False;
    repeat
      aResp := FResponses.Find(VST_ACTION, FCurrTable, FCurrGamer);
      if (aResp <> nil) then begin
        Result := True;
        FResponses.Del(aResp);
      end;
    until (aResp = nil);
    CriticalSectionFrame.Leave;
  end;
begin
  if (FCurrTable = nil) then Exit;
  if (lbUserButtons.Count <= 0) then Exit;
  if not (lbUserButtons.ItemIndex in [0..(lbUserButtons.Count-1)]) then Exit;

  nInd := lbUserButtons.ItemIndex;
  sName := lbUserButtons.Items[nInd];
  aActType := ACT_UNKNOWN;
  if (sName = 'Sit Down')    then begin
    aActType := ACT_SITDOWN;
    DeleteAllStoredCommands;
    BotSitDown;
  end else if (sName = 'Leave Table') then begin
    aActType := ACT_LEAVETABLE;
    DeleteAllStoredCommands;
    BotLeaveTable;
  end else if (sName = 'More Chips') then begin
    aActType := ACT_MORECHIPS;
    BotMoreChips;
  end;

  if (aActType = ACT_UNKNOWN) then begin
    aButton := nil;
    if (FCurrGamer.AvailableAnwers.Count > 0) and
       (nInd in [0..(FCurrGamer.AvailableAnwers.Count-1)])
    then begin
      aButton := FCurrGamer.AvailableAnwers.Items[nInd];
      aActType := aButton.AnswerType;
    end;

    strXML := '';
    if (aButton <> nil) then
      strXML := FCurrTable.GetActionNodeByAnswerButton(aButton);

    if (strXML <> '') then begin
      bFoundCommand := DeleteAllStoredCommands;
      { extern call response }
      if bFoundCommand and Assigned(OnVisualizationResponse) then begin
        FOnVisualizationResponse(strXML, VST_ACTION, aActType, FCurrTable, FCurrGamer);
      end;
    end;
  end;

  RefreshCurrTable;
end;

function TBotFrame.GetCurrUser: TBotUser;
begin
  if FChairsFocused then
    Result := FCurrGamer
  else
    Result := FCurrWatch;

{  if (FCurrGamer = nil) then
    Result := FCurrWatch
  else
    Result := FCurrGamer;}
end;

procedure TBotFrame.sgChairsClick(Sender: TObject);
var
  nPos: Integer;
  aChair: TBotChair;
begin
  FCurrGamer := nil;
  FCurrChair := nil;
  if (Tables.Count <= 0) or
     ((sgTables.RowCount = 2) and (sgTables.Cells[1, 1] = '')) or
     (sgChairs.RowCount = 2) and (sgChairs.Cells[0, 1] = '')
  then begin
    RefreshCurrUser(nil, False);
    Exit;
  end;
  if (FCurrTable = nil) then begin
    RefreshCurrUser(nil, False);
    Exit;
  end;

  nPos := StrToIntDef(sgChairs.Cells[0, sgChairs.Row], -1);
  aChair := FCurrTable.Chairs.ChairByPosition(nPos);
  if (aChair = nil) then begin;
    RefreshCurrUser(nil, False);
    Exit;
  end;

  if FChairsFocused then RefreshCurrUser(aChair.User, (aChair <> FCurrChair));
  FCurrChair := aChair;
  FCurrGamer := FCurrChair.User;
end;

procedure TBotFrame.btAllocateAllWatchersClick(Sender: TObject);
var
  aUser: TBotUser;
  aChair: TBotChair;
  I: Integer;
  nAmount: Currency;
begin
  if (FCurrTable = nil) then Exit;
  for I:=0 to FCurrTable.Users.Count - 1 do begin
    aUser := FCurrTable.Users.Items[I];
    if not (aUser.IsBot and aUser.IsWatcher) then Continue;

    aChair := GetFirstEmptyChair;
    if (aChair = nil) then begin
      RefreshCurrTable;
      Exit;
    end;

    FCurrChair := aChair;
    FCurrWatch := aUser;

    nAmount := StrToCurrDef(leUserMoney.Text, FCurrTable.DefBuyIn/100);
    FProcessor.BotSitDown(FCurrTable.ProcessID, FCurrWatch.UserID, FCurrChair.Position, nAmount);
  end;

  RefreshCurrTable;
  if FChairsFocused then
    RefreshWatchers
  else
    RefreshChairs;
end;

procedure TBotFrame.SetOnVisualizationCommand(
  const Value: TVisualizationCommands);
begin
  FOnVisualizationCommand := Value;
end;

procedure TBotFrame.SetOnOnVisualizationResponse(const Value: TVisualizationResponse);
begin
  FOnVisualizationResponse := Value;
end;

procedure TBotFrame.OnCommand(aNode: IXMLNode; aType: TFixVisualizationType; Process: TBotTable; User: TBotUser);
var
  aChair: TBotChair;
  aTable: TBotTable;
begin
  if (User <> nil) and (Process <> nil) then
    Logger.Log(User.UserID, ClassName, 'OnCommand',
      'Command was resived: UserID=' + IntToStr(User.UserID) +
        '; ProcessID=' + IntToStr(Process.ProcessID) + '; XML=[' + aNode.XML + ']',
      ltCall
    );
{
  if (aType = VST_GACRASH) then begin
    CriticalSectionFrame.Enter;

    aTable := FCurrTable;
    FCurrTable := Process;

    btLeaveTableAll.Click;

    FCurrTable := aTable;

    CriticalSectionFrame.Leave;
  end;
}
  if (Process <> nil) then begin
    if (Process.Users.CountOfBots <= 0) then begin
      CriticalSectionFrame.Enter;

      Tables.Remove(Process);
      CurrTable := nil;
      FCurrChair := nil;
      FCurrWatch := nil;
      FCurrGamer := nil;
      if (Tables.Count <= 0) then begin
        if FCloseAfterCommand then
          (Owner as TForm).Close
        else
          FCloseAfterCommand := True;
      end else begin
        RefreshTables;
      end;

      CriticalSectionFrame.Leave;

      Exit;
    end;
  end;

  if (aType = VST_PROCSTATE) and (User <> nil) then begin
    if (Process.Chairs.Count > Process.Chairs.CountOfBuzy) and
       (Process.Users.CountOfBotWatchers > 0) and User.AutoSitDown
    then begin
      CriticalSectionFrame.Enter;

      aTable := FCurrTable;
      FCurrTable := Process;

      btAllocateAllWatchers.Click;

      FCurrTable := aTable;

      CriticalSectionFrame.Leave;
    end;
  end;

  if (FCurrTable = Process) then begin
    case aType of
      VST_SETACTIVEPLAYER:
      begin
        if (Process = nil) or (User = nil) then begin
          Logger.Log(-1, ClassName, 'OnCommand',
            '[Error] For SetActivePlayer command: OnCommand was called with nil parameter (Table or User)',
            ltError);
        end else begin
          aChair := User.Chair;
          if (FCurrGamer <> User) and (aChair <> nil) and (FCurrTable = Process) then begin
            pbTimeLimit.Visible := User.IsBot and FChairsFocused and FNeedRefresh;
            if pbTimeLimit.Visible then begin
              pbTimeLimit.Max      := aChair.TurnTime;
              pbTimeLimit.Position := pbTimeLimit.Max;
            end;
            FCurrChair := aChair;
            RefreshChairs;
          end;
        end;
      end;
      VST_ACTION, VST_PROCCLOSE: if FChairsFocused then RefreshChairs;
      VST_COMMUNITYCARDS, VST_DEALCARDS: RefreshCurrTable;
      VST_PROCINIT, VST_PROCSTATE:
      begin
        RefreshTables;
      end;
      VST_POTS, VST_MOVEBETS: RefreshPots;
      VST_FINISHHAND:
      begin
        RefreshPots;
        RefreshCurrTable;
      end;
    end;
  end;

  { recall extern vizualization }
  if Assigned(FOnVisualizationCommand) then
    FOnVisualizationCommand(aNode, aType, Process, User);
end;

function TBotFrame.OnButtons(aButtons: TBotAvailableAnswerList; aUser: TBotUser;
  ActiveButton: TBotAvailableAnswer): TBotAvailableAnswer;
var
  nInd: Integer;
begin
  Result := ActiveButton;

  if (aButtons = nil) then
    Logger.Log(-1, ClassName, 'OnButtons', '[ERROR]: Parameter aButton is nil.', ltError);
  if (aUser = nil) then Exit;

  if (aUser = CurrUser) then RefreshButtons(aUser);

  if not (ActiveButton = nil) and (aButtons.Count > 0) and (aUser = CurrUser) then begin
    nInd := aUser.AvailableAnwers.IndexByType(ActiveButton.AnswerType);
    if (nInd >= 0) and FNeedRefresh then lbUserButtons.ItemIndex := nInd;
  end;

  { recall extern vizualization }
  if Assigned(FOnVisualizationButtons) then
    FOnVisualizationButtons(aButtons, aUser);
end;

procedure TBotFrame.SetOnVisualizationButtons(const Value: TVisualizationButtons);
begin
  FOnVisualizationButtons := Value;
end;

procedure TBotFrame.sgChairsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (gdSelected in State) then begin
    if not FChairsFocused then begin
      sgChairs.Canvas.Brush.Color := cl3DLight;
      sgChairs.Canvas.Font.Color := clBlack;
    end;
    sgChairs.Canvas.FillRect(Rect);
    sgChairs.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, sgChairs.Cells[ACol, ARow]);
  end;
end;

procedure TBotFrame.sgUsersEnter(Sender: TObject);
begin
  FChairsFocused := False;
  RefreshChairs;
{  if (FCurrWatch = nil) then
    RefreshWatchers
  else
    RefreshCurrUser(FCurrWatch, True);}
end;

procedure TBotFrame.sgChairsEnter(Sender: TObject);
begin
  FChairsFocused := True;
  RefreshWatchers;
  if (FCurrChair = nil) then begin
    RefreshCurrChair;
  end else if (FCurrChair.User = nil) then begin
    RefreshCurrChair;
  end;
end;

procedure TBotFrame.sgUsersDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (gdSelected in State) then begin
    if FChairsFocused then begin
      sgUsers.Canvas.Brush.Color := cl3DLight;
      sgUsers.Canvas.Font.Color := clBlack;
    end;
    sgUsers.Canvas.FillRect(Rect);
    sgUsers.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, sgUsers.Cells[ACol, ARow]);
  end;
end;

procedure TBotFrame.cbChatFilterChange(Sender: TObject);
begin
  if (FCurrTable = nil) then Exit;
  if FChairsFocused and (FCurrChair.User = nil) then Exit;
  if not FChairsFocused and (FCurrWatch = nil) then Exit;

  if FChairsFocused then
    RefreshCurrUser(FCurrChair.User, False)
  else
    RefreshCurrUser(FCurrWatch, False);
end;

procedure TBotFrame.leChatEnterKeyPress(Sender: TObject; var Key: Char);
var
  sText: string;
  aUser: TBotUser;
begin
  if not (Key in [#8,#13,#32..#127]) then Key := #0;
  if Key in ['<', '>', '"'] then Key := #0;

  if (Key = #0) then Exit;
  if (Key = #13) and (leChatEnter.Text <> '') then begin
    if Assigned(FOnVisualizationResponse) then begin
      if (FCurrTable = nil) then Exit;
      if FChairsFocused then
        aUser := FCurrChair.User
      else
        aUser := FCurrWatch;
      if (aUser = nil) then Exit;

      sText :=
        '<chat src="2" priority="0" msg="' + leChatEnter.Text +
          '" userid="' + IntToStr(aUser.UserID) +
          '" username="' + aUser.Name +
        '"/>';
      sText :=
        GetGaActionOpenNodeAsString(FCurrTable.ProcessID) +
          sText +
        GetGaActionCloseNodeAsString;
      FOnVisualizationResponse(sText, VST_CHAT, ACT_UNKNOWN, FCurrTable, aUser);
      leChatEnter.Text := '';
    end;
  end;
end;

procedure TBotFrame.cbUseCustomBotAnswerClick(Sender: TObject);
begin
  btExecuteAction.Enabled := cbUseCustomBotAnswer.Checked and cbUseCustomBotAnswer.Visible;
  if (FCurrTable <> nil) then FCurrTable.CustomAnswer := cbUseCustomBotAnswer.Checked;
end;

procedure TBotFrame.TimerAnswerTimer(Sender: TObject);
var
  aResponse, aRespForDel: TBotResponse;
  I, J: Integer;
  nSecWait: Integer;
  aTable, aMemCurrTable: TBotTable;
begin
  CriticalSectionFrame.Enter;
  I := 0;
  while I < FResponses.Count do begin
    aResponse := FResponses.Items[I];

    if aResponse.FTable.CustomAnswer then
      nSecWait := 20
    else
      nSecWait := seWaitOnResponse.Value;

    if (aResponse.FUser = CurrUser) and FChairsFocused then begin
      if pbTimeLimit.Visible then begin
        pbTimeLimit.Position := pbTimeLimit.Max - SecondsBetween(aResponse.FDateEntry, Now);
      end;
    end;

    if (IncSecond(aResponse.FDateEntry, nSecWait) <= Now) then begin
      if (aResponse.FUser <> nil) then begin
        aResponse.FUser.AvailableAnwers.Clear;
        if (aResponse.FUser = CurrUser) and FChairsFocused then begin
          RefreshButtons(CurrUser);
          pbTimeLimit.Visible := False;
          pbTimeLimit.Position := pbTimeLimit.Max;
        end;

        { recall extern vizualization }
        Logger.Log(aResponse.FUser.UserID, ClassName, 'TimerAnswerTimer',
          'Command was sending to gameadapter: UserID=' + IntToStr(aResponse.FUser.UserID) + '; XML=[' + aResponse.FXML + ']',
          ltCall
        );
        if Assigned(FOnVisualizationResponse) then begin
          FOnVisualizationResponse(
            aResponse.FXML, aResponse.FVisualizationType,
            aResponse.FActionType, aResponse.FTable, aResponse.FUser
          );
        end;
      end;

      { delete showdown any response for current user }
      if (aResponse.FActionType in [ACT_DONTSHOW, ACT_MUCK, ACT_SHOWSHUFFLED, ACT_SHOW]) then begin
        for J:=FResponses.Count - 1 to 0 do begin
          aRespForDel := FResponses.Items[J];
          if (aResponse.FUser = aRespForDel.FUser) and
             (aRespForDel.FActionType in [ACT_DONTSHOW, ACT_MUCK, ACT_SHOWSHUFFLED, ACT_SHOW])
          then begin
            FResponses.Del(aRespForDel);
          end;
        end;
      end;
      FResponses.Del(aResponse);
    end else begin
      Inc(I);
    end;
  end;

  CriticalSectionFrame.Leave;

  { Check on time out for sitdown and last time activity}
  for I:=0 to Tables.Count - 1 do begin
    aTable := Tables.Items[I];

    if (Now >= IncSecond(aTable.LastTimeActivity, TIME_OUT_FORACTIVITY)) then begin
      aTable.PerformStandUpAllBots(True);
      aTable.LastTimeActivity  := Now;
      aTable.TimeOutForSitDown := Now;
    end;

    if (Now < aTable.TimeOutForSitDown) then Continue;
    aTable.TimeOutForSitDown := IncSecond(Now, TIME_OUT_FORSITDOWN);

    if aTable.CustomAnswer then Continue;
    if (aTable.Users.CountOfBotWatchers <= 0) or
       (aTable.Chairs.CountOfBuzy >= aTable.Chairs.Count)
    then Continue;

    aMemCurrTable := FCurrTable;
    FCurrTable := aTable;

    btAllocateAllWatchers.Click;

    FCurrTable := aMemCurrTable;
  end;

//  if (Tables.Count <= 0) then (Owner as TForm).Close;
end;

procedure TBotFrame.SetResponses(const Value: TBotResponseList);
begin
  FResponses := Value;
end;

procedure TBotFrame.RefreshButtons(aUser: TBotUser);
var
  I: Integer;

  procedure SetNotVisible;
  begin
    lbUserButtons.Visible := False;
    lbAvalableActionsUser.Visible := False;
    btExecuteAction.Visible := False;
  end;
begin
  if not FNeedRefresh then Exit;

  lbUserButtons.Clear;
  if (aUser = nil) then begin SetNotVisible; Exit; end;
  if not aUser.IsBot then begin SetNotVisible; Exit; end;

//  aChair := aUser.Chair;

//  pbTimeLimit.Visible := aUser.IsBot and (aChair <> nil);
//  if pbTimeLimit.Visible then pbTimeLimit.Max := aChair.TurnTime;

  lbUserButtons.Visible := aUser.IsBot;
  btExecuteAction.Visible := aUser.IsBot;
  lbAvalableActionsUser.Visible := aUser.IsBot;

  for I:=0 to aUser.AvailableAnwers.Count - 1 do begin
    lbUserButtons.Items.Add(aUser.AvailableAnwers.Items[I].Name);
  end;
  if aUser.IsWatcher then begin
    lbUserButtons.Items.Add('Sit Down');
  end else begin
    lbUserButtons.Items.Add('More Chips');
  end;
  lbUserButtons.Items.Add('Leave Table');
//  lbUserButtons.ItemIndex := 0;
end;

procedure TBotFrame.btLeaveTableAllClick(Sender: TObject);
var
  I, nProcessID: Integer;
  aUser: TBotUser;
  aRsp: TBotResponse;
begin
  if (FCurrTable = nil) then Exit;

  FCloseAfterCommand := False;

  TimerAnswer.Enabled := False;
  CriticalSectionFrame.Enter;
  I:=0;
  while I < FResponses.Count do begin
    aRsp := FResponses.Items[I];
    if (aRsp.FTable = FCurrTable) then
      FResponses.Del(aRsp)
    else
      Inc(I);
  end;
  CriticalSectionFrame.Leave;
  TimerAnswer.Enabled := True;

  nProcessID := FCurrTable.ProcessID;
  I:=0;
  while I < FCurrTable.Users.Count do begin
    if (FCurrTable.ProcessID <> nProcessID) then Break;
    aUser := FCurrTable.Users.Items[I];
    if not aUser.IsBot then Continue;

    FProcessor.BotLeaveTable(nProcessID, aUser.UserID);
    if FCloseAfterCommand then Break;
  end;

  if FCloseAfterCommand then begin
    (Owner as TForm).Close
  end else begin
    FCloseAfterCommand := True;
    RefreshTables;
  end;
end;

function TBotFrame.BotReconnect(UserID: Integer): string;
var
  aTable: TBotTable;
  aUser: TBotUser;
  I: Integer;
begin
  { on reconnect user }
  for I:=0 to Tables.Count - 1 do begin
    aTable := Tables.Items[I];
    aUser  := aTable.Users.UserByID(UserID);
    if (aUser <> nil) then begin
      if not aUser.IsBot then Continue;
      BotEntry(aTable.Name, aUser.Name, aTable.ProcessID, UserID);
    end;
  end;
end;

procedure TBotFrame.RefreshPots;
var
  I: Integer;
begin
  if not NeedRefresh then Exit;

  { refresh pots memo }
  MemoTablePots.Clear;
  MemoTablePots.Lines.Add('Pots:');
  if (FCurrTable = nil) then Exit;
  with FCurrTable.Pots do begin
    for I:=0 to Count - 1 do MemoTablePots.Lines.Add(IntToStr(I) + ':' + #9 + CurrToStr(Items[I].Amount / 100))
  end;
end;

function TBotFrame.BotDisconnect(UserID: Integer): string;
var
  aTable: TBotTable;
  aUser: TBotUser;
  I: Integer;
begin
  { on disconnect user }
  for I:=0 to Tables.Count - 1 do begin
    aTable := Tables.Items[I];
    aUser  := aTable.Users.UserByID(UserID);
    if (aUser <> nil) then begin
      if not aUser.IsBot then Continue;
      aUser.Connected := False;
    end;
  end;
end;

function TBotFrame.GetFormOwner: TForm;
begin
  Result := nil;
  if (Owner <> nil) then Result := (Owner as TForm);
end;

procedure TBotFrame.SetNeedRefresh(const Value: Boolean);
begin
  FNeedRefresh := Value;
end;

procedure TBotFrame.SetEventFrameFunctionsToNil;
begin

end;

function TBotFrame.GetFirstEmptyChair: TBotChair;
var
  nCnt: Integer;
  aCh: TBotChair;
begin
  Result := nil;
  if (FCurrTable = nil) then Exit;

  for nCnt:=0 to FCurrTable.Chairs.Count - 1 do begin
    aCh := FCurrTable.Chairs.Items[nCnt];
    if (aCh.User = nil) then begin
      Result := aCh;
      Exit;
    end;
  end;
end;

initialization
  CriticalSectionFrame := TCriticalSection.Create;

finalization
  CriticalSectionFrame.Free;

end.
