unit uTransactionHistoryForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ComCtrls, StdCtrls, Mask, ExtCtrls;

type
  TTransactionHistoryForm = class(TForm)
    CancelButton: TTeButton;
    TeGroupBox1: TTeGroupBox;
    DateRadioButton: TTeRadioButton;
    DateFromButton: TTeButton;
    DateToLabel: TTeLabel;
    DateToButton: TTeButton;
    UpdateButton: TTeButton;
    CalendarPanel: TTeHeaderPanel;
    MonthCalendar: TMonthCalendar;
    CalendarTimer: TTimer;
    HistoryPageControl: TTePageControl;
    MoneyTabSheet: TTeTabSheet;
    BonusesTabSheet: TTeTabSheet;
    HistoryListView: TTeListView;
    BonusesListView: TTeListView;
    DateFromLabel: TTeLabel;
    TeLabel4: TTeLabel;
    TopLastEdit: TTeSpinEdit;
    LastRadioButton: TTeRadioButton;
    GroupBox1: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure CalendarTimerTimer(Sender: TObject);
    procedure MonthCalendarClick(Sender: TObject);
    procedure CalendarPanelButtonClick(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure DateRadioButtonClick(Sender: TObject);
    procedure LastRadioButtonClick(Sender: TObject);
    procedure MonthCalendarKeyPress(Sender: TObject; var Key: Char);
    procedure DateButtonClick(Sender: TObject);
    procedure MonthCalendarDblClick(Sender: TObject);
    procedure TopLastEditClick(Sender: TObject);
    procedure TopLastEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    DateFrom: TDateTime;
    DateTo: TDateTime;

    procedure OnTransactionHistory;
    procedure OnTransactionHistoryData;

    procedure CloseCalendar;

    procedure UpdateDates;
    function FillDatesFromMonthCalendar: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  TransactionHistoryForm: TTransactionHistoryForm;

implementation

uses
  uLogger, uConstants, uDataList, uConversions,
  uThemeEngineModule, uUserModule, uCashierModule;

{$R *.dfm}


// Common

procedure TTransactionHistoryForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Transactions history';
  ThemeEngineModule.FormsChangeConstraints(Self, 650, 350);
  CashierModule.OnTransactionHistory := OnTransactionHistory;
  CashierModule.OnTransactionHistoryData := OnTransactionHistoryData;
end;

procedure TTransactionHistoryForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTransactionHistoryForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TTransactionHistoryForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TTransactionHistoryForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;


// Transaction list

procedure TTransactionHistoryForm.OnTransactionHistoryData;
var
  Loop: Integer;
  curHistory: TDataList;
  curData: TDataList;
  curItem: TListItem;
begin
  HistoryListView.Clear;
  if CashierModule.History.Find(RealMoneyCurrencyID, curHistory) then
    for Loop := 0 to curHistory.Count - 1 do
    begin
      curData := curHistory.Items(Loop);
      curItem := HistoryListView.Items.Add;
      curItem.Caption := curData.ValuesAsString['date'];
      curItem.SubItems.Add(curData.ValuesAsString['type']);
      curItem.SubItems.Add(curData.ValuesAsString['comment']);
      curItem.SubItems.Add(Conversions.Cur2Str(Conversions.Str2Cur
        (curData.ValuesAsString['amount']), RealMoneyCurrencyID, 2));
      curItem.SubItems.Add(Conversions.Cur2Str(Conversions.Str2Cur
        (curData.ValuesAsString['balance']), RealMoneyCurrencyID, 2));
    end;

  BonusesListView.Clear;
  if CashierModule.History.Find(BonusCurrencyID, curHistory) then
    for Loop := 0 to curHistory.Count - 1 do
    begin
      curData := curHistory.Items(Loop);
      curItem := BonusesListView.Items.Add;
      curItem.Caption := curData.ValuesAsString['date'];
      curItem.SubItems.Add(curData.ValuesAsString['type']);
      curItem.SubItems.Add(curData.ValuesAsString['comment']);
      curItem.SubItems.Add(Conversions.Cur2Str(Conversions.Str2Cur
        (curData.ValuesAsString['amount']), BonusCurrencyID, 2));
      curItem.SubItems.Add(Conversions.Cur2Str(Conversions.Str2Cur
        (curData.ValuesAsString['balance']), BonusCurrencyID, 2));
    end;
end;


// Filter controls

procedure TTransactionHistoryForm.OnTransactionHistory;
begin
  if CashierModule.History.Count = 0 then
  begin
    HistoryListView.Clear;
    HistoryListView.Items.Add.Caption := cstrLobbyRetrievingInfo;
  end
  else
    OnTransactionHistoryData;

  DateFrom := CashierModule.CurrentDateFrom;
  DateTo := CashierModule.CurrentDateTo;
  UpdateDates;
  
  if CashierModule.CurrentTopLast = 0 then
  begin
    TopLastEdit.Text := inttostr(TransactionHistoryTopLastRecords);
    DateRadioButton.Checked := true;
  end
  else
  begin
    LastRadioButton.Checked := true;
    TopLastEdit.Text := inttostr(CashierModule.CurrentTopLast);
  end;

  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  HistoryPageControl.ActivePage := MoneyTabSheet;
  Show;
end;

procedure TTransactionHistoryForm.TopLastEditClick(Sender: TObject);
begin
  LastRadioButton.Checked := true;
end;

procedure TTransactionHistoryForm.TopLastEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  curControl: TTeSpinEdit;
begin
  curControl := Sender as TTeSpinEdit;
  if (curControl.Text = '') or (curControl.Text = '0') then
    curControl.Text := inttostr(round(curControl.MinValue));
  LastRadioButton.Checked := true;
end;

procedure TTransactionHistoryForm.LastRadioButtonClick(Sender: TObject);
begin
  CloseCalendar;
end;

procedure TTransactionHistoryForm.DateRadioButtonClick(Sender: TObject);
begin
  CloseCalendar;
end;

procedure TTransactionHistoryForm.DateButtonClick(Sender: TObject);
var
  ClientPoint: TPoint;
  curControl: TControl;
begin
  DateRadioButton.Checked := true;
  curControl := Sender as TControl;

  MonthCalendar.Tag := curControl.Tag;
  if MonthCalendar.Tag = 1 then
  begin
    CalendarPanel.Caption := 'Choose date from';
    MonthCalendar.Date := DateFrom
  end
  else
  begin
    CalendarPanel.Caption := 'Choose date to';
    MonthCalendar.Date := DateTo;
  end;

  ClientPoint := curControl.ClientOrigin;
  CalendarPanel.Left := ClientPoint.X - Left - 70;
  CalendarPanel.Top := ClientPoint.Y - Top - CalendarPanel.Height - 25;
  CalendarPanel.Visible := true;

  CalendarTimer.Enabled := true;
end;

procedure TTransactionHistoryForm.MonthCalendarClick(Sender: TObject);
begin
  FillDatesFromMonthCalendar;
  CalendarTimer.Enabled := False;
  CalendarTimer.Enabled := True;
end;

procedure TTransactionHistoryForm.MonthCalendarKeyPress(Sender: TObject;
  var Key: Char);
begin
  FillDatesFromMonthCalendar;
  CalendarTimer.Enabled := False;
  CalendarTimer.Enabled := True;
end;

function TTransactionHistoryForm.FillDatesFromMonthCalendar: Boolean;
begin
  Result := False;

  if MonthCalendar.Tag = 1 then
  begin
    if MonthCalendar.Date <= DateTo then
    begin
      DateFrom := MonthCalendar.Date;
      Result := True;
    end;
  end
  else
  begin
    if MonthCalendar.Date >= DateFrom then
    begin
      DateTo := MonthCalendar.Date;
      Result := True;
    end;
  end;

  if Result then
    UpdateDates;
end;

procedure TTransactionHistoryForm.MonthCalendarDblClick(Sender: TObject);
begin
  CloseCalendar;
  if not FillDatesFromMonthCalendar then
    ThemeEngineModule.ShowWarning(cstrCashierInvalidDate)
end;

procedure TTransactionHistoryForm.UpdateDates;
begin
  DateFromLabel.Caption := Conversions.Date2American(DateFrom);
  DateToLabel.Caption := Conversions.Date2American(DateTo);
end;

procedure TTransactionHistoryForm.CalendarTimerTimer(Sender: TObject);
begin
  CloseCalendar;
end;

procedure TTransactionHistoryForm.CalendarPanelButtonClick(Sender: TObject);
begin
  CloseCalendar;
end;

procedure TTransactionHistoryForm.CloseCalendar;
begin
  CalendarTimer.Enabled := false;
  CalendarPanel.Visible := false;
end;

procedure TTransactionHistoryForm.UpdateButtonClick(Sender: TObject);
var
  curTopLast: Integer;
begin
  CloseCalendar;

  if LastRadioButton.Checked then
    curTopLast := TopLastEdit.AsInteger
  else
    curTopLast := 0;

  CashierModule.Do_UpdateTransactionHistory(curTopLast, DateFrom, DateTo);
end;


end.
