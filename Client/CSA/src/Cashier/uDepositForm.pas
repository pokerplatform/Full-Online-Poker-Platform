unit uDepositForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ComCtrls, ExtCtrls, GIFImage, jpeg;

type
  TDepositForm = class(TForm)
    CancelButton: TTeButton;
    BackgroundPanel: TTeHeaderPanel;
    TeGroupBox2: TTeGroupBox;
    VISARadioButton: TTeRadioButton;
    MasterCardRadioButton: TTeRadioButton;
    VISALogo: TImage;
    VISALabel: TTeLabel;
    MasterCardLabel: TTeLabel;
    MasterCardLogo: TImage;
    FirePayRadioButton: TTeRadioButton;
    FirePayLabel: TTeLabel;
    FirePayLogo: TImage;
    NETellerRadioButton: TTeRadioButton;
    NETellerLabel: TTeLabel;
    NETellerLogo: TImage;
    TeGroupBox1: TTeGroupBox;
    DepositButton: TTeButton;
    TeLabel1: TTeLabel;
    MailingAddressLabel: TTeLabel;
    TeLabel3: TTeLabel;
    CardNumberLabel: TTeLabel;
    CardNumberEdit: TTeEdit;
    CVVEdit: TTeEdit;
    CVVLabel: TTeLabel;
    TeLabel6: TTeLabel;
    MonthComboBox: TTeComboBox;
    YearComboBox: TTeComboBox;
    TeLabel12: TTeLabel;
    TeLabel8: TTeLabel;
    TeLabel13: TTeLabel;
    TeLabel14: TTeLabel;
    TeLabel15: TTeLabel;
    AmountEdit: TTeEdit;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure DepositButtonClick(Sender: TObject);
    procedure VISARadioButtonClick(Sender: TObject);
    procedure MasterCardRadioButtonClick(Sender: TObject);
    procedure FirePayRadioButtonClick(Sender: TObject);
    procedure NumberEditKeyPress(Sender: TObject; var Key: Char);
    procedure NETellerRadioButtonClick(Sender: TObject);
  private
    procedure OnDeposit;
    procedure OnDepositSuccess;
    procedure OnDepositFailed;

    procedure DisableControls;
    procedure EnableControls;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  DepositForm: TDepositForm;

implementation

uses
  uLogger, uConstants, uDataList,
  uThemeEngineModule, uUserModule, uCashierModule, uParserModule;

{$R *.dfm}

procedure TDepositForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Buy chips';
  ThemeEngineModule.FormsChangeConstraints(Self, 545, 435);
  CashierModule.OnDeposit := OnDeposit;
  CashierModule.OnDepositSuccess := OnDepositSuccess;
  CashierModule.OnDepositFailed := OnDepositFailed;
end;

procedure TDepositForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDepositForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TDepositForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TDepositForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;


procedure TDepositForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  BackgroundPanel.Cursor := crHourGlass;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TDepositForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  BackgroundPanel.Cursor := crDefault;
  for Loop := 0 to BackgroundPanel.ControlCount - 1 do
    BackgroundPanel.Controls[Loop].Enabled := true;

  NETellerRadioButton.Enabled := false;
  NETellerLogo.Enabled := false;
  NETellerLabel.Enabled := false;
end;


procedure TDepositForm.OnDeposit;
var
  curData: TDataList;
  MailingAddress: String;
begin
  // Mailing address
  MailingAddress := CashierModule.FirstName + ' ' + CashierModule.LastName + ','#13#10 +
  CashierModule.Address1;
  if CashierModule.Address2 <> '' then
    MailingAddress := MailingAddress + #13#10 + CashierModule.Address2;
  MailingAddress := MailingAddress + ', '#13#10;
  MailingAddress := MailingAddress + CashierModule.City + ', ' + CashierModule.ZIP + ','#13#10;

  if CashierModule.States.Find(CashierModule.StateID, curData) then
    MailingAddress := MailingAddress + curData.Name + ','#13#10
  else
    MailingAddress := MailingAddress + CashierModule.Province + ','#13#10;

  if CashierModule.Countries.Find(CashierModule.CountryID, curData) then
    MailingAddress := MailingAddress + curData.Name;

  MailingAddressLabel.Caption := MailingAddress;

  VISARadioButton.Checked := true;
  CVVLabel.Visible := true;
  CVVEdit.Visible := true;
  CardNumberLabel.Caption := 'VISA number:';

  EnableControls;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TDepositForm.VISARadioButtonClick(Sender: TObject);
begin
  CVVLabel.Visible := true;
  CVVEdit.Visible := true;
  CardNumberLabel.Caption := 'VISA number:';
  VISARadioButton.Checked := true;
end;

procedure TDepositForm.MasterCardRadioButtonClick(Sender: TObject);
begin
  CVVLabel.Visible := true;
  CVVEdit.Visible := true;
  CardNumberLabel.Caption := 'Card number:';
  MasterCardRadioButton.Checked := true;
end;

procedure TDepositForm.FirePayRadioButtonClick(Sender: TObject);
begin
  CVVLabel.Visible := false;
  CVVEdit.Visible := false;
  CardNumberLabel.Caption := 'FirePay number:';
  FirePayRadioButton.Checked := true;
end;

procedure TDepositForm.NETellerRadioButtonClick(Sender: TObject);
begin
  //
end;


procedure TDepositForm.NumberEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not(((Key >= '0') and (Key <= '9')) or (Key < ' ')) then
    Key := #0;
end;


procedure TDepositForm.DepositButtonClick(Sender: TObject);
var
  PaymentSystem: TPaymentSystem;
  curAmount: Integer;
begin
  curAmount := StrToIntDef(AmountEdit.Text, 0);
  if (curAmount < MinDepositAmount) or (curAmount > MaxDepositAmount) then
  begin
    ThemeEngineModule.ShowWarning(cstrCashierDepositAmountIncorrect);
    ActiveControl := AmountEdit;
    Exit;
  end;

  PaymentSystem := psVISA;

  if MasterCardRadioButton.Checked then
    PaymentSystem := psMasterCard;
  if FirePayRadioButton.Checked then
    PaymentSystem := psFirePay;
  if NETellerRadioButton.Checked then
    PaymentSystem := psNETeller;

  if PaymentSystem <> psNETeller then
  begin
    if CardNumberEdit.Text = '' then
    begin
      ThemeEngineModule.ShowWarning(cstrCashierCardNumberEmpty);
      exit;
    end;

    if PaymentSystem <> psFirePay then
      if CVVEdit.Text = '' then
      begin
        ThemeEngineModule.ShowWarning(cstrCashierCVVEmpty);
        exit;
      end;

    if ParserModule.Send_Deposit(RealMoneyCurrencyID, curAmount, PaymentSystem,
      CardNumberEdit.Text, CVVEdit.Text, MonthComboBox.Text, YearComboBox.Text) then
      DisableControls;
  end
  else
  begin
  end;
end;

procedure TDepositForm.OnDepositFailed;
begin
  ThemeEngineModule.ShowMessage(cstrCashierDepositFailed);
  EnableControls;
end;

procedure TDepositForm.OnDepositSuccess;
begin
  ThemeEngineModule.ShowMessage(cstrCashierDepositSuccessfull);
  Close;
end;




end.
