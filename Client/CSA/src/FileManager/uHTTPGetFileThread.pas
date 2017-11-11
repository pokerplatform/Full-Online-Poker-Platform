unit uHTTPGetFileThread;

interface

uses
  Classes, WinINet, Windows, SysUtils,
  uConstants, uLogger;

const
  ReadBufferSize = 4096;

type
  THTTPGetFileThread = class;

  THTTPGetFileState = (gfNone, gfStart, gfDownload, gfFailed, gfFinished);
  THTTPGetFileEvent = procedure (This: THTTPGetFileThread) of object;


  THTTPGetFileThread = class(TThread)
  private
    FFileID: Integer;
    FSessionID: Integer;
    FURL: String;
    FURLFileSize: Integer;
    FSizeCompleted: Integer;
    FFileName: String;
    FFilePath: String;
    FFileType: String;
    FFileTypeID: Integer;
    FContentTypeID: Integer;
    FVersion: Integer;
    FCurrentState: THTTPGetFileState;
    FOnUpdateState: THTTPGetFileEvent;

    procedure UpdateState;
    { Private declarations }
  protected
    procedure Execute; override;
  public
    property FileID: Integer read FFileID;
    property SessionID: Integer read FSessionID;
    property CurrentState: THTTPGetFileState read FCurrentState;
    property URL: String read FURL;
    property URLFileSize: Integer read FURLFileSize;
    property SizeCompleted: Integer read FSizeCompleted;
    property FileName: String read FFileName;
    property FilePath: String read FFilePath;
    property FileType: String read FFileType;
    property FileTypeID: Integer read FFileTypeID;
    property ContentTypeID: Integer read FContentTypeID;
    property Version: Integer read FVersion;

    constructor Create(AFileID, ASessionID, AVersion: Integer;
      AURL, AFileName, AFilePath, AFileType: String;
      AFileTypeID, AContentTypeID: Integer; AURLFileSize: Cardinal;
      AOnUpdateState: THTTPGetFileEvent);
  end;

implementation

{ THTTPGetFileThread }

constructor THTTPGetFileThread.Create(AFileID, ASessionID, AVersion: Integer;
  AURL, AFileName, AFilePath, AFileType: String;
  AFileTypeID, AContentTypeID: Integer; AURLFileSize: Cardinal;
  AOnUpdateState: THTTPGetFileEvent);
begin
  inherited Create(True);
  FFileID := AFIleID;
  FSessionID := ASessionID;
  FURL := AURL;
  FFileName := AFileName;
  FFilePath := AFilePath;
  FFileType := AFileType;
  FFileTypeID := AFileTypeID;
  FContentTypeID := AContentTypeID;
  FVersion := AVersion;
  FURLFileSize := AURLFileSize;
  FOnUpdateState := AOnUpdateState;
  FCurrentState := gfNone;
  FSizeCompleted := 0;

  FreeOnTerminate := true;
  Resume;
end;

procedure THTTPGetFileThread.Execute;
var
  hSession, hURL: HInternet;
  Headers: PChar;

  ReadBuffer: String;
  ReadBufferLength: DWORD;

  FileBuffer: String;
  FileHandle: Integer;
  Result: Boolean;
  OldSize: Integer;
begin
  // Initialize variables
  FCurrentState := gfFailed;
  Result := False;

  hSession := nil;
  hURL := nil;
  ReadBuffer := '';
  ReadBufferLength := 0;
  FileBuffer := '';

  if (FFilePath <> '') and (FURL <> '') and (FURLFileSize > 0) then
  try
    FSizeCompleted := 0;

    FCurrentState := gfStart;
    Synchronize(UpdateState);

    try
      hSession := InternetOpen(AppFileName, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
      if hSession = nil then
        raise EAbort.Create('InternetOpen failed');

      Headers := 'Accept: */*';
      hURL := InternetOpenURL(hSession, PChar(FURL), Headers, length(Headers), INTERNET_FLAG_RELOAD, 0);
      if hURL = nil then
        raise EAbort.Create('InternetOpenURL failed');

      FCurrentState := gfDownload;
      repeat
        SetLength(ReadBuffer, ReadBufferSize);
        InternetReadFile(hURL, @ReadBuffer[1], ReadBufferSize, ReadBufferLength);
        SetLength(ReadBuffer, ReadBufferLength);
        FileBuffer := FileBuffer + ReadBuffer;

        OldSize := FSizeCompleted;
        FSizeCompleted := Length(FileBuffer);
        if (not (FSizeCompleted = FURLFileSize)) and
          ((FSizeCompleted - OldSize) >= ReadBufferSize) then
          Synchronize(UpdateState);
      until (ReadBufferLength = 0) or Terminated;
    finally
      if hURL <> nil then
        InternetCloseHandle(hURL);
      if hSession <> nil then
        InternetCloseHandle(hSession);
    end;

    if not Terminated then
    begin
      FSizeCompleted := Length(FileBuffer);
      Result := FSizeCompleted = FURLFileSize;

      DeleteFile(FFilePath);

      if FileExists(FFilePath) then
        Result := False
      else
      begin
        FileHandle := FileCreate(FFilePath);
        if FileHandle > 0 then
        begin
          Result := Result and (FileWrite(FileHandle, FileBuffer[1], Length(FileBuffer)) <> -1);
          FileClose(FileHandle);
        end
        else
          Result := False;
      end;
    end;
  except
    on E: Exception do
      Logger.Add(E.Message + ', URL=' + FURL + ', FFilePath="' + FFilePath +
      '", URLFileSize=' + inttostr(FURLFileSize), llBase);
  end;

  if not Terminated then
  begin
    if Result then
      FCurrentState := gfFinished
    else
      FCurrentState := gfFailed;
    Synchronize(UpdateState);
  end;
  Terminate;     {}
end;

procedure THTTPGetFileThread.UpdateState;
begin
  if Assigned(FOnUpdateState) then
    FOnUpdateState(Self);
end;


end.
