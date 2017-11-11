unit uUserForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, ComCtrls, Buttons;

type
  TUsersForm = class(TForm)
    MainMenu: TMainMenu;
    Bots1: TMenuItem;
    ables1: TMenuItem;
    ournaments1: TMenuItem;
    Settings1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    GenerateBotsItem: TMenuItem;
    ConnectionSettingsItem: TMenuItem;
    Singletabletournaments1: TMenuItem;
    Multitabletournaments1: TMenuItem;
    ablelist1: TMenuItem;
    Runn1: TMenuItem;
    N1: TMenuItem;
    Quit1: TMenuItem;
    BotListPanel: TPanel;
    BotListCaptionLabel: TLabel;
    MainSplitter: TSplitter;
    ConnectedBotsPanel: TPanel;
    ConnectedBotsCaptionLabel: TLabel;
    BotListActionPanel: TPanel;
    BotListView: TListView;
    BotListDeleteButton: TSpeedButton;
    BotListConnectButton: TSpeedButton;
    BotListSelectAllButton: TSpeedButton;
    BotListClearSelectionAllButton: TSpeedButton;
    BotListEditButton: TSpeedButton;
    BotListAddButton: TSpeedButton;
    BotListGenerateButton: TSpeedButton;
    ActionPageControl: TPageControl;
    ConnectionsTabSheet: TTabSheet;
    ProcessesTabSheet: TTabSheet;
    ConnectedInfoEdit: TLabeledEdit;
    DisconnectedInfoEdit: TLabeledEdit;
    RegisteredInfoEdit: TLabeledEdit;
    LoggedInfoEdit: TLabeledEdit;
    ConnectedDisconnectButton: TSpeedButton;
    ConnectedReconnectButton: TSpeedButton;
    ConnectedSelectAllButton: TSpeedButton;
    ConnectedClearSelectionButton: TSpeedButton;
    RefreshGroupBox: TGroupBox;
    RefreshNowButton: TSpeedButton;
    RefreshEditButton: TSpeedButton;
    EmulateCheckBox: TCheckBox;
    EmulateComboBox: TComboBox;
    ProcessListPanel: TPanel;
    ProcessesActionPanel: TPanel;
    CategoryLabel: TLabel;
    JoinProcessButton: TSpeedButton;
    CategoryComboBox: TComboBox;
    ProcessesListView: TListView;
    ProcessesSplitter: TSplitter;
    ProcessInfoMemo: TMemo;
    ShowTablesButton: TSpeedButton;
    ConnectedBotListView: TListView;
    SplitterBots: TSplitter;
    PanelBots: TPanel;
    CloseTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConnectionSettingsItemClick(Sender: TObject);
    procedure GenerateBotsItemClick(Sender: TObject);
    procedure BotListSelectAllButtonClick(Sender: TObject);
    procedure BotListClearSelectionAllButtonClick(Sender: TObject);
    procedure BotListDeleteButtonClick(Sender: TObject);
    procedure BotListConnectButtonClick(Sender: TObject);
    procedure BotListGenerateButtonClick(Sender: TObject);
    procedure BotListAddButtonClick(Sender: TObject);
    procedure BotListEditButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NumberEditKeyPress(Sender: TObject; var Key: Char);
    procedure RefreshEditButtonClick(Sender: TObject);
    procedure RefreshNowButtonClick(Sender: TObject);
    procedure ConnectedSelectAllButtonClick(Sender: TObject);
    procedure ConnectedClearSelectionButtonClick(Sender: TObject);
    procedure ConnectedDisconnectButtonClick(Sender: TObject);
    procedure ConnectedReconnectButtonClick(Sender: TObject);
    procedure JoinProcessButtonClick(Sender: TObject);
    procedure CategoryComboBoxChange(Sender: TObject);
    procedure ProcessesListViewClick(Sender: TObject);
    procedure ShowTablesButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseTimerTimer(Sender: TObject);
  private
    FDrawedSubCategoryID: Integer;
    FUpdatingNow: Boolean;

    procedure UpdateBotList;

    procedure UpdateConnectedControls;
    procedure UpdateConnectedData;
    procedure UpdateRefreshSettings;
    procedure UpdateProcessList;
  end;

var
  UsersForm: TUsersForm;

implementation

{$R *.dfm}

