unit uDataList;

interface

uses
  Forms, Variants, Classes, SysUtils, StrUtils,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uConstants;

type

  TDataList = class
  // General
  private
    FID: Integer;
    FParent: TDataList;
  public
    function ID: Integer;
    function Parent: TDataList;
    procedure Clear;

    constructor Create(AID: Integer; AParent: TDataList);
    destructor  Destroy; override;

  // Data
  private
    FName: String;
    FValue: Variant;

    FNames: array of String;
    FValues: array of Variant;

    function AddValueName(const ValueName: String): Integer;
    function FoundValueName(const ValueName: String; var Index: Integer): Boolean;

    function GetValueNames(Index: Integer): String;
    function GetValues(Index: Integer): Variant;

    procedure SetValueNames(Index: Integer; const Value: String);
    procedure SetValues(Index: Integer; const Value: Variant);

    function GetValuesAsBoolean(const ValueName: String): Boolean;
    function GetValuesAsCurrency(const ValueName: String): Currency;
    function GetValuesAsFloat(const ValueName: String): Double;
    function GetValuesAsInteger(const ValueName: String): Integer;
    function GetValuesAsString(const ValueName: String): String;
    function GetValuesAsTDateTime(const ValueName: String): TDateTime;

    procedure SetValuesAsBoolean(const ValueName: String; const Value: Boolean);
    procedure SetValuesAsCurrency(const ValueName: String; const Value: Currency);
    procedure SetValuesAsFloat(const ValueName: String; const Value: Double);
    procedure SetValuesAsInteger(const ValueName: String; const Value: Integer);
    procedure SetValuesAsString(const ValueName: String; const Value: String);
    procedure SetValuesAsTDateTime(const ValueName: String; const Value: TDateTime);
  public
    property Name: String read FName write FName;
    property Value: Variant read FValue write FValue;

    function ValueCount: Integer;
    property ValueNames[Index: Integer]: String read GetValueNames write SetValueNames;
    property Values[Index: Integer]: Variant read GetValues write SetValues;

    property ValuesAsString[const ValueName: String]: String read GetValuesAsString write SetValuesAsString;
    property ValuesAsInteger[const ValueName: String]: Integer read GetValuesAsInteger write SetValuesAsInteger;
    property ValuesAsBoolean[const ValueName: String]: Boolean read GetValuesAsBoolean write SetValuesAsBoolean;
    property ValuesAsFloat[const ValueName: String]: Double read GetValuesAsFloat write SetValuesAsFloat;
    property ValuesAsCurrency[const ValueName: String]: Currency read GetValuesAsCurrency write SetValuesAsCurrency;
    property ValuesAsTDateTime[const ValueName: String]: TDateTime read GetValuesAsTDateTime write SetValuesAsTDateTime;

    procedure ClearData(NewCount: Integer);

    procedure LoadFromXML(ValuesNode: IXMLNode; ProcessItemsRecursive: Boolean = false);
    procedure SaveToXML(ValuesNode: IXMLNode; ProcessItemsRecursive: Boolean = false);
    procedure LoadFromFile(FileName: String);
    procedure SaveToFile(FileName, RootNodeName: String);

  // Items
  private
    FItems: array of TDataList;
    function FindItem(AID: Integer; var Index: Integer): Boolean;
  public
    function Count: Integer;
    function Items(Index: Integer): TDataList;
    function Add(AID: Integer): TDataList;
    function Clone(Original: TDataList; NewID: Integer = 0): TDataList;
    function Find(AID: Integer; var DataList: TDataList): Boolean;

    procedure Delete(Index: Integer);
    procedure Remove(AID: Integer);

    procedure ClearItems(NewCount: Integer);
    function  AddItem(AID, Index: Integer): TDataList;

    procedure SortItems(const ValueName: String;
      Ascending, IsNumber: Boolean;
      IndexFrom, IndexTo: Integer); overload;

    procedure SortItems(const ValueName: String;
      Ascending: Boolean = true; IsNumber: Boolean = false); overload;
  end;


