unit uProcessStatisticsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls, Menus;

type
  TProcessStatisticsForm = class(TForm)
    StatisticsPopupMenu: TTePopupMenu;
    PreserveStatisticsItem: TTeItem;
    ResetStatisticsItem: TTeItem;
    StatisticsLoggingItem: TTeItem;
    AlwaysOnTopItem: TTeItem;
    CustomItem5: TTeItem;
    SaveToClipboardItem: TTeItem;
    CustomItem1: TTeItem;
    TeHeaderPanel1: TTeHeaderPanel;
    SessionStartNameLabel: TTeLabel;
    SessionGamesNameLabel: TTeLabel;
    SessionGamesLabel: TTeLabel;
    SessionStartLabel: TTeLabel;
    ResetButton: TTeButton;
    TeHeaderPanel2: TTeHeaderPanel;
    WinFlopsSeenValueLabel: TTeLabel;
    FlopsSeenNameLabel: TTeLabel;
    WinFlopsSeenNameLabel: TTeLabel;
    FlopsSeenValueLabel: TTeLabel;
    TeHeaderPanel3: TTeHeaderPanel;
    GamesWonNameLabel: TTeLabel;
    ShowdownsWonNameLabel: TTeLabel;
    GamesWonLabel: TTeLabel;
    ShowdownsWonLabel: TTeLabel;
    TeHeaderPanel4: TTeHeaderPanel;
    WhereYouFoldLabel: TTeLabel;
    StatsName1Label: TTeLabel;
    StatsValue1Label: TTeLabel;
    StatsName2Label: TTeLabel;
    StatsValue2Label: TTeLabel;
    StatsName3Label: TTeLabel;
    StatsValue3Label: TTeLabel;
    StatsName4Label: TTeLabel;
    StatsValue4Label: TTeLabel;
    StatsName5Label: TTeLabel;
    StatsValue5Label: TTeLabel;
    StatsName6Label: TTeLabel;
    StatsValue6Label: TTeLabel;
    TeHeaderPanel5: TTeHeaderPanel;
    YourActionsLabel: TTeLabel;
    FoldNameLabel: TTeLabel;
    FoldLabel: TTeLabel;
    CheckNameLabel: TTeLabel;
    CheckLabel: TTeLabel;
    CallNameLabel: TTeLabel;
    CallLabel: TTeLabel;
    BetNameLabel: TTeLabel;
    BetLabel: TTeLabel;
    RaiseNameLabel: TTeLabel;
    RaiseLabel: TTeLabel;
    ReRaiseNameLabel: TTeLabel;
    ReRaiseLabel: TTeLabel;
    CustomItem2: TTeItem;
    ChangeGameTimer: TTimer;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure BackgroundPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ResetStatisticsItemClick(Sender: TObject);
    procedure SaveToClipboardItemClick(Sender: TObject);
    procedure AlwaysOnTopItemClick(Sender: TObject);
    procedure PreserveStatisticsItemClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure StatisticsLoggingItemClick(Sender: TObject);
    procedure ChangeGameTimerTimer(Sender: TObject);
  private
    procedure OnProcessStatsShow;
    procedure OnProcessStatsUpdate;
    procedure ProcessStatsUpdate;
    function GetFoldLabel(Index, labeltype: Integer): TTeLabel;
    procedure GameMenuItemClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ProcessStatisticsForm: TProcessStatisticsForm;

implementation

uses
  Clipbrd,
  uLogger,
  uProcessModule,
  uConstants,
  uDataList,
  uThemeEngineModule, uSessionModule;

{$R *.dfm}

procedure TProcessStatisticsForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Statistics';
  ThemeEngineModule.FormsChangeConstraints(Self,  300, 185);

  ProcessModule.OnProcessStatsShow := OnProcessStatsShow;
  ProcessModule.OnProcessStatsUpdate := OnProcessStatsUpdate;
end;

procedure TProcessStatisticsForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TProcessStatisticsForm.FormDestroy(Sender: TObject);
begin
  ProcessModule.OnProcessStatsShow := nil;
  ProcessModule.OnProcessStatsUpdate := nil;
end;


