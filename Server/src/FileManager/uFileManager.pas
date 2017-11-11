unit uFileManager;

interface

uses
  xmldom, XMLIntf, msxmldom, XMLDoc, Contnrs,
  uInfoCash, uFMActions;

type
  TFileManager = class
  private
    FRequest : TfmActions;
    FResponse: TfmRespActions;

    procedure ProcessGetFileInfo(aAction: TfmAction);
    procedure ProcessGetProcessFiles(aAction: TfmAction);
    procedure ProcessGetSystemFiles(aAction: TfmAction);
    procedure ProcessGetPlayerLogo(aAction: TfmAction);
    procedure ProcessGetPushingContentFiles(aAction: TfmAction);
    //
    function GetResponseXMLOnError(NodeName: string; ErrorCode: Integer): string;
  public
    property Request   : TfmActions read FRequest;
    property Response  : TfmRespActions read FResponse;
    //
    function ProcessAction(ActionsNode: IXMLNode): Integer;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, Classes, StrUtils, DB, Variants
  , uCommonDataModule
  , uLogger
  , uXMLConstants
  , uErrorConstants
  , uSQLAdapter
  , uObjectPool
  , uCacheContainer
  , uApi;

{ TFileManager }

constructor TFileManager.Create;
begin
  inherited;
  FRequest := TfmActions.Create;
  FResponse := TfmRespActions.Create;
  CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
end;

destructor TFileManager.Destroy;
begin
  FRequest.Free;
  FResponse.Free;
  CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  inherited;
end;

function TFileManager.GetResponseXMLOnError(NodeName: string; ErrorCode: Integer): string;
begin
  Result :=
    '<' + NodeName + ' result="' + IntToStr(ErrorCode) + '"/>';
end;

procedure TFileManager.ProcessGetFileInfo(aAction: TfmAction);
var
  rs: TDataSet;//_RecordSet; //recordset
  sSQL: string;
  FSQL: TSQLAdapter;
  FileId: integer;
  sXML: string;
  //
  sFileID,
  sFileType,
  sLocation,
  sName,
  sFileTypeID,
  sSize,
  sVersion: string;
begin
  if aAction = nil then begin
    CommonDataModule.Log(ClassName, 'IsProcessGetFileInfo',
      '[ERROR] current action is nil', ltError
    );
    Exit;
  end;

  // Get Request Info
  FileId := StrToIntDef(aAction.ActionNode.Attributes['fileid'], 0);
  if FileId <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessGetFileInfo',
      '[ERROR] Request action has not valid attribute fileid' +
      '; Params: Action=' + aAction.ActionNode.XML,
      ltError
    );

    Response.Add(
      GetResponseXMLOnError(aAction.Name, FM_ERR_CORRUPTREQUESTARGUMENTS),
      aAction.SessionID, aAction.UserID
    );
    Exit;
  end;

  if CommonDataModule.ObjectPool.GetFileInfoCache.GetCachedString(FileId, sXML) then
  begin
    // get Category info
    sSQL := 'exec fmnGetFileInfo '+inttostr(FileId);  // prepare query
    FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      rs := FSQL.Execute(sSQL);
    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetFileInfo',
          '[EXCEPTION] On execute fmnGetFileInfo:' + E.Message +
          '; Params: Action=' + aAction.ActionNode.XML,
          ltException
        );

        Response.Add(
          GetResponseXMLOnError(aAction.Name, FM_ERR_SQLEXCEPTION),
          aAction.SessionID, aAction.UserID
        );

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Exit;
      end;
    end;

    try
      if not rs.Eof then begin
        sFileID   := rs.FieldValues['id'];
        sFileType := rs.FieldValues['filetype'];
        sLocation := rs.FieldValues['location'];
        sName     := rs.FieldValues['name'];
        sFileTypeID := rs.FieldValues['filetypeid'];
        sSize     := rs.FieldValues['size'];
        sVersion  := rs.FieldValues['version'];
      end
      else begin
        CommonDataModule.Log(ClassName, 'ProcessGetFileInfo',
          '[ERROR] File not found' +
          '; Params: Action=' + aAction.ActionNode.XML,
          ltError
        );

        Response.Add(
          GetResponseXMLOnError(aAction.Name, FM_ERR_FILENOTFOUND),
          aAction.SessionID, aAction.UserID
        );

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Exit;
      end;
    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetFileInfo',
          '[EXCEPTION] On get parameters from recordset:' + e.Message +
          '; Params: Action=' + aAction.ActionNode.XML,
          ltException
        );

        Response.Add(
          GetResponseXMLOnError(aAction.Name, FM_ERR_SQLEXCEPTION),
          aAction.SessionID, aAction.UserID
        );

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Exit;
      end;
    end;

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);

    // notify user about result using response packet
    sXML :=
      '<fmgetfileinfo ' +
        'result="0" ' +
        'fileid="' + sFileID + '" ' +
        'filetype="' + sFileType  + '" ' +
        'filetypeid="' + sFileTypeID  + '" ' +
        'version="' + sVersion + '" ' +
        'name="' + sName + '" ' +
        'location="' + sLocation + '" ' +
        'size="' + sSize + '"' +
      '/>';

    CommonDataModule.ObjectPool.GetFileInfoCache.SetCachedString(FileID, sXML);
  end;

  Response.Add(sXML, aAction.SessionID, aAction.UserID);

