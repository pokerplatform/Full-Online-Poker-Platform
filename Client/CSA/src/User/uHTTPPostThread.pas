unit uHTTPPostThread;

interface

uses
  Forms, Windows, Classes, Messages, SysUtils, IdBaseComponent,IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Dialogs, XMLDoc, xmldom, XMLIntf;

type
  TResultEvent = procedure(Result: string) of object;
  THTTPPostThread = class(TThread)
  private
    FOwner: TComponent;
    FFileSize: Integer;
    FBuffer: string;
    FURL: String;
    WebServiceResult: String;
    FenrtyName: String;
    FXML: String;
    FOnResult: TResultEvent;
    FUserID: Integer;
    FisAvatar: Boolean;
    FFilePath: string;
    FisArchive: String;
    ForigFileSize: Integer;
    procedure SetOwner(const Value: TComponent);
    procedure SetBuffer(const Value: string);
    procedure SetFileSize(const Value: Integer);
    procedure SetURL(const Value: String);
    procedure SetenrtyName(const Value: String);
    procedure SetOnResult(const Value: TResultEvent);
    procedure SetUserID(const Value: Integer);
    { Private declarations }
  protected
    procedure Execute; override;
    procedure XMLParse;
  public
    strPost, strGet, strServerURL : string;
    constructor Create(AOwner: TComponent; Buf: String; FSize: Integer;AorigFileSize: Integer;Path: string;
                                    AURL: String; entrName: String; ID: Integer; isAvatarPosted: Boolean = true;
                                    isFileArchive: string = 'false');
    property Owner: TComponent read FOwner write SetOwner;
    property Buffer: string read FBuffer write SetBuffer;
    property FileSize: Integer read FFileSize write SetFileSize;
    property URL: String read FURL write SetURL;
    property enrtyName: String read FenrtyName write SetenrtyName;
    property OnResult: TResultEvent read FOnResult write SetOnResult;
    property UserID: Integer read FUserID write SetUserID;
    property isAvatar: Boolean read FisAvatar;
    property FilePath: string read FFilePath;
    property isArchive: String read FisArchive;
    property origFileSize: Integer read ForigFileSize;
  end;

implementation

uses ComObj, SOAPHTTPClient, SOAPHTTPTrans, Math;

{ THTTPThread }

constructor THTTPPostThread.Create(AOwner: TComponent; Buf: String; FSize: Integer;AorigFileSize: Integer;Path: string;
                                    AURL: String; entrName: String; ID: Integer; isAvatarPosted: Boolean = true;
                                    isFileArchive: string = 'false');
begin
  inherited Create(True);
  FOwner := AOwner;
  FBuffer := Buf;
  FFileSize := FSize;
  FURL := AURL;
  FenrtyName := entrName;
  FUserID := ID;
  FisAvatar := isAvatarPosted;
  FFilePath := Path;
  FisArchive := isFileArchive;
  ForigFileSize := AorigFileSize;
  Resume;
end;{}

procedure THTTPPostThread.Execute;
var
  response   : TStringStream;
  strPost: string;
  Request: TMemoryStream;
  FileName: String;
  HTTPReqResp: THTTPReqResp;
