unit uFileManagerModule;

interface

uses
  SysUtils, Classes, Windows, Contnrs,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uDataList,
  uHTTPGetFileThread,
  uConstants;

type
  TDownloadSession = class;
  TDownloadSessionType = (stSystemFiles, stCustomFiles, stProcessFiles);
  TDownloadProgressProc = procedure (This: TDownloadSession) of object;

  TDownloadSession = class
  private
    FSessionID: Integer;
    FSessionType: TDownloadSessionType;
    FDataID: Integer;
    FFilesToDownload: TDataList;
    FSessionState: THTTPGetFileState;
    FPercentCompleted: Integer;
    FOnDownloadProgress: TDownloadProgressProc;

    procedure CallEventProc;
  public
    property SessionID: Integer read FSessionID;
    property SessionType: TDownloadSessionType read FSessionType;
    property DataID: Integer read FDataID;
    property FilesToDownload: TDataList read FFilesToDownload;
    property SessionState: THTTPGetFileState read FSessionState;
    property PercentCompleted: Integer read FPercentCompleted;

    constructor Create(ASessionID, ADataID: Integer; ASessionType: TDownloadSessionType;
      ADownloadProgressProc: TDownloadProgressProc);
    destructor  Destroy; override;
  end;

  TFileManagerModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FFilesPath: String;
    FFilesToDownloadPath: String;

    FFiles: TDataList;
    FLogoFiles: TStringList;

    FDownloadSessions: TObjectList;
    FDownloadSessionCounter: Integer;

    procedure Run_GetFileInfo(XMLRoot: IXMLNode);
    procedure Run_GetProcessFiles(XMLRoot: IXMLNode);
    procedure Run_GetSystemFiles(XMLRoot: IXMLNode);
    procedure Run_GetPlayerLogo(XMLNode: IXMLNode);

    procedure OnHTTPDownloadProgress(This: THTTPGetFileThread);

    function AddNewSession(ADataID: Integer; ASessionType: TDownloadSessionType;
      ADownloadProgressProc: TDownloadProgressProc; var NewSession: TDownloadSession): Integer;
    procedure FillFilesToDownload(curSession: TDownloadSession;
      XMLRoot: IXMLNode);

    procedure StartDownload(curSession: TDownloadSession);
    procedure StopDownload(curSession: TDownloadSession);
    procedure AnalyseSession(curSession: TDownloadSession;
      FileID: Integer = 0; FileSizeCompleted: Integer = 0);
  public
    property FilesPath: String read FFilesPath;
    property FilesToDownloadPath: String read FFilesToDownloadPath;

    procedure RunCommand(XMLRoot: IXMLNode);

    function DownloadFile(FileID: Integer;
      DownloadProgressProc: TDownloadProgressProc): Integer;
    function DownloadFiles(FileID: array of Integer; DataID: Integer;
      DownloadProgressProc: TDownloadProgressProc): Integer;

    function DownloadSystemFiles(
      DownloadProgressProc: TDownloadProgressProc): Integer;
    function DownloadProcessFiles(ProcessID: Integer;
      DownloadProgressProc: TDownloadProgressProc): Integer;

    function DownloadPlayerLogoFiles(UserID: Integer; Version: Integer;DownloadProgressProc: TDownloadProgressProc): Integer;

    procedure StopDownloadFiles(SessionID: Integer);

    procedure FillLogoFiles(XMLRoot: IXMLNode);
 end;

var
  FileManagerModule: TFileManagerModule;

implementation

uses
  uSessionModule,
  uParserModule,
  uLogger;

{$R *.dfm}


{ TDownloadSession }

constructor TDownloadSession.Create(ASessionID, ADataID: Integer;
  ASessionType: TDownloadSessionType; ADownloadProgressProc: TDownloadProgressProc);
begin
  inherited Create;

  FSessionID := ASessionID;
  FDataID := ADataID;
  FSessionType := ASessionType;
  FFilesToDownload := TDataList.Create(0, nil);
  FOnDownloadProgress := ADownloadProgressProc;
  FSessionState := gfNone;
  FPercentCompleted := 0;
end;

destructor TDownloadSession.Destroy;
begin
  FFilesToDownload.Free;
  FOnDownloadProgress := nil;
  FSessionState := gfNone;
  FPercentCompleted := 0;

  inherited;
