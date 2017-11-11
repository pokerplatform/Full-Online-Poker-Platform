unit uConversions;

interface

uses
  SysUtils, Math, uDataList, StrUtils,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uCommonDataModule, uBotConnection;

const
  CurrencyMaxDecimalPlaces = 4;

type
  TConversions = class(TObject)
  private
    FDefaultDateTimeFormatSettings: TFormatSettings;
    FAmericanDateTimeFormatSettings: TFormatSettings;

    FCurrencyList: TDataList;
    procedure Run_GetCurrencies(BotConnection: TBotConnection; XMLRoot: IXMLNode);
  public
    property CurrencyList: TDataList read FCurrencyList;

    constructor Create;
    destructor  Destroy; override;

    // Currency
    function Str2Cur (const Value: String): Currency;
    function Cur2Str(Value: Currency; CurrencyType: Integer = 1; DecPlaces: Integer = 2): String;

    // TDateTime
    function Str2DateTime(const Value: String): TDateTime;
    function American2DateTime(const Value: String): TDateTime;

    function DateTime2American(Value: TDateTime): String;
    function DateTime2ANSI(Value: TDateTime): String;

    function Date2American(Value: TDateTime): String;
    function Time2American(Value: TDateTime): String;

    function Date2ANSI(Value: TDateTime): String;
    function Time2ANSI(Value: TDateTime): String;

    procedure RunCommand(BotConnection: TBotConnection; XMLRoot: IXMLNode);
  end;

var
  Conversions: TConversions;

implementation

uses
   uLogger;

{ TConversions }

// Common

constructor TConversions.Create;
begin
  FCurrencyList := TDataList.Create(0, nil);

  FDefaultDateTimeFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  FDefaultDateTimeFormatSettings.ShortTimeFormat := 'hh:nn:ss.zzz';
  FDefaultDateTimeFormatSettings.LongDateFormat := 'yyyy-mm-dd';
  FDefaultDateTimeFormatSettings.LongTimeFormat := 'hh:nn:ss.zzz';
  FDefaultDateTimeFormatSettings.DateSeparator := '-';
  FDefaultDateTimeFormatSettings.TimeSeparator := ':';

  FAmericanDateTimeFormatSettings.ShortDateFormat := 'mm/dd/yyyy';
  FAmericanDateTimeFormatSettings.ShortTimeFormat := 'hh:nn ampm';
  FAmericanDateTimeFormatSettings.LongDateFormat := 'mm/dd/yyyy';
  FAmericanDateTimeFormatSettings.LongTimeFormat := 'hh:nn:ss ampm';
  FAmericanDateTimeFormatSettings.DateSeparator := '/';
  FAmericanDateTimeFormatSettings.TimeSeparator := ':';
  FAmericanDateTimeFormatSettings.TimeAMString  := 'AM';
  FAmericanDateTimeFormatSettings.TimePMString  := 'PM';
end;

destructor TConversions.Destroy;
begin
  FCurrencyList.Free;
end;


// Actions

procedure TConversions.RunCommand(BotConnection: TBotConnection; XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Log(BotConnection.BotID, ClassName, 'RunCommand', 'Started', ltCall);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := XMLNode.NodeName;

        if strNode = 'apgetcurrencies' then
          Run_GetCurrencies(BotConnection, XMLNode);
      end;

    strNode := '';
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'RunCommand', E.Message, ltException);
  end;
end;

procedure TConversions.Run_GetCurrencies(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="conversions">
  <apgetcurrencies result="0|...">
    <currency id="1" name="Play money" sign=""/>
    <currency id="2" name="Real dollars" sign="$"/>
    <currency id="3" name="Real hrivna" sign="H"/>
  </apgetcurrencies>
</object>
}
var
  ItemsCount: Integer;
  Loop: Integer;
  XMLNode: IXMLNode;
  curMoney: TDataList;
begin
  if CommonDataModule.CheckCommandResult(BotConnection, XMLRoot) then
  begin
    ItemsCount := XMLRoot.ChildNodes.Count;
    FCurrencyList.ClearItems(ItemsCount);
    for Loop := 0 to ItemsCount - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      curMoney := FCurrencyList.AddItem(XMLNode.Attributes['id'], Loop);
      curMoney.LoadFromXML(XMLNode);
    end;
  end;
end;


// Currency conversions

function TConversions.Str2Cur (const Value: String): Currency;
var
  strCur : String;
  strVal : String;
  strDec : String;
  Loop   : Integer;
  nPos   : Integer;

  nInt   : Integer;
  nDec   : Integer;

  strMaxDec: String;
  nMaxDec: Integer;
