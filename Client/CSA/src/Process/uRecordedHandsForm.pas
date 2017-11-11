unit uRecordedHandsForm;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, StdCtrls;

type
  TRecordedHandsForm = class(TForm)
    BackgroundPanel: TTeHeaderPanel;
    SlotPanel: TTeHeaderPanel;
    TeLabel22: TTeLabel;
    TeLabel24: TTeLabel;
    SlotSaveButton: TTeButton;
    SlotCancelButton: TTeButton;
    HandIDEdit: TTeEdit;
    TeLabel1: TTeLabel;
    HandsPageControl: TTePageControl;
    PreviousHandsTabSheet: TTeTabSheet;
    SelectedHandsTabSheet: TTeTabSheet;
    CancelButton: TTeButton;
    PlayButton: TTeButton;
    Slot1FirstLabel: TTeLabel;
    Slot1SecondLabel: TTeLabel;
    Slot2FirstLabel: TTeLabel;
    Slot2SecondLabel: TTeLabel;
    Slot3FirstLabel: TTeLabel;
    Slot3SecondLabel: TTeLabel;
    Slot4FirstLabel: TTeLabel;
    Slot4SecondLabel: TTeLabel;
    Slot5FirstLabel: TTeLabel;
    Slot5SecondLabel: TTeLabel;
    Slot6FirstLabel: TTeLabel;
    Slot6SecondLabel: TTeLabel;
    Slot7FirstLabel: TTeLabel;
    Slot7SecondLabel: TTeLabel;
    Slot8FirstLabel: TTeLabel;
    Slot8SecondLabel: TTeLabel;
    Slot9FirstLabel: TTeLabel;
    Slot9SecondLabel: TTeLabel;
    Slot10FirstLabel: TTeLabel;
    Slot10SecondLabel: TTeLabel;
    RemoveButton: TTeButton;
    Slot1RadioButton: TTeRadioButton;
    Slot2RadioButton: TTeRadioButton;
    Slot3RadioButton: TTeRadioButton;
    Slot4RadioButton: TTeRadioButton;
    Slot5RadioButton: TTeRadioButton;
    Slot6RadioButton: TTeRadioButton;
    Slot7RadioButton: TTeRadioButton;
    Slot8RadioButton: TTeRadioButton;
    Slot9RadioButton: TTeRadioButton;
    Slot10RadioButton: TTeRadioButton;
    EditButton: TTeButton;
    PH_CancelButton: TTeButton;
    PH_PlayButton: TTeButton;
    PH_Slot1FirstLabel: TTeLabel;
    PH_Slot1SecondLabel: TTeLabel;
    PH_Slot2FirstLabel: TTeLabel;
    PH_Slot2SecondLabel: TTeLabel;
    PH_Slot3FirstLabel: TTeLabel;
    PH_Slot3SecondLabel: TTeLabel;
    PH_Slot4FirstLabel: TTeLabel;
    PH_Slot4SecondLabel: TTeLabel;
    PH_Slot5FirstLabel: TTeLabel;
    PH_Slot5SecondLabel: TTeLabel;
    PH_Slot1RadioButton: TTeRadioButton;
    PH_Slot2RadioButton: TTeRadioButton;
    PH_Slot3RadioButton: TTeRadioButton;
    PH_Slot4RadioButton: TTeRadioButton;
    PH_Slot5RadioButton: TTeRadioButton;
    PH_Slot6FirstLabel: TTeLabel;
    PH_Slot6SecondLabel: TTeLabel;
    PH_Slot7FirstLabel: TTeLabel;
    PH_Slot7SecondLabel: TTeLabel;
    PH_Slot8FirstLabel: TTeLabel;
    PH_Slot8SecondLabel: TTeLabel;
    PH_Slot9FirstLabel: TTeLabel;
    PH_Slot9SecondLabel: TTeLabel;
    PH_Slot10FirstLabel: TTeLabel;
    PH_Slot10SecondLabel: TTeLabel;
    PH_Slot6RadioButton: TTeRadioButton;
    PH_Slot7RadioButton: TTeRadioButton;
    PH_Slot8RadioButton: TTeRadioButton;
    PH_Slot9RadioButton: TTeRadioButton;
    PH_Slot10RadioButton: TTeRadioButton;
    CommentsMemo: TMemo;
    HandIDComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure SlotsRadioButtonClick(Sender: TObject);
    procedure SlotPanelButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure SlotSaveButtonClick(Sender: TObject);
    procedure SlotCancelButtonClick(Sender: TObject);
    procedure SlotControlDblClick(Sender: TObject);
    procedure HandIDEditKeyPress(Sender: TObject; var Key: Char);
    procedure HandIDEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HandIDComboBoxChange(Sender: TObject);
    procedure PH_PlayButtonClick(Sender: TObject);
    procedure PH_Slot1FirstLabelClick(Sender: TObject);
    procedure HandsPageControlChange(Sender: TObject);
  private
    CurrentSlot: Integer;
    CurrentHandID: Integer;

    procedure OnRecordedHandsShow;
    procedure OnRecordedHandsUpdate;
    procedure OnRecordHandsSaved;
    procedure OnRecordHandsSaveFailed;

    function  GetFirstLabel(curSlotNo: Integer): TTeLabel;
    function  GetRadioButton(curSlotNo: Integer): TTeRadioButton;
    function  GetSecondLabel(curSlotNo: Integer): TTeLabel;
    procedure RecordedHandsUpdate;
    procedure DisableControls;
    procedure EnableControls;
    procedure EditSlot;
    procedure SlotPanelClose;
    procedure SlotPanelOpen;
    function GetOneLineComments(Value: String): String;
    function GetPH_FirstLabel(curSlotNo: Integer): TTeLabel;
    function GetPH_RadioButton(curSlotNo: Integer): TTeRadioButton;
    function GetPH_SecondLabel(curSlotNo: Integer): TTeLabel;
    procedure PreviousHandsUpdate;
    procedure SelectedHandsUpdate;
    procedure CheckCurrentHandID;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  RecordedHandsForm: TRecordedHandsForm;

