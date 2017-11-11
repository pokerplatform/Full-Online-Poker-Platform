unit uWithdrawalForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ComCtrls, StdCtrls;

type
  TWithdrawalForm = class(TForm)
    BackgroundPanel: TTeHeaderPanel;
    TeLabel1: TTeLabel;
    TeLabel2: TTeLabel;
    WithdrawalButton: TTeButton;
    CancelButton: TTeButton;
    TeLabel4: TTeLabel;
    TeLabel5: TTeLabel;
    TeLabel6: TTeLabel;
    TeLabel7: TTeLabel;
    AmountEdit: TTeEdit;
    MoneyAvailableLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure WithdrawalButtonClick(Sender: TObject);
    procedure AmountEditKeyPress(Sender: TObject; var Key: Char);
  private
    MaxAmount: Currency;

    procedure OnWithdrawal;
    procedure OnWithdrawalSuccess;
    procedure OnWithdrawalFailed;
    procedure DisableControls;
    procedure EnableControls;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  WithdrawalForm: TWithdrawalForm;

implementation

uses
  uLogger, uConstants, uConversions, uDataList,
  uThemeEngineModule, uUserModule, uCashierModule;

{$R *.dfm}

procedure TWithdrawalForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self, 381, 289);
  CashierModule.OnWithdrawal := OnWithdrawal;
  CashierModule.OnWithdrawalSuccess := OnWithdrawalSuccess;
  CashierModule.OnWithdrawalFailed := OnWithdrawalFailed;
end;

procedure TWithdrawalForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TWithdrawalForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TWithdrawalForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TWithdrawalForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;


procedure TWithdrawalForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  BackgroundPanel.Cursor := crHourGlass;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TWithdrawalForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  BackgroundPanel.Cursor := crDefault;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := true;
end;


procedure TWithdrawalForm.OnWithdrawal;
var
  curData: TDataList;
begin
  EnableControls;
  MaxAmount := 0;
  if CashierModule.Balance.Find(RealMoneyCurrencyID, curData) then
    MaxAmount := curData.ValuesAsCurrency['balance'];

  if MaxAmount >= MinWithdrawalAmount then
  begin
    MoneyAvailableLabel.Caption := Conversions.Cur2Str(MaxAmount, 2, 2);
    AmountEdit.Text := MoneyAvailableLabel.Caption;
    if MaxAmount > 50 then
      AmountEdit.Text := '50.00';
  end
  else
  begin
    MaxAmount := 0;
    MoneyAvailableLabel.Caption := '0.00';
    AmountEdit.Text := '0.00';
    AmountEdit.Enabled := false;
  end;

  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TWithdrawalForm.WithdrawalButtonClick(Sender: TObject);
var
  curAmount: Currency;
begin
  curAmount := StrToCurrDef(AmountEdit.Text, 0);
  if (curAmount < MinWithdrawalAmount) or (curAmount > MaxAmount) then
  begin
    ThemeEngineModule.ShowWarning(cstrCashierWithdrawalAmountIncorrect);
    ActiveControl := AmountEdit;
    Exit;
  end;

  DisableControls;
  CashierModule.Do_MakeWithdraw(curAmount);
end;

procedure TWithdrawalForm.OnWithdrawalFailed;
begin
  ThemeEngineModule.ShowMessage(cstrCashierWithdrawFailed);
  EnableControls;
end;

procedure TWithdrawalForm.OnWithdrawalSuccess;
begin
  ThemeEngineModule.ShowMessage(cstrCashierWithdrawSuccessfull);
  Close;
end;

procedure TWithdrawalForm.AmountEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(((Key >= '0') and (Key <= '9')) or (Key < ' ') or (Key = '.')) then
    Key := #0;
end;

end.
