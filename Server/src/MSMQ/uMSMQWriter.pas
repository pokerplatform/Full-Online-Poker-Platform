unit uMSMQWriter;

interface

uses
  Classes, SysUtils,
  xmldom, XMLIntf, msxmldom, XMLDoc;

type
  TMSMQWriter = class
  public
    procedure ProcessAction(ActionXML: IXMLNode);

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  uCommonDataModule, uLogger, uSettings, uXMLConstants;


{ TMSMQWriter }

constructor TMSMQWriter.Create;
begin
  inherited;
  CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
end;

destructor TMSMQWriter.Destroy;
begin
  CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  inherited;
end;

procedure TMSMQWriter.ProcessAction(ActionXML: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  XMLName: String;
begin
  if ActionXML.ChildNodes.Count = 0 then
  begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      'Action packet was arrived without child nodes', ltError);
    Exit;
  end;

  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
  try
    XMLNode := ActionXML.ChildNodes.Nodes[Loop];
    XMLName := XMLNode.NodeName;

    if XMLName = MW_Message then
      CommonDataModule.SendAdminMSMQ(XMLNode.Attributes['body'], XMLNode.Attributes['label']);

  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ProcessAction',
        E.Message + ' On processing action:' + ActionXML.XML, ltException);
  end;
end;

end.