implementation

uses
  uLogger,
  uProcessModule,
  uLobbyModule,
  uDataList,
  uConstants,
  uThemeEngineModule;

{$R *.dfm}

procedure TRecordedHandsForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Recorded hands';
  ThemeEngineModule.FormsChangeConstraints(Self,  675, 233);
  HandsPageControl.ActivePage := PreviousHandsTabSheet;
  ThemeEngineModule.CenteringForm(Self);

  CurrentHandID := 0;
  CurrentSlot := 0;

  ProcessModule.OnRecordedHandsShow := OnRecordedHandsShow;
  ProcessModule.OnRecordedHandsUpdate := OnRecordedHandsUpdate;
  ProcessModule.OnRecordHandsSaved := OnRecordHandsSaved;
  ProcessModule.OnRecordHandsSaveFailed := OnRecordHandsSaveFailed;
end;

procedure TRecordedHandsForm.FormDestroy(Sender: TObject);
begin
  ProcessModule.OnRecordedHandsShow := nil;
  ProcessModule.OnRecordedHandsUpdate := nil;
  ProcessModule.OnRecordHandsSaved := nil;
  ProcessModule.OnRecordHandsSaveFailed := nil;
end;

procedure TRecordedHandsForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TRecordedHandsForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TRecordedHandsForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TRecordedHandsForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TRecordedHandsForm.DisableControls;
var
  Loop: Integer;
begin
  cursor := crHourGlass;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
  PH_CancelButton.Enabled := true;
end;

procedure TRecordedHandsForm.EnableControls;
var
  Loop: Integer;
begin
  cursor := crDefault;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := true;
end;

procedure TRecordedHandsForm.OnRecordedHandsShow;
begin
  CurrentHandID := 0;
  CurrentSlot := 0;

  RecordedHandsUpdate;
  if not Visible then
  begin
    HandsPageControl.ActivePage := PreviousHandsTabSheet;
    ThemeEngineModule.CenteringForm(Self);
  end;
  Show;
end;

procedure TRecordedHandsForm.OnRecordedHandsUpdate;
begin
  if Visible then
    RecordedHandsUpdate;
end;

procedure TRecordedHandsForm.RecordedHandsUpdate;
begin
  PreviousHandsUpdate;
  SelectedHandsUpdate;
end;

procedure TRecordedHandsForm.HandsPageControlChange(Sender: TObject);
begin
  if Visible then
    RecordedHandsUpdate;
end;

// Previous Hands

// Get controls

