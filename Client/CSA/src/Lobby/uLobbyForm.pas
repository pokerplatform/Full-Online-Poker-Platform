unit uLobbyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, Menus, te_controls, uThemeEngineModule, te_engine, te_theme,
  OleCtrls, ShockwaveFlashObjects_TLB, ComCtrls, ImgList, CommCtrl,
  uDataList, StdCtrls, AppEvnts, Mask,
  xmldom, XMLIntf, msxmldom, XMLDoc, GIFImage, SHDocVw, JvComponent,
  JvxCtrls, XPMan;

const
  SubCategoryButtonName = 'SubCategoryButton';

  ProcessListRowHeight = 15;
  TextMargin = 3;
  ProcessInfoRowHeight = 15;
  InfoTitleHeight = 21;
  InfoTitleOffset = 4;
  InfoGroupTextMargin = 5;
  InfoTextMargin = 15;

type
  TLobbyForm = class(TForm)
    HeaderSortImageList: TImageList;
    MenuPopupTimer: TTimer;
    ApplicationEvents: TApplicationEvents;
    LobbyBackgroundImage: TImage;
    TotalPlayersLabel: TLabel;
    SubCategoryPlayersLabel: TLabel;
    TotalTablesLabel: TLabel;
    SubCategoryTableLabel: TLabel;
    ProcessListScrollBar: TTeScrollBar;
    LobbyProcessListHeader: TTeHeaderControl;
    ProcessListFocusEdit: TEdit;
    CashierButton: TTeButton;
    ProcessListPanel: TTeHeaderPanel;
    ProcessListImage: TImage;
    ProcessInfoPanel: TTeHeaderPanel;
    ProcessInfoImage: TImage;
    FixedLimitButton: TTeSpeedButton;
    NoLimitButton: TTeSpeedButton;
    PlayMoneyButton: TTeSpeedButton;
    TournamentButton1: TTeSpeedButton;
    TournamentButton2: TTeSpeedButton;
    TournamentButton4: TTeSpeedButton;
    TournamentButton3: TTeSpeedButton;
    TournamentButton5: TTeSpeedButton;
    TournamentButton6: TTeSpeedButton;
    ShockwaveFlash: TShockwaveFlash;
    BlackJackButton: TTeButton;
    SubCategoryPanel: TTeHeaderPanel;
    LobbyProcessInfoHeader: TTeHeaderControl;
    LobbyHeaderImage: TImage;
    BTeHeaderPanel1: TTeHeaderPanel;
    WaitingListButton: TTeButton;
    GoToTableButton: TTeButton;
    TournamentLobbyButton: TTeButton;
    LoyalityPokerButton: TTeSpeedButton;
    TournamentButton7: TTeSpeedButton;
    MainMenu: TMainMenu;
    Lobby1: TMenuItem;
    Account1: TMenuItem;
    Requests1: TMenuItem;
    Options1: TMenuItem;
    ournamentLeaderBoard1: TMenuItem;
    Help1: TMenuItem;
    LoginMenuItem: TMenuItem;
    N1: TMenuItem;
    CashierMenuItem: TMenuItem;
    N2: TMenuItem;
    ExitMenuItem: TMenuItem;
    CreateNewAccountMenuItem: TMenuItem;
    ValidateEmailAddress: TMenuItem;
    ChangePlayerLogoMenuItem: TMenuItem;
    ChangeAccount1: TMenuItem;
    ChangePasswordItem: TMenuItem;
    ChangeMailingAddressItem: TMenuItem;
    ChangeProfileItem: TMenuItem;
    RecordedHandsItem: TMenuItem;
    RequestHandHistoryMenuItem: TMenuItem;
    ViewProcessStatsMenuItemViewProcessStatsMenuItem: TMenuItem;
    FindPlayerMenuItem: TMenuItem;
    TransferFundsMenuItem: TMenuItem;
    Use4ColorsDeckMenuItem: TMenuItem;
    EnableAnimationMenuItem: TMenuItem;
    EnableSoundsMenuItem: TMenuItem;
    ThisWeekMenuItem: TMenuItem;
    ThismonthMenuItem: TMenuItem;
    ThisyearMenuItem: TMenuItem;
    PrevWeekMenuItem: TMenuItem;
    PrevMonthMenuItem: TMenuItem;
    PrevYearMenuItem: TMenuItem;
    TournamentLeaderPointsMenuItem: TMenuItem;
    HelpMenuItem: TMenuItem;
    GameRulesMenuItem: TMenuItem;
    TipMenuItem: TMenuItem;
    N3: TMenuItem;
    NewsMenuItem: TMenuItem;
    N4: TMenuItem;
    CustomSupportItem: TMenuItem;
    NetworkStatusMenuItem: TMenuItem;
    N5: TMenuItem;
    AboutMenuItem: TMenuItem;
    HideCompletedTournamentsItem: TMenuItem;
    HideRunningTournamentsItem: TMenuItem;
    HideFullTablesItem: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    GetMoreChipsMenuItem: TMenuItem;
    ServerTimeLabel: TJvxLabel;
    MasterTournamentIDLabel: TLabel;
    SendLogFileItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GoToTableButtonClick(Sender: TObject);
    procedure CashierButtonClick(Sender: TObject);
    procedure WaitingListButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GoToTableMenuItemClick(Sender: TObject);
    procedure WaitingListMenuItemClick(Sender: TObject);
    procedure HidePlayMoneyTablesMenuItemClick(Sender: TObject);
    procedure CashierMenuItemClick(Sender: TObject);
    procedure LoginMenuItemClick(Sender: TObject);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure SubcategoryMenuItemClick(Sender: TObject);
    procedure ShowProcessItemMenuClick(Sender: TObject);
    procedure AllInsRemainingMenuItemClick(Sender: TObject);
    procedure RequestAllInsResetMenuItemClick(Sender: TObject);
    procedure RequestHandHistoryMenuItemClick(Sender: TObject);
    procedure ChangeValidateEmailMenuItemClick(Sender: TObject);
    procedure ChangeMailingAddressMenuItemClick(Sender: TObject);
    procedure ChangePasswordMenuItemClick(Sender: TObject);
    procedure Use4ColorsDeckMenuItemClick(Sender: TObject);
    procedure EnableAnimationMenuItemClick(Sender: TObject);
    procedure EnableChatBubblesMenuItemClick(Sender: TObject);
    procedure EnableSoundsMenuItemClick(Sender: TObject);
    procedure ReverseStereoPanningMenuItemClick(Sender: TObject);
    procedure LobbyProcessListHeaderSectionClick(
      EkHeaderControl: TTeHeaderControl; Section: TTeHeaderSection);
    procedure LobbyProcessListHeaderSectionResize(
      EkHeaderControl: TTeHeaderControl; Section: TTeHeaderSection);
    procedure ProcessListScrollBarChange(Sender: TObject);
    procedure ProcessListImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ProcessListImageDblClick(Sender: TObject);
    procedure ProcessListFocusEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChangeProfileMenuItemClick(Sender: TObject);
    procedure ViewProcessStatsMenuItemClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure AboutMenuItemClick(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
    procedure MenuButtonClick(Sender: TObject);
    procedure MenuPopupTimerTimer(Sender: TObject);
    procedure RecordedHandsItemClick(Sender: TObject);
    procedure CustomSupportItemClick(Sender: TObject);
    procedure ChangeValidateMenuItemClick(Sender: TObject);
    procedure ChangePlayerMenuItemClick(Sender: TObject);
    procedure CreateNewAccountItemMenuItemMenuClick(Sender: TObject);
    procedure HelpMenuItemClick(Sender: TObject);
    procedure GameRulesMenuItemClick(Sender: TObject);
    procedure TipMenuItemClick(Sender: TObject);
    procedure NewsMenuItemClick(Sender: TObject);
    procedure WhatsNewMenuItemClick(Sender: TObject);
    procedure ChooseMenuItemClick(Sender: TObject);
    procedure NetworkStatusMenuItemClick(Sender: TObject);
    procedure ShockwaveFlashFSCommand(ASender: TObject; const command,
      args: WideString);
    procedure WOWLabelDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure ApplicationEventsDeactivate(Sender: TObject);
    procedure FixedLimitButtonClick(Sender: TObject);
    procedure NoLimitButtonClick(Sender: TObject);
    procedure PlayMoneyButtonClick(Sender: TObject);
    procedure HideWelcomeMessageItemClick(Sender: TObject);
    procedure BannerBrowserDocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure BannerBrowserNavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure BlackJackButtonClick(Sender: TObject);
    procedure TransferFundsMenuItemClick(Sender: TObject);
    procedure LobbyProcessListHeaderMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LobbyHeaderImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MainMenuMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TournamentLobbyButtonClick(Sender: TObject);
    procedure FindPlayerMenuItemClick(Sender: TObject);
    procedure ThisWeekMenuItemClick(Sender: TObject);
    procedure ThismonthMenuItemClick(Sender: TObject);
    procedure ThisyearMenuItemClick(Sender: TObject);
    procedure PrevWeekMenuItemClick(Sender: TObject);
    procedure PrevMonthMenuItemClick(Sender: TObject);
    procedure PrevYearMenuItemClick(Sender: TObject);
    procedure TournamentLeaderPointsMenuItemClick(Sender: TObject);
    procedure MainMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HideCompletedTournamentsItemClick(Sender: TObject);
    procedure HideRunningTournamentsItemClick(Sender: TObject);
    procedure HideFullTablesItemClick(Sender: TObject);
    procedure GetMoreChipsMenuItemClick(Sender: TObject);
    procedure ProgressiveButtonClick(Sender: TObject);
    procedure MasterTournamentIDLabelMouseEnter(Sender: TObject);
    procedure MasterTournamentIDLabelMouseLeave(Sender: TObject);
    procedure MasterTournamentIDLabelClick(Sender: TObject);
    procedure SendLogFileItemClick(Sender: TObject);
  private
    FUpdatingNow: Boolean;
    //curControl: TTeButton;

    FSubCategoriesButtonArray: Array of TTeButton;
    FDrawedSubCategoryID: Integer;

    FProcessListTopIndex: Integer;
    ProcessListBackground: TBitmap;
    ProcessListDrawBackground: TBitmap;
    ProcessListPainting: TBitmap;
    ProcessInfoBackground: TBitmap;
    ProcessInfoPainting: TBitmap;
    RowCount: Integer;
    curMasterTournamentID: Integer;

    procedure SubcategoryButtonClick(Sender: TObject);
    procedure JoinProcess;
    procedure UpdateProcessList;
    procedure UpdateProcessListColumns;
    procedure ProcessListChangeIndex(NewIndex: Integer);
    procedure PrepareBitmaps;
    function  CalculateAverageColor(TransparentPercent: Integer; Color1,
      Color2: TColor): TColor;
    procedure UpdateMenu;
    procedure UpdateProcessListColumnsConstraints;
    procedure SendOptions(Command: String);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure StartWork;
    procedure StopWork;
    procedure ShowLobby;
    procedure MinimizeLobby;
    procedure UpdateLoginState;
    procedure UpdateSummary;
    procedure UpdateCategories;
    procedure UpdateProcesses;
    procedure UpdateProcessInfo;
    procedure UpdateOptions;
    procedure UpdateButtonsState;
  end;

var
  LobbyForm: TLobbyForm;

implementation

uses
  uLogger,
  uSessionModule,
  uConstants,
  uProcessModule,
  uLobbyModule,
  uParserModule,
  uDebugForm,
  StrUtils,
  Types,
  uUserModule, uFileManagerModule, uTournamentLobbyForm,
  uBlackJackWelcomeForm, uWelcomeMessageForm, uTournamentModule;

{$R *.dfm}

procedure TLobbyForm.FormCreate(Sender: TObject);
begin
  //BannerBrowser.Navigate(cstrBannerLink);
  ThemeEngineModule.FormsChangeConstraints(Self,
    LobbyBackgroundImage.Width, LobbyBackgroundImage.Height);

  Caption := AppName + ' - Lobby';
  //TeForm.Caption := Caption;

  NewsMenuItem.Caption := 'Display "' + AppName + '.com News" window';
  //WhatsNewMenuItem.Caption := 'What''s new at ' + AppName;
  //ChooseMenuItem.Caption := 'Why choose ' + AppName;
  //AboutMenuItem.Caption := 'About ' + AppName + '.com client';

  LobbyModule.OnStartWork := StartWork;
  LobbyModule.OnStopWork := StopWork;
  LobbyModule.OnShowLobby := ShowLobby;
  LobbyModule.OnMinimizeLobby := MinimizeLobby;

  LobbyModule.OnUpdateSummary := UpdateSummary;
  LobbyModule.OnUpdateCategories := UpdateCategories;
  LobbyModule.OnUpdateProcesses := UpdateProcesses;
  LobbyModule.OnUpdateProcessInfo := UpdateProcessInfo;
  LobbyModule.OnUpdateOptions := UpdateOptions;


  FUpdatingNow := false;

  SetLength(FSubCategoriesButtonArray, 0);
  FDrawedSubCategoryID := 0;
  RowCount := ProcessListImage.Height div ProcessListRowHeight;

  ProcessInfoBackground := TBitmap.Create;
  ProcessInfoPainting := TBitmap.Create;
  ProcessListPainting := TBitmap.Create;
  ProcessListBackground := TBitmap.Create;
  ProcessListDrawBackground := TBitmap.Create;
  PrepareBitmaps;

  FProcessListTopIndex := 0;
  ProcessListFocusEdit.Top := 5000;
end;

procedure TLobbyForm.FormDestroy(Sender: TObject);
begin
  ProcessListBackground.Free;
  ProcessListDrawBackground.Free;
  ProcessListPainting.Free;

  LobbyModule.OnStartWork := nil;
  LobbyModule.OnStopWork := nil;
  LobbyModule.OnUpdateSummary := nil;
  LobbyModule.OnUpdateCategories := nil;
  LobbyModule.OnUpdateProcesses := nil;
  LobbyModule.OnUpdateProcessInfo := nil;
  LobbyModule.OnUpdateOptions := nil;
end;

procedure TLobbyForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TLobbyForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  SessionModule.CloseApplication;
end;

procedure TLobbyForm.StartWork;
begin
  Logger.Add('LobbyForm.StartWork', llVerbose);
  UpdateCategories;
  UpdateProcesses;
  UpdateProcessInfo;
  UpdateSummary;
  UpdateButtonsState;

  if FileExists(FileManagerModule.FilesPath + LobbyModule.BannerFileName) then
  begin
    ShockwaveFlash.Visible := True;
    ShockwaveFlash.Movie := FileManagerModule.FilesPath + LobbyModule.BannerFileName;
    ShockwaveFlash.Play;
  end
  else
    ShockwaveFlash.Visible := false;

  UpdateLoginState;
  ShowLobby;
  WelcomeMessageForm.ShowForm;
end;

procedure TLobbyForm.UpdateLoginState;
var
  UserSessionInfo: String;
begin
  UserSessionInfo := UserModule.GetUserSessionInfo;
  if UserSessionInfo <> '' then
  begin
    Caption := AppName + ' - Lobby ' + UserSessionInfo;
    //TeForm.Caption := Caption;
  end;
end;

procedure TLobbyForm.StopWork;
begin
  OnCloseQuery := nil;
  Hide;
end;

procedure TLobbyForm.MinimizeLobby;
begin
  WindowState := wsMinimized;
end;

procedure TLobbyForm.ShowLobby;
begin
  WindowState := wsNormal;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;


// Update procedures

procedure TLobbyForm.UpdateSummary;
var
  curCategory: TDataList;
  curSubCategory: TDataList;
begin
  UpdateLoginState;

  TotalPlayersLabel.Caption := inttostr(LobbyModule.PlayersCount) + cstrLobbyTotalPlayers;
  TotalTablesLabel.Caption := inttostr(LobbyModule.ProcessesCount) + cstrLobbyTotalProcesses;
  ServerTimeLabel.Caption := LobbyModule.ServerTime;

  if LobbyModule.Data.Find(LobbyModule.CurrentCategoryID, curCategory) then
    if curCategory.Find(LobbyModule.CurrentSubCategoryID, curSubCategory) then
      if curSubCategory.ID <> TournamentSubCategoryID then
      begin
        SubCategoryPlayersLabel.Caption :=
          inttostr(curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT]) + ' ' +
          curSubCategory.Name + cstrLobbySubCategoryPlayers;
        SubCategoryTableLabel.Caption :=
          inttostr(curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT]) +
          cstrLobbySubCategoryProcesses;
      end
      else
      begin
        SubCategoryPlayersLabel.Caption :=
          inttostr(curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT]) +
          cstrLobbySubCategoryTournamentPlayers;
        SubCategoryTableLabel.Caption :=
          inttostr(curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT]) +
          cstrLobbySubCategoryTournaments;
      end;
