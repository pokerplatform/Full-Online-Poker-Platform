unit uLogReader;

interface

uses Classes, Contnrs, Graphics
  , uLogger
  ;

const
  Delimeter = '|';
  LR_ColorBase = clWindowText;
  LR_ColorCall = clWindowText;
  LR_ColorRqst = clGreen;
  LR_ColorRsps = clTeal;
  LR_ColorErrr = clOlive;
  LR_ColorExct = clRed;

type

  TLogItem = class
  private
    FAppName: string;
    FLogType: TLogType;
    FClassItem: string;
    FMethodItem: string;
    FTime: TDateTime;
    FBody: TStringList;
    FVisible: Boolean;
    FInd: Integer;
    FColor: TColor;
    procedure SetAppName(const Value: string);
    procedure SetClassItem(const Value: string);
    procedure SetMethodItem(const Value: string);
    procedure SetTime(const Value: TDateTime);
    procedure SetLogType(const Value: TLogType);
    procedure SetVisible(const Value: Boolean);
    function GetTypeName: string;
    procedure SetColor(const Value: TColor);
    //
    function GetLogTypeByName(const Value: string): TLogType;
    procedure FillEmptyValues;
    procedure SetDefoultColor;
    //
    procedure LoadFromString(sData: string);
    procedure LoadFromItem(aItem: TLogItem);
  public
    property LogType: TLogType read FLogType write SetLogType;
    property Time: TDateTime read FTime write SetTime;
    property AppName: string read FAppName write SetAppName;
    property ClassItem: string read FClassItem write SetClassItem;
    property MethodItem: string read FMethodItem write SetMethodItem;
    property Body: TStringList read FBody;
    property Color: TColor read FColor write SetColor;
    // read only properties
    property TypeName: string read GetTypeName;
    property Ind: Integer read FInd;
    property Visible: Boolean read FVisible write SetVisible;
    //
    constructor Create;
    destructor Destroy; override;
  end;

  TLogItemList = class(TObjectList)
  private
    function GetItem(nIndex: Integer): TLogItem;
  public
    property Items[nIndex: Integer]: TLogItem read GetItem;
    //
    procedure Del(Item: TLogItem);
    function Add: TLogItem;
    // sorting methods
    procedure SortByTime(Ascending: Boolean = True);
    procedure SortByLogType(Ascending: Boolean = True);
    procedure SortByAppName(Ascending: Boolean = True);
    procedure SortByClassName(Ascending: Boolean = True);
    procedure SortByMethodName(Ascending: Boolean = True);
    //
    destructor Destroy; override;
  end;

  TLogReader = class
  private
    FLogList: TLogItemList;
    //
    FFiles: TStringList;
    FLogTypeFilters: TStringList;
    FAppNameFilters: TStringList;
    FClassItemFilters: TStringList;
    FMethodItemFilters: TStringList;
    FWordFilters: TStringList;
    FWordFiltersExclude: TStringList;
    FTimeBeginFilter: TDateTime;
    FTimeEndFilter: TDateTime;
    FLinkWordsExcludeByAND: Boolean;
    FLinkWordsByAND: Boolean;
    procedure SetTimeBeginFilter(const Value: TDateTime);
    procedure SetTimeEndFilter(const Value: TDateTime);
    function GetCountVisible: Integer;
    function GetCount: Integer;
    //
    function GetSourceLine(sLines: TStringList): string;
    procedure AutoFillingFilters;
    function LogTypeFiltersExist(Value: string): Boolean;
    function AppNameFiltersExist(Value: string): Boolean;
    function ClassItemFiltersExist(Value: string): Boolean;
    function MethodItemFiltersExist(Value: string): Boolean;
    function AnyWordFilter(aWordFilter: TStringList; bLinkByAND: Boolean; aLogItem: TLogItem): Boolean;
    function WordFilterInclude(aLogItem: TLogItem): Boolean;
    function WordFilterExclude(aLogItem: TLogItem): Boolean;
    procedure SetLinkWordsByAND(const Value: Boolean);
    procedure SetLinkWordsExcludeByAND(const Value: Boolean);
  public
    property TimeBeginFilter: TDateTime read FTimeBeginFilter write SetTimeBeginFilter;
    property TimeEndFilter: TDateTime read FTimeEndFilter write SetTimeEndFilter;
    // read only properties
    property LogList: TLogItemList read FLogList;
    property Files: TStringList read FFiles;
    property LogTypeFilters: TStringList read FLogTypeFilters;
    property AppNameFilters: TStringList read FAppNameFilters;
    property ClassItemFilters: TStringList read FClassItemFilters;
    property MethodItemFilters: TStringList read FMethodItemFilters;
    property WordFilters: TStringList read FWordFilters;
    property LinkWordsByAND: Boolean read FLinkWordsByAND write SetLinkWordsByAND;
    property WordFiltersExclude: TStringList read FWordFiltersExclude;
    property LinkWordsExcludeByAND: Boolean read FLinkWordsExcludeByAND write SetLinkWordsExcludeByAND;
    property CountVisible: Integer read GetCountVisible;
    property Count: Integer read GetCount;
    // methods
    procedure Load;
    function FileExist(Value: string): Boolean;
    procedure Refresh;
    procedure ShowAll;
    // constructor & destructor
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses StrUtils, SysUtils, DateUtils, Math;