function TRecordedHandsForm.GetPH_RadioButton(curSlotNo: Integer): TTeRadioButton;
begin
  case curSlotNo of
    1 : Result := PH_Slot1RadioButton;
    2 : Result := PH_Slot2RadioButton;
    3 : Result := PH_Slot3RadioButton;
    4 : Result := PH_Slot4RadioButton;
    5 : Result := PH_Slot5RadioButton;
    6 : Result := PH_Slot6RadioButton;
    7 : Result := PH_Slot7RadioButton;
    8 : Result := PH_Slot8RadioButton;
    9 : Result := PH_Slot9RadioButton;
    10: Result := PH_Slot10RadioButton;
  else
    Result := PH_Slot1RadioButton;
  end;
end;

function TRecordedHandsForm.GetPH_FirstLabel(curSlotNo: Integer): TTeLabel;
begin
  case curSlotNo of
    1 : Result := PH_Slot1FirstLabel;
    2 : Result := PH_Slot2FirstLabel;
    3 : Result := PH_Slot3FirstLabel;
    4 : Result := PH_Slot4FirstLabel;
    5 : Result := PH_Slot5FirstLabel;
    6 : Result := PH_Slot6FirstLabel;
    7 : Result := PH_Slot7FirstLabel;
    8 : Result := PH_Slot8FirstLabel;
    9 : Result := PH_Slot9FirstLabel;
    10: Result := PH_Slot10FirstLabel;
  else
    Result := PH_Slot1FirstLabel;
  end;
end;

function TRecordedHandsForm.GetPH_SecondLabel(curSlotNo: Integer): TTeLabel;
begin
  case curSlotNo of
    1 : Result := PH_Slot1SecondLabel;
    2 : Result := PH_Slot2SecondLabel;
    3 : Result := PH_Slot3SecondLabel;
    4 : Result := PH_Slot4SecondLabel;
    5 : Result := PH_Slot5SecondLabel;
    6 : Result := PH_Slot6SecondLabel;
    7 : Result := PH_Slot7SecondLabel;
    8 : Result := PH_Slot8SecondLabel;
    9 : Result := PH_Slot9SecondLabel;
    10: Result := PH_Slot10SecondLabel;
  else
    Result := Slot1SecondLabel;
  end;
end;

// Actions

procedure TRecordedHandsForm.PreviousHandsUpdate;
var
  Loop: Integer;
  Index: Integer;
  curHand: TDataList;
  curRadioButton: TTeRadioButton;
  curFirstLabel: TTeLabel;
  curSecondLabel: TTeLabel;
begin
  for Loop := 1 to 10 do
  begin
    curRadioButton := GetPH_RadioButton(Loop);
    curFirstLabel := GetPH_FirstLabel(Loop);
    curSecondLabel := GetPH_SecondLabel(Loop);

    curHand := nil;
    Index := ProcessModule.PreviousHands.Count - Loop;
    if Index >= 0 then
      curHand := ProcessModule.PreviousHands.Items(Index);

    if curHand = nil then
    begin
      curRadioButton.Visible := False;
      curFirstLabel.Visible := False;
      curSecondLabel.Visible := False;
      curRadioButton.Tag := 0;
      curFirstLabel.Tag := 0;
      curSecondLabel.Tag := 0;
      curRadioButton.Checked := False;
      curFirstLabel.Caption := '';
      curSecondLabel.Caption := '';
    end
    else
    begin
      curRadioButton.Visible := True;
      curFirstLabel.Visible := True;
      curSecondLabel.Visible := True;
      curRadioButton.Tag := curHand.ID;
      curFirstLabel.Tag := curHand.ID;
      curSecondLabel.Tag := curHand.ID;
      curRadioButton.Checked := False;
      curFirstLabel.Caption := 'Hand #' + inttostr(curHand.ID);
      curSecondLabel.Caption := curHand.Value + ' ' + curHand.Name;
    end;
  end;
  CheckCurrentHandID;
end;

procedure TRecordedHandsForm.CheckCurrentHandID;
var
  Loop: Integer;
  curRadioButton: TTeRadioButton;
begin
  for Loop := 1 to 10 do
  begin
    curRadioButton := GetPH_RadioButton(Loop);
    if curRadioButton.Tag = CurrentHandID then
    begin
      curRadioButton.Checked := True;
      Break;
    end;
  end;
end;

