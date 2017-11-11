unit uCashierForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls;

type
  TCashierForm = class(TForm)
    BackgroundPanel: TTeHeaderPanel;
    TeGroupBox1: TTeGroupBox;
    TeGroupBox2: TTeGroupBox;
    TeLabel7: TTeLabel;
    TeLabel9: TTeLabel;
    MoneyAvailableLabel: TTeLabel;
    TeLabel19: TTeLabel;
    MoneyInPlayLabel: TTeLabel;
    MoneyTotalLabel: TTeLabel;
    TeGroupBox3: TTeGroupBox;
    DepositButton: TTeButton;
    WithdrawalButton: TTeButton;
    HistoryButton: TTeButton;
    TeLabel3: TTeLabel;
    NameLabel: TTeLabel;
    TeLabel5: TTeLabel;
    AddressLabel: TTeLabel;
    TeLabel8: TTeLabel;
    CityLabel: TTeLabel;
    TeLabel12: TTeLabel;
    StateLabel: TTeLabel;
    TeLabel16: TTeLabel;
    ZIPLabel: TTeLabel;
    TeLabel21: TTeLabel;
    CountryLabel: TTeLabel;
    TeLabel4: TTeLabel;
    PhoneLabel: TTeLabel;
    TeLabel6: TTeLabel;
    TeLabel10: TTeLabel;
    TeLabel11: TTeLabel;
    PlayMoneyAvailableLabel: TTeLabel;
    TeLabel14: TTeLabel;
    PlayMoneyTotalLabel: TTeLabel;
    PlayMoneyInPlayLabel: TTeLabel;
    TeLabel18: TTeLabel;
    TeGroupBox4: TTeGroupBox;
    TeLabel1: TTeLabel;
    PlayerIDLabel: TTeLabel;
    TeLabel2: TTeLabel;
    EMailLabel: TTeLabel;
    TeLabel13: TTeLabel;
    LoggedTimeLabel: TTeLabel;
    TeLabel17: TTeLabel;
    TotalLoggedLabel: TTeLabel;
    TeGroupBox5: TTeGroupBox;
    TeLabel15: TTeLabel;
    TeLabel20: TTeLabel;
    TeLabel22: TTeLabel;
    BonusAvailableLabel: TTeLabel;
    TeLabel24: TTeLabel;
    BonusTotalLabel: TTeLabel;
    BonusInPlayLabel: TTeLabel;
    LeaveCashierButton: TTeButton;
    TeButton1: TTeButton;
    TeGroupBox6: TTeGroupBox;
    TeLabel28: TTeLabel;
    LoyalityPointsLabel: TTeLabel;
    ReloadChipsButton: TTeButton;
    procedure FormCreate(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure HistoryButtonClick(Sender: TObject);
    procedure DepositButtonClick(Sender: TObject);
    procedure WithdrawalButtonClick(Sender: TObject);
    procedure LeaveCashierButtonClick(Sender: TObject);
    procedure TeButton1Click(Sender: TObject);
    procedure ReloadChipsButtonClick(Sender: TObject);
  private
    procedure OnCashierStart;
    procedure OnCashierStop;
    procedure OnCashierUpdate;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  CashierForm: TCashierForm;

implementation

uses
  uLogger,
  uDataList,
  uCashierModule,
  uConversions,
  uConstants,
  uThemeEngineModule, uUserModule, uLoyaltyStore, uLobbyModule;

{$R *.dfm}

procedure TCashierForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self,517, 418);
  CashierModule.OnCashierStart := OnCashierStart;
  CashierModule.OnCashierStop := OnCashierStop;
  CashierModule.OnCashierUpdate := OnCashierUpdate;
end;

procedure TCashierForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TCashierForm.OnCashierStart;
begin
  OnCashierUpdate;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TCashierForm.OnCashierUpdate;
var
  curData: TDataList;
  seconds, minutes, hours, days: Integer;
  totaltime: String;
  mBalance: Currency;
  mReserved: Currency;