begin
  Result := 0;
  strMaxDec := '';
  nMaxDec := 1;
  for Loop := 1 to CurrencyMaxDecimalPlaces do
  begin
    strMaxDec := strMaxDec + '0';
    nMaxDec := nMaxDec * 10;
  end;

  if Value <> '' then
  try
    strCur := Value;
    nDec   := 0;
    strCur := StringReplace(strCur,',','.',[rfReplaceAll, rfIgnoreCase]);

    strVal := '';
    for Loop := 1 to length(strCur) do
      if ((strCur[Loop] >= '0') and (strCur[Loop] <= '9')) or
        (strCur[Loop] = '.') or (strCur[Loop] = '-') then
        strVal := strVal + strCur[Loop];

    nPos := pos('.', strVal);
    if nPos > 0 then
    begin
      nInt   := StrToIntDef(copy(strVal, 1, nPos-1), 0);
      strDec := copy(strVal + strMaxDec, nPos + 1, CurrencyMaxDecimalPlaces);

      if strDec <> '' then
        nDec := StrToIntDef(strDec, 0);
    end
    else
      nInt := StrToIntDef(strVal, 0);

    Result := nInt + nDec/nMaxDec;
    if (pos('-', Value) > 0) and (Result <> 0) then
      Result := - Result;

    strCur := '';
    strVal := '';
    strDec := '';
    strMaxDec := '';
  except
    on E: Exception do
      Logger.Log(0, ClassName, 'Str2Cur', E.Message, ltException);
  end;
end;

function TConversions.Cur2Str(Value: Currency; CurrencyType: Integer = 1; DecPlaces: Integer = 2): String;
Var
  nInt: Integer;
  nDec: Integer;
  nRnd: Integer;
  Loop: Integer;

  strCurDec: String;
  nCurDec: Int64;
  curMoney: TDataList;
begin
  Result := '';
  strCurDec := '0';
  nCurDec := 10;
  for Loop := 2 to DecPlaces do
  begin
    strCurDec := strCurDec + '0';
    nCurDec := nCurDec * 10;
  end;

  try
    nInt := round(int(abs(Value)*nCurDec));
    nRnd := round(int(abs(Value)*10*nCurDec)) - (nInt * 10);
    if nRnd >= 5 then
      nInt := nInt + 1;
    nDec := nInt mod nCurDec;
    nInt := nInt div nCurDec;

    if FCurrencyList.Find(CurrencyType, curMoney) then
      Result := curMoney.ValuesAsString['sign'];

    Result := Result + inttostr(nInt) + '.' + RightStr(strCurDec + inttostr(nDec), DecPlaces);

    if Value < 0 then
      Result := '-' + Result;

    strCurDec := '';
  except
    on E: Exception do
      Logger.Log(0, ClassName, 'Cur2Str', E.Message, ltException);
  end;
end;


// DateTime Conversions

function TConversions.Str2DateTime(const Value: String): TDateTime;
begin
  Result := StrToDateTimeDef(Value, 0, FDefaultDateTimeFormatSettings);
  if Result = 0 then
    Result := StrToDateTimeDef(Value, 0, FAmericanDateTimeFormatSettings);
  if Result = 0 then
    Result := StrToDateTimeDef(Value, 0);
end;

function TConversions.American2DateTime(const Value: String): TDateTime;
begin
  Result := StrToDateTimeDef(Value, 0, FAmericanDateTimeFormatSettings);
end;

function TConversions.DateTime2ANSI(Value: TDateTime): String;
begin
  Result := DateTimeToStr(Value, FDefaultDateTimeFormatSettings);
end;

function TConversions.DateTime2American(Value: TDateTime): String;
begin
  Result := DateTimeToStr(Value, FAmericanDateTimeFormatSettings);
end;

function TConversions.Date2American(Value: TDateTime): String;
begin
  Result := DateToStr(Value, FAmericanDateTimeFormatSettings);
end;

function TConversions.Time2American(Value: TDateTime): String;
begin
  Result := TimeToStr(Value, FAmericanDateTimeFormatSettings);
end;

function TConversions.Date2ANSI(Value: TDateTime): String;
begin
  Result := DateToStr(Value, FDefaultDateTimeFormatSettings);
end;

function TConversions.Time2ANSI(Value: TDateTime): String;
begin
  Result := TimeToStr(Value, FDefaultDateTimeFormatSettings);
end;

initialization
  Conversions := TConversions.Create;

finalization
  Conversions.Free;

end.
