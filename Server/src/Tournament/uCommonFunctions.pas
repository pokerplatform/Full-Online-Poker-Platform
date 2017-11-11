unit uCommonFunctions;

interface

uses
  SysUtils, ComObj
//po
  , uGameConnector
  ;

function DateTimeToODBCStr(DT : TDateTime): string;
function ODBCStrToDateTimeDef(Value: string; Default: TDateTime): TDateTime;
//
procedure Log(ObjectName, ProcName, Msg: string);
procedure LogException( GUID, ObjectName, ProcName, Reason : string);
//
function GetDiffTime(dt: TDateTime): string;
function GetNextTimeEvent(EventTime : TDateTime) : string;
function GetStrBetweenDateTime(ANow, AThen: TDateTime): string;
function PlaceAsString(nPlace: Integer): string;
//
function CreateGameConnector(ClassName, sEngineName: string): TGameConnector;

implementation

uses DateUtils, StrUtils
//
  , uCommonDataModule
  , uLogger
  ;

function DateTimeToODBCStr(DT : TDateTime) : string;
begin
  if DT = 0 then
    Result := ''
  else
    DateTimeToString( Result, 'yyyy-mm-dd hh:nn:ss.zzz', DT);
end;

function ODBCStrToDateTimeDef(Value: string; Default: TDateTime): TDateTime;
var
  AYear,
  AMonth,
  ADay,
  AHour,
  AMinute,
  ASecond,
  AMilliSecond: Word;
  DatePart, TimePart: string;
  nPos: Integer;
begin
  // only use format ODBC: 'yyyy-mm-dd hh:mi:ss.mmm(24h)'

  Result := Default;
  if (Value = '') then Exit;

  nPos := Pos(' ', Value);
  DatePart := Copy(Value, 1, nPos - 1);
  TimePart := Copy(Value, nPos + 1, 12);

  try
    // date part
    nPos := Pos('-', DatePart);
    AYear := Word(StrToInt(Copy(DatePart, 1, nPos - 1)));
    DatePart := Copy(DatePart, nPos + 1, Length(DatePart));

    nPos := Pos('-', DatePart);
    AMonth := Word(StrToInt(Copy(DatePart, 1, nPos - 1)));
    ADay := Word(StrToInt(Copy(DatePart, nPos + 1, 2)));

    // time part
    nPos := Pos(':', TimePart);
    AHour := Word(StrToInt(Copy(TimePart, 1, nPos - 1)));
    TimePart := Copy(TimePart, nPos + 1, Length(TimePart));

    nPos := Pos(':', TimePart);
    AMinute := Word(StrToInt(Copy(TimePart, 1, nPos - 1)));
    TimePart := Copy(TimePart, nPos + 1, Length(TimePart));

    nPos := Pos('.', TimePart);
    ASecond :=  Word(StrToInt(Copy(TimePart, 1, nPos - 1)));
    AMilliSecond := Word(StrToInt(Copy(TimePart, nPos + 1, 3)));

    // Encode to TDateTime
    Result := EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);

  except on E: Exception do
    begin
      Result := Default;
      Exit;
    end;
  end;

end;

procedure Log(ObjectName, ProcName, Msg: string);
begin
  CommonDataModule.Log( ObjectName, ProcName, Msg, ltCall );
end;

procedure LogException(GUID, ObjectName, ProcName, Reason : string);
begin
  CommonDataModule.Log( ObjectName, ProcName, Reason + ' [' + GUID + ']', ltException );
end;

function GetDiffTime(dt: TDateTime): string;
var
  sb : int64;
  i  : integer;
begin
  sb := SecondsBetween(dt,Now());
  if dt < Now() then sb := 0;
  Result := 'in ';
  if sb < 60 then begin
    Result := Result + IntToStr(sb) + ' sec';
    Exit;
  end;

  sb := sb div 60;
  if sb < 60 then begin
    Result := Result + IntToStr(sb) + ' min';
    Exit;
  end;

  sb := sb div 60;
  if sb < 24 then begin
    Result := Result + IntToStr(sb) + ' hour';
    if sb > 1 then Result := Result + 's';
    Exit;
  end;

  i := sb div 24;
  Result := Result + IntToStr(i) + ' day';
  if i > 1 then Result := Result + 's';
  sb := sb - i*24;
  if sb >= 1 then begin
    Result := Result + ' ' + IntToStr(sb) + ' hour';
    if sb > 1 then Result := Result + 's';
  end;
end;

function GetNextTimeEvent(EventTime : TDateTime) : string;
var
  t : TDateTime;
  n : integer;
begin
  t := Now();
  Result := '';
  if EventTime < t then Exit;

  n := MinutesBetween(EventTime,t);
  if n > 0 then Result := IntToStr(n) + ' min'
  else begin
    n := SecondsBetween(EventTime,t);
    Result := IntToStr(n) + ' sec';
  end;
end;

function GetStrBetweenDateTime(ANow, AThen: TDateTime): string;
var
  SecCount, Num: Integer;

  function ToStr(Num: Integer; sContext: string; sRest: string = ''): string;
  begin
    Result := '';
    if Num <= 0 then Exit;

    Result := Result + IntToStr(Num) + ' ' + sContext;
    if Num > 1 then Result := Result + sRest;
  end;
begin
  Result := '';
  if ANow >= AThen then Exit;

  SecCount := SecondsBetween(ANow, AThen);
  // days part
  Num := SecCount div (24*60*60);
  if Num > 0 then Result := Result + ToStr(Num, 'day', 's');
  // Hours part
  SecCount := SecCount - (Num*24*60*60);
  Num := SecCount div (60*60);
  if Num > 0 then Result := Result + ' ' + ToStr(Num, 'hour', 's');
  // minutes part
  SecCount := SecCount - Num*60*60;
  Num := SecCount div (60);
  if Num > 0 then Result := Result + ' ' + ToStr(Num, 'min');
  // second part
  SecCount := SecCount - Num*60;
  Num := SecCount;
  if Num > 0 then Result := Result + ' ' + ToStr(Num, 'sec');
  Result := Trim(Result);
end;

function CreateGameConnector(ClassName, sEngineName: string): TGameConnector;
begin
  try
    Result := TGameConnector.Create;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'CreateGameConnector',
        '[EXCEPTION] on create game connector: ' + E.Message + '; Params: sEngineName=' + sEngineName,
        ltException
      );

      Result := nil;
    end;
  end;
end;

function PlaceAsString(nPlace: Integer): string;
begin
  Result := IntToStr(nPlace);
  case nPlace of
    1: Result := Result + 'st';
    2: Result := Result + 'nd';
    3: Result := Result + 'rd';
  else
    Result := Result + 'th';
  end;
end;

end.
