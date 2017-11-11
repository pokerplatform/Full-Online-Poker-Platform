unit uMessageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls;

type
  TMsgWndType = (msgMessage, msgConfirm, msgWarning);

  TMessageForm = class(TForm)
    IconPanel: TTeHeaderPanel;
    TextLabel: TTeLabel;
    OkButton: TTeButton;
    CancelButton: TTeButton;
    TimeOutTimer: TTimer;
    procedure OkButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimeOutTimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FConfirmed: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public

    function StartWork(MsgWndType: TMsgWndType; IsModal: Boolean; const Text: String): Boolean;
  end;

implementation

uses
  uConstants,
  uThemeEngineModule;

{$R *.dfm}

{ TMessageForm }

function TMessageForm.StartWork(MsgWndType: TMsgWndType; IsModal: Boolean;
  const Text: String): Boolean;
begin
  // SetText
  TextLabel.AutoSize := False;
  TextLabel.Width := 250;
  TextLabel.Height := 55;
  TextLabel.Top := 10;
  TextLabel.Left := 80;
  TextLabel.Caption := Text;
  TextLabel.AutoSize := True;

  if TextLabel.Height > 55 then
  begin
    TextLabel.AutoSize := False;
    TextLabel.Width := 300;
    TextLabel.Height := 70;
    TextLabel.Top := 10;
    TextLabel.Left := 80;
    TextLabel.Caption := Text;
    TextLabel.AutoSize := True;
  end;

  if TextLabel.Height > 80 then
  begin
    TextLabel.AutoSize := False;
    TextLabel.Width := 350;
    TextLabel.Height := 100;
    TextLabel.Top := 10;
    TextLabel.Left := 80;
    TextLabel.Caption := Text;
    TextLabel.AutoSize := True;
  end;

  TextLabel.AutoSize := False;
  TextLabel.Top := 10;
  TextLabel.Left := 80;
  if TextLabel.Width < 250 then
    TextLabel.Width := 250;
  if TextLabel.Height < 55 then
    TextLabel.Height := 55;
  ClientWidth := 90 + TextLabel.Width;
  ClientHeight := 30 + TextLabel.Height + OkButton.Height;

  // Set Icon
  IconPanel.Left := 10;
  IconPanel.Top := 10 + ((TextLabel.Height - IconPanel.Height) div 2);

  if MsgWndType = msgMessage then
  begin
    Caption := 'Information...';
    //Caption := TeForm.Caption;
    IconPanel.ThemeObject := 'InfoMessagePanel';
  end;

  if MsgWndType = msgWarning then
  begin
    Caption := 'Warning...';
    //Caption := TeForm.Caption;
    IconPanel.ThemeObject := 'WarningMessagePanel';
  end;

  if MsgWndType = msgConfirm then
  begin
    Caption := 'Question...';
    //Caption := TeForm.Caption;
    IconPanel.ThemeObject := 'ConfirmMessagePanel';
  end;

  // Set buttons
  if MsgWndType = msgConfirm then
  begin
    CancelButton.Visible := true;
    OkButton.Top := ClientHeight - 10 - OkButton.Height;
    OkButton.Left := (ClientWidth div 2) - 10 - OkButton.Width;
    CancelButton.Top := ClientHeight - 10 - CancelButton.Height;
    CancelButton.Left := (ClientWidth div 2) + 10;
  end
  else
  begin
    CancelButton.Visible := false;
    OkButton.Top := ClientHeight - 10 - OkButton.Height;
    OkButton.Left := (ClientWidth div 2) - (OkButton.Width div 2);
  end;

  FConfirmed := false;
  ThemeEngineModule.CenteringForm(Self);
  ThemeEngineModule.FormsChangeConstraints(Self, ClientWidth, ClientHeight);

  ActiveControl := OkButton;
  TimeOutTimer.Enabled := true;

  if IsModal then
    ShowModal
  else
    Show;

  Result := FConfirmed;
end;

procedure TMessageForm.OkButtonClick(Sender: TObject);
begin
  FConfirmed := true;
  Close;
end;

procedure TMessageForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMessageForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMessageForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TMessageForm.TimeOutTimerTimer(Sender: TObject);
begin
  Close;
end;

procedure TMessageForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
  begin
    FConfirmed := True;
    Close;
  end;

  if key = 27 then
  begin
    FConfirmed := False;
    Close;
  end;
end;

end.
