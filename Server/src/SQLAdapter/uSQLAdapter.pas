unit uSQLAdapter;

interface

uses
  MSAccess, DB, OLEDBAccess, SyncObjs;

type
  TSQLAdapter = class
  private
    FCommand: TMSStoredProc;
    FConnection: TMSConnection;
    FConnectionString: string;
    FSQL: TMSQuery;
    FTransactionCount: Integer;
    FConnected: Boolean;
    procedure SetConnected(const Value: Boolean);
  public
    property Connected: Boolean read FConnected write SetConnected;

    function Execute(const Sql: String): TDataSet;
    function ExecuteForXML(const Sql: String): String;

    function BeginTrans: Integer;
    function CommitTrans: Integer;
    function RollbackTrans: Integer;

    procedure Clear;

    function SetProcName(const ProcName: String): Integer;
    function AddParam(const PName: String; PValue: OleVariant; PDirection: TParamType; PType: TFieldType): Integer;
    function AddParInt(const name: String; value: OleVariant; direction: TParamType): Integer;
    function AddParString(const name: String; value: OleVariant; direction: TParamType): Integer;
    function AddParWString(const name: String; value: OleVariant; direction: TParamType): Integer;
    function GetParam(const PName: String): OleVariant;
    function ExecuteCommand: TDataSet;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses SysUtils, Types, ActiveX, Variants, ADODB_TLB, Classes, MemDS,
  uSessionUtils, uCommonDataModule, uLogger, uErrorConstants;

{ TSQLAdapter }

// Common functions

constructor TSQLAdapter.Create;
begin
  FConnectionString:=CommonDataModule.SQLConnectionString + CommonDataModule.SQLServerHost;

  { create connection object }
  FConnection := TMSConnection.Create(nil);
  FConnection.ConnectString := FConnectionString;
  FConnection.ConnectionTimeout := 30;
  FConnection.PoolingOptions.MaxPoolSize := 1000;
  FConnection.PoolingOptions.MinPoolSize := 0;
  FConnection.PoolingOptions.ConnectionLifetime := 10000;
  FConnection.Pooling := True;

  { create query object }
  FSQL := TMSQuery.Create(nil);
  FSQL.Connection := FConnection;

  { create command object }
  FCommand := TMSStoredProc.Create(nil);
  FCommand.Connection := FConnection;
end;

destructor TSQLAdapter.Destroy;
begin
  try
    Clear;
    FConnection.Connected := False;

    FSQL.Free;
    FCommand.Free;
    FConnection.Free;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;

  inherited;
end;

procedure TSQLAdapter.Clear;
begin
  try
    if FSQL.Active then
      FSQL.Close;
    if FCommand.Active then
    begin
      FCommand.Params.Clear;
      FCommand.Close;
    end;
  except
  end;
end;

procedure TSQLAdapter.SetConnected(const Value: Boolean);
begin
  if FConnected <> Value then
  try
    FConnection.Connected := Value;
    FConnected := FConnection.Connected;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'SetConnected',
        'New Value=' + BoolToStr(Value) + ', ' + E.Message, ltException);
  end;
end;


// Transactions

function TSQLAdapter.BeginTrans: Integer;
begin
  Result := SL_ERR_CANNOTSTARTTRANSACTION;

  if FTransactionCount > 0 then
  begin
   CommonDataModule.Log(ClassName, 'BeginTrans', 'Transaction is already opened' +
    ' transactionCount: ' + inttostr(FTransactionCount), ltError);
    Exit;
  end;

  try
    FConnection.StartTransaction;
    Inc(FTransactionCount);
    Result := PO_NOERRORS;
    CommonDataModule.Log(ClassName, 'BeginTrans', 'Begin Transaction', ltCall);
  except
    on E:Exception do
    begin
     CommonDataModule.Log(ClassName, 'BeginTrans', E.Message +
        ' TransactionCount: ' + inttostr(FTransactionCount), ltException);
      Connected := False;
      { escalate exception }
      Raise;
    end;
  end;
end;

function TSQLAdapter.CommitTrans: Integer;
begin
  Result := SL_ERR_CANNOTCOMMITTRANSACTION;

  if FTransactionCount = 0 then
  begin
    CommonDataModule.Log(ClassName, 'CommitTrans', 'Transaction is not started' +
    ' transactionCount: ' + inttostr(FTransactionCount), ltError);
    Exit;
  end;

  try
    FConnection.Commit;
    Dec(FTransactionCount);
    Result := PO_NOERRORS;
    CommonDataModule.Log(ClassName, 'CommitTrans', 'Commit Transaction', ltCall);
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'CommitTrans', E.Message +
        ' TransactionCount: ' + inttostr(FTransactionCount), ltException);
      Connected := False;
      { escalate exception }
      Raise
    end;
  end;

  FConnection.Commit;
end;

