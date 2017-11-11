unit uCashierModule;

interface

uses
  SysUtils, Classes,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uDataList,
  uSessionModule;

const
  MinDepositAmount = 20;
  MaxDepositAmount = 600;
  MinWithdrawalAmount = 0.1;

type
  TCashierModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FBalance: TDataList;
    FCountries: TDataList;
    FStates: TDataList;
    FHistory: TDataList;
    FBonuses: TDataList;

    FOnCashierStop: TSessionEvent;
    FOnCashierStart: TSessionEvent;
    FOnWithdrawal: TSessionEvent;
    FOnDeposit: TSessionEvent;
    FOnTransactionHistory: TSessionEvent;
    FOnTransactionHistoryData: TSessionEvent;
    FOnChangeMailingAddressFailed: TSessionEvent;
    FOnChangeMailingAddress: TSessionEvent;
    FOnChangedMailingAddress: TSessionEvent;
    FOnGetMailingAddress: TSessionEvent;
    FOnCashierUpdate: TSessionEvent;

    FStateID: Integer;
    FCountryID: Integer;
    FAddress1: String;
    FAddress2: String;
    FFirstName: String;
    FCity: String;
    FZIP: String;
    FLastName: String;
    FPhone: String;
    FProvince: String;
    FOnDepositSuccess: TSessionEvent;
    FOnDepositFailed: TSessionEvent;
    FOnWithdrawalFailed: TSessionEvent;
    FOnWithdrawalSuccess: TSessionEvent;
    FCurrentTopLast: Integer;
    FCurrentDateFrom: TDateTime;
    FCurrentDateTo: TDateTime;

    procedure SetOnCashierStart(const Value: TSessionEvent);
    procedure SetOnCashierStop(const Value: TSessionEvent);
    procedure SetOnDeposit(const Value: TSessionEvent);
    procedure SetOnWithdrawal(const Value: TSessionEvent);
    procedure SetOnTransactionHistory(const Value: TSessionEvent);
    procedure SetOnTransactionHistoryData(const Value: TSessionEvent);
    procedure SetOnChangedMailingAddress(const Value: TSessionEvent);
    procedure SetOnChangeMailingAddress(const Value: TSessionEvent);
    procedure SetOnChangeMailingAddressFailed(const Value: TSessionEvent);
    procedure SetOnGetMailingAddress(const Value: TSessionEvent);
    procedure SetOnCashierUpdate(const Value: TSessionEvent);

    procedure Run_Deposit(XMLRoot: IXMLNode);
    procedure Run_Withdrawal(XMLRoot: IXMLNode);
    procedure Run_ChangeMailingAddress(XMLRoot: IXMLNode);
    procedure Run_GetMailingAddress(XMLRoot: IXMLNode);
    procedure Run_GetBalanceInfo(XMLRoot: IXMLNode);
    procedure Run_GetHistory(XMLRoot: IXMLNode);
    procedure Run_GetCountries(XMLRoot: IXMLNode);
    procedure Run_GetStates(XMLRoot: IXMLNode);

    procedure OnGetUserProfile;
    procedure SetOnDepositFailed(const Value: TSessionEvent);
    procedure SetOnDepositSuccess(const Value: TSessionEvent);
    procedure SetOnWithdrawalFailed(const Value: TSessionEvent);
    procedure SetOnWithdrawalSuccess(const Value: TSessionEvent);
  public
    property  Balance: TDataList read FBalance;
    property  Countries: TDataList read FCountries;
    property  States: TDataList read FStates;
    property  History: TDataList read FHistory;
    property  Bonuses: TDataList read FBonuses;

    property  FirstName: String read FFirstName;
    property  LastName: String read FLastName;
    property  Address1: String read FAddress1;
    property  Address2: String read FAddress2;
    property  City: String read FCity;
    property  CountryID: Integer read FCountryID;
    property  StateID: Integer read FStateID;
    property  Province: String read FProvince;
    property  ZIP: String read FZIP;
    property  Phone: String read FPhone;

    property  CurrentTopLast: Integer read FCurrentTopLast;
    property  CurrentDateFrom: TDateTime read FCurrentDateFrom;
    property  CurrentDateTo: TDateTime read FCurrentDateTo;

    property  OnCashierStart: TSessionEvent read FOnCashierStart write SetOnCashierStart;
    property  OnCashierStop: TSessionEvent read FOnCashierStop write SetOnCashierStop;
    property  OnCashierUpdate: TSessionEvent read FOnCashierUpdate write SetOnCashierUpdate;

    property  OnTransactionHistory: TSessionEvent read FOnTransactionHistory write SetOnTransactionHistory;
    property  OnTransactionHistoryData: TSessionEvent read FOnTransactionHistoryData write SetOnTransactionHistoryData;

    property  OnDeposit: TSessionEvent read FOnDeposit write SetOnDeposit;
    property  OnDepositSuccess: TSessionEvent read FOnDepositSuccess write SetOnDepositSuccess;
    property  OnDepositFailed: TSessionEvent read FOnDepositFailed write SetOnDepositFailed;

    property  OnWithdrawal: TSessionEvent read FOnWithdrawal write SetOnWithdrawal;
    property  OnWithdrawalSuccess: TSessionEvent read FOnWithdrawalSuccess write SetOnWithdrawalSuccess;
    property  OnWithdrawalFailed: TSessionEvent read FOnWithdrawalFailed write SetOnWithdrawalFailed;

    property  OnGetMailingAddress: TSessionEvent read FOnGetMailingAddress write SetOnGetMailingAddress;
    property  OnChangeMailingAddress: TSessionEvent read FOnChangeMailingAddress write SetOnChangeMailingAddress;
    property  OnChangedMailingAddress: TSessionEvent read FOnChangedMailingAddress write SetOnChangedMailingAddress;
    property  OnChangeMailingAddressFailed: TSessionEvent read FOnChangeMailingAddressFailed write SetOnChangeMailingAddressFailed;

    procedure StartWork;
    procedure StopWork;
    procedure ChangeMailingAddress;

    procedure Do_TransactionHistory;
    procedure Do_UpdateTransactionHistory(TopLastRecords: Integer;
      DateFrom, DateTo: TDateTime);

    procedure Do_Deposit;
    procedure Do_Withdrawal;
    procedure Do_MakeWithdraw(Amount: Currency);
    procedure Do_ChangeMailingAddress(FirstName, LastName, Address1, Address2,
      City, Province, ZIP, Phone: String; StateID, CountryID: Integer);

    procedure RunCommand(XMLRoot: IXMLNode);
  end;

