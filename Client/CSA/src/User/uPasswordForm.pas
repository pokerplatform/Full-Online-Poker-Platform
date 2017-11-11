unit uPasswordForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPasswordForm = class(TForm)
    PasswordEdit: TEdit;
    OkButon: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PasswordEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OkButonClick(Sender: TObject);
  private
    { Private declarations }
    FTournamentID: Integer;
  public
    { Public declarations }
    procedure ShowForm(TournamentID: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;  
  end;

var
  PasswordForm: TPasswordForm;

implementation

uses uThemeEngineModule, uTournamentModule, uSessionModule;

{$R *.dfm}

{ TPasswordForm }

procedure TPasswordForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TPasswordForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self,  265, 112);
  Caption := SessionModule.AppName + ' - Password';
end;

procedure TPasswordForm.FormShow(Sender: TObject);
begin
  PasswordEdit.Text := '';
  PasswordEdit.SetFocus;
end;

procedure TPasswordForm.ShowForm(TournamentID: Integer);
begin
  FTournamentID := TournamentID;
  ShowModal;
end;

procedure TPasswordForm.PasswordEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
   OkButonClick(Sender);
end;

procedure TPasswordForm.OkButonClick(Sender: TObject);
begin
   TournamentModule.Do_Register(FTournamentID, PasswordEdit.Text);
   Close;
end;

end.