end;

procedure TDownloadSession.CallEventProc;
begin
  if Assigned(FOnDownloadProgress) then
  try
    FOnDownloadProgress(Self);
  except
    on E: Exception do
      Logger.Add('TDownloadSession.CallEventProc: ' + E.Message, llBase);
  end;
end;


{ TFileManagerModule }

procedure TFileManagerModule.DataModuleCreate(Sender: TObject);
var
  Loop: Integer;
  curFile: TDataList;
  NeedDelete: Boolean;
  FileName: String;
  FileToSize: File;
begin
  FFilesPath := SessionModule.AppPath + FilesFolderName;
  FFilesToDownloadPath := FFilesPath + FilesToDownloadFolderName;
  ForceDirectories(FFilesPath);
  ForceDirectories(FFilesToDownloadPath);

  FDownloadSessionCounter := 1;
  FDownloadSessions := TObjectList.Create;
  FLogoFiles := TStringList.Create;

  FFiles := TDataList.Create(0, nil);
  FFiles.LoadFromFile(FFilesPath + FileListXMLFileName);
  for Loop := FFiles.Count - 1 downto 0 do
  begin
    NeedDelete := true;
    curFile := FFiles.Items(Loop);
    if curFile <> nil then
      if curFile.ValuesAsInteger[DATANAME_VERSION] > 0 then
      begin
        FileName := FFilesPath + curFile.ValuesAsString['name'];
        if FileExists(FileName) then
        begin
         AssignFile(FileToSize, FileName);
         Reset(FileToSize, 1);
         if FileSize(FileToSize) = curFile.ValuesAsInteger['size'] then
           NeedDelete := false;
         CloseFile(FileToSize);
        end;
      end;
    if NeedDelete then
      FFiles.Delete(Loop);
  end;
end;

procedure TFileManagerModule.DataModuleDestroy(Sender: TObject);
begin
  FDownloadSessions.Free;
  FLogoFiles.Free;
  FFiles.SaveToFile(FFilesPath + FileListXMLFileName, FileListXMLRootNodeName);
  FFiles.Free;
end;

function TFileManagerModule.AddNewSession(ADataID: Integer; ASessionType: TDownloadSessionType;
  ADownloadProgressProc: TDownloadProgressProc; var NewSession: TDownloadSession): Integer;
begin
  Result := FDownloadSessionCounter;
  NewSession := TDownloadSession.Create(Result, ADataID, ASessionType, ADownloadProgressProc);
  FDownloadSessions.Add(NewSession);
  Inc(FDownloadSessionCounter);
end;

// Public calls

procedure TFileManagerModule.FillLogoFiles(XMLRoot: IXMLNode);
var
  Loop: Integer;
begin
  for Loop := 0 to FLogoFiles.Count - 1 do
    XMLRoot.AddChild('logo').Attributes['filename'] := FLogoFiles.Strings[Loop];
end;

function TFileManagerModule.DownloadFile(FileID: Integer;
  DownloadProgressProc: TDownloadProgressProc): Integer;
begin
  Result := DownloadFiles([FileID], 0, DownloadProgressProc);
end;

function TFileManagerModule.DownloadFiles(FileID: array of Integer; DataID: Integer;
  DownloadProgressProc: TDownloadProgressProc): Integer;
var
  curSession: TDownloadSession;
  Loop: Integer;
  AllRight: Boolean;
begin
  Result := AddNewSession(DataID, stCustomFiles, DownloadProgressProc, curSession);
  AllRight := True;
  curSession.FilesToDownload.ClearItems(Length(FileID));
  for Loop := 0 to Length(FileID) - 1 do
    with curSession.FilesToDownload.AddItem(FileID[Loop], Loop) do
    begin
      Value := gfNone;
      ValuesAsInteger[DATANAME_VERSION] := 0;
      ValuesAsInteger['size'] := 0;
      ValuesAsInteger['contenttypeid'] := 0;
      ValuesAsInteger['filetypeid'] := 0;
      ValuesAsString['filetype'] := '';
      ValuesAsString['name'] := '';
      ValuesAsString['location'] := '';
      AllRight := AllRight and ParserModule.Send_GetFileInfo(FileID[Loop]);
    end;
  if AllRight then
    curSession.FSessionState := gfStart
  else
    curSession.FSessionState := gfFailed;
  curSession.CallEventProc;
  if not AllRight then
  begin
    StopDownload(curSession);
    Result := -1;
  end;