end;

procedure TLobbyForm.JoinProcess;
begin
  LobbyModule.Do_JoinProcess(LobbyModule.CurrentProcessID);
end;


// Main Menu

procedure TLobbyForm.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  ApplicationEvents.OnMessage := nil;
  
  {LobbyMenuButton.Enabled := true;
  AccountMenuButton.Enabled := true;
  OptionsMenuButton.Enabled := true;
  RequestsMenuButton.Enabled := true;
  HelpMenuButton.Enabled := true;{}
end;

procedure TLobbyForm.MenuButtonClick(Sender: TObject);
begin
 // curControl := Sender as TTeButton;
 MenuPopupTimer.Enabled:= true;
 UpdateMenu;
end;

procedure TLobbyForm.MenuPopupTimerTimer(Sender: TObject);
begin
  MenuPopupTimer.Enabled := false;
  UpdateMenu;
end;

procedure TLobbyForm.UpdateMenu;
//var
  //Loop: Integer;
 // curMenuItem: TTeItem;
 // curCategory: TDataList;
 // curSubcategory: TDataList;
 // curProcessList: TStringList;
begin
  //if curControl.PopupMenu <> nil then
  begin
   // if curControl.PopupMenu = AccountPopupMenu then
     CreateNewAccountMenuItem.Enabled := not UserModule.Logged;
  //  if curControl.PopupMenu = LobbyPopupMenu then
    begin
      LoginMenuItem.Enabled := not UserModule.Logged;

      {HidePlayMoneyTablesMenuItem.Checked :=
        SessionModule.SessionSettings.ValuesAsBoolean[SessionHidePlayMoneyTables];{}
     { Loop := 0;
      repeat
        curMenuItem := LobbyPopupMenu.Items.Items[Loop];
        if curMenuItem.Tag <> 0 then
          LobbyPopupMenu.Items.Delete(Loop)
        else
          Inc(Loop);
      until Loop >= LobbyPopupMenu.Items.Count;{}

      {if LobbyModule.Data.Find(LobbyModule.CurrentCategoryID, curCategory) then
        for Loop := curCategory.Count - 1 downto 0 do
        begin
          curSubcategory := curCategory.Items(Loop);
          curMenuItem := TTeItem.Create(LobbyPopupMenu);
          curMenuItem.Caption := curSubcategory.Name;
          curMenuItem.Tag := curSubcategory.ID;
          curMenuItem.OnClick := SubcategoryMenuItemClick;
          curMenuItem.Checked := curMenuItem.Tag = LobbyModule.CurrentSubCategoryID;
          LobbyPopupMenu.Items.Insert(4, curMenuItem);
        end;{}

      //curProcessList := TStringList.Create;
      //ShowProcessItemMenu.Visible := not ProcessModule.GetProcessList(curProcessList);
      {if not ShowProcessItemMenu.Visible then
        for Loop := 0 to curProcessList.Count - 1 do
        begin
          curMenuItem := TTeItem.Create(LobbyPopupMenu);
          curMenuItem.Caption := curProcessList.Strings[Loop];
          curMenuItem.Tag := integer(curProcessList.Objects[Loop]);
          curMenuItem.OnClick := ShowProcessItemMenuClick;
          LobbyPopupMenu.Items.Insert(LobbyPopupMenu.Items.Count - 8, curMenuItem);
        end;
      curProcessList.Free;{}
    end;

      Use4ColorsDeckMenuItem.Checked       := SessionModule.SessionSettings.ValuesAsBoolean[SessionUse4ColorsDeck];
      EnableAnimationMenuItem.Checked      := SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableAnimation];
     // EnableChatBubblesMenuItem.Checked    := SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableChatBubbles];
      EnableSoundsMenuItem.Checked         := SessionModule.SessionSettings.ValuesAsBoolean[SessionEnableSounds];
      HideCompletedTournamentsItem.Checked := SessionModule.SessionSettings.ValuesAsBoolean[SessionHideCompletedTournamens];
      HideRunningTournamentsItem.Checked   := SessionModule.SessionSettings.ValuesAsBoolean[SessionHideRunningTournamens];
      HideFullTablesItem.Checked           := SessionModule.SessionSettings.ValuesAsBoolean[SessionHideFullTables];
      //ReverseStereoPanningMenuItem.Checked := SessionModule.SessionSettings.ValuesAsBoolean[SessionReverseStereoPanning];
     // HideWelcomeMessageItem.Checked       := SessionModule.SessionSettings.ValuesAsBoolean[SessionHideWelcomeMessage];{}

    SendLogFileItem.Visible := false; 
    if (SessionModule.SessionSettings.ValuesAsString[RegistryDebugIdent] = RegistryDebugVerbose) and
       (SessionModule.SessionSettings.ValuesAsString[RegistryDebugKey] = '1') then
     SendLogFileItem.Visible := true;
    ApplicationEvents.OnMessage := ApplicationEventsMessage;
  end;
end;

procedure TLobbyForm.GoToTableMenuItemClick(Sender: TObject);
begin
  JoinProcess;
end;

procedure TLobbyForm.WaitingListMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laWaitingList);
end;

procedure TLobbyForm.HidePlayMoneyTablesMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laHidePlayMoneyTables);
end;

procedure TLobbyForm.SubcategoryMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_ChooseSubCategory((Sender as TComponent).Tag);
  UpdateCategories;
end;

procedure TLobbyForm.ShowProcessItemMenuClick(Sender: TObject);
begin
  LobbyModule.Do_JoinProcess((Sender as TComponent).Tag);
end;

procedure TLobbyForm.CashierMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laCashier);
end;

procedure TLobbyForm.CreateNewAccountItemMenuItemMenuClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laNewAccount);
end;

