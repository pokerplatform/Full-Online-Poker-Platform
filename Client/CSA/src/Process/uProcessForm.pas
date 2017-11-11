unit uProcessForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, uLogger,
  uThemeEngineModule, OleCtrls, ShockwaveFlashObjects_TLB, Menus, ExtCtrls;

type
  TProcessForm = class(TForm)
    TeForm: TTeForm;
    ShockwaveFlash: TShockwaveFlash;
    procedure ShockwaveFlashFSCommand(ASender: TObject; const command,
      args: WideString);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    OwnerProcessObj: TObject;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure Load(ProcessObj: TObject; FileName: String);
    procedure SetSize(ProcessWidth, ProcessHeight: Integer);
    procedure Start;
    procedure Stop;
    procedure Send(Command: String);
  end;

implementation

uses
  uProcessModule;

{$R *.dfm}

{ TProcessForm }

procedure TProcessForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TProcessForm.Load(ProcessObj: TObject; FileName: String);
begin
  OwnerProcessObj := ProcessObj;
  Left := 5000;
  Top := 5000;
  Show;
  Hide;
  WindowState := wsMinimized;

  ShockwaveFlash.Movie := FileName;
  ShockwaveFlash.Play;
end;

procedure TProcessForm.SetSize(ProcessWidth, ProcessHeight: Integer);
begin
  ThemeEngineModule.FormsChangeConstraints(Self, ProcessWidth, ProcessHeight);
end;

procedure TProcessForm.Start;
begin
  ThemeEngineModule.DeActivateAllForms;

  WindowState := wsNormal;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);

  TeForm.StayOnTop := true;
  //TeForm.Update;
  Show;
  SetForegroundWindow(Handle);

  if not ((Screen.WorkAreaHeight <= Height) or
    (Screen.WorkAreaWidth <= Width)) then
  begin
    TeForm.StayOnTop := false;
    //TeForm.Update;
    Show;
  end;
end;

procedure TProcessForm.Stop;
begin
  OnCloseQuery := nil;
end;

procedure TProcessForm.Send(Command: String);
begin
  ShockwaveFlash.SetVariable('mcComm.strInMsg', Command);
end;

procedure TProcessForm.ShockwaveFlashFSCommand(ASender: TObject;
  const command, args: WideString);
begin
  if command = 'SendMsg' then
  try
    ProcessModule.DoCommand(OwnerProcessObj as TGameProcess, args);
  except
    on E: Exception do
      Logger.Add('TProcessForm.ShockwaveFlashFSCommand: ' + e.Message, llBase, True);
  end;
end;

procedure TProcessForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  ProcessModule.Send(OwnerProcessObj as TGameProcess, '<gamefinished/>');
end;

procedure TProcessForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TProcessForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TProcessForm.FormActivate(Sender: TObject);
begin
  ProcessModule.UpdateActiveState(OwnerProcessObj as TGameProcess, True);
end;

procedure TProcessForm.FormDeactivate(Sender: TObject);
begin
  ProcessModule.UpdateActiveState(OwnerProcessObj as TGameProcess, False);
end;

procedure TProcessForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self, 784, 552);
  ShockwaveFlash.Width := 784;
  ShockwaveFlash.Height := 552;
end;

end.
