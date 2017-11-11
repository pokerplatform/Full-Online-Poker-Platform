unit uErrorHandling;

interface

uses
  Classes, SysUtils;

////////////////////////////////////////////////////////////////////////////////
// Log configuration:
////////////////////////////////////////////////////////////////////////////////
const
  DEFAULT_ENGINE_FACILITY = 'GPEngine';
  DEFAULT_LOG_EXT = 'log';
  DEFAULT_STATE_DUMP_LOG_EXT = 'state';

//var
//  DEFAULT_LOG_BASE_PATH: String   = 'D:\Poker\Logs';


////////////////////////////////////////////////////////////////////////////////
// Error codes:
////////////////////////////////////////////////////////////////////////////////
const
  GE_ERR_NONE = 0;
  GE_ERR_UNDEFINED_CODE = 1;


////////////////////////////////////////////////////////////////////////////////
// Exception handling
////////////////////////////////////////////////////////////////////////////////
type
  EpoExceptionClass = class of EpoException;
  EpoException = class(Exception)
  private
    FAnchor: String;
    FCode: Integer;
    procedure SetAnchor(const Value: String);
    procedure SetCode(const Value: Integer);
    function GetLocation: String;

  protected
    function GetUnit(): string;

  public
    property Anchor: String read FAnchor write SetAnchor;
    property Code: Integer read FCode write SetCode;
    property Location: String read GetLocation;

  //utility
    function Dump(): String;

  //generic
    constructor Create(sMsg, sAnchor: String; nCode: Integer = GE_ERR_UNDEFINED_CODE); reintroduce;
    destructor Destroy; override;
  end;//EpoException

  EpoSessionExceptionClass = class of EpoSessionException;
  EpoSessionException = class(EpoException)
  private
    FSessionID: Integer;
    procedure SetSessionID(const Value: Integer);
  public
    property SessionID: Integer read FSessionID write SetSessionID;
    constructor Create(sMsg, sAnchor: String; nCode: Integer = GE_ERR_UNDEFINED_CODE);
  end;//EpoSessionException

  EpoUnexpectedActionException = class(EpoSessionException)
  end;//EpoBadActionException

  EpoGamerNotFound = class(EpoSessionException);

procedure EscalateFailure(
  sReason, sAnchor: String; nCode: Integer = GE_ERR_UNDEFINED_CODE
); overload;

procedure EscalateFailure(
  cExceptionClass: EpoExceptionClass; sReason, sAnchor: String; nCode: Integer = GE_ERR_UNDEFINED_CODE
); overload;

procedure EscalateFailure(
  cExceptionClass: EpoSessionExceptionClass;
  nSessionID: LongInt;
  sReason, sAnchor: String;
  nCode: Integer = GE_ERR_UNDEFINED_CODE
); overload;

procedure EscalateFailure(
  nResult: Integer; cExceptionClass: EpoExceptionClass; sReason, sAnchor: String; nCode: Integer = GE_ERR_UNDEFINED_CODE
); overload;

implementation

uses uCommonDataModule;

const
  LF =#$D#$A;

procedure EscalateFailure(sReason, sAnchor: String; nCode: Integer); overload;
begin
  raise EpoException.Create(sReason, sAnchor, nCode);
end;//

procedure EscalateFailure(cExceptionClass: EpoExceptionClass; sReason, sAnchor: String; nCode: Integer);
begin
  if sReason = '' then Exit;
  raise cExceptionClass.Create(
    sReason,
    sAnchor,
    nCode
  );
end;

procedure EscalateFailure(
  cExceptionClass: EpoSessionExceptionClass; nSessionID: LongInt; sReason, sAnchor: String; nCode: Integer = GE_ERR_UNDEFINED_CODE
); overload;
var
  ex: EpoSessionException;
begin
  if sReason = '' then Exit;
  ex:= cExceptionClass.Create(
    sReason,
    sAnchor,
    nCode
  );
  ex.SessionID:= nSessionID;
  raise ex;
end;//

procedure EscalateFailure(nResult: Integer;
  cExceptionClass: EpoExceptionClass; sReason, sAnchor: String; nCode: Integer
  );
begin
  if nResult = 0 then Exit;
  EscalateFailure(cExceptionClass, sReason, sAnchor, nResult);
end;

(*
procedure EscalateFailure(e: Exception; sAnchor: String; nCode: Integer);
begin
  raise EpoException.Create(e.Message, sAnchor, nCode);
end;//
*)

{ EpoException }

constructor EpoException.Create(sMsg, sAnchor: String; nCode: Integer);
begin  
  inherited Create(sMsg);
  Anchor:= sAnchor;
  Code:= nCode;
end;

destructor EpoException.Destroy;
begin
  inherited;
end;

function EpoException.Dump: String;
begin
  Result:= 'Exception ('+ClassName+'): '+Message+' '+#$D#$A+'Anchor: '+FAnchor;
end;

function EpoException.GetLocation: String;
begin
  Result:= '{'+GetUnit+': '+FAnchor+'}';
end;

function EpoException.GetUnit: string;
begin
//TBD:
  Result:= ClassName;
end;

procedure EpoException.SetAnchor(const Value: String);
begin
  FAnchor:= Value;
end;


procedure EpoException.SetCode(const Value: Integer);
begin
  FCode:= Value;
end;


{ EpoSessionException }

constructor EpoSessionException.Create(sMsg,
  sAnchor: String; nCode: Integer);
begin
  inherited Create(sMsg, sAnchor, nCode);
end;

procedure EpoSessionException.SetSessionID(const Value: Integer);
begin
  FSessionID := Value;
end;

end.
