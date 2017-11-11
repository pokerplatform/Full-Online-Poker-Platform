unit uChangeProfileForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls;

type
  TChangeProfileForm = class(TForm)
    BackgroundPanel: TTeHeaderPanel;
    TeLabel1: TTeLabel;
    TeLabel4: TTeLabel;
    TeLabel6: TTeLabel;
    TeLabel7: TTeLabel;
    TeLabel8: TTeLabel;
    TeLabel9: TTeLabel;
    TeLabel11: TTeLabel;
    SaveButton: TTeButton;
    CancelButton: TTeButton;
    FirstNameEdit: TTeEdit;
    LastNameEdit: TTeEdit;
    LocationEdit: TTeEdit;
    MaleRadioButton: TTeRadioButton;
    FemaleRadioButton: TTeRadioButton;
    LocationYesRadioButton: TTeRadioButton;
    LocationNoRadioButton: TTeRadioButton;
    PlayerIDLabel: TTeLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure EditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
  private

    procedure OnGetProfile;
    procedure OnChangeProfile;
    procedure OnChangedProfile;
    procedure OnChangeProfileFailed;

    procedure DisableControls;
    procedure EnableControls;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ChangeProfileForm: TChangeProfileForm;

implementation

uses
  uLogger,
  uUserModule,
  uConstants,
  uThemeEngineModule;

{$R *.dfm}

procedure TChangeProfileForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Change profile'; 
  ThemeEngineModule.FormsChangeConstraints(Self, 305, 227);
  UserModule.OnGetProfile := OnGetProfile;
  UserModule.OnChangeProfile := OnChangeProfile;
  UserModule.OnChangedProfile := OnChangedProfile;
  UserModule.OnChangeProfileFailed := OnChangeProfileFailed;
end;

procedure TChangeProfileForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TChangeProfileForm.FormDestroy(Sender: TObject);
begin
  UserModule.OnGetProfile := nil;
  UserModule.OnChangeProfile := nil;
  UserModule.OnChangedProfile := nil;
  UserModule.OnChangeProfileFailed := nil;
end;


procedure TChangeProfileForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TChangeProfileForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TChangeProfileForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := true;
end;

procedure TChangeProfileForm.OnChangeProfile;
begin
  EnableControls;
  PlayerIDLabel.Caption := UserModule.UserName;
  FirstNameEdit.Text := UserModule.UserFirstName;
  LastNameEdit.Text := UserModule.UserLastName;
  LocationEdit.Text := UserModule.UserLocation;

  if UserModule.UserShowLocation then
    LocationYesRadioButton.Checked := true
  else
    LocationNoRadioButton.Checked := true;

  if UserModule.UserSexID = 1 then
    MaleRadioButton.Checked := true
  else
    FemaleRadioButton.Checked := true;

  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TChangeProfileForm.SaveButtonClick(Sender: TObject);
var
  SexID: Integer;
begin
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
  UserModule.Do_UpdateProfile(FirstNameEdit.Text, LastNameEdit.Text,
    LocationEdit.Text, LocationYesRadioButton.Checked, SexID);
end;

procedure TChangeProfileForm.OnChangedProfile;
begin
  ThemeEngineModule.ShowMessage(cstrUserChangedProfile);
  EnableControls;
  Close;
end;

procedure TChangeProfileForm.OnChangeProfileFailed;
begin
  EnableControls;
  Close;
end;

procedure TChangeProfileForm.OnGetProfile;
begin
  if Visible then
    OnChangeProfile;
end;

procedure TChangeProfileForm.EditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then
    Close;
  if key = 13 then
    SaveButtonClick(SaveButton);
end;

procedure TChangeProfileForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TChangeProfileForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

end.