implementation

uses
  uConversions;

{ TDataList }


// General

constructor TDataList.Create(AID: Integer; AParent: TDataList);
begin
  FID := AID;
  FParent := AParent;
  Clear;
end;

destructor TDataList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TDataList.Clear;
begin
  FName := '';
  FValue := 0;

  ClearData(0);
  ClearItems(0);
end;

function TDataList.ID: Integer;
begin
  Result := FID;
end;

function TDataList.Parent: TDataList;
begin
  Result := FParent;
end;


// Data

procedure TDataList.ClearData(NewCount: Integer);
var
  Loop: Integer;
begin
  SetLength(FNames, NewCount);
  SetLength(FValues, NewCount);

  if NewCount > 0 then
    for Loop := 0 to NewCount - 1 do
    begin
      FNames[Loop] := '';
      FValues[Loop] := 0;
    end;
end;

procedure TDataList.LoadFromXML(ValuesNode: IXMLNode; ProcessItemsRecursive: Boolean = false);
Var
  Loop: Integer;
  atrCount: Integer;
  curNode: IXMLNode;
  strAttrName: String;
  NewID: Integer;
begin
  if FID = 0 then
    if ValuesNode.HasAttribute(XMLATTRNAME_ID) then
      FID := ValuesNode.Attributes[XMLATTRNAME_ID];

  if ValuesNode.HasAttribute(XMLATTRNAME_ITEMNAME) then
    FName := ValuesNode.Attributes[XMLATTRNAME_ITEMNAME]
  else
    if ValuesNode.HasAttribute(XMLATTRNAME_NAME) then
      FName := ValuesNode.Attributes[XMLATTRNAME_NAME];

  if ValuesNode.HasAttribute(XMLATTRNAME_ITEMVALUE) then
    FValue := ValuesNode.Attributes[XMLATTRNAME_ITEMVALUE];

  atrCount := ValuesNode.AttributeNodes.Count;
  ClearData(atrCount);
  if atrCount > 0 then
    for Loop := 0 to atrCount - 1 do
    begin
      curNode := ValuesNode.AttributeNodes.Nodes[Loop];
      strAttrName := curNode.NodeName;
      if (strAttrName <> XMLATTRNAME_ID) and (strAttrName <> XMLATTRNAME_ITEMNAME) and
        (strAttrName <> XMLATTRNAME_ITEMVALUE) then
      begin
        FNames[Loop] := lowercase(StringReplace(strAttrName, '_', ' ',
          [rfReplaceAll, rfIgnoreCase]));
        if curNode.NodeValue <> Null then
          FValues[Loop] := curNode.NodeValue
        else
          FValues[Loop] := '';
      end;
    end;

  if ProcessItemsRecursive then
    if ValuesNode.ChildNodes.Count > 0 then
    begin
      ClearItems(ValuesNode.ChildNodes.Count);
      for Loop := 0 to ValuesNode.ChildNodes.Count - 1 do
      begin
        curNode := ValuesNode.ChildNodes.Nodes[Loop];
        NewID := Loop;
        if curNode.HasAttribute(XMLATTRNAME_ID) then
          NewID := curNode.Attributes[XMLATTRNAME_ID];
        AddItem(NewID, Loop).LoadFromXML(curNode, ProcessItemsRecursive);
      end;
    end;

  strAttrName := '';
end;

procedure TDataList.SaveToXML(ValuesNode: IXMLNode; ProcessItemsRecursive: Boolean = false);
Var
  Loop: Integer;
begin
  ValuesNode.Attributes[XMLATTRNAME_ID] := FID;
  ValuesNode.Attributes[XMLATTRNAME_ITEMNAME] := FName;
  if Value <> Null then
    ValuesNode.Attributes[XMLATTRNAME_ITEMVALUE] := FValue;

  if Length(FNames) > 0 then
    for Loop := 0 to Length(FNames) - 1 do
      if (FValues[Loop] <> Null) and (FNames[Loop] <> '') then
        ValuesNode.Attributes[StringReplace(FNames[Loop], ' ', '_', [rfReplaceAll, rfIgnoreCase])] :=
          FValues[Loop];

  if ProcessItemsRecursive then
    if Count > 0 then
      for Loop := 0 to Count - 1 do
        Items(Loop).SaveToXML(ValuesNode.AddChild('item'), ProcessItemsRecursive);