uses
  uLogger, uConstants, uCommonDataModule, uDataList, uConversions,
  uSettingsForm, uGenerationForm, uBotConnection, uBotForm, uLobbyModule;


procedure TUsersForm.FormCreate(Sender: TObject);
begin
  CommonDataModule.OnBotListUpdate := UpdateBotList;
  UpdateBotList;

  CommonDataModule.OnBotConnectedUpdate := UpdateConnectedControls;
  UpdateConnectedData;
  UpdateRefreshSettings;

  ActionPageControl.ActivePageIndex := 0;
  FDrawedSubCategoryID := -1;
  DoubleBuffered := True;
  Logger.Log(0, ClassName, 'FormCreate', 'Created sucessfully', ltBase);
end;

procedure TUsersForm.FormDestroy(Sender: TObject);
begin
  Logger.Log(0, ClassName, 'FormDestroy', 'Destroyed sucessfully', ltBase);
end;

procedure TUsersForm.FormShow(Sender: TObject);
begin
  UpdateRefreshSettings;
  Caption := 'RoboPoker - Lobby';
  Left := 0;
  Top := 0;
  BotForm.Caption := 'RoboPoker - Tables';
  BotForm.Left := Screen.DesktopWidth - BotForm.Width;
  BotForm.Top := Screen.DesktopHeight - BotForm.Height;
end;

procedure TUsersForm.UpdateConnectedControls;
begin
  if ActionPageControl.ActivePageIndex = 0 then
    UpdateConnectedData
  else
    UpdateProcessList;
end;


// Additional Forms calls

procedure TUsersForm.ConnectionSettingsItemClick(Sender: TObject);
begin
  SettingsForm.Show;
end;

procedure TUsersForm.GenerateBotsItemClick(Sender: TObject);
begin
  GenerationForm.Show;
end;


// Bot list

procedure TUsersForm.UpdateBotList;
var
  Loop: Integer;
  curBot: TDataList;
  curItem: TListItem;
begin
  while CommonDataModule.BotList.Count <> BotListView.Items.Count do
    if CommonDataModule.BotList.Count < BotListView.Items.Count then
      BotListView.Items.Delete(0)
    else
      BotListView.Items.Add.SubItems.Add('');

  for Loop := 0 to CommonDataModule.BotList.Count - 1 do
  begin
    curBot := CommonDataModule.BotList.Items(Loop);
    curItem := BotListView.Items[Loop];
    curItem.Caption := inttostr(curBot.ID);
    curItem.Data := Pointer(curBot.ID);
    curItem.SubItems.Text := curBot.ValuesAsString[BotLoginName];
  end;
end;

procedure TUsersForm.BotListSelectAllButtonClick(Sender: TObject);
begin
  BotListView.SelectAll;
end;

procedure TUsersForm.BotListClearSelectionAllButtonClick(Sender: TObject);
begin
  BotListView.ClearSelection;
end;

procedure TUsersForm.BotListAddButtonClick(Sender: TObject);
begin
//
end;

procedure TUsersForm.BotListEditButtonClick(Sender: TObject);
begin
//
end;

procedure TUsersForm.BotListDeleteButtonClick(Sender: TObject);
var
 Loop: Integer;
 BotID: Integer;
begin
  for Loop := 0 to BotListView.Items.Count - 1 do
    if BotListView.Items[Loop].Selected then
    begin
      BotID := Integer(BotListView.Items[Loop].Data);
      CommonDataModule.DisconnectBot(BotID);
      CommonDataModule.BotList.Remove(BotID);
    end;
  UpdateBotList;  
end;

procedure TUsersForm.BotListConnectButtonClick(Sender: TObject);
var
 Loop: Integer;
begin
  for Loop := 0 to BotListView.Items.Count - 1 do
    if BotListView.Items[Loop].Selected then
      CommonDataModule.ConnectBot(Integer(BotListView.Items[Loop].Data));
end;

procedure TUsersForm.BotListGenerateButtonClick(Sender: TObject);
begin
  GenerationForm.Show;
end;


// Refresh settings

procedure TUsersForm.UpdateRefreshSettings;
begin
  EmulateCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotEmulateLobby];
  EmulateComboBox.ItemIndex := CommonDataModule.SessionSettings.ValuesAsInteger[BotEmulateLobbyType];
  EmulateCheckBox.Enabled := False;
  EmulateComboBox.Enabled := False;
  RefreshEditButton.Caption := EditCaption;
  RefreshNowButton.Caption := RefreshNowCaption;
