unit uCacheContainer;

interface

uses
//borland
  Classes,
  SysUtils,
  Contnrs,
  Controls,
  XMLDom,
  XMLDoc,
  XMLIntf
  ;

const
  CFG_ID_ANSWER_PROBOBILITY = 25;

type

//predefinition
  TStringTableCacheItem = class;
  TStringTableCache     = class;


  TStringTableCacheItem = class
  private
    FMapID        : Integer;
    FActionType   : Integer;
    FKeyWords     : TStringList;
    FPostVariants : TStringList;
  public

  //properties
    property MapID      : Integer read FMapID;
    property ActionType : Integer read FActionType;

  //utils
    function IsInKeyWords(aWord: String; var aIndx: Integer): Boolean;
    function IsInPostVariants(aWord: String; var aIndx: Integer): Boolean;

    procedure SetupKeyWords(Text: String);

    function AddToKeyWords(aWord: String): Integer;
    function AddToPostVariants(aPostVariant: String): Integer;

    procedure ResetAll();
    procedure ResetStringsTables();

    procedure ClearKeyWords();
    procedure ClearPostVariants();

    function GetRandomPostVariant(var aMsg: String): Boolean;

  //general methods
    constructor Create(); overload;
    constructor Create(aMapID: Integer; aActionType: Integer); overload;

    destructor Destroy(); override;
  end;//class TStringCache


  TStringTableCacheState = (
    ST_IDLE,
    ST_UPDATING
  );


  TStringTableCache = class(TObjectList)
  private
    FUpdateInterval     : Integer;
    FLastUpdate         : TDateTime;
    FState              : TStringTableCacheState;

    function GetByIndex(Index: Integer): TStringTableCacheItem;
    function GetByActionType(Index: Integer): TStringTableCacheItem;
    function GetByMapID(MapID: Integer): TStringTableCacheItem;
  public

  //properties
    property Items[Index: Integer]        : TStringTableCacheItem read GetByIndex;
    property ByActionType[Index: Integer] : TStringTableCacheItem read GetByActionType;
    property ByMapID[MapID: Integer]      : TStringTableCacheItem read GetByMapID;

  //utils
    function Add(): TStringTableCacheItem; overload;
    function Add(aItem: TStringTableCacheItem): TStringTableCacheItem; overload;

    function GetRandomPostByActionType(ActionType: Integer; var sMsg: String): Boolean;
    function GetRandomPostByKeyWords(KeyWords: String; var sMsg: String): Boolean;

    function UT_GetRandomPostByKeyWords(KeyWords: String): String;

    procedure UpdateByTime();
    procedure Update();

  //generic methods
    constructor Create(UpdateInSeconds: Integer);
    destructor  Destroy(); override;
  end;//class TStringTableCache



  TCacheItemState = (
    CIS_NORMAL,
    CIS_UPDATED,
    CIS_DELETE
  ); //


  TCacheItem = class
  private
    FState: TCacheItemState;

    procedure SetState(const Value: TCacheItemState); virtual;
  public

  //properteis
    property State: TCacheItemState read FState write SetState;

  //tools
    procedure ResetState(Force: Boolean = False);
    procedure MarkForDelete(); 

  //generic methods
    constructor Create();
    destructor  Destroy(); override;

  end;//class TCacheItem

implementation

uses
//borland
  DateUtils,
//poker
  uCommonDataModule,
  uApi,
  uSQLAdapter,
  uSQLTools,
  DB
;

{ TStringTableCache }

function TStringTableCache.Add: TStringTableCacheItem;
begin
  Result:= TStringTableCacheItem.Create();
  if not Assigned(Result) then Exit;
  Add(Result);
end;

function TStringTableCache.Add(
  aItem: TStringTableCacheItem): TStringTableCacheItem;
begin
  Result:= nil;

  if not Assigned(aItem) then Exit;
  if ((inherited Add(aItem)) = -1) then Exit;

  Result:= aItem;
end;

constructor TStringTableCache.Create(UpdateInSeconds: Integer);
begin
  inherited Create(True);

  FUpdateInterval := UpdateInSeconds;
  FLastUpdate     := Now();
  FState          := ST_IDLE;
end;

destructor TStringTableCache.Destroy;
begin
  inherited;
end;

function TStringTableCache.GetByActionType(
  Index: Integer): TStringTableCacheItem;