end;

procedure TDataList.LoadFromFile(FileName: String);
var
  XMLDoc: TXMLDocument;
begin
  if FileExists(FileName) then
  try
    XMLDoc := TXMLDocument.Create(Application);
    try
      XMLDoc.Active := false;
      XMLDoc.XML.LoadFromFile(FileName);
      XMLDoc.Active := true;
      LoadFromXML(XMLDoc.DocumentElement, true);
    finally
      XMLDoc.Active := false;
      XMLDoc.Free;
    end;
  except
  end;
end;

procedure TDataList.SaveToFile(FileName, RootNodeName: String);
var
  XMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
  strXML: TStringList;
begin
  try
    XMLDoc := TXMLDocument.Create(Application);
    strXML := TStringList.Create;
    try
      XMLDoc.Active := false;
      XMLDoc.XML.Text := '<' + RootNodeName + '/>';
      XMLDoc.Active := true;
      XMLRoot := XMLDoc.DocumentElement;
      SaveToXML(XMLRoot, true);
      strXML.Text := FormatXMLData(XMLRoot.XML);
      strXML.SaveToFile(FileName);
    finally
      XMLDoc.Active := false;
      XMLDoc.Free;
      strXML.Free;
    end;
  except
  end;
end;


// Add/Get value

function TDataList.AddValueName(const ValueName: String): Integer;
begin
  if not FoundValueName(ValueName, Result) then
  begin
    Result := Length(FNames);
    SetLength(FNames, Result + 1);
    SetLength(FValues, Result + 1);
    FNames[Result] := lowercase(ValueName);
  end;
end;

function TDataList.FoundValueName(const ValueName: String; var Index: Integer): Boolean;
var
  Loop: Integer;
  LowerName: String;
begin
  Index := -1;
  Result := false;
  LowerName := lowercase(ValueName);
  if Length(FNames) > 0 then
    for Loop := 0 to Length(FNames) - 1 do
      if FNames[Loop] = LowerName then
      begin
        Index := Loop;
        Result := true;
        break;
      end;

  LowerName := '';
end;


// Value Count, Set/Get Values and Names

function TDataList.ValueCount: Integer;
begin
  Result := Length(FNames);
end;

procedure TDataList.SetValueNames(Index: Integer; const Value: String);
begin
  FNames[Index] := lowercase(Value);
end;

function TDataList.GetValueNames(Index: Integer): String;
begin
  Result := FNames[Index];
end;

procedure TDataList.SetValues(Index: Integer; const Value: Variant);
begin
  if Value <> Null then
    FValues[Index] := Value
  else
    FValues[Index] := '';
end;

function TDataList.GetValues(Index: Integer): Variant;
begin
  Result := FValues[Index];
end;


// Set/Get values

procedure TDataList.SetValuesAsBoolean(const ValueName: String;
  const Value: Boolean);
begin
  if Value then
    FValues[AddValueName(ValueName)] := '1'
  else
    FValues[AddValueName(ValueName)] := '0';
end;

function TDataList.GetValuesAsBoolean(const ValueName: String): Boolean;
var
  Index: Integer;
  StrResult: String;
begin
  Result := false;
  if FoundValueName(ValueName, Index) then
  begin
    StrResult := lowercase(String(FValues[Index]));
    Result := (StrResult = '1') or (StrResult = 'true');
  end;

  StrResult := '';
end;

procedure TDataList.SetValuesAsCurrency(const ValueName: String;
  const Value: Currency);
begin
  FValues[AddValueName(ValueName)] := Value;
end;

function TDataList.GetValuesAsCurrency(const ValueName: String): Currency;
var
  Index: Integer;
