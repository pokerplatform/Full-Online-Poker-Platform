unit uXMLActions;

interface

uses XMLIntf, XMLDoc, Contnrs
//
  ;

type
// *************************************
// Input Action context item
// *************************************
  TXMLAction = class(TObject)
  private
    FUserID: Integer;
    FProcessID: Integer;
    FTournamentID: Integer;
    FSessionID: Integer;
    FName: string;
    FAction: string;
    FGuid: string;
    FFromTime: string;
    FToTime: string;
    FTypeOfRequest: string;
    FTournamentKind: Integer;
    FActionDispatcherID: Integer;
    FStatus: Integer;
    FFromTournamentID: Integer;
    FPassword: string;
    FBotPerProcess: Integer;
    FValue: Integer;
    procedure SetAction(const Value: string);
    procedure SetContext(ActionNode: IXMLNode);
    procedure SetTournamentKind(const Value: Integer);
  public
    property Action: string read FAction write SetAction;
    property TournamentID: Integer read FTournamentID;
    property Status: Integer read FStatus;
    property ActionDispatcherID: Integer read FActionDispatcherID;
    property TournamentKind: Integer read FTournamentKind write SetTournamentKind;
    property ProcessID: Integer read FProcessID;
    property UserID: Integer read FUserID;
    property SessionID: Integer read FSessionID;
    property Name: string read FName;
    property Guid: string read FGuid;
    property TypeOfRequest: string read FTypeOfRequest; //For Tournament Leader Board
    property FromTime: string read FFromTime;           //
    property ToTime: string read FToTime;               //
    property FromTournamentID: Integer read FFromTournamentID;
    property Password: string read FPassword;
    property Value: Integer read FValue;
    // bots
    property BotPerProcess: Integer read FBotPerProcess;
    //
    function SetContextByObject(FromObj: TXMLAction): Integer;

    // constructor
    constructor Create(ActionNode: IXMLNode);
    destructor Destroy; override;
  end;

// *************************************
// Input Action list context
// *************************************
  TXMLActions = class(TObjectList)
  private
    function GetItem(Index: Integer): TXMLAction;
  public
    property Item[Index: Integer]: TXMLAction read GetItem;
    //
    procedure Del(Item: TXMLAction);
    // Add Item to the lists
    function Add(ActionNode: IXMLNode): TXMLAction;

    function Ins(Index: Integer; ActionNode: IXMLNode): TXMLAction;

    function SetContextByObject(FromObj: TXMLActions): Integer;
    //
    destructor Destroy; override;
  end;

// *************************************
// Responce Action context item
// *************************************
  TXMLRespAction = class(TObject)
  private
    FActionTxt: string;
    FUserID: Integer;
    FSessionID: Integer;
    procedure SetActionTxt(const Value: string);
    procedure SetSessionID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
  public
    property ActionTxt: string read FActionTxt write SetActionTxt;
    // is sessionID or UserID <> 0 then notification
    property SessionID: Integer read FSessionID write SetSessionID;
    property UserID: Integer read FUserID write SetUserID;
    procedure SendAction;
    // Internal functionalities
    function SetContextByObject(FromObj: TXMLRespAction): Integer;
    // constructor
    constructor Create(sTxt: string; nSessionID, nUserID: Integer);
  end;

// *************************************
// Responce Action list context
// *************************************
  TXMLRespActions = class(TObjectList)
  private
    function GetItem(Index: Integer): TXMLRespAction;
  public
    property Item[Index: Integer]: TXMLRespAction read GetItem;
    //
    procedure Del(Item: TXMLRespAction);
    // Add Item to the lists
    function Add(sTxt: string; nSessionID, nUserID: Integer): TXMLRespAction;
    function Ins(Index: Integer; sTxt: string; nSessionID, nUserID: Integer): TXMLRespAction;
    // Internal functionalities
    function SetContextByObject(FromObj: TXMLRespActions): Integer;
    //
    destructor Destroy; override;
  end;

function XMLSafeEncode(XMLText: String; IsText: Boolean = False): String;
function XMLSafeDecode(XMLText: String; IsText: Boolean = False): String;

implementation

uses
  SysUtils, Classes
{$IFDEF __TEST__}
  , uTournamentTest
{$ENDIF}
  , uCommonDataModule
  , uLogger
  , uXMLConstants
  , uErrorConstants
  ;


function XMLSafeEncode(XMLText: String; IsText: Boolean = False): String;
begin
  Result := StringReplace(XMLText, '<', '&lt;',   [rfIgnoreCase, rfReplaceAll]);
  Result := StringReplace(Result,  '>', '&gt;',   [rfIgnoreCase, rfReplaceAll]);
  if not IsText then
    Result := StringReplace(Result,  '"', '&quot;', [rfIgnoreCase, rfReplaceAll]);
