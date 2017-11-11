unit uAccount;

interface

uses
  SysUtils, StrUtils, Contnrs, xmldom, XMLIntf, msxmldom, XMLDoc, DB
//PO
  , uLogger
  , PFProCOMLib_TLB
  ;

const
{For test only}
  ACCOUNTID   = '1234567890';
  MERCHANTID  = '123qwerty56789';
  MERCHANTPWD = '12asd456zxc';

  VS_USER     : String = 'Enter Real User';
  VS_PWD      : String = 'Enter Real PWD';
  VS_VENDOR   : String = 'Enter Real Vendor';
  VS_PARTNER  : String = 'verisign';
  VS_HOST_ADD : String = 'payflow.verisign.com';

type
  TVSTransactionResult = record
    Result    : Integer;
    PNRef     : String;
    RespMsg   : String;
    AuthCode  : String;
    AVSAddr   : String;
    AVSZip    : String;
    IAVS      : String;
    CVV2MATCH : String;
  end;

type
// -----------------------
// TCreditCard: Replicate from DataBase
// -----------------------
  TCreditCard = class
  private
    FAmountDeposited: Currency;
    FCardTypeID: Integer;
    FUserID: Integer;
    FExpirationMonth: Integer;
    FExpirationYear: Integer;
    FID: Integer;
    FCardNumber: string;
    FCVV2: string;
    procedure SetAmountDeposited(const Value: Currency);
    procedure SetCardNumber(const Value: string);
    procedure SetCardTypeID(const Value: Integer);
    procedure SetExpirationMonth(const Value: Integer);
    procedure SetExpirationYear(const Value: Integer);
    procedure SetID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
    procedure SetCVV2(const Value: string);
  public
    property ID: Integer read FID write SetID;
    property UserID: Integer read FUserID write SetUserID;
    property AmountDeposited: Currency read FAmountDeposited write SetAmountDeposited;
    property CardNumber: string read FCardNumber write SetCardNumber;
    property ExpirationMonth: Integer read FExpirationMonth write SetExpirationMonth;
    property ExpirationYear: Integer read FExpirationYear write SetExpirationYear;
    property CardTypeID: Integer read FCardTypeID write SetCardTypeID;
    property CVV2: string read FCVV2 write SetCVV2;
  end;

  TCreditCardList = class(TObjectList)
  private
    function GetCards(nIndex: Integer): TCreditCard;
  public
    property Cards[nIndex: Integer]: TCreditCard read GetCards;
    //
    function Add(nAmountDeposited: Currency;
      nCardTypeID, nUserID, nExpirationMonth, nExpirationYear, nID: Integer;
      sCVV2, sCardNumber: string
    ): TCreditCard;
  end;

type
  TAccount = class
  private
    procedure Log(MethodName, LogData: String; LogType: TLogType);
    //
    function DepositMoneyCC(UserAccountID, CreditCardID, PNRef: integer;ResponseMsg, AuthCode: string; Amount: currency; Comments: string;var newAmount: currency; var Error: string; var IsFirst: Integer): integer;
    function GetMerchantData(UserID: integer): string;
    function GetMerchantTxn: integer;
    function GetTransactionHistory(SessionID, UserID, CurrencyTypeID,TopLast: integer; DateStart, DateEnd: string): integer;
    function GetTxDoc(Comments: string; var TxDocID: integer): integer;
    function CalculateRakeEvent: Integer;
    function UserGroupsAllocationEvent: Integer;
    function ChangeBalance(nSessionID, nUserID, nCurrTypeID, nType, nCheatsUsed: Integer; nAmount: Currency; sReason: string): Integer;
    //
    function HandFee(GameProcessID: integer; Amount: Currency; TxDocID,HandID: integer; const Comment: String): integer;
    function AffiliateFee(AffiliateID, ProcessID, HandID: Integer; Amount: Currency): Integer;
    function HandLost(UserID, GameProcessID: integer; Amount: Currency;TxDocID, HandId: integer; const Comment: String; IsRaked: Integer): integer;
    function HandWon(UserID, GameProcessID: integer; Amount: Currency; TxDocID, HandID: integer; const Comment: String; IsRaked: Integer): integer;
    function HandBet(UserID, GameProcessID: integer; Amount: Currency; TxDocID, HandID: integer; const Comment: String): integer;
    function SaveUserLastHand(UserID, GameProcessID, HandID: integer): integer;
    //
    function IsDepositAllowed(SessionID, CurrencyTypeID: integer;Amount: currency; var UserAccountID: integer; CardNumber, CVV: string;ExpMonth, ExpYear, CardTypeID: integer; var CreditCardID: integer;var Error: string): integer;
    // Functions for Fire Pay transactions
    function PrepareForFirePayParams(TransType: Char; Amount: currency; CardNumber, CardName,ExpMonth, ExpYear: string; UserID: integer;var PNRef: integer): string;
    // Functions for Credit Card transactions
    function ProcessCC(Amount: currency; CVV2, CardNumber, ExpMonth,ExpYear: string; CardTypeID, UserID: integer; var ResponseMsg,AuthCode: string; var PNRef: integer): integer;
    function DoVSTransaction(TransType: Char; CVV2, CardNum, ExpDateMonth, ExpDateYear: String;
      Amount: Real; Address, Zip: String): TVSTransactionResult;
    function GetVSTransactionResult(StrRes: string): TVSTransactionResult;
    function GetAdressAndZipForVSTransaction(UserID: Integer; var sAdress, sZip: string): Integer;
    function WithdrawalCC(Amount: Currency;
      CVV2, CardNumber, ExpMonth, ExpYear: string; CardTypeID, UserID: integer;
       var ResponseMsg, AuthCode: string; var PNRef: integer
    ): Integer;
    // withdrawal internal methods
    function GetAllUserCreditCards(UserID: Integer; aCreditCards: TCreditCardList): Integer;
    function IsWithdrawalAllowed(SessionID, UserID, CurrencyTypeID: Integer; Amount: Currency): Integer;
    function WithdrawalToCreditCard(UserID, CurrencyTypeID, CreditCardID: Integer;
      PNRef, ResponseMsg, AuthCode: string;
      Amount: Currency; var NewAmount: Currency
    ): Integer;
    function accWithdrawalExecute(UserID, CurrencyTypeID: Integer;
      Amount: Currency; Comments: String; var NewAmount: Currency): Integer;
    procedure GetMailingAddressForWithdrawal(UserID: Integer; var sUserName, sUserInfo: string);
    procedure AddMoneyFromPromoCard(CardID: string; UserID, SessionID: Integer);
    //
    procedure AddToLog(MethodName, LogData: String; LogType: TLogType);
    //
  public
    function ProcessAction(ActionsNode: IXMLNode): Integer;
    function Deposit(SessionID: Integer; UserID: Integer; CurrencyTypeID: Integer;
      Amount: Currency; const CardName: String; const CardNumber: String;
      const Cvv: String; const ExpMonth: String; const ExpYear: String;
      var NewAmount: Currency): Integer;
    function Withdrawal(SessionID: Integer; UserID: Integer; CurrencyTypeID: Integer;
      Amount: Currency; const Comments: String; var NewAmount: Currency): Integer;
    function ReservAmount(SessionID: Integer; UserID: Integer; GameProcessID: Integer;
      Amount: Currency; var NewAmount: Currency; var NewReserv: Currency): Integer;
    function ReturnAmount(SessionID: Integer; UserID: Integer; GameProcessID: Integer;
      Amount: Currency; var NewAmount: Currency; var NewReserv: Currency): Integer;
    function MoneyExchange(SessionID: Integer; AccountFromID: Integer;
      AccountToID: Integer; Amount: Currency; var NewAmountFrom: Currency;
      var NewAmountTo: Currency): Integer;
    function GetBalanceInfo(SessionID: Integer; UserID: Integer): Integer;
    function GetReservedBalanceInfo(SessionID: Integer; UserID: Integer): Integer;
    function GetReservedAmount(SessionID: Integer; UserID: Integer;
      GameProcessID: Integer; var Amount: Currency): Integer;
    function ChangeAccountStatus(SessionID: Integer; AccountID: Integer;
      StatusID: Integer): Integer;
    function CreateNewAccount(SessionID: Integer; UserID: Integer;
      CurrencyTypeID: Integer; var AccountID: Integer): Integer;
    function GetUserCurrencyBalance(SessionID: Integer; UserID: Integer;
      CurrencyID: Integer; var Amount: Currency): Integer;
    function GetMailingAddress(SessionID: Integer; UserID: Integer;
      var Data: String): Integer;
    function UpdateMailingAddress(SessionID: Integer; UserID: Integer;
      const FirstName: String; const LastName: String;
      const Address1: String; const Address2: String;
      const Province: String; const City: String;
      StateID: Integer; const Zip: String; const Phone: String;
      CountryID: Integer): Integer;
    function HandResult(GameProcessID: Integer; HandID: Integer; const Comment: String;
      const Data: String): Integer;
    function ReturnAllMoneyFromGameProcess(GameProcessID: Integer): Integer;
    function ReservForTournament(GameProcessID: Integer; var Data: String): Integer;
    function UnReserveForTournament(ProcessID: Integer; var Data: String): Integer;
    function TournamentPrize(GameProcessID: Integer; var Data: String): Integer;
  end;

implementation

uses
  Variants, Classes
//PO
  , uCommonDataModule
  , uFirePay
  , uObjectPool
  , uErrorConstants
  , uXMLConstants
  , uUser
  , uSQLAdapter
  , uEMail;

{ TAccount }

function TAccount.ProcessAction(ActionsNode: IXMLNode): Integer;
var
  Node,SubNode    : IXMLNode;
  Cnt             : Integer;
  ActionName      : string;
  NewAmount,
  Amount,
  NewReserv       : currency;
  NewAmountFrom,
  NewAmountTo     : currency;
  Response        : String;
  AccountID       : integer;
  UID,
  CurrencyTypeID  : integer;
  CardName,Cvv,
  CardNumber      : string;
  ExpMonth,ExpYear: string;
  SessionID       : Integer;
  nSparkleCheats  : Integer;
begin

  Response := '';
  Log('ProcessAction', 'Entry; Params: Data=' + ActionsNode.XML, ltCall);

  Result := 0;

  Node := ActionsNode.ChildNodes.Get(0);
  SessionID := StrToIntDef(Node.Attributes[PO_ATTRSESSIONID], 0);

  // cycle through file
  for Cnt := 0 to ActionsNode.ChildNodes.Count-1 do begin
    try
      Node       := ActionsNode.ChildNodes.Get(Cnt);
      ActionName := Lowercase(Node.NodeName);

      if ActionName = AO_CreateNew  then
        CreateNewAccount(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['currencytypeid']),
          AccountID
        )
      else if ActionName = AO_Deposit  then begin
        UID            := StrToInt(Node.Attributes['userid']);
        CurrencyTypeID := StrToInt(Node.Attributes['currencytypeid']);
        Amount         := StrToCurr(Node.Attributes['amount']);
        SubNode        := Node.ChildNodes[0];
        if LowerCase(SubNode.NodeName) = 'card' then begin
            CardName   := SubNode.Attributes['name'];
            CardNumber := SubNode.Attributes['number'];
            Cvv        := SubNode.Attributes['cvv'];
            ExpMonth   := SubNode.Attributes['expmonth'];
            ExpYear    := SubNode.Attributes['expyear'];
        end;

        Deposit(SessionID,UID,CurrencyTypeID,Amount,CardName,CardNumber,Cvv,
                ExpMonth,ExpYear,NewAmount);
      end else if ActionName = AO_Withdrawal then
        Withdrawal(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['currencytypeid']),
          StrToCurr(Node.Attributes['amount']),
          '',
          NewAmount
        )
      else if ActionName = AO_ReservAmount then
        ReservAmount(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['gameprocessid']),
          StrToCurr(Node.Attributes['amount']),
          NewAmount,
          NewReserv
        )
      else if ActionName = AO_ReturnAmount then
        ReturnAmount(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['gameprocessid']),
          StrToCurr(Node.Attributes['amount']),
          NewAmount,
          NewReserv
        )
      else if ActionName = AO_MoneyExchange then
        MoneyExchange(SessionID,
          StrToInt(Node.Attributes['accountfromid']),
          StrToInt(Node.Attributes['accounttoid']),
          StrToCurr(Node.Attributes['amount']),
          NewAmountFrom,
          NewAmountTo
        )
      else if ActionName = AO_GetBalanceInfo then
        GetBalanceInfo(SessionID,
          StrToInt(Node.Attributes['userid']) )
      else if ActionName = AO_GetReservedBalanceInfo then
        GetReservedBalanceInfo(SessionID,
          StrToInt(Node.Attributes['userid']) )
      else if ActionName = AO_GetReservedAmount then
        GetReservedAmount(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['gameprocessid']),
          Amount
        )
      else if ActionName = AO_ChangeStatus then
        ChangeAccountStatus(SessionID,
          StrToInt(Node.Attributes['accountid']),
          StrToInt(Node.Attributes['statusid'])
        )
      else if ActionName = AO_GetUserCurrencyBalance then
        GetUserCurrencyBalance(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['currencyid']),
          Amount
        )
      else if ActionName = AO_GetMailingAddress then
        GetMailingAddress(SessionID,
          StrToInt(Node.Attributes['userid']),
          Response
        )
      else if ActionName = AO_UpdateMailingAddress then
        UpdateMailingAddress(SessionID,
          StrToInt(Node.Attributes['userid']),
          Node.Attributes['firstname'],
          Node.Attributes['lastname'],
          Node.Attributes['address1'],
          Node.Attributes['address2'],
          Node.Attributes['province'],
          Node.Attributes['city'],
          StrToInt(Node.Attributes['stateid']),
          Node.Attributes['zip'],
          Node.Attributes['phone'],
          StrToInt(Node.Attributes['countryid'])
        )
      else if ActionName = AO_TransactionHistory then
        GetTransactionHistory(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['currencytypeid']),
          StrToInt(Node.Attributes['toplast']),
          Node.Attributes['datestart'],
          Node.Attributes['dateend']
        )
      else if ActionName = AO_CalculateRake then
        CalculateRakeEvent
      else if ActionName = AO_UserGroupsAllocation then
        UserGroupsAllocationEvent
      else if ActionName = AO_ChangeBalance then begin
        if Node.HasAttribute('sparklecheatused') then
          nSparkleCheats := StrToIntDef(Node.Attributes['sparklecheatused'], 0)
        else
          nSparkleCheats := 0;
        ChangeBalance(SessionID,
          StrToInt(Node.Attributes['userid']),
          StrToInt(Node.Attributes['currencytypeid']),
          StrToInt(Node.Attributes['type']),
          nSparkleCheats,
          StrToCurr(Node.Attributes['amount']),
          Node.Attributes['reason'],
        );
      end
      else if ActionName = AO_PromoCards then
        AddMoneyFromPromoCard(Node.Attributes['cardid'], Node.Attributes['userid'], SessionID);
    except
      on e : Exception do begin
        Log('ProcessAction', '[EXCEPTION]: ' + E.Message + '; Params:' +
          ' Data - ' + ActionsNode.XML,
          ltException
        );
        Exit;
      end;
    end;
  end;
