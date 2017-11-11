unit uLogger;

interface

uses
  SysUtils, Classes, Windows, Messages, DateUtils, SyncObjs, DXString,
  uSettings, uLocker;

const
  MaxLogCacheSize = 65536;
  SaveTime_Sec = 10;

type
  TLogType = (ltBase, ltCall, ltRequest, ltResponse, ltError, ltException);

  TLogger = class (TThread)
  private
    FLogFormatSettings: TFormatSettings;
    FServiceName: String;
    FLogPath: String;
    FLogCache: String;
    FSystemLogCache: String;
    FCriticalSection: TLocker;

    function GetLogLine(const ClassName, MethodName, LogData: String;
      LogType: TLogType): String;

    procedure SaveLogFile;
    procedure SaveSystemLogFile;
    procedure SaveFile(const FileName, Data: String);
  protected
    procedure Execute; override;
  public
    procedure Log(const ClassName, MethodName, LogData : String; LogType: TLogType);
    procedure SystemLog(const ClassName, MethodName, LogData : String; LogType: TLogType);

    constructor Create(LogFolder, ServiceName: String);
    destructor Destroy; override;
  end;


implementation

uses uCommonDataModule;

{ TLogger }

constructor TLogger.Create(LogFolder, ServiceName: string);
begin
  inherited Create(True);

  FLogFormatSettings.ShortDateFormat := 'mm/dd/yyyy';
  FLogFormatSettings.ShortTimeFormat := 'hh:nn:ss.zzz';
  FLogFormatSettings.LongDateFormat := 'mm/dd/yyyy';
  FLogFormatSettings.LongTimeFormat := 'hh:nn:ss.zzz';
  FLogFormatSettings.DateSeparator := '/';
  FLogFormatSettings.TimeSeparator := ':';

  FServiceName := ServiceName;
  FLogPath := StringReplace(
    LogFolder + '\' + FServiceName + '\', '\\', '\', [rfReplaceAll, rfIgnoreCase]);
  ForceDirectories(FLogPath);

  FLogCache := '';
  FSystemLogCache := '';
  FCriticalSection := CommonDataModule.ThreadLockHost.Add('logger');

  Resume;
end;

destructor TLogger.Destroy;
begin
  Terminate;

  SaveLogFile;
  SaveSystemLogFile;

  WaitFor;

  CommonDataModule.ThreadLockHost.Del(FCriticalSection);

  inherited;
end;

function TLogger.GetLogLine(const ClassName, MethodName, LogData : String; LogType: TLogType): String;
var
  TypeName: String;
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

  Result := TypeName + '|' + DateTimeToStr(Now, FLogFormatSettings) + '|' +
    FServiceName + '|' + ClassName + '|' + MethodName + '|' + LogData + #13#10;
    
  TypeName := '';
end;

procedure TLogger.Log(const ClassName, MethodName, LogData : String; LogType: TLogType);
var
  CurLogLine: String;
begin
  CurLogLine := GetLogLine(ClassName, MethodName, LogData, LogType);

  FCriticalSection.Lock;
  try
    FLogCache := FLogCache + CurLogLine;
  finally
    FCriticalSection.UnLock;
  end;

  CurLogLine := '';
end;

procedure TLogger.SystemLog(const ClassName, MethodName, LogData: String; LogType: TLogType);
var
  CurLogLine: String;
begin
  CurLogLine := GetLogLine(ClassName, MethodName, LogData, LogType);

  FCriticalSection.Lock;
  try
    FSystemLogCache := FSystemLogCache + CurLogLine;
  finally
    FCriticalSection.UnLock;
  end;

  CurLogLine := '';
end;

procedure TLogger.SaveLogFile;
var
  LogFile: String;
  LogLines: String;
  AYear, AMonth, ADay, AHour,
  AMinute, ASecond, AMilliSecond: Word;
begin
  FCriticalSection.Lock;
  try
    LogLines := FLogCache;
    FLogCache := '';
  finally
    FCriticalSection.UnLock;
  end;

  DecodeDateTime(now, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);

  LogFile := FLogPath +
    FormatFloat('0000', AYear) + '_' + FormatFloat('00', AMonth) + '_' + FormatFloat('00', ADay) +
    '[' + FormatFloat('00', AHour) + '_' + FormatFloat('00', AMinute) + '].log';

  SaveFile(LogFile, LogLines);
  LogLines := '';
end;

procedure TLogger.SaveSystemLogFile;
var
  LogFile: String;
  LogLines: String;
begin
  FCriticalSection.Lock;
  try
    LogLines := FSystemLogCache;
    FSystemLogCache := '';
  finally
    FCriticalSection.UnLock;
  end;

  LogFile := FLogPath + '_System.log';
  SaveFile(LogFile, LogLines);
  LogLines := '';
end;

procedure TLogger.SaveFile(const FileName, Data: String);
var
  LogFile: TextFile;
begin
  if (FileName <> '') and (Data <> '') then
  try
    AssignFile(LogFile, FileName);
    if FileExists(FileName) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    Write(LogFile, Data);
    CloseFile(LogFile);
  except
  end;
end;

{ TLoggerThread }

procedure TLogger.Execute;
var
  LastLogSaveTime: TDateTime;
  LastSystemLogSaveTime: TDateTime;
  LogCacheLength: Integer;
  SystemLogCacheLength: Integer;
begin
  inherited;

  LastLogSaveTime := Now;
  LastSystemLogSaveTime := Now;

  while not Terminated do
  try
    FCriticalSection.Lock;
    try
      LogCacheLength := Length(FLogCache);
      SystemLogCacheLength := Length(FSystemLogCache);
    finally
      FCriticalSection.UnLock;
    end;

    if (LogCacheLength > MaxLogCacheSize) or Terminated or
      (SecondsBetween(Now, LastLogSaveTime) > SaveTime_Sec) then
    begin
      SaveLogFile;
      LastLogSaveTime := Now;
    end;

    if (SystemLogCacheLength > MaxLogCacheSize) or Terminated or
      (SecondsBetween(Now, LastSystemLogSaveTime) > SaveTime_Sec) then
    begin
      SaveSystemLogFile;
      LastSystemLogSaveTime := Now;
    end;

    Sleep(500);
  except
  end;
end;

end.