var
  CashierModule: TCashierModule;

implementation

uses
  uLogger,
  uConstants,
  uConversions,
  uParserModule,
  uCashierForm,
  uThemeEngineModule,
  uUserModule,
  uProcessModule;

{$R *.dfm}

{ TCashierModule }

procedure TCashierModule.DataModuleCreate(Sender: TObject);
begin
  FBalance := TDataList.Create(0, nil);
  FCountries := TDataList.Create(0, nil);
  FStates := TDataList.Create(0, nil);
  FHistory := TDataList.Create(0, nil);
  FBonuses := TDataList.Create(0, nil);
  UserModule.OnGetProfileForCashier := OnGetUserProfile;
end;

procedure TCashierModule.DataModuleDestroy(Sender: TObject);
begin
  FBalance.Free;
  FCountries.Free;
  FStates.Free;
  FHistory.Free;
  FBonuses.Free;
end;


// Set properties

procedure TCashierModule.SetOnDepositFailed(const Value: TSessionEvent);
begin
  FOnDepositFailed := Value;
end;

procedure TCashierModule.SetOnDepositSuccess(const Value: TSessionEvent);
begin
  FOnDepositSuccess := Value;
end;

procedure TCashierModule.SetOnWithdrawalFailed(const Value: TSessionEvent);
begin
  FOnWithdrawalFailed := Value;
end;

procedure TCashierModule.SetOnWithdrawalSuccess(
  const Value: TSessionEvent);
begin
  FOnWithdrawalSuccess := Value;
end;

procedure TCashierModule.SetOnGetMailingAddress(
  const Value: TSessionEvent);
begin
  FOnGetMailingAddress := Value;
end;

procedure TCashierModule.SetOnCashierStart(const Value: TSessionEvent);
begin
  FOnCashierStart := Value;
end;

procedure TCashierModule.SetOnCashierStop(const Value: TSessionEvent);
begin
  FOnCashierStop := Value;
end;

procedure TCashierModule.SetOnCashierUpdate(const Value: TSessionEvent);
begin
  FOnCashierUpdate := Value;
end;

procedure TCashierModule.SetOnDeposit(const Value: TSessionEvent);
begin
  FOnDeposit := Value;
end;