end;

procedure TFileManager.ProcessGetProcessFiles(aAction: TfmAction);
var
  sXML: string;
  sSQL: string;
  FSql: TSQLAdapter;
  ProcessID: Integer;
  AffiliateID: Integer;
  RS: TDataSet;
begin
  ProcessID := StrToIntDef(aAction.ActionNode.Attributes['processid'], 0);
  AffiliateID := StrToIntDef(aAction.ActionNode.Attributes['affiliateid'], 1);
  if ProcessID <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessGetProcessFiles',
      '[ERROR] Request action has not valid attribute ProcessID' +
      '; Params: Action=' + aAction.ActionNode.XML,
      ltError
    );

    Response.Add(
      GetResponseXMLOnError(aAction.Name, FM_ERR_CORRUPTREQUESTARGUMENTS),
      aAction.SessionID, aAction.UserID
    );
    Exit;
  end;

  if CommonDataModule.ObjectPool.GetProcessFilesCache.GetCachedString(ProcessID, sXML) then
  begin
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      sSQL := 'exec fmnGetGameProcessFiles ' + IntToStr(ProcessID) + ',' + IntToStr(AffiliateID);
      RS := FSql.Execute(sSQL);
//      sXML := FSql.ExecuteForXML(sSQL);
      sXML := '';
      while not RS.Eof do begin
        sXML := sXML +
          '<file fileid="' + RS.FieldByName('fileid').AsString + '" ' +
            'name="' + RS.FieldByName('name').AsString + '" ' +
            'location="' + RS.FieldByName('location').AsString + '" ' +
            'filetype="' + RS.FieldByName('filetype').AsString + '" ' +
            'version="' + RS.FieldByName('version').AsString + '" ' +
            'size="' + RS.FieldByName('size').AsString + '" ' +
            'contenttypeid="' + RS.FieldByName('contenttypeid').AsString + '" ' +
            'filetypeid="' + RS.FieldByName('filetypeid').AsString + '" ' +
          '/>';

        RS.Next;
      end;

    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetProcessFiles',
          '[EXCEPTION] On execute fmnGetGameProcessFiles:' + E.Message +
          '; Params: Action=' + aAction.ActionNode.XML,
          ltException
        );

        Response.Add(
          GetResponseXMLOnError(aAction.Name, FM_ERR_SQLEXCEPTION),
          aAction.SessionID, aAction.UserID
        );

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Exit;
      end;
    end;

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

    sXML :=
      '<fmgetprocessfiles ' +
          'result="0" ' +
          'processid="' + IntToStr(ProcessID) + '">' +
        sXML +
      '</fmgetprocessfiles>';

    CommonDataModule.ObjectPool.GetProcessFilesCache.SetCachedString(ProcessID, sXML);
  end;

  Response.Add(sXML, aAction.SessionID, aAction.UserID);