procedure TLobbyForm.LoginMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laLogin);
end;

procedure TLobbyForm.ExitMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laExit);
end;

procedure TLobbyForm.AllInsRemainingMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laAllInsRemaining);
end;

procedure TLobbyForm.RequestAllInsResetMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laRequestAllInsReset);
end;

procedure TLobbyForm.RequestHandHistoryMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laRequestHandHistory);
end;

procedure TLobbyForm.ViewProcessStatsMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laViewStatistics);
end;

procedure TLobbyForm.TransferFundsMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laTrunsferFunds);
end;

procedure TLobbyForm.FindPlayerMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laFindPlayer);
end;

procedure TLobbyForm.ChangeProfileMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laChangeProfile);
end;

procedure TLobbyForm.ChangeValidateEmailMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laChangeValidateEmail);
end;

procedure TLobbyForm.ChangeMailingAddressMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laChangeMailingAddress);
end;

procedure TLobbyForm.ChangePasswordMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laChangePassword);
end;

procedure TLobbyForm.Use4ColorsDeckMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laUse4ColorsDeck);
end;

procedure TLobbyForm.EnableAnimationMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laEnableAnimation);
end;

procedure TLobbyForm.EnableChatBubblesMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laEnableChatBubbles);
end;

procedure TLobbyForm.EnableSoundsMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laEnableSounds);
end;

procedure TLobbyForm.ReverseStereoPanningMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laReverseStereoPanning);
end;


// Buttons events

procedure TLobbyForm.GoToTableButtonClick(Sender: TObject);
begin
  JoinProcess;
end;

procedure TLobbyForm.TournamentLobbyButtonClick(Sender: TObject);
var Loop : Integer;
begin
 for Loop := 0 to 4 do
 begin
  if FSubCategoriesButtonArray[Loop].Tag = -7 then
    SubcategoryButtonClick(FSubCategoriesButtonArray[Loop]);
 end;
  //SubcategoryButtonClick(Sender);
  LobbyModule.UpdateTimer.Enabled := true;
  JoinProcess;
end;


procedure TLobbyForm.WaitingListButtonClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laWaitingList);
end;

procedure TLobbyForm.CashierButtonClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laCashier);
end;


// Categories

procedure TLobbyForm.UpdateCategories;
var
  Loop: Integer;
  curControl: TControl;
  curCategory: TDataList;
  curSubCategory: TDataList;
  NewButton: TTeButton;
begin
 //exit;
  Loop := 0;

  repeat
    curControl := Controls[Loop];
    if (curControl.ClassName = 'TTeButton') and
      (LeftStr(curControl.Name, length(SubCategoryButtonName)) = SubCategoryButtonName) then
      curControl.Free
    else
      Inc(Loop);
  until Loop >= ControlCount;

  if LobbyModule.Data.Find(LobbyModule.CurrentCategoryID, curCategory) then
  begin
    SetLength(FSubCategoriesButtonArray, curCategory.Count);

    for Loop := 0 to curCategory.Count - 1 do
    begin
      curSubCategory := curCategory.Items(Loop);
     if FSubCategoriesButtonArray[Loop] = nil then
     begin
      NewButton := TTeButton.Create(Self);
      NewButton.Visible := false;
      NewButton.Parent := SubCategoryPanel;
      NewButton.Name := SubCategoryButtonName + inttostr(Loop);
      NewButton.Caption := curSubcategory.Name;
      NewButton.Tag := curSubcategory.ID;

      if Loop = 0 then
        NewButton.ThemeObject := 'SubCategoryButton'
      else
        NewButton.ThemeObject := 'SubCategoryButton';
      NewButton.Performance := kspDoubleBuffer;
      NewButton.DrawLeftAlignment := false;
      NewButton.TextMargin := 10;
      NewButton.Height := 27;
      NewButton.Width := 99;
      NewButton.Left := Loop*(NewButton.Width + 4);//LobbyProcessListHeader.Left + Loop*(NewButton.Width+7) ;
      NewButton.Top := 5;
      NewButton.Spacing := 0;
      NewButton.Cursor := crHandPoint;
      NewButton.OnClick := SubcategoryButtonClick;
      NewButton.Enabled := curSubcategory.ID <> LobbyModule.CurrentSubCategoryID;
      NewButton.Transparent := false;
      NewButton.Visible := true;
      FSubCategoriesButtonArray[Loop] := NewButton;
     end;
    end;
  end;
end;

procedure TLobbyForm.SubcategoryButtonClick(Sender: TObject);
var
  Loop: Integer;
  curControl: TControl;
begin
  for Loop := 0 to Length(FSubCategoriesButtonArray) - 1 do
  begin
    curControl := FSubCategoriesButtonArray[Loop];
    if not curControl.Enabled then
      (curControl as TTeButton).Enabled := true;
  end;
  (Sender as TTeButton).Enabled := false;
  
  LobbyModule.Do_ChooseSubCategory((Sender as TControl).Tag);
  UpdateButtonsState;
  FDrawedSubCategoryID := 0;
end;