function TSQLAdapter.RollbackTrans: Integer;
begin
  Result := SL_ERR_CANNOTROLLBACKACTION;

  if FTransactionCount = 0 then
    CommonDataModule.Log(ClassName, 'RollbackTrans', 'Transaction is not started', ltError)
  else
  try
    FConnection.Rollback;
    Dec(FTransactionCount);
    Result := PO_NOERRORS;
    CommonDataModule.Log(ClassName, 'RollbackTrans', 'Rollback Transaction', ltCall);
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'RollbackTrans', E.Message +
        ', TransactionCount: ' + inttostr(FTransactionCount), ltException);
      Connected := False;
      { escalate exception }
      Raise;
    end;
  end;
end;


// Executions

function TSQLAdapter.Execute(const Sql: String): TDataSet;
begin
  try
    FSQL.Close;
    FSQL.SQL.Text := Sql;
    FSQL.Execute;
    Result := FSQL as TDataSet;
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'Execute', E.Message + ', SQL: ' + Sql, ltException);
      Connected := False;
      { escalate exception }
      Raise;
    end;
  end;//try
end;

function TSQLAdapter.ExecuteForXML(const Sql: String): String;
var
  Records, Params : OleVariant;
  Stream: ADODB_TLB.TStream;
  adConnection : _Connection;
  adCommand: _Command;
begin
  try
    Result := '';
    adConnection := nil;
    adCommand := nil;
    Stream := ADODB_TLB.TStream.Create(nil);

    try
      adConnection := CoConnection.Create;
      adConnection.Open(FConnectionString, '', '', -1);

      adCommand := CoCommand.Create;
      adCommand.CommandType := adCmdText;
      adCommand.CommandText := sql;
      adCommand.Set_ActiveConnection(adConnection);

      Params := EmptyParam;
      Records := Unassigned;

      { open data stream }
      Stream.DefaultInterface.Open(EmptyParam, adModeUnknown, adOpenStreamUnspecified, '', '');

      { save old property }
      adCommand.Properties.Item['Output Stream'].Value := Stream.DefaultInterface;

      { execute command and save loaded data directly to the stream }
      adCommand.Execute(Records, Params, adExecuteStream);

      { read data }
      Result:=Stream.ReadText(Integer(adReadAll));

      { close connection and release objects }
      adConnection.Close;
    finally
      if adCommand <> nil then
        adCommand := nil;
      if adConnection <> nil then
        adConnection := nil;
      Stream.Free;
    end;
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'ExecuteForXML', E.Message + ', Sql: ' + Sql, ltException);
      Connected := False;
      { escalate exception }
      Raise;
    end;
  end;
end;


// Stored Procedures with params

function TSQLAdapter.SetProcName(const ProcName: String): Integer;
begin
  try
    FCommand.Params.Clear;
    FCommand.StoredProcName := ProcName;
    Result := PO_NOERRORS;
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'SetProcName', E.Message +
        ', ProcName: ' + procName, ltException);
      Connected := False;
      { escalate exception }
      Raise;
    end;
  end;
end;

function TSQLAdapter.ExecuteCommand: TDataSet;
begin
  try
    FConnection.ExecSQL('SET NOCOUNT ON',[]);
    FCommand.Execute;
    Result := FCommand as TDataSet;
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'ExecuteCommand', E.Message +
        ' procname: ' + FCommand.StoredProcName, ltException);
      Connected := False;
      { escalate exception }
      Raise;
    end;
  end;
end;

function TSQLAdapter.AddParam(const PName: String; PValue: OleVariant;
  PDirection: TParamType; PType: TFieldType): Integer;
var
  Param: TMSParam;// _Parameter;
begin
  try
    Param := FCommand.Params.FindParam(pName);
    if not Assigned(Param) then
      Param := FCommand.Params.CreateParam(pType, pName, pDirection) as TMSParam;
    Param.Value := pValue;

    if (pType = ftString) or (pType = ftWideString) or (pType = ftMemo)then
      Param.Size := 8000;

    Result := PO_NOERRORS;
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'SetProcName', E.Message +
        ' parName: ' + pName + ',' + ' parDirection: ' + inttostr(Integer(PDirection)) + ',' +
        ' parValue: ' + pValue + ',' + ' parType: ' + inttostr(Integer(pType)) + ',', ltException);
      Connected := False;
      { escalate exception }
      Raise;
    end;
  end;
end;

function TSQLAdapter.AddParInt(const name: String; value: OleVariant;
  direction: TParamType): Integer;
begin
  Result := AddParam(Name, Value, Direction, ftInteger);
end;

function TSQLAdapter.AddParString(const name: String; value: OleVariant;
  direction: TParamType): Integer;
begin
  Result := AddParam(Name, Value, Direction, ftString);
end;

function TSQLAdapter.AddParWString(const name: String; value: OleVariant;
  direction: TParamType): Integer;
begin
  Result := AddParam(Name, Value, Direction, ftWideString);
end;

function TSQLAdapter.GetParam(const PName: String): OleVariant;
begin
  try
    Result := FCommand.Params.ParamValues[pName];
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'GetParam', E.Message +
        ' parName: ' + pName, ltException);
      Connected := False;
      { escalate exception }
      Raise;
    end;
  end;
end;


end.
