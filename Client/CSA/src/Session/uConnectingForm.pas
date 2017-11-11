unit uConnectingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, StdCtrls, ExtCtrls, jpeg, te_controls,
  uThemeEngineModule,
  uSessionModule, ComCtrls;

type
  TConnectingForm = class(TForm)
    Image1: TImage;
    StatusLabel: TLabel;
    CancelButton: TTeButton;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure OnConnecting;
    procedure OnConnectingFailed;
    procedure OnSynchronizing;
    procedure OnSynchronized;
    procedure OnUpdating;
    procedure OnUpdatingFiles;
    procedure UpdateSynch;
    procedure ShowForm;
    procedure ReceiveWMUSERMessage(var msg: TMessage);  message WM_USER;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ConnectingForm: TConnectingForm;

implementation

uses
  uLogger,
  CLipbrd,
  uConstants;

{$R *.dfm}

procedure TConnectingForm.FormCreate(Sender: TObject);
begin
  Left := Screen.WorkAreaRect.Left +
    ((Screen.WorkAreaRect.Right - Screen.WorkAreaRect.Left - Width) div 2);
  Top := Screen.WorkAreaRect.Top +
    ((Screen.WorkAreaRect.Bottom - Screen.WorkAreaRect.Top - Height) div 2);
  Caption := AppName;

  SessionModule.OnConnecting := OnConnecting;
  SessionModule.OnConnectingFailed := OnConnectingFailed;
  SessionModule.OnSynchronizing := OnSynchronizing;
  SessionModule.OnSynchronized := OnSynchronized;
  SessionModule.OnUpdating := OnUpdating;
  SessionModule.OnUpdatingFiles := OnUpdatingFiles;

  DoubleBuffered := True;
end;

procedure TConnectingForm.FormDestroy(Sender: TObject);
begin
  SessionModule.OnConnecting := nil;
  SessionModule.OnConnectingFailed := nil;
  SessionModule.OnSynchronizing := nil;
  SessionModule.OnSynchronized := nil;
  SessionModule.OnUpdating := nil;
  SessionModule.OnUpdatingFiles := nil;
end;

procedure TConnectingForm.CancelButtonClick(Sender: TObject);
begin
  SessionModule.CloseApplication;
end;

// Events from SessionModule

procedure TConnectingForm.OnConnecting;
begin
  StatusLabel.Caption := cstrConnecting;
  //StatusLabel.Alignment := taCenter;
  CancelButton.Visible := true;
  //ConnectionProgressPanel.Visible := false;
  ShowForm;
end;

procedure TConnectingForm.OnUpdating;
begin
  StatusLabel.Caption := cstrUpdating;
  //StatusLabel.Alignment := taCenter;
  UpdateSynch;
end;

procedure TConnectingForm.OnUpdatingFiles;
begin
  StatusLabel.Caption := cstrUpdatingFiles;
  //StatusLabel.Alignment := taCenter;
  UpdateSynch;
end;

procedure TConnectingForm.UpdateSynch;
var
  ProgressPosition: Integer;
begin
  ProgressPosition := round(SessionModule.SynchProgress);

  if (abs(ProgressBar.Position - ProgressPosition) > 1) or
    (ProgressPosition = 100) or (ProgressPosition = 0) then
  begin
    {if not ConnectionProgressPanel.Visible then
      ConnectionProgressPanel.Visible := true;{}
    if ProgressPosition < ProgressBar.Min then
      ProgressPosition := ProgressBar.Min;
    if ProgressPosition > ProgressBar.Max then
      ProgressPosition := ProgressBar.Max;
    ProgressBar.Position := ProgressPosition;
    ShowForm;
  end;
end;

procedure TConnectingForm.OnConnectingFailed;
begin
  {StatusLabel.Caption := cstrConnectFailed;
  StatusLabel.Alignment := taCenter;
  ProgressBar.Position := 0;
  //ConnectionProgressPanel.Visible := false;
  ShowForm;{}
end;

procedure TConnectingForm.OnSynchronizing;
begin
  StatusLabel.Caption := cstrSynchronizing;
  //StatusLabel.Alignment := taCenter;
  UpdateSynch;
end;

procedure TConnectingForm.OnSynchronized;
begin
  Hide;
end;

procedure TConnectingForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do begin
    Style := Style OR WS_SYSMENU; //AND (NOT WS_MAXIMIZE);
    ExStyle := ExStyle OR WS_EX_APPWINDOW;
    WndParent := HWND_DESKTOP;
  end;
end;

procedure TConnectingForm.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TConnectingForm.ShowForm;
begin
  if (SessionModule.SessionState <> poRunning) and
    (SessionModule.SessionState <> poTerminating) then
  begin
    if not Visible then
      ThemeEngineModule.CenteringForm(Self);
    Show;
    Invalidate;
    //ConnectionProgressPanel.Invalidate;
    ProgressBar.Invalidate;
  end;
end;

procedure TConnectingForm.ReceiveWMUSERMessage(var msg: TMessage);
begin
  SessionModule.ShowApplication;
end;

end.