procedure TLobbyForm.UpdateButtonsState;
begin
  if (LobbyModule.CurrentSubCategoryID > 0)and (LobbyModule.CurrentSubCategoryID <= 5)  then
  begin
    FixedLimitButton.Visible := true;
    NoLimitButton.Visible := true;
    PlayMoneyButton.Visible := true;
    LoyalityPokerButton.Visible := true;
    LobbyModule.isTournament := false;
    TournamentButton1.Visible := false;
    TournamentButton2.Visible := false;
    TournamentButton3.Visible := false;
    TournamentButton4.Visible := false;
    TournamentButton5.Visible := false;
    TournamentButton6.Visible := false;
    TournamentButton7.Visible := false;
    //WaitingListButton.Visible := true;
    WaitingListButton.Enabled := true;
    //GoToTableButton.Caption := 'Go to Tabel';
    LobbyProcessInfoHeader.Visible := true;
  end
  else
  begin
    FixedLimitButton.Visible := false;
    NoLimitButton.Visible := false;
    PlayMoneyButton.Visible := false;
    LoyalityPokerButton.Visible := false;
    TournamentButton1.Visible := true;
    TournamentButton2.Visible := true;
    TournamentButton3.Visible := true;
    TournamentButton4.Visible := true;
    TournamentButton5.Visible := true;
    TournamentButton6.Visible := true;
    TournamentButton7.Visible := true;
    if (LobbyModule.CurrentSubCategoryID = 17) then
    begin
      LobbyModule.isTournament := true;
      TournamentButton1.Caption := 'All';
      TournamentButton2.Caption := '1-Table';
      TournamentButton3.Caption := '2-Table';
      TournamentButton4.Caption := 'Heads-Up';
      TournamentButton5.Caption := 'Satellite';
      TournamentButton6.Caption := 'Play Money';
      TournamentButton7.Caption := 'Loyalty Points';
      WaitingListButton.Enabled := true;
      //GoToTableButton.Caption := 'Go to Tabel';
      LobbyProcessInfoHeader.Visible := true;
    end
    else
    if (LobbyModule.CurrentSubCategoryID = -7) then
    begin
      LobbyModule.isTournament := true;
      TournamentButton1.Caption := 'All';
      TournamentButton2.Caption := 'Regular';
      TournamentButton3.Caption := 'Satellite';
      TournamentButton4.Caption := 'Special';
      TournamentButton5.Caption := 'Freeroll';
      TournamentButton6.Caption := 'Private';
      TournamentButton7.Caption := 'Loyalty Points';
      WaitingListButton.Enabled := false;
      //GoToTableButton.Caption := 'Tournament Lobby';
      LobbyProcessInfoHeader.Visible := false;
    end
    else
    if (LobbyModule.CurrentSubCategoryID = -8) then
    begin
      LobbyModule.isTournament := true;
      TournamentButton1.Caption := 'All';
      TournamentButton2.Caption := '1-Table';
      TournamentButton3.Caption := '2-Table';
      TournamentButton4.Caption := 'Heads-Up';
      TournamentButton5.Caption := 'Satellite';
      TournamentButton6.Caption := 'Play Money';
      TournamentButton7.Caption := 'Loyalty Points';
      WaitingListButton.Enabled := false;
      //GoToTableButton.Caption := 'Go to Tabel';
      LobbyProcessInfoHeader.Visible := false;
    end
  end;
end;

// Lobby process list

procedure TLobbyForm.UpdateProcesses;
var
  Loop: Integer;
  divCount: Integer;
  FirstColumnWidth: Integer;
  ColumnWidth: Integer;
begin
  // Update columns width
  // Check for new subcategory
  //LobbyProcessListHeader.Sections.clear;
  if (FDrawedSubCategoryID <> LobbyModule.CurrentSubCategoryID) or
    (LobbyModule.CurrentColumns.Count <> LobbyProcessListHeader.Sections.Count) or
    (LobbyProcessListHeader.Sections.Count = 0) then
  begin
    FProcessListTopIndex := 0;
    if LobbyModule.CurrentColumns <> nil then
      if LobbyModule.CurrentColumns.Count > 0 then
        if LobbyModule.CurrentColumns.Count = 1 then
          LobbyModule.CurrentColumns.Items(0).ValuesAsInteger['width'] :=
            LobbyProcessListHeader.Width + 2
        else
        if (LobbyModule.CurrentSubCategoryID = TournamentSubCategoryID) and
          (LobbyModule.CurrentColumns.Count = 8) then
        begin
            LobbyModule.CurrentColumns.Items(0).ValuesAsInteger['width'] := 38;
            LobbyModule.CurrentColumns.Items(1).ValuesAsInteger['width'] := 80;
            LobbyModule.CurrentColumns.Items(2).ValuesAsInteger['width'] := 130;
            LobbyModule.CurrentColumns.Items(3).ValuesAsInteger['width'] := 67;
            LobbyModule.CurrentColumns.Items(4).ValuesAsInteger['width'] := 35;
            LobbyModule.CurrentColumns.Items(5).ValuesAsInteger['width'] := 44;
            LobbyModule.CurrentColumns.Items(6).ValuesAsInteger['width'] := 65;
            LobbyModule.CurrentColumns.Items(7).ValuesAsInteger['width'] := 55;  {}
        end
        else
        if (LobbyModule.CurrentSubCategoryID = SitAndGoSubCategoryID) and
           (LobbyModule.CurrentColumns.Count = 7) then
        begin
          LobbyModule.CurrentColumns.Items(0).ValuesAsInteger['width'] := 38;
          LobbyModule.CurrentColumns.Items(1).ValuesAsInteger['width'] := 150;
          LobbyModule.CurrentColumns.Items(2).ValuesAsInteger['width'] := 100;
          LobbyModule.CurrentColumns.Items(3).ValuesAsInteger['width'] := 50;
          LobbyModule.CurrentColumns.Items(4).ValuesAsInteger['width'] := 55;
          LobbyModule.CurrentColumns.Items(5).ValuesAsInteger['width'] := 60;
          LobbyModule.CurrentColumns.Items(6).ValuesAsInteger['width'] := 60;
        end
        else
        begin
          if LobbyModule.CurrentColumns.Count = 9 then
          begin
            LobbyModule.CurrentColumns.Items(0).ValuesAsInteger['width'] := 115;
            LobbyModule.CurrentColumns.Items(1).ValuesAsInteger['width'] := 55;
            LobbyModule.CurrentColumns.Items(2).ValuesAsInteger['width'] := 95;
            LobbyModule.CurrentColumns.Items(3).ValuesAsInteger['width'] := 35;
            LobbyModule.CurrentColumns.Items(4).ValuesAsInteger['width'] := 35;
            LobbyModule.CurrentColumns.Items(5).ValuesAsInteger['width'] := 40;
            LobbyModule.CurrentColumns.Items(6).ValuesAsInteger['width'] := 55;
            LobbyModule.CurrentColumns.Items(7).ValuesAsInteger['width'] := 50;
            LobbyModule.CurrentColumns.Items(8).ValuesAsInteger['width'] := 35;
          end
          else
          if LobbyModule.CurrentColumns.Count = 8 then
          begin
            LobbyModule.CurrentColumns.Items(0).ValuesAsInteger['width'] := 115;
            LobbyModule.CurrentColumns.Items(1).ValuesAsInteger['width'] := 65;
            LobbyModule.CurrentColumns.Items(2).ValuesAsInteger['width'] := 65;
            LobbyModule.CurrentColumns.Items(3).ValuesAsInteger['width'] := 60;
            LobbyModule.CurrentColumns.Items(4).ValuesAsInteger['width'] := 55;
            LobbyModule.CurrentColumns.Items(5).ValuesAsInteger['width'] := 55;
            LobbyModule.CurrentColumns.Items(6).ValuesAsInteger['width'] := 55;
            LobbyModule.CurrentColumns.Items(7).ValuesAsInteger['width'] := 45;
          end
          else
          if LobbyModule.CurrentColumns.Count = 7 then
          begin
            LobbyModule.CurrentColumns.Items(0).ValuesAsInteger['width'] := 38;
            LobbyModule.CurrentColumns.Items(1).ValuesAsInteger['width'] := 150;
            LobbyModule.CurrentColumns.Items(2).ValuesAsInteger['width'] := 100;
            LobbyModule.CurrentColumns.Items(3).ValuesAsInteger['width'] := 50;
            LobbyModule.CurrentColumns.Items(4).ValuesAsInteger['width'] := 55;
            LobbyModule.CurrentColumns.Items(5).ValuesAsInteger['width'] := 60;
            LobbyModule.CurrentColumns.Items(6).ValuesAsInteger['width'] := 60;
          end
          else
          begin
            divCount := LobbyModule.CurrentColumns.Count;
            if LobbyModule.CurrentColumns.Count > 4 then
              divCount := 4;
            FirstColumnWidth := LobbyProcessListHeader.Width div divCount;
            ColumnWidth := (LobbyProcessListHeader.Width - FirstColumnWidth) div
              (LobbyModule.CurrentColumns.Count - 1);
            LobbyModule.CurrentColumns.Items(0).ValuesAsInteger['width'] := FirstColumnWidth;
            LobbyModule.CurrentColumns.Items(LobbyModule.CurrentColumns.Count - 1).
              ValuesAsInteger['width'] := LobbyProcessListHeader.Width + 2 - FirstColumnWidth -
                  ColumnWidth * (LobbyModule.CurrentColumns.Count - 2);
            if LobbyModule.CurrentColumns.Count > 2 then
              for Loop := 1 to LobbyModule.CurrentColumns.Count - 2 do
                LobbyModule.CurrentColumns.Items(Loop).ValuesAsInteger['width'] := ColumnWidth;
          end;
        end;
  end
  else
    UpdateProcessListColumnsConstraints;

  UpdateProcessListColumns;
  if FDrawedSubCategoryID <> LobbyModule.CurrentSubCategoryID then
    FProcessListTopIndex := LobbyModule.CurrentProcessIDPosition;
  UpdateProcessList;
  FDrawedSubCategoryID := LobbyModule.CurrentSubCategoryID;
{
  for Loop := 0 to LobbyProcessListHeader.Sections.Count - 1 do
    LobbyProcessListHeader.Sections.Items[Loop].Text :=
      inttostr(LobbyProcessListHeader.Sections.Items[Loop].Width);
}
end;