procedure TProcessStatisticsForm.OnProcessStatsShow;
begin
  ProcessStatsUpdate;
  AlwaysOnTopItem.Checked := SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsOnTop];
  //TeForm.StayOnTop := AlwaysOnTopItem.Checked;
  PreserveStatisticsItem.Checked := SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsPreserve];
  StatisticsLoggingItem.Checked := SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessLogging];
  if not Visible then
  begin
    Left := 0;
    Top := 0;
  end;

  Show;
end;

procedure TProcessStatisticsForm.OnProcessStatsUpdate;
begin
  if Visible then
    ProcessStatsUpdate;
end;

procedure TProcessStatisticsForm.ProcessStatsUpdate;
var
  ActionsEmpty: Boolean;
  FoldEmpty: Boolean;

  curGame: TDataList;
  ActionsAll: Integer;
  HandsAll: Integer;
  HandsWon: Integer;
  HandsLose: Integer;

  ShowdownsCnt: Integer;
  ShowdownsWon: Integer;

  HandsFlopSeen: Integer;
  HandsFlopParticipate: Integer;
  HandsWonFlopSeen: Integer;

  Loop: Integer;
  curLabel: Integer;
  curName: String;
begin
  ActionsEmpty := true;
  FoldEmpty := true;

  SessionStartLabel.Caption := ProcessModule.ProcessStats.ValuesAsString['SessionStart'];

  if ProcessModule.ProcessStats.Find(ProcessModule.CurrentGameType, curGame) then
  begin
    Caption := 'Statistics - ' + curGame.ValuesAsString['gamename'];
    //TeForm.Caption := Caption;

    ActionsAll := curGame.ValuesAsInteger['actionsall'];
    HandsWon := curGame.ValuesAsInteger['won'];
    HandsLose := curGame.ValuesAsInteger['lose'];
    HandsAll := HandsWon + HandsLose;

    SessionGamesLabel.Caption := inttostr(HandsAll);
    if HandsAll > 0 then
      GamesWonLabel.Caption := inttostr((100 * HandsWon) div HandsAll) + ' %'
    else
      GamesWonLabel.Caption := '0 %';

    ShowdownsCnt := curGame.ValuesAsInteger['showdowncount'];
    ShowdownsWon := curGame.ValuesAsInteger['winshowdowncount'];
    if ShowdownsCnt > 0 then
      ShowdownsWonLabel.Caption := inttostr((100 * ShowdownsWon) div ShowdownsCnt) + ' %'
    else
      ShowdownsWonLabel.Caption := '0 %';

    HandsFlopSeen := curGame.ValuesAsInteger['flopseen'];
    HandsFlopParticipate := curGame.ValuesAsInteger['flopparticipate'];
    HandsWonFlopSeen := curGame.ValuesAsInteger['winflopseen'];
    if HandsFlopSeen > 0 then
      FlopsSeenValueLabel.Caption    := inttostr((100 * HandsFlopParticipate) div HandsFlopSeen) + ' %'
    else
      FlopsSeenValueLabel.Caption    := '0 %';

    if HandsFlopParticipate > 0 then
      WinFlopsSeenValueLabel.Caption := inttostr((100 * HandsWonFlopSeen) div HandsFlopParticipate) + ' %'
    else
      WinFlopsSeenValueLabel.Caption := '0 %';

    FlopsSeenNameLabel.Caption     := curGame.ValuesAsString['flopname'] + ':';
    WinFlopsSeenNameLabel.Caption  := curGame.ValuesAsString['winflopname'] + ':';

    if ActionsAll > 0 then
    begin
      ActionsEmpty := false;
      FoldLabel.Caption    := inttostr((100 * curGame.ValuesAsInteger['fold']) div ActionsAll) + ' %';
      CheckLabel.Caption   := inttostr((100 * curGame.ValuesAsInteger['check']) div ActionsAll) + ' %';
      CallLabel.Caption    := inttostr((100 * curGame.ValuesAsInteger['call']) div ActionsAll) + ' %';
      BetLabel.Caption     := inttostr((100 * curGame.ValuesAsInteger['bet']) div ActionsAll) + ' %';
      RaiseLabel.Caption   := inttostr((100 * curGame.ValuesAsInteger['raise']) div ActionsAll) + ' %';
      ReRaiseLabel.Caption := inttostr((100 * curGame.ValuesAsInteger['reraise']) div ActionsAll) + ' %';
    end;

    if HandsAll > 0 then
    begin
      FoldEmpty := false;
      curLabel := 1;
      for Loop := 0 to curGame.ValueCount - 1 do
      begin
        curName := curGame.ValueNames[Loop];
        if copy(curName, 1, 7) = 'foldon_' then
        begin
          GetFoldLabel(curLabel, 0).Caption :=
            UpperCase(copy(curName, 8, 1)) + copy(curName, 9, MAXINT) + ':';
          GetFoldLabel(curLabel, 1).Caption :=
            inttostr((100 * curGame.ValuesAsInteger[curName]) div HandsAll) + ' %';
          curLabel := curLabel + 1;
        end;
      end;
    end;
  end
  else
  begin
    Caption := 'Statistics';
    //TeForm.Caption := Caption;

    SessionGamesLabel.Caption := '0';
    GamesWonLabel.Caption := '0 %';
    ShowdownsWonLabel.Caption := '0 %';

    FlopsSeenNameLabel.Caption     := 'Flops seen:';
    FlopsSeenValueLabel.Caption    := '0 %';
    WinFlopsSeenNameLabel.Caption  := 'Win % if flop seen:';
    WinFlopsSeenValueLabel.Caption := '0 %';
  end;

  if ActionsEmpty then
  begin
    FoldLabel.Caption    := '0 %';
    CheckLabel.Caption   := '0 %';
    CallLabel.Caption    := '0 %';
    BetLabel.Caption     := '0 %';
    RaiseLabel.Caption   := '0 %';
    ReRaiseLabel.Caption := '0 %';
  end;

  if FoldEmpty then
  begin
    StatsName1Label.Caption    := 'Pre-flop:';
    StatsValue1Label.Caption   := '0 %';
    StatsName2Label.Caption    := 'Flop:';
    StatsValue2Label.Caption   := '0 %';
    StatsName3Label.Caption    := 'Turn:';
    StatsValue3Label.Caption   := '0 %';
    StatsName4Label.Caption    := 'River:';
    StatsValue4Label.Caption   := '0 %';
    StatsName5Label.Caption    := 'No fold:';
    StatsValue5Label.Caption   := '0 %';
    StatsName6Label.Caption    := '';
    StatsValue6Label.Caption   := '';
  end;
