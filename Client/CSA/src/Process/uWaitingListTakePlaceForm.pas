unit uWaitingListTakePlaceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls;

type
  TWaitingListTakePlaceForm = class(TForm)
    IconPanel: TTeHeaderPanel;
    TextLabel: TTeLabel;
    YesButton: TTeButton;
    NoButton: TTeButton;
    UpdateTimeTimer: TTimer;
    HideButton: TTeButton;
    ShowAgainTimer: TTimer;
    procedure YesButtonClick(Sender: TObject);
    procedure NoButtonClick(Sender: TObject);
    procedure HideButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateTimeTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowAgainTimerTimer(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    FProcessText: String;
    FCurrentSeconds: Integer;
    procedure UpdateText;
    procedure ShowForm;
  public
    procedure OnWaitingListConfirm(const ProcessText: String; Seconds: Integer);
    procedure OnWaitingListHide;
    procedure OnWaitingListClose;
  end;

var
  WaitingListTakePlaceForm: TWaitingListTakePlaceForm;

implementation

uses
  uProcessModule,
  uConstants,
  uThemeEngineModule;

{$R *.dfm}

{ TMessageForm }

procedure TWaitingListTakePlaceForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self, 430, 100);

  ProcessModule.OnWaitingListConfirm := OnWaitingListConfirm;
  ProcessModule.OnWaitingListClose := OnWaitingListClose;
  ProcessModule.OnWaitingListHide := OnWaitingListHide;
end;

procedure TWaitingListTakePlaceForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TWaitingListTakePlaceForm.OnWaitingListConfirm(const ProcessText: String; Seconds: Integer);
begin
  FProcessText := ProcessText;
  FCurrentSeconds := Seconds;
  TextLabel.Caption := FProcessText + #13#10 +
    cstrWaitingListTimer1 + inttostr(FCurrentSeconds) + cstrWaitingListTimer2;
  // SetText
  TextLabel.AutoSize := False;
  TextLabel.Width := 250;
  TextLabel.Height := 55;
  TextLabel.Top := 10;
  TextLabel.Left := 80;
  TextLabel.Caption := ProcessText;
  TextLabel.AutoSize := True;

  if TextLabel.Height > 55 then
  begin
    TextLabel.AutoSize := False;
    TextLabel.Width := 300;
    TextLabel.Height := 70;
    TextLabel.Top := 10;
    TextLabel.Left := 80;
    TextLabel.Caption := ProcessText;
    TextLabel.AutoSize := True;
  end;

  if TextLabel.Height > 80 then
  begin
    TextLabel.AutoSize := False;
    TextLabel.Width := 350;
    TextLabel.Height := 100;
    TextLabel.Top := 10;
    TextLabel.Left := 80;
    TextLabel.Caption := ProcessText;
    TextLabel.AutoSize := True;
  end;

  TextLabel.AutoSize := False;
  TextLabel.Top := 10;
  TextLabel.Left := 80;
  TextLabel.Width := 350;
  if TextLabel.Height < 55 then
    TextLabel.Height := 55;
  ClientWidth := 90 + TextLabel.Width;
  ClientHeight := 30 + TextLabel.Height + YesButton.Height;

  // Set Icon
  IconPanel.Left := 10;
  IconPanel.Top := 10 + ((TextLabel.Height - IconPanel.Height) div 2);

  Caption := 'A seat is available for you...';
  //Caption := TeForm.Caption;
  IconPanel.ThemeObject := 'ConfirmMessagePanel';

  YesButton.Top := ClientHeight - 10 - YesButton.Height;
  NoButton.Top := ClientHeight - 10 - NoButton.Height;
  HideButton.Top := ClientHeight - 10 - HideButton.Height;

  // ShowModal and get result
  UpdateTimeTimer.Enabled := true;
  ShowForm;
end;

procedure TWaitingListTakePlaceForm.YesButtonClick(Sender: TObject);
begin
  ProcessModule.Do_TakePlace;
end;

procedure TWaitingListTakePlaceForm.NoButtonClick(Sender: TObject);
begin
  ProcessModule.Do_Unjoin;
end;

procedure TWaitingListTakePlaceForm.HideButtonClick(Sender: TObject);
begin
  OnWaitingListHide;
end;

procedure TWaitingListTakePlaceForm.OnWaitingListClose;
begin
  ShowAgainTimer.Enabled := false;
  UpdateTimeTimer.Enabled := false;
  Close;
end;

procedure TWaitingListTakePlaceForm.OnWaitingListHide;
begin
  Hide;
  ShowAgainTimer.Enabled := true;
end;

procedure TWaitingListTakePlaceForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ShowAgainTimer.Enabled := UpdateTimeTimer.Enabled;
end;

procedure TWaitingListTakePlaceForm.UpdateTimeTimerTimer(Sender: TObject);
begin
  FCurrentSeconds := FCurrentSeconds - 1;
  if FCurrentSeconds <= 0 then
    FCurrentSeconds := 0;
  UpdateText;
end;

procedure TWaitingListTakePlaceForm.UpdateText;
begin
  TextLabel.Caption := FProcessText + #13#10 +
    cstrWaitingListTimer1 + inttostr(FCurrentSeconds) + cstrWaitingListTimer2;
end;

procedure TWaitingListTakePlaceForm.ShowAgainTimerTimer(Sender: TObject);
begin
  ShowForm;
end;

procedure TWaitingListTakePlaceForm.ShowForm;
begin
  ShowAgainTimer.Enabled := false;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

end.