// Columns

procedure TLobbyForm.UpdateProcessListColumns;
var
  Loop: Integer;
  curColumn: TDataList;
  curSection: TTeHeaderSection;
begin
  if LobbyModule.CurrentColumns = nil then
    exit;

  if LobbyModule.CurrentColumns.Count = 0 then
    exit;

  FUpdatingNow := true;

  if LobbyModule.CurrentColumns.Count <> LobbyProcessListHeader.Sections.Count then
    if LobbyModule.CurrentColumns.Count > LobbyProcessListHeader.Sections.Count then
      repeat
        curSection := LobbyProcessListHeader.Sections.Add;
        curSection.Alignment := taCenter;
        curSection.Layout := hglGlyphRight;
        curSection.ShowImage := true;
        curSection.Margin := 3;
        curSection.Spacing := 2;
      until LobbyModule.CurrentColumns.Count = LobbyProcessListHeader.Sections.Count
    else
      repeat
        LobbyProcessListHeader.Sections.Delete(LobbyProcessListHeader.Sections.Count - 1)
      until LobbyModule.CurrentColumns.Count = LobbyProcessListHeader.Sections.Count;

  for Loop := 0 to LobbyModule.CurrentColumns.Count - 1 do
  begin
    curColumn := LobbyModule.CurrentColumns.Items(Loop);
    curSection := LobbyProcessListHeader.Sections.Items[Loop];
    curSection.Width := curColumn.ValuesAsInteger['width'];
    curSection.Text := curColumn.Name;
    if curColumn.ID <> LobbyModule.CurrentSortStatsID then
      curSection.ImageIndex := -1
    else
      if curColumn.ValuesAsBoolean[DATANAME_SORT] then
        curSection.ImageIndex := 0
      else
        curSection.ImageIndex := 1;
  end;

  UpdateProcessListColumnsConstraints;
  FUpdatingNow := false;
end;

procedure TLobbyForm.LobbyProcessListHeaderSectionResize(
  EkHeaderControl: TTeHeaderControl; Section: TTeHeaderSection);
var
  curSection: TTeHeaderSection;
begin
  if FUpdatingNow or (LobbyModule.CurrentColumns = nil) then
    exit;

  FUpdatingNow := true;

  curSection := LobbyProcessListHeader.Sections.Items[LobbyProcessListHeader.Sections.Count - 1];
  curSection.Width := LobbyProcessListHeader.Width - curSection.Left + 2;

  UpdateProcessListColumnsConstraints;
  UpdateProcessList;

  FUpdatingNow := false;
end;

procedure TLobbyForm.UpdateProcessListColumnsConstraints;
var
  Loop: Integer;
  curSection: TTeHeaderSection;
  curWidth: Integer;
