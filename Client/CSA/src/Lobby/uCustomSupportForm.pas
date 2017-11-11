unit uCustomSupportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, StdCtrls;

type
  TCustomSupportForm = class(TForm)
    SendButton: TTeButton;
    CancelButton: TTeButton;
    TeLabel1: TTeLabel;
    SubjectEdit: TTeEdit;
    MessageMemo: TTeMemo;
    TeLabel2: TTeLabel;
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure SendButtonClick(Sender: TObject);
  private
    procedure OnCustomSupport;
    procedure OnCustomSupportSent;
    procedure OnCustomSupportFailed;
    procedure DisableControls;
    procedure EnableControls;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  CustomSupportForm: TCustomSupportForm;

implementation

uses
  uLogger,
  uLobbyModule,
  uConstants,
  uThemeEngineModule;

{$R *.dfm}

procedure TCustomSupportForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Custom support';
  ThemeEngineModule.FormsChangeConstraints(Self, 430, 185);
  LobbyModule.OnCustomSupport := OnCustomSupport;
  LobbyModule.OnCustomSupportSent := OnCustomSupportSent;
  LobbyModule.OnCustomSupportFailed := OnCustomSupportFailed;
end;

procedure TCustomSupportForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TCustomSupportForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TCustomSupportForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TCustomSupportForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TCustomSupportForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  CustomSupportForm.Cursor := crHourGlass;
  for Loop := 0 to CustomSupportForm.ControlCount - 1 do
   CustomSupportForm.Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TCustomSupportForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  CustomSupportForm.Cursor := crDefault;
  for Loop := 0 to CustomSupportForm.ControlCount - 1 do
    CustomSupportForm.Controls[Loop].Enabled := true;
end;

procedure TCustomSupportForm.OnCustomSupport;
begin
  SubjectEdit.Text := '';
  MessageMemo.Lines.Text := '';
  EnableControls;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TCustomSupportForm.OnCustomSupportSent;
begin
  ThemeEngineModule.ShowMessage(cstrCustomSupportSent);
  Close;
end;

procedure TCustomSupportForm.OnCustomSupportFailed;
begin
  ThemeEngineModule.ShowWarning(cstrCustomSupportFailed);
  EnableControls;
end;

procedure TCustomSupportForm.SendButtonClick(Sender: TObject);
begin
  DisableControls;
  LobbyModule.Do_SendCustomSupportMessage(SubjectEdit.Text, MessageMemo.Lines.Text);
end;

end.
