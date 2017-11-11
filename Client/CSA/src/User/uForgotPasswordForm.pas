unit uForgotPasswordForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls;

type
  TForgotPasswordForm = class(TForm)
    TeLabel1: TTeLabel;
    TeLabel3: TTeLabel;
    TeLabel5: TTeLabel;
    TeLabel6: TTeLabel;
    TeLabel7: TTeLabel;
    TeLabel8: TTeLabel;
    PlayerIDEdit: TTeEdit;
    SaveButton: TTeButton;
    CancelButton: TTeButton;
    FirstNameEdit: TTeEdit;
    LastNameEdit: TTeEdit;
    LocationEdit: TTeEdit;
    MaleRadioButton: TTeRadioButton;
    FemaleRadioButton: TTeRadioButton;
    TeLabel9: TTeLabel;
    EMailEdit: TTeEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure LocationEditKeyPress(Sender: TObject; var Key: Char);
    procedure EMailEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
  private

    procedure OnForgotPassword;
    procedure OnForgottedPassword;
    procedure OnForgotPasswordFailed;

    procedure DisableControls;
    procedure EnableControls;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ForgotPasswordForm: TForgotPasswordForm;

implementation

uses
  uLogger,
  uUserModule,
  uConstants,
  uThemeEngineModule;

{$R *.dfm}

procedure TForgotPasswordForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Forgot Password';
  ThemeEngineModule.FormsChangeConstraints(Self, 280, 225);
  UserModule.OnForgotPassword := OnForgotPassword;
  UserModule.OnForgottedPassword := OnForgottedPassword;
  UserModule.OnForgotPasswordFailed := OnForgotPasswordFailed;
end;

procedure TForgotPasswordForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TForgotPasswordForm.FormDestroy(Sender: TObject);
begin
  UserModule.OnForgotPassword := nil;
  UserModule.OnForgottedPassword := nil;
  UserModule.OnForgotPasswordFailed := nil;
end;


procedure TForgotPasswordForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForgotPasswordForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TForgotPasswordForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := true;
end;

procedure TForgotPasswordForm.OnForgotPassword;
begin
  EnableControls;
  PlayerIDEdit.Text := '';
  FirstNameEdit.Text := '';
  LastNameEdit.Text := '';
  EMailEdit.Text := '';
  LocationEdit.Text := '';
  MaleRadioButton.Checked := true;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TForgotPasswordForm.SaveButtonClick(Sender: TObject);
var
  SexID: Integer;
begin
  if (PlayerIDEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserNameEmpty);
    exit;
  end;

  if (FirstNameEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserFirstNameEmpty);
    exit;
  end;

  if (LastNameEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserLastNameEmpty);
    exit;
  end;

  if (EMailEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserEMailEmpty);
    exit;
  end;

  if (pos('@', EMailEdit.Text) = 0) or (pos('.', EMailEdit.Text) = 0) then
  begin
    ThemeEngineModule.ShowMessage(cstrUserEMailInvalid);
    exit;
  end;

  if (LocationEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserLocationEmpty);
    exit;
  end;

  DisableControls;
  if MaleRadioButton.Checked then
    SexID := 1
  else
    SexID := 2;
  UserModule.Do_ForgotPassword(PlayerIDEdit.Text, FirstNameEdit.Text, LastNameEdit.Text,
    EMailEdit.Text, LocationEdit.Text, SexID);
end;

procedure TForgotPasswordForm.OnForgottedPassword;
begin
  ThemeEngineModule.ShowMessage(cstrUserForgotPassword);
  EnableControls;
  Close;
end;

procedure TForgotPasswordForm.OnForgotPasswordFailed;
begin
  EnableControls;
  Close;
end;

procedure TForgotPasswordForm.LocationEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if length((Sender as TTeEdit).Text) > (Sender as TTeEdit).Tag then
    Key := #0;
  if key = #27 then
    Close;  
end;

procedure TForgotPasswordForm.EMailEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 13 then
    SaveButtonClick(SaveButton);
end;

procedure TForgotPasswordForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TForgotPasswordForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

end.