begin
  curWidth := 0;
  for Loop := 0 to LobbyProcessListHeader.Sections.Count - 1 do
  begin
    curSection := LobbyProcessListHeader.Sections.Items[Loop];
    {curSection.MaxWidth := curSection.Width;
    curSection.MinWidth := curSection.Width;{}
    curSection.MinWidth := 10;
    if Loop = LobbyModule.CurrentColumns.Count - 1 then
      curSection.MaxWidth := LobbyProcessListHeader.Width -
        (LobbyProcessListHeader.Sections.Count - 1) * 10
    else
      curSection.MaxWidth := LobbyProcessListHeader.Width - curWidth -
        (LobbyProcessListHeader.Sections.Count - Loop - 1) * 10;

    curWidth := curWidth + curSection.Width;
    LobbyModule.CurrentColumns.Items(Loop).ValuesAsInteger['width'] :=
      curSection.Width;{}
  end;
end;

procedure TLobbyForm.LobbyProcessListHeaderSectionClick(
  EkHeaderControl: TTeHeaderControl; Section: TTeHeaderSection);
var
  nInd: Integer;
  curColumn: TDataList;
begin
  if FUpdatingNow then
    exit;

  if LobbyModule.CurrentColumns = nil then
    exit;

  nInd := Section.Index;

  if (nInd >= 0) and (nInd < LobbyModule.CurrentColumns.Count) then
  begin
    curColumn := LobbyModule.CurrentColumns.Items(nInd);
    if curColumn <> nil then
      LobbyModule.Do_SortProcesses(curColumn.ID);
  end;
end;

procedure TLobbyForm.LobbyHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Loop : Integer;
begin
  for Loop := 0 to LobbyProcessListHeader.Sections.Count-1 do
  begin
    if (x >= LobbyProcessListHeader.Sections[Loop].Left) and (x <= LobbyProcessListHeader.Sections[Loop].Right) then
      LobbyProcessListHeaderSectionClick(LobbyProcessListHeader,LobbyProcessListHeader.Sections[Loop]);
  end;
end;

procedure TLobbyForm.LobbyProcessListHeaderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   
end;

// List

function AlignAnalizeForList(Text:String):boolean;
var i : integer;
begin
  result := false;
 for i := 1 to Length(Text) do
 begin
  if text[i] in ['0'..'9'] then
  begin
   result := true;
   break;
  end;
 end;
 for i := 1 to Length(Text) do
 begin
  if text[i] in ['A'..'Z'] then
  begin
   result := false;
   break;
  end;
 end;
 if pos(text,'of') <> 0 then
  result := true;
 if (text = 'Fixed') or (text = 'NL') or (text = 'PL') then
  result := true;
end;

procedure TLobbyForm.UpdateProcessList;
var
  Loop: Integer;
  Loop2: Integer;
  curText: String;
  curRect: TRect;
  curX: Integer;
  curY: Integer;
  TextOffset: Integer;
  EndCount: Integer;

  curColumn: TDataList;
  curProcess: TDataList;
  txtOffset: Integer;
  txtLeft: Integer;

  LastGroupID: Integer;
  CurrentGroupID: Integer;
  NeedDraw: Boolean;

  //currencyId : Integer;

  //category : Integer;
  //stakenopotlimit : string;
  //NeedToShow : boolean;
begin

  FUpdatingNow := true;
  ProcessListPainting.Assign(ProcessListBackground);
  ProcessListPainting.Canvas.Brush.Style := bsClear;
  ProcessListPainting.Canvas.Font.Name := 'Tahoma';
  ProcessListPainting.Canvas.Font.Size := 8;
  ProcessListPainting.Canvas.Font.Style := [];
  ProcessListPainting.Canvas.Font.Color := TextColor;
  ProcessListPainting.Canvas.CopyMode := cmSrcCopy;

  TextOffset := (ProcessListRowHeight - ProcessListPainting.Canvas.TextHeight('Pq')) div 2;

  if (LobbyModule.CurrentColumns = nil) or (LobbyModule.CurrentProcesses = nil) then
  begin
    ProcessListScrollBar.Visible := false;
    FProcessListTopIndex := 0;
    curRect.Top    := 0;
    curRect.Bottom := ProcessListRowHeight;
    curRect.Left   := 0;
    curRect.Right  := ProcessListPainting.Width;
    ProcessListPainting.Canvas.TextRect(curRect, TextMargin, TextOffset, cstrLobbyRetrievingInfo);
  end
  else
  if LobbyModule.CurrentProcesses.Count = 0 then
  begin
    ProcessListScrollBar.Visible := false;
    FProcessListTopIndex := 0;
    curRect.Top    := 0;
    curRect.Bottom := ProcessListRowHeight;
    curRect.Left   := 0;
    curRect.Right  := ProcessListPainting.Width;
  end
  else
  begin
    if LobbyModule.CurrentProcesses.Count <= RowCount then
      FProcessListTopIndex := 0;

    EndCount := LobbyModule.CurrentProcesses.Count - 1;
    if EndCount > FProcessListTopIndex + RowCount then
      EndCount := FProcessListTopIndex + RowCount + 1;

    LastGroupID := -1;
    NeedDraw := true;
    if FProcessListTopIndex > 0 then
      for Loop := 0 to FProcessListTopIndex - 1 do
      begin
        // Check for need draw grouped
        curProcess := LobbyModule.CurrentProcesses.Items(Loop);
        if curProcess.Value <> Null then
        begin
          CurrentGroupID := Integer(curProcess.Value);
          if CurrentGroupID <> LastGroupID then
          begin
            NeedDraw := not NeedDraw;
            LastGroupID := CurrentGroupID;
          end;
        end;
      end;


    for Loop := FProcessListTopIndex to EndCount do
    begin
     curProcess := LobbyModule.CurrentProcesses.Items(Loop);
      //if  LobbyModule.ShowAll or ChooseCurrentGameType(curProcess) then
       begin
        curRect.Top    := (Loop - FProcessListTopIndex)* ProcessListRowHeight;
        curRect.Bottom := curRect.Top + ProcessListRowHeight;
        curRect.Left   := 0;
        curRect.Right  := ProcessListPainting.Width - 2;

        // Check for need draw grouped
        if curProcess.Value <> Null then
        begin
          CurrentGroupID := Integer(curProcess.Value);
          if CurrentGroupID <> LastGroupID then
          begin
            NeedDraw := not NeedDraw;
            LastGroupID := CurrentGroupID;
          end;
        end;

        if Loop = LobbyModule.CurrentProcessIDPosition then
        begin
          // Draw selected
          WaitingListButton.Enabled := false;
          if curProcess.ValuesAsInteger[IntToStr(StatID_PlayersCount)] <> 0 then
          if curProcess.ValuesAsInteger[IntToStr(StatID_PlayersCount)] = curProcess.ValuesAsInteger[IntToStr(StatID_Chairs)] then
            WaitingListButton.Enabled := true;


          ProcessListPainting.Canvas.Brush.Color := FocusedRowBackgroundColor;
          ProcessListPainting.Canvas.FillRect(curRect);
          ProcessListPainting.Canvas.DrawFocusRect(curRect);
          ProcessListPainting.Canvas.Brush.Style := bsClear;{}
        end
        else
          if (LobbyModule.CurrentSubCategoryID <> TournamentSubCategoryID) and
             (LobbyModule.CurrentSubCategoryID <> SitAndGoSubCategoryID) then
            if NeedDraw then
              ProcessListPainting.Canvas.CopyRect(
                curRect, ProcessListDrawBackground.Canvas, curRect);

        curX := TextMargin;
        curY := curRect.Top + TextOffset;

        //currencyId := curProcess.ValuesAsInteger['currencyId'];
        for Loop2 := 0 to LobbyModule.CurrentColumns.Count - 1 do
        begin
          curColumn := LobbyModule.CurrentColumns.Items(Loop2);

          curText := curProcess.ValuesAsString[inttostr(curColumn.ID)];
          curRect.Left   := curX;
          curRect.Right  := curRect.Left + curColumn.ValuesAsInteger['width'] - TextMargin;
          txtOffset := ThemeEngineModule.CropText(curText, ProcessListPainting.Canvas, curRect.Right - curRect.Left);
          if (Loop2 = 0)  or (Loop2 = LobbyModule.CurrentColumns.Count - 1) then
            txtOffset := 0;
          //if AlignAnalizeForList(CurText) then
           txtLeft := curX + txtOffset;
          {else
           txtLeft := curX;{}
          curX := curRect.Right + TextMargin;
          ProcessListPainting.Canvas.TextRect(curRect, txtLeft, curY, curText);
        end;
       end;
      //end;
    end;

    ProcessListScrollBar.Visible := LobbyModule.CurrentProcesses.Count > RowCount;
    if ProcessListScrollBar.Visible then
    begin
      ProcessListScrollBar.Min := 0;
      ProcessListScrollBar.Max := LobbyModule.CurrentProcesses.Count - 1;
      ProcessListScrollBar.LargeChange := RowCount;
      ProcessListScrollBar.PageSize := RowCount;
      ProcessListScrollBar.Position := FProcessListTopIndex;
    end;
  end;

  ProcessListImage.Picture.Bitmap.Assign(ProcessListPainting);    {}

  if Enabled then
    ActiveControl := ProcessListFocusEdit;
  FUpdatingNow := false;
end;



procedure TLobbyForm.PrepareBitmaps;
var
  BMP: TBitmap;
  DestRect: TRect;
  SrcRect: TRect;
  x,y: Integer;
begin
  BMP := TBitmap.Create;
  BMP.Assign(LobbyBackgroundImage.Picture.Graphic);

  // Assign ProcessListImage
  DestRect.Left := 0;
  DestRect.Top := 0;
  DestRect.Right := ProcessListImage.Width;
  DestRect.Bottom := ProcessListImage.Height;

  SrcRect.Left := ProcessListPanel.Left;
  SrcRect.Top := ProcessListPanel.Top - LobbyBackgroundImage.Top;
  SrcRect.Right := SrcRect.Left + DestRect.Right;
  SrcRect.Bottom := SrcRect.Top + DestRect.Bottom;

  ProcessListBackground.Width := ProcessListImage.Width;
  ProcessListBackground.Height := ProcessListImage.Height;
  ProcessListBackground.Canvas.CopyMode := cmSrcCopy;
  ProcessListBackground.Canvas.CopyRect(DestRect, BMP.Canvas, SrcRect);

  ProcessListDrawBackground.Width := ProcessListImage.Width;
  ProcessListDrawBackground.Height := ProcessListImage.Height;
  ProcessListDrawBackground.Canvas.CopyMode := cmSrcCopy;

  for y := 0 to ProcessListBackground.Height do
    for x := 0 to ProcessListBackground.Width do
      ProcessListDrawBackground.Canvas.Pixels[x, y] := ProcessListBackground.Canvas.Pixels[x, y];
      {CalculateAverageColor(40,
        GroupedRowBackgroundColor, ProcessListBackground.Canvas.Pixels[x, y]);{}

  // Assign ProcessInfoImage
  DestRect.Left := 0;
  DestRect.Top := 0;
  DestRect.Right := ProcessInfoImage.Width;
  DestRect.Bottom := ProcessInfoImage.Height;

  SrcRect.Left := ProcessInfoPanel.Left;
  SrcRect.Top := ProcessInfoPanel.Top - LobbyBackgroundImage.Top;
  SrcRect.Right := SrcRect.Left + DestRect.Right;
  SrcRect.Bottom := SrcRect.Top + DestRect.Bottom;

  ProcessInfoBackground.Width := ProcessInfoImage.Width;
  ProcessInfoBackground.Height := ProcessInfoImage.Height;
  ProcessInfoBackground.Canvas.CopyMode := cmSrcCopy;
  ProcessInfoBackground.Canvas.CopyRect(DestRect, BMP.Canvas, SrcRect);

  BMP.Free;
end;

function TLobbyForm.CalculateAverageColor(TransparentPercent: Integer; Color1, Color2: TColor): TColor;
var
  a1, a2, a3, b1, b2, b3, r1, r2, r3: Byte;

  procedure ColorToBytes(c: TColor; var c1, c2, c3: Byte);
  begin
    c1 := c div (256 * 256);
    c2 := (c mod (256 * 256)) div 256;
    c3 := c mod 256;
  end;
begin
  ColorToBytes(Color1, a1, a2, a3);
  ColorToBytes(Color2, b1, b2, b3);

  r1 := a1 + ((b1 - a1) *  TransparentPercent) div 100;
  r2 := a2 + ((b2 - a2) *  TransparentPercent) div 100;
  r3 := a3 + ((b3 - a3) *  TransparentPercent) div 100;

  Result := ((r1 * 256) + r2) * 256 + r3;
end;

procedure TLobbyForm.ProcessListChangeIndex(NewIndex: Integer);
begin
  if FUpdatingNow or (LobbyModule.CurrentProcesses = nil) then
    exit;

  if LobbyModule.CurrentProcesses.Count = 0 then
    exit;

  if NewIndex < 0 then NewIndex := 0;
  if NewIndex >= LobbyModule.CurrentProcesses.Count then
    NewIndex := LobbyModule.CurrentProcesses.Count - 1;
  if LobbyModule.CurrentProcessIDPosition <> NewIndex then
  begin
    LobbyModule.Do_ChooseProcess(LobbyModule.CurrentProcesses.Items(NewIndex).ID, NewIndex);
    if NewIndex - FProcessListTopIndex > RowCount then
      FProcessListTopIndex := NewIndex - RowCount;
    if (NewIndex = LobbyModule.CurrentProcesses.Count - 1) and
      (LobbyModule.CurrentProcesses.Count > RowCount) then
      FProcessListTopIndex := LobbyModule.CurrentProcesses.Count - RowCount;
    if NewIndex < FProcessListTopIndex then
      FProcessListTopIndex := NewIndex;
    UpdateProcessList;
  end;
end;


// Process list scroller

procedure TLobbyForm.ProcessListScrollBarChange(Sender: TObject);
begin
  if FUpdatingNow then
    exit;

  if ProcessListScrollBar.Position <= ProcessListScrollBar.Max - ProcessListScrollBar.PageSize + 1 then
  begin
    FProcessListTopIndex := ProcessListScrollBar.Position;
    UpdateProcessList;
  end
  else
  begin
    FUpdatingNow := true;
    ProcessListScrollBar.Position := FProcessListTopIndex;
    FUpdatingNow := false;
  end;
end;


// ProcessInfo

procedure TLobbyForm.UpdateProcessInfo;
var
  curProcess: TDataList;
  curProcessInfo: TDataList;
  curData: TDataList;
  Loop,Loop2: Integer;
  curText: String;
  curName: String;
  curCity: String;
  curValue: String;
  curRect: TRect;
  //ShowProcessInfo : Boolean;
  txtOffset : Integer;
begin
  ProcessInfoPainting.Assign(ProcessInfoBackground);
  ProcessInfoPainting.Canvas.Brush.Style := bsClear;
  ProcessInfoPainting.Canvas.Font.Name := 'Tahoma';
  ProcessInfoPainting.Canvas.Font.Size := 8;
  ProcessInfoPainting.Canvas.Font.Style := [fsBold];
  ProcessInfoPainting.Canvas.Font.Color := TextColor;
  ProcessInfoPainting.Canvas.CopyMode := cmSrcCopy;
  MasterTournamentIDLabel.Caption := '';

  if (LobbyModule.CurrentProcesses <> nil) then
    if LobbyModule.CurrentProcesses.Count > 0 then
    begin
      // Process Info Title
      curText := '';
      if LobbyModule.CurrentProcesses.Find(LobbyModule.CurrentProcessID, curProcess) then
        if (LobbyModule.CurrentSubCategoryID <> TournamentSubCategoryID) and
           (LobbyModule.CurrentSubCategoryID <> SitAndGoSubCategoryID) then
          curText := '' + curProcess.Name
        else
          if pos('tournament', lowercase(curProcess.Name)) > 0 then
            curText := curProcess.Name
          else
            curText := curProcess.Name;

      if curText <> '' then
      begin
        curRect.Top    := InfoTitleOffset;
        curRect.Bottom := InfoTitleHeight;
        curRect.Left   := ProcessInfoPainting.Width div 2 - ProcessInfoPainting.Canvas.TextWidth(curText) div 2;
        curRect.Right  := ProcessInfoPainting.Width;

        ThemeEngineModule.CropText(curText, ProcessInfoPainting.Canvas,
          curRect.Right - curRect.Left);
        ProcessInfoPainting.Canvas.Font.Color := LobbyInfoCaptionColor;
        ProcessInfoPainting.Canvas.TextRect(curRect, curRect.Left, curRect.Top, curText);
      end;

      // Process Info Data
     if LobbyProcessInfoHeader.Visible then
     begin
      ProcessInfoPainting.Canvas.Font.Color := TextColor;
      ProcessInfoPainting.Canvas.Font.Style := [];
      if LobbyModule.CurrentProcessesInfo <> nil then
        if not LobbyModule.CurrentProcessesInfo.
          Find(LobbyModule.CurrentProcessID, curProcessInfo) then
        begin
          curRect.Top    := InfoTitleHeight + TextOffset;
          curRect.Bottom := InfoTitleHeight + ProcessInfoRowHeight + TextOffset;
          curRect.Left   := InfoGroupTextMargin;
          curRect.Right  := ProcessInfoPainting.Width;

          curText := cstrLobbyRetrievingInfo;
          ThemeEngineModule.CropText(curText, ProcessInfoPainting.Canvas,
            curRect.Right - curRect.Left);
          ProcessInfoPainting.Canvas.TextRect(curRect, curRect.Left, curRect.Top, curText);
        end
        else
        begin
          Loop2 := 0;
          for Loop := 0 to curProcessInfo.Count - 1 do
          begin
            curData := curProcessInfo.Items(Loop);
            if not curData.ValuesAsBoolean['isgroup'] then
            begin
              curName := curData.Name;
              curCity := curData.ValuesAsString['city'];
              curValue := curData.ValuesAsString['value'];{}
             {if (curName <> 'Registering') and (curName <> 'Starting') and
                (curName <> 'Running') and (curName <> 'Completed') then{}
             begin
              Loop2 := Loop2 + 1;
              if Loop2 mod 2 = 0  then
              begin
               curRect.Top    := InfoTitleHeight + Loop2 * ProcessInfoRowHeight + TextOffset;
               curRect.Bottom := curRect.Top + ProcessInfoRowHeight;
               curRect.Left   := 0;
               curRect.Right  := curRect.Right + LobbyProcessInfoHeader.Sections[1].Width;
               ProcessInfoPainting.Canvas.CopyRect(curRect, ProcessListDrawBackground.Canvas, curRect);
              end;

              curRect.Top    := InfoTitleHeight + Loop2 * ProcessInfoRowHeight + TextOffset;
              curRect.Bottom := curRect.Top + ProcessInfoRowHeight;
              curRect.Left   := 4;
              curRect.Right  := LobbyProcessInfoHeader.Sections[0].Width;
              ProcessInfoPainting.Canvas.Font.Color := clBlack;
              //txtOffset := ThemeEngineModule.CropText(curName, ProcessListPainting.Canvas, curRect.Right - curRect.Left);
              ProcessInfoPainting.Canvas.TextRect(curRect, curRect.Left, curRect.Top, curName); {}

              curRect.Top    := InfoTitleHeight + Loop2 * ProcessInfoRowHeight + TextOffset;
              curRect.Bottom := curRect.Top + ProcessInfoRowHeight;
              curRect.Left   := curRect.Left + LobbyProcessInfoHeader.Sections[0].Width;
              curRect.Right  := curRect.Right + LobbyProcessInfoHeader.Sections[0].Width;
              ProcessInfoPainting.Canvas.Font.Color := clBlack;
              //txtOffset := ThemeEngineModule.CropText(curName, ProcessListPainting.Canvas, curRect.Right - curRect.Left);
              ProcessInfoPainting.Canvas.TextRect(curRect, curRect.Left, curRect.Top, curCity); {}

              curRect.Top    := InfoTitleHeight + Loop2 * ProcessInfoRowHeight + TextOffset;
              curRect.Bottom := curRect.Top + ProcessInfoRowHeight;
              curRect.Left   := curRect.Left + LobbyProcessInfoHeader.Sections[1].Width;
              curRect.Right  := curRect.Right + LobbyProcessInfoHeader.Sections[1].Width;
              ProcessInfoPainting.Canvas.Font.Color := clBlack;
              txtoffset := 31 - ProcessInfoPainting.Canvas.TextWidth(curValue) div 2;
              ProcessInfoPainting.Canvas.TextRect(curRect, curRect.Left + txtoffset, curRect.Top, curValue); {}
             end;{}
            end;
          end;
      end;
     end
     else
     begin
       ProcessInfoPainting.Canvas.Font.Color := TextColor;
      if LobbyModule.CurrentProcessesInfo <> nil then
        if not LobbyModule.CurrentProcessesInfo.
          Find(LobbyModule.CurrentProcessID, curProcessInfo) then
        begin
          curRect.Top    := InfoTitleHeight + TextOffset;
          curRect.Bottom := InfoTitleHeight + ProcessInfoRowHeight + TextOffset;
          curRect.Left   := InfoGroupTextMargin;
          curRect.Right  := ProcessInfoPainting.Width;

          curText := cstrLobbyRetrievingInfo;
          ThemeEngineModule.CropText(curText, ProcessInfoPainting.Canvas,
            curRect.Right - curRect.Left);
          ProcessInfoPainting.Canvas.TextRect(curRect, curRect.Left, curRect.Top, curText);
        end
        else
        begin
          curMasterTournamentID := curProcessInfo.ValuesAsInteger['mastertournamentid'];
          MasterTournamentIDLabel.Caption := '';
          if curMasterTournamentID > 0 then
            MasterTournamentIDLabel.Caption := 'tournament #' + IntToStr(curMasterTournamentID);
          for Loop := 0 to curProcessInfo.Count - 1 do
          begin
            curData := curProcessInfo.Items(Loop);
            curRect.Top    := InfoTitleHeight + Loop * ProcessInfoRowHeight + TextOffset;
            curRect.Bottom := curRect.Top + ProcessInfoRowHeight;
            curRect.Left   := 0;
            curRect.Right  := ProcessInfoPainting.Width;


            if curData.ValuesAsBoolean['isgroup'] then
            begin
             if (CurData.Name = 'Waiting list:') or (CurData.Name = 'Players:') or
               (CurData.Name = 'Watchers:') then continue;
              curRect.Left := InfoGroupTextMargin;
              curText := curData.Name;
              ProcessInfoPainting.Canvas.Font.Style := [fsBold];
            end;
            if curData.ValuesAsBoolean['issatellited'] then
            begin
              MasterTournamentIDLabel.top := curRect.Top;
              txtOffset := ProcessInfoPainting.Width div 2 - ProcessInfoPainting.Canvas.TextWidth(curText + MasterTournamentIDLabel.caption) div 2 + 10;
              MasterTournamentIDLabel.Left := CurRect.left + ProcessInfoPainting.Canvas.TextWidth(curText) + txtOffSet;
            end
            else
             txtOffset := ProcessInfoPainting.Width div 2 - ProcessInfoPainting.Canvas.TextWidth(curText) div 2;

            ProcessInfoPainting.Canvas.TextRect(curRect, curRect.Left + txtOffset, curRect.Top, curText);

          end;
       end;                   {}
     end;
    end;
  ProcessInfoImage.Picture.Bitmap.Assign(ProcessInfoPainting);
end;

procedure TLobbyForm.ProcessListImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ProcessListChangeIndex(FProcessListTopIndex + (Y div ProcessListRowHeight));
end;

procedure TLobbyForm.ProcessListImageDblClick(Sender: TObject);
begin
   JoinProcess;
end;

procedure TLobbyForm.ProcessListFocusEditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if FUpdatingNow then
    exit;

  case Key of
    VK_UP:    ProcessListChangeIndex(LobbyModule.CurrentProcessIDPosition - 1);
    VK_DOWN:  ProcessListChangeIndex(LobbyModule.CurrentProcessIDPosition + 1);
    VK_HOME:  ProcessListChangeIndex(0);
    VK_END:   ProcessListChangeIndex(LobbyModule.CurrentProcesses.Count - 1);
    VK_PRIOR: ProcessListChangeIndex(LobbyModule.CurrentProcessIDPosition -
              (ProcessListPainting.Height div ProcessListRowHeight));
    VK_NEXT:  ProcessListChangeIndex(LobbyModule.CurrentProcessIDPosition +
              (ProcessListPainting.Height div ProcessListRowHeight));
    VK_F5:    LobbyModule.Do_ChooseSubCategory(LobbyModule.CurrentSubCategoryID);
  end;
end;

procedure TLobbyForm.AboutMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laAbout);
end;

procedure TLobbyForm.RecordedHandsItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laRecordedHands);
end;

procedure TLobbyForm.CustomSupportItemClick(Sender: TObject);
begin
  LobbyModule.Do_CustomSupport;
end;

procedure TLobbyForm.ChangeValidateMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laChangeValidateEmail);
end;

procedure TLobbyForm.HelpMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laHelp);
end;