var
  nIndx: Integer;
begin
  UpdateByTime();
  
  Result:= nil;
  for nIndx:= 0 to (Count-1) do
    if (Items[nIndx].ActionType = Index) then begin
      Result:= Items[nIndx];
      Exit;
    end;//if
end;

function TStringTableCache.GetByIndex(
  Index: Integer): TStringTableCacheItem;
begin
  UpdateByTime();

  Result:= TStringTableCacheItem(inherited Items[Index]);
end;

function TStringTableCache.GetByMapID(
  MapID: Integer): TStringTableCacheItem;
var
  nIndx: Integer;
begin
  UpdateByTime();

  Result:= nil;
  for nIndx:= 0 to (Count-1) do
    if (Items[nIndx].MapID = MapID) then begin
      Result:= Items[nIndx];
      Exit;
    end;//if
end;

function TStringTableCache.GetRandomPostByActionType(ActionType: Integer;
  var sMsg: String): Boolean;
var
  CacheItem: TStringTableCacheItem;
begin
  UpdateByTime();

  Result  := False;
  sMsg    := '';

  CacheItem:= ByActionType[ActionType];
  if not Assigned(CacheItem) then Exit;

  if (not CacheItem.GetRandomPostVariant(sMsg)) then Exit;

  Result:= True;
end;

function TStringTableCache.GetRandomPostByKeyWords(KeyWords: String;
  var sMsg: String): Boolean;
var
  nIndx,
  nKeyIndx: Integer;
begin
  Result:= False;
  KeyWords:= LowerCase(KeyWords);

  for nIndx:= 0 to (Count-1) do begin
    if (Items[nIndx].IsInKeyWords(KeyWords, nKeyIndx)) then begin
      if (not Items[nIndx].GetRandomPostVariant(sMsg)) then Exit;
      Result:= True;
      Exit;
    end;//if
  end;//for
end;

procedure TStringTableCache.Update();
var
  Item: TStringTableCacheItem;
  nIndx: Integer;

  SQLAdapter: TSQLAdapter;
  DataSet: TDataSet;
begin
  FState:= ST_UPDATING;

//start update
  Clear();

  SQLAdapter:= CommonDataModule.ObjectPool.GetSQLAdapter();
  try

    DataSet:= SQLAdapter.Execute('apiGetBotChatPostMap');

    if Assigned(DataSet) then begin
      if (not DataSet.Eof) then begin
        DataSet.FindFirst;

        while (not DataSet.Eof) do begin

          Item:= TStringTableCacheItem.Create(
            DataSet.FieldByName('mapid').Value,
            DataSet.FieldByName('actiontypeid').Value
          );

          Item.SetupKeyWords(DataSet.FieldByName('keywords').Value);

          Add(Item);

          DataSet.Next;
        end;//while

      end;//if
    end;//if
            
    DataSet.Close;

    //getting post variants
    for nIndx:= 0 to (Count-1) do begin

      DataSet:= SQLAdapter.Execute('apiGetBotChatPostVariandByMapID ' + IntToStr(Items[nIndx].MapID));

      if Assigned(DataSet) then begin
        if (not DataSet.Eof) then begin
          DataSet.FindFirst;

          while (not DataSet.Eof) do begin
            Items[nIndx].AddToPostVariants(DataSet.FieldByName('postvariant').Value);
            DataSet.Next;
          end;//while

        end;//if
      end;//if

    end;//for

  except
    on E:Exception do begin

    end;//on
  end;//try-except
  CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);

  FLastUpdate:= Now();

  FState:= ST_IDLE;
end;

procedure TStringTableCache.UpdateByTime;
begin
  if (FState <> ST_IDLE) then Exit;
  if (SecondsBetween(Now(), FLastUpdate) < FUpdateInterval) then Exit;
  Update();
end;

function TStringTableCache.UT_GetRandomPostByKeyWords(
  KeyWords: String): String;
var
  nIndx,
  nKeyIndx: Integer;
  sMsg: String;
begin
  KeyWords:= LowerCase(KeyWords);

  for nIndx:= 0 to (Count-1) do begin
    if (Items[nIndx].IsInKeyWords(KeyWords, nKeyIndx)) then begin
      if (not Items[nIndx].GetRandomPostVariant(sMsg)) then Exit;
      Result:= sMsg;
      Exit;
    end;//if
  end;//for
