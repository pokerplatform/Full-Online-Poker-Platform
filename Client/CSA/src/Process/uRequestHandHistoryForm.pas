unit uRequestHandHistoryForm;

interface

uses
  Windows, Messages, SysUtils, StrUtils, te_controls, Controls, Classes,
  Variants, Graphics, Forms,
  Dialogs, StdCtrls;

type
  TRequestHandHistoryForm = class(TForm)
    TeGroupBox1: TTeGroupBox;
    LastHandsRadioButton: TTeRadioButton;
    LastHandsSpinEdit: TTeSpinEdit;
    TeLabel1: TTeLabel;
    HandNumberRadioButton: TTeRadioButton;
    TeGroupBox2: TTeGroupBox;
    OldestFirstRadioButton: TTeRadioButton;
    NewestFirstRadioButton: TTeRadioButton;
    OkButton: TTeButton;
    CancelButton: TTeButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    HandNumberComboBox: TComboBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HandNumberKeyPress(Sender: TObject; var Key: Char);
    procedure OkButtonClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure HandNumberComboBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LastHandsRadioButtonClick(Sender: TObject);
    procedure HandNumberRadioButtonClick(Sender: TObject);
  private
    procedure DisableControls;
    procedure EnableControls;
    procedure OnRequestHandHistory(FirstHandID: Integer);
    procedure OnRequestHandHistorySent;
    procedure OnRequestHandHistoryFailed;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  RequestHandHistoryForm: TRequestHandHistoryForm;

implementation

uses
  uThemeEngineModule,
  uConstants,
  uProcessModule;

{$R *.dfm}

{ TRequestHandHistoryForm }

procedure TRequestHandHistoryForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TRequestHandHistoryForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Request hand history...';
  ThemeEngineModule.FormsChangeConstraints(Self,  250, 200);
  ProcessModule.OnRequestHandHistory := OnRequestHandHistory;
  ProcessModule.OnRequestHandHistorySent := OnRequestHandHistorySent;
  ProcessModule.OnRequestHandHistoryFailed := OnRequestHandHistoryFailed;
end;

procedure TRequestHandHistoryForm.FormDestroy(Sender: TObject);
begin
  ProcessModule.OnRequestHandHistory := nil;
  ProcessModule.OnRequestHandHistorySent := nil;
  ProcessModule.OnRequestHandHistoryFailed := nil;
end;

procedure TRequestHandHistoryForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TRequestHandHistoryForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TRequestHandHistoryForm.DisableControls;
var
  Loop: Integer;
begin
  cursor := crHourGlass;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TRequestHandHistoryForm.EnableControls;
var
  Loop: Integer;
begin
  cursor := crDefault;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := true;
end;

procedure TRequestHandHistoryForm.LastHandsRadioButtonClick(
  Sender: TObject);
begin
  LastHandsSpinEdit.Enabled := true;
  HandNumberComboBox.Enabled := false;
end;

procedure TRequestHandHistoryForm.HandNumberRadioButtonClick(
  Sender: TObject);
begin
  LastHandsSpinEdit.Enabled := false;
  HandNumberComboBox.Enabled := true;
end;

procedure TRequestHandHistoryForm.HandNumberComboBoxKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 27 then
    Close;
  if key = 13 then
    OkButtonClick(OkButton);
end;

procedure TRequestHandHistoryForm.HandNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not ((key >= '0') and (key <='9'))) or (length((Sender as TTeEdit).Text) > 9) then
    key := #0;
end;

procedure TRequestHandHistoryForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TRequestHandHistoryForm.OkButtonClick(Sender: TObject);
var
  HandID: Integer;
  LastHands: Integer;
  Direction: Integer;
begin
  if LastHandsRadioButton.Checked then
  begin
    HandID := 0;
    LastHands := LastHandsSpinEdit.AsInteger;
  end
  else
  begin
    HandID := StrToIntDef(HandNumberComboBox.Text, 0);
    LastHands := 0;
  end;

  if OldestFirstRadioButton.Checked then
    Direction := 0
  else
    Direction := 1;

  DisableControls;
  ProcessModule.Do_RequestHandHistory(HandID, LastHands, Direction);
end;

procedure TRequestHandHistoryForm.OnRequestHandHistory(FirstHandID: Integer);
var
  Loop: Integer;
begin
  LastHandsSpinEdit.Value := 5;
  HandNumberComboBox.Items.Clear;

  if ProcessModule.PreviousHands.Count > 0 then
  begin
    for Loop := ProcessModule.PreviousHands.Count - 1 downto 0 do
      HandNumberComboBox.Items.Add(inttostr(ProcessModule.PreviousHands.Items(Loop).ID));
    if (FirstHandID > 0) or (ProcessModule.PreviousHands.Count = 0) then
      HandNumberComboBox.Text := inttostr(FirstHandID)
    else
      HandNumberComboBox.Text := inttostr(
        ProcessModule.PreviousHands.Items(ProcessModule.PreviousHands.Count - 1).ID);
  end
  else
    HandNumberComboBox.Text := '';

  LastHandsRadioButtonClick(LastHandsRadioButton);
  LastHandsRadioButton.Checked := true;
  OldestFirstRadioButton.Checked := true;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TRequestHandHistoryForm.OnRequestHandHistorySent;
begin
  EnableControls;
  ThemeEngineModule.ShowMessage(cstrProcessRequestHandHistorySend);
  Close;
end;

procedure TRequestHandHistoryForm.OnRequestHandHistoryFailed;
begin
  EnableControls;
end;

end.
