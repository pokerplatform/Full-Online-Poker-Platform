unit uTransferFundsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls;

type
  TTransferFundsForm = class(TForm)
    TransferCountLabel: TTeLabel;
    AmountEdit: TTeEdit;
    PlayerNameEdit: TTeEdit;
    PlayerNameLabel: TTeLabel;
    InfoLabel: TTeLabel;
    OkButton: TTeButton;
    CancelButton: TTeButton;
    BackgroundPanel: TTeHeaderPanel;
    procedure FormCreate(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure AmountEditKeyPress(Sender: TObject; var Key: Char);
    procedure PlayerNameEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;  
  public
    { Public declarations }
  end;

var
  TransferFundsForm: TTransferFundsForm;

implementation

uses uUserModule, uThemeEngineModule, uConstants;

{$R *.dfm}

procedure TTransferFundsForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Transfer Funds';
  ThemeEngineModule.FormsChangeConstraints(Self, 311,189);
end;

procedure TTransferFundsForm.OkButtonClick(Sender: TObject);
var Loop : Integer;
    text : string;
begin
 Text :=  AmountEdit.Text;
 if (pos(',',Text) <> 0) or (pos('.',Text) <> 0) then
 begin
   ThemeEngineModule.ShowModalMessage(cstrUserNotNumbers);
   exit;
 end;
 for Loop := 1 to Length(Text) do
 begin
   if (Text[Loop] in ['A'..'Z']) or (Text[Loop] in ['a'..'z']) then
   begin
    ThemeEngineModule.ShowModalMessage(cstrUserNotNumbers);
    exit;
   end;
 end;
 if Text = '' then
 begin
  ThemeEngineModule.ShowModalMessage(cstrUserAmountEmpty);
  exit;
 end;
 if StrToInt(Text) <= 0 then
 begin
  ThemeEngineModule.ShowModalMessage(cstrUserAmountEmpty);
  exit;
 end;
 if PlayerNameEdit.Text = '' then
 begin
  ThemeEngineModule.ShowModalMessage(cstrUserPlayerIDEmpty);
  exit;
 end;
  UserModule.Do_TransferMoneyTo(UserModule.UserID,StrToInt(Text),UserModule.UserName,PlayerNameEdit.Text);
  close;
end;

procedure TTransferFundsForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTransferFundsForm.FormActivate(Sender: TObject);
begin
  PlayerNameEdit.Text := '';
  AmountEdit.Text := '10';
end;

procedure TTransferFundsForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TTransferFundsForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TTransferFundsForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TTransferFundsForm.AmountEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    ActiveControl := PlayerNameEdit;
  if key = #27 then
    Close;{}
end;

procedure TTransferFundsForm.PlayerNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
 if key = #13 then
    OkButtonClick(Sender);
  if key = #27 then
    Close;{}
end;

end.