begin
  Result := 0;
  if FoundValueName(ValueName, Index) then
  try
    Result := Currency(FValues[Index]);
  except
    Result := 0;
  end;
end;

procedure TDataList.SetValuesAsFloat(const ValueName: String;
  const Value: Double);
begin
  FValues[AddValueName(ValueName)] := Value;
end;

function TDataList.GetValuesAsFloat(const ValueName: String): Double;
var
  Index: Integer;
begin
  Result := 0;
  if FoundValueName(ValueName, Index) then
  try
    Result := Double(FValues[Index]);
  except
    Result := 0;
  end;
end;

procedure TDataList.SetValuesAsInteger(const ValueName: String;
  const Value: Integer);
begin
  FValues[AddValueName(ValueName)] := Value;
end;

function TDataList.GetValuesAsInteger(const ValueName: String): Integer;
var
  Index: Integer;
begin
  Result := 0;
  if FoundValueName(ValueName, Index) then
  try
    Result := Integer(FValues[Index]);
  except
    Result := 0;
  end;
end;

procedure TDataList.SetValuesAsString(const ValueName: String;
  const Value: String);
begin
  FValues[AddValueName(ValueName)] := Value;
end;

function TDataList.GetValuesAsString(const ValueName: String): String;
var
  Index: Integer;
begin
  Result := '';
  if FoundValueName(ValueName, Index) then
    Result := String(FValues[Index]);
end;

procedure TDataList.SetValuesAsTDateTime(const ValueName: String;
  const Value: TDateTime);
begin
  FValues[AddValueName(ValueName)] := Value;
end;

function TDataList.GetValuesAsTDateTime(const ValueName: String): TDateTime;
var
  Index: Integer;
begin
  Result := 0;
  if FoundValueName(ValueName, Index) then
  try
    Result := TDateTime(FValues[Index]);
  except
    Result := 0;
  end;
end;


// Items

procedure TDataList.ClearItems(NewCount: Integer);
var
  curObj: TDataList;
  Loop: Integer;
begin
  if Length(FItems) > 0 then
    for Loop := 0 to Length(FItems) - 1 do
    begin
      curObj := FItems[Loop];
      if curObj <> nil then
        curObj.Free;
    end;

  SetLength(FItems, NewCount);

  if NewCount > 0 then
    for Loop := 0 to NewCount - 1 do
      FItems[Loop] := nil;
end;

function TDataList.Count: Integer;
begin
  Result := Length(FItems);
end;

procedure TDataList.Delete(Index: Integer);
var
  Loop: Integer;
  DataList: TDataList;
begin
  // Free item object
  DataList := FItems[Index];
  if DataList <> nil then
    DataList.Free;

  if Length(FItems) > 1 then
  begin
    // Move Rest items
    if Index < Length(FItems) - 1 then
      for Loop := Index + 1 to Length(FItems) - 1 do
        FItems[Loop - 1] := FItems[Loop];

    SetLength(FItems, Length(FItems) - 1);
  end
  else
    SetLength(FItems, 0);
end;

procedure TDataList.Remove(AID: Integer);
var
  Index: Integer;
begin
  if FindItem(AID, Index) then
    Delete(Index);
end;

function TDataList.Items(Index: Integer): TDataList;
begin
  Result := FItems[Index];
end;

function TDataList.Add(AID: Integer): TDataList;
var
  Index: Integer;
begin
  if FindItem(AID, Index) then
    Result := FItems[Index]
  else
  begin
    Result := TDataList.Create(AID, Self);
    SetLength(FItems, Length(FItems) + 1);
    FItems[Length(FItems) - 1] := Result;
  end;
end;

function TDataList.Clone(Original: TDataList; NewID: Integer = 0): TDataList;
var
  Loop: Integer;
