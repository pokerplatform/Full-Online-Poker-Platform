unit uChangeMailingAddressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, StdCtrls;

type
  TChangeMailingAddressForm = class(TForm)
    SaveButton: TTeButton;
    CancelButton: TTeButton;
    TeLabel10: TTeLabel;
    TeLabel2: TTeLabel;
    TeLabel3: TTeLabel;
    TeLabel4: TTeLabel;
    TeLabel5: TTeLabel;
    TeLabel1: TTeLabel;
    TeLabel6: TTeLabel;
    TeLabel7: TTeLabel;
    TeLabel8: TTeLabel;
    TeLabel9: TTeLabel;
    FirstNameEdit: TTeEdit;
    Address1Edit: TTeEdit;
    Address2Edit: TTeEdit;
    CityEdit: TTeEdit;
    ProvinceEdit: TTeEdit;
    ZIPEdit: TTeEdit;
    PhoneEdit: TTeEdit;
    CountryComboBox1: TTeComboBox;
    TeLabel11: TTeLabel;
    LastNameEdit: TTeEdit;
    TeLabel12: TTeLabel;
    StateComboBox1: TTeComboBox;
    PlayerIDLabel: TTeLabel;
    CountryComboBox: TComboBox;
    StateComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure PlayerIDEditKeyPress(Sender: TObject; var Key: Char);
    procedure PhoneEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure CountryComboBox1Change(Sender: TObject);
    procedure StateComboBox1Change(Sender: TObject);
  private
    procedure OnChangeMailingAddress;
    procedure OnChangedMailingAddress;
    procedure OnChangeMailingAddressFailed;
    procedure OnGetMailingAddress;
    procedure DisableControls;
    procedure EnableControls;
    procedure CheckProvince;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ChangeMailingAddressForm: TChangeMailingAddressForm;

implementation

uses
  uLogger,
  uConstants,
  uThemeEngineModule,
  uCashierModule,
  uUserModule,
  uDataList;

{$R *.dfm}

procedure TChangeMailingAddressForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Change mailing address';
  ThemeEngineModule.FormsChangeConstraints(Self, 285, 345);
  CashierModule.OnChangeMailingAddress := OnChangeMailingAddress;
  CashierModule.OnChangedMailingAddress := OnChangedMailingAddress;
  CashierModule.OnChangeMailingAddressFailed := OnChangeMailingAddressFailed;
  CashierModule.OnGetMailingAddress := OnGetMailingAddress;
end;

procedure TChangeMailingAddressForm.FormDestroy(Sender: TObject);
begin
  CashierModule.OnChangeMailingAddress := nil;
  CashierModule.OnChangedMailingAddress := nil;
  CashierModule.OnChangeMailingAddressFailed := nil;
  CashierModule.OnGetMailingAddress := nil;
end;

procedure TChangeMailingAddressForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TChangeMailingAddressForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TChangeMailingAddressForm.DisableControls;
var
  Loop: Integer;
begin
  Cursor := crHourGlass;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := false;
  CancelButton.Enabled := true;
end;

procedure TChangeMailingAddressForm.EnableControls;
var
  Loop: Integer;
begin
  Cursor := crDefault;
  for Loop := 0 to ControlCount - 1 do
    Controls[Loop].Enabled := true;
end;

procedure TChangeMailingAddressForm.OnChangeMailingAddress;
var
  Loop: Integer;
  nInd: Integer;
  curData: TDataList;
  USAfound: Boolean;
begin
  EnableControls;
  PlayerIDLabel.Caption := UserModule.UserName;

  FirstNameEdit.Text := CashierModule.FirstName;
  if CashierModule.FirstName = '' then
    FirstNameEdit.Text := UserModule.UserFirstName;

  LastNameEdit.Text := CashierModule.LastName;
  if CashierModule.LastName = '' then
    LastNameEdit.Text := UserModule.UserLastName;

  Address1Edit.Text := CashierModule.Address1;
  Address2Edit.Text := CashierModule.Address2;
  CityEdit.Text := CashierModule.City;
  ZIPEdit.Text := CashierModule.ZIP;
  PhoneEdit.Text := CashierModule.Phone;
  ProvinceEdit.Text := CashierModule.Province;

  StateComboBox.Items.Clear;
  nInd := -1;
  for Loop := 0 to CashierModule.States.Count - 1 do
  begin
    curData := CashierModule.States.Items(Loop);
    StateComboBox.Items.AddObject(curData.Name, pointer(curData.ID));
    if curData.ID = CashierModule.StateID then
      nInd := Loop;
  end;
  if nInd >= 0 then
    StateComboBox.ItemIndex := nInd
  else
    if StateComboBox.Items.Count > 0 then
      StateComboBox.ItemIndex := 0
    else
      StateComboBox.ItemIndex := -1;

  CountryComboBox.Items.Clear;
  nInd := -1;
  for Loop := 0 to CashierModule.Countries.Count - 1 do
  begin
    curData := CashierModule.Countries.Items(Loop);
    CountryComboBox.Items.AddObject(curData.Name, pointer(curData.ID));
    if curData.ID = CashierModule.CountryID then
      nInd := Loop;
  end;
  if nInd >= 0 then
    CountryComboBox.ItemIndex := nInd
  else
    if CountryComboBox.Items.Count > 0 then
    begin
      USAfound := false;
      for Loop := 0 to CashierModule.Countries.Count - 1 do
        if CashierModule.Countries.Items(Loop).ValuesAsBoolean['usa'] then
        begin
          USAfound := true;
          CountryComboBox.ItemIndex := Loop;
          break;
        end;
      if not USAfound then
        CountryComboBox.ItemIndex := 0;
    end
    else
      CountryComboBox.ItemIndex := -1;

  CheckProvince;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TChangeMailingAddressForm.OnChangedMailingAddress;