end;

function TProcessStatisticsForm.GetFoldLabel(Index, labeltype: Integer): TTeLabel;
begin
  Result := StatsName1Label;
  case Index of
    1: if labeltype = 0 then
         Result := StatsName1Label
       else
         Result := StatsValue1Label;
    2: if labeltype = 0 then
         Result := StatsName2Label
       else
         Result := StatsValue2Label;
    3: if labeltype = 0 then
         Result := StatsName3Label
       else
         Result := StatsValue3Label;
    4: if labeltype = 0 then
         Result := StatsName4Label
       else
         Result := StatsValue4Label;
    5: if labeltype = 0 then
         Result := StatsName5Label
       else
         Result := StatsValue5Label;
    6: if labeltype = 0 then
         Result := StatsName6Label
       else
         Result := StatsValue6Label;
  end;
end;

procedure TProcessStatisticsForm.BackgroundPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  _X: Integer;
  _Y: Integer;

  Loop: Integer;
  curMenuItem: TTeItem;
  curGame: TDataList;
begin
  if Button = mbRight then
  begin
    Loop := 0;
    repeat
      curMenuItem := StatisticsPopupMenu.Items.Items[Loop];
      if curMenuItem.Tag <> 0 then
        StatisticsPopupMenu.Items.Delete(Loop)
      else
        Inc(Loop);
    until Loop >= StatisticsPopupMenu.Items.Count;

    if ProcessModule.ProcessStats.Count > 0 then
      for Loop := ProcessModule.ProcessStats.Count - 1 downto 0 do
      begin
        curGame := ProcessModule.ProcessStats.Items(Loop);
        curMenuItem := TTeItem.Create(StatisticsPopupMenu);
        curMenuItem.Caption := curGame.ValuesAsString['gamename'];
        curMenuItem.Tag := curGame.ID;
        curMenuItem.OnClick := GameMenuItemClick;
        curMenuItem.Checked := curMenuItem.Tag = ProcessModule.CurrentGameType;
        StatisticsPopupMenu.Items.Insert(2, curMenuItem);
      end
    else
      begin
        curMenuItem := TTeItem.Create(StatisticsPopupMenu);
        curMenuItem.Caption := 'Statistics is empty';
        curMenuItem.Tag := 1;
        curMenuItem.OnClick := nil;
        curMenuItem.Checked := false;
        curMenuItem.Enabled := false;
        StatisticsPopupMenu.Items.Insert(2, curMenuItem);
      end;

    _X := Left + 3;
    _Y := Top + 25;

    StatisticsPopupMenu.Popup(_X + X, _Y + Y);
  end;
