unit uAPIActions;

interface

uses
  xmldom, XMLIntf, msxmldom, XMLDoc, SysUtils, Classes, Contnrs;

type
  // *************************************
  // Input Action context item
  // *************************************
  TapiAction = class(TObject)
  private
    FUserID: Integer;
    FProcessID: Integer;
    FTournamentID: Integer;
    FActionNode: IXMLNode;
    FSessionID: Integer;
    procedure SetActionNode(const Value: IXMLNode);
    procedure SetContext;
    function GetName: string;
  public
    property ActionNode: IXMLNode read FActionNode write SetActionNode;
    property TournamentID: Integer read FTournamentID write FTournamentID;
    property ProcessID: Integer read FProcessID write FProcessID;
    property UserID: Integer read FUserID write FUserID;
    property SessionID: Integer read FSessionID write FSessionID;
    property Name: string read GetName;
    //
    function SetContextByObject(FromObj: TapiAction): Integer;
    // constructor
    constructor Create;
  end;

  // *************************************
  // Input Action list context
  // *************************************
  TapiActions = class(TObjectList)
  private
    function GetItem(Index: Integer): TapiAction;
  public
    property Item[Index: Integer]: TapiAction read GetItem;
    //
    procedure Del(Item: TapiAction);
    // Add Item to the lists
    function Add: TapiAction;
    function Ins(Index: Integer): TapiAction;
    //
    function SetContextByObject(FromObj: TapiActions): Integer;
  end;

  // *************************************
  // Responce Action context item
  // *************************************
  TapiRespAction = class(TObject)
  private
    FActionTxt: string;
    FUserID: Integer;
    FSessionID: Integer;
    FObjName: string;
    procedure SetActionTxt(const Value: string);
    procedure SetSessionID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
    procedure SetObjName(const Value: string);
  public
    property ActionTxt: string read FActionTxt write SetActionTxt;
    property ObjName: string read FObjName write SetObjName;
    // is sessionID or UserID <> 0 then notification
    property SessionID: Integer read FSessionID write SetSessionID;
    property UserID: Integer read FUserID write SetUserID;
    procedure SendAction;
    // Internal functionalities
    function SetContextByObject(FromObj: TapiRespAction): Integer;
    // constructor
    constructor Create(sTxt: string; nSessionID, nUserID: Integer);
  end;

  // *************************************
  // Responce Action list context
  // *************************************
  TapiRespActions = class(TObjectList)
  private
    function GetItem(Index: Integer): TapiRespAction;
  public
    property Item[Index: Integer]: TapiRespAction read GetItem;
    //
    procedure Del(Item: TapiRespAction);
    // Add Item to the lists
    function Add(sTxt: string; nSessionID, nUserID: Integer): TapiRespAction;
    function Ins(Index: Integer; sTxt: string; nSessionID, nUserID: Integer): TapiRespAction;
    // Internal functionalities
    procedure SendActions;
    function SetContextByObject(FromObj: TapiRespActions): Integer;
  end;

implementation

uses Variants
//PO
  , uCommonDataModule
  , uLogger
  {$IFDEF __TEST__}
    , uTournamentTest
  {$ENDIF}
  ;

{ TapiAction }

constructor TapiAction.Create;
begin
  inherited Create;
  FUserID := -1;
  FProcessID := -1;
  FTournamentID := -1;
  FSessionID := -1;
end;

function TapiAction.GetName: string;
begin
  Result := FActionNode.NodeName;
end;

function TapiAction.SetContextByObject(FromObj: TapiAction): Integer;
begin
  ActionNode := FromObj.FActionNode;
  Result := 0;
end;

procedure TapiAction.SetActionNode(const Value: IXMLNode);
begin
  FActionNode := Value.CloneNode(True);
  SetContext;
end;