procedure TRecordedHandsForm.PH_Slot1FirstLabelClick(Sender: TObject);
begin
  CurrentHandID := (Sender as TComponent).Tag;
  CheckCurrentHandID;
end;

procedure TRecordedHandsForm.PH_PlayButtonClick(Sender: TObject);
begin
  if CurrentHandID > 0 then
    ProcessModule.Do_PreviousHandPlay(CurrentHandID);
end;


// Selected Hands

// Get controls

function TRecordedHandsForm.GetRadioButton(curSlotNo: Integer): TTeRadioButton;
begin
  case curSlotNo of
    1 : Result := Slot1RadioButton;
    2 : Result := Slot2RadioButton;
    3 : Result := Slot3RadioButton;
    4 : Result := Slot4RadioButton;
    5 : Result := Slot5RadioButton;
    6 : Result := Slot6RadioButton;
    7 : Result := Slot7RadioButton;
    8 : Result := Slot8RadioButton;
    9 : Result := Slot9RadioButton;
    10: Result := Slot10RadioButton;
  else
    Result := Slot1RadioButton;
  end;
end;

function TRecordedHandsForm.GetFirstLabel(curSlotNo: Integer): TTeLabel;
begin
  case curSlotNo of
    1 : Result := Slot1FirstLabel;
    2 : Result := Slot2FirstLabel;
    3 : Result := Slot3FirstLabel;
    4 : Result := Slot4FirstLabel;
    5 : Result := Slot5FirstLabel;
    6 : Result := Slot6FirstLabel;
    7 : Result := Slot7FirstLabel;
    8 : Result := Slot8FirstLabel;
    9 : Result := Slot9FirstLabel;
    10: Result := Slot10FirstLabel;
  else
    Result := Slot1FirstLabel;
  end;
end;

function TRecordedHandsForm.GetSecondLabel(curSlotNo: Integer): TTeLabel;
begin
  case curSlotNo of
    1 : Result := Slot1SecondLabel;
    2 : Result := Slot2SecondLabel;
    3 : Result := Slot3SecondLabel;
    4 : Result := Slot4SecondLabel;
    5 : Result := Slot5SecondLabel;
    6 : Result := Slot6SecondLabel;
    7 : Result := Slot7SecondLabel;
    8 : Result := Slot8SecondLabel;
    9 : Result := Slot9SecondLabel;
    10: Result := Slot10SecondLabel;
  else
    Result := Slot1SecondLabel;
  end;
end;


// Actions

procedure TRecordedHandsForm.OnRecordHandsSaved;
begin
  SlotPanelClose;
end;

procedure TRecordedHandsForm.OnRecordHandsSaveFailed;
begin
  if not SlotPanel.Visible then
    EnableControls
  else
    SlotPanelOpen;
end;

procedure TRecordedHandsForm.SelectedHandsUpdate;
var
  Loop: Integer;
  HandID: Integer;
  curData: TDataList;
begin
  HandIDComboBox.Items.Clear;
  HandIDComboBox.Text := '';
  HandIDComboBox.ItemIndex := -1;

  if ProcessModule.PreviousHands.Count > 0 then
  begin
    for Loop := ProcessModule.PreviousHands.Count - 1 downto 0 do
      HandIDComboBox.Items.Add(inttostr(ProcessModule.PreviousHands.Items(Loop).ID));
    HandIDComboBox.ItemIndex := 0;
    HandIDComboBox.Text := HandIDComboBox.Items.Strings[0];
  end;

  for Loop := 1 to 10 do
  begin
    curData := ProcessModule.RecordedHandList.Items(Loop - 1);
    HandID := curData.ValuesAsInteger['handid'];
    if HandID > 0 then
    begin
      GetFirstLabel(Loop).Caption := 'Hand #' + inttostr(HandID);
      GetSecondLabel(Loop).Caption := GetOneLineComments(curData.ValuesAsString['comment']);
    end
    else
    begin
      GetFirstLabel(Loop).Caption := cstrRecordHandSlot;
      GetSecondLabel(Loop).Caption := cstrRecordHandLabel;
    end;
  end;

  if not SlotPanel.Visible then
  begin
    SlotPanelClose;
    if not ProcessModule.RecordedHandReceived then
      DisableControls;
  end;
end;

procedure TRecordedHandsForm.EditSlot;
var
  HandID: Integer;
  curData: TDataList;