end;

procedure TProcessStatisticsForm.GameMenuItemClick(Sender: TObject);
begin
  ChangeGameTimer.Tag := (Sender as TComponent).Tag;
  ChangeGameTimer.Enabled := true;
end;

procedure TProcessStatisticsForm.ChangeGameTimerTimer(Sender: TObject);
begin
  ChangeGameTimer.Enabled := false;
  ProcessModule.Do_ChangeCurrentStatsGameType((Sender as TComponent).Tag);
end;

procedure TProcessStatisticsForm.ResetButtonClick(Sender: TObject);
begin
  ProcessModule.Do_ProcessStatsClear;
end;

procedure TProcessStatisticsForm.ResetStatisticsItemClick(Sender: TObject);
begin
  ProcessModule.Do_ProcessStatsClear;
end;

procedure TProcessStatisticsForm.SaveToClipboardItemClick(Sender: TObject);
begin
  Clipboard.AsText :=
  SessionStartNameLabel.Caption + ' ' + SessionStartLabel.Caption + #13#10 +
  SessionGamesNameLabel.Caption + ' ' + SessionGamesLabel.Caption + #13#10 +
  GamesWonNameLabel.Caption + ' ' + GamesWonLabel.Caption + #13#10 +
  ShowdownsWonNameLabel.Caption + ' ' + ShowdownsWonLabel.Caption + #13#10 +
  FlopsSeenNameLabel.Caption + ' ' + FlopsSeenValueLabel.Caption + #13#10 +
  WinFlopsSeenNameLabel.Caption + ' ' + WinFlopsSeenValueLabel.Caption + #13#10 +

  YourActionsLabel.Caption + #13#10 +
  FoldNameLabel.Caption + ' ' + FoldLabel.Caption + #13#10 +
  CheckNameLabel.Caption + ' ' + CheckLabel.Caption + #13#10 +
  CallNameLabel.Caption + ' ' + CallLabel.Caption + #13#10 +
  BetNameLabel.Caption + ' ' + BetLabel.Caption + #13#10 +
  RaiseNameLabel.Caption + ' ' + RaiseLabel.Caption + #13#10 +
  ReRaiseNameLabel.Caption + ' ' + ReRaiseLabel.Caption + #13#10 +

  WhereYouFoldLabel.Caption + #13#10 +
  StatsName1Label.Caption + ' ' + StatsValue1Label.Caption + #13#10 +
  StatsName2Label.Caption + ' ' + StatsValue2Label.Caption + #13#10 +
  StatsName3Label.Caption + ' ' + StatsValue3Label.Caption + #13#10 +
  StatsName4Label.Caption + ' ' + StatsValue4Label.Caption + #13#10 +
  StatsName5Label.Caption + ' ' + StatsValue5Label.Caption + #13#10 +
  StatsName6Label.Caption + ' ' + StatsValue6Label.Caption;

  ThemeEngineModule.ShowMessage(cstrProcessStatsCopyToClipboard);
end;

procedure TProcessStatisticsForm.AlwaysOnTopItemClick(Sender: TObject);
begin
  SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsOnTop] :=
    not SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsOnTop];
  OnProcessStatsShow;
end;

procedure TProcessStatisticsForm.PreserveStatisticsItemClick(
  Sender: TObject);
begin
  SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsPreserve] :=
    not SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsPreserve];
  OnProcessStatsShow;
end;

procedure TProcessStatisticsForm.StatisticsLoggingItemClick(Sender: TObject);
begin
  SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessLogging] :=
    not SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessLogging];
  OnProcessStatsShow;
end;

procedure TProcessStatisticsForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TProcessStatisticsForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;


end.