procedure TLobbyForm.GameRulesMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laGameRules);
end;

procedure TLobbyForm.TipMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laTip);
end;

procedure TLobbyForm.NewsMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laNews);
end;

procedure TLobbyForm.WhatsNewMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laWhatsNew);
end;

procedure TLobbyForm.ChooseMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laWhyChoose);
end;

procedure TLobbyForm.NetworkStatusMenuItemClick(Sender: TObject);
begin
  SessionModule.Do_ViewNetworkStatus;
end;


// Options

procedure TLobbyForm.SendOptions(Command: String);
begin
  try
    ShockwaveFlash.SetVariable('mcComm.strInMsg', Command);
  except
  end;
end;

procedure TLobbyForm.UpdateOptions;
begin
  SendOptions(ProcessModule.GetOptionsXML(nil));
end;

procedure TLobbyForm.ShockwaveFlashFSCommand(ASender: TObject;
  const command, args: WideString);
begin
  ShockwaveFlash.OnFSCommand := nil;
  UpdateOptions;
end;


procedure TLobbyForm.WOWLabelDblClick(Sender: TObject);
var
  DebugForm: TDebugForm;
begin
  if SessionModule.SessionSettings.ValuesAsBoolean[RegistryDebugKey] and
    (SessionModule.SessionSettings.ValuesAsString[RegistryDebugIdent] =
    RegistryDebugVerbose) and
    (SessionModule.SessionSettings.ValuesAsString[RegistryMultiInstancesKey] =
    RegistryMultiInstancesValue) then
  begin
    Application.CreateForm(TDebugForm, DebugForm);
    DebugForm.Show;
  end;
