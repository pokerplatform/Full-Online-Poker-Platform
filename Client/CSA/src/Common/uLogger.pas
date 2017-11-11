//      Project: Poker
//         Unit: uLogger.pas
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es): TLogger
//  Description: Write text to log file
//               By default, CSA write log events in llBase mode
//               User can disable logging
//               If there is special GUID key with special parameter in user machine,
//               then this user may choose logging level from these types:
//
//               llNone     - none of log event save into log file
//               llBase     - connect, disconnect, login, logout, open process, close process,
//                            exceptions and methods fails
//               llExtended - llBase (with advanced info) + objects creations and destructions,
//                            send/receive XML protocol (as received and sent - not formatted),
//                            external and internal commands started/finished,
//               llVerbose  - all log events = llExtended + formatted send/receive XML protocol,
//                            all other method logs

unit uLogger;

interface

uses
  SysUtils, Classes, Windows, ExtCtrls;

const
  SaveFileSize = 32768;
  SaveMiliSeconds = 5000;
  DefaultLogFileName = 'CSA.log';
  DefaultProcessLogFileName = 'Process.log';

type
  TLogLevel = (llNone, llBase, llExtended, llVerbose);

  TLogger = class(TDataModule)
    SaveTimer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure SaveTimerTimer(Sender: TObject);
  private
    FCurrentLogLevel: TLogLevel;
    FFormatXML: Boolean;
    FLogFilePath: String;
    FProcessLogFilePath: String;
    FLogFormatSettings: TFormatSettings;
    FLogBuffer: String;
    FProcessLogBuffer: String;
    procedure SaveToLogFile;
    procedure SaveToProcessLogFile;
  public
    procedure SaveBuffers;
    procedure Add(const LogData: String; LogLevel: TLogLevel = llVerbose;
      AddToProcessLog: Boolean = false);
  end;

var
  Logger: TLogger;

implementation

{$R *.dfm}

uses
  XMLDoc, DateUtils,
  uSessionModule,
  uConstants,
  uDataList;

procedure TLogger.DataModuleCreate(Sender: TObject);
var
  strLogLevel: String;
begin
  FLogFormatSettings.ShortDateFormat := 'mm/dd/yyyy';
  FLogFormatSettings.ShortTimeFormat := 'hh:nn:ss.zzz';
  FLogFormatSettings.LongDateFormat := 'mm/dd/yyyy';
  FLogFormatSettings.LongTimeFormat := 'hh:nn:ss.zzz';
  FLogFormatSettings.DateSeparator := '/';
  FLogFormatSettings.TimeSeparator := ':';

  FCurrentLogLevel := llNone;
  if SessionModule.SessionSettings.ValuesAsBoolean[RegistryDebugKey] then
  begin
    FCurrentLogLevel := llBase;
    strLogLevel := SessionModule.SessionSettings.ValuesAsString[RegistryDebugIdent];
    if strLogLevel = RegistryDebugExtended then
      FCurrentLogLevel := llExtended;
    if strLogLevel = RegistryDebugVerbose then
      FCurrentLogLevel := llVerbose;
    SaveTimer.Interval := SaveMiliSeconds;
    SaveTimer.Enabled := true;
    FFormatXML := SessionModule.SessionSettings.ValuesAsBoolean[RegistryFormatXMLKey];
  end;

  FLogFilePath := SessionModule.AppPath + DefaultLogFileName;
  FProcessLogFilePath := SessionModule.AppPath + DefaultProcessLogFileName;

  FProcessLogBuffer := '';
  FLogBuffer := '';
end;

procedure TLogger.DataModuleDestroy(Sender: TObject);
begin
  Add('Logger.DataModuleDestroy');
  SaveTimer.Enabled := false;
  SaveBuffers;
end;

procedure TLogger.Add(const LogData: String; LogLevel: TLogLevel = llVerbose; AddToProcessLog: Boolean = false);
Var
  LogStr: String;
begin
  if Logger <> nil then
    if LogLevel <= FCurrentLogLevel then
    try

      if FFormatXML and (copy(LogData, 1, 1) = '<') then
      try
        LogStr := FormatXMLData(LogData);
      except
        on E: Exception do
          LogStr := '['+DateTimeToStr(Now, FLogFormatSettings) + '] ' +
            E.Message + ':' + LogData;
      end
      else
        LogStr := '['+DateTimeToStr(Now, FLogFormatSettings) + '] ' + LogData;

      FLogBuffer := FLogBuffer + #13#10 + LogStr;
      if Length(FLogBuffer) > SaveFileSize then
        SaveToLogFile;

      if AddToProcessLog then
      begin
        FProcessLogBuffer :=FProcessLogBuffer + #13#10 + LogStr;
        if Length(FProcessLogBuffer) > SaveFileSize then
          SaveToProcessLogFile;
      end;
    except
    end;
end;

procedure TLogger.SaveBuffers;
begin
  if FLogBuffer <> '' then
    SaveToLogFile;
  if FProcessLogBuffer <> '' then
    SaveToProcessLogFile;
end;

procedure TLogger.SaveToLogFile;
var
  LogFile: TextFile;
  curLogBuffer: String;
begin
  curLogBuffer := FLogBuffer;
  FLogBuffer := '';
  try
    AssignFile(LogFile, FLogFilePath);
    if FileExists(FLogFilePath) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    WriteLn(LogFile, curLogBuffer);
    CloseFile(LogFile);
   except
   end;
end;

procedure TLogger.SaveToProcessLogFile;
var
  LogFile: TextFile;
  curProcessLogBuffer: String;
begin
   curProcessLogBuffer := FProcessLogBuffer;
   FProcessLogBuffer := '';
   try
    AssignFile(LogFile, FProcessLogFilePath);
    if FileExists(FProcessLogFilePath) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    WriteLn(LogFile, curProcessLogBuffer);
    CloseFile(LogFile);
   except
   end;
end;

procedure TLogger.SaveTimerTimer(Sender: TObject);
begin
  SaveBuffers;
end;

end.