end;

procedure TUsersForm.NumberEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ((Key >= ' ') and (Key < '0')) or (Key > '9') then
    Key := #0;
end;

procedure TUsersForm.RefreshEditButtonClick(Sender: TObject);
begin
  if RefreshEditButton.Caption = EditCaption then
  begin
    EmulateCheckBox.Enabled := True;
    EmulateComboBox.Enabled := True;
    RefreshEditButton.Caption := SaveCaption;
    RefreshNowButton.Caption := CancelCaption;
  end
  else
  begin
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotEmulateLobby] := EmulateCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsInteger[BotEmulateLobbyType] := EmulateComboBox.ItemIndex;
    UpdateRefreshSettings;
    CommonDataModule.RefreshAll;
  end;
end;

procedure TUsersForm.RefreshNowButtonClick(Sender: TObject);
begin
  UpdateRefreshSettings;
  CommonDataModule.RefreshAll;
end;


// Connected Data

procedure TUsersForm.UpdateConnectedData;
var
  ConnectedCount: Integer;
  DisconnectedCount: Integer;
  RegisteredCount: Integer;
  LoggedCount: Integer;

  Loop: Integer;
  curBotConnection: TBotConnection;
  curItem: TListItem;
begin
  // Summary Info
  CommonDataModule.BotsSummary(ConnectedCount, DisconnectedCount, RegisteredCount, LoggedCount);
  ConnectedInfoEdit.Text := inttostr(ConnectedCount);
  DisconnectedInfoEdit.Text := inttostr(DisconnectedCount);
  RegisteredInfoEdit.Text := inttostr(RegisteredCount);
  LoggedInfoEdit.Text := inttostr(LoggedCount);

  // Bot Connected list
  while CommonDataModule.BotConnections.Count <> ConnectedBotListView.Items.Count do
    if CommonDataModule.BotConnections.Count < ConnectedBotListView.Items.Count then
      ConnectedBotListView.Items.Delete(0)
    else
      with ConnectedBotListView.Items.Add do
        for Loop := 0 to 5 do
          SubItems.Add('');

  for Loop := 0 to CommonDataModule.BotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(CommonDataModule.BotConnections.Items[Loop]);
    curItem := ConnectedBotListView.Items[Loop];
    curItem.Caption := inttostr(curBotConnection.BotID);
    curItem.Data := Pointer(curBotConnection.BotID);
    curItem.SubItems.Strings[0] := inttostr(curBotConnection.SessionID);
    curItem.SubItems.Strings[1] := inttostr(curBotConnection.UserID);
    curItem.SubItems.Strings[2] := curBotConnection.BotName;
    curItem.SubItems.Strings[3] := curBotConnection.GetConnectionState;
    curItem.SubItems.Strings[4] := inttostr(curBotConnection.Disconnects);
    curItem.SubItems.Strings[5] := inttostr(curBotConnection.ProcessIDs.Count);
  end;
end;

procedure TUsersForm.ConnectedSelectAllButtonClick(Sender: TObject);
begin
  ConnectedBotListView.SelectAll;
end;

procedure TUsersForm.ConnectedClearSelectionButtonClick(Sender: TObject);
begin
  ConnectedBotListView.ClearSelection;
end;

procedure TUsersForm.ConnectedDisconnectButtonClick(Sender: TObject);
var
 Loop: Integer;
begin
  for Loop := 0 to ConnectedBotListView.Items.Count - 1 do
    if ConnectedBotListView.Items[Loop].Selected then
      CommonDataModule.DisconnectBot(Integer(ConnectedBotListView.Items[Loop].Data));
  ConnectedBotListView.ClearSelection;
  UpdateConnectedData;
end;

procedure TUsersForm.ConnectedReconnectButtonClick(Sender: TObject);
var
 Loop: Integer;
begin
  for Loop := 0 to ConnectedBotListView.Items.Count - 1 do
    if ConnectedBotListView.Items[Loop].Selected then
      CommonDataModule.ReconnectBot(Integer(ConnectedBotListView.Items[Loop].Data));
  UpdateConnectedData;
end;


// Process List

procedure TUsersForm.UpdateProcessList;
var
  Loop: Integer;
  Loop2: Integer;
  Index: Integer;
  curCategory: TDataList;
  curSubCategory: TDataList;
  curProcess: TDataList;
  curProcessInfo: TDataList;
  curData: TDataList;
  curItem: TListItem;
  curColumn: TListColumn;
  curText: String;
  curName: String;
  curCity: String;
  curValue: String;