{ TLogItem }

constructor TLogItem.Create;
begin
  inherited Create;
  FBody := TStringList.Create;
  FillEmptyValues;
  FInd := -1;
  FColor := clWindowText;
end;

destructor TLogItem.Destroy;
begin
  FBody.Free;
  inherited;
end;

procedure TLogItem.LoadFromString(sData: string);
var
  sBuffData: string;
  sStr: string;

  function GetNextText(var sText: string): string;
  var
    nPosDlmt: Integer;
  begin
    nPosDlmt := Pos(Delimeter, sText);
    if nPosDlmt <= 0 then begin
      Result := sText;
      sText  := '';
      Exit;
    end;

    Result := Trim( Copy(sText, 1, nPosDlmt-1) );
    sBuffData := Copy(sText, nPosDlmt+1, Length(sText));
  end;

begin
  sBuffData := sData;
  sStr := GetNextText(sBuffData);
  if sStr = '' then begin
    FillEmptyValues;
    Exit;
  end;

  FLogType    := GetLogTypeByName( sStr );
  FTime       := StrToDateTimeDef(GetNextText(sBuffData), 0);
  FAppName    := GetNextText(sBuffData);
  FAppName    := IfThen(Trim(FAppName) = '', 'nil', FAppName);
  FClassItem  := GetNextText(sBuffData);
  FClassItem  := IfThen(Trim(FClassItem) = '', 'nil', FClassItem);
  FMethodItem := GetNextText(sBuffData);
  FMethodItem := IfThen(Trim(FMethodItem) = '', 'nil', FMethodItem);
  sStr := GetNextText(sBuffData);
  FBody.Text  := sStr;

  SetDefoultColor;
end;

procedure TLogItem.SetAppName(const Value: string);
begin
  FAppName := Value;
end;

procedure TLogItem.SetClassItem(const Value: string);
begin
  FClassItem := Value;
end;

procedure TLogItem.SetMethodItem(const Value: string);
begin
  FMethodItem := Value;
end;

procedure TLogItem.SetTime(const Value: TDateTime);
begin
  FTime := Value;
end;

procedure TLogItem.SetLogType(const Value: TLogType);
begin
  FLogType := Value;
end;

procedure TLogItem.LoadFromItem(aItem: TLogItem);
begin
  if aItem = nil then Exit;

  FAppName    := aItem.FAppName;
  FLogType    := aItem.FLogType;
  FClassItem  := aItem.FClassItem;
  FMethodItem := aItem.FMethodItem;
  FTime       := aItem.FTime;
  FBody.Text  := aItem.FBody.Text;
  FColor      := aItem.FColor;
end;

procedure TLogItem.FillEmptyValues;
begin
  FAppName    := '';
  FLogType    := ltBase;
  FClassItem  := '';
  FMethodItem := '';
  FTime       := 0;
  FBody.Clear;
  FVisible    := True;

  SetDefoultColor;
end;