end;


function TAccount.ChangeAccountStatus(SessionID, AccountID,
  StatusID: Integer): Integer;
var
//  Response: string;
  FSql: TSQLAdapter;
begin
  Result := 0;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      FSql.SetProcName('accChangeStatus');
      FSql.AddParInt('RETURN_VALUE',0, ptResult);
      FSql.AddParInt('AccountID',AccountID,ptInput);
      FSql.AddParInt('AccountStatusID',StatusID,ptInput);
      FSql.ExecuteCommand;

      Result := FSql.GetParam('RETURN_VALUE');

    except
      on e : Exception do begin
        Log('ChangeAccountStatus', '[EXCEPTION]: ' + e.Message +
          '; Params: SessionID = ' + IntToStr(SessionID) +
          ', AccountID = ' + IntToStr(AccountID) +
          ', StatusID = '  + IntToStr(StatusID),
          ltException
        );
{
        Response   := '<object name="cashier"><aochangestatus result="'+IntToStr(AC_ERR_SQLCOMMANDERROR)+
                      '"/></object>';
        if SessionID > 0 then
          CommonDataModule.NotifyUser(SessionID,Response);
}
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;
{
  Response := '<object name="cashier"><aochangestatus result="' + IntToStr(Result) +
              '"/></object>';
  if SessionID > 0 then
    CommonDataModule.NotifyUser(SessionID,Response);
}
  Log('ChangeAccountStatus', 'Result=' + IntToStr(Result) +
    '; Params: SessionID = ' + IntToStr(SessionID) +
    ', AccountID = ' + IntToStr(AccountID) +
    ', StatusID = ' + IntToStr(StatusID),
    ltCall
  );
end;


function TAccount.CreateNewAccount(SessionID, UserID,
  CurrencyTypeID: Integer; var AccountID: Integer): Integer;
var
//  Response: String;
  FSql: TSQLAdapter;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // stored procedure accCreatenewAccount
    FSql.SetProcName('accCreateNewAccount');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('UserID',UserID,ptInput);
    FSql.AddParInt('CurrencyTypeID',CurrencyTypeID,ptInput);
    FSql.ExecuteCommand;

    Result := FSql.GetParam('RETURN_VALUE');

  except on e : Exception do
    begin
      Log('CreateNewAccount', '[EXCEPTION]: ' + e.Message +
        '; Params: SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID) +
        ', CurrencyTypeID = ' + IntToStr(CurrencyTypeID),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
{
      Response    := '<object name="cashier"><aocreatenewaccount result="' + IntToStr(Result) +
                   '"/></object>';
      if SessionID > 0 then
        CommonDataModule.NotifyUser(SessionID,Response)
      else
        CommonDataModule.NotifyUserByID(UserID,Response);
}
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  if Result = 0 then begin
    AccountId   := 0;
    Result      := AC_ERR_CREATENEWACCOUNTFAILED;
  end else begin
    AccountID   := Result;
    Result      := 0;
  end;
{
  Response := '<object name="cashier"><aocreatenewaccount result="' + IntToStr(Result) +
              '" accountid="' + IntToStr(AccountID)+'"/></object>';
  if SessionID > 0 then
    CommonDataModule.NotifyUser(SessionID,Response)
  else
    CommonDataModule.NotifyUserByID(UserID,Response);
}
  Log('CreateNewAccount', 'Result=' + IntToStr(Result) + ', AccountID=' + IntToStr(AccountID) +
    '; Params: SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', CurrencyTypeID = ' + IntToStr(CurrencyTypeID),
    ltCall
  );
end;

function TAccount.Deposit(SessionID, UserID,
  CurrencyTypeID: Integer; Amount: Currency; const CardName, CardNumber,
  Cvv, ExpMonth, ExpYear: String; var NewAmount: Currency): Integer;
var
    XML            : IXMLDocument;
    Node           : IXMLNode;
    CardTypeID,
    UserAccountID,
    IsFirst,
    CreditCardID   : integer;
    Error          : string;
    PNRef          : integer;
    AuthCode,
    ResponseMsg    : string;
    Comments       : string;
begin
  Log('Deposit',
    'Entry; Params: SessionID=' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', CurrencyTypeID = ' + IntToStr(CurrencyTypeID) +
    ', Amount = ' + CurrToStr(Amount) +
    ', CardName = ' + CardName +
    ', CardNumber = ' + CardNumber +
    ', CVV = ' + CVV +
    ', ExpMonth = ' + ExpMonth +
    ', ExpYear = ' + ExpYear,
    ltCall
  );

  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  Node       := XML.AddChild('object');
  Node.SetAttribute('name','cashier');
  NewAmount  := 0;

{ WARNING !!!:
  CardTypeID  !!!!!!!!!!!! (hardcoded)
  visa        = 1
  mastercard  = 2
  firepay     = 3
}
  if CardName = 'visa' then CardTypeID := 1
  else if CardName = 'mastercard' then CardTypeID := 2
  else if CardName = 'firepay' then CardTypeID := 3
  else begin
    Result := AC_ERR_WRONGCREDITCARDTYPE;
    Node := Node.AddChild(AO_Deposit);
    Node.SetAttribute('result',Result);
    Node.SetAttribute('newamount',NewAmount);
    Node.SetAttribute('reason',Error);
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
    else
      CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);
    XML := nil;
    Exit;
  end;

  Result := IsDepositAllowed(
    SessionID,CurrencyTypeID,Amount,UserAccountID,CardNumber, CVV,
    StrToInt(ExpMonth),StrToInt(ExpYear),CardTypeID, CreditCardID,Error
  );

  if Result <> 0 then begin
    Log('Deposit', '[ERROR]: Deposit not Allowed. Reason = ' + Error, ltError);

    Node := Node.AddChild(AO_Deposit);
    Node.SetAttribute('result',Result);
    Node.SetAttribute('newamount',NewAmount);
    Node.SetAttribute('reason',Error);
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
    else
      CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

    XML := nil;
    Exit;
  end;

  Result := ProcessCc(Amount,Cvv,CardNumber,ExpMonth,ExpYear,CardTypeID,UserID,ResponseMsg,AuthCode,PNRef);
  if Result <> 0 then begin
    Log('Deposit', '[ERROR]: Process Credit Card failed.', ltError);

    Node := Node.AddChild(AO_Deposit);
    Node.SetAttribute('result',Result);
    Node.SetAttribute('newamount',0);
    Node.SetAttribute('reason',ResponseMsg);
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
    else
      CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

    XML := nil;
    Exit;
  end;

  Comments := '';

  Result := DepositMoneyCC(UserAccountID,CreditCardID,PNRef,ResponseMsg,AuthCode,Amount,Comments,NewAmount,Error, IsFirst);

  Node := Node.AddChild(AO_Deposit);
  Node.SetAttribute('result',Result);
  Node.SetAttribute('newamount',NewAmount);
  Node.SetAttribute('reason','');
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
    else
      CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

  XML := nil;

end;

function TAccount.GetBalanceInfo(SessionID, UserID: Integer): Integer;
var
  FSql: TSQLAdapter;
  sData: string;
  nCheatsBlackjack, nCheatsRoulette: Integer;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      sData := FSql.ExecuteForXML('accGetBalanceInfoNew ' + IntToStr(UserID));
    except
      on e : Exception do begin
        Log('GetBalanceInfo', '[EXCEPTION]: ' + e.Message +
          '; Params: SessionID=' + IntToStr(SessionID) +
          ', UserID = ' + IntToStr(UserID),
          ltException
        );

        Result := AC_ERR_SQLCOMMANDERROR;
        { notification }
        sData :=
          '<object name="cashier">' +
            '<aogetbalanceinfo result="' + IntToStr(Result) + '"/>' +
          '</object>';
        if SessionID > 0 then
          CommonDataModule.NotifyUser(SessionID, sData)
        else
          CommonDataModule.NotifyUserByID(UserID, sData);

        { free sql }
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;

    try
      FSql.SetProcName('accGetUserSparkleCheats');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('userId', UserID,ptInput);
      FSql.AddParInt('Blackjack', 0, ptOutput);
      FSql.AddParInt('Roulette', 0, ptOutput);

      FSql.ExecuteCommand;

      nCheatsBlackjack := FSql.GetParam('Blackjack');
      nCheatsRoulette  := FSql.GetParam('Roulette');
    except
      nCheatsBlackjack := 0;
      nCheatsRoulette  := 0;
    end;

  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  { notification }
  Result := 0;
  sData :=
    '<object name="cashier">' +
      '<aogetbalanceinfo result="' + IntToStr(Result) + '" ' +
        'schroulette="' + IntToStr(nCheatsRoulette) + '" ' +
        'schblackjack="' + IntToStr(nCheatsBlackjack) + '">' +
        sData +
      '</aogetbalanceinfo>' +
    '</object>';
  if SessionID > 0 then
    CommonDataModule.NotifyUser(SessionID, sData)
  else
    CommonDataModule.NotifyUserByID(UserID, sData);

(*
  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  Root       := XML.AddChild('object');
  Root.SetAttribute('name','cashier');
  Root := Root.AddChild('aogetbalanceinfo');

  Result := 0;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      FSql.SetProcName('accGetBalanceInfo');
      FSql.AddParInt('UserID',UserID,adParamInput);
      FSql.AddParam('Balance1',0,adParamOutPut,adCurrency);
      FSql.AddParam('Balance2',0,adParamOutPut,adCurrency);
      FSql.AddParam('Balance3',0,adParamOutPut,adCurrency);
      FSql.AddParam('Balance4',0,adParamOutPut,adCurrency);
      FSql.AddParam('Reserved1',0,adParamOutPut,adCurrency);
      FSql.AddParam('Reserved2',0,adParamOutPut,adCurrency);
      FSql.AddParam('Reserved3',0,adParamOutPut,adCurrency);
      FSql.AddParam('Reserved4',0,adParamOutPut,adCurrency);

      FSql.ExecuteCommand;
      Balance1  := FSql.GetParam('balance1');
      Balance2  := FSql.GetParam('balance2');
      Balance3  := FSql.GetParam('balance3');
      Balance4  := FSql.GetParam('balance4');
      Reserved1 := FSql.GetParam('reserved1');
      Reserved2 := FSql.GetParam('reserved2');
      Reserved3 := FSql.GetParam('reserved3');
      Reserved4 := FSql.GetParam('reserved4');

    except
      on e : Exception do begin
        Log('GetBalanceInfo', '[EXCEPTION]: ' + e.Message +
          '; Params: SessionID=' + IntToStr(SessionID) +
          ', UserID = ' + IntToStr(UserID),
          ltException
        );

        Result      := AC_ERR_SQLCOMMANDERROR;
        Root.SetAttribute('result',Result);
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
    else
      CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

        XML := nil;
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  Root.SetAttribute('result',0);
  Node := Root.AddChild('account');
  Node.SetAttribute('currencytypeid',1);
  Node.SetAttribute('balance',balance1);
  Node.SetAttribute('reserved',reserved1);
  Node := Root.AddChild('account');
  Node.SetAttribute('currencytypeid',2);
  Node.SetAttribute('balance',balance2);
  Node.SetAttribute('reserved',reserved2);
  Node := Root.AddChild('account');
  Node.SetAttribute('currencytypeid',3);
  Node.SetAttribute('balance',balance3);
  Node.SetAttribute('reserved',reserved3);
  Node := Root.AddChild('account');
  Node.SetAttribute('currencytypeid',4);
  Node.SetAttribute('balance',balance4);
  Node.SetAttribute('reserved',reserved4);

    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
    else
      CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

  XML := nil;
*)
end;

function TAccount.GetMailingAddress(SessionID, UserID: Integer;
  var Data: String): Integer;
var
  XML  : IXMLDocument;
  Node : IXMLNode;
  FSql : TSQLAdapter;
  RS   : TDataSet;
