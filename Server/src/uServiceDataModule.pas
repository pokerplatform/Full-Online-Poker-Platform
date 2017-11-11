unit uServiceDataModule;

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, Graphics, Controls, ActiveX, SvcMgr, Dialogs;

type
  TServiceDataModule = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceCreate(Sender: TObject);
  public
    function GetServiceController: TServiceController; override;
  end;

var
  ServiceDataModule: TServiceDataModule;

procedure StartService;
procedure StopService;

implementation

{$R *.DFM}

uses
  uCommonDataModule, uActionDispatcher;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceDataModule.Controller(CtrlCode);
end;

function TServiceDataModule.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServiceDataModule.ServiceStart(Sender: TService; var Started: Boolean);
begin
  StartService;
  Started := true;
end;

procedure TServiceDataModule.ServiceContinue(Sender: TService; var Continued: Boolean);
begin
  StartService;
  Continued := true;
end;

procedure TServiceDataModule.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  StopService;
  Stopped := true;
end;

procedure TServiceDataModule.ServicePause(Sender: TService; var Paused: Boolean);
begin
  StopService;
  Paused := true;
end;

procedure TServiceDataModule.ServiceShutdown(Sender: TService);
begin
  StopService;
end;


// Start service

procedure StartService;
begin
  CoInitialize(nil);

  CommonDataModule := nil;
  ActionDispatcher := nil;

  CommonDataModule := TCommonDataModule.Create;
  CommonDataModule.StartWork;
  
  ActionDispatcher := TActionDispatcher.Create;
end;


// Stop service

procedure StopService;
begin
  try
    ActionDispatcher.Free;
    CommonDataModule.Free;
  except
  end;

  CoUninitialize;
end;


procedure TServiceDataModule.ServiceCreate(Sender: TObject);
var
  ServiceName: String;
begin
  ServiceName := ExtractFileName(Forms.Application.ExeName);
  ServiceName := copy(ServiceName, 1, Length(ServiceName) - 4);

  Name := ServiceName;
  DisplayName := ServiceName;
end;

end.