begin
  ThemeEngineModule.ShowMessage(cstrCashierChangedMailingAddress);
  Close;
end;

procedure TChangeMailingAddressForm.OnChangeMailingAddressFailed;
begin
  ThemeEngineModule.ShowMessage(cstrCashierChangeMailingAddressFailed);
  Close;
end;

procedure TChangeMailingAddressForm.OnGetMailingAddress;
begin
  if Visible then
    OnChangeMailingAddress;
end;

procedure TChangeMailingAddressForm.SaveButtonClick(Sender: TObject);
var
  CountryID: Integer;
  StateID: Integer;
begin
  if (FirstNameEdit.Text = '') or (LastNameEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrCashierRealNameEmpty);
    exit;
  end;

  if (Address1Edit.Text + Address1Edit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrCashierAddressEmpty);
    exit;
  end;

  if (CityEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrCashierCityEmpty);
    exit;
  end;

  if (ZIPEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrCashierZIPEmpty);
    exit;
  end;

  if (PhoneEdit.Text = '') then
  begin
    ThemeEngineModule.ShowMessage(cstrCashierPhoneEmpty);
    exit;
  end;

  if CountryComboBox.ItemIndex >= 0 then
    CountryID := integer(CountryComboBox.Items.Objects[CountryComboBox.ItemIndex])
  else
  begin
    ThemeEngineModule.ShowMessage(cstrCashierCountryEmpty);
    exit;
  end;

  StateID := 0;
  if StateComboBox.ItemIndex >= 0 then
    StateID := integer(StateComboBox.Items.Objects[StateComboBox.ItemIndex])
  else
  if ProvinceEdit.Text <> '' then
    begin
      ThemeEngineModule.ShowMessage(cstrCashierStateEmpty);
      exit;
    end;

  DisableControls;
  CashierModule.Do_ChangeMailingAddress(FirstNameEdit.Text, LastNameEdit.Text,
    Address1Edit.Text, Address2Edit.Text,
    CityEdit.Text, ProvinceEdit.Text, ZIPEdit.Text, PhoneEdit.Text, StateID, CountryID);
end;

procedure TChangeMailingAddressForm.PlayerIDEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if length((Sender as TTeEdit).Text) > (Sender as TTeEdit).Tag then
    Key := #0;
  if key = #27 then
    Close;  
end;

procedure TChangeMailingAddressForm.PhoneEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 13 then
    SaveButtonClick(SaveButton);
end;

procedure TChangeMailingAddressForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TChangeMailingAddressForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TChangeMailingAddressForm.CountryComboBox1Change(Sender: TObject);
var
  StateID: Integer;
  CountryID: Integer;
  curData: TDataList;
  Loop: Integer;
begin
  StateID := 0;
  if StateComboBox.ItemIndex >= 0 then
    StateID := integer(StateComboBox.Items.Objects[StateComboBox.ItemIndex]);

  CountryID := 0;
  if CountryComboBox.ItemIndex >= 0 then
    CountryID := integer(CountryComboBox.Items.Objects[CountryComboBox.ItemIndex]);

  if CashierModule.Countries.Find(CountryID, curData) then
  begin
    if (StateID = OutsideUSProvince) and curData.ValuesAsBoolean['usa'] then
    begin
      if StateComboBox.ItemIndex < StateComboBox.Items.Count - 1 then
        StateComboBox.ItemIndex := StateComboBox.ItemIndex + 1
      else
        StateComboBox.ItemIndex := 0;
    end;

    if (StateID <> OutsideUSProvince) and (not curData.ValuesAsBoolean['usa']) then
      for Loop := 0 to StateComboBox.Items.Count - 1 do
        if integer(StateComboBox.Items.Objects[StateComboBox.ItemIndex]) = OutsideUSProvince then
        begin
          StateComboBox.ItemIndex := Loop;
          break;
        end;
  end;

  CheckProvince;
end;

procedure TChangeMailingAddressForm.StateComboBox1Change(Sender: TObject);
var
  StateID: Integer;
  CountryID: Integer;
  curData: TDataList;
  Loop: Integer;
begin
  StateID := 0;
  if StateComboBox.ItemIndex >= 0 then
    StateID := integer(StateComboBox.Items.Objects[StateComboBox.ItemIndex]);

  CountryID := 0;
  if CountryComboBox.ItemIndex >= 0 then
    CountryID := integer(CountryComboBox.Items.Objects[CountryComboBox.ItemIndex]);

  if CashierModule.Countries.Find(CountryID, curData) then
  begin
    if (StateID = OutsideUSProvince) and curData.ValuesAsBoolean['usa'] then
    begin
      if CountryComboBox.ItemIndex < CountryComboBox.Items.Count - 1 then
        CountryComboBox.ItemIndex := CountryComboBox.ItemIndex + 1
      else
        CountryComboBox.ItemIndex := 0;
    end;

    if (StateID <> OutsideUSProvince) and (not curData.ValuesAsBoolean['usa']) then
      for Loop := 0 to CashierModule.Countries.Count - 1 do
        if CashierModule.Countries.Items(Loop).ValuesAsBoolean['usa'] then
        begin
          CountryComboBox.ItemIndex := Loop;
          break;
        end;
  end;

  CheckProvince;
end;

procedure TChangeMailingAddressForm.CheckProvince;
var
  StateID: Integer;
begin
  StateID := 0;
  if StateComboBox.ItemIndex >= 0 then
    StateID := integer(StateComboBox.Items.Objects[StateComboBox.ItemIndex]);

  ProvinceEdit.Enabled := StateID = OutsideUSProvince;
  if not ProvinceEdit.Enabled then
    ProvinceEdit.Text := '';
end;

end.
