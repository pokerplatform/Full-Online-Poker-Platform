unit uLoginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls;

type
  TLoginForm = class(TForm)
    BackgroundPanel: TTeHeaderPanel;
    TeLabel1: TTeLabel;
    TeLabel2: TTeLabel;
    TeLabel3: TTeLabel;
    PlayerIDEdit: TTeEdit;
    PasswordEdit: TTeEdit;
    LoginButton: TTeButton;
    CancelButton: TTeButton;
    NewUserButton: TTeButton;
    RememberCheckBox: TTeCheckBox;
    ForgotPasswordButton: TTeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure NewUserButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PlayerIDEditKeyPress(Sender: TObject; var Key: Char);
    procedure PasswordEditKeyPress(Sender: TObject; var Key: Char);
    procedure ForgotPasswordButtonClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
  private
    GoodResult: Boolean;

    procedure OnLogin;
    procedure OnLogged;
    procedure OnloginFailed;

    procedure EnableControls;
    procedure DisableControls;
    procedure Clear;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
  
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

uses
  uLogger,
  uConstants,
  uUserModule,
  uThemeEngineModule;

{$R *.dfm}

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self,  346, 136);
  Caption := 'Login to ' + AppName;
  //TeForm.Caption := Caption;

  Clear;
  UserModule.OnLogin := OnLogin;
  UserModule.OnLogged := OnLogged;
  UserModule.OnLoginFailed := OnloginFailed;
end;

procedure TLoginForm.FormDestroy(Sender: TObject);
begin
  Clear;
end;

procedure TLoginForm.Clear;
begin
  GoodResult := false;
  UserModule.OnLogin := nil;
  UserModule.OnLogged := nil;
  UserModule.OnLoginFailed := nil;
end;


procedure TLoginForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TLoginForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  BackgroundPanel.Cursor := crHourGlass;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TLoginForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  ForgotPasswordButton.Visible := false;
  CancelButton.Visible := true;
  BackgroundPanel.Cursor := crDefault;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := true;
end;

procedure TLoginForm.OnLogin;
begin
  GoodResult := false;
  EnableControls;
  PlayerIDEdit.Text := UserModule.UserName;
  PasswordEdit.Text := UserModule.UserPassword;
  RememberCheckBox.Checked := UserModule.AutoSave;
  ActiveControl := PlayerIDEdit;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TLoginForm.LoginButtonClick(Sender: TObject);
begin
  if (PlayerIDEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserNameEmpty);
    exit;
  end;

  if (PasswordEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserPasswordEmpty);
    exit;
  end;

  DisableControls;
  UserModule.Do_Login(PlayerIDEdit.Text, PasswordEdit.Text, RememberCheckBox.Checked);
end;

procedure TLoginForm.OnLogged;
begin
  GoodResult := true;
  EnableControls;
  Close;
end;

procedure TLoginForm.OnloginFailed;
begin
  EnableControls;
  ForgotPasswordButton.Visible := true;
  CancelButton.Visible := false;
end;

procedure TLoginForm.ForgotPasswordButtonClick(Sender: TObject);
begin
  UserModule.ForgotPassword;
  EnableControls;
end;

procedure TLoginForm.NewUserButtonClick(Sender: TObject);
begin
  UserModule.NewUser;
  GoodResult := true;
  Close;
end;

procedure TLoginForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not GoodResult then
    UserModule.Do_CancelLogin;
end;

procedure TLoginForm.PlayerIDEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    ActiveControl := PasswordEdit;
  if length((Sender as TTeEdit).Text) > (Sender as TTeEdit).Tag then
    Key := #0;
  if key = #27 then
    Close;  
end;

procedure TLoginForm.PasswordEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    LoginButtonClick(Sender);
  if length((Sender as TTeEdit).Text) > (Sender as TTeEdit).Tag then
    Key := #0;
  if key = #27 then
    Close;  
end;

procedure TLoginForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TLoginForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

end.
