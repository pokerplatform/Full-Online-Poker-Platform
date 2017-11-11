unit uMSMQReader;

interface

uses
  Classes, SysUtils,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uMSMQThread;

type
  TMSMQReader = class
  private
    MSMQThread: TMSMQThread;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  uCommonDataModule, uLogger, uSettings;


{ TMSMQReader }

constructor TMSMQReader.Create;
begin
  inherited;
  try
    MSMQThread := TMSMQThread.Create(TRUE);
    MSMQThread.Priority := tpLowest;
    MSMQThread.FreeOnTerminate := False;
    MSMQThread.Resume;
    CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create',E.Message, ltException);
  end;
end;

destructor TMSMQReader.Destroy;
begin
  try
    MSMQThread.Terminate;
    MSMQThread.WaitFor;
    MSMQThread.Free;
    
    CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;

  inherited;
end;

end.