function TLogItem.GetLogTypeByName(const Value: string): TLogType;
begin
  if Value = 'Base' then Result := ltBase else
  if Value = 'Call' then Result := ltCall else
  if Value = 'Rqst' then Result := ltRequest else
  if Value = 'Resp' then Result := ltResponse else
  if Value = 'Eror' then Result := ltError else
  if Value = 'Exct' then Result := ltException else
    Result := ltBase;
end;

function TLogItem.GetTypeName: string;
begin
  case FLogType of
    ltBase     : Result := 'Base';
    ltCall     : Result := 'Call';
    ltRequest  : Result := 'Request';
    ltResponse : Result := 'Response';
    ltError    : Result := 'Error';
    ltException: Result := 'Exception';
  else
    Result := 'None';
  end;
end;

procedure TLogItem.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

procedure TLogItem.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TLogItem.SetDefoultColor;
begin
  case FLogType of
    ltBase: FColor := LR_ColorBase;
    ltCall: FColor := LR_ColorCall;
    ltRequest: FColor := LR_ColorRqst;
    ltResponse: FColor := LR_ColorRsps;
    ltError: FColor := LR_ColorErrr;
    ltException: FColor := LR_ColorExct;
  else
    FColor := clBlue;
  end
end;

{ TLogItemList }

function TLogItemList.Add: TLogItem;
begin
  Result := TLogItem.Create;
  Result.FInd := inherited Add(Result);
end;

procedure TLogItemList.Del(Item: TLogItem);
begin
  inherited Remove(Item);
end;

destructor TLogItemList.Destroy;
begin
  Clear;
  inherited;
end;

function TLogItemList.GetItem(nIndex: Integer): TLogItem;
begin
  Result := TLogItem(inherited Items[nIndex]);
end;

procedure TLogItemList.SortByAppName(Ascending: Boolean);
var
  TopInd: Integer;
  I, J: Integer;
  aObj: TLogItem;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aObj := Items[J];

      if Ascending then begin
        if  (Items[TopInd].FAppName > aObj.FAppName) or
           ((Items[TopInd].FAppName = aObj.FAppName) and (Items[TopInd].FInd > aObj.FInd))
        then TopInd := IndexOf(aObj);
      end else begin
        if  (Items[TopInd].FAppName < aObj.FAppName) or
           ((Items[TopInd].FAppName = aObj.FAppName) and (Items[TopInd].FInd < aObj.FInd))
        then TopInd := IndexOf(aObj);
      end;
    end;

    // swap indexes
    aObj := TLogItem.Create;
    aObj.LoadFromItem(Items[TopInd]);
    Items[TopInd].LoadFromItem(Items[I]);
    Items[I].LoadFromItem(aObj);
    aObj.Free;
  end;
end;

procedure TLogItemList.SortByClassName(Ascending: Boolean);
var
  TopInd: Integer;
  I, J: Integer;
  aObj: TLogItem;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aObj := Items[J];

      if Ascending then begin
        if  (Items[TopInd].FClassItem > aObj.FClassItem) or
           ((Items[TopInd].FClassItem = aObj.FClassItem) and (Items[TopInd].FInd > aObj.FInd))
        then TopInd := IndexOf(aObj);
      end else begin
        if  (Items[TopInd].FClassItem < aObj.FClassItem) or
           ((Items[TopInd].FClassItem = aObj.FClassItem) and (Items[TopInd].FInd < aObj.FInd))
        then TopInd := IndexOf(aObj);
      end;
    end;

    // swap indexes
    aObj := TLogItem.Create;
    aObj.LoadFromItem(Items[TopInd]);
    Items[TopInd].LoadFromItem(Items[I]);
    Items[I].LoadFromItem(aObj);
    aObj.Free;
  end;
end;

procedure TLogItemList.SortByLogType(Ascending: Boolean);
var
  TopInd: Integer;
  I, J: Integer;
  aObj: TLogItem;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aObj := Items[J];

      if Ascending then begin
        if  (Items[TopInd].FLogType > aObj.FLogType) or
           ((Items[TopInd].FLogType = aObj.FLogType) and (Items[TopInd].FInd > aObj.FInd))
        then TopInd := IndexOf(aObj);
      end else begin
        if  (Items[TopInd].FLogType < aObj.FLogType) or
           ((Items[TopInd].FLogType = aObj.FLogType) and (Items[TopInd].FInd < aObj.FInd))
        then TopInd := IndexOf(aObj);
      end;
    end;

    // swap indexes
    aObj := TLogItem.Create;
    aObj.LoadFromItem(Items[TopInd]);
    Items[TopInd].LoadFromItem(Items[I]);
    Items[I].LoadFromItem(aObj);
    aObj.Free;
  end;
