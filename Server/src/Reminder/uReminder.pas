unit uReminder;

interface

uses
  xmldom, XMLIntf, msxmldom, XMLDoc, Variants
//PO
  , uReminderThread
  ;

type
  TReminder = class
  private
    ReminderThread: TReminderThread;
  public
    procedure ProcessAction(ActionXML: IXMLNode);

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
//PO
  uCommonDataModule
  , uLogger
  , uXMLConstants
  , SysUtils;

// Common DataModule Events

constructor TReminder.Create;
begin
  inherited;
  ReminderThread := TReminderThread.Create;
  CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
end;

destructor TReminder.Destroy;
begin
  ReminderThread.Free;
  CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  inherited;
end;

procedure TReminder.ProcessAction(ActionXML: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strData, strCommand: String;
begin
  CommonDataModule.Log( ClassName, 'ProcessAction',
    'Start ActionXML=[' + ActionXML.XML + ']', ltRequest );

  // set initial values as undefined
  if not ActionXML.HasAttribute('name') then Exit;
  if not (ActionXML.Attributes['name'] = OBJ_REMINDER) then Exit;

  // filling InputActions buffer
  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
  try
    XMLNode := ActionXML.ChildNodes[Loop];
    if XMLNode.ChildNodes.Count > 0 then
      strData := XMLNode.ChildNodes.Nodes[0].XML
    else
      strData := '';

    strCommand := lowercase(XMLNode.NodeName);
    ReminderThread.AddCommand(strCommand,
      XMLNode.Attributes['id'], strData,
      StrToDateTime(XMLNode.Attributes['exectime']),
      StrToIntDef(XMLNode.Attributes['sessionid'], -1),
      StrToIntDef(XMLNode.Attributes['processid'], -1));

  except
    on E: Exception do
      CommonDataModule.Log( ClassName, 'ProcessAction', E.Message, ltException );
  end;

  CommonDataModule.Log( ClassName, 'ProcessAction', 'Finish', ltCall );
end;

end.