end;

function TFileManagerModule.DownloadProcessFiles(ProcessID: Integer;
  DownloadProgressProc: TDownloadProgressProc): Integer;
var
  curSession: TDownloadSession;
  AllRight: Boolean;
begin
  Result := AddNewSession(ProcessID, stProcessFiles, DownloadProgressProc, curSession);
  AllRight := ParserModule.Send_GetProcessFiles(ProcessID);
  if AllRight then
    curSession.FSessionState := gfStart
  else
    curSession.FSessionState := gfFailed;
  curSession.CallEventProc;
  if not AllRight then
  begin
    StopDownload(curSession);
    Result := -1;
  end;
end;

function TFileManagerModule.DownloadSystemFiles(
  DownloadProgressProc: TDownloadProgressProc): Integer;
var
  curSession: TDownloadSession;
  AllRight: Boolean;
begin
  Result := AddNewSession(-1, stSystemFiles, DownloadProgressProc, curSession);
  AllRight := ParserModule.Send_GetSystemFiles;
  if AllRight then
    curSession.FSessionState := gfStart
  else
    curSession.FSessionState := gfFailed;
  curSession.CallEventProc;
  if not AllRight then
  begin
    StopDownload(curSession);
    Result := -1;
  end;
end;

function TFileManagerModule.DownloadPlayerLogoFiles(UserID: Integer; Version: Integer;DownloadProgressProc: TDownloadProgressProc): Integer;
var
  curSession: TDownloadSession;
  AllRight: Boolean;
  ExistedFile: TDataList;
  DoDowloadAvatar: Boolean;
begin
 Result := -1;
 DoDowloadAvatar := false;
 if FFiles.Find(UserID, ExistedFile) then
 begin
  if (Version > ExistedFile.ValuesAsInteger[DATANAME_VERSION]) then
   DoDowloadAvatar := true
  else
   DoDowloadAvatar := false;
 end
 else
   DoDowloadAvatar := true;

 if DoDowloadAvatar then
 begin
  Result := AddNewSession(UserID,stProcessFiles, DownloadProgressProc, curSession);
  AllRight := ParserModule.Send_GetPlayerLogo(UserID);
  if AllRight then
   curSession.FSessionState := gfStart
  else
  begin
   curSession.FSessionState := gfFailed;
   StopDownload(curSession);
   Result := -1;
  end;
 end;
end;
// Server responces parsing