end;

procedure TLogItemList.SortByMethodName(Ascending: Boolean);
var
  TopInd: Integer;
  I, J: Integer;
  aObj: TLogItem;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aObj := Items[J];

      if Ascending then begin
        if  (Items[TopInd].FMethodItem > aObj.FMethodItem) or
           ((Items[TopInd].FMethodItem = aObj.FMethodItem) and (Items[TopInd].FInd > aObj.FInd))
        then TopInd := IndexOf(aObj);
      end else begin
        if  (Items[TopInd].FMethodItem < aObj.FMethodItem) or
           ((Items[TopInd].FMethodItem = aObj.FMethodItem) and (Items[TopInd].FInd < aObj.FInd))
        then TopInd := IndexOf(aObj);
      end;
    end;

    // swap indexes
    aObj := TLogItem.Create;
    aObj.LoadFromItem(Items[TopInd]);
    Items[TopInd].LoadFromItem(Items[I]);
    Items[I].LoadFromItem(aObj);
    aObj.Free;
  end;
end;

procedure TLogItemList.SortByTime(Ascending: Boolean);
var
  TopInd: Integer;
  I, J: Integer;
  aObj: TLogItem;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aObj := Items[J];

      if Ascending then begin
        if  (Items[TopInd].FTime > aObj.FTime) or
           ((Items[TopInd].FTime = aObj.FTime) and (Items[TopInd].FInd > aObj.FInd))
        then TopInd := IndexOf(aObj);
      end else begin
        if  (Items[TopInd].FTime < aObj.FTime) or
           ((Items[TopInd].FTime = aObj.FTime) and (Items[TopInd].FInd < aObj.FInd))
        then TopInd := IndexOf(aObj);
      end;
    end;

    // swap indexes
    aObj := TLogItem.Create;
    aObj.LoadFromItem(Items[TopInd]);
    Items[TopInd].LoadFromItem(Items[I]);
    Items[I].LoadFromItem(aObj);
    aObj.Free;
  end;
end;

{ TLogReader }