begin
  // User Info
  PlayerIDLabel.Caption := UserModule.UserName;
  EMailLabel.Caption := UserModule.UserEMail;
  LoggedTimeLabel.Caption := UserModule.UserLastLoggedTime;

  seconds := UserModule.UserTotalLoggedSeconds;
  minutes := 0;
  hours := 0;
  days := 0;

  if seconds > 60 then
  begin
    minutes := seconds div 60;
    seconds := seconds mod 60;
  end;

  if minutes > 60 then
  begin
    hours := minutes div 60;
    minutes := minutes mod 60;
  end;

  if hours > 24 then
  begin
    days := hours div 24;
    hours := hours mod 24;
  end;

  totaltime := inttostr(seconds) + ' sec.';
  if (minutes > 0) or (hours > 0)  or (days > 0) then
    totaltime := inttostr(minutes) + ' min. ' + totaltime;
  if (hours > 0)  or (days > 0) then
    totaltime := inttostr(hours) + ' h. ' + totaltime;
  if days > 0 then
    totaltime := inttostr(days) + ' d. ' + totaltime;

  TotalLoggedLabel.Caption := totaltime;

  // Mailing address
  NameLabel.Caption := CashierModule.FirstName + ' ' + CashierModule.LastName;
  AddressLabel.Caption := CashierModule.Address1 + #13#10 + CashierModule.Address2;
  CityLabel.Caption := CashierModule.City;
  ZIPLabel.Caption := CashierModule.ZIP;
  PhoneLabel.Caption := CashierModule.Phone;
  if CashierModule.States.Find(CashierModule.StateID, curData) then
    StateLabel.Caption := curData.Name
  else
    StateLabel.Caption := CashierModule.Province;

  if CashierModule.Countries.Find(CashierModule.CountryID, curData) then
    CountryLabel.Caption := curData.Name
  else
    CountryLabel.Caption := '';

  // Real money
  if CashierModule.Balance.Find(RealMoneyCurrencyID, curData) then
  begin
    mBalance := curData.ValuesAsCurrency['balance'];
    mReserved := curData.ValuesAsCurrency['reserved'];
  end
  else
  begin
    mBalance := 0;
    mReserved := 0;
  end;
  MoneyAvailableLabel.Caption := Conversions.Cur2Str(mBalance, RealMoneyCurrencyID);
  MoneyInPlayLabel.Caption := Conversions.Cur2Str(mReserved, RealMoneyCurrencyID);
  MoneyTotalLabel.Caption := Conversions.Cur2Str(mBalance + mReserved, RealMoneyCurrencyID);

  // Bonus
  if CashierModule.Balance.Find(BonusCurrencyID, curData) then
  begin
    mBalance := curData.ValuesAsCurrency['balance'];
    mReserved := curData.ValuesAsCurrency['reserved'];
  end
  else
  begin
    mBalance := 0;
    mReserved := 0;
  end;
  BonusAvailableLabel.Caption := Conversions.Cur2Str(mBalance, BonusCurrencyID);
  BonusInPlayLabel.Caption := Conversions.Cur2Str(mReserved, BonusCurrencyID);
  BonusTotalLabel.Caption := Conversions.Cur2Str(mBalance + mReserved, BonusCurrencyID);

  // Play money
  if CashierModule.Balance.Find(PlayMoneyCurrencyID, curData) then
  begin
    mBalance := curData.ValuesAsCurrency['balance'];
    mReserved := curData.ValuesAsCurrency['reserved'];
  end
  else
  begin
    mBalance := 0;
    mReserved := 0;
  end;
  PlayMoneyAvailableLabel.Caption := Conversions.Cur2Str(mBalance, PlayMoneyCurrencyID);
  PlayMoneyInPlayLabel.Caption := Conversions.Cur2Str(mReserved, PlayMoneyCurrencyID);
  PlayMoneyTotalLabel.Caption := Conversions.Cur2Str(mBalance + mReserved, PlayMoneyCurrencyID);

  if CashierModule.Balance.Find(LoyalityPointsID, curData) then
  begin
    mBalance := curData.ValuesAsCurrency['balance'];
    mReserved := curData.ValuesAsCurrency['reserved'];
  end
  else
  begin
    mBalance := 0;
    mReserved := 0;
  end;

  LoyalityPointsLabel.Caption := IntToStr(Trunc(mBalance + mReserved));
end;

procedure TCashierForm.OnCashierStop;
begin
  Close;
end;

procedure TCashierForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TCashierForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TCashierForm.HistoryButtonClick(Sender: TObject);
begin
  CashierModule.Do_TransactionHistory;
end;

procedure TCashierForm.DepositButtonClick(Sender: TObject);
begin
  CashierModule.Do_Deposit;
end;

procedure TCashierForm.WithdrawalButtonClick(Sender: TObject);
begin
  CashierModule.Do_Withdrawal;
end;

procedure TCashierForm.LeaveCashierButtonClick(Sender: TObject);
begin
  close;
end;

procedure TCashierForm.TeButton1Click(Sender: TObject);
begin
  LoyaltyStoreForm.ShowModal;
end;

procedure TCashierForm.ReloadChipsButtonClick(Sender: TObject);
begin
  LobbyModule.Do_Action(laGetMoreChips);
end;

end.