procedure TCashierModule.SetOnWithdrawal(const Value: TSessionEvent);
begin
  FOnWithdrawal := Value;
end;

procedure TCashierModule.SetOnTransactionHistory(
  const Value: TSessionEvent);
begin
  FOnTransactionHistory := Value;
end;

procedure TCashierModule.SetOnTransactionHistoryData(
  const Value: TSessionEvent);
begin
  FOnTransactionHistoryData := Value;
end;

procedure TCashierModule.SetOnChangedMailingAddress(
  const Value: TSessionEvent);
begin
  FOnChangedMailingAddress := Value;
end;

procedure TCashierModule.SetOnChangeMailingAddress(
  const Value: TSessionEvent);
begin
  FOnChangeMailingAddress := Value;
end;

procedure TCashierModule.SetOnChangeMailingAddressFailed(
  const Value: TSessionEvent);
begin
  FOnChangeMailingAddressFailed := Value;
end;

// Start

procedure TCashierModule.StartWork;
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;
    ParserModule.Send_GetBalanceInfo(UserModule.UserID);
    if Assigned(FOnCashierStart) then
      FOnCashierStart;
  end
  else
  begin
    UserModule.OnActionLogin := StartWork;
    UserModule.Login;
  end;
end;

procedure TCashierModule.StopWork;
begin
  if Assigned(FOnCashierStop) then
    FOnCashierStop;
end;

procedure TCashierModule.Do_Deposit;
begin
  if FFirstName = '' then
  begin
    ThemeEngineModule.ShowWarning(cstrCashierChangedMailingAddressNeeded);
    ChangeMailingAddress;
  end
  else
    if not UserModule.UserEMailValidated then
    begin
      ThemeEngineModule.ShowWarning(cstrEmailNotValidated);
      UserModule.ChangeValidateEmail;
    end
    else
      if Assigned(FOnDeposit) then
        FOnDeposit
end;

procedure TCashierModule.Do_Withdrawal;
begin
  if FFirstName = '' then
  begin
    ThemeEngineModule.ShowWarning(cstrCashierChangedMailingAddressNeeded);
    ChangeMailingAddress;
  end
  else
    if not UserModule.UserEMailValidated then
    begin
      ThemeEngineModule.ShowWarning(cstrEmailNotValidated);
      UserModule.ChangeValidateEmail;
    end
    else
      if Assigned(FOnWithdrawal) then
        FOnWithdrawal;
end;

procedure TCashierModule.Do_TransactionHistory;
begin
  FHistory.Clear;
  FCurrentTopLast := TransactionHistoryTopLastRecords;
  FCurrentDateFrom := now - TransactionHistoryDateBefore;
  FCurrentDateTo := now;
  ParserModule.Send_GetTransactionHistory(UserModule.UserID, RealMoneyCurrencyID,
    FCurrentTopLast, FCurrentDateFrom, FCurrentDateTo);
  if Assigned(FOnTransactionHistory) then
    FOnTransactionHistory;
end;

procedure TCashierModule.Do_UpdateTransactionHistory(TopLastRecords: Integer;
  DateFrom, DateTo: TDateTime);
begin
  FCurrentTopLast := TopLastRecords;
  if FCurrentTopLast = 0 then
  begin
    FCurrentDateFrom := DateFrom;
    FCurrentDateTo := DateTo;
  end;
  ParserModule.Send_GetTransactionHistory(UserModule.UserID, RealMoneyCurrencyID,
    FCurrentTopLast, FCurrentDateFrom, FCurrentDateTo);
end;

// Parser command

