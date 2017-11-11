unit uChangeValidateEmailForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, StdCtrls;

type
  TChangeValidateEmailForm = class(TForm)
    TeLabel1: TTeLabel;
    TeGroupBox1: TTeGroupBox;
    TeLabel2: TTeLabel;
    TeLabel3: TTeLabel;
    EMailEdit: TTeEdit;
    TeGroupBox2: TTeGroupBox;
    TeLabel4: TTeLabel;
    SendEMailButton: TTeButton;
    TeLabel5: TTeLabel;
    ValidationCodeEdit: TTeEdit;
    ValidateButton: TTeButton;
    CancelButton: TTeButton;
    PlayerIDLabel: TTeLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    TeButton1: TTeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ValidateButtonClick(Sender: TObject);
    procedure SendEMailButtonClick(Sender: TObject);
    procedure EmailEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ValidationCodeEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure ValidationCodeEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure OnGetProfileForChangeEMail;
    procedure OnChangeValidateEMail;
    procedure OnValidatedEMail;
    procedure OnValidateEMailFailed;
    procedure DisableControls;
    procedure EnableControls;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangeValidateEmailForm: TChangeValidateEmailForm;

implementation

uses
  uThemeEngineModule,
  uLogger,
  uConstants,
  uUserModule;

{$R *.dfm}

{ TChangeValidateEmailForm }

procedure TChangeValidateEmailForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TChangeValidateEmailForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Change/Validate Email Address';
  ThemeEngineModule.FormsChangeConstraints(Self,  315, 305);
  UserModule.OnGetProfileForChangeEMail := OnGetProfileForChangeEMail;
  UserModule.OnChangeValidateEMail := OnChangeValidateEMail;
  UserModule.OnValidatedEMail := OnValidatedEMail;
  UserModule.OnValidateEMailFailed := OnValidateEMailFailed;
end;

procedure TChangeValidateEmailForm.FormDestroy(Sender: TObject);
begin
  UserModule.OnGetProfileForChangeEMail := nil;
  UserModule.OnChangeValidateEMail := nil;
  UserModule.OnValidatedEMail := nil;
  UserModule.OnValidateEMailFailed := nil;
end;

procedure TChangeValidateEmailForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TChangeValidateEmailForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := true;
end;

procedure TChangeValidateEmailForm.OnChangeValidateEMail;
begin
  EnableControls;
  PlayerIDLabel.Caption := UserModule.UserName;
  EMailEdit.Text := UserModule.UserEMail;
  ValidationCodeEdit.Text := '';
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TChangeValidateEmailForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TChangeValidateEmailForm.SendEMailButtonClick(Sender: TObject);
begin
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

  UserModule.Do_ChangeEMail(EMailEdit.Text);
  Close;
end;

procedure TChangeValidateEmailForm.ValidateButtonClick(Sender: TObject);
var
  nValidationCode: Integer;
begin
  if (ValidationCodeEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrUserValidationCodeEmpty);
    exit;
  end;

  nValidationCode := StrToIntDef(ValidationCodeEdit.Text, 0);
  if nValidationCode = 0 then
  begin
    ThemeEngineModule.ShowMessage(cstrUserValidationCodeInvalid);
    exit;
  end;

  DisableControls;
  UserModule.Do_ValidateEMail(nValidationCode);
end;

procedure TChangeValidateEmailForm.OnValidatedEMail;
begin
  ThemeEngineModule.ShowMessage(cstrUserValidatedEMail);
  Close;
end;

procedure TChangeValidateEmailForm.OnValidateEMailFailed;
begin
  ThemeEngineModule.ShowMessage(cstrUserValidateEMailFailed);
  Close;
end;

procedure TChangeValidateEmailForm.OnGetProfileForChangeEMail;
begin
  if Visible then
    OnChangeValidateEMail;
end;

procedure TChangeValidateEmailForm.EmailEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 27 then
    Close;

  if key = 13 then
    SendEMailButtonClick(SendEMailButton);
end;

procedure TChangeValidateEmailForm.ValidationCodeEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 27 then
    Close;

  if key = 13 then
    ValidateButtonClick(ValidateButton);
end;

procedure TChangeValidateEmailForm.ValidationCodeEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  if (Key < '0') or (Key > '9') then
    Key := #0;
end;

procedure TChangeValidateEmailForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TChangeValidateEmailForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;


procedure TChangeValidateEmailForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  UserModule.Do_ValidateEmailClose;
end;

end.
