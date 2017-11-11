unit uChangePasswordForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, StdCtrls;

type
  TChangePasswordForm = class(TForm)
    TeGroupBox1: TTeGroupBox;
    SaveButton: TTeButton;
    CancelButton: TTeButton;
    TeLabel1: TTeLabel;
    TeLabel2: TTeLabel;
    CurrentPasswordEdit: TTeEdit;
    TeLabel3: TTeLabel;
    PasswordEdit: TTeEdit;
    TeLabel4: TTeLabel;
    ConfirmEdit: TTeEdit;
    TeLabel5: TTeLabel;
    RememberCheckBox: TTeCheckBox;
    PlayerIDLabel: TTeLabel;
    GroupBox1: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ConfirmEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
  private
    procedure OnChangePassword;
    procedure OnChangedPassword;
    procedure OnChangePasswordFailed;
    procedure DisableControls;
    procedure EnableControls;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ChangePasswordForm: TChangePasswordForm;

implementation

uses
  uLogger,
  uConstants,
  uThemeEngineModule, uUserModule;

{$R *.dfm}

procedure TChangePasswordForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Change password';
  ThemeEngineModule.FormsChangeConstraints(Self, 280, 250);
  UserModule.OnChangePassword := OnChangePassword;
  UserModule.OnChangedPassword := OnChangedPassword;
  UserModule.OnChangePasswordFailed := OnChangePasswordFailed;
end;

procedure TChangePasswordForm.FormDestroy(Sender: TObject);
begin
  UserModule.OnChangePassword := nil;
  UserModule.OnChangedPassword := nil;
  UserModule.OnChangePasswordFailed := nil;
end;

procedure TChangePasswordForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TChangePasswordForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TChangePasswordForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TChangePasswordForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := true;
end;

procedure TChangePasswordForm.OnChangePassword;
begin
  EnableControls;
  PlayerIDLabel.Caption := UserModule.UserName;
  CurrentPasswordEdit.Text := '';
  PasswordEdit.Text := '';
  ConfirmEdit.Text := '';
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TChangePasswordForm.SaveButtonClick(Sender: TObject);
var
  Loop: Integer;
  AlphaExists: Boolean;
  DigitExists: Boolean;
begin
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

  if (CurrentPasswordEdit.Text = '') or (PasswordEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserPasswordEmpty);
    exit;
  end;

  if (PasswordEdit.Text <> ConfirmEdit.Text) then
  begin
    ThemeEngineModule.ShowMessage(cstrUserPassNotEqual);
    exit;
  end;
  
  DisableControls;
  UserModule.Do_ChangePassword(CurrentPasswordEdit.Text, PasswordEdit.Text,
    RememberCheckBox.Checked);
end;

procedure TChangePasswordForm.OnChangedPassword;
begin
  ThemeEngineModule.ShowMessage(cstrUserChangedPassword);
  Close;
end;

procedure TChangePasswordForm.OnChangePasswordFailed;
begin
  ThemeEngineModule.ShowMessage(cstrUserChangePasswordFailed);
  Close;
end;

procedure TChangePasswordForm.ConfirmEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 27 then
    Close;
  if key = 13 then
    SaveButtonClick(SaveButton);
end;

procedure TChangePasswordForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TChangePasswordForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

end.
