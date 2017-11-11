unit uEMail;

interface

uses
  Forms, Windows, ActiveX, Classes, ComObj, StdVcl, SysUtils, StrUtils,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdMessageClient, IdSMTP;

type
  TEMail = class
  public
    function ProcessAction(ActionsNode: IXMLNode): Integer;

    function GetAdminEmail: string;
    function GetEmailFromAddress(UserID: integer): String;
    function GetEmailAddress(UserID: integer): String;
    function ParseTemplate(var sTemplate: String; Data: String): integer;
    function PostEmailMessage(EmailFrom, EmailTo, Subject, Body: String): integer;

    function SendUserEmail(SessionID, UserID: Integer;
      const Subject: String; const Data: String): Integer;
    function SendAdminEmail(SessionID, UserID: Integer;
      const Subject: String; const Data: String): Integer;
    function SendCustomEmail(SessionID, UserID: Integer;
      TemplateID: Integer; const Data: String): Integer;
  end;

implementation

uses
  uXMLConstants, uErrorConstants, uLogger, uCommonDataModule, uSQLAdapter, DB;

{ TEMail }

function TEMail.ProcessAction(ActionsNode: IXMLNode): Integer;
var
  XMLNode: IXMLNode;
  Loop: Integer;
  ActionName: String;
  SessionID: Integer;
begin
  Result := EM_ERR_WRONGREQUEST;

  try
    for Loop := 0 to ActionsNode.ChildNodes.Count - 1 do
    begin
      XMLNode := ActionsNode.ChildNodes.Nodes[Loop];
      ActionName := lowercase(XMLNode.NodeName);
      SessionID := StrToIntDef(XMLNode.Attributes[PO_ATTRSESSIONID], 0);

      if ActionName = EM_SendUserEmail  then
        SendUserEmail(SessionID, XMLNode.Attributes['userid'],
          XMLNode.Attributes['subject'], XMLNode.Attributes['data'])
       else
       if ActionName = EM_SendAdminEmail then
        SendAdminEmail(SessionID, 0,
          XMLNode.Attributes['subject'], XMLNode.Attributes['data'])
       else
       if ActionName = EM_SendCustomEmail then
          SendCustomEmail(SessionID, XMLNode.Attributes['userid'],
            XMLNode.Attributes['templateid'], XMLNode.Attributes['data'])
       else
         CommonDataModule.Log(ClassName, 'ProcessAction',
           'Valid email action was not found', ltError);
    end;
    Result := PO_NOERRORS;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ProcessAction',
       E.Message, ltException);
  end;
end;

function TEMail.SendAdminEmail(SessionID, UserID: Integer; const Subject, Data: String): Integer;
begin
  Result := PostEmailMessage(GetEmailFromAddress(UserID), GetEmailFromAddress(UserID),
    Subject, Data);
end;

function TEMail.SendUserEmail(SessionID, UserID: Integer; const Subject, Data: String): Integer;
begin
  Result := PostEmailMessage(GetEmailFromAddress(UserId), GetEmailAddress(UserId),
    Subject, Data);
end;

function TEMail.SendCustomEmail(SessionID, UserID,
  TemplateID: Integer; const Data: String): Integer;
var
  SqlAdapter: TSQLAdapter;
  RS: TDataSet;
  EmailBody: String;
  EmailSubject: String;
begin
  Result := EM_ERR_SQLCOMMANDERROR;

  try
    SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      SqlAdapter.SetProcName('emlGetEmailTemplate');
      SqlAdapter.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
      SqlAdapter.AddParInt('TemplateID', TemplateID, ptInput);
      RS := SqlAdapter.ExecuteCommand;
      try
        if RS.Eof then
          CommonDataModule.Log(ClassName, 'SendCustomEmail',
            'No email template with ID=' + inttostr(TemplateID), ltError)
        else
        begin
          EmailBody := RS.FieldValues['Body'];
          EmailSubject := RS.FieldValues['Subject'];

          Result := ParseTemplate(EmailBody, Data);
          Result := PostEmailMessage(GetEmailFromAddress(UserId), GetEmailAddress(UserId),
            EmailSubject, EmailBody);
        end;
      finally
        RS.Close;
      end;
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'SendCustomEmail',
        E.Message + ', TemplateID=' + inttostr(TemplateID), ltException);
  end;
