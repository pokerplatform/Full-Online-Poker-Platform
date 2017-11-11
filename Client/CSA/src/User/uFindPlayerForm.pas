unit uFindPlayerForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, te_controls;

type
  TFindPlayerForm = class(TForm)
    TeForm: TTeForm;
    PlayerIDEdit: TTeEdit;
    FindButton: TTeButton;
    CancelButton: TTeButton;
    PlayerIDLabel: TLabel;
    TeLabel1: TTeLabel;
    procedure FormCreate(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure FindButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PlayerIDEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;  
  end;

var
  FindPlayerForm: TFindPlayerForm;

implementation

uses uThemeEngineModule, uUserModule, uConstants;

{$R *.dfm}

procedure TFindPlayerForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TFindPlayerForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Find Player';
  ThemeEngineModule.FormsChangeConstraints(Self, 275,117);
end;

procedure TFindPlayerForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
 ThemeEngineModule.FormsMaximized(Self);
end;

procedure TFindPlayerForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TFindPlayerForm.FindButtonClick(Sender: TObject);
begin
 if PlayerIDEdit.Text = '' then
 begin
  ThemeEngineModule.ShowModalMessage(cstrUserPlayerIDEmpty);
  exit;
 end;
  UserModule.Do_FindPlayer(PlayerIDEdit.text);
  close;
end;

procedure TFindPlayerForm.CancelButtonClick(Sender: TObject);
begin
  close;
end;

procedure TFindPlayerForm.FormActivate(Sender: TObject);
begin
  PlayerIDEdit.SetFocus;
  PlayerIDEdit.Text := '';
end;

procedure TFindPlayerForm.PlayerIDEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
   FindButton.Click;
end;

end.