end;

function XMLSafeDecode(XMLText: String; IsText: Boolean = False): String;
begin
  Result := StringReplace(XMLText, '&lt;',   '<', [rfIgnoreCase, rfReplaceAll]);
  Result := StringReplace(Result,  '&gt;',   '>', [rfIgnoreCase, rfReplaceAll]);
  if not IsText then
    Result := StringReplace(Result,  '&quot;', '"', [rfIgnoreCase, rfReplaceAll]);
end;


{ TXMLAction }

constructor TXMLAction.Create(ActionNode: IXMLNode);
begin
  inherited Create;
  SetContext(ActionNode);
end;

destructor TXMLAction.Destroy;
begin
  inherited;
end;

procedure TXMLAction.SetAction(const Value: string);
begin
  FAction := Value;
end;

procedure TXMLAction.SetContext(ActionNode: IXMLNode);
begin
  FSessionID := -1;
  FUserID := -1;
  FProcessID := -1;
  FTournamentID := -1;
  FStatus := 0;
  FActionDispatcherID := 0;
  FTournamentKind := 0;
  FGuid := '';
  FAction := '';
  FFromTournamentID := 0;
  FPassword := '';
  FValue := 0;
  FBotPerProcess := 0;

  if ActionNode = nil then
    Exit;

  if ActionNode.HasAttribute('sessionid') then
    FSessionID := StrToIntDef(ActionNode.Attributes['sessionid'], -1);

  if ActionNode.HasAttribute('userid') then
    FUserID := StrToIntDef(ActionNode.Attributes['userid'], -1);

  if ActionNode.HasAttribute('processid') then
    FProcessID := StrToIntDef(ActionNode.Attributes['processid'], -1);

  if ActionNode.HasAttribute('tournamentid') then
    FTournamentID := StrToIntDef(ActionNode.Attributes['tournamentid'], -1);

  if ActionNode.HasAttribute('statusid') then
    FStatus := StrToIntDef(ActionNode.Attributes['statusid'], 0);

  if ActionNode.HasAttribute('actiondispatcherid') then
    FActionDispatcherID := StrToIntDef(ActionNode.Attributes['actiondispatcherid'], 0);

  if ActionNode.HasAttribute('kind') then
    FTournamentKind := StrToIntDef(ActionNode.Attributes['kind'], 0);

  if ActionNode.HasAttribute('type') then
    FTypeOfRequest := ActionNode.Attributes['type'];

  if ActionNode.HasAttribute('fromtime') then
    FFromTime := ActionNode.Attributes['fromtime'];

  if ActionNode.HasAttribute('totime') then
    FToTime := ActionNode.Attributes['totime'];

  if ActionNode.HasAttribute('fromtournamentid') then
    FFromTournamentID := ActionNode.Attributes['fromtournamentid'];

  if ActionNode.HasAttribute('password') then
    FPassword := ActionNode.Attributes['password'];

  if ActionNode.HasAttribute('value') then
    FValue := ActionNode.Attributes['value'];

  if ActionNode.HasAttribute(PO_ATTRGUID) then
    FGuid := ActionNode.Attributes[PO_ATTRGUID];

  if ActionNode.HasAttribute('maxnumberperprocess') then
    FBotPerProcess := ActionNode.Attributes['maxnumberperprocess'];

  FName := lowercase(ActionNode.NodeName);
  FAction := ActionNode.XML;
end;

function TXMLAction.SetContextByObject(FromObj: TXMLAction): Integer;
begin
  FUserID := FromObj.FUserID;
  FProcessID := FromObj.FProcessID;
  FTournamentID := FromObj.FTournamentID;
  FStatus := FromObj.FStatus;
  FActionDispatcherID := FromObj.FActionDispatcherID;
  FTournamentKind := FromObj.FTournamentKind;
  FSessionID := FromObj.FSessionID;
  FName := FromObj.FName;
  FGuid := FromObj.Guid;
  FAction := FromObj.FAction;
  FTypeOfRequest := FromObj.FTypeOfRequest;
  FFromTime := FromObj. FFromTime;
  FToTime := FromObj.FToTime;
  FFromTournamentID := FromObj.FFromTournamentID;
  FPassword := FromObj.FPassword;
  FValue := FromObj.FValue;
  FBotPerProcess := FromObj.FBotPerProcess;

  Result := PO_NOERRORS;
end;