procedure TapiAction.SetContext;
begin
  FUserID := -1;
  FProcessID := -1;
  FTournamentID := -1;
  FSessionID := -1;

  if FActionNode = nil then
    Exit;

  if FActionNode.HasAttribute('userid') then
    FUserID := StrToIntDef(FActionNode.Attributes['userid'], -1);

  if FActionNode.HasAttribute('sessionid') then
    FSessionID := StrToIntDef(FActionNode.Attributes['sessionid'], -1);

  if FActionNode.HasAttribute('processid') then
    FProcessID := StrToIntDef(FActionNode.Attributes['processid'], -1);

  if FActionNode.HasAttribute('tournamentid') then
    FTournamentID := StrToIntDef(FActionNode.Attributes['tournamentid'], -1);
end;

{ TapiActions }

function TapiActions.Add: TapiAction;
begin
  Result := TapiAction.Create;
  inherited Add(Result);
  Result.SetContext;
end;

procedure TapiActions.Del(Item: TapiAction);
begin
  inherited Remove(Item);
end;

function TapiActions.GetItem(Index: Integer): TapiAction;
begin
  Result := TapiAction(inherited Items[Index]);
end;

function TapiActions.Ins(Index: Integer): TapiAction;
begin
  Result := TapiAction.Create;
  inherited Insert(Index, Result);
  Result.SetContext;
end;

function TapiActions.SetContextByObject(FromObj: TapiActions): Integer;
var
  I: Integer;
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
    Add.SetContextByObject(FromObj.Item[I]);
  end;

  Result := 0;
end;

{ TapiRespAction }

constructor TapiRespAction.Create(sTxt: string; nSessionID, nUserID: Integer);
begin
  inherited Create;
  ActionTxt := sTxt;
  FSessionID := nSessionID;
  FUserID := nUserID;
  FObjName := '';
end;

procedure TapiRespAction.SendAction;
var
  sTxt: string;
begin
  sTxt :=
    '<object name="' + FObjName + '" sessionid="' + IntToStr(FSessionID) + '">' +
      FActionTxt +
    '</object>';

  if (FSessionID <= 0) and (FUserID <= 0) then begin
    CommonDataModule.Log(ClassName, 'SendAction',
    '[ERROR] SessionID and UserID is undefined', ltError);
  end else begin
    if FSessionID > 0 then begin
      CommonDataModule.NotifyUser(FSessionID, sTxt);
    end else begin
      CommonDataModule.NotifyUserByID(FUserID, sTxt);
    end;
  end;
end;

procedure TapiRespAction.SetActionTxt(const Value: string);
begin
  FActionTxt := Value;
end;

{ TapiRespActions }

function TapiRespActions.Add(sTxt: string; nSessionID, nUserID: Integer): TapiRespAction;
begin
  Result := TapiRespAction.Create(sTxt, nSessionID, nUserID);
  inherited Add(Result);
end;

procedure TapiRespActions.Del(Item: TapiRespAction);
begin
  inherited Remove(Item);
end;

function TapiRespActions.GetItem(Index: Integer): TapiRespAction;
begin
  Result := TapiRespAction(inherited Items[Index]);
end;

function TapiRespActions.Ins(Index: Integer; sTxt: string; nSessionID, nUserID: Integer): TapiRespAction;
begin
  Result := TapiRespAction.Create(sTxt, nSessionID, nUserID);
  inherited Insert(Index, Result);
end;

function TapiRespAction.SetContextByObject(FromObj: TapiRespAction): Integer;
begin
  FActionTxt := FromObj.FActionTxt;
  FSessionID := FromObj.FSessionID;
  FUserID    := FromObj.FUserID;
  Result := 0;
end;

procedure TapiRespActions.SendActions;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do begin
  {$IFDEF __TEST__}
    fMain.MemoOutput.Lines.Add('***************************************');
    fMain.MemoOutput.Lines.Add(FormatXMLData(Data));
  {$ELSE}
    Item[I].SendAction;
  {$ENDIF}
  end;
  Clear;
end;

function TapiRespActions.SetContextByObject(
  FromObj: TapiRespActions): Integer;
var
  I: Integer;
  aAct: TapiRespAction;
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

procedure TapiRespAction.SetObjName(const Value: string);
begin
  FObjName := Value;
end;

procedure TapiRespAction.SetSessionID(const Value: Integer);
begin
  FSessionID := Value;
end;

procedure TapiRespAction.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

end.
