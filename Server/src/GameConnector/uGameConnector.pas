unit uGameConnector;

interface

uses
  Windows, Classes, ActiveX, Contnrs, SyncObjs, SysUtils
//
  , uXMLActions
  , uApi
  , uPokerGameEngine
  ;

type
  TGameConnector = class
  private
    FGameEngine: TpoBasicGameEngine;

  public
    function UpdateProcState: Integer;
    function SetContext(var ProcessState: String; var ErrorString: String): Integer;
    function GetContext(var ProcessState: String; var ProcessInfoState: String;
      var ErrorString: string): Integer;

    function GetDefaultProperties(var InfoXML, Reason: string): Integer;
    function InitGameProcess(ProcessID: Integer; const InitXML: string;
      var Reason: string): Integer;

    function ProcessActions(nProcessID: Integer;
      var InputActions: string; var OutputActions: string;
      var ErrorString: string): Integer;

    constructor Create;
    destructor  Destroy; override;
  end;

implementation

uses
  uCommonDataModule, uLogger;

{ TGameConnector }

constructor TGameConnector.Create;
begin
  inherited;

  try
    FGameEngine := TpoGenericPokerGameEngine.Create(nil);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create',E.Message, ltException);
  end;
end;

destructor TGameConnector.Destroy;
begin
  try
    FGameEngine.Free;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;
  
  inherited;
end;


// Context set/get

function TGameConnector.SetContext(var ProcessState: String; var ErrorString: String): Integer;
begin
  Result := FGameEngine.SetContext(ProcessState, ErrorString);
end;

function TGameConnector.GetContext(var ProcessState: String;
  var ProcessInfoState: String; var ErrorString: string): Integer;
begin
  Result := FGameEngine.GetContext(ProcessState, ProcessInfoState, ErrorString);
end;

// Action Processing

function TGameConnector.ProcessActions(nProcessID: Integer;
  var InputActions: string; var OutputActions: string;
  var ErrorString: string): Integer;
begin
  Result := FGameEngine.ProcessActions(nProcessID, InputActions, OutputActions, ErrorString);
end;

function TGameConnector.GetDefaultProperties(var InfoXML,
  Reason: string): Integer;
begin
  Result:= FGameEngine.GetProcessInfo(InfoXML, Reason);
end;

function TGameConnector.InitGameProcess(ProcessID: Integer;
  const InitXML: string; var Reason: string): Integer;
begin
  Result:= FGameEngine.InitGameProcess(ProcessID, InitXML, Reason);
end;

function TGameConnector.UpdateProcState: Integer;
begin
  Result:= FGameEngine.UpdateProcState;
end;

end.