end;

procedure TFileManager.ProcessGetSystemFiles(aAction: TfmAction);
var
  sXML : string;
  sSQL : string;
  FSql: TSQLAdapter;
  AffiliateID: Integer;
  RS: TDataSet;
begin
  AffiliateID := StrToIntDef(aAction.ActionNode.Attributes['affiliateid'], 1);
  if CommonDataModule.ObjectPool.GetSystemFilesCache.GetCachedString(AffiliateID, sXML) then
  begin
    // get SubCategory format info
    CommonDataModule.Log(ClassName, 'ProcessGetSystemFiles',
      'fmnGetSystemFiles enter with aff=' + inttostr(AffiliateID), ltCall);

    sSQL := 'exec fmnGetSystemFiles ' + inttostr(AffiliateID);  // prepare query
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      RS := FSql.Execute(sSQL);

      sXML := '';
      while not RS.Eof do begin
        sXML := sXML +
          '<file ' +
            'fileid="' + VarToStr(RS.FieldValues['fileid']) + '" ' +
            'name="' + VarToStr(RS.FieldValues['name']) + '" ' +
            'location="' + VarToStr(RS.FieldValues['location']) + '" ' +
            'filetype="' + VarToStr(RS.FieldValues['filetype']) + '" ' +
            'version="' + VarToStr(RS.FieldValues['version']) + '" ' +
            'size="' + VarToStr(RS.FieldValues['size']) + '" ' +
            'contenttypeid="' + VarToStr(RS.FieldValues['contenttypeid']) + '" ' +
            'contenttypename="' + VarToStr(RS.FieldValues['contenttypename']) + '" ' +
            'filetypeid="' + VarToStr(RS.FieldValues['filetypeid']) + '" ' +
          '/>';

        RS.Next;
      end;
    except
      on e: Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetSystemFiles',
          '[EXCEPTION] On exec fmnGetSystemFiles "' + inttostr(AffiliateID) + '": Message=' + e.Message,
          ltException);
        sXML := '';
      end;
    end;
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    CommonDataModule.Log(ClassName, 'ProcessGetSystemFiles',
      'fmnGetSystemFiles quit with aff=' + inttostr(AffiliateID), ltCall);

    sXML :=
      '<fmgetsystemfiles result="0">' +
        sXML +
      '</fmgetsystemfiles>';

    CommonDataModule.ObjectPool.GetSystemFilesCache.SetCachedString(AffiliateID, sXML);
  end;

  Response.Add(sXML, aAction.SessionID, aAction.UserID);
end;

function TFileManager.ProcessAction(ActionsNode: IXMLNode): Integer;
var
  i : integer;
  aAction: TfmAction;