begin
  Result := 0;
  Data := '';
  XML  := TXMLDocument.Create(nil);
  XML.Active := true;
  Node := XML.AddChild('object');
  Node.SetAttribute('name',APP_CASHIER);
  Node := Node.AddChild(AO_GetMailingAddress);

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // Excp
    try // finally
      FSql.SetProcName('accGetMailingAddress');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('UserID',UserID,ptInput);
      RS := FSql.ExecuteCommand;

      if RS.Eof then begin
        Result := AC_ERR_NOACCOUNT;
        Node.SetAttribute('result',Result);
      end else begin
        Node.SetAttribute('result',Result);
        Node.SetAttribute('firstname',RS.FieldValues['Firstname']);
        Node.SetAttribute('lastname',RS.FieldValues['LastName']);
        Node.SetAttribute('address1',RS.FieldValues['Address1']);
        Node.SetAttribute('address2',RS.FieldValues['Address2']);
        Node.SetAttribute('province',RS.FieldValues['Province']);
        Node.SetAttribute('city',RS.FieldValues['City']);
        Node.SetAttribute('stateid',RS.FieldValues['StateID']);
        Node.SetAttribute('zip',RS.FieldValues['Zip']);
        Node.SetAttribute('phone',RS.FieldValues['Phone']);
        Node.SetAttribute('countryid',RS.FieldValues['CountryID']);
      end;

    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end;
  except
    on e : Exception do begin
      Log('GetMailingAddress', '[EXCEPTION]: ' + e.Message + '; Params:' +
        ' SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
      Node.SetAttribute('result',Result);

    end;
  end;

  if SessionID > 0 then
    CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
  else
    CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

  XML := nil;
end;

function TAccount.GetReservedAmount(SessionID, UserID,
  GameProcessID: Integer; var Amount: Currency): Integer;
var
//  Response: String;
  FSql: TSQLAdapter;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      FSql.SetProcName('accGetReservedAmount');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('UserID',UserID,ptInput);
      FSql.AddParInt('GameProcessID',GameProcessID,ptInput);
      FSql.AddParam('Amount',Amount,ptOutput,ftCurrency);
      FSql.ExecuteCommand;

      Result      := FSql.GetParam('RETURN_VALUE');
      Amount      := FSql.GetParam('Amount');

    except
      on e : Exception do begin
        Log('GetReservedAmount', '[EXCEPTION]: ' + e.Message +
          '; Params: SessionID = ' + IntToStr(SessionID) +
          ', UserID = ' + IntToStr(UserID) +
          ', GameProcessID = ' + IntToStr(GameProcessID),
          ltException
        );

        Result      := AC_ERR_SQLCOMMANDERROR;
{
        Response    := '<object name="cashier"><aogetreservedamount result="' + IntToStr(Result) +
                       '"/></object>';
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  if Result = 1 then Result := AC_ERR_NOACCOUNT;
{
  Response := '<object name="cashier"><aogetreservedamount result="' + IntToStr(Result) +
              '" amount="' + CurrToStr(Amount)+'"/></object>';
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}
  AddToLog('GetReservedAmount', 'Result=' + IntToStr(Result) + ', Amount=' + CurrToStr(Amount) +
    '; Params: SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', GameProcessID = ' + IntToStr(GameProcessID),
    ltCall
  );
end;

function TAccount.GetReservedBalanceInfo(SessionID,
  UserID: Integer): Integer;
var
//  Response: String;
  FSql: TSQLAdapter;
  RS: TDataSet;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      FSql.SetProcName('accGetReservedBalanceInfo');
      FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
      FSql.AddParInt('UserID',UserID,ptInput);

      RS := FSql.ExecuteCommand;

    except
      on e : Exception do begin
        Log('GetReservedBalanceInfo','[EXCEPTION]: ' + e.Message +
          '; Params: SessionID=' + IntToStr(SessionID) +
          ', UserID=' + IntToStr(UserID),
          ltException
        );

        Result     := AC_ERR_SQLCOMMANDERROR;
{
        Response   := '<object name="cashier"><aogetreservedbalanceinfo result="' + IntToStr(Result) +
                      '"/></object>';
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;

    if RS.Eof then begin
      Result   := AC_ERR_SQLEMPTYDATASET;
{
      Response := '<object name="cashier"><aogetreservedbalanceinfo result="' + IntToStr(Result) +
                  '"/></object>';
}
    end else begin
      Result  := 0;
{
      Response := '<object name="account"><aogebalanceinfo result="' + IntToStr(Result) +  '"/>';
      while not RS.Eof do begin
        Response := Response + #13#10#9 + '<account accountid="';
        Response := Response + RS.Fields.Item['AccountID'].Value + '"';
        Response := Response + #13#10#9 + 'amount="';
        Response := Response + RS.Fields.Item['Amount'].Value + '"';
        Response := Response + #13#10#9 + 'currencyname="';
        Response := Response + RS.Fields.Item['CurrencyName'].Value + '"';
        Response := Response + #13#10#9 + 'gamename="';
        Response := Response + RS.Fields.Item['GameName'].Value + '"';
        Response := Response + #13#10#9 + 'gameprocessid="';
        Response := Response + RS.Fields.Item['GameProcessID'].Value + '"/>';

        RS.MoveNext;
      end;

      Response := Response + '/>' + #13#10 + '</object>';
}
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;
{
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);

  Log('GetReservedBalanceInfo', 'Result=' + IntToStr(Result) + ', Data=' + Response +
    '; Params: SessionID=' + IntToStr(SessionID) +
    ', UserID=' + IntToStr(UserID),
    ltCall
  );
}
end;

function TAccount.GetUserCurrencyBalance(SessionID, UserID,
  CurrencyID: Integer; var Amount: Currency): Integer;
var
//  Response: string;
  FSql: TSQLAdapter;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accGetUserCurrencyBalance');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('UserID',UserID,ptInput);
    FSql.AddParInt('CurrencyTypeID',CurrencyID,ptInput);
    FSql.AddParam('Amount',Amount,ptOutput,ftCurrency);
    FSql.ExecuteCommand;

    Result := FSql.GetParam('RETURN_VALUE');
    Amount := FSql.GetParam('Amount');

  except
    on e : Exception do begin
      Log('GetUserCurrencyBalance', '[EXCEPTION]: ' + e.Message +
        '; Params: SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID) +
        ', CurrencyID = '  + IntToStr(CurrencyID),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
{
      Response    := '<object name="cashier"><aogetusercurrencybalance result="' + IntToStr(Result) +
                    '"/></object>';

    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  if Result <> 0 then Result := AC_ERR_NOACCOUNT;
{
  Response := '<object name="cashier"><aogetusercurrencybalance result="' + IntToStr(Result) +
              '" amount="' + CurrToStr(Amount)+'"/></object>';
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}
  Log('GetUserCurrencyBalance', 'Result=' + IntToStr(Result) +
    '; Params: SessionID = ' + IntToStr(SessionID) +
    ', UserID = ' + IntToStr(UserID) +
    ', CurrencyID = ' + IntToStr(CurrencyID),
    ltCall
  );
end;

function TAccount.HandResult(GameProcessID, HandID: Integer;
  const Comment, Data: String): Integer;
var
  XML     : IXMLDocument;
  Node,
  SubNode : IXMLNode;
  AffNode : IXMLNode;
  i, J, UID, IsRaked,
  TxDocID : integer;
  s       : string;
  Amount  : currency;
  Comm    : string;
//
  AffID   : Integer;
  AffFee  : Currency;
begin
  XML          := TXMLDocument.Create(nil);
  XML.XML.Text := Data;
  XML.Active   := true;
  Node         := XML.DocumentElement;

  if Node.NodeName <> 'endofhand' then begin
    Log('HandResult', '[ERROR]: Wrong Root NodeName = ' + Node.NodeName + '; Params:' +
      ' GameProcessID = ' + IntToStr(GameProcessID) +
      ', HandID = ' + IntToStr(HandID) +
      ', Comments = ' + Comment +
      ', Data = ' + Data,
      ltError
    );

    Result := AC_ERR_WRONGREQUEST;
    XML    := nil;
    Exit;
  end;

  Result := GetTxDoc(Comment,TxDocID);
  if Result <> 0 then begin
    XML    := nil;
    Exit;
  end;

  // define raked hand
  IsRaked := 0;
  if Node.HasAttribute('israked') then IsRaked := Node.Attributes['israked'];

  for i := 0 to (Node.ChildNodes.Count-1) do begin
    SubNode := Node.ChildNodes.Nodes[i];

    if SubNode.NodeName = 'user' then begin
      UID    := StrToInt(SubNode.Attributes['userid']);
      s      := SubNode.Attributes['result'];
      Amount := StrToCurr(SubNode.Attributes['money']);
      Comm   := SubNode.Attributes['comment'];

      if s = 'w' then begin
        Result := HandWon(UID,GameProcessID,Amount,TxDocID,HandID,Comm,IsRaked);
        if Result <> 0 then begin
          XML    := nil;
          Exit;
        end;

        SaveUserLastHand(UID, GameProcessID, HandID);
      end else if s = 'l' then begin
        Result := HandLost(UID,GameProcessID,Amount,TxDocID,HandID,Comm, IsRaked);
        if Result <> 0 then begin
          XML    := nil;
          Exit;
        end;

        SaveUserLastHand(UID, GameProcessID, HandID);
      end else if s = 'b' then begin
        Result := HandBet(UID, GameProcessID, Amount, TxDocID, HandID , Comm);
        if Result <> 0 then begin
          XML    := nil;
          Exit;
        end;
      end else begin
        Result := AC_ERR_WRONGREQUEST;
        XML    := nil;
        Exit;
      end;
    end else if SubNode.NodeName = 'fee' then begin
      Amount := StrToCurr(SubNode.Attributes['money']);
      Comm   := SubNode.Attributes['comment'];
      Result := HandFee(GameProcessID,Amount,TxDocID,HandID,Comm);
      if Result <> 0 then begin
        XML    := nil;
        Exit;
      end;

      for J:=0 to SubNode.ChildNodes.Count - 1 do begin
        AffNode := SubNode.ChildNodes.Nodes[J];
        AffID   := StrToInt(AffNode.Attributes['id']);
        AffFee  := StrToCurr(AffNode.Attributes['money']);
        Result := AffiliateFee(AffID, GameProcessID, HandID, AffFee);
        if Result <> 0 then begin
          XML    := nil;
          Exit;
        end;
      end;

    end else begin
      Log('HandResult', '[ERROR]: Unrecognize NodeName = ' + SubNode.NodeName +
        '; Params: GameProcessID = ' + IntToStr(GameProcessID) +
        ', HandID = ' + IntToStr(HandID) +
        ', Comments = ' + Comment +
        ', Data = ' +  Data,
        ltError
      );

     Result := AC_ERR_WRONGREQUEST;
     XML    := nil;
     Exit;
    end;
  end;

  XML := nil;
end;

function TAccount.MoneyExchange(SessionID, AccountFromID,
  AccountToID: Integer; Amount: Currency; var NewAmountFrom,
  NewAmountTo: Currency): Integer;
var
//  Response: String;
  FSql: TSQLAdapter;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      FSql.SetProcName('accMoneyExchange');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('AccountFromID',AccountFromID,ptInput);
      FSql.AddParInt('AccountToID',AccountToID,ptInput);
      FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
      FSql.AddParam('NewAmountFrom',NewAmountFrom,ptOutput,ftCurrency);
      FSql.AddParam('NewAmountTo',NewAmountTo,ptOutput,ftCurrency);
      FSql.ExecuteCommand;

      Result        := FSql.GetParam('RETURN_VALUE');
      NewAmountFrom := FSql.GetParam('NewAmountFrom');
      NewAmountTo   := FSql.GetParam('NewAmountTo');

    except
      on e : Exception do begin
        Log('MoneyExchange', '[EXCEPTION]: ' + E.Message + '; Params:' +
          ' SessionID=' + IntToStr(SessionID) +
          ', AccountFromID=' + IntToStr(AccountFromID) +
          ', AccountToID=' + IntToStr(AccountToID) +
          ', Amount=' + CurrToStr(Amount),
          ltException
        );

        Result      := AC_ERR_SQLCOMMANDERROR;
{
        Response    := '<object name="cashier"><aomoneyexchange result="' + IntToStr(Result) +
                       '"/></object>';
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response);
}
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  case Result of
    1 : Result := AC_ERR_NOACCOUNT;         // one of accounts(or both) not found
    2 : Result := AC_ERR_WITHDRAWALFAILED;  // not enough money to execute operation
  end;
{
  Response := '<object name="cashier"><aomoneyexchange result="' + IntToStr(Result) +
              '" newamountfrom="' + CurrToStr(NewAmountFrom) +
              '" newamountto="' + CurrToStr(NewAmountTo) + '"/></object>';
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response);
}
  Log('MoneyExchnge',
    'Result=' + IntToStr(Result) +
      ', NewAmountFrom=' + CurrToStr(NewAmountFrom) +
      ', NewAmountTo=' + CurrToStr(NewAmountTo) +
    '; Params: SessionID=' + IntToStr(SessionID) +
      ', AccountFromID=' + IntToStr(AccountFromID) +
      ', AccountToID=' + IntToStr(AccountToID) +
      ', Amount=' + CurrToStr(Amount),
    ltCall
  );
end;


function TAccount.ReservAmount(SessionID, UserID,
  GameProcessID: Integer; Amount: Currency; var NewAmount,
  NewReserv: Currency): Integer;
var
//  Response : String;
  FSql     : TSQLAdapter;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      FSql.SetProcName('accReservAmount');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('UserID',UserID,ptInput);
      FSql.AddParInt('GameProcessID',GameProcessID,ptInput);
      FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
      FSql.AddParam('NewAmount',NewAmount,ptOutput,ftCurrency);
      FSql.AddParam('NewReserv',NewReserv,ptOutput,ftCurrency);

      FSql.ExecuteCommand;

      Result    := FSql.GetParam('RETURN_VALUE');
      NewAmount := FSql.GetParam('NewAmount');
      NewReserv := FSql.GetParam('NewReserv');

    except
      on e : Exception do begin
        Log('ReservAmount', '[EXCEPTION]: ' + e.Message + '; Params:' +
          ' SessionID = ' + IntToStr(SessionID) +
          ', UserID = ' + IntToStr(UserID) +
          ', GameProcessID = ' + IntToStr(GameProcessID) +
          ', Amount = ' + CurrToStr(Amount),
          ltException
        );

        Result      := AC_ERR_SQLCOMMANDERROR;
{
        Response    := '<object name="cashier"><aoreservamount result="' + IntToStr(Result) +
                       '"/></object>';
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}      
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  case Result of
    1 : Result := AC_ERR_GAMEPROCESSNOTFOUND;  // game process not found
    2 : Result := AC_ERR_NOACCOUNT;            // account not found
                                               // user has'n account for CurrencyType
                                               // assosiated with GameProcessID
    3 : Result := AC_ERR_WITHDRAWALFAILED;     // not enough money on account
  end;

{
  Response := '<object name="cashier"><aoreservamount result="' + IntToStr(Result) +
              '" newamount="' + CurrToStr(NewAmount) +
              '" newreserv="' + CurrToStr(NewReserv) + '"/></object>';

    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}      
  GetBalanceInfo(SessionID,UserID);

  Log('ReservAmount',
    'Result=' + IntToStr(Result) + ', NewAmount = ' + CurrToStr(NewAmount) +
      ', NewReserv = ' + CurrToStr(NewReserv) + '; Params:' +
      ', UserID=' + IntToStr(UserID) +
      ', GameProcessID=' + IntToStr(GameProcessID),
    ltCall
  );
end;

function TAccount.ReservForTournament(GameProcessID: Integer;
  var Data: String): Integer;
var
  XML   : IXMlDocument;
  Node  : IXMLNode;
  Amount: currency;
  UserID: integer;
  FSql  : TSQLAdapter;
begin
  Result := 0;
  try
    XML          := TXMLDocument.Create(nil);
    XML.XML.Text := Data;
    XML.Active   := true;
    Node         := XML.DocumentElement;
  except
    on e: Exception do begin
      Log('ReservForTournament', '[EXCEPTION] On open XML document: ' + e.Message +
        '; Params: GameProcessID=' + IntToStr(GameProcessID) +
        ', Data=' + Data,
        ltException
      );

      XML := nil;
      Exit;
    end;
  end;

  if Node.NodeName <> 'singletournamentreserv' then begin
    Log('ReservForTournament', '[ERROR]: Wrong Root NodeName: ' + Node.NodeName +
      '; Params: GameProcessID = ' + IntToStr(GameprocessID) +
      ', Data = ' + Data,
      ltError
    );

    XML    := nil;
    Result := AC_ERR_WRONGREQUEST;
    Exit;
  end;

  Amount := StrToCurrDef(Node.GetAttribute('buyin'),0);
  UserID := StrToIntDef(Node.GetAttribute('userid'),0);

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accReservForSingleTournament');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('UserID',UserID,ptInput);
    FSql.AddParInt('GameProcessID',gameprocessID,ptInput);
    FSql.AddParam('Amount',Amount,ptInput, ftCurrency);
    FSql.ExecuteCommand;

    Result  := FSql.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('ReservForTournament', '[EXCEPTION]: ' + e.Message +
        '; Params: GameprocessID = ' + IntToStr(GameprocessID) +
        ', UserID=' + IntToSTr(UserID),
        ltException
      );

      XML    := nil;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Result      := AC_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  // notify about new ballance
  if UserID > 0 then GetBalanceInfo(0,UserID);

end;

function TAccount.ReturnAllMoneyFromGameProcess(GameProcessID: Integer): Integer;
var
  FSql: TSQLAdapter;
begin
  Result := PO_NOERRORS;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accReturnAllMoneyFromGameprocess');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.AddParInt('GameProcessID',GameprocessID,ptInput);
    FSql.ExecuteCommand;
  except
    on e : Exception do begin
      Log('ReturnAllMoneyFromGameProcess', '[EXCEPTION]: ' + e.Message + '; Params:' +
        ' GameProcessID = ' + IntToStr(GameProcessID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Result := AC_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAccount.ReturnAmount(SessionID, UserID,
  GameProcessID: Integer; Amount: Currency; var NewAmount,
  NewReserv: Currency): Integer;
var
//  Response : String;
  FSql     : TSQLAdapter;
  ReservBefore: Currency;
begin
  ReservBefore := 0;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      FSql.SetProcName('accReturnAmount');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('UserID',UserID,ptInput);
      FSql.AddParInt('GameProcessID',GameProcessID,ptInput);
      FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
      FSql.AddParam('ReservBeforeUpdate',ReservBefore,ptOutput,ftCurrency);
      FSql.AddParam('NewAmount',NewAmount,ptOutput,ftCurrency);
      FSql.AddParam('NewReserv',NewReserv,ptOutput,ftCurrency);

      FSql.ExecuteCommand;

      Result    := FSql.GetParam('RETURN_VALUE');
      NewAmount := FSql.GetParam('NewAmount');
      NewReserv := FSql.GetParam('NewReserv');
      ReservBefore := FSql.GetParam('ReservBeforeUpdate');

    except
      on e : Exception do begin
        Log('ReturnAmount', '[EXCEPTION]: ' + e.Message + '; Params:' +
          ' SessionID=' + IntToStr(SessionID) +
          ', UserID=' + IntToStr(UserID) +
          ', GameProcessID=' + IntToStr(GameProcessID) +
          ', AmountBeforeReturn=' + CurrToStr(ReservBefore) +
          ', Amount=' + CurrToStr(Amount),
          ltException
        );

        Result      := 0;
//        Result      := AC_ERR_SQLCOMMANDERROR;
{
        Response    := '<object name="cashier"><aoreturn result="' + IntToStr(Result) +
                       '"/></object>';
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}      
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  case Result of
    1 : Result := AC_ERR_GAMEPROCESSNOTFOUND;   // gameprocess not found
    2 : Result := AC_ERR_NOACCOUNT;             // account not found
    3 : Result := AC_ERR_NORESERVEDMONEY;       // no money reserved for gameprocessid
    4 : Result := AC_ERR_NOTENOUGHRESERVEDMONEY // Amount > than reserved money
  end;

  if Result<>0 then begin
     Log('ReturnAmount', '[ERROR] Result=' + IntToStr(Result) + '; Params:' +
       ' SessionID=' + IntToStr(SessionID) +
       ', UserID=' + IntToStr(UserID) +
       ', GameProcessID=' + IntToStr(GameProcessID) +
       ', Amount=' + CurrToStr(Amount),
       ltError
     );

    //!!!!!!!!!!!!!!!!
    // Important !!!
    // It's debug for only
    //if Result = 4 then begin
    //    Result := 0;
    //    //when it will fixed need remove dummy at accReturnAmount
    //end;
    //!!!!!!!!!!!!!!!!
    // Cannot Return More That 0
    //!!!!!!!!!!!!!!!!

  end; // if Result<>0
{
  Response :=
    '<object name="cashier">' +
      '<aoreturnamount result="' + IntToStr(Result) +
              '" newamount="' + CurrToStr(NewAmount) +
              '" newreserv="' + CurrToStr(NewReserv) + '"' +
      '/>' +
    '</object>';

    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,Response)
    else
      CommonDataModule.NotifyUserByID(UserID,Response);
}
  GetBalanceInfo(SessionID,UserID);

  Log('ReturnAmount', 'Result=' + IntToStr(Result) + '; Params:' +
    ' SessionID=' + IntToStr(SessionID) +
    ', UserID=' + IntToStr(UserID) +
    ', GameProcessID=' + IntToStr(GameProcessID) +
    ', Amount=' + CurrToStr(Amount),
    ltCall
  );
end;

function TAccount.TournamentPrize(GameProcessID: Integer;
  var Data: String): Integer;
var
  XML     : IXMlDocument;
  Node,
  SubNode,
  AffNode : IXMLNode;
  Amount, BonusAmount,
  Fee     : currency;
  AffFee  : Currency;
  i, J: Integer;
  UID, AffID : integer;
//  TransLevel : integer;
  txDocID : integer;
  Comment : string;
  FSql: TSQLAdapter;
  sSQL: string;
  nCnt: Integer;
  ArrayUID: array of Integer;
begin
  Result := 0;
  try
    XML          := TXMLDocument.Create(nil);
    XML.XML.Text := Data;
    XML.Active   := true;
  except
    on E: Exception do begin
      Log('TournamentPrize', '[EXCEPTION]: ' + e.Message + '; Params:' +
        ' GameprocessID = ' + IntToStr(GameprocessID) +
        ', Data = ' + Data,
        ltException
      );

      XML := nil;
      Result := AC_ERR_WRONGREQUEST;
      Exit;
    end;
  end;

  Node         := XML.DocumentElement;
  if Node.NodeName <> 'singletournamentprize' then begin
    Log('TournamentPrize', '[ERROR]: Wrong Root NodeName: ' + Node.NodeName +'; Params:' +
      ' GameprocessID = ' + IntToStr(GameprocessID) + ', Data = ' + Data,
      ltError
    );

    XML    := nil;
    Result := AC_ERR_WRONGREQUEST;
    Exit;
  end;

  Fee := StrToCurrDef(Node.GetAttribute('fee'),0);
//  TransLevel := 0;

//--------------------------------------------------------
  sSQL := 'BEGIN TRANSACTION TournamentPrize' + #13#10;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accGetTxDocID');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    Comment       := 'Singletable Tournament ' + IntToStr(GameprocessID) ;
    FSql.AddParString('Name',comment,ptInput);
    FSql.AddParInt('TxDocID',0,ptOutput);
    FSql.ExecuteCommand;
    txDocID := FSql.GetParam('TxDocID');

    nCnt := Node.ChildNodes.Count;
    SetLength(ArrayUID, nCnt);
    for i := 0 to (Node.ChildNodes.Count-1) do begin
      SubNode := Node.ChildNodes.Nodes[i];
      UID := 0;
      if SubNode.NodeName = 'user' then begin
        UID     := StrToIntDef(SubNode.GetAttribute('userid'),0);
        Amount  := 0;
        if SubNode.HasAttribute('prize') then
          Amount  := StrToCurrDef(SubNode.GetAttribute('prize'),0);
        BonusAmount := 0;
        if SubNode.HasAttribute('bonusprize') then
          BonusAmount := StrToCurrDef(SubNode.GetAttribute('bonusprize'),0);
        Comment := SubNode.GetAttribute('comment');

        sSQL := sSQL +
          'EXEC accSingleTournamentPrize ' +
              IntToStr(GameprocessID) + ', ' +
              IntToStr(UID) + ', ' +
              IntToStr(TxDocID) + ', ' +
              CurrToStr(Amount) + ', ' +
              CurrToStr(BonusAmount) + ', ' +
              '''' + StringReplace(Comment, '''', '"', [rfReplaceAll]) + ''''#13#10;
      end
      else if (SubNode.NodeName = 'fee') then begin
        for J := 0 to SubNode.ChildNodes.Count-1 do begin
          AffNode := SubNode.ChildNodes.Nodes[J];
          AffID := StrToIntDef(AffNode.Attributes['id'], 0);
          AffFee := StrToCurrDef(AffNode.Attributes['money'], 0);

          sSQL := sSQL +
            'EXEC accMiniTournayAffiliateFee ' +
              IntToStr(AffID) + ', ' +
              IntToStr(GameprocessID) + ', ' +
              CurrToStr(AffFee) + #13#10;
        end;
      end;
      ArrayUID[I] := UID;
    end;

    XML := nil;

    Comment := 'SingleTable Tournament '+IntToStr(GameProcessID);
    sSQL := sSQL+
      'EXEC accTournamentFee ' +
          IntToStr(GameProcessid) + ', ' +
          IntToStr(txdocid) + ', ' +
          CurrToStr(Fee) + ', ' +
          '''' + Comment + ''''#13#10;

//    sSQL := sSQL + 'EXEC acccleanreserv ' + IntToStr(GameProcessid) + #13#10;

    sSQL := sSQL + 'COMMIT TRANSACTION TournamentPrize'#13#10;
    FSql.Execute(sSQL);

//--------------------------------------------------------
  except
    on e: Exception do begin
//--------------------------------------------------------
      Log('TournamentPrize', '[EXCEPTION] On execute SQL: ' + e.Message +
        '; Params: SQL=' + sSQL,
        ltException
      );

      XML := nil;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Result      := AC_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  // notify about new ballance
  for I:=0 to nCnt - 1 do begin
    if ArrayUID[I] > 0 then GetBalanceInfo(0, ArrayUID[I]);
  end;

  Log('TournamentPrize', 'All Right; Params:' +
    ' GameprocessID = ' + IntToStr(GameprocessID) +
    ', Data = ' + Data,
    ltCall
  );
end;

function TAccount.UpdateMailingAddress(SessionID, UserID: Integer;
  const FirstName, LastName, Address1, Address2, Province, City: String;
  StateID: Integer; const Zip, Phone: String; CountryID: Integer): Integer;
var
  XML  : IXMLDocument;
  Node : IXMLNode;
  FSql : TSQLAdapter;
begin
  XML  := TXMLDocument.Create(nil);
  XML.Active := true;
  Node := XML.AddChild('object');
  Node.SetAttribute('name',APP_CASHIER);
  Node := Node.AddChild(AO_UpdateMailingAddress);

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accUpdateMailingAddress');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('UserID',UserID,ptInput);
    FSql.AddParWString('FirstName',FirstName,ptInput);
    FSql.AddParWString('LastName',LastName,ptInput);
    FSql.AddParWString('Address1',Address1,ptInput);
    FSql.AddParWString('Address2',Address2,ptInput);
    FSql.AddParWString('Province',Province,ptInput);
    FSql.AddParWString('City',City,ptInput);
    FSql.AddParInt('StateID',StateID,ptInput);
    FSql.AddParString('Zip',Zip,ptInput);
    FSql.AddParString('Phone',Phone,ptInput);
    FSql.AddParInt('CountryID',CountryID,ptInput);
    FSql.ExecuteCommand;

    Result := FSql.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('UpdateMailingAddress', '[EXCEPTION]: ' + e.Message +
        '; Params: SessionID = ' + IntToStr(SessionID) +
        ', UserID = ' + IntToStr(UserID) +
        ', FirstName = ' + FirstName +
        ', LastName = ' + LastName +
        ', Address1 = ' + Address1 +
        ', Address2 = ' + Address2 +
        ', Province = ' + Province +
        ', City = ' + City +
        ', StateID = ' + IntToSTr(StateID) +
        ', Zip = ' + Zip +
        ', Phone = ' + Phone +
        ', CountryID = ' + IntToStr(CountryID),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
      Node.SetAttribute('result',Result);
    if SessionID > 0 then
      CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
    else
      CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

      XML := nil;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  Node.SetAttribute('result',Result);
  if SessionID > 0 then
    CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
  else
    CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

  XML := nil;

end;

function TAccount.Withdrawal(SessionID, UserID,
  CurrencyTypeID: Integer; Amount: Currency; const Comments: String;
  var NewAmount: Currency): Integer;
var
  Response: String;
  aCreditCards: TCreditCardList;
  aCard: TCreditCard;
  I, ttRes, nPNRef: Integer;
  nRestAmount, nAmountCC: Currency;
  sRespMSG, sAuthCode: string;
  //
  eMailData, eMailAdmData: string;
  aEMail: TEMail;
  //
  sUserName: string;
  sUserInfo: string;

  function GetCardNameByID(nID: Integer): string;
  begin
    case nID of
      1: Result := 'VISA';
      2: Result := 'Master Card';
      3: Result := 'Fire Pay';
    else
      Result := '';
    end;
  end;
begin
  Log('Withdrawal',
    'Entry; Params: SessionID=' + IntToStr(SessionID) +
      ', UserID=' + IntToStr(UserID) +
      ', CurrencyTypeID=' + IntToStr(CurrencyTypeID) +
      ', Amount=' + CurrToStr(Amount) +
      ', Comments=' + Comments,
    ltCall
  );

  Result := IsWithdrawalAllowed(SessionID, UserID, CurrencyTypeID, Amount);
  if (Result <> 0) then begin
    Response := '<object name="cashier"><aowithdrawal result="' + IntToStr(Result) + '"/></object>';

    if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
    else CommonDataModule.NotifyUserByID(UserID,Response);

    Exit;
  end;

  if Amount <= 0 then begin
    Result := AC_ERR_WITHDRAWALFAILED_AMOUNTISNULL;
    Response := '<object name="cashier"><aowithdrawal result="' + IntToStr(Result) + '"/></object>';

    if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
    else CommonDataModule.NotifyUserByID(UserID,Response);

    Exit;
  end;

  { get all credit cards from DB into TCreditCardList object }
  aCreditCards := TCreditCardList.Create;
  Result := GetAllUserCreditCards(UserID, aCreditCards);
  if (Result <> 0) then begin
    aCreditCards.Free;

    Response := '<object name="cashier"><aowithdrawal result="' + IntToStr(Result) + '"/></object>';

    if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
    else CommonDataModule.NotifyUserByID(UserID,Response);

    Exit;
  end;

  eMailData := '';
  nRestAmount := Amount;
  for I:=0 to aCreditCards.Count - 1 do begin
    aCard := aCreditCards.Cards[I];

    { Get not null Sum to Credit Transaction }
    nAmountCC := aCard.FAmountDeposited;
    if (nAmountCC > nRestAmount) then begin
      nAmountCC := nRestAmount;
    end;

    { credit card VS or firepay transaction }

    ttRes := WithdrawalCC(nAmountCC, aCard.FCVV2, aCard.FCardNumber,
      IntToStr(aCard.FExpirationMonth), IntToStr(aCard.FExpirationYear), aCard.FCardTypeID, UserID,
      sRespMSG, sAuthCode, nPNRef
    );
    if ttRes <> 0 then Continue;

    Result := WithdrawalToCreditCard(UserID, CurrencyTypeID, aCard.FID, IntToStr(nPNRef), sRespMSG, sAuthCode, nAmountCC, NewAmount);
    if Result = 0 then begin
      nRestAmount := nRestAmount - nAmountCC;
      eMailData := eMailData + '$' + FormatFloat('0.00', nAmountCC) + ' was transferred to your ' + GetCardNameByID(aCard.FCardTypeID) + ' #' + aCard.FCardNumber + '.<br>';
    end;

    if nRestAmount <= 0 then Break;
  end;

  { dispose aCreditCards object }
  aCreditCards.Free;

  GetMailingAddressForWithdrawal(UserID, sUserName, sUserInfo);

  eMailAdmData := 'User "' + sUserName + '" with UserID="' + IntToStr(UserID) + '" withdrawed $' + FormatFloat('0.00', Amount) + '.<br>';

  { Withdrawal rest money }
  if nRestAmount > 0 then begin
    Result := accWithdrawalExecute(UserID, CurrencyTypeID, nRestAmount, Comments, NewAmount);

    eMailAdmData := eMailAdmData + '$' + FormatFloat('0.00', nRestAmount) + ' have to transfer for user by bank cheque.<br>' + sUserInfo;
    eMailData := eMailData + '$' + FormatFloat('0.00', nRestAmount) + ' you will receive by bank cheque.<br>';
  end;
  eMailAdmData := eMailAdmData + '<br>Copy of the letter to the User:<br><br>' + eMailData;

  { send EMail to admin & user }
  if eMailData <> '' then begin
    aEMail := CommonDataModule.ObjectPool.GetEmail;

    aEMail.SendAdminEmail(SessionID, UserID, 'Withdrawal report - "' + sUserName + '"', eMailAdmData);
    aEMail.SendUserEmail(SessionID, UserID, 'Withdrawal report', eMailData);

    CommonDataModule.ObjectPool.FreeEmail(aEMail);
  end;

  if Result <> 0 then begin
    Response := '<object name="cashier"><aowithdrawal result="' + IntToStr(Result) + '"/></object>';
  end else begin
    Response :=
      '<object name="cashier"><aowithdrawal result="' + IntToStr(Result) +
        '" newamount="' + CurrToStr(NewAmount)+'"/></object>';
  end;

  if SessionID > 0 then CommonDataModule.NotifyUser(SessionID,Response)
  else CommonDataModule.NotifyUserByID(UserID,Response);

  Log('Withdrawal',
    'Exit; Result=' + IntToStr(Result) + ', NewAmount=' + CurrToStr(NewAmount) +
    '; Params: UserID=' + IntToStr(UserID),
    ltCall
  );
end;

function TAccount.DepositMoneyCC(UserAccountID, CreditCardID,
  PNRef: integer; ResponseMsg, AuthCode: string; Amount: currency;
  Comments: string; var newAmount: currency; var Error: string;
  var IsFirst: Integer): integer;
var
  FSQL: TSQLAdapter;
begin
  Log('DepositMoneyCC',
    'Entry; Params: UserAccountID = ' + IntToStr(UserAccountID) +
      ', CreditCardID = ' + IntToStr(CreditCardID) +
      ', PNRef = ' + IntToStr(PNRef) +
      ', ResponseMsg = ' + ResponseMsg +
      ', AuthCode = ' + AuthCode +
      ', Amount = ' + CurrToStr(Amount) +
      ', Comments = ' + Comments,
    ltCall
  );

  FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;

  NewAmount := 0;
  try
    FSql.SetProcName('aacDepositMoneyCC');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.AddParInt('UserAccountID',UserAccountID,ptInput);
    FSql.AddParInt('CreditCardID',CreditCardID,ptInput);
    FSql.AddParInt('PNRef',PNRef,ptInput);
    FSql.AddParString('ResponseMsg',ResponseMsg,ptInput);
    FSql.AddParString('AuthCode',AuthCode,ptInput);
    FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
    FSql.AddParString('Comments',Comments,ptInput);
    FSql.AddParam('NewAmount',NewAmount,ptOutput,ftCurrency);
    FSql.AddParString('Error',Error,ptOutput);
    FSql.AddParString('IsFirst',IsFirst,ptOutput);
    FSql.ExecuteCommand;

    NewAmount := FSql.GetParam('NewAmount');
    Error	  := FSql.GetParam('Error');
    IsFirst := FSql.GetParam('IsFirst');

    Result       := 0;
    Error        := '';

  except
    on e : Exception do begin
      Log('DepositMoneyCC',
        '[EXCEPTION]: ' + e.Message + '; Rarams: UserAccountID = ' + IntToStr(UserAccountID) +
          ', CreditCardID = ' + IntToStr(CreditCardID) +
          ', PNRef = ' + IntToSTr(PNRef) +
          ', ResponseMsg = ' + ResponseMsg +
          ', AuthCode = ' + AuthCode +
          ', Amount = ' + CurrToStr(Amount) +
          ', Comments = ' + Comments,
          ltException);

      Result      := AC_ERR_SQLCOMMANDERROR;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);

  Log('DepositMoneyCC',
    'Exit: DepositMoneyCC is executed; Params: UserAccountID = ' + IntToStr(UserAccountID) +
      ', CreditCardID = ' + IntToStr(CreditCardID) +
      ', PNRef = ' + IntToStr(PNRef) +
      ', ResponseMsg = ' + ResponseMsg +
      ', AuthCode = ' + AuthCode +
      ', Amount = ' + CurrToStr(Amount) +
      ', Comments = ' + Comments,
    ltCall
  );
end;

function TAccount.GetMerchantData(UserID: integer): string;
var
  s: string;
  FSQL: TSQLAdapter;
  RS: TDataSet;
begin

  FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // finally
    try
      FSql.SetProcName('accGetMerchantData');
      FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
      FSql.AddParInt('UserID',UserID,ptInput);
      RS := FSql.ExecuteCommand;

      if RS.Eof then begin
        s := '';
        Exit;
      end;
      s :=
        '&custName1=' + Encode(Trim(RS.FieldValues['FirstName']) +
        ' ' + Trim(RS.FieldValues['LastName'])) +
        '&streetAddr=' +  Encode(Trim(RS.FieldValues['Address1'])) +
        '&streetAddr2=' + Encode(Trim(RS.FieldValues['Address2'])) +
        '&phone=' + Trim(RS.FieldValues['Phone']) +
        '&email=' + Trim(RS.FieldValues['Email']) +
        '&city=' + Encode(Trim(RS.FieldValues['City'])) +
        '&province=';
      if StrToInt(RS.FieldValues['IsUnitedStates']) = 1 then
        s := s + Trim(RS.FieldValues['Name'])
      else
        s := s + Trim(RS.FieldValues['Province']);

      s := s + '&zip=' + Trim(RS.FieldValues['Zip']) +
       '&country='+ RS.FieldValues['CountryCode'];

    except
      on e: Exception do begin
        Log('GetMerchantData',
          '[EXCEPTION]: ' + e.Message + '; Params: UserID = ' + IntToStr(UserID),
          ltException);

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Result := '';
        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
  end;

  Result := s;
end;

function TAccount.GetMerchantTxn: integer;
var
  FSql: TSQLAdapter;
begin
  Result := -1;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accGetPNRef');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.AddParInt('PNRef',0,ptOutput);
    FSql.ExecuteCommand;
    Result := FSql.GetParam('PNRef');
  except
    on e: Exception do begin
      Log('GetMerchantTxn', '[EXCEPTION]: ' + e.Message, ltException);
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAccount.GetTransactionHistory(SessionID, UserID,
  CurrencyTypeID, TopLast: integer; DateStart, DateEnd: string): integer;
var
  AccountID : integer;
  XML       : IXMLDocument;
  Node, NodeHist,
  SubNode   : IXMLNode;
  n         : integer;
  RS        : TDataSet;
  FSql      : TSQLAdapter;
begin

  Result      := 0;

  XML  := TXMLDocument.Create(nil);
  XML.Active := true;
  Node := XML.AddChild('object');
  Node.SetAttribute('name',APP_CASHIER);
  NodeHist := Node.AddChild(AO_TransactionHistory);
  NodeHist.SetAttribute('currencyid',inttostr(CurrencyTypeID));
  Node := NodeHist;
  //Node := NodeHist.AddChild('money');


  try
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      // real money history
      if TopLast = 0 then begin
        FSql.SetProcName('accGetTransactionHistoryByDates');
        FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
        FSql.AddParInt('UserID',UserID,ptInput);
        FSql.AddParInt('CurrencyTypeID',CurrencyTypeID,ptInput);
  //            FSql.AddParInt('toplast',TopLast,ptInput);
        FSql.AddParString('DateStart',DateStart,ptInput);
        FSql.AddParString('DateEnd',DateEnd,ptInput);
        FSql.AddParInt('AccountID',0,ptOutput);
      end else begin
        if TopLast < 0 then n := 0 else n := TopLast;
        FSql.SetProcName('accGetTransactionHistoryByNumber');
        FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
        FSql.AddParInt('UserID',UserID,ptInput);
        FSql.AddParInt('CurrencyTypeID',CurrencyTypeID,ptInput);
        FSql.AddParInt('TopLast',n,ptInput);
        FSql.AddParInt('AccountID',0,ptOutput);
      end;

      RS := FSql.ExecuteCommand;

      while not RS.Eof do begin
        SubNode := Node.AddChild('transaction');
        SubNode.SetAttribute('amount',RS.FieldValues['TxAmount']);
        SubNode.SetAttribute('balance',RS.FieldValues['AccountBalane']);
        SubNode.SetAttribute('type',RS.FieldValues['Name']);
        SubNode.SetAttribute('comment',RS.FieldValues['Comments']);
        SubNode.SetAttribute('date',RS.FieldValues['RecordDate']);
        SubNode.SetAttribute('handid',RS.FieldValues['GameLogID']);

        RS.Next;
      end;

      AccountID := FSql.GetParam('AccountID');
      if AccountID = 0 then begin
        Result := AC_ERR_NOACCOUNT;
        NodeHist.SetAttribute('result',Result);
        //Node := NodeHist.AddChild('bonuses');
        if SessionID > 0 then
          CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
        else
          CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);
            XML := nil;

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Exit;
      end;
      NodeHist.SetAttribute('result', Result);

      if SessionID > 0 then
        CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
      else
        CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);

      Log('GetTransactionHistory',
        'TransactionHistory was sending-' + XML.DocumentElement.XML, ltCall);

      XML := nil;

    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end;
  except
    on E: Exception do
    begin
      Log('GetTransactionHistory', E.Message, ltException);

      Result      := AC_ERR_SQLCOMMANDERROR;
      Node.SetAttribute('result',Result);
      if SessionID > 0 then
        CommonDataModule.NotifyUser(SessionID,XML.DocumentElement.XML)
      else
        CommonDataModule.NotifyUserByID(UserID,XML.DocumentElement.XML);
          XML := nil;
      Exit;
    end;
  end;
end;

function TAccount.GetTxDoc(Comments: string;
  var TxDocID: integer): integer;
var
  FSql: TSQLAdapter;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiCreateTxDoc');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParString('comment',Comments,ptInput);
    FSql.AddParInt('txdocid',TxDocID,ptOutput);

    FSql.ExecuteCommand;

    Result  := FSql.GetParam('RETURN_VALUE');
    TxDocID := FSql.GetParam('txdocid');

  except
    on e : Exception do begin
      Log('GetTxDoc',
        '[EXCEPTION]: On execute apiCreateTxDoc: ' + e.Message +
          '; Params: Comments = ' + Comments,
        ltException);

      Result      := AC_ERR_SQLCOMMANDERROR;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

end;

function TAccount.HandFee(GameProcessID: integer; Amount: Currency;
  TxDocID, HandID: integer; const Comment: String): integer;
var
  FSql: TSQLAdapter;
begin
  Log('HandFee', 'Entry; Params:' +
    ' GameProcessID = ' + IntToStr(GameProcessID) +
    ', Amount = ' + CurrToStr(Amount) +
    ', txDocID = ' + IntToStr(txDocID) +
    ', HandID = ' + IntToStr(HandID) +
    ', Comments = ' + Comment,
    ltCall
  );

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accHandFee');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('GameprocessID',GameProcessID,ptInput);
    FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
    FSql.AddParInt('TxDocID',TxDocID,ptInput);
    FSql.AddParInt('HandID',HandID,ptInput);
    FSql.AddParString('Comment',Comment,ptInput);

    FSql.ExecuteCommand;

    Result := FSql.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('HandFee', '[EXCEPTION] On execute accHandFee:' + e.Message +
        '; Params: GameProcessID = ' + IntToStr(GameProcessID) +
        ', Amount = ' + CurrToStr(Amount) +
        ', txDocID = ' + IntToStr(txDocID) +
        ', handID = ' + IntToStr(HandID) +
        ', Comment = ' + Comment,
        ltException);

      Result      := AC_ERR_SQLCOMMANDERROR;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  if Result <> 0 then
    Log('HandFee', '[ERROR] accHandFee SQL ERROR=' + IntToStr(Result) + '; Params:' +
      ' GameProcessID = ' + IntToStr(GameProcessID) +
      ', Amount = ' + CurrToStr(Amount) +
      ', txDocID = ' + IntToStr(txDocID) +
      ', HandID = ' + IntToStr(HandID) +
      ', Comments = ' + Comment,
      ltError
    );

end;

function TAccount.AffiliateFee(AffiliateID, ProcessID, HandID: Integer; Amount: Currency): Integer;
var
  FSql: TSQLAdapter;
begin
  Log('AffiliateFee', 'Entry; Params:' +
    ' ProcessID = ' + IntToStr(ProcessID) +
    ', Amount = ' + CurrToStr(Amount) +
    ', AffiliateID = ' + IntToStr(AffiliateID) +
    ', HandID = ' + IntToStr(HandID),
    ltCall
  );

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accHandAffiliateFee');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('AffiliateID', AffiliateID, ptInput);
    FSql.AddParInt('ProcessID', ProcessID, ptInput);
    FSql.AddParInt('HandID', HandID, ptInput);
    FSql.AddParam('Amount', Amount, ptInput, ftCurrency);

    FSql.ExecuteCommand;

    Result := FSql.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('AffiliateFee', '[EXCEPTION] On execute accHandAffiliateFee:' + e.Message +
        '; Params: ProcessID = ' + IntToStr(ProcessID) +
        ', Amount = ' + CurrToStr(Amount) +
        ', AffiliateID = ' + IntToStr(AffiliateID) +
        ', handID = ' + IntToStr(HandID),
        ltException);

      Result      := AC_ERR_SQLCOMMANDERROR;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  if Result <> 0 then
    Log('AffiliateFee', '[ERROR] accHandAffiliateFee SQL ERROR=' + IntToStr(Result) + '; Params:' +
      ' ProcessID = ' + IntToStr(ProcessID) +
      ', Amount = ' + CurrToStr(Amount) +
      ', AffiliateID = ' + IntToStr(AffiliateID) +
      ', HandID = ' + IntToStr(HandID),
      ltError
    );

end;

function TAccount.HandLost(UserID, GameProcessID: integer;
  Amount: Currency; TxDocID, HandId: integer; const Comment: String;
  IsRaked: Integer): integer;
var
  FSql: TSQLAdapter;
begin
  Log('HandLost', 'Entry; Params:' +
    ' UserID = ' + IntToStr(UserID) +
    ', GameProcessID = ' + IntToStr(GameProcessID) +
    ', Amount = ' + CurrToStr(Amount) +
    ', txDocID = ' + IntToStr(txDocID) +
    ', HandID = ' + IntToStr(HandID) +
    ', Comments = ' + Comment +
    ', IsRaked = ' + IntToStr(IsRaked),
    ltCall
  );

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accHandLost');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('UserID',UserID,ptInput);
    FSql.AddParInt('GameProcessID',GameProcessID,ptInput);
    FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
    FSql.AddParInt('txDocID',TxDocID,ptInput);
    FSql.AddParInt('HandID',HandID,ptInput);
    FSql.AddParInt('IsRaked',IsRaked,ptInput);
    FSql.AddParString('Comment',Comment,ptInput);

    FSql.ExecuteCommand;

    Result := FSql.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('HandLost', '[EXCEPTION]: ' + e.Message + '; Params:' +
        ' UserID = ' + IntToStr(UserID) +
        ', GameProcessID = ' + IntToStr(GameProcessID) +
        ', Amount = ' + CurrToStr(Amount) +
        ', txDocID = ' + IntToStr(txDocID) +
        ', handID = ' + IntToStr(HandID) +
        ', Comments = ' + Comment +
        ', IsRaked = ' + IntToStr(IsRaked),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  if Result <> 0 then
    Log('HandLost', '[ERROR] accHandLost SQL ERROR=' + IntToStr(Result) + '; Params:' +
      ' UserID = ' + IntToStr(UserID) +
      ', GameProcessID = ' + IntToStr(GameProcessID) +
      ', Amount = ' + CurrToStr(Amount) +
      ', txDocID = ' + IntToStr(txDocID) +
      ', HandID = ' + IntToStr(HandID) +
      ', Comments = ' + Comment +
      ', IsRaked = ' + IntToStr(IsRaked),
      ltError
    );

  if Result = 1 then Result := AC_ERR_GAMEPROCESSNOTFOUND
  else if Result = 2 then Result := AC_ERR_NOACCOUNT;
  GetBalanceInfo(0,UserID);

end;

function TAccount.HandWon(UserID, GameProcessID: integer;
  Amount: Currency; TxDocID, HandID: integer; const Comment: String;
  IsRaked: Integer): integer;
var
  FSql: TSQLAdapter;
begin
  Log('HandWon', 'Entry; Params:' +
    ' UserID = ' + IntToStr(UserID) +
    ', GameProcessID = ' + IntToStr(GameProcessID) +
    ', Amount = ' + CurrToStr(Amount) +
    ', txDocID = ' + IntToStr(txDocID) +
    ', HandID = ' + IntToStr(HandID) +
    ', Comments = ' + Comment +
    ', IsRaked = ' + IntToStr(IsRaked),
    ltCall
  );

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accHandWon');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('UserID',UserID,ptInput);
    FSql.AddParInt('GameProcessID',GameProcessID,ptInput);
    FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
    FSql.AddParInt('txDocID',TxDocID,ptInput);
    FSql.AddParInt('HandID',HandID,ptInput);
    FSql.AddParInt('IsRaked',IsRaked,ptInput);
    FSql.AddParString('Comment',Comment,ptInput);

    FSql.ExecuteCommand;

    Result := FSql.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('HandWon', '[EXCEPTION]: ' + e.Message + '; Params:' +
        ' UserID = ' + IntToStr(UserID) +
        ', GameProcessID = ' + IntToStr(GameProcessID) +
        ', Amount = ' + CurrToStr(Amount) +
        ', txDocID = ' + IntToStr(txDocID) +
        ', handID = ' + IntToStr(HandID) +
        ', Comment = ' + Comment +
        ', IsRaked = ' + IntToStr(IsRaked),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  if Result <> 0 then
    Log('HandWon', '[ERROR] accHandWon SQL ERROR=' + IntToStr(Result) + '; Params:' +
      ' UserID = ' + IntToStr(UserID) +
      ', GameProcessID = ' + IntToStr(GameProcessID) +
      ', Amount = ' + CurrToStr(Amount) +
      ', txDocID = ' + IntToStr(txDocID) +
      ', HandID = ' + IntToStr(HandID) +
      ', Comments = ' + Comment +
      ', IsRaked = ' + IntToStr(IsRaked),
      ltError
    );

  if Result = 1 then Result := AC_ERR_GAMEPROCESSNOTFOUND
  else if Result = 2 then Result := AC_ERR_NOACCOUNT;
  GetBalanceInfo(0,UserID);

end;

function TAccount.IsDepositAllowed(SessionID, CurrencyTypeID: integer;
  Amount: currency; var UserAccountID: integer; CardNumber, CVV: string;
  ExpMonth, ExpYear, CardTypeID: integer; var CreditCardID: integer;
  var Error: string): integer;
var
  FSql: TSQLAdapter;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // Finally
    try
      FSql.SetProcName('aacIsDepositAllowed');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('SessionID',SessionID,ptInput);
      FSql.AddParInt('CurrencyTypeID',CurrencyTypeID,ptInput);
      FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
      FSql.AddParInt('UserAccountID',UserAccountID,ptOutput);
      FSql.AddParString('CVV2',CVV,ptInput);
      FSql.AddParString('CardNumber',CardNumber,ptInput);
      FSql.AddParInt('ExpirationMonth',ExpMonth,ptInput);
      FSql.AddParInt('ExpirationYear',ExpYear,ptInput);
      FSql.AddParInt('CardTypeID',CardTypeID,ptInput);
      FSql.AddParInt('CreditCardID',CreditCardID,ptOutput);
      FSql.AddParString('Error',Error,ptOutput);

      FSql.ExecuteCommand;

      Result        := FSql.GetParam('RETURN_VALUE');
      UserAccountID := FSql.GetParam('UserAccountID');
      CreditCardID  := FSql.GetParam('CreditCardID');
      Error         := '';

      if Result <> 0 then begin
        Result := AC_ERR_DEPOSITNOTALLOWED;
        Error := FSql.GetParam('error');

        Log('IsDepositAllowed',
          '[ERROR]: Not Execute SQL Procedure aacIsDepositAllowed with error: ' + Error + '; Params:' +
            'SessionID = ' + IntToStr(SessionID) +
            ', CurrencyTypeID = ' + IntToStr(CurrencyTypeID) +
            ', Amount = ' + FloatToStr(Amount) +
            ', CardNumber = ' + CardNumber +
            ', ExpMonth = ' + IntToStr(ExpMonth) +
            ', ExpYear = ' + IntToStr(ExpYear) +
            ', CardTypeID = ' + IntToStr(CardTypeID),
          ltError
        );

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Exit;
      end;

    except
      on e : Exception do begin
        Log('IsDepositAllowed', '[EXCEPTION]: ' + e.Message + '; Params:' +
          'SessionID = ' + IntToSTr(SessionID) +
          ', CurrencyTypeID = ' + IntToStr(CurrencyTypeID) +
          ', Amount = ' + CurrToStr(Amount) +
          ', CardNumber = ' + CardNumber +
          ', ExpMonth = ' + IntToStr(ExpMonth) +
          ', ExpYear = ' + IntToStr(ExpYear) +
          ', CardTypeID = ' + IntToStr(CardTypeID),
          ltException
        );

        Result  := AC_ERR_SQLCOMMANDERROR;
     CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Exit;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  Result := 0;

end;

function TAccount.PrepareForFirePayParams(TransType: Char; Amount: currency; CardNumber, CardName,
  ExpMonth, ExpYear: string; UserID: integer; var PNRef: integer): string;
var
  s : string;
begin
{
    Prepare parameters string for processing center
}
  case TransType of
    's', 'S': TransType := 'S';
    'c', 'C': TransType := 'C';
  else
    CommonDataModule.Log(ClassName, 'PrepareForFirePayParams',
      'Transaction type (' + TransType + ')is not valid.', ltError);
    Exit;
  end;

  PNRef := GetMerchantTxn;
  if TransType = 'S' then begin
    s :=
      'account=' + ACCOUNTID + '&' +
      'amount=' + IntToStr(Trunc(Amount*100)) + '&' +
      'cardNumber=' + CardNumber + '&' +
      'cardType=' + CardName + '&' +
      'cardExp=' + ExpMonth + '%2F' + ExpYear + '&' +
      'cvdIndicator=0&cvdvalue=&operation=P&clientVersion=1.1' +
      '&merchantId=' + MERCHANTID + '&merchantPwd=' + MERCHANTPWD +
      '&merchantTxn=' + IntToStr(PNRef) +
      GetMerchantData(UserID);
  end else begin
    { TODO : (BS) in future need set on firepay cards }
    s := 'credit type of firePay transaction will be incapsulated in future';
  end;

  Result := s;

  Log('PrepareParams',
    'Parameters string for processing center: ' + s, ltCall);

end;

function TAccount.ProcessCC(Amount: currency; CVV2, CardNumber, ExpMonth,
  ExpYear: string; CardTypeID, UserID: integer; var ResponseMsg,
  AuthCode: string; var PNRef: integer): integer;
var
  s, CardName : string;
  aVSTransactionResult: TVSTransactionResult;
  sAdress, sZip: string;
begin
  Log('ProcessCC', 'Process CreditCard Request' +
    ' Amount = ' + CurrToStr(Amount) +
    ', CardNumber = ' + CardNumber +
    ', ExpMonth = ' + ExpMonth +
    ', ExpYear = ' + ExpYear +
    ', CardTypeID = ' + IntToStr(CardTypeID) +
    ', UserID = ' + IntToStr(UserID),
    ltCall
  );

  case CardTypeID of
    1: CardName := 'VI';
    2: CardName := 'MC';
    3: CardName := 'FP';
  else
    begin
      Result := AC_ERR_WRONGCREDITCARDTYPE;
      Exit;
    end;
  end;

  if CardTypeID in [1,2] then begin
    { Get Adaress & Zip for VeriSign}
    Result := GetAdressAndZipForVSTransaction(UserID, sAdress, sZip);
    if Result <> 0 then Exit;
    aVSTransactionResult := DoVSTransaction('S', CVV2, CardNumber, ExpMonth, ExpYear, Amount, sAdress, sZip);
    ResponseMsg := aVSTransactionResult.RespMsg;
    AuthCode    := aVSTransactionResult.AuthCode;
    PNRef       := StrToIntDef(aVSTransactionResult.PNRef, 0);
    Result := aVSTransactionResult.Result;
  end else begin
    { Get string params FirePay}
    s := PrepareForFirePayParams('S', Amount, CardNumber, CardName, ExpMonth, ExpYear, UserID, PNRef);
    Result := MakeRequestFirePay(s, ResponseMsg, AuthCode);
  end;
end;

procedure TAccount.AddToLog(MethodName, LogData: String; LogType: TLogType);
begin
  CommonDataModule.Log(ClassName, MethodName, LogData, LogType);
end;

procedure TAccount.Log(MethodName, LogData: String; LogType: TLogType);
begin
  CommonDataModule.Log(ClassName, MethodName, LogData, LogType);
end;

function TAccount.UnReserveForTournament(ProcessID: Integer;
  var Data: String): Integer;
var
  doc     : IXMlDocument;
  node    : IXMLNode;
  amount : currency;
  userID_  : integer;
  FSql: TSQLAdapter;
begin

  try
    doc := TXMLDocument.Create(nil);
    doc.XML.Text := Data;
    doc.Active   := true;
    node := doc.DocumentElement;

    if node.NodeName <> 'singletournamentreserv' then begin
      CommonDataModule.Log(ClassName, 'UnReserveForTournament',
        '[ERROR] On verify XML Data: Node Name is not singletournamentreserv' +
        '; Params: processId=' + IntToStr(processId) +
        ', data=' + Data,
        ltError
      );

      Result := AP_ERR_WRONGREQUESTDATA;
      doc    := nil;
      exit;
    end;

    amount := node.Attributes['buyin'];
    userID_ := node.Attributes['userid'];

  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'UnReserveForTournament',
        '[EXCEPTION] On verify XML Data:' + e.Message +
        '; Params: processId=' + IntToStr(processId) +
        ', data=' + Data,
        ltException
      );

      result:= AP_ERR_WRONGREQUESTDATA;
      doc    := nil;
      exit;
    end;
  end;
  doc    := nil;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accUnReservForSingleTournament');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('UserID',UserID_,ptInput);
    FSql.AddParInt('GameProcessID',processID,ptInput);
    FSql.AddParam('Amount',Amount,ptInput, ftCurrency);
    FSql.ExecuteCommand;
    result  := FSql.GetParam('RETURN_VALUE');
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'UnReserveForTournament',
        '[ERROR] On exec accUnReservForSingleTournament Result=' + IntToStr(Result) +
        '; Params: processId=' + IntToStr(processId) +
        ', UserID=' + IntToStr(userID_) +
        ', Amount=' + CurrToStr(Amount),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;

  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'UnReserveForTournament',
        '[EXCEPTION] On exec accUnReservForSingleTournament:' + e.Message +
        '; Params: processId=' + IntToStr(processId) +
        ', UserID=' + IntToStr(userID_) +
        ', Amount=' + CurrToStr(Amount),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

      result:= AP_ERR_CANNOTUNRESERVEMONEYFORTOURNAMENT;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  // notify about new ballance
  if userID_ > 0  then GetBalanceInfo(0,userID_);

  result := 0;

end;

function TAccount.DoVSTransaction(TransType: Char; CVV2, CardNum, ExpDateMonth,
  ExpDateYear: String; Amount: Real; Address,
  Zip: String): TVSTransactionResult;
var
  aPNCom      : TPNCom;
  Context1    : Integer;
  ParamList   : String;
  resString   : String;
begin
  CommonDataModule.Log(ClassName, 'DoVSTransaction', 'Entry.', ltCall);
  case TransType of
    's', 'S': TransType := 'S';
    'c', 'C': TransType := 'C';
  else
    CommonDataModule.Log(ClassName, 'DoVSTransaction',
      'Transaction type (' + TransType + ')is not valid.', ltError);
    Exit;
  end;

  { creating parameter list }
  ParamList :=
    'TRXTYPE=' + TransType +                        { set transaction type }
    '&TENDER=C&PWD=' + VS_PWD +                     { set the tender and password }
    '&USER='    + VS_USER +                         { set the user }
    '&VENDOR='  + VS_VENDOR +                       { set the vendor }
    '&PARTNER=' + VS_PARTNER +                      { set the partner }
    '&EXPDATE=' + ExpDateMonth + ExpDateYear +      { set the expiration date }
    '&AMT=' + FloatToStrF(Amount, ffFixed, 10, 2) + { set the amount }
    '&ACCT=' + CardNum +                            { set the account }
    '&STREET=' + Address +                          { set the street for AVS }
    '&ZIP=' + Zip;                                  { set the zip code for AVS }
  if (CVV2 <> '') then begin
    ParamList := ParamList + '&CVV2=' + CVV2;       { set the CSC }
  end;

  CommonDataModule.Log(ClassName, 'DoVSTransaction', 'Param list was created: ' + ParamList, ltCall);
  CommonDataModule.Log(ClassName, 'DoVSTransaction', 'Before execute aPNCom.CreateContext on: ' + VS_HOST_ADD, ltCall);

  aPNCom := TPNCom.Create(nil);
  Context1 := aPNCom.CreateContext(VS_HOST_ADD, 443, 30, '', 0, '', '');

  CommonDataModule.Log(ClassName, 'DoVSTransaction',
    'Before execute aPNCom.SubmitTransaction on: ' + VS_HOST_ADD + '; Context=' + IntToStr(Context1), ltCall);

  resString := aPNCom.SubmitTransaction(Context1, ParamList, Length(ParamList));

  CommonDataModule.Log(ClassName, 'DoVSTransaction',
    'Before execute aPNCom.DestroyContext on: ' + VS_HOST_ADD + '; Context=' + IntToStr(Context1), ltCall);

  { destroing context }
  aPNCom.DestroyContext(Context1);
  aPNCom.Free;

  CommonDataModule.Log(ClassName, 'DoVSTransaction',
    'Context destroy and aPNCom is Free; resString = ' + resString + '; Context=' + IntToStr(Context1), ltCall);

  Result := GetVSTransactionResult(resString);
  if (Result.AVSZip<>'Y') and (Result.AVSAddr<>'Y') and (Result.Result = 0) then begin
    { Delayed transaction }
    CommonDataModule.Log(ClassName, 'DoVSTransaction', 'Perform delayed transaction.', ltCall);

    Result.Result := -23000;
    Result.RespMsg:= 'User authentication failed';
    { creating PayFlow object }
    aPNCom := TPNCom.Create(nil);
    { creating parameter list }
    ParamList :=
      'TRXTYPE=V&TENDER=C' +
      '&PARTNER=' + VS_PARTNER +    { set the partner }
      '&VENDOR=' + VS_VENDOR +      { set the vendor }
      '&USER=' + VS_USER +          { set the user }
      '&PWD=' + VS_PWD +            { set the password }
      '&ORIGID=' + Result.PNRef;    { set the origid}

    CommonDataModule.Log(ClassName, 'DoVSTransaction', '[delayed] Param list was created: ' + ParamList, ltCall);
    { creating the context }
    Context1 := aPNCom.CreateContext(VS_HOST_ADD, 443, 30, '', 0, '', '');
    { submitting transation and getting the server response }
    resString := aPNCom.SubmitTransaction(Context1, ParamList, Length(ParamList));
    { destroing context }
    aPNCom.DestroyContext(Context1);

    aPNCom.Free;
  end;//rollback transaction if no match AVSZIP or AVSADDR

  { rechecking to transaction result }
  case Result.Result of
    1        : Result.RespMsg  := 'User authentication failed';
    11       : Result.RespMsg  := 'Client time-out waiting for response';
    -23000   : Result.RespMsg  := 'User authentication failed (bad Zip or Street)';
  end;
end;

function TAccount.GetVSTransactionResult(StrRes: string): TVSTransactionResult;
var
  varString, resString, Key, Value: string;
begin
  resString := StrRes;
  while Length(resString) > 0 do
  begin
    { get next key-value pair }
    if Pos('&', resString)>0 then
    begin
        varString := MidStr(resString, 1, Pos('&',resString)-1);
        { skip over the & }
        resString := MidStr(resString, Length(varString) + 2, MAXINT);
    end
    else
    begin
        varString := resString;
        resString := '';
    end;

    { get key name }
    Key := MidStr(varString, 1, Pos('=', varString)-1);
    { get key value }
    Value := MidStr(varString, Pos('=',varString) + 1, MAXINT);

    { storing results }
    if UPPERCASE(Key) = 'RESULT'    then Result.Result   := StrToIntDef(Value,-1000);
    if UPPERCASE(Key) = 'PNREF'     then Result.PNRef    := Value;
    if UPPERCASE(Key) = 'RESPMSG'   then Result.RespMsg  := Value;
    if UPPERCASE(Key) = 'AUTHCODE'  then Result.AuthCode := Value;
    if UPPERCASE(Key) = 'AVSADDR'   then Result.AVSAddr  := Value;
    if UPPERCASE(Key) = 'AVSZIP'    then Result.AVSZip   := Value;
    if UPPERCASE(Key) = 'IAVS'      then Result.IAVS     := Value;
    if UPPERCASE(Key) = 'CVV2MATCH' then Result.CVV2MATCH:= Value;
  end;
end;

function TAccount.GetAdressAndZipForVSTransaction(UserID: Integer;
  var sAdress, sZip: string): Integer;
var
  FSql: TSQLAdapter;
  RS: TDataSet;
begin
  Result := 0;
  sAdress := '';
  sZip    := '';

  { Get Adaress & Zip }
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // Except
    try // finally
      FSql.SetProcName('accGetMailingAddress');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('UserID',UserID,ptInput);
      RS := FSql.ExecuteCommand;

      if RS.Eof then begin
        Result := AC_ERR_NOACCOUNT;
        Exit;
      end else begin
        sAdress := Trim( RS.FieldValues['Address1'] );
        sAdress := sAdress + ' ' + Trim( RS.FieldValues['Address2']);
        sZip    := RS.FieldValues['Zip'];
      end;

    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end;
  except
    on e : Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessCC',
        '[EXCEPTION] On Execute FSql.accGetMailingAddress: ' + e.Message + '; Params:' +
        ' UserID = ' + IntToStr(UserID),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
    end;
  end;
end;

function TAccount.GetAllUserCreditCards(UserID: Integer;
  aCreditCards: TCreditCardList): Integer;
var
  FSql: TSQLAdapter;
  RS: TDataSet;
  //
  nAmountDeposited: Currency;
  nCardTypeID: Integer;
  nExpirationMonth: Integer;
  nExpirationYear: Integer;
  nID: Integer;
  sCVV2, sCardNumber: string;
begin
  CommonDataModule.Log(ClassName, 'GetAllUserCreditCards',
    'Entry with params: UserID=' + IntToStr(UserID), ltCall);

  { check on assigned aCreditCards object }
  if aCreditCards = nil then begin
    CommonDataModule.Log(ClassName, 'GetAllUserCreditCards',
      'Entry with params: UserID=' + IntToStr(UserID), ltCall);
    Result := AC_ERR_WRONGREQUESTPARAM;
    Exit;
  end;

  { Execute SQL procedure and filling aCreditCards object if need }
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // except
    try // finally
      FSql.SetProcName('accGetAllUserCreditCards');
      FSql.AddParInt('RETURN_VALUE', 0, ptResult);
      FSql.AddParInt('UserID', UserID, ptInput);

      RS := FSql.ExecuteCommand;

      Result := FSql.GetParam('RETURN_VALUE');

      if RS.EOF or (Result <> 0) then begin
        aCreditCards.Clear;
        Exit;
      end;

      while not RS.Eof do begin
        nAmountDeposited := RS.FieldValues['AmountDeposited'];
        nCardTypeID      := RS.FieldValues['CardTypeID'];
        nExpirationMonth := RS.FieldValues['ExpirationMonth'];
        nExpirationYear  := RS.FieldValues['ExpirationYear'];
        nID              := RS.FieldValues['ID'];
        sCVV2            := RS.FieldValues['CVV2'];
        sCardNumber      := RS.FieldValues['CardNumber'];

        aCreditCards.Add(
          nAmountDeposited,
          nCardTypeID, UserID, nExpirationMonth, nExpirationYear, nID,
          sCVV2, sCardNumber
        );

        RS.Next;
      end;

    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end; // finally
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'GetAllUserCreditCards',
        '[EXCEPTION] On execute FSql.accGetAllUserCreditCards: ' + E.Message + '; Params: UserID=' + IntToStr(UserID), ltException);

      Result := AC_ERR_SQLCOMMANDERROR;
      aCreditCards.Clear;
      Exit;
    end;
  end; // except

  CommonDataModule.Log(ClassName, 'GetAllUserCreditCards',
    'Exit. All right. Params: UserID=' + IntToStr(UserID) + ', CreditCards Count=' + IntToStr(aCreditCards.Count), ltCall);
end;

function TAccount.accWithdrawalExecute(UserID, CurrencyTypeID: Integer;
  Amount: Currency; Comments: String; var NewAmount: Currency): Integer;
var
  FSql: TSQLAdapter;
begin
  Log('accWithdrawalExecute',
    'Entry; Params: UserID=' + IntToStr(UserID) +
      ', CurrencyTypeID=' + IntToStr(CurrencyTypeID) +
      ', Amount=' + CurrToStr(Amount) +
      ', Comments=' + Comments,
    ltCall
  );

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // except
    try // finally
      FSql.SetProcName('accWithdrawal');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('UserID',UserID,ptInput);
      FSql.AddParInt('CurrencyTypeID',CurrencyTypeID,ptInput);
      FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
      FSql.AddParam('NewAmount',NewAmount,ptOutput,ftCurrency);

      FSql.ExecuteCommand;

      Result    := FSql.GetParam('RETURN_VALUE');
      NewAmount := FSql.GetParam('NewAmount');

    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end;
  except
    on e: Exception do begin
      Log('accWithdrawalExecute', '[EXCEPTION]: ' + e.Message +
        '; Params: UserID = ' + IntToStr(UserID) +
        ' CurrencyTypeID = ' + IntToStr(CurrencyTypeID) +
        ' Amount = ' + CurrToStr(Amount),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  end;

  if Result = 2 then Result := AC_ERR_WITHDRAWALFAILED  // not enough money
  else if Result = 1 then Result := AC_ERR_NOACCOUNT;

  Log('accWithdrawalExecute',
    'Exit; Result=' + IntToStr(Result) + ', NewAmount=' + CurrToStr(NewAmount) +
    '; Params: UserID=' + IntToStr(UserID),
    ltCall
  );
end;

function TAccount.IsWithdrawalAllowed(SessionID, UserID, CurrencyTypeID: Integer; Amount: Currency): Integer;
var
  FSql: TSQLAdapter;
begin
  CommonDataModule.Log(ClassName, 'IsWithwravalAllowed',
    'Entry; Params: SessionID=' + IntToStr(SessionID) +
      ', UserID=' + IntToStr(UserID) +
      ', CurrencyTypeID=' + IntToStr(CurrencyTypeID) +
      ', Amount=' + CurrToStr(Amount),
    ltCall
  );

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // except
    try // finally
      FSql.SetProcName('accIsWithdrawalAllowed');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('SessionID', SessionID, ptInput);
      FSql.AddParInt('UserID', UserID, ptInput);
      FSql.AddParInt('CurrencyTypeID', CurrencyTypeID, ptInput);
      FSql.AddParam('Amount', Amount, ptInput, ftCurrency);
      FSql.ExecuteCommand;

      Result := FSql.GetParam('RETURN_VALUE');

    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end;
  except
    on e: Exception do begin
      CommonDataModule.Log(ClassName, 'IsWithwravalAllowed',
        '[EXCEPTION] On Execute FSQL.accIsWithdrawalAllowed: ' + e.Message +
        '; Params: SessionID=' + IntToStr(SessionID) +
        ', UserID=' + IntToStr(UserID) +
        ', CurrencyTypeID=' + IntToStr(CurrencyTypeID) +
        ', Amount=' + CurrToStr(Amount),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  end;

  case Result of
    1: Result := AC_ERR_WITHDRAWALFAILED_NOTONLINE;
    2: Result := AC_ERR_WITHDRAWALFAILED_WRONGUSERID;
    3: Result := AC_ERR_WITHDRAWALFAILED_CREDITCARDSNOTFOUND;
    4: Result := AC_ERR_WITHDRAWALFAILED_INSUFFICIENTFUNDS;
    5: Result := AC_ERR_WITHDRAWALFAILED_USERACCOUNTNOTFOUND;
  end;

  CommonDataModule.Log(ClassName, 'IsWithwravalAllowed',
    'Exit; Result=' + IntToStr(Result) +
      '; Params: SessionID=' + IntToStr(SessionID) +
      ', UserID=' + IntToStr(UserID) +
      ', CurrencyTypeID=' + IntToStr(CurrencyTypeID) +
      ', Amount=' + CurrToStr(Amount),
    ltCall
  );
end;

function TAccount.WithdrawalCC(Amount: Currency;
  CVV2, CardNumber, ExpMonth, ExpYear: string; CardTypeID, UserID: integer;
  var ResponseMsg, AuthCode: string; var PNRef: integer
): Integer;
var
  s, CardName: string;
  sAdress, sZip: string;
  aVSTransactionResult: TVSTransactionResult;
begin
  case CardTypeID of
    1: CardName := 'VI';
    2: CardName := 'MC';
    3: CardName := 'FP';
  else
    begin
      Result := AC_ERR_WRONGCREDITCARDTYPE;
      Exit;
    end;
  end;

  try
    if CardTypeID in [1,2] then begin
      { Get Adaress & Zip for VeriSign}
      Result := GetAdressAndZipForVSTransaction(UserID, sAdress, sZip);
      if Result <> 0 then Exit;
      aVSTransactionResult := DoVSTransaction('C', CVV2, CardNumber, ExpMonth, ExpYear, Amount, sAdress, sZip);
      ResponseMsg := aVSTransactionResult.RespMsg;
      AuthCode    := aVSTransactionResult.AuthCode;
      PNRef       := StrToIntDef(aVSTransactionResult.PNRef, 0);
      Result := aVSTransactionResult.Result;
    end else begin
      { Get string params FirePay}
      s := PrepareForFirePayParams('C', Amount, CardNumber, CardName, ExpMonth, ExpYear, UserID, PNRef);
      Result := MakeRequestFirePay(s, ResponseMsg, AuthCode);
    end;
  except
    on E: Exception do begin
      Result := 2;
    end;
  end;
end;

function TAccount.WithdrawalToCreditCard(UserID, CurrencyTypeID, CreditCardID: Integer;
  PNRef, ResponseMsg, AuthCode: string;
  Amount: Currency; var NewAmount: Currency
): Integer;
var
  FSql: TSQLAdapter;
begin
  Log('WithdrawalToCreditCard',
    'Entry; Params: UserID=' + IntToStr(UserID) +
      ', CurrencyTypeID=' + IntToStr(CurrencyTypeID) +
      ', CardID=' + IntToStr(CreditCardID) +
      ', Amount=' + CurrToStr(Amount),
    ltCall
  );

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // except
    try // finally
      FSql.SetProcName('accWithdrawalToCreditCard');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('UserID',UserID,ptInput);
      FSql.AddParInt('CurrencyTypeID',CurrencyTypeID,ptInput);
      FSql.AddParInt('CreditCardID',CreditCardID,ptInput);
      FSql.AddParString('PNRef',PNRef,ptInput);
      FSql.AddParString('ResponseMsg',ResponseMsg,ptInput);
      FSql.AddParString('AuthCode',AuthCode,ptInput);
      FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
      FSql.AddParam('NewAmount',NewAmount,ptOutput,ftCurrency);

      FSql.ExecuteCommand;

      Result    := FSql.GetParam('RETURN_VALUE');
      NewAmount := FSql.GetParam('NewAmount');

    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end;
  except
    on e: Exception do begin
      Log('WithdrawalToCreditCard', '[EXCEPTION] on Execute FSQL.accWithdrawalToCreditCard: ' + e.Message +
        '; Params: UserID = ' + IntToStr(UserID) +
        ' CurrencyTypeID = ' + IntToStr(CurrencyTypeID) +
        ' CardID = ' + IntToStr(CreditCardID) +
        ' Amount = ' + CurrToStr(Amount),
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  end;

  if Result = 2 then Result := AC_ERR_WITHDRAWALFAILED  // not enough money
  else if Result = 1 then Result := AC_ERR_NOACCOUNT;

  Log('WithdrawalToCreditCard',
    'Exit; Result=' + IntToStr(Result) + ', NewAmount=' + CurrToStr(NewAmount) +
    '; Params: UserID=' + IntToStr(UserID) + ', CardID=' + IntToStr(CreditCardID),
    ltCall
  );
end;

procedure TAccount.GetMailingAddressForWithdrawal(UserID: Integer;
  var sUserName, sUserInfo: string);
var
  FSql : TSQLAdapter;
  RS   : TDAtaSet;
begin
  sUserName := '';
  sUserInfo := '';

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try // Excp
    try // finally
      FSql.SetProcName('accGetMailingAddress');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParInt('UserID',UserID,ptInput);
      RS := FSql.ExecuteCommand;

      if not RS.Eof then begin
        sUserName := RS.FieldValues['Firstname'] + ' ' + RS.FieldValues['LastName'];
        sUserInfo := 'MAIL ADDRESS: <br>' +
          RS.FieldValues['Address1'] + ' ' + RS.FieldValues['Address2'] + ',<br>' +
          RS.FieldValues['City'] + ', ' + RS.FieldValues['Zip'] + ',<br>';
        if RS.FieldValues['Province'] = '' then begin
          sUserInfo := sUserInfo + RS.FieldValues['StateName'] + ',<br>';
        end else begin
          sUserInfo := sUserInfo + RS.FieldValues['Province'] + ',<br>';
        end;
        sUserInfo := sUserInfo +
          RS.FieldValues['CountryName'] + ',<br>';
        if RS.FieldValues['Phone'] = '' then begin
          sUserInfo := sUserInfo + 'PHONE: None';
        end else begin
          sUserInfo := sUserInfo +
            'PHONE: ' + RS.FieldValues['Phone'] + '<br>';
        end;
      end;

    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end;
  except
    on e : Exception do begin
      Log('GetMailingAddressForWithdrawal', '[EXCEPTION]: ' + e.Message + '; Params:' +
        ', UserID = ' + IntToStr(UserID),
        ltException
      );

      sUserName := '';
      sUserInfo := '';
    end;
  end;
end;

function TAccount.CalculateRakeEvent: Integer;
var
  FSql: TSQLAdapter;
begin
  CommonDataModule.Log(ClassName, 'CalculateRakeEvent', 'Entry: Calculate Rake Event was accured.', ltCall);

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accCalculateRakeEvent');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.ExecuteCommand;
    Result := FSql.GetParam('RETURN_VALUE');

    if (Result <> PO_NOERRORS) then begin
      CommonDataModule.Log(ClassName, 'CalculateRakeEvent',
        '[ERROR] On execute accCalculateRakeEvent: Error code=' + IntToStr(Result),
        ltError
      );

      Exit;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  Result := PO_NOERRORS;

  CommonDataModule.Log(ClassName, 'CalculateRakeEvent', 'Exit: All right.', ltCall);
end;

function TAccount.UserGroupsAllocationEvent: Integer;
var
  FSql: TSQLAdapter;
begin
  CommonDataModule.Log(ClassName, 'UserGroupsAllocationEvent',
    'Entry: User Groups Allocation Event was accured.', ltCall);

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accUserGroupsAllocationEvent');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.ExecuteCommand;
    Result := FSql.GetParam('RETURN_VALUE');

    if (Result <> PO_NOERRORS) then begin
      CommonDataModule.Log(ClassName, 'UserGroupsAllocationEvent',
        '[ERROR] On execute accUserGroupsAllocationEvent: Error code=' + IntToStr(Result),
        ltError
      );

      Exit;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  Result := PO_NOERRORS;

  CommonDataModule.Log(ClassName, 'UserGroupsAllocationEvent', 'Exit: All right.', ltCall);
end;

function TAccount.ChangeBalance(nSessionID, nUserID, nCurrTypeID, nType, nCheatsUsed: Integer;
  nAmount: Currency; sReason: string): Integer;
var
  FSql: TSQLAdapter;
begin
  if (nAmount <> 0) and (nUserID > 0) then begin
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      FSql.SetProcName('accChangeBalance');
      FSql.AddParInt('RETURN_VALUE', 0, ptResult);
      FSql.AddParInt('UserID', nUserID, ptInput);
      FSql.AddParInt('CurrencyID', nCurrTypeID, ptInput);
      FSql.AddParInt('TypeNumber', nType, ptInput);
      FSql.AddParInt('SparkleCheats', nCheatsUsed, ptInput);
      FSql.AddParam('Amount', nAmount, ptInput, ftCurrency);
      FSql.AddParString('Comment', sReason, ptInput);

      FSql.ExecuteCommand;

      Result := FSql.GetParam('RETURN_VALUE');

    except
      on e : Exception do begin
        Log( 'ChangeBalance',
          '[EXCEPTION] On exec accChangeBalance: ' + e.Message + '; Rarams: ' +
          'UserID=' + IntToStr(nUserID) + '; CurrTypeD=' + IntToStr(nCurrTypeID) +
          '; Type=' + IntToStr(nType) + '; Amount=' + CurrToStr(nAmount),
          ltException
        );

        Result      := AC_ERR_SQLCOMMANDERROR;
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

        GetBalanceInfo(nSessionID, nUserID);
        Exit;
      end;
    end;
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end else begin
    Result := AC_ERR_WRONGREQUEST;

    Log('ChangeBalance',
      '[ERROR] Parameters is incorrect: ' +
      'UserID=' + IntToStr(nUserID) + '; CurrTypeD=' + IntToStr(nCurrTypeID) +
      '; Type=' + IntToStr(nType) + '; Amount=' + CurrToStr(nAmount),
      ltError
    );
  end;

  GetBalanceInfo(nSessionID, nUserID);
end;

function TAccount.HandBet(UserID, GameProcessID: integer; Amount: Currency;
  TxDocID, HandID: integer; const Comment: String): integer;
var
  FSql: TSQLAdapter;
begin
  Log('HandBet', 'Entry; Params:' +
    ' UserID = ' + IntToStr(UserID) +
    ', GameProcessID = ' + IntToStr(GameProcessID) +
    ', Amount = ' + CurrToStr(Amount) +
    ', txDocID = ' + IntToStr(txDocID) +
    ', HandID = ' + IntToStr(HandID) +
    ', Comments = ' + Comment,
    ltCall
  );

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('accHandBet');
    FSql.AddParInt('RETURN_VALUE',0,ptResult);
    FSql.AddParInt('UserID',UserID,ptInput);
    FSql.AddParInt('GameProcessID',GameProcessID,ptInput);
    FSql.AddParam('Amount',Amount,ptInput,ftCurrency);
    FSql.AddParInt('txDocID',TxDocID,ptInput);
    FSql.AddParInt('HandID',HandID,ptInput);
    FSql.AddParString('Comment',Comment,ptInput);

    FSql.ExecuteCommand;

    Result := FSql.GetParam('RETURN_VALUE');

  except
    on e : Exception do begin
      Log('HandBet', '[EXCEPTION]: ' + e.Message + '; Params:' +
        ' UserID = ' + IntToStr(UserID) +
        ', GameProcessID = ' + IntToStr(GameProcessID) +
        ', Amount = ' + CurrToStr(Amount) +
        ', txDocID = ' + IntToStr(txDocID) +
        ', handID = ' + IntToStr(HandID) +
        ', Comments = ' + Comment,
        ltException
      );

      Result      := AC_ERR_SQLCOMMANDERROR;
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  if Result <> 0 then
    Log('HandBet', '[ERROR] accHandBet SQL ERROR=' + IntToStr(Result) + '; Params:' +
      ' UserID = ' + IntToStr(UserID) +
      ', GameProcessID = ' + IntToStr(GameProcessID) +
      ', Amount = ' + CurrToStr(Amount) +
      ', txDocID = ' + IntToStr(txDocID) +
      ', handID = ' + IntToStr(HandID) +
      ', Comments = ' + Comment,
      ltError
    );

  if Result = 1 then Result := AC_ERR_GAMEPROCESSNOTFOUND
  else if Result = 2 then Result := AC_ERR_NOACCOUNT;
//  GetBalanceInfo(0,UserID);
end;

function TAccount.SaveUserLastHand(UserID, GameProcessID, HandID: integer): integer;
var
  errCode: Integer;
  FSql: TSQLAdapter;
begin
  Result := 0;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiSaveUserLastHands');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('UserID', UserID,ptInput,ftInteger);
    FSql.addparam('ProcessID', GameProcessID,ptInput,ftInteger);
    FSql.addparam('GameLogID', HandID,ptInput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'LastHand',
        '[ERROR] On exec apiSaveUserLastHands Result=' + IntToStr(errCode) +
        '; Params: HandID=' + IntToStr(HandID) + '; UserID=' + IntToStr(UserID) + '; ProcessID' + IntToStr(GameProcessID),
        ltError
      );
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;
end;

procedure TAccount.AddMoneyFromPromoCard(CardID: string; UserID, SessionID: Integer);
var
  FSql: TSQLAdapter;
  nRes: Integer;
  Amount: Currency;
  sResponse, sReason: string;
begin
  sReason := '';
  Amount := 0;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    try
      FSql.SetProcName('accMovePromoCardToAccount');
      FSql.AddParInt('RETURN_VALUE',0,ptResult);
      FSql.AddParam('CardID', CardID, ptInput, ftString);
      FSql.AddParInt('UserID', UserID, ptInput);
      FSql.AddParam('Amount', Amount, ptOutput, ftCurrency);

      FSql.ExecuteCommand;

      nRes := FSql.GetParam('RETURN_VALUE');
      if (nRes <> 0) then begin
        CommonDataModule.Log(ClassName, 'AddMoneyFromPromoCard',
          '[ERROR] on exec accMovePromoCardToAccount: Result=' + IntToStr(nRes) +
            '; Params: CardID=' + CardID +
            ', UserID=' + IntToStr(UserID),
          ltError);
        case nRes of
          1:
          begin
            nRes := AC_ERR_PROMOCARD_NOTFOUNT;
            sReason := sAC_ERR_PROMOCARD_NOTFOUNT;
          end;
          2:
          begin
            nRes := AC_ERR_NOACCOUNT;
            sReason := sAC_ERR_NOACCOUNT;
          end;
          3:
          begin
            nRes := AC_ERR_PROMOCARD_USED;
            sReason := sAC_ERR_PROMOCARD_USED;
          end;
        end;
        Amount := 0;
      end else begin
        Amount := FSql.GetParam('Amount');
      end;
    except
      on e: Exception do begin
        CommonDataModule.Log(ClassName, 'AddMoneyFromPromoCard',
          '[EXCEPTION] on exec accMovePromoCardToAccount: ' + e.Message +
            '; Params: CardID=' + CardID +
            ', UserID=' + IntToStr(UserID),
          ltException);

        Amount := 0;
        nRes := AC_ERR_SQLCOMMANDERROR;
        sReason := sAC_ERR_SQLCOMMANDERROR;
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  sResponse :=
    '<object name="cashier">' +
      '<' + AO_PromoCards + ' result="' + IntToStr(nRes) + '" ' +
        'reason="' + sReason + '" ' +
        'cardid="' + CardID + '" ' +
        'amount="' + CurrToStr(Amount) + '" ' +
      '/>' +
    '</object>';

  if SessionID > 0 then
    CommonDataModule.NotifyUser(SessionID, sResponse)
  else
    CommonDataModule.NotifyUserByID(UserID, sResponse);

  if (nRes = 0) then GetBalanceInfo(SessionID, UserID);
end;

{ TCreditCard }

procedure TCreditCard.SetAmountDeposited(const Value: Currency);
begin
  FAmountDeposited := Value;
end;

procedure TCreditCard.SetCardNumber(const Value: string);
begin
  FCardNumber := Value;
end;

procedure TCreditCard.SetCardTypeID(const Value: Integer);
begin
  FCardTypeID := Value;
end;

procedure TCreditCard.SetCVV2(const Value: string);
begin
  FCVV2 := Value;
end;

procedure TCreditCard.SetExpirationMonth(const Value: Integer);
begin
  FExpirationMonth := Value;
end;

procedure TCreditCard.SetExpirationYear(const Value: Integer);
begin
  FExpirationYear := Value;
end;

procedure TCreditCard.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TCreditCard.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

{ TCreditCardList }

function TCreditCardList.Add(nAmountDeposited: Currency; nCardTypeID,
  nUserID, nExpirationMonth, nExpirationYear, nID: Integer;
  sCVV2, sCardNumber: string): TCreditCard;
begin
  Result := TCreditCard.Create;

  Result.FAmountDeposited := nAmountDeposited;
  Result.FCardTypeID := nCardTypeID;
  Result.FUserID := nUserID;
  Result.FExpirationMonth := nExpirationMonth;
  Result.FExpirationYear := nExpirationYear;
  Result.FID := nID;
  Result.FCardNumber := sCardNumber;
  Result.FCVV2 := sCVV2;

  inherited Add(Result);
end;

function TCreditCardList.GetCards(nIndex: Integer): TCreditCard;
begin
	Result := Items[nIndex] as TCreditCard;
end;

end.