function TLogReader.AppNameFiltersExist(Value: string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I:=0 to FAppNameFilters.Count - 1 do begin
    if Trim(Value) = FAppNameFilters.Strings[I] then begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TLogReader.AutoFillingFilters;
var
  I: Integer;
  aLogItem: TLogItem;
begin
  for I:=0 to FLogList.Count - 1 do begin
    aLogItem := FLogList.Items[I];
    if not LogTypeFiltersExist(aLogItem.GetTypeName)  then
      FLogTypeFilters.Add(aLogItem.GetTypeName);
    if not AppNameFiltersExist(aLogItem.FAppName)     then
      FAppNameFilters.Add(aLogItem.FAppName);
    if not ClassItemFiltersExist(aLogItem.FClassItem) then
      FClassItemFilters.Add(aLogItem.FClassItem);
    if not MethodItemFiltersExist(aLogItem.FMethodItem) then
      FMethodItemFilters.Add(aLogItem.FMethodItem);
  end;
end;

function TLogReader.ClassItemFiltersExist(Value: string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I:=0 to FClassItemFilters.Count - 1 do begin
    if Trim(Value) = FClassItemFilters.Strings[I] then begin
      Result := True;
      Exit;
    end;
  end;
end;

constructor TLogReader.Create;
begin
  inherited Create;

  FLogList := TLogItemList.Create;
  //
  FFiles             := TStringList.Create;
  FLogTypeFilters    := TStringList.Create;
  FAppNameFilters    := TStringList.Create;
  FClassItemFilters  := TStringList.Create;
  FMethodItemFilters := TStringList.Create;
  FWordFilters       := TStringList.Create;
  FWordFiltersExclude := TStringList.Create;

  FLinkWordsByAND        := True;
  FLinkWordsExcludeByAND := False;

  FTimeBeginFilter   := 0;
  FTimeEndFilter     := 0;
end;

destructor TLogReader.Destroy;
begin
  FLogList.Free;
  //
  FFiles.Free;
  FLogTypeFilters.Free;
  FAppNameFilters.Free;
  FClassItemFilters.Free;
  FMethodItemFilters.Free;
  FWordFilters.Free;
  FWordFiltersExclude.Free;

  inherited;
end;

function TLogReader.FileExist(Value: string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I:=0 to FFiles.Count - 1 do begin
    if Trim(Value) = FFiles.Strings[I] then begin
      Result := True;
      Exit;
    end;
  end;
end;

function TLogReader.GetCount: Integer;
begin
  Result := FLogList.Count;
end;

function TLogReader.GetCountVisible: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to LogList.Count - 1 do begin
    if LogList.Items[I].Visible then Inc(Result);
  end;
end;

function TLogReader.GetSourceLine(sLines: TStringList): string;
const
  arrTypeNames: array [0..6] of string =
    ('Base', 'Call', 'Rqst', 'Resp', 'Eror', 'Exct', 'None');
var
  I: Integer;
  sStr: string;
  FirstInd, NextInd: Integer;
  aResList: TStringList;

  function ValidateStr(sStr: string): Boolean;
  var
    Cnt: Integer;
  begin
    for Cnt := 0 to 6 do begin
      Result := (sStr = arrTypeNames[Cnt]);
      if Result then Exit;
    end;
  end;

begin
//*************************************
// WARNING:
// function delete uses items of sLines
// sLines.Count after execute will be decremented
//*************************************

  aResList := TStringList.Create;

  FirstInd := -1;
  NextInd  := -1;
  for I:=0 to sLines.Count - 1 do begin
    sStr := Copy(sLines.Strings[I], 1, 4);
    if NOT ValidateStr(sStr) then Continue;

    if FirstInd >= 0 then NextInd := I else FirstInd := I;
    if (FirstInd >= 0) and (NextInd > 0) then Break;
  end;

  if (FirstInd >= 0) and (NextInd > 0) then begin
    // on part of corrupted sLines - decrement of count
    for I:=0 to FirstInd - 1 do begin
      sLines.Delete(I);
      Dec(FirstInd);
      Dec(NextInd);
    end;

    for I:=FirstInd to NextInd - 1 do begin
      aResList.Add(sLines.Strings[I]);
    end;

    // decrement of count
    for I:=FirstInd to NextInd - 1 do begin
      sLines.Delete(0);
    end;
  end else begin
    sLines.Clear;
  end;

  Result := aResList.Text;

  aResList.Free;
end;

procedure TLogReader.Load;
const
  MaxBuff = 65535;

type
  TCharBuffer = array [1..MaxBuff] of char;

var
  I, nMin: Integer;
  nSize: Int64;
  ABuffList: TStringList;
  StrBuff,
  sStr, sFileName: string;
  sBuff: TCharBuffer;
  aFileStream: TFileStream;

  function ReadReplaceAndClearBuffer(Buff: TCharBuffer; CurrSize: Integer): string;
  var
    J: Integer;
  begin
    for J:=1 to CurrSize do if Buff[J] = #0 then Buff[J] := ' ';
    for J:=CurrSize + 1 to MaxBuff do Buff[J] := #0;
    Result := String(Buff);
  end;

begin
  if FFiles.Count <= 0 then Exit;

  FLogList.Clear;

  ABuffList := TStringList.Create;
  FFiles.Sort;
  // adding items to List from files
  for I:=0 to FFiles.Count - 1 do begin
    ABuffList.Clear;
    sFileName := FFiles.Strings[I];
    StrBuff := '';
    aFileStream := TFileStream.Create(sFileName, fmOpenRead);
    try
      nSize := aFileStream.Size;
      StrBuff := '';

      while (nSize > 0) do begin
        nMin := Min(MaxBuff, nSize);
        aFileStream.Read(sBuff, nMin);
        StrBuff := StrBuff + ReadReplaceAndClearBuffer(sBuff, nMin);
        nSize := nSize - nMin;
      end;
      ABuffList.Text := StrBuff;
    finally
      aFileStream.Free;
    end;
    if ABuffList.Text = '' then Continue;

    while ABuffList.Count > 0 do begin
      sStr := GetSourceLine(ABuffList);
      if sStr = '' then Break;
      FLogList.Add.LoadFromString(sStr);
    end;
  end;

  ABuffList.Clear;
  ABuffList.Free;

  if FLogList.Count > 0 then begin
    // filters
    FTimeBeginFilter := FLogList.Items[0].FTime;
    FTimeEndFilter   := IncSecond( FLogList.Items[FLogList.Count - 1].FTime, 1 );

    AutoFillingFilters;
  end;

end;

function TLogReader.LogTypeFiltersExist(Value: string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I:=0 to FLogTypeFilters.Count - 1 do begin
    if Trim(Value) = FLogTypeFilters.Strings[I] then begin
      Result := True;
      Exit;
    end;
  end;
end;

function TLogReader.MethodItemFiltersExist(Value: string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I:=0 to FMethodItemFilters.Count - 1 do begin
    if Trim(Value) = FMethodItemFilters.Strings[I] then begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TLogReader.Refresh;
var
  I: Integer;
  aItm: TLogItem;
  bOnExcludeWord: Boolean;
  bOnWord: Boolean;
begin
  for I:=0 to LogList.Count - 1 do begin
    aItm := LogList.Items[I];
    bOnWord := WordFilterInclude(aItm);
    bOnExcludeWord := WordFilterExclude(aItm);
      
    aItm.Visible := (
      LogTypeFiltersExist(aItm.GetTypeName) and
      AppNameFiltersExist(aItm.AppName) and
      ClassItemFiltersExist(aItm.FClassItem) and
      MethodItemFiltersExist(aItm.FMethodItem) and
      (FTimeBeginFilter <= aItm.FTime) and
      (FTimeEndFilter >=  aItm.FTime) and
      bOnWord and
      bOnExcludeWord
    );
  end;
end;

procedure TLogReader.SetLinkWordsByAND(const Value: Boolean);
begin
  FLinkWordsByAND := Value;
end;

procedure TLogReader.SetLinkWordsExcludeByAND(const Value: Boolean);
begin
  FLinkWordsExcludeByAND := Value;
end;

procedure TLogReader.SetTimeBeginFilter(const Value: TDateTime);
begin
  FTimeBeginFilter := Value;
end;

procedure TLogReader.SetTimeEndFilter(const Value: TDateTime);
begin
  FTimeEndFilter := Value;
end;

procedure TLogReader.ShowAll;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do begin
    FLogList.Items[I].Visible := True;
  end;
end;

function TLogReader.WordFilterInclude(aLogItem: TLogItem): Boolean;
var
  aWordFilter: TStringList;
begin
  Result := True;
  aWordFilter := FWordFilters;
  if aWordFilter.Count <= 0 then begin
    //filter disabled
    Exit;
  end;

  Result := AnyWordFilter(aWordFilter, FLinkWordsByAND, aLogItem);
end;

function TLogReader.WordFilterExclude(aLogItem: TLogItem): Boolean;
var
  aWordFilter: TStringList;
begin
  Result := True;
  aWordFilter := FWordFiltersExclude;
  if aWordFilter.Count <= 0 then begin
    //filter disabled
    Exit;
  end;

  Result := not AnyWordFilter(aWordFilter, FLinkWordsExcludeByAND, aLogItem);
end;

function TLogReader.AnyWordFilter(aWordFilter: TStringList;
  bLinkByAND: Boolean; aLogItem: TLogItem): Boolean;
var
  I: Integer;
begin
  Result := bLinkByAND;
  for I:=0 to aWordFilter.Count - 1 do begin
    if Pos( AnsiLowerCase(Trim(aWordFilter.Strings[I])), AnsiLowerCase(aLogItem.FBody.Text) ) > 0 then begin
      if bLinkByAND then begin
        Continue;
      end else begin
        Result := True;
        Exit;
      end;
    end else begin
      if bLinkByAND then begin
        Result := False;
        Exit;
      end else begin
        Continue;
      end;
    end;
  end;
end;

end.
