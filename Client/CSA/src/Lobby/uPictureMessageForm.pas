unit uPictureMessageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, te_controls, JvxAnimate, JvGIFCtrl, StdCtrls,
  JvComponent, JvxCtrls, JvGIF;

type
  TPictureMessage = (pmBreak, pmReconnect, pmChangeTable, pmPrizeInfo, pmTournamentStart, pmTournamentOver);
  TPictureMessageForm = class(TForm)
    ReconnectImage: TImage;
    BreakImage: TImage;
    Timer: TTimer;
    MoveImage: TImage;
    WinnersMessImage: TJvGIFAnimator;
    TournamentStartImage: TImage;
    TournamentOverImage: TImage;
    UpdateTimer: TTimer;
    MessageLabel: TJvxLabel;
    procedure ReconnectImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerTimer(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  private
    { Private declarations }
    Time: TDateTime;
  public
    { Public declarations }
    procedure ShowForm(Mes: TPictureMessage;MessageText: String; Breakduration: Integer = 0);
  end;

var
  PictureMessageForm: TPictureMessageForm;

implementation

uses DateUtils;

{$R *.dfm}



function GetStrBetweenDateTime(SecCount: Integer): TDateTime;
var
  Num: Integer;
  hour, min, sec: Integer;
begin
  Num := SecCount div (24*60*60);
  // Hours part
  SecCount := SecCount - (Num*24*60*60);
  Num := SecCount div (60*60);

  if Num > 0 then
    hour := Num
  else
    hour := 0;

  // minutes part
  SecCount := SecCount - Num*60*60;
  Num := SecCount div (60);
  if Num > 0 then
    min := Num
  else
    min := 0;

  // second part
  SecCount := SecCount - Num*60;
  Num := SecCount;
  if Num > 0 then
   sec := Num
  else
   sec := 0;

  Result := EncodeTime(hour,Min,Sec,0);
end;

procedure TPictureMessageForm.ShowForm(Mes: TPictureMessage;MessageText: String; Breakduration: Integer = 0);
begin
  Timer.Enabled := false;
  MessageLabel.visible := false;
  if Mes = pmReconnect then
  begin
    TournamentOverImage.Visible := false;
    TournamentStartImage.Visible := false;
    BreakImage.Visible := false;
    MoveImage.Visible := false;
    WinnersMessImage.Visible := false;
    MessageLabel.visible := false;
    ReconnectImage.Visible := true;
    ReconnectImage.Top := 0;
    ReconnectImage.Left := 0;
    Width := ReconnectImage.Width;
    Height := ReconnectImage.Height;
    UpdateTimer.Enabled := false;
    AlphaBlend := false;
    Show;
  end
  else
  if Mes = pmChangeTable then
  begin
    TournamentOverImage.Visible := false;
    TournamentStartImage.Visible := false;
    BreakImage.Visible := false;
    ReconnectImage.Visible := false;
    WinnersMessImage.Visible := false;
    MessageLabel.visible := false;
    MoveImage.Visible := true;
    MoveImage.Top := 0;
    MoveImage.Left := 0;
    Width := MoveImage.Width;
    Height := MoveImage.Height;
    Timer.Interval := 10000;
    Timer.Enabled := true;
    UpdateTimer.Enabled := false;
    AlphaBlend := false;
    Show;
  end
  else
  if Mes = pmBreak then
  begin
    TournamentOverImage.Visible := false;
    TournamentStartImage.Visible := false;
    ReconnectImage.Visible := false;
    MoveImage.Visible := false;
    WinnersMessImage.Visible := false;
    MessageLabel.Left := 27;
    MessageLabel.Top := 36;
    MessageLabel.Caption := '';
    MessageLabel.Font.Name := 'MS Sans Serif';
    MessageLabel.Font.Style := [fsBold];
    MessageLabel.Font.Size := 12;
    MessageLabel.Font.Color := $FEFFFD;
    MessageLabel.ShadowColor := clBlack;
    MessageLabel.visible := true;
    BreakImage.Visible := true;
    BreakImage.Top := 0;
    BreakImage.Left := 0;
    Width := BreakImage.Width;
    Height := BreakImage.Height;
    Timer.Interval := Breakduration*1000; // breakduration in seconds
    Timer.Enabled := true;
    Time := GetStrBetweenDateTime(Breakduration);
    UpdateTimer.Enabled := true;
    AlphaBlend := true;
    AlphaBlendValue := 150;
    Show;
  end
  else
  if Mes = pmPrizeInfo then
  begin
    TournamentOverImage.Visible := false;
    TournamentStartImage.Visible := false;
    ReconnectImage.Visible := false;
    MoveImage.Visible := false;
    BreakImage.Visible := false;
    WinnersMessImage.Visible := true;
    WinnersMessImage.Top := 0;
    WinnersMessImage.Left := 0;
    Width := WinnersMessImage.Width;
    Height := WinnersMessImage.Height;
    MessageLabel.Left := 40;
    MessageLabel.Top := 56;
    MessageLabel.visible := true;
    MessageLabel.Font.Size := 10;
    MessageLabel.Font.Style := [fsBold];
    MessageLabel.Font.Name := 'Arial';
    MessageLabel.Font.Color := clNavy;
    MessageLabel.ShadowColor := clWhite;
    MessageLabel.Caption := MessageText;
    Timer.Interval := 10000;
    Timer.Enabled := true;
    UpdateTimer.Enabled := false;
    AlphaBlend := false;
    Position := poDesktopCenter;
    Show;
    //ShowForm(pmTournamentOver,'',0);
  end
  else
  if Mes = pmTournamentStart then
  begin
    TournamentOverImage.Visible := false;
    ReconnectImage.Visible := false;
    MoveImage.Visible := false;
    BreakImage.Visible := false;
    WinnersMessImage.Visible := false;
    TournamentStartImage.Visible := true;
    TournamentStartImage.Top := 0;
    TournamentStartImage.Left := 0;
    Width := TournamentStartImage.Width;
    Height := TournamentStartImage.Height;
    MessageLabel.visible := false;
    Timer.Interval := 60000;
    Timer.Enabled := true;
    UpdateTimer.Enabled := false;
    AlphaBlend := true;
    AlphaBlendValue := 150;
    Show;
  end
  else
  if Mes = pmTournamentOver then
  begin
    ReconnectImage.Visible := false;
    MoveImage.Visible := false;
    BreakImage.Visible := false;
    WinnersMessImage.Visible := false;
    TournamentStartImage.Visible := false;
    TournamentOverImage.Visible := true;
    TournamentOverImage.Top := 0;
    TournamentOverImage.Left := 0;
    Width := TournamentOverImage.Width;
    Height := TournamentOverImage.Height;
    MessageLabel.visible := false;
    Timer.Interval := 10000;
    Timer.Enabled := true;
    UpdateTimer.Enabled := false;
    AlphaBlend := false;
    ShowModal;
  end;
end;

procedure TPictureMessageForm.ReconnectImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TPictureMessageForm.TimerTimer(Sender: TObject);
begin
  close;
end;

procedure TPictureMessageForm.UpdateTimerTimer(Sender: TObject);
begin
  Time := IncSecond(Time,-1);
  MessageLabel.Caption := FormatDateTime('hh:mm:ss',Time);
  if Time <= 0 then
   UpdateTimer.Enabled := false;
end;

end.