end;

{ TStringTableCacheItem }

constructor TStringTableCacheItem.Create;
begin
  inherited;

  FMapID        := -1;
  FKeyWords     := TStringList.Create();
  FPostVariants := TStringList.Create();
end;

constructor TStringTableCacheItem.Create(aMapID: Integer; aActionType: Integer);
begin
  Create();

  FMapID      := aMapID;
  FActionType := aActionType
end;

destructor TStringTableCacheItem.Destroy;
begin
  FKeyWords.Free();
  FPostVariants.Free();

  inherited;
end;

function TStringTableCacheItem.GetRandomPostVariant(
  var aMsg: String): Boolean;
var
  nIndx: Integer;
  aApi: TApi;
  sValue: String;
  nProb: Real;
begin
  Result  := False;
  aMsg    := '';

  if (FPostVariants.Count = 0) then Exit;

  aApi:= CommonDataModule.ObjectPool.GetAPI();
  sValue:= '';
  aApi.GetSystemOption(CFG_ID_ANSWER_PROBOBILITY, sValue);
  CommonDataModule.ObjectPool.FreeAPI(aApi);

  nProb:= 100 - StrToIntDef(sValue, 50);
  if (nProb > 100) or (nProb < 0) then nProb:= 50;
  if ((Random(100) + 1) < nProb) then Exit;

  nIndx:= Random(FPostVariants.Count);
  if (nIndx >= FPostVariants.Count) then Exit;

  aMsg:= FPostVariants[nIndx];
  Result:= True;
end;

function TStringTableCacheItem.IsInKeyWords(aWord: String;
  var aIndx: Integer): Boolean;
begin
  aWord   := LowerCase(aWord);
  aIndx   := FKeyWords.IndexOf(aWord);
  Result  := (aIndx <> -1);
end;

function TStringTableCacheItem.IsInPostVariants(aWord: String;
  var aIndx: Integer): Boolean;
var
  nIndx: Integer;
begin
  Result:= False;
  aWord:= LowerCase(aWord);
  aIndx   := -1;

  for nIndx:= 0 to (FPostVariants.Count-1) do
    if (FPostVariants[nIndx] = aWord) then begin
      aIndx   := nIndx;
      Result  := True;
    end;//if
end;

function TStringTableCacheItem.AddToKeyWords(aWord: String): Integer;
begin
  Result:= FKeyWords.Add(LowerCase(aWord));
end;

function TStringTableCacheItem.AddToPostVariants(
  aPostVariant: String): Integer;
begin
  Result:= FPostVariants.Add(LowerCase(aPostVariant));
end;

procedure TStringTableCacheItem.ClearKeyWords;
begin
  FKeyWords.Clear();
end;

procedure TStringTableCacheItem.ClearPostVariants;
begin
  FPostVariants.Clear();
end;

procedure TStringTableCacheItem.ResetAll;
begin
  FMapID:= -1;
  ResetStringsTables();
end;

procedure TStringTableCacheItem.ResetStringsTables;
begin
  ClearKeyWords();
  ClearPostVariants();
end;

procedure TStringTableCacheItem.SetupKeyWords(Text: String);
var
  nIndx: Integer;
  sWords: String;
begin
  sWords:= '';

  for nIndx:= 1 to Length(Text) do begin
    if not (Text[nIndx] in [#13, #10, ',']) then begin
      sWords:= sWords + Text[nIndx];
    end else begin
      if (sWords <> '') then AddToKeyWords(sWords);
      sWords:= '';
    end;//if
  end;//for

  //add last words
  if (sWords <> '') then AddToKeyWords(sWords);
end;

{ TCacheItem }

constructor TCacheItem.Create;
begin
  inherited;

  FState:= CIS_UPDATED;
end;

destructor TCacheItem.Destroy;
begin
  inherited;
end;

procedure TCacheItem.MarkForDelete;
begin
  FState:= CIS_DELETE;
end;

procedure TCacheItem.ResetState(Force: Boolean);
begin
  if (Force) then FState:= CIS_NORMAL
  else if (FState <> CIS_DELETE) then FState:= CIS_NORMAL;
end;

procedure TCacheItem.SetState(const Value: TCacheItemState);
begin
  FState := Value;
end;

end.