procedure TCashierModule.RunCommand(XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Add('CashierModule.RunCommand started', llExtended);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := XMLNode.NodeName;
        Logger.Add('CashierModule.RunCommand found: ' + strNode, llExtended);

        if strNode = 'aodeposit' then
          Run_Deposit(XMLNode)
        else
        if strNode = 'aowithdrawal' then
          Run_Withdrawal(XMLNode)
        else
        if strNode = 'aogetbalanceinfo' then
          Run_GetBalanceInfo(XMLNode)
        else
        if strNode = 'aogetmailingaddress' then
          Run_GetMailingAddress(XMLNode)
        else
        if strNode = 'apgetcountries' then
          Run_GetCountries(XMLNode)
        else
        if strNode = 'apgetstates' then
          Run_GetStates(XMLNode)
        else
        if strNode = 'aogethistory' then
          Run_GetHistory(XMLNode)
        else
        if strNode = 'aochangemailingaddress' then
          Run_ChangeMailingAddress(XMLNode);
      end;
  except
    Logger.Add('CashierModule.RunCommand failed', llBase);
  end;
end;


// Get countries and states

procedure TCashierModule.Run_GetCountries(XMLRoot: IXMLNode);
{
<object name="cashier">
  <apgetcountries result="0|...">
    <country id="1" name="USA"/>
    <country id="2" name="Ukraine"/>
    <country id="3" name="Russia"/>
  </apgetcurrencies>
</object>
}
var
  ItemsCount: Integer;
  ErrorCode: Integer;

  Loop: Integer;
  XMLNode: IXMLNode;
  curData: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    ItemsCount := XMLRoot.ChildNodes.Count;
    FCountries.ClearItems(ItemsCount);
    for Loop := 0 to ItemsCount - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      curData := FCountries.AddItem(XMLNode.Attributes[XMLATTRNAME_ID], Loop);
      curData.Name := XMLNode.Attributes[XMLATTRNAME_NAME];
      curData.LoadFromXML(XMLNode);
    end;
  end;
  SessionModule.Do_Synchronized;
end;

procedure TCashierModule.Run_GetStates(XMLRoot: IXMLNode);
{
<object name="cashier">
  <apgetstates result="0|...">
    <state id="1" name="Outside US" longname="Outside US" isfundsallowed="1"
  </apgetcurrencies>
</object>
}
var
  ItemsCount: Integer;
  ErrorCode: Integer;

  Loop: Integer;
  XMLNode: IXMLNode;
  curData: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    ItemsCount := XMLRoot.ChildNodes.Count;
    FStates.ClearItems(ItemsCount);
    for Loop := 0 to ItemsCount - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      curData := FStates.AddItem(XMLNode.Attributes[XMLATTRNAME_ID], Loop);
      curData.Name := XMLNode.Attributes['longname'];
      curData.LoadFromXML(XMLNode);
    end;
  end;
  SessionModule.Do_Synchronized;
end;


// Get balance

procedure TCashierModule.Run_GetBalanceInfo(XMLRoot: IXMLNode);
{
<object name="cashier">
	<aogetbalanceinfo result="0|..."
      <account currencytypeid="10"
	    balance="25.25"
      reserved="12.25"/>

</object>
}
var
  ErrorCode: Integer;

  Loop: Integer;
  XMLNode: IXMLNode;
  curData: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    FBalance.ClearItems(XMLRoot.ChildNodes.Count);

    for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      curData := FBalance.AddItem(XMLNode.Attributes['currencytypeid'], Loop);
      curData.ValuesAsCurrency['balance'] := Conversions.Str2Cur(XMLNode.Attributes['balance']);
      curData.ValuesAsCurrency['reserved'] := Conversions.Str2Cur(XMLNode.Attributes['reserved']);
    end;

    if Assigned(FOnCashierUpdate) then
      FOnCashierUpdate;
    ProcessModule.UpdateUserBalance;
  end;
end;

procedure TCashierModule.OnGetUserProfile;
begin
  if Assigned(FOnCashierUpdate) then
    FOnCashierUpdate;
end;


// Change Mailing address

procedure TCashierModule.ChangeMailingAddress;
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;
    if Assigned(FOnChangeMailingAddress) then
      FOnChangeMailingAddress;
  end
  else
  begin
    UserModule.OnActionLogin := ChangeMailingAddress;
    UserModule.Login;
  end;
end;

procedure TCashierModule.Do_ChangeMailingAddress(FirstName, LastName,
  Address1, Address2, City, Province, ZIP, Phone: String;
  StateID, CountryID: Integer);
begin
  ParserModule.Send_ChangeMailingAddress(UserModule.UserID, FirstName, LastName,
  Address1, Address2, City, Province, ZIP, Phone, StateID, CountryID);
end;

procedure TCashierModule.Run_ChangeMailingAddress(XMLRoot: IXMLNode);
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, False) then
  begin
    ParserModule.Send_GetMailingAddress(UserModule.UserID);
    if Assigned(FOnChangedMailingAddress) then
      FOnChangedMailingAddress;
  end
  else
  begin
    if Assigned(FOnChangeMailingAddressFailed) then
      FOnChangeMailingAddressFailed;
  end;
end;