begin
  Result := S_OK;

  // verify
  if ActionsNode = nil  then begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      '[ERROR] ActionsNode is nil',
      ltError
    );

    Result := FM_ERR_CORRUPTREQUESTXML;
    Exit;
  end;
  if not ActionsNode.HasChildNodes then begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      '[ERROR] ActionsNode has not child nodes; Params: ActionsNode=' + ActionsNode.XML,
      ltError
    );

    Result := FM_ERR_CORRUPTREQUESTXML;
    Exit;
  end;

  for I:=0 to ActionsNode.ChildNodes.Count - 1 do begin
    Request.Add.ActionNode := ActionsNode.ChildNodes[I];
  end;


  //....................................................................................
  // Process XML data for each action in action packet
  // Response notification will send by one for action and added to the Response object
  // Action Packet Processing
  //....................................................................................
  for i := 0 to Request.Count-1 do begin
    aAction := Request.Item[I];

    // case by action name and executing specific method for each action
    if aAction.Name = FM_GETFILEINFO then begin
      ProcessGetFileInfo(aAction);
      continue;
    end;
    //................................................................
    if aAction.Name = FM_GETPROCESSFILES then begin
      ProcessGetProcessFiles(aAction);
      continue;
    end;
    //................................................................
    if aAction.Name = FM_GETSYSTEMFILES then begin
      ProcessGetSystemFiles(aAction);
      continue;
    end;
    //................................................................
    if aAction.Name = FM_GETPLAYERLOGO then begin
      ProcessGetPlayerLogo(aAction);
      continue;
    end;
    //................................................................
    if aAction.Name = FM_GETPUSHINGCONTENTFILES then begin
      ProcessGetPushingContentFiles(aAction);
      continue;
    end;

  end; // for by each action in the actions packet

  //free resources
  Request.Clear;

  // notification & clear
  Response.SendActions;

end;

procedure TFileManager.ProcessGetPlayerLogo(aAction: TfmAction);
var
  sXML : string;
  sSQL : string;
  FSql: TSQLAdapter;
  UserID, nRes: Integer;
  RS: TDataSet;
begin
  UserID := StrToIntDef(aAction.ActionNode.Attributes['userid'], 0);

  CommonDataModule.Log(ClassName, 'ProcessGetPlayerLogo',
    'fmnGetPlayerLogo enter with UserID=' + inttostr(UserID), ltCall);

  nRes := 0;
  sSQL := 'exec fmnGetPlayerLogo ' + inttostr(UserID);  // prepare query
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    RS := FSql.Execute(sSQL);

    sXML := '';
    while not RS.Eof do begin
      sXML := sXML +
        '<file ' +
            'userid="' + RS.FieldByName('UserID').AsString + '" ' +
            'name="' + RS.FieldByName('File').AsString + '" ' +
            'location="' + RS.FieldByName('Path').AsString + '" ' +
            'version="' + RS.FieldByName('Version').AsString + '" ' +
            'size="' + RS.FieldByName('Size').AsString + '" ' +
            'fileid="' + RS.FieldByName('ID').AsString + '" ' +
        '/>';

      RS.Next;
    end;
  except
    on e: Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessGetPlayerLogo',
        '[EXCEPTION] On exec fmnGetPlayerLogo "' + inttostr(UserID) + '": Message=' + e.Message,
        ltException);

      sXML := '';
      nRes := FM_ERR_SQLEXCEPTION;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  CommonDataModule.Log(ClassName, 'ProcessGetPlayerLogo',
    'fmnGetPlayerLogo quit with UserID=' + inttostr(UserID) + '; Result=' + IntToStr(nRes),
    ltCall
  );

  sXML :=
    '<fmgetplayerlogo result="' + IntToStr(nRes) + '">' +
      sXML +
    '</fmgetplayerlogo>';

  Response.Add(sXML, aAction.SessionID, aAction.UserID);
end;

procedure TFileManager.ProcessGetPushingContentFiles(aAction: TfmAction);
var
  sXML                    : String;
  nUserID, nProcessID, nType: Integer;
  FApi: TAPI;
begin
  sXML:= '';

  nUserID := aAction.UserID;
  if (nUserID < 0) then nUserID := 0;
  nProcessID := aAction.ProcessID;
  if (nProcessID < 0) then nProcessID := 0;
  if aAction.ActionNode.Attributes['type'] = 'lobby' then
    nType := 1
  else
    nType := 2;

  FApi := CommonDataModule.ObjectPool.GetAPI;
  try
    FApi.GetPushingContentFiles(nType, nProcessID, nUserID, sXML);
  finally
    CommonDataModule.ObjectPool.FreeAPI(FApi);
  end;

  if (sXML <> '') then
    Response.Add(sXML, aAction.SessionID, nUserID);
end;

end.