procedure TXMLAction.SetTournamentKind(const Value: Integer);
begin
  FTournamentKind := Value;
end;

{ TXMLActions }

function TXMLActions.Add(ActionNode: IXMLNode): TXMLAction;
begin
  Result := TXMLAction.Create(ActionNode);
  inherited Add(Result);
end;

procedure TXMLActions.Del(Item: TXMLAction);
begin
  inherited Remove(Item);
end;

destructor TXMLActions.Destroy;
begin
  while Count > 0 do
    Del(Item[0]);
  inherited;
end;

function TXMLActions.GetItem(Index: Integer): TXMLAction;
begin
  Result := TXMLAction(inherited Items[Index]);
end;

function TXMLActions.Ins(Index: Integer; ActionNode: IXMLNode): TXMLAction;
begin
  Result := TXMLAction.Create(ActionNode);
  inherited Insert(Index, Result);
//  Result.SetContext;
end;

function TXMLActions.SetContextByObject(FromObj: TXMLActions): Integer;
var
  Loop: Integer;
  curAction: TXMLAction;
begin
  for Loop := 0 to FromObj.Count - 1 do
  begin
    curAction := TXMLAction.Create(nil);
    curAction.SetContextByObject(FromObj.Item[Loop]);
    inherited Add(curAction);
  end;
  Result := PO_NOERRORS;
end;

{ TXMLRespAction }

constructor TXMLRespAction.Create(sTxt: string; nSessionID, nUserID: Integer);
begin
  inherited Create;
  ActionTxt := sTxt;
  FSessionID := nSessionID;
  FUserID := nUserID;
end;

procedure TXMLRespAction.SendAction;
begin

  if (FSessionID <= 0) and (FUserID <= 0) then begin
{$IFDEF __TEST__}
    fMain.MemoOutput.Lines.Add('***************************************');
    fMain.MemoOutput.Lines.Add(FormatXMLData(ActionTxt));
{$ELSE}
    CommonDataModule.ProcessAction(ActionTxt);
{$ENDIF}
  end else begin
{$IFDEF __TEST__}
    fMain.MemoOutput.Lines.Add('***************************************');
    fMain.MemoOutput.Lines.Add(FormatXMLData(ActionTxt));
{$ELSE}
    if FSessionID > 0 then begin
      CommonDataModule.NotifyUser(FSessionID, FActionTxt);
    end else begin
      CommonDataModule.NotifyUserByID(FUserID, FActionTxt);
    end;
{$ENDIF}
  end;
end;

procedure TXMLRespAction.SetActionTxt(const Value: string);
begin
  FActionTxt := Value;
end;

{ TtsRestActions }

function TXMLRespActions.Add(sTxt: string; nSessionID, nUserID: Integer): TXMLRespAction;
begin
  Result := TXMLRespAction.Create(sTxt, nSessionID, nUserID);
  inherited Add(Result);
end;

procedure TXMLRespActions.Del(Item: TXMLRespAction);
begin
  inherited Remove(Item);
end;

destructor TXMLRespActions.Destroy;
begin
  while Count > 0 do Del(Item[0]);
  inherited;
end;

function TXMLRespActions.GetItem(Index: Integer): TXMLRespAction;
begin
  Result := TXMLRespAction(inherited Items[Index]);
end;

function TXMLRespActions.Ins(Index: Integer; sTxt: string; nSessionID, nUserID: Integer): TXMLRespAction;
begin
  Result := TXMLRespAction.Create(sTxt, nSessionID, nUserID);
  inherited Insert(Index, Result);
end;

function TXMLRespAction.SetContextByObject(FromObj: TXMLRespAction): Integer;
begin
  FActionTxt := FromObj.FActionTxt;
  FSessionID := FromObj.FSessionID;
  FUserID    := FromObj.FUserID;
  Result := 0;
end;

function TXMLRespActions.SetContextByObject(
  FromObj: TXMLRespActions): Integer;
var
  I: Integer;
  aAct: TXMLRespAction;
begin
  if FromObj = nil then
  begin
    CommonDataModule.Log(ClassName, 'SetContextByObject',
      'Try to take context from nil object', ltException);

    Result := 1;
    Exit;
  end;

  Clear;
  for I := 0 to FromObj.Count - 1 do begin
    aAct := FromObj.Item[I];
    Add(aAct.FActionTxt, aAct.FSessionID, aAct.FUserID);
  end;

  Result := 0;

end;

procedure TXMLRespAction.SetSessionID(const Value: Integer);
begin
  FSessionID := Value;
end;

procedure TXMLRespAction.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

end.
