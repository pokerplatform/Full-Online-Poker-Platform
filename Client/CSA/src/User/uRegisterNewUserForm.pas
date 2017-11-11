unit uRegisterNewUserForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls;

type
  TRegisterNewUserForm = class(TForm)
    BackgroundPanel: TTeHeaderPanel;
    TeLabel1: TTeLabel;
    TeLabel2: TTeLabel;
    TeLabel3: TTeLabel;
    TeLabel4: TTeLabel;
    TeLabel5: TTeLabel;
    TeLabel6: TTeLabel;
    TeLabel7: TTeLabel;
    TeLabel8: TTeLabel;
    TeLabel9: TTeLabel;
    PlayerIDEdit: TTeEdit;
    PasswordEdit: TTeEdit;
    RegisterButton: TTeButton;
    CancelButton: TTeButton;
    ConfirmEdit: TTeEdit;
    FirstNameEdit: TTeEdit;
    LastNameEdit: TTeEdit;
    LocationEdit: TTeEdit;
    MaleRadioButton: TTeRadioButton;
    FemaleRadioButton: TTeRadioButton;
    EMailEdit: TTeEdit;
    LocationYesRadioButton: TTeRadioButton;
    LocationNoRadioButton: TTeRadioButton;
    TeLabel10: TTeLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure RegisterButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
  private
    GoodResult: Boolean;

    procedure OnNewUser;
    procedure OnNewUserRegistered;
    procedure OnNewUserFailed;

    procedure DisableControls;
    procedure Clear;
    procedure EnableControls;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public

    { Public declarations }
  end;

var
  RegisterNewUserForm: TRegisterNewUserForm;

implementation

uses
  uLogger,
  uUserModule,
  uConstants,
  uThemeEngineModule;

{$R *.dfm}

procedure TRegisterNewUserForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Register new user';
  ThemeEngineModule.FormsChangeConstraints(Self, 319, 307);

  Clear;
  UserModule.OnNewUser := OnNewUser;
  UserModule.OnNewUserRegistered := OnNewUserRegistered;
  UserModule.OnNewUserFailed := OnNewUserFailed;
end;

procedure TRegisterNewUserForm.FormDestroy(Sender: TObject);
begin
  Clear;
end;

procedure TRegisterNewUserForm.Clear;
begin
  GoodResult := false;
  UserModule.OnNewUser := nil;
  UserModule.OnNewUserRegistered := nil;
  UserModule.OnNewUserFailed := nil;
end;


procedure TRegisterNewUserForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TRegisterNewUserForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  BackgroundPanel.Cursor := crHourGlass;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TRegisterNewUserForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  BackgroundPanel.Cursor := crDefault;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := true;
end;

procedure TRegisterNewUserForm.OnNewUser;
begin
  EnableControls;
  GoodResult := false;
  PlayerIDEdit.Text := '';
  PasswordEdit.Text := '';
  ConfirmEdit.Text := '';
  FirstNameEdit.Text := '';
  LastNameEdit.Text := '';
  EMailEdit.Text := '';
  LocationEdit.Text := '';
  MaleRadioButton.Checked := true;
  FemaleRadioButton.Checked := false;
  ActiveControl := PlayerIDEdit;
  LocationYesRadioButton.Checked := true;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TRegisterNewUserForm.RegisterButtonClick(Sender: TObject);
var
  SexID: Integer;
  Loop: Integer;
  AlphaExists: Boolean;
  DigitExists: Boolean;
begin
  if PlayerIDEdit.Text = '' then
  begin
    ThemeEngineModule.ShowMessage(cstrUserNameEmpty);
    exit;
  end;

  if Length(PlayerIDEdit.Text) > 11 then
  begin
    ThemeEngineModule.ShowMessage(cstrUserNameInvalid);
    exit;
  end;

  for Loop := 1 to Length(PlayerIDEdit.Text) do
    if not ((PlayerIDEdit.Text[Loop] = '_') or (PlayerIDEdit.Text[Loop] = ' ') or
     ((PlayerIDEdit.Text[Loop] >= '0') and (PlayerIDEdit.Text[Loop] <= '9')) or
     ((PlayerIDEdit.Text[Loop] >= 'a') and (PlayerIDEdit.Text[Loop] <= 'z')) or
     ((PlayerIDEdit.Text[Loop] >= 'A') and (PlayerIDEdit.Text[Loop] <= 'Z'))) then
    begin
      ThemeEngineModule.ShowMessage(cstrUserNameInvalid);
      exit;
    end;

  if (PasswordEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserPasswordEmpty);
    exit;
  end;

  if Length(PasswordEdit.Text) < 6 then
  begin
    ThemeEngineModule.ShowMessage(cstrUserPasswordInvalid);
    exit;
  end;

  AlphaExists := false;
  DigitExists := false;
  for Loop := 1 to Length(PasswordEdit.Text) do
  begin
    if (PasswordEdit.Text[Loop] >= '0') and (PasswordEdit.Text[Loop] <= '9') then
      DigitExists := true;

    if ((PasswordEdit.Text[Loop] >= 'a') and (PasswordEdit.Text[Loop] <= 'z')) or
     ((PasswordEdit.Text[Loop] >= 'A') and (PasswordEdit.Text[Loop] <= 'Z')) then
      AlphaExists := true;
  end;

  if (not DigitExists) or (not AlphaExists) then
  begin
    ThemeEngineModule.ShowMessage(cstrUserPasswordInvalid);
    exit;
  end;

  if PasswordEdit.Text <> ConfirmEdit.Text then
  begin
    ThemeEngineModule.ShowMessage(cstrUserPassNotEqual);
    exit;
  end;

  if FirstNameEdit.Text = '' then
  begin
    ThemeEngineModule.ShowMessage(cstrUserFirstNameEmpty);
    exit;
  end;

  if LastNameEdit.Text = '' then
  begin
    ThemeEngineModule.ShowMessage(cstrUserLastNameEmpty);
    exit;
  end;

  if EMailEdit.Text = '' then
  begin
    ThemeEngineModule.ShowMessage(cstrUserEMailEmpty);
    exit;
  end;

  if (pos('@', EMailEdit.Text) = 0) or (pos('.', EMailEdit.Text) = 0) then
  begin
    ThemeEngineModule.ShowMessage(cstrUserEMailInvalid);
    exit;
  end;

  if LocationEdit.Text = '' then
  begin
    ThemeEngineModule.ShowMessage(cstrUserLocationEmpty);
    exit;
  end;

  DisableControls;
  if MaleRadioButton.Checked then
    SexID := 1
  else
    SexID := 2;
  UserModule.Do_NewUser(PlayerIDEdit.Text, PasswordEdit.Text, FirstNameEdit.Text,
    LastNameEdit.Text, EMailEdit.Text, LocationEdit.Text, LocationYesRadioButton.Checked, SexID);
end;

procedure TRegisterNewUserForm.OnNewUserRegistered;
begin
  GoodResult := true;
  ThemeEngineModule.ShowMessage(cstrUserRegistered);
  EnableControls;
  Close;
end;

procedure TRegisterNewUserForm.OnNewUserFailed;
begin
  EnableControls;
end;


procedure TRegisterNewUserForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TRegisterNewUserForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not GoodResult then
    UserModule.Do_CancelLogin;
end;

procedure TRegisterNewUserForm.EditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 27 then
    Close;
  if key = 13 then
    RegisterButtonClick(RegisterButton);
end;

procedure TRegisterNewUserForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TRegisterNewUserForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

end.