begin
  if NewID = 0 then
    Result := Add(Original.ID)
  else
    Result := Add(NewID);
    
  Result.Name := Original.Name;
  Result.Value := Original.Value;

  // Values
  Result.ClearData(Original.ValueCount);
  for Loop := 0 to Original.ValueCount - 1 do
  begin
    Result.ValueNames[Loop] := Original.ValueNames[Loop];
    Result.Values[Loop] := Original.Values[Loop];
  end;

  // Items
  Result.ClearItems(0);
  for Loop := 0 to Original.Count - 1 do
    Result.Clone(Original.Items(Loop));
end;

function TDataList.Find(AID: Integer; var DataList: TDataList): Boolean;
var
  Index: Integer;
begin
  Result := FindItem(AID, Index);
  if Result then
    DataList := FItems[Index];
end;

function TDataList.FindItem(AID: Integer; var Index: Integer): Boolean;
var
  Loop: Integer;
begin
  Result := false;
  Index := -1;
  if Length(FItems) > 0 then
    for Loop := 0 to Length(FItems) - 1 do
      if FItems[Loop].ID = AID then
      begin
        Index := Loop;
        Result := true;
        break;
      end;
end;

function TDataList.AddItem(AID, Index: Integer): TDataList;
begin
  Result := TDataList.Create(AID, Self);
  FItems[Index] := Result;
end;

procedure TDataList.SortItems(const ValueName: String; Ascending,
  IsNumber: Boolean);
begin
  SortItems(ValueName, Ascending, IsNumber, 0, Length(FItems) - 1);
end;

procedure TDataList.SortItems(const ValueName: String; Ascending,
  IsNumber: Boolean; IndexFrom, IndexTo: Integer);
type
  TValueType = (vtID, vtName, vtValue, vtValues);
var
  Loop: Integer;
  Loop2: Integer;
  ValueType: TValueType;
  Index: Integer;
  IndValue: Integer;
  Value: String;
  fltValue: Double;
  curValue: String;
  curItem: TDataList;
  isFound: Boolean;
begin
  if (Length(FItems) < 2) or (IndexFrom >= IndexTo) then
    exit;

  ValueType := vtValues;
  if ValueName = XMLATTRNAME_ID then
    ValueType := vtID;
  if (ValueName = XMLATTRNAME_ITEMNAME) or (ValueName = XMLATTRNAME_NAME) then
    ValueType := vtName;
  if ValueName = XMLATTRNAME_ITEMVALUE then
    ValueType := vtValue;

  for Loop := IndexFrom to IndexTo - 1 do
  begin
    curItem := FItems[Loop];
    Index := Loop;
    Value := '';
    case ValueType of
      vtID:
        Value := inttostr(curItem.ID);
      vtName:
        Value := curItem.Name;
      vtValue:
        Value := String(curItem.Value);
      vtValues:
        if curItem.FoundValueName(ValueName, IndValue) then
          Value := String(curItem.FValues[IndValue]);
    end;
    fltValue := 0;
    if IsNumber then
      fltValue := Conversions.Str2Cur(Value);

    if Value <> Null then
      for Loop2 := Loop + 1 to IndexTo do
      begin
        curItem := FItems[Loop2];
        curValue := '';
        case ValueType of
          vtID:
            curValue := inttostr(curItem.ID);
          vtName:
            curValue := curItem.Name;
          vtValue:
            curValue := String(curItem.Value);
          vtValues:
            if curItem.FoundValueName(ValueName, IndValue) then
              curValue := String(curItem.FValues[IndValue]);
        end;

        if curValue <> Null then
        begin
          if IsNumber then
          begin
            if Ascending then
              isFound := Conversions.Str2Cur(curValue) < fltValue
            else
              isFound := Conversions.Str2Cur(curValue) > fltValue;
          end
          else
            if Ascending then
              isFound := curValue < Value
            else
              isFound := curValue > Value;

          if isFound then
          begin
            Index := Loop2;
            Value := curValue;
            if IsNumber then
              fltValue := Conversions.Str2Cur(Value);
          end;
        end;
      end;

    if Index <> Loop then
    begin
      curItem := FItems[Loop];
      FItems[Loop] := FItems[Index];
      FItems[Index] := curItem;
    end;
  end;

  Value   := '';
  curValue:= '';
end;


end.