end;


procedure TLobbyForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TLobbyForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TLobbyForm.FormActivate(Sender: TObject);
begin
  LobbyModule.LobbyActivated := True;
end;

procedure TLobbyForm.FormDeactivate(Sender: TObject);
begin
  LobbyModule.LobbyActivated := False;
end;

procedure TLobbyForm.FormHide(Sender: TObject);
begin
  LobbyModule.LobbyActivated := False;
end;

procedure TLobbyForm.FormShow(Sender: TObject);
begin
  LobbyModule.LobbyActivated := True;
  if SessionModule.SessionSettings.ValuesAsBoolean[SessionShowPlayMoneyTables] then
  begin
   PlayMoneyButton.Enabled := false;
   NoLimitButton.Enabled := true;
   FixedLimitButton.Enabled := true;
  end
  else
  if SessionModule.SessionSettings.ValuesAsBoolean[SessionShowNoLimitTables] then
  begin
   PlayMoneyButton.Enabled := true;
   NoLimitButton.Enabled := false;
   FixedLimitButton.Enabled := true;
  end
  else
  if SessionModule.SessionSettings.ValuesAsBoolean[SessionShowLimitTables] then
  begin
   PlayMoneyButton.Enabled := true;
   NoLimitButton.Enabled := true;
   FixedLimitButton.Enabled := false;
  end;
end;

procedure TLobbyForm.ApplicationEventsActivate(Sender: TObject);
begin
  if Showing and (Screen.ActiveForm = Self) then
    LobbyModule.LobbyActivated := True;
end;

procedure TLobbyForm.ApplicationEventsDeactivate(Sender: TObject);
begin
  LobbyModule.LobbyActivated := False;
end;

procedure TLobbyForm.FixedLimitButtonClick(Sender: TObject);
begin
  {LobbyModule.Do_Action(laHideNoLimitTables);
  FixedLimitButton.Enabled := false;
  NoLimitButton.Enabled := true;
  PlayMoneyButton.Enabled := true; {}
  PlayMoneyButton.Enabled := false;
end;

procedure TLobbyForm.NoLimitButtonClick(Sender: TObject);
begin
  {LobbyModule.Do_Action(laHideLimitTables);
  FixedLimitButton.Enabled := true;
  NoLimitButton.Enabled := false;
  PlayMoneyButton.Enabled := true;{}
  PlayMoneyButton.Enabled := false;
end;

procedure TLobbyForm.PlayMoneyButtonClick(Sender: TObject);
begin
  {LobbyModule.Do_Action(laHidePlayMoneyTables);
  FixedLimitButton.Enabled := true;
  NoLimitButton.Enabled := true;{}
  PlayMoneyButton.Enabled := false;{}
end;

procedure TLobbyForm.HideWelcomeMessageItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(lahidewelcomemessage);
end;

procedure TLobbyForm.ChangePlayerMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laChangeAvatar);
end;

procedure TLobbyForm.BannerBrowserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  {BannerBrowser.OleObject.Document.Body.Style.OverflowX := 'hidden';
  BannerBrowser.OleObject.Document.Body.Style.OverflowY := 'hidden';
  BannerBrowser.OleObject.Document.ParentWindow.ScrollBy(10, 15);{}
end;


procedure TLobbyForm.BannerBrowserNavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
 { LobbyModule.WB_Set3DBorderStyle(Sender, False);
  // Draw a double line border
  LobbyModule.WB_SetBorderStyle(Sender, 'double');
  // Set a border color
  LobbyModule.WB_SetBorderColor(Sender, '#282828');{}
end;

procedure TLobbyForm.BlackJackButtonClick(Sender: TObject);
begin
   BlackJackWelcomeForm.Show;
end;

procedure TLobbyForm.MainMenuMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 MenuPopupTimer.Enabled:= true;
end;

procedure TLobbyForm.ThisWeekMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laleaderboardsforthisweek);
end;

procedure TLobbyForm.ThismonthMenuItemClick(Sender: TObject);
begin
 LobbyModule.Do_Action(laleaderboardsforthismonth);
end;

procedure TLobbyForm.ThisyearMenuItemClick(Sender: TObject);
begin
 LobbyModule.Do_Action(laleaderboardsforthisyear);
end;

procedure TLobbyForm.PrevWeekMenuItemClick(Sender: TObject);
begin
 LobbyModule.Do_Action(laleaderboardsforpreviousweek);
end;

procedure TLobbyForm.PrevMonthMenuItemClick(Sender: TObject);
begin
 LobbyModule.Do_Action(laleaderboardsforpreviousmonth);
end;

procedure TLobbyForm.PrevYearMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laleaderboardsforpreviousyear);
end;

procedure TLobbyForm.TournamentLeaderPointsMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laleaderpoints);
end;

procedure TLobbyForm.MainMenuMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MenuPopupTimer.Enabled:= true;
  
end;


procedure TLobbyForm.HideCompletedTournamentsItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(lahidecompletetables);
end;

procedure TLobbyForm.HideRunningTournamentsItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(lahiderunningtables);
end;

procedure TLobbyForm.HideFullTablesItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(lahidefulltables);
end;

procedure TLobbyForm.GetMoreChipsMenuItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laGetMoreChips);
end;


procedure TLobbyForm.ProgressiveButtonClick(Sender: TObject);
begin
  LobbyModule.Do_Action(labikiniforum);
end;

procedure TLobbyForm.MasterTournamentIDLabelMouseEnter(Sender: TObject);
begin
  MasterTournamentIDLabel.Font.Style := [fsUnderline];
end;

procedure TLobbyForm.MasterTournamentIDLabelMouseLeave(Sender: TObject);
begin
  MasterTournamentIDLabel.Font.Style := [];
end;

procedure TLobbyForm.MasterTournamentIDLabelClick(Sender: TObject);
begin
  TournamentModule.StartTournament(curMasterTournamentID,'Tournament #' + IntToStr(curMasterTournamentID));
end;

procedure TLobbyForm.SendLogFileItemClick(Sender: TObject);
begin
  LobbyModule.Do_Action(lasendlogfile);
end;

end.