procedure TFileManagerModule.RunCommand(XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Add('FileManagerModule.RunCommand started', llExtended);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := XMLNode.NodeName;
        Logger.Add('FileManagerModule.RunCommand found ' + strNode, llExtended);

        if strNode = 'fmgetfileinfo' then
          Run_GetFileInfo(XMLNode)
        else
        if strNode = 'fmgetprocessfiles' then
          Run_GetProcessFiles(XMLNode)
        else
        if strNode = 'fmgetsystemfiles' then
          Run_GetSystemFiles(XMLNode)
        else
        if strNode = 'fmgetplayerlogo' then
         Run_GetPlayerLogo(XMLNode);  

      end;
  except
    Logger.Add('FileManagerModule.RunCommand failed', llBase);
  end;
end;

procedure TFileManagerModule.Run_GetFileInfo(XMLRoot: IXMLNode);
{
<object name="filemanager">
  <fmgetfileinfo result="0|..."
     fileid="1213"
     filetype="htm"
     filetypeid="1"
     version="2"
     name="holdem.swf"
     location="http://poker.com/files/1213.bin"
     size="123456"/>
</object>
}
var
  ErrorCode: Integer;
  Loop: Integer;
  Loop2: Integer;
  FileID: Integer;
  curSession: TDownloadSession;
  curFile: TDataList;
  AllFilesReady: Boolean;
begin
  if not ParserModule.GetResult(XMLRoot, ErrorCode, False) then
  Exit;

  FileID := strtointdef(XMLRoot.Attributes['fileid'], 0);
  if FileID <= 0 then
  Exit;

  for Loop := FDownloadSessions.Count - 1 downto 0 do
  begin
    curSession := TDownloadSession(FDownloadSessions.Items[Loop]);
    if (curSession.SessionType = stCustomFiles) and (curSession.SessionState = gfStart) and
      (curSession.FFilesToDownload.Find(FileID, curFile)) then
      if curFile.Value = gfNone then
      begin
        curFile.LoadFromXML(XMLRoot);
        curFile.Value := gfStart;
        AllFilesReady := True;
        for Loop2 := 0 to curSession.FFilesToDownload.Count - 1 do
          if curSession.FFilesToDownload.Items(Loop2).Value = gfNone then
          begin
            AllFilesReady := False;
            break;
          end;
        if AllFilesReady then
          StartDownload(curSession);
      end;
  end;
end;

procedure TFileManagerModule.Run_GetProcessFiles(XMLRoot: IXMLNode);
{
<object name="filemanager">
  <fmgetprocessfiles result="0|..." processid="234" gameengineid="1">
    <file fileid="1213"
     filetype="swf"
     filetypeid="1"
     contenttypeid="1"
     version="2"
     name="game.swf"
     location="http://poker.com/files/1213.bin"
     size="123456"/>
  <fmgetprocessfiles>
</object>
}
var
  Loop: Integer;
  ProcessID: Integer;
  curSession: TDownloadSession;
begin
  ProcessID := strtointdef(XMLRoot.Attributes['processid'], 0);
  for Loop := 0 to FDownloadSessions.Count - 1 do
  begin
    curSession := TDownloadSession(FDownloadSessions.Items[Loop]);
    if (curSession.DataID = ProcessID) and
      (curSession.SessionType = stProcessFiles) and (curSession.SessionState = gfStart) then
      FillFilesToDownload(curSession, XMLRoot);
  end;
end;

procedure TFileManagerModule.Run_GetSystemFiles(XMLRoot: IXMLNode);
{
<object name="filemanager">
  <fmgetsystemfiles result="0|...">
    <file fileid="1213"
     filetype="swf"
     filetypeid="1"
     contenttypeid="1"
     version="2"
     name="game.swf"
     location="http://poker.com/files/1213.bin"
     size="123456"/>
  </fmgetsystemfiles>
</object>
}
var
  Loop: Integer;
  curSession: TDownloadSession;
  FileName: String;
begin
  // Check for Download needed
  if FDownloadSessions.Count > 0 then
    for Loop := 0 to FDownloadSessions.Count - 1 do
    begin
      curSession := TDownloadSession(FDownloadSessions.Items[Loop]);
      if (curSession.FSessionType = stSystemFiles) and (curSession.SessionState = gfStart) then
        FillFilesToDownload(curSession, XMLRoot);
    end;

  // Fill Logo Files
  FLogoFiles.Clear;
  for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
  begin
    FileName := XMLRoot.ChildNodes.Nodes[Loop].Attributes['name'];
    if lowercase(copy(FileName, 1, 4)) = 'logo' then
      FLogoFiles.Add(FileName);
  end;
end;

procedure TFileManagerModule.Run_GetPlayerLogo(XMLNode: IXMLNode);
{
<object name="filemanager">
  <fmgetplayerlogo result="0|...">
    <file
     version="12"
     userid="1212"
     name="game.swf"
     location="http://poker.com/files/Avatar/1213.jpg"
     size="123456"/>
  </fmgetplayerlogo>
</object>
}
var
  UserID: Integer;
  Loop: Integer;
  curSession: TDownloadSession;
begin
  UserID := 0;
  if XMLNode.ChildNodes.Count > 0 then
  begin
   UserID := XMLNode.ChildNodes[0].Attributes['userid'];
   XMLNode.ChildNodes[0].Attributes['fileid'] := UserID;
  end;

  for Loop := 0 to FDownloadSessions.Count - 1 do
  begin
    curSession := TDownloadSession(FDownloadSessions.Items[Loop]);
    if (curSession.DataID = UserID) and
      (curSession.SessionType = stProcessFiles) and (curSession.SessionState = gfStart) then
      FillFilesToDownload(curSession, XMLNode);
  end;
end;

procedure TFileManagerModule.FillFilesToDownload(curSession: TDownloadSession; XMLRoot: IXMLNode);
var
  ErrorCode: Integer;
  Loop: Integer;
  curData: TDataList;
  ItemsCount: Integer;
  XMLNode: IXMLNode;
begin
  if curSession = nil then
    Exit;
  if (curSession.SessionState <> gfStart) or (curSession.FFilesToDownload.Count > 0) or
    (not ParserModule.GetResult(XMLRoot, ErrorCode, False)) then
  begin
    curSession.FSessionState := gfFailed;
    curSession.CallEventProc;
    StopDownload(curSession);
    Exit;
  end;

  ItemsCount := XMLRoot.ChildNodes.Count;
  curSession.FFilesToDownload.ClearItems(ItemsCount);
  for Loop := 0 to ItemsCount - 1 do
  begin
    XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
    curData := curSession.FFilesToDownload.AddItem(
      strtointdef(XMLNode.Attributes['fileid'], 0), Loop);
    curData.LoadFromXML(XMLNode);
    curData.Value := gfStart;
  end;
  StartDownload(curSession);
end;


// Start/Stop downloading files

procedure TFileManagerModule.StopDownload(curSession: TDownloadSession);
begin
  FDownloadSessions.Remove(curSession);
  FFiles.SaveToFile(FFilesPath + FileListXMLFileName, FileListXMLRootNodeName);
end;

procedure TFileManagerModule.StopDownloadFiles(SessionID: Integer);
var
  Loop: Integer;
  curSession: TDownloadSession;
begin
  for Loop := FDownloadSessions.Count - 1 downto 0 do
  begin
    curSession := TDownloadSession(FDownloadSessions.Items[Loop]);
    if curSession.FSessionID = SessionID then
      FDownloadSessions.Delete(Loop);
  end;
  FFiles.SaveToFile(FFilesPath + FileListXMLFileName, FileListXMLRootNodeName);
end;

procedure TFileManagerModule.StartDownload(curSession: TDownloadSession);
begin
  if curSession = nil then
    Exit;

  if curSession.FSessionState <> gfStart then
  begin
    curSession.FSessionState := gfFailed;
    curSession.CallEventProc;
    StopDownload(curSession);
    Exit;
  end;

  if curSession.FFilesToDownload.Count = 0 then
  begin
    curSession.FSessionState := gfFinished;
    curSession.CallEventProc;
    StopDownload(curSession);
    Exit;
  end;

  curSession.FSessionState := gfDownload;
  AnalyseSession(curSession);
end;

procedure TFileManagerModule.AnalyseSession(curSession: TDownloadSession;
  FileID: Integer = 0; FileSizeCompleted: Integer = 0);
var
  Loop: Integer;
  curFile: TDataList;
  ExistedFile: TDataList;
  FileToDownload: TDataList;
  FileSize: Integer;
  SizeToDownload: Integer;
  SizeFinished: Integer;
  SessionDownloading: Boolean;
  SessionFinished: Boolean;
  SessionFailed: Boolean;
begin
  SizeToDownload := 0;
  SizeFinished := 0;
  FileToDownload := nil;
  SessionDownloading := False;
  SessionFinished := True;
  SessionFailed := False;

  for Loop := 0 to curSession.FFilesToDownload.Count - 1 do
  begin
    curFile := curSession.FFilesToDownload.Items(Loop);
    FileSize := curFile.ValuesAsInteger['size'];
    if (curFile.Value = gfNone) or (curFile.Value = gfFailed) or (FileSize = 0) then
    begin
      SessionFailed := True;
      Break;
    end;

    if (FileID <> 0) and (FileSizeCompleted > 0) and (FileID = curFile.ID) then
      curFile.ValuesAsInteger[DATANAME_SIZECOMPLETED] := FileSizeCompleted;

    if curFile.Value <> gfFinished then
      if FFiles.Find(curFile.ID, ExistedFile) then
        if (curFile.ValuesAsInteger[DATANAME_VERSION] =
          ExistedFile.ValuesAsInteger[DATANAME_VERSION]) and
         (FileSize = ExistedFile.ValuesAsInteger['size']) then
        begin
          curFile.Value := gfFinished;
          curFile.ValuesAsInteger[DATANAME_SIZECOMPLETED] := FileSize;
        end;

    if (curFile.Value = gfStart) and (FileToDownload = nil) then
      FileToDownload := curFile;

    if curFile.Value = gfDownload then
      SessionDownloading := True;

    SessionFinished := SessionFinished and (curFile.Value = gfFinished);
    SizeToDownload := SizeToDownload + FileSize;
    SizeFinished := SizeFinished + curFile.ValuesAsInteger[DATANAME_SIZECOMPLETED];
  end;

  if SessionFailed or (SizeToDownload <= 0) or
   (SessionFinished and (SizeFinished <> SizeToDownload)) or
   ((not SessionFinished) and (SizeFinished = SizeToDownload)) or
   ((not SessionFinished) and (not SessionDownloading) and (FileToDownload = nil)) then
  begin
    curSession.FSessionState := gfFailed;
    curSession.FPercentCompleted := 0;
    curSession.CallEventProc;
    StopDownload(curSession);
  end
  else
  begin
    curSession.FPercentCompleted := Round(100 * SizeFinished / SizeToDownload);
    if curSession.FPercentCompleted > 100 then curSession.FPercentCompleted := 100;
    if curSession.FPercentCompleted < 0 then curSession.FPercentCompleted := 0;

    if SessionFinished then
    begin
      curSession.FSessionState := gfFinished;
      curSession.CallEventProc;
      StopDownload(curSession);
    end
    else
    begin
      if curSession.PercentCompleted > 0 then
        curSession.FSessionState := gfDownload
      else
        curSession.FSessionState := gfStart;
      curSession.CallEventProc;

      if (not SessionDownloading) and (FileToDownload <> nil) then
      begin
        FileToDownload.Value := gfDownload;
        FileToDownload.ValuesAsInteger[DATANAME_SIZECOMPLETED] := 0;

        // Start download
        THTTPGetFileThread.Create(
          FileToDownload.ID, curSession.SessionID,
          FileToDownload.ValuesAsInteger['version'],
          FileToDownload.ValuesAsString['location'],
          FileToDownload.ValuesAsString['name'],
          FFilesToDownloadPath + FileToDownload.ValuesAsString['name'],
          FileToDownload.ValuesAsString['filetype'],
          FileToDownload.ValuesAsInteger['filetypeid'],
          FileToDownload.ValuesAsInteger['contenttypeid'],
          FileToDownload.ValuesAsInteger['size'],
          OnHTTPDownloadProgress);
      end;
    end;
  end;
end;

procedure TFileManagerModule.OnHTTPDownloadProgress(This: THTTPGetFileThread);
var
  curSession: TDownloadSession;
  Loop: Integer;
  curFile: TDataList;
begin
  if (This.FileID <= 0) or (This.SessionID <= 0) then
  begin
    This.Terminate;
    Exit;
  end;

  curSession := nil;
  for Loop := FDownloadSessions.Count - 1 downto 0 do
  begin
    curSession := TDownloadSession(FDownloadSessions.Items[Loop]);
    if curSession.SessionID = This.SessionID then
      Break
    else
      if Loop = 0 then
      begin
        This.Terminate;
        Exit;
      end;
  end;

  if (This.CurrentState = gfFailed) or
    (This.CurrentState = gfNone) or (This.CurrentState = gfStart) then
    curSession.FSessionState := gfFailed;

  if This.CurrentState = gfFinished then
  begin
      DeleteFile(PChar(FFilesPath + This.FileName));
      if CopyFile(PChar(This.FilePath), PChar(FFilesPath + This.FileName), True) then
      begin
        DeleteFile(PChar(This.FilePath));
        curFile := FFiles.Add(This.FileID);
        curFile.ValuesAsString['name'] := This.FileName;
        curFile.ValuesAsInteger['size'] := This.SizeCompleted;
        curFile.ValuesAsInteger['version'] := This.Version;
        curFile.ValuesAsString['filetype'] := This.FileType;
        curFile.ValuesAsInteger['filetypeid'] := This.FileTypeID;
        curFile.ValuesAsInteger['contenttypeid'] := This.ContentTypeID;
      end
      else
      begin
        curSession.FSessionState := gfFailed;
        Logger.Add('FileManagerModule.OnHTTPDownloadProgress copy failed: ' + This.FileName);
      end;
    end;

  AnalyseSession(curSession, This.FileID, This.SizeCompleted);
end;





end.
