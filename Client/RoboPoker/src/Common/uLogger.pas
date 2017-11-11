unit uLogger;

interface

uses
  SysUtils, Classes, Windows, Messages, DateUtils, SyncObjs, uConstants;

const
  MaxLogCashSize = 100000;
  SaveTime_Sec = 5;

type
  TLogType = (ltBase, ltCall, ltRequest, ltResponse, ltError, ltException);

  TLogger = class (TThread)
  private
    FCriticalSection: TCriticalSection;
    FLogFormatSettings: TFormatSettings;
    FLogPath: String;
    FLogCash: String;
    FLastSaveTime: TDateTime;
    FLogging: Boolean;

  protected
    procedure Execute; override;

  public
    property Logging: Boolean read FLogging write FLogging;
    procedure Log(BotID: Integer; const ClassName, MethodName, LogData : String; LogType: TLogType);

    constructor Create;
    destructor Destroy; override;
  end;

  var
    Logger: TLogger;

implementation

{ TLogger }

constructor TLogger.Create;
var
  PCModuleName: PChar;
begin
  inherited Create(True);

  FLogFormatSettings.ShortDateFormat := 'mm/dd/yyyy';
  FLogFormatSettings.ShortTimeFormat := 'hh:nn:ss.zzz';
  FLogFormatSettings.LongDateFormat := 'mm/dd/yyyy';
  FLogFormatSettings.LongTimeFormat := 'hh:nn:ss.zzz';
  FLogFormatSettings.DateSeparator := '/';
  FLogFormatSettings.TimeSeparator := ':';

  FLogCash := '';

  GetMem(PCModuleName, MAX_PATH);
  GetModuleFileName(0, PCModuleName, MAX_Path);
  FLogPath := ExtractFilePath(PCModuleName) + 'Logs\';
  ForceDirectories(FLogPath);
  FreeMem(PCModuleName);
  FLastSaveTime := Now;

  FCriticalSection := TCriticalSection.Create;

  Log(0, ClassName, 'Create', 'Created sucessfully', ltBase);
  Resume;
end;

destructor TLogger.Destroy;
begin
  Log(0, ClassName, 'Destroy', 'Destroyed sucessfully', ltBase);

  Terminate;
  WaitFor;

  FCriticalSection.Free;
  inherited;
end;

procedure TLogger.Log(BotID: Integer; const ClassName, MethodName, LogData : String; LogType: TLogType);
var
  TypeName: String;
  CurLogLine: String;
  BotInfo: String;
begin
  if FLogging then
  begin
    case LogType of
      ltBase:
        TypeName := 'Base';
      ltCall:
        TypeName := 'Call';
      ltRequest:
        TypeName := 'Rqst';
      ltResponse:
        TypeName := 'Resp';
      ltError:
        TypeName := 'Eror';
      ltException:
        TypeName := 'Exct';
    else
      TypeName := 'None'
    end;

    BotInfo := '';
    if BotID > 0 then
      BotInfo := inttostr(BotID);
    CurLogLine := TypeName + '|' + DateTimeToStr(Now, FLogFormatSettings) + '|' +
      BotInfo + '|' + ClassName + '|' + MethodName + '|' + LogData + #13#10;

    FCriticalSection.Enter;
    FLogCash := FLogCash + CurLogLine;
    FCriticalSection.Leave;

    { clear local strings }
    TypeName := '';
    CurLogLine := '';
    BotInfo := '';
  end;
end;

procedure TLogger.Execute;
var
  CurLogLine: String;
  IntLogCash: String;

  FH: integer;
  FLogFile: String;

  AYear, AMonth, ADay, AHour,
  AMinute, ASecond, AMilliSecond: Word;
begin
  inherited;

  repeat
  try
    Sleep(1000);

    FCriticalSection.Enter;
    CurLogLine := FLogCash;
    FLogCash := '';
    FCriticalSection.Leave;

    IntLogCash := IntLogCash + CurLogLine;
    CurLogLine := '';
    if IntLogCash <> '' then
    if Terminated or (Length(IntLogCash) > MaxLogCashSize) or
      (IncSecond(FLastSaveTime, SaveTime_Sec) < Now) then
      begin
        DecodeDateTime(now, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);

        FLogFile := FLogPath +
          FormatFloat('0000', AYear) + '_' + FormatFloat('00', AMonth) + '_' + FormatFloat('00', ADay) +
          '[' + FormatFloat('00', AHour) + '_' + FormatFloat('00', AMinute) + '].log';

        try
          FH := FileOpen(FLogFile, fmOpenWrite or fmShareDenyNone);
          if FH < 0 then
            FH :=FileCreate(FLogFile)
          else
            FileSeek(FH, 0, 2);
          FileWrite(FH, IntLogCash[1], Length(IntLogCash));
          FileClose(FH);
          FLastSaveTime := Now;
          IntLogCash := '';
          FLogFile := '';
        except
        end;
      end;
  except
  end;
  until Terminated;
end;

initialization
  Logger := TLogger.Create;

finalization
  Logger.Free;
  
end.