end;

function TEMail.GetAdminEmail: string;
begin
  Result := CommonDataModule.AdminEmailAddress;
end;

function TEMail.GetEmailFromAddress(UserID: integer): String;
var
  SqlAdapter: TSQLAdapter;
begin
  Result := '';
  try
    SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      SqlAdapter.SetProcName('dskGetAffiliateEMailFrom');
      SqlAdapter.AddParInt('RETURN_VALUE', 0, ptResult);
      SqlAdapter.AddParInt('UserID', UserID, ptInput);
      SqlAdapter.AddParString('EmailFrom', '@', ptOutput);
      SqlAdapter.ExecuteCommand;

      if SqlAdapter.GetParam('RETURN_VALUE') = 0 then
        Result := SqlAdapter.GetParam('EmailFrom')
      else
        Result := GetAdminEmail;
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'GetEmailFromAddress',
        E.Message + ', UserID=' + inttostr(UserID), ltException);
  end;
end;

function TEMail.GetEmailAddress(UserID: integer): String;
var
  SqlAdapter: TSQLAdapter;
begin
  Result := '';
  try
    SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      SqlAdapter.SetProcName('emlGetUserEmail');
      SqlAdapter.AddParInt('RETURN_VALUE', 0, ptResult);
      SqlAdapter.AddParInt('UserID', UserID, ptInput);
      SqlAdapter.AddParString('Email', '@', ptOutput);
      SqlAdapter.ExecuteCommand;

      if SqlAdapter.GetParam('RETURN_VALUE') = 0 then
        Result := SqlAdapter.GetParam('Email');
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'GetEmailAddress',
        E.Message + ', UserID=' + inttostr(UserID), ltException);
  end;
end;

function TEMail.ParseTemplate(var sTemplate: String; Data: String): integer;
var
  tPars   : TStringList;
  sSource : String;
  sDest   : String;
  i,j     : integer;
begin
  Result := 0;
  tPars := TStringList.Create;
  tPars.CommaText := Data;
  for i := 0 to (tPars.Count - 1) do
  begin
    j := AnsiPos('=', tPars.Strings[i]);
    if j >= 0 then
    begin
      sSource := '{' + LeftStr(tPars.Strings[i], j-1) + '}';
      sDest := AnsiRightStr(tPars.Strings[i], Length(tPars.Strings[i]) - j);
      sTemplate := StringReplace(sTemplate, sSource, sDest, [rfReplaceAll, rfIgnoreCase]);
    end;
  end;
end;

function TEMail.PostEmailMessage(EmailFrom, EmailTo, Subject, Body: String): integer;
var
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
begin
  Result := EM_ERR_CANNOTSEND;
  try
    IdSMTP := TIdSMTP.Create(Forms.Application);
    IdMessage := TIdMessage.Create(Forms.Application);
    try
      IdSMTP.Host := CommonDataModule.SMTPHost;
      IdSMTP.Port := CommonDataModule.SMTPPort;
      IdMessage.ContentType := 'text/html';
      IdMessage.Subject := Subject;
      IdMessage.Body.Text := Body;
      IdMessage.From.Address := EmailFrom;
      IdMessage.ReplyTo.Clear;
      IdMessage.ReplyTo.Add.Address := EmailFrom;
      IdMessage.Recipients.Clear;
      IdMessage.Recipients.Add.Address := EmailTo;

      if not IdSMTP.Connected then
        IdSMTP.Connect;
      IdSMTP.Send(IdMessage);

      Result := PO_NOERRORS;
      CommonDataModule.Log(ClassName, 'PostEmailMessage',
        'Message was sent: EmailFrom=' + EmailFrom + ', EmailFrom=' + EmailFrom +
        ', Subject= ' + Subject + ', Body=' + Body, ltCall);

    finally
      IdMessage.Free;
      IdSMTP.Free;
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'PostEmailMessage',
        E.Message + ', EmailFrom=' + EmailFrom + ', EmailFrom=' + EmailFrom +
        ', Subject= ' + Subject + ', Body=' + Body, ltException);
  end;
end;

end.
