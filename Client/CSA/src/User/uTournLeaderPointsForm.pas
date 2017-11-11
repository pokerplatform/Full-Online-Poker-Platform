unit uTournLeaderPointsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TTournLeaderPointsForm = class(TForm)
    FromMonthBox: TComboBox;
    FromDayBox: TComboBox;
    FromYearBox: TComboBox;
    ToMonthBox: TComboBox;
    ToDayBox: TComboBox;
    ToYearBox: TComboBox;
    OkButton: TButton;
    CanceButton: TButton;
    ErrorLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PrepareBoxes;
    procedure FromMonthBoxChange(Sender: TObject);
    procedure CanceButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  TournLeaderPointsForm: TTournLeaderPointsForm;

implementation

uses uThemeEngineModule, DateUtils, uUserModule, uConstants;

{$R *.dfm}

procedure TTournLeaderPointsForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TTournLeaderPointsForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Tournament Leader Points';
  ThemeEngineModule.FormsChangeConstraints(Self, 300, 179);
  PrepareBoxes;
end;

procedure TTournLeaderPointsForm.PrepareBoxes;
var year, month, day: word;
    weekOfYear, dayOfWeek: word;
begin
  DecodeDate(Now,year,month,day);
  ToMonthBox.ItemIndex :=  month-1;
  ToDayBox.ItemIndex :=  day-1;
  ToYearBox.Items.Add(IntToStr(year-1));
  ToYearBox.Items.Add(IntToStr(year));
  ToYearBox.ItemIndex := 1;

  DecodeDateWeek(Now,year,weekOfYear,dayOfWeek);
  FromMonthBox.ItemIndex  := month-1;
  FromDayBox.ItemIndex :=  day-dayofweek-1;
  FromYearBox.Items.Add(IntToStr(year-1));
  FromYearBox.Items.Add(IntToStr(year));
  FromYearBox.ItemIndex := 1;
end;


procedure TTournLeaderPointsForm.FromMonthBoxChange(Sender: TObject);
var Date: TDateTime;
begin
  OkButton.Enabled := true;
  ErrorLabel.Caption := '';
 if not TryEncodeDate(StrtoInt(FromYearBox.text),FromMonthBox.ItemIndex+1,FromDayBox.ItemIndex+1,Date) then
 begin
   OkButton.Enabled := false;
   ErrorLabel.Caption := 'Invalid From Date';
 end;

 if not TryEncodeDate(StrtoInt(ToYearBox.text),ToMonthBox.ItemIndex+1,ToDayBox.ItemIndex+1,Date) then
 begin
   OkButton.Enabled := false;
   ErrorLabel.Caption := 'Invalid To Date';
 end;

 if ToYearBox.ItemIndex = FromYearBox.ItemIndex then
 begin
    if ToMonthBox.ItemIndex < FromMonthBox.ItemIndex then
    begin
      OkButton.Enabled := false;
      ErrorLabel.Caption := 'Error: From is after To';
    end;

    if ToMonthBox.ItemIndex = FromMonthBox.ItemIndex then
    if ToDayBox.ItemIndex < FromDayBox.ItemIndex then
    begin
      OkButton.Enabled := false;
      ErrorLabel.Caption := 'Error: From is after To';
    end;
 end
 else
 if ToYearBox.ItemIndex < FromYearBox.ItemIndex then
 begin
  OkButton.Enabled := false;
  ErrorLabel.Caption := 'Error: From is after To';
 end;

end;

procedure TTournLeaderPointsForm.CanceButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTournLeaderPointsForm.OkButtonClick(Sender: TObject);
var FromTime, ToTime: TDateTime;
    hour, minute, sec, milsec: word;
begin
  DecodeTime(Now,hour, minute, sec, milsec);
  FromTime := EncodeDate(StrtoInt(FromYearBox.text),FromMonthBox.ItemIndex+1,FromDayBox.ItemIndex+1);
  ToTime := EncodeDateTime(StrtoInt(ToYearBox.text),ToMonthBox.ItemIndex+1,ToDayBox.ItemIndex+1,hour, minute, sec, milsec);
  UserModule.Do_GetLeaderPoints(DateToStr(FromTime),FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',ToTime));
  close;
end;

end.
