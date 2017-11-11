unit uFMActions;

interface

uses
  SysUtils, Classes, xmldom, XMLIntf, msxmldom, XMLDoc, Contnrs;

type
  TfmAction = class(TObject)
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
    property TournamentID: Integer read FTournamentID;
    property ProcessID: Integer read FProcessID;
    property UserID: Integer read FUserID;
    property SessionID: Integer read FSessionID;
    property Name: string read GetName;
    //
    function SetContextByObject(FromObj: TfmAction): Integer;
    // constructor
    constructor Create;
  end;

  // *************************************
  // Input Action list context
  // *************************************
  TfmActions = class(TObjectList)
  private
    function GetItem(Index: Integer): TfmAction;
  public
    property Item[Index: Integer]: TfmAction read GetItem;
    //
    procedure Del(Item: TfmAction);
    // Add Item to the lists
    function Add: TfmAction;
    function Ins(Index: Integer): TfmAction;
    //
    function SetContextByObject(FromObj: TfmActions): Integer;
  end;

  // *************************************
  // Responce Action context item
  // *************************************
  TfmRespAction = class(TObject)
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
    function SetContextByObject(FromObj: TfmRespAction): Integer;
    // constructor
    constructor Create(sTxt: string; nSessionID, nUserID: Integer);
  end;

  // *************************************
  // Responce Action list context
  // *************************************
  TfmRespActions = class(TObjectList)
  private
    function GetItem(Index: Integer): TfmRespAction;
  public
    property Item[Index: Integer]: TfmRespAction read GetItem;
    //
    procedure Del(Item: TfmRespAction);
    // Add Item to the lists
    function Add(sTxt: string; nSessionID, nUserID: Integer): TfmRespAction;
    function Ins(Index: Integer; sTxt: string; nSessionID, nUserID: Integer): TfmRespAction;
    // Internal functionalities
    procedure SendActions;
    function SetContextByObject(FromObj: TfmRespActions): Integer;
  end;

implementation

uses
  uCommonDataModule, uLogger, uXMLConstants;

{ TAction }

constructor TfmAction.Create;
begin
  inherited Create;
  FUserID := -1;
  FProcessID := -1;
  FTournamentID := -1;
  FSessionID := -1;
end;

function TfmAction.GetName: string;
begin
  Result := FActionNode.NodeName;
end;

function TfmAction.SetContextByObject(FromObj: TfmAction): Integer;
begin
  ActionNode := FromObj.FActionNode;
  Result := 0;
end;

procedure TfmAction.SetActionNode(const Value: IXMLNode);
begin
  FActionNode := Value.CloneNode(True);
  SetContext;
end;

procedure TfmAction.SetContext;
begin
  if FActionNode = nil then begin
    FUserID := -1;
    FProcessID := -1;
    FTournamentID := -1;
    FSessionID := -1; // initial uncnown

    Exit;
  end;

  if FActionNode.HasAttribute('userid') then
    FUserID := StrToIntDef(FActionNode.Attributes['userid'], -1)
  else
    FUserID := -1;

  if FActionNode.HasAttribute('processid') then
    FProcessID := StrToIntDef(FActionNode.Attributes['processid'], -1)
  else
    FProcessID := -1;

  if FActionNode.HasAttribute('tournamentid') then
    FTournamentID := StrToIntDef(FActionNode.Attributes['tournamentid'], -1)
  else
    FTournamentID := -1;

  FSessionID := -1; // initial uncnown
  if FActionNode.HasAttribute('sessionid') then
    FSessionID := StrToIntDef(FActionNode.Attributes['sessionid'], -1);
end;

{ TActions }

function TfmActions.Add: TfmAction;
begin
  Result := TfmAction.Create;
  inherited Add(Result);
  Result.SetContext;
end;

procedure TfmActions.Del(Item: TfmAction);
begin
  inherited Remove(Item);
end;

function TfmActions.GetItem(Index: Integer): TfmAction;
begin
  Result := TfmAction(inherited Items[Index]);
end;

function TfmActions.Ins(Index: Integer): TfmAction;
begin
  Result := TfmAction.Create;
  inherited Insert(Index, Result);
  Result.SetContext;
end;

function TfmActions.SetContextByObject(FromObj: TfmActions): Integer;
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

{ TRespAction }

constructor TfmRespAction.Create(sTxt: string; nSessionID, nUserID: Integer);
begin
  inherited Create;
  ActionTxt := sTxt;
  FSessionID := nSessionID;
  FUserID := nUserID;
end;

procedure TfmRespAction.SendAction;
var
  sTxt: string;
begin
  sTxt :=
    '<object name="' + OBJ_FILEMANAGER + '">' +
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

procedure TfmRespAction.SetActionTxt(const Value: string);
begin
  FActionTxt := Value;
end;

{ TRestActions }

function TfmRespActions.Add(sTxt: string; nSessionID, nUserID: Integer): TfmRespAction;
begin
  Result := TfmRespAction.Create(sTxt, nSessionID, nUserID);
  inherited Add(Result);
end;

procedure TfmRespActions.Del(Item: TfmRespAction);
begin
  inherited Remove(Item);
end;

function TfmRespActions.GetItem(Index: Integer): TfmRespAction;
begin
  Result := TfmRespAction(inherited Items[Index]);
end;

function TfmRespActions.Ins(Index: Integer; sTxt: string; nSessionID, nUserID: Integer): TfmRespAction;
begin
  Result := TfmRespAction.Create(sTxt, nSessionID, nUserID);
  inherited Insert(Index, Result);
end;

function TfmRespAction.SetContextByObject(FromObj: TfmRespAction): Integer;
begin
  FActionTxt := FromObj.FActionTxt;
  FSessionID := FromObj.FSessionID;
  FUserID    := FromObj.FUserID;
  Result := 0;
end;

procedure TfmRespActions.SendActions;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do begin
    Item[I].SendAction;
  end;
  Clear;
end;

function TfmRespActions.SetContextByObject(
  FromObj: TfmRespActions): Integer;
var
  I: Integer;
  aAct: TfmRespAction;
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

procedure TfmRespAction.SetSessionID(const Value: Integer);
begin
  FSessionID := Value;
end;

procedure TfmRespAction.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

end.