begin

  // StartPostFile
  HTTPReqResp := THTTPReqResp.Create(FOwner);
  HTTPReqResp.SoapAction := 'http://DesktopAdmin/webservice/StartPostFile';
  HTTPReqResp.URL := 'http://'+FURL+'/PokerWebService/PokerService.asmx';
  HTTPReqResp.Agent := 'Mozilla/4.0 (compatible; MSIE 6.0b; Windows NT 5.1)';
  StrPost :=  '<?xml version="1.0" encoding="utf-8"?>' +
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
                 '<StartPostFile xmlns="http://DesktopAdmin/webservice/">'+
                    '<fileName>'+FFilePath+'</fileName>'+
                '</StartPostFile>'+
              '</soap:Body>'+
                '</soap:Envelope>';
  Request := TMemoryStream.Create;
  Request.SetSize(Length(strpost));
  Request.Write(Strpost[1],Length(strpost));
  Response := TStringStream.Create('');
  try
    HTTPReqResp.Execute(Request, Response);
  except
    if Assigned(FOnResult) then
     FOnResult('false');
     exit;
  end;
  FXML := Response.DataString;
  Synchronize(XMLParse);
  FileName := WebServiceResult;{}
  //ShowMessage(FileName);

  //PostFile
  HTTPReqResp.SoapAction := 'http://DesktopAdmin/webservice/PostFile';
  HTTPReqResp.URL := 'http://'+FURL+'/PokerWebService/PokerService.asmx';
  HTTPReqResp.Agent := 'Mozilla/4.0 (compatible; MSIE 6.0b; Windows NT 5.1)';
  StrPost :=  '<?xml version="1.0" encoding="utf-8"?>'+
            '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
                '<PostFile xmlns="http://DesktopAdmin/webservice/">'+
                  '<fileName>'+FileName+'</fileName>'+
                  '<fileSize>'+IntToStr(FileSize)+'</fileSize>' +
                  '<buf>'+FBuffer+'</buf>' +
                  '<bufLen>'+IntToStr(FFileSize)+'</bufLen>' +
                '</PostFile>' +
              '</soap:Body>' +
            '</soap:Envelope>';
  Request.Clear;
  Request.SetSize(Length(strpost));
  Request.Write(Strpost[1],Length(strpost));
  Response := TStringStream.Create('');
  try
    HTTPReqResp.Execute(Request, Response);
  except
    if Assigned(FOnResult) then
     FOnResult('false');
     exit;
  end;
  FXML := Response.DataString;
  Synchronize(XMLParse);
  if WebServiceResult = 'false' then
  begin
   if Assigned(FOnResult) then
    FOnResult(WebServiceResult);
   Exit;
  end;

  //EndPostFileArch
  HTTPReqResp.SoapAction := 'http://DesktopAdmin/webservice/EndPostFileArch';
  HTTPReqResp.URL := 'http://'+FURL+'/PokerWebService/PokerService.asmx';
  HTTPReqResp.Agent := 'Mozilla/4.0 (compatible; MSIE 6.0b; Windows NT 5.1)';
  StrPost :=  '<?xml version="1.0" encoding="utf-8"?>' +
                '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
                  '<soap:Body>' +
                    '<EndPostFileArch xmlns="http://DesktopAdmin/webservice/">' +
                      '<subFolder>'+FenrtyName+'</subFolder>' +
                      '<fileName>'+FileName+'</fileName>' +
                      '<entryName>'+FFilePath+'</entryName>' +
                      '<fileSize>'+IntToStr(FFileSize)+'</fileSize>' +
                      '<origFileSize>'+IntToStr(ForigFileSize)+'</origFileSize>' +
                      '<IsFileArchive>'+FisArchive+'</IsFileArchive>'+
                    '</EndPostFileArch>' +
                  '</soap:Body>' +
                '</soap:Envelope>';
  Request.Clear;
  Request.SetSize(Length(strpost));
  Request.Write(Strpost[1],Length(strpost));
  Response := TStringStream.Create('');

  try
    HTTPReqResp.Execute(Request, Response);
  except
    if Assigned(FOnResult) then
     FOnResult('false');
     exit;
  end;
  FXML := Response.DataString;
  Synchronize(XMLParse);
  if Assigned(FOnResult) then
    FOnResult(WebServiceResult);

 //UpdateAvatarData
 if FisAvatar then
 begin
  HTTPReqResp.SoapAction := 'http://DesktopAdmin/webservice/UpdateAvatarData';
  HTTPReqResp.URL := 'http://'+FURL+'/PokerWebService/PokerService.asmx';
  HTTPReqResp.Agent := 'Mozilla/4.0 (compatible; MSIE 6.0b; Windows NT 5.1)';
  StrPost :=  '<?xml version="1.0" encoding="utf-8"?>' +
                '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
                  '<soap:Body>' +
                    '<UpdateAvatarData xmlns="http://DesktopAdmin/webservice/">' +
                      '<UserID>'+IntToStr(UserID)+'</UserID>' +
                      '<file>'+FFilePath+'</file>' +
                      '<size>'+IntToStr(FFileSize)+'</size>' +
                    '</UpdateAvatarData>' +
                  '</soap:Body>' +
                '</soap:Envelope>';
  Request.Clear;
  Request.SetSize(Length(strpost));
  Request.Write(Strpost[1],Length(strpost));
  Response := TStringStream.Create('');

  try
    HTTPReqResp.Execute(Request, Response);
  except
    if Assigned(FOnResult) then
     FOnResult('false');
     exit;
  end;
 end;

 HTTPReqResp.Free;
end;

procedure THTTPPostThread.XMLParse;
var  XMLDoc: IXMLDocument;
     XMLRoot: IXMLNode;
begin
 try
  if FXML <> '' then
  begin
   XMLDoc := TXMLDocument.Create(nil);
   XMLDoc.Active := false;
   XMLDoc.XML.Text := FXML;
   XMLDoc.Active := true;
   XMlRoot := XMLDoc.DocumentElement;
   WebServiceResult := XMLRoot.ChildNodes[0].ChildNodes[0].ChildNodes[0].NodeValue;
  end;
 finally
   XMLDoc := nil;
 end;
end;

procedure THTTPPostThread.SetBuffer(const Value: string);
begin
  FBuffer := Value;
end;

procedure THTTPPostThread.SetenrtyName(const Value: String);
begin
  FenrtyName := Value;
end;

procedure THTTPPostThread.SetFileSize(const Value: Integer);
begin
  FFileSize := Value;
end;

procedure THTTPPostThread.SetOwner(const Value: TComponent);
begin
  FOwner := Value;
end;

procedure THTTPPostThread.SetURL(const Value: String);
begin
  FURL := Value;
end;

procedure THTTPPostThread.SetOnResult(const Value: TResultEvent);
begin
  FOnResult := Value;
end;

procedure THTTPPostThread.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

end.