begin
  if ProcessModule.RecordedHandList.Find(CurrentSlot, curData) then
  begin
    HandIDComboBox.ItemIndex := -1;
    HandIDComboBox.Text := '';
    HandIDEdit.Text := '';
    CommentsMemo.Text := '';

    HandID := curData.ValuesAsInteger['handid'];

    if HandID > 0 then
    begin
      HandIDEdit.Text := HandIDComboBox.Text;
      HandIDComboBox.Text := inttostr(curData.ValuesAsInteger['handid']);
      CommentsMemo.Lines.Text := curData.ValuesAsString['comment'];
    end
    else
      if HandIDComboBox.Items.Count > 0 then
        HandIDComboBox.ItemIndex := 0;

    SlotPanelOpen;
  end;
end;

procedure TRecordedHandsForm.SlotPanelOpen;
begin
  HandIDEdit.Enabled := true;
  HandIDComboBox.Enabled := true;
  CommentsMemo.Enabled := true;
  SlotSaveButton.Enabled := true;
  SlotCancelButton.Enabled := true;
  SlotPanel.Caption := 'Slot #' + inttostr(CurrentSlot);
  SlotPanel.Visible := true;
  SlotPanel.Show;
  DisableControls;
end;

procedure TRecordedHandsForm.SlotPanelClose;
begin
  SlotPanel.Visible := false;
  EnableControls;
end;


// Events

procedure TRecordedHandsForm.SlotsRadioButtonClick(Sender: TObject);
var
  curData: TDataList;
begin
  CurrentSlot := (Sender as TControl).Tag;
  GetRadioButton(CurrentSlot).Checked := true;

  if ProcessModule.RecordedHandList.Find(CurrentSlot, curData) then
    if curData.ValuesAsInteger['handid'] = 0 then
      EditSlot;
end;

procedure TRecordedHandsForm.SlotControlDblClick(Sender: TObject);
begin
  CurrentSlot := (Sender as TControl).Tag;
  GetRadioButton(CurrentSlot).Checked := true;
  EditSlot;
end;

procedure TRecordedHandsForm.SlotPanelButtonClick(Sender: TObject);
begin
  SlotPanelClose;
end;

procedure TRecordedHandsForm.EditButtonClick(Sender: TObject);
begin
  EditSlot;
end;

procedure TRecordedHandsForm.RemoveButtonClick(Sender: TObject);
begin
  ProcessModule.Do_RecordHandClear(CurrentSlot);
end;

procedure TRecordedHandsForm.PlayButtonClick(Sender: TObject);
begin
  ProcessModule.Do_RecordHandPlay(CurrentSlot);
end;

procedure TRecordedHandsForm.SlotSaveButtonClick(Sender: TObject);
begin
  DisableControls;
  HandIDEdit.Enabled := false;
  HandIDComboBox.Enabled := false;
  CommentsMemo.Enabled := false;
  SlotSaveButton.Enabled := false;
  SlotCancelButton.Enabled := false;
  ProcessModule.Do_RecordHandSave(CurrentSlot, StrToIntDef(HandIDEdit.Text, 0),
    CommentsMemo.Text);
end;

procedure TRecordedHandsForm.SlotCancelButtonClick(Sender: TObject);
begin
  SlotPanelClose;
end;

procedure TRecordedHandsForm.HandIDEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not ((key >= '0') and (key <='9'))) or (length((Sender as TTeEdit).Text) > 9) then
    key := #0;
end;

procedure TRecordedHandsForm.HandIDEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then
    Close;
end;

procedure TRecordedHandsForm.HandIDComboBoxChange(Sender: TObject);
var
  HandID: Integer;
  curHand: TDataList;
begin
  if HandIDComboBox.Text <> HandIDEdit.Text then
  begin
    HandID := strtointdef(HandIDComboBox.Text, 0);
    if HandID > 0 then
    begin
      HandIDEdit.Text := HandIDComboBox.Text;
      CommentsMemo.Lines.Clear;
      if ProcessModule.PreviousHands.Find(HandID, curHand) then
        CommentsMemo.Lines.Add(curHand.Value + ' ' + curHand.Name);
    end;
  end;
end;

function TRecordedHandsForm.GetOneLineComments(Value: String): String;
begin
  Result := ProcessModule.GetOneLineComments(copy(Value, 1, 40));
end;


end.