procedure TCashierModule.Run_GetMailingAddress(XMLRoot: IXMLNode);
{
<object name="cashier">
	<aogetmailingaddress result="0|..."
         firstname="John"
         lastname="Smith"
	 address1="Independence street, 6549"
	 address2="3rd floor nalevo"
	 city="Las-Vegas"
	 countryid="1"
	 stateid="1"
         province="Nevada"
	 zip="95000"
	 phone="+100180080808080"
	/>

</object>
}
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    FFirstName := XMLRoot.Attributes['firstname'];
    FLastName := XMLRoot.Attributes['lastname'];
    FAddress1 := XMLRoot.Attributes['address1'];
    FAddress2 := XMLRoot.Attributes['address2'];
    FCity := XMLRoot.Attributes['city'];
    FCountryID := strtointdef(XMLRoot.Attributes['countryid'], 0);
    FStateID := strtointdef(XMLRoot.Attributes['stateid'], 0);
    FProvince := XMLRoot.Attributes['province'];
    FZIP := XMLRoot.Attributes['zip'];
    FPhone := XMLRoot.Attributes['phone'];

    if Assigned(FOnGetMailingAddress) then
      FOnGetMailingAddress;
    if Assigned(FOnCashierUpdate) then
      FOnCashierUpdate;
  end
end;


// Deposit

procedure TCashierModule.Run_Deposit(XMLRoot: IXMLNode);
{
<object name="cashier">
	<aodeposit result="0|..." newamount="100.55"/>
</object>
}
var
  ErrorCode: Integer;
  curData: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, False) then
  begin
    if FBalance.Find(RealMoneyCurrencyID, curData) then
      curData.ValuesAsCurrency['balance'] := Conversions.Str2Cur(XMLRoot.Attributes['newamount']);

    if Assigned(FOnDepositSuccess) then
      FOnDepositSuccess;
    if Assigned(FOnCashierUpdate) then
      FOnCashierUpdate;
  end
  else
    if Assigned(FOnDepositFailed) then
      FOnDepositFailed;
end;


// Withdrawal

procedure TCashierModule.Run_Withdrawal(XMLRoot: IXMLNode);
var
  ErrorCode: Integer;
  curData: TDataList;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, False) then
  begin
    if FBalance.Find(RealMoneyCurrencyID, curData) then
      curData.ValuesAsCurrency['balance'] := Conversions.Str2Cur(XMLRoot.Attributes['newamount']);

    if Assigned(FOnWithdrawalSuccess) then
      FOnWithdrawalSuccess;
    if Assigned(FOnCashierUpdate) then
      FOnCashierUpdate;
  end
  else
    if Assigned(FOnWithdrawalFailed) then
      FOnWithdrawalFailed;
end;

procedure TCashierModule.Do_MakeWithdraw(Amount: Currency);
begin
  ParserModule.Send_Withdrawal(UserModule.UserID, RealMoneyCurrencyID, Amount);
end;

// Transaction history

procedure TCashierModule.Run_GetHistory(XMLRoot: IXMLNode);
{
<object name="cashier">
    <aogethistory result="0|...">
      <money>
      	<transaction amount="123.12" balance="1000" type="deposit" comment="reserve money" date="10-30-2003"/>
      	<transaction amount="123.12" balance="1000" type="deposit" comment="reserve money" date="10-30-2003"/>
      </money>
      <bonuses>
      	<transaction amount="123.12" balance="1000" type="deposit" comment="reserve money" date="10-30-2003"/>
      	<transaction amount="123.12" balance="1000" type="deposit" comment="reserve money" date="10-30-2003"/>
      </bonuses>
    </aogethistory>
</object>
}
var
  ErrorCode: Integer;
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
  Loop2: Integer;
begin
  ErrorCode := -1;
  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      strNode := lowercase(XMLNode.NodeName);

      if strNode = 'money' then
      begin
        FHistory.ClearItems(XMLNode.ChildNodes.Count);
        for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
          FHistory.AddItem(Loop2, Loop2).LoadFromXML(XMLNode.ChildNodes.Nodes[Loop2]);
      end;

      if strNode = 'bonuses' then
      begin
        FBonuses.ClearItems(XMLNode.ChildNodes.Count);
        for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
          FBonuses.AddItem(Loop2, Loop2).LoadFromXML(XMLNode.ChildNodes.Nodes[Loop2]);
      end;
    end;

    if Assigned(FOnTransactionHistoryData) then
      FOnTransactionHistoryData;
  end;
end;


end.