begin
  FUpdatingNow := True;

  // Update Category
  if FDrawedSubCategoryID <> CommonDataModule.LobbyModule.CurrentSubCategoryID then
  begin
    if not CategoryComboBox.DroppedDown then
    begin
      Index := -1;
      CategoryComboBox.Clear;
      if CommonDataModule.LobbyModule.Data.Find(
        CommonDataModule.LobbyModule.CurrentCategoryID, curCategory) then
      begin
        for Loop := 0 to curCategory.Count - 1 do
        begin
          curSubCategory := curCategory.Items(Loop);
          CategoryComboBox.Items.Add(curSubCategory.Name);
          if curSubCategory.ID = CommonDataModule.LobbyModule.CurrentSubCategoryID then
            Index := Loop;
        end;
      end;
      CategoryComboBox.ItemIndex := Index;
    end;

    // Process list - columns
    if CommonDataModule.LobbyModule.CurrentColumns <> nil then
    begin
      while ProcessesListView.Columns.Count <> CommonDataModule.LobbyModule.CurrentColumns.Count + 1 do
        if ProcessesListView.Columns.Count > CommonDataModule.LobbyModule.CurrentColumns.Count + 1 then
          ProcessesListView.Columns.Delete(0)
        else
          ProcessesListView.Columns.Add;

      ProcessesListView.Columns[0].Caption := 'ID';
      for Loop := 1 to CommonDataModule.LobbyModule.CurrentColumns.Count do
      begin
        curColumn := ProcessesListView.Columns[Loop];
        curColumn.Caption := CommonDataModule.LobbyModule.CurrentColumns.Items(Loop - 1).Name;
        if Loop = 1 then
          curColumn.Width := 120
        else
          curColumn.Width := 50;
      end;

      if CommonDataModule.LobbyModule.CurrentColumns.Count > 0 then
        FDrawedSubCategoryID := CommonDataModule.LobbyModule.CurrentSubCategoryID;
    end
    else
      ProcessesListView.Items.Clear;
  end;

  // Process list - rows
  if CommonDataModule.LobbyModule.CurrentProcesses <> nil then
  begin
    while ProcessesListView.Items.Count <> CommonDataModule.LobbyModule.CurrentProcesses.Count do
      if ProcessesListView.Items.Count > CommonDataModule.LobbyModule.CurrentProcesses.Count then
        ProcessesListView.Items.Delete(0)
      else
      begin
        curItem := ProcessesListView.Items.Add;
        for Loop2 := 0 to 20 do
          curItem.SubItems.Add('');
      end;

    for Loop := 0 to CommonDataModule.LobbyModule.CurrentProcesses.Count - 1 do
    begin
      curProcess := CommonDataModule.LobbyModule.CurrentProcesses.Items(Loop);
      curItem := ProcessesListView.Items[Loop];
      curItem.Data := Pointer(curProcess.ID);
      curItem.Caption := inttostr(curProcess.ID);
      for Loop2 := 0 to CommonDataModule.LobbyModule.CurrentColumns.Count - 1 do
        curItem.SubItems[Loop2] := curProcess.ValuesAsString[
          inttostr(CommonDataModule.LobbyModule.CurrentColumns.Items(Loop2).ID)];
    end;
  end;

  // Process info - summary
  ProcessInfoMemo.Lines.Clear;

  ProcessInfoMemo.Lines.Add(' ' +
    inttostr(CommonDataModule.LobbyModule.PlayersCount) + cstrLobbyTotalPlayers);
  ProcessInfoMemo.Lines.Add(' ' +
    inttostr(CommonDataModule.LobbyModule.ProcessesCount) + cstrLobbyTotalProcesses);

  if CommonDataModule.LobbyModule.Data.Find(
    CommonDataModule.LobbyModule.CurrentCategoryID, curCategory) then
    if curCategory.Find(CommonDataModule.LobbyModule.CurrentSubCategoryID, curSubCategory) then
      begin
        ProcessInfoMemo.Lines.Add(' ' +
          inttostr(curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT]) + ' ' +
          curSubCategory.Name + cstrLobbySubCategoryPlayers);
        ProcessInfoMemo.Lines.Add(' ' +
          inttostr(curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT]) +
          cstrLobbySubCategoryProcesses);
      end;

  // Process info - data
  if CommonDataModule.LobbyModule.CurrentProcesses <> nil then
    if CommonDataModule.LobbyModule.CurrentProcesses.Find(
      CommonDataModule.LobbyModule.CurrentProcessID, curProcess) then
    begin
      // Process Info Data Title
      curText := 'Table ' + curProcess.Name + ':';
      ProcessInfoMemo.Lines.Add('');
      ProcessInfoMemo.Lines.Add(' ' + curText);

      // Process Info Data Rows
      curText := '';
      if CommonDataModule.LobbyModule.CurrentProcessesInfo <> nil then
        if CommonDataModule.LobbyModule.CurrentProcessesInfo.
          Find(CommonDataModule.LobbyModule.CurrentProcessID, curProcessInfo) then
          for Loop := 0 to curProcessInfo.Count - 1 do
          begin
            curData := curProcessInfo.Items(Loop);
            if curData.ValuesAsBoolean['isgroup'] then
            begin
              curText := curData.Name;
              curValue := curData.ValuesAsString['value'];
              if curValue <> '' then
                curText := curText + ' ' + curValue;
            end
            else
            begin
              curName := curData.Name;
              curCity := curData.ValuesAsString['city'];
              curValue := curData.ValuesAsString['value'];

              if (curCity = '') and (curValue = '') then
                curText := curName
              else
              begin
                if curCity = '' then
                begin
                  curText := curName;
                  curValue := ' - ' + curValue;
                end
                else
                begin
                  curText := curName + ' (' + curCity;
                  curValue := ') - ' + curValue;
                end;

                curText := '  ' + curText + curValue;
              end;
            end;
           ProcessInfoMemo.Lines.Add(' ' + curText);
          end;
    end;

  FUpdatingNow := False;

  curText  := '';
  curName  := '';
  curCity  := '';
  curValue := '';
