unit uTournamentLobbyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ComCtrls, StdCtrls, ShellAPI,
  uDataList, ExtCtrls, jpeg, uTournamentInfoForm;

type
  TTournamentLobbyForm = class(TForm)
    TeHeaderPanel1: TTeHeaderPanel;
    TeHeaderControl1: TTeHeaderControl;
    TableListView: TTeListView;
    TeHeaderPanel2: TTeHeaderPanel;
    TablePlayerListView: TTeListView;
    TeHeaderPanel3: TTeHeaderPanel;
    PlayerListView: TTeListView;
    ObserveTableButton: TTeButton;
    ViewPlayerDetailsButton: TTeButton;
    ViewLobbyButton: TTeButton;
    RegisterButton: TTeButton;
    LoginButton: TTeButton;
    PrizeUpButton: TTeButton;
    PrizeDownButton: TTeButton;
    PrizeTopButton: TTeButton;
    BackgroundImage: TImage;
    AdvancedInfoLabel: TLabel;
    PrizesInfoLabel: TLabel;
    PrizePoolInfoLabel: TLabel;
    MainInfoLabel: TLabel;
    CurrentPlayerTimer: TTimer;
    CurrentPlayerPanel: TPanel;
    CurrentPlayerNoLabel: TLabel;
    CurrentPlayerNameLabel: TLabel;
    CurrentPlayerAmountLabel: TLabel;
    UnRegisterButton: TTeButton;
    TournamentInfoButton: TTeButton;
    procedure FormCreate(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure ViewLobbyButtonClick(Sender: TObject);
    procedure RegisterButtonClick(Sender: TObject);
    procedure UnRegisterButtonClick(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure ObserveTableButtonClick(Sender: TObject);
    procedure ViewPlayerDetailsButtonClick(Sender: TObject);
    procedure TableListViewDblClick(Sender: TObject);
    procedure TablePlayerListViewDblClick(Sender: TObject);
    procedure PlayerListViewDblClick(Sender: TObject);
    procedure TableListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TableListViewDrawItem(Sender: TCustomListView;
      Item: TListItem; Rect: TRect; State: TOwnerDrawState);
    procedure PrizePoolDetailsButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrizeUpButtonClick(Sender: TObject);
    procedure PrizeDownButtonClick(Sender: TObject);
    procedure PrizeTopButtonClick(Sender: TObject);
    procedure CurrentPlayerTimerTimer(Sender: TObject);
    procedure TournamentInfoButtonClick(Sender: TObject);
  private
    FID: Integer;
    FURL: String;
    FPot: Currency;
    FWinnersCount: Integer;
    FUpdatingNow: Boolean;
    FName: String;
    FLogged: Boolean;
    FRegistered: Boolean;
    FTournamentType: Integer;
    FTournamentState: Integer;
    FPrizeInfoList: TStringList;
    FPrizeInfoTop: Integer;

    FIsPlayer: Boolean;
    FMyIndex: Integer;

    FPlayersListHeight: Integer;
    FPlayersListTop: Integer;

    procedure UpdatePrizeInfo;
    procedure UpdateCurrentUserInfo;
    procedure TournamentInfoFormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    TournamentInfoForm: TTournamentInfoForm;
    TournamentInfoFormOpened: Boolean;

    property ID: Integer read FID write FID;
    property Name: String read FName write FName;

    procedure StartWork(TournamentName: String; Logged, Registered: Boolean; TournamentType,
      TournamentState: Integer);
    procedure UpdateState(TournamentName : String; Logged, Registered: Boolean; TournamentType,
      TournamentState: Integer);
    procedure UpdateInfo(Info, AdvancedInfo, PrizeInfo, PrizePoolInfo, URL: String;
      Pot: Currency; WinnersCount: Integer);
    procedure UpdateTableList(TableList: TDataList);
    procedure UpdateTablePlayerList(ProcessID: Integer;PlayerList: TDataList);
    procedure UpdatePlayerList(PlayerList: TDataList);

    procedure CreateTournamentInfoForm(Caption, StartingChips: string;LevelsData,PrizesData: TDataList);
  end;

implementation

uses
  uThemeEngineModule,
  uTournamentModule,
  uConversions,
  uConstants, uUserModule, Math;

{$R *.dfm}

procedure TTournamentLobbyForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TTournamentLobbyForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TTournamentLobbyForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TTournamentLobbyForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self,
    BackgroundImage.Width, BackgroundImage.Height);

  FUpdatingNow := false;
  FPrizeInfoList := TStringList.Create;
  FPrizeInfoList.Clear;

  FIsPlayer := false;
  FMyIndex := -1;

  FPlayersListHeight := PlayerListView.Height;
  FPlayersListTop := PlayerListView.Top;

  TableListView.Color := ListViewBackgroundColor;
  PlayerListView.Color := ListViewBackgroundColor;
  TablePlayerListView.Color := ListViewBackgroundColor;

  CurrentPlayerPanel.Color := ListViewCurrentBackgroundColor;
  CurrentPlayerPanel.Visible := false;
  CurrentPlayerNoLabel.Color := ListViewTextColor;
  CurrentPlayerNameLabel.Color := ListViewTextColor;
  CurrentPlayerAmountLabel.Color := ListViewTextColor;
  CurrentPlayerNoLabel.Caption := '';
  CurrentPlayerNameLabel.Caption := '';
  CurrentPlayerAmountLabel.Caption := '';
  CurrentPlayerNoLabel.Left := 3;
  CurrentPlayerNoLabel.Width := PlayerListView.Columns.Items[0].Width;
  CurrentPlayerNameLabel.Left := CurrentPlayerNoLabel.Left + CurrentPlayerNoLabel.Width;
  CurrentPlayerNameLabel.Width := PlayerListView.Columns.Items[1].Width;
  CurrentPlayerAmountLabel.Left := CurrentPlayerNameLabel.Left + CurrentPlayerNameLabel.Width;
  CurrentPlayerAmountLabel.Width := PlayerListView.Columns.Items[2].Width;
end;

procedure TTournamentLobbyForm.FormDestroy(Sender: TObject);
begin
  FPrizeInfoList.Free;
  TournamentInfoForm.Free;
end;


// Controls Events

procedure TTournamentLobbyForm.ViewLobbyButtonClick(Sender: TObject);
begin
  TournamentModule.Do_ViewLobby(ID);
end;

procedure TTournamentLobbyForm.RegisterButtonClick(Sender: TObject);
begin
  TournamentModule.Do_Register(ID);
end;

procedure TTournamentLobbyForm.UnRegisterButtonClick(Sender: TObject);
begin
  TournamentModule.Do_UnRegister(ID);
end;

procedure TTournamentLobbyForm.LoginButtonClick(Sender: TObject);
begin
  TournamentModule.Do_Login(ID);
end;

procedure TTournamentLobbyForm.TournamentInfoButtonClick(Sender: TObject);
begin
   TournamentModule.Do_ChooseTournamentInfo(ID);
end;

procedure TTournamentLobbyForm.TableListViewChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if not FUpdatingNow then
    if TableListView.ItemIndex >= 0 then
      TournamentModule.Do_ChooseTable(ID,
        Integer(TableListView.Items.Item[TableListView.ItemIndex].Data));
end;

procedure TTournamentLobbyForm.ObserveTableButtonClick(Sender: TObject);
begin
  if not FUpdatingNow then
    if TableListView.ItemIndex >= 0 then
      TournamentModule.Do_ObserveTable(ID,
        Integer(TableListView.Items.Item[TableListView.ItemIndex].Data));
end;

procedure TTournamentLobbyForm.TableListViewDblClick(Sender: TObject);
begin
  if not FUpdatingNow then
    if TableListView.ItemIndex >= 0 then
      TournamentModule.Do_ObserveTable(ID,
        Integer(TableListView.Items.Item[TableListView.ItemIndex].Data));
end;

procedure TTournamentLobbyForm.ViewPlayerDetailsButtonClick(
  Sender: TObject);
begin
  if not FUpdatingNow then
    if PlayerListView.ItemIndex >= 0 then
      TournamentModule.Do_PlayerDetails(ID,
        Integer(PlayerListView.Items.Item[PlayerListView.ItemIndex].Data))
end;

procedure TTournamentLobbyForm.TablePlayerListViewDblClick(
  Sender: TObject);
begin
  if not FUpdatingNow then
    if TablePlayerListView.ItemIndex >= 0 then
      TournamentModule.Do_PlayerDetails(ID,
        Integer(TablePlayerListView.Items.Item[TablePlayerListView.ItemIndex].Data));
end;

procedure TTournamentLobbyForm.PlayerListViewDblClick(Sender: TObject);
begin
  if not FUpdatingNow then
    if PlayerListView.ItemIndex >= 0 then
      TournamentModule.Do_PlayerDetails(ID,
        Integer(PlayerListView.Items.Item[PlayerListView.ItemIndex].Data));
end;


// Control procedures from Module

procedure TTournamentLobbyForm.StartWork(TournamentName: String; Logged, Registered: Boolean;
  TournamentType, TournamentState: Integer);
begin
  Caption := TournamentName + ' Lobby';
  //TeForm.Caption := Caption;
  UpdateState(TournamentName, Logged, Registered, TournamentType, TournamentState);

  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TTournamentLobbyForm.UpdateState(TournamentName : String; Logged, Registered: Boolean;
  TournamentType, TournamentState: Integer);
var
  UserSessionInfo: String;
begin
  UserSessionInfo := UserModule.GetUserSessionInfo;
  if UserSessionInfo <> '' then
  begin
    Caption := TournamentName + ' Lobby ' + UserSessionInfo;
    //TeForm.Caption := Caption;
  end;

  FLogged := Logged;
  FRegistered := Registered;
  FTournamentType := TournamentType;
  FTournamentState := TournamentState;

  //RegisterButton.Enabled := false;
  LoginButton.Visible := false;
  //LoginButton.Caption := '';
  RegisterButton.Visible := false;
  //RegisterButton.Caption := '';

  if not FLogged then
  begin
    LoginButton.Visible := true;
    //LoginButton.Caption := 'Login';
  end
  else
    if not FRegistered then
    begin
      if FTournamentState = 2 then
      begin
        RegisterButton.Visible := true;
        //RegisterButton.Caption := 'Register';
        UnRegisterButton.Visible := false;
        //UnRegisterButton.Caption := '';
      end;
    end
    else
    begin
      RegisterButton.Visible := false;
      //RegisterButton.Caption := '';
      UnRegisterButton.Visible := true;
      UnRegisterButton.Caption := 'Unregister';
      UnRegisterButton.Enabled := true;
    end;

    if (FTournamentState <> 2)  and  Logged then
    begin
     UnRegisterButton.Visible := true;
     UnRegisterButton.Enabled := false;
     UnRegisterButton.Caption := '';
    end{}
end;


procedure TTournamentLobbyForm.UpdateInfo(Info, AdvancedInfo, PrizeInfo,
  PrizePoolInfo, URL: String; Pot: Currency; WinnersCount: Integer);

function ChangeTabTextToSpace(Text:String):string;
var Loop :Integer;
begin
  for loop := 0 to Length(Text) do
  begin
    If text[loop] = #9 then
     text[loop] := #32;
  end;
  result := text;
end;

begin
  MainInfoLabel.Caption := Info;
  AdvancedInfoLabel.Caption := ChangeTabTextToSpace(AdvancedInfo);
  PrizePoolInfoLabel.Caption := 'The Prize Pool structure has been modified.'+ #13#10 +
                                'Click the ''Tournament Info'' button ' + #13#10+ 'to view detailed info.' +
                                #13#10 + 'Good Luck!';//PrizePoolInfo;
  if URL <> '' then
  begin
    FURL := URL;
    //PrizePoolDetailsButton.Visible := true;
  end
  else
  begin
    FURL := '';
    //PrizePoolDetailsButton.Visible := false;
  end;

  FPot := Pot;
  FWinnersCount := WinnersCount;
  FPrizeInfoList.Text := PrizeInfo;
  UpdatePrizeInfo;
end;

procedure TTournamentLobbyForm.UpdatePrizeInfo;
var
  infoText: String;
  Loop: Integer;
begin
  infoText := '';
  if (FPot > 0) and (FWinnersCount > 0) then
  begin
    infoText := cstrTournamentPotSum + Conversions.Cur2Str(FPot) + #13#10;
    infoText := infoText + IntToStr(FWinnersCount) + cstrTournamentWinnersCount + #13#10;
  end;

  if FPrizeInfoList.Count <= 7 then
  begin
    FPrizeInfoTop := 0;
    PrizesInfoLabel.Caption := infoText + FPrizeInfoList.Text;
    PrizeUpButton.Visible := false;
    PrizeDownButton.Visible := false;
    PrizeTopButton.Visible := false;
  end
  else
  begin
    if FPrizeInfoTop < 0 then
      FPrizeInfoTop := 0;
    if FPrizeInfoTop > FPrizeInfoList.Count - 6 then
      FPrizeInfoTop := FPrizeInfoList.Count - 6;

    for Loop := FPrizeInfoTop to FPrizeInfoList.Count - 1 do
      infoText := infoText + FPrizeInfoList.Strings[Loop] + #13#10;
    PrizesInfoLabel.Caption := infoText;

    PrizeUpButton.Visible := true;
    PrizeDownButton.Visible := true;
    PrizeTopButton.Visible := true;
  end;
end;

procedure TTournamentLobbyForm.PrizeUpButtonClick(Sender: TObject);
begin
  FPrizeInfoTop := FPrizeInfoTop - 1;
  UpdatePrizeInfo;
end;

procedure TTournamentLobbyForm.PrizeDownButtonClick(Sender: TObject);
begin
  FPrizeInfoTop := FPrizeInfoTop + 1;
  UpdatePrizeInfo;
end;

procedure TTournamentLobbyForm.PrizeTopButtonClick(Sender: TObject);
begin
  FPrizeInfoTop := 0;
  UpdatePrizeInfo;
end;


procedure TTournamentLobbyForm.UpdateTableList(TableList: TDataList);
var
  Loop: Integer;
  curItem: TListItem;
  curData: TDataList;
  curID: Integer;
  curInd: Integer;
begin
  FUpdatingNow := true;

  if TableList.Count = 0 then
  begin
    TableListView.Clear;
    TableListView.ItemIndex := -1;
    TablePlayerListView.Clear;
    FUpdatingNow := false;
    ObserveTableButton.Enabled := false;
    exit;
  end;

  curInd := 0;
  curID := 0;
  if TableListView.ItemIndex >= 0 then
    curID := Integer(TableListView.Items.Item[TableListView.ItemIndex].Data);

  if TableListView.Items.Count <> TableList.Count then
    if TableListView.Items.Count < TableList.Count then
    repeat
      curItem := TableListView.Items.Add;
      curItem.SubItems.Add(' ');
      curItem.SubItems.Add(' ');
      curItem.SubItems.Add(' ');
    until TableList.Count = TableListView.Items.Count
    else
    repeat
      TableListView.Items.Delete(TableListView.Items.Count - 1);
    until TableList.Count = TableListView.Items.Count;

  for Loop := 0 to TableList.Count - 1 do
  begin
    curData := TableList.Items(Loop);
    curItem := TableListView.Items.Item[Loop];
    curItem.Caption := curData.ValuesAsString['name'];
    curItem.Data := pointer(curData.ID);
    curItem.SubItems.Strings[0] := curData.ValuesAsString['playerscount'];
    curItem.SubItems.Strings[1] := curData.ValuesAsString['minstack'];
    curItem.SubItems.Strings[2] := curData.ValuesAsString['maxstack'];

    if curData.ID = curID then
      curInd := Loop;
  end;

  FUpdatingNow := false;

  if (curInd >= 0) and (curInd < TableListView.Items.Count) then
    TableListView.ItemIndex := curInd
  else
    if TableListView.Items.Count > 0 then
      TableListView.ItemIndex := 0
    else
      TableListView.Items.Count := -1;

  TableListView.Invalidate;
  ObserveTableButton.Enabled:= true;
end;

procedure TTournamentLobbyForm.UpdateTablePlayerList(ProcessID: Integer;PlayerList: TDataList);
var
  Loop: Integer;
  curItem: TListItem;
  curData: TDataList;
  curID: Integer;
  curInd: Integer;
  TableList: TDataList;
begin
  FUpdatingNow := true;
  curInd := 0;
  try
   TableList := TDataList.Create(0,nil);
  for Loop := 0 to PlayerList.count-1 do
  begin
    if PlayerList.Items(Loop).ValuesAsInteger['processid'] = ProcessID then
    begin
      curData := TableList.Add(PlayerList.Items(Loop).ID);
      CurData.ValuesAsString['name'] := PlayerList.Items(Loop).ValuesAsString['name'];
      CurData.ValuesAsString['amount'] := PlayerList.Items(Loop).ValuesAsString['amount'];
      CurData.ValuesAsString['city'] := PlayerList.Items(Loop).ValuesAsString['city'];
    end;
  end;

  if TableListView.ItemIndex >= 0 then
    if Integer(TableListView.Items.Item[TableListView.ItemIndex].Data) = ProcessID then
    begin
      if TableList.Count = 0 then
      begin
        TablePlayerListView.Clear;
        TablePlayerListView.ItemIndex := -1;
        FUpdatingNow := false;
        exit;
      end;

      curID := 0;
      if TablePlayerListView.ItemIndex >= 0 then
        curID := Integer(TablePlayerListView.Items.Item[TablePlayerListView.ItemIndex].Data);

      if TablePlayerListView.Items.Count <> TableList.Count then
        if TablePlayerListView.Items.Count < TableList.Count then
        repeat
          TablePlayerListView.Items.Add.SubItems.Add(' ');
        until TableList.Count = TablePlayerListView.Items.Count
        else
        repeat
          TablePlayerListView.Items.Delete(TablePlayerListView.Items.Count - 1);
        until TableList.Count = TablePlayerListView.Items.Count;

      for Loop := 0 to TableList.Count - 1 do
      begin
        curData := TableList.Items(Loop);
        curItem := TablePlayerListView.Items.Item[Loop];
        curItem.Caption := curData.ValuesAsString['name'] + '(' +
          curData.ValuesAsString['city'] + ')';
        curItem.Data := pointer(curData.ID);
        curItem.SubItems.Strings[0] := curData.ValuesAsString['amount'];
        if curData.ID = curID then
          curInd := Loop;
      end;
    end;

  FUpdatingNow := false;

  if (curInd >= 0) and (curInd < TablePlayerListView.Items.Count) then
    TablePlayerListView.ItemIndex := curInd
  else
    if TablePlayerListView.Items.Count > 0 then
      TablePlayerListView.ItemIndex := 0
    else
      TablePlayerListView.Items.Count := -1;

  TablePlayerListView.Invalidate;

  finally
    TableList.Free;
  end;
end;

procedure TTournamentLobbyForm.UpdatePlayerList(PlayerList: TDataList);
var
  Loop: Integer;
  curItem: TListItem;
  curData: TDataList;
  curID: Integer;
  curInd: Integer;
begin
  FUpdatingNow := true;
  FIsPlayer := false;
  FMyIndex := -1;

  if PlayerList.Count = 0 then
  begin
    PlayerListView.Clear;
    PlayerListView.ItemIndex := -1;
    FUpdatingNow := false;
    ViewPlayerDetailsButton.Enabled := false;
    UpdateCurrentUserInfo;
    exit;
  end;

  curInd := 0;
  curID := 0;
  if PlayerListView.ItemIndex >= 0 then
    curID := Integer(PlayerListView.Items.Item[PlayerListView.ItemIndex].Data);

  if PlayerListView.Items.Count <> PlayerList.Count then
    if PlayerListView.Items.Count < PlayerList.Count then
    repeat
      curItem := PlayerListView.Items.Add;
      curItem.SubItems.Add(' ');
      curItem.SubItems.Add(' ');
    until PlayerList.Count = PlayerListView.Items.Count
    else
    repeat
      PlayerListView.Items.Delete(PlayerListView.Items.Count - 1);
    until PlayerList.Count = PlayerListView.Items.Count;

  for Loop := 0 to PlayerList.Count - 1 do
  begin
    curData := PlayerList.Items(Loop);
    curItem := PlayerListView.Items.Item[Loop];
    curItem.Data := pointer(curData.ID);
    curItem.Caption := curData.ValuesAsString['place'];
    curItem.SubItems.Strings[0] := curData.ValuesAsString['name'] + ' (' +
      curData.ValuesAsString['city'] + ')';
    curItem.SubItems.Strings[1] := curData.ValuesAsString['amount'];
    if curData.ID = curID then
      curInd := Loop;
    if curData.ID = UserModule.UserID then
    begin
      FIsPlayer := true;
      FMyIndex := Loop;
      CurrentPlayerNoLabel.Caption := curData.ValuesAsString['place'];
      CurrentPlayerNameLabel.Caption := curData.ValuesAsString['name'] + ' (' +
      curData.ValuesAsString['city'] + ')';
      CurrentPlayerAmountLabel.Caption := curData.ValuesAsString['amount'];
    end;
  end;

  FUpdatingNow := false;

  if (curInd >= 0) and (curInd < PlayerListView.Items.Count) then
    PlayerListView.ItemIndex := curInd
  else
    if PlayerListView.Items.Count > 0 then
      PlayerListView.ItemIndex := 0
    else
      PlayerListView.Items.Count := -1;

  PlayerListView.Repaint;
  ViewPlayerDetailsButton.Enabled := true;
  UpdateCurrentUserInfo;
end;

procedure TTournamentLobbyForm.CurrentPlayerTimerTimer(Sender: TObject);
begin
  CurrentPlayerTimer.Enabled := false;
  UpdateCurrentUserInfo;
end;

procedure TTournamentLobbyForm.UpdateCurrentUserInfo;
var
  TopIndex: Integer;
  BottomIndex: Integer;
  ShowState: Integer;  // 0-dont show, 1-top, 2-bottom
begin
  ShowState := 0;
  if UserModule.Logged then
    if (PlayerListView.Items.Count > 0) and (FMyIndex >= 0) then
    begin
      TopIndex := PlayerListView.TopItem.Index;
      BottomIndex := TopIndex + PlayerListView.VisibleRowCount;

      if (FMyIndex < TopIndex) or (FMyIndex > BottomIndex) then
      begin
        if FMyIndex < TopIndex then
        begin
          ShowState := 2;
          if (not CurrentPlayerPanel.Visible) or (CurrentPlayerPanel.Top <> FPlayersListTop) then
          begin
            CurrentPlayerPanel.Top := FPlayersListTop;
            PlayerListView.Height := FPlayersListHeight - CurrentPlayerPanel.Height;
            PlayerListView.Top := CurrentPlayerPanel.Top + CurrentPlayerPanel.Height;
            CurrentPlayerPanel.Visible := true;
            PlayerListView.Refresh
          end;
        end
        else
        begin
          ShowState := 1;
          if (not CurrentPlayerPanel.Visible) or (CurrentPlayerPanel.Top = FPlayersListTop) then
          begin
            CurrentPlayerPanel.Top := FPlayersListTop + FPlayersListHeight - CurrentPlayerPanel.Height;
            PlayerListView.Top := FPlayersListTop;
            PlayerListView.Height := FPlayersListHeight - CurrentPlayerPanel.Height;
            CurrentPlayerPanel.Visible := true;
            PlayerListView.Refresh
          end;
        end;
      end;
    end;

  if ShowState = 0 then
    if CurrentPlayerPanel.Visible then
    begin
      CurrentPlayerPanel.Visible := false;
      PlayerListView.Height := FPlayersListHeight;
      PlayerListView.Top := FPlayersListTop;
    end;
  CurrentPlayerTimer.Enabled := true;
end;

procedure TTournamentLobbyForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TournamentModule.Do_Finish(ID);
end;

procedure TTournamentLobbyForm.TableListViewDrawItem(
  Sender: TCustomListView; Item: TListItem; Rect: TRect;
  State: TOwnerDrawState);
begin
  if (UserModule.Logged) and (UserModule.UserID > 0) and (Integer(Item.Data) = UserModule.UserID) then
  begin
    ThemeEngineModule.ListViewDrawItem(Sender, Item, Rect, State, CurrentPlayerPanel.Color);
    UpdateCurrentUserInfo;
  end
  else
    ThemeEngineModule.ListViewDrawItem(Sender, Item, Rect, State);
end;

procedure TTournamentLobbyForm.PrizePoolDetailsButtonClick(
  Sender: TObject);
begin
  if FURL <> '' then
    ShellExecute(0,pchar('open'),pchar(FURL),nil,nil,SW_RESTORE);
end;


procedure TTournamentLobbyForm.CreateTournamentInfoForm(Caption, StartingChips: string;LevelsData,PrizesData: TDataList);
begin
 if not TournamentInfoFormOpened then
 begin
  TournamentInfoFormOpened := true;
  TournamentInfoForm := TTournamentInfoForm.CreateParented(0);
  TournamentInfoForm.OnClose := TournamentInfoFormClose;
  TournamentInfoForm.LevelsData := LevelsData;
  TournamentInfoForm.PrizesData := PrizesData;
  TournamentInfoForm.Caption :=  'Tournament #'+ Caption + ' Info';
  TournamentInfoForm.StartingChips := StartingChips;
  TournamentInfoForm.ShowForm;
 end
 else
  TournamentInfoForm.ShowForm;
end;

procedure TTournamentLobbyForm.TournamentInfoFormClose(Sender: TObject; var Action: TCloseAction);
begin
  TournamentInfoFormOpened := false;
end;
end.
