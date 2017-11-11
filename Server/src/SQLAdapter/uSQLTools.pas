unit uSQLTools;

interface

uses
  Classes, ComObj, SysUtils, StrUtils, Variants, DBClient, DB;

  function rsBit(rs: TDataSet; FieldName: string): integer;
  function rsInt(rs: TDataSet; FieldName: string): integer;
  function rsDate(rs: TDataSet; FieldName: string): Tdatetime;
  function rsStr(rs: TDataSet; FieldName: string): string;
  function rsFlt(rs: TDataSet; FieldName: string): Double;
  function rsCur(rs: TDataSet; FieldName: string): Currency;

implementation

// Getting Bit value from recordset field as integer(0/1).
// The value'll getted from current row of the recordset
function rsBit(rs: TDataSet;  FieldName: string): integer;
begin
  if rs.FieldByName(FieldName).AsBoolean then
    Result:=1
  else
    Result:=0;
end;

// Getting Integer value from recordset field.
// The value'll getted from current row of the recordset
function rsInt(rs: TDataSet;  FieldName: string): integer;
begin
  Result := rs.FieldByName(FieldName).AsInteger;
end;

// Getting Date value
function rsDate(rs: TDataSet;  FieldName: string): Tdatetime;
begin
  Result := rs.FieldByName(FieldName).AsDateTime;
end;

// Getting string value from recordset field.
// The value'll getted from current row of the recordset
function rsStr(rs: TDataSet;  FieldName: string): string;
begin
  Result := rs.FieldByName(FieldName).AsString;
end;

// Getting float value from recordset field.
// The value'll getted from current row of the recordset
function rsFlt(rs: TDataSet;  FieldName: string): Double;
begin
  Result := rs.FieldByName(FieldName).AsFloat;
end;

// Geting currency value from recordset field.
// The value'll getted from current row of the recordset
function rsCur(rs: TDataSet;  FieldName: string): Currency;
begin
  Result := rs.FieldByName(FieldName).AsCurrency;
end;


end.