end;

procedure TUsersForm.CategoryComboBoxChange(Sender: TObject);
var
  curCategory: TDataList;
begin
  if not FUpdatingNow then
  if CommonDataModule.LobbyModule.Data.Find(
    CommonDataModule.LobbyModule.CurrentCategoryID, curCategory) then
      CommonDataModule.LobbyModule.Do_ChooseSubCategory(
        curCategory.Items(CategoryComboBox.ItemIndex).ID);
  UpdateProcessList;
end;

procedure TUsersForm.JoinProcessButtonClick(Sender: TObject);
var
  Loop: Integer;
  curProcessID: Integer;
  curProcessName: String;
  curItem: TListItem;
begin
  curProcessID := 0;
  if ProcessesListView.ItemIndex >= 0 then
  begin
    curProcessID := Integer(ProcessesListView.Items[ProcessesListView.ItemIndex].Data);
    curProcessName := ProcessesListView.Items[ProcessesListView.ItemIndex].SubItems[0];
  end;

  if curProcessID > 0 then
  begin
    for Loop := 0 to ConnectedBotListView.Items.Count - 1 do
    begin
      curItem := ConnectedBotListView.Items[Loop];
      if curItem.Selected then
        CommonDataModule.JoinBotToProcess(Integer(curItem.Data), curProcessID, curProcessName);
    end;
  end;

  curProcessName := '';
end;

procedure TUsersForm.ProcessesListViewClick(Sender: TObject);
var
  curProcessID: Integer;
begin
  curProcessID := 0;
  if ProcessesListView.ItemIndex >= 0 then
    curProcessID := Integer(ProcessesListView.Items[ProcessesListView.ItemIndex].Data);

  if curProcessID > 0 then
    CommonDataModule.LobbyModule.Do_ChooseProcess(curProcessID, 0);
  CommonDataModule.RefreshAll;
end;

procedure TUsersForm.ShowTablesButtonClick(Sender: TObject);
begin
  BotForm.Show;
end;


procedure TUsersForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := CommonDataModule.ApplicationTerminationAllowed;
  CloseTimer.Enabled := True;
end;

procedure TUsersForm.CloseTimerTimer(Sender: TObject);
begin
  CloseTimer.Enabled := False;
  if MessageDlg('Are you sure you want to close the RoboPoker tool?',
    mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
  begin
    CommonDataModule.ApplicationTerminationAllowed := False;
    Application.Terminate;
  end;
end;

end.
