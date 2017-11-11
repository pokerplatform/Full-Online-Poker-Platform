unit uChangePlayerLogoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  Dialogs, te_controls, uLogger,
  uThemeEngineModule, OleCtrls, ShockwaveFlashObjects_TLB, Menus, ExtCtrls;

type
  TChangePlayerLogoForm = class(TForm)
    ShockwaveFlash: TShockwaveFlash;
    TimeOutTimer: TTimer;
    procedure ShockwaveFlashFSCommand(ASender: TObject; const command,
      args: WideString);
    procedure TimeOutTimerTimer(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure Load(FileName: String);
    procedure SetSize(ProcessWidth, ProcessHeight: Integer);
    procedure Start;
    procedure Stop;
    procedure Send(Command: String);
  end;

implementation

uses
  uUserModule, uFileManagerModule, uConstants;

{$R *.dfm}

{ TProcessForm }

procedure TChangePlayerLogoForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TChangePlayerLogoForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TChangePlayerLogoForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;


// Actions

procedure TChangePlayerLogoForm.Send(Command: String);
begin
  ShockwaveFlash.SetVariable('mcComm.strInMsg', Command);
  Logger.Add('ChangePlayerLogoForm.ShockwaveFlashFSCommand sent:', llExtended);
  Logger.Add(Command, llExtended);
end;

procedure TChangePlayerLogoForm.ShockwaveFlashFSCommand(ASender: TObject;
  const command, args: WideString);
begin
  Logger.Add('ChangePlayerLogoForm.ShockwaveFlashFSCommand receive: ' + command, llExtended);
  Logger.Add(args, llExtended);

  if (command = 'SendMsg') and (args <> '') then
    UserModule.Do_PlayerLogoCommand(args);
end;

procedure TChangePlayerLogoForm.TimeOutTimerTimer(Sender: TObject);
begin
  TimeOutTimer.Enabled := false;
  Logger.Add('ChangePlayerLogoForm.TimeOutTimerTimer');
  Close;
end;

procedure TChangePlayerLogoForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TimeOutTimer.Enabled := false;
  UserModule.Do_PlayerLogoClosed;
  Action := caFree;
end;

procedure TChangePlayerLogoForm.Load(FileName: String);
begin
  Logger.Add('ChangePlayerLogoForm.Load');
  TimeOutTimer.Enabled := true;
  ShockwaveFlash.Movie := FileName;
  ShockwaveFlash.Play;

  Left := 5000;
  Top := 5000;
  Show;
  Hide;
end;

procedure TChangePlayerLogoForm.SetSize(ProcessWidth,
  ProcessHeight: Integer);
begin
  ThemeEngineModule.FormsChangeConstraints(Self,
    ProcessWidth, ProcessHeight);
end;

procedure TChangePlayerLogoForm.Start;
begin
  TimeOutTimer.Enabled := false;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
  SetForegroundWindow(Handle);
end;

procedure TChangePlayerLogoForm.Stop;
begin
  Close;
end;

procedure TChangePlayerLogoForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + 'Change player logo...';
  ThemeEngineModule.FormsChangeConstraints(Self,  400, 385);
  ShockwaveFlash.Width := 400;
  ShockwaveFlash.Height := 385;
end;

end.
