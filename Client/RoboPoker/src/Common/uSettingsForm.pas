unit uSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls;

type
  TSettingsForm = class(TForm)
    EditButton: TSpeedButton;
    CancelButton: TSpeedButton;
    GroupBox1: TGroupBox;
    HostEdit: TLabeledEdit;
    PortEdit: TLabeledEdit;
    KeepConnectedCheckBox: TCheckBox;
    SSLCheckBox: TCheckBox;
    NewEdit: TLabeledEdit;
    GroupBox2: TGroupBox;
    AutoJoinNumberEdit: TLabeledEdit;
    AutoJoinGamersEdit: TLabeledEdit;
    TimeOutForSitDownEdit: TLabeledEdit;
    TimeOutOnResponseBotEdit: TLabeledEdit;
    TimeOutOnRefreshEdit: TLabeledEdit;
    AutoLeaveBotOnGamersEdit: TLabeledEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    MailListMemo: TMemo;
    ResponseTimeOutProcessesEdit: TLabeledEdit;
    ResponseTimeOutOnBotEntryEdit: TLabeledEdit;
    TimeOutOnHandTimelineEdit: TLabeledEdit;
    ManyTablesPlayCheckBox: TCheckBox;
    RestrictByNamesCheckBox: TCheckBox;
    RestrictedNamesEdit: TEdit;
    ActionDispatcherListEdit: TLabeledEdit;
    MaximumWorkTimeEdit: TLabeledEdit;
    StopCheckBox: TCheckBox;
    StartCheckBox: TCheckBox;
    CompressTrafficCheckBox: TCheckBox;
    LoggingCheckBox: TCheckBox;
    UseHeadersCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NumberEditKeyPress(Sender: TObject; var Key: Char);
    procedure EditButtonClick(Sender: TObject);
    procedure HostEditKeyUp(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    procedure Init;
  public
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

uses
  uLogger, uConstants, uCommonDataModule, uDataList, uConversions;


procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  Init;
  Logger.Log(0, ClassName, 'FormCreate', 'Created sucessfully', ltBase);
end;

procedure TSettingsForm.FormDestroy(Sender: TObject);
begin
  Logger.Log(0, ClassName, 'FormDestroy', 'Destroyed sucessfully', ltBase);
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  Init;
end;

procedure TSettingsForm.CancelButtonClick(Sender: TObject);
begin
  Init;
  Close;
end;

procedure TSettingsForm.Init;
begin
  KeepConnectedCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotKeepConnected];
  SSLCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotSSL];
  CompressTrafficCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotCompressTraffic];
  LoggingCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotLogging];
  HostEdit.Text := CommonDataModule.SessionSettings.ValuesAsString[BotRemoteHost];
  PortEdit.Text := CommonDataModule.SessionSettings.ValuesAsString[BotRemotePort];
  NewEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotNewConnectionsPerSecond]);
  AutoJoinGamersEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitGamers]);
  AutoJoinNumberEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitCount]);
  AutoLeaveBotOnGamersEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoLeaveOnGamers]);
  TimeOutForSitDownEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitTimeOut]);
  TimeOutOnResponseBotEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoResponseTimeOut]);
  TimeOutOnRefreshEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotRefreshInterval]);
  ResponseTimeOutProcessesEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotResponseTimeOutProcesses]);
  ResponseTimeOutOnBotEntryEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotResponseTimeOutOnBotEntry]);
  TimeOutOnHandTimelineEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotTimeOutOnHandTimeline]);
  MailListMemo.Text := StringReplace(CommonDataModule.SessionSettings.ValuesAsString[BotMailList], ';', #13#10, [rfReplaceAll]);
  RestrictedNamesEdit.Text := CommonDataModule.SessionSettings.ValuesAsString[BotRestrictedNames];
  RestrictByNamesCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotRestrictByNames];
  ManyTablesPlayCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotAllowManyTables];
  UseHeadersCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotUseHeaders];

  ActionDispatcherListEdit.Text := CommonDataModule.SessionSettings.ValuesAsString[BotActionDispatcherIDList];
  MaximumWorkTimeEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotMaximumWorkTime]);
  StopCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotStopAfterMaximumWorkTime];
  StartCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotRestartAfterMaximumWorkTime];

  HostEdit.Enabled := False;
  PortEdit.Enabled := False;
  NewEdit.Enabled := False;
  AutoJoinNumberEdit.Enabled := False;
  AutoJoinGamersEdit.Enabled := False;
  AutoLeaveBotOnGamersEdit.Enabled := False;
  TimeOutForSitDownEdit.Enabled := False;
  TimeOutOnResponseBotEdit.Enabled := False;
  TimeOutOnRefreshEdit.Enabled := False;
  ResponseTimeOutProcessesEdit.Enabled := False;
  ResponseTimeOutOnBotEntryEdit.Enabled := False;
  TimeOutOnHandTimelineEdit.Enabled := False;
  MailListMemo.Enabled := False;
  SSLCheckBox.Enabled := False;
  CompressTrafficCheckBox.Enabled := False;
  LoggingCheckBox.Enabled := False;
  KeepConnectedCheckBox.Enabled := False;
  ManyTablesPlayCheckBox.Enabled := False;
  UseHeadersCheckBox.Enabled := False;
  RestrictByNamesCheckBox.Enabled := False;
  RestrictedNamesEdit.Enabled := False;
  ActionDispatcherListEdit.Enabled := False;
  MaximumWorkTimeEdit.Enabled := False;
  StopCheckBox.Enabled := False;
  StartCheckBox.Enabled := False;

  EditButton.Caption := EditCaption;
end;

procedure TSettingsForm.EditButtonClick(Sender: TObject);
begin
  if EditButton.Caption = EditCaption then
  begin
    HostEdit.Enabled := True;
    PortEdit.Enabled := True;
    NewEdit.Enabled := True;
    AutoJoinNumberEdit.Enabled := True;
    AutoJoinGamersEdit.Enabled := True;
    AutoLeaveBotOnGamersEdit.Enabled := True;
    TimeOutForSitDownEdit.Enabled := True;
    TimeOutOnResponseBotEdit.Enabled := True;
    TimeOutOnRefreshEdit.Enabled := True;
    ResponseTimeOutProcessesEdit.Enabled := True;
    ResponseTimeOutOnBotEntryEdit.Enabled := True;
    TimeOutOnHandTimelineEdit.Enabled := True;
    MailListMemo.Enabled := True;
    SSLCheckBox.Enabled := True;
    CompressTrafficCheckBox.Enabled := True;
    LoggingCheckBox.Enabled := True;
    KeepConnectedCheckBox.Enabled := True;
    ManyTablesPlayCheckBox.Enabled := True;
    UseHeadersCheckBox.Enabled := True;
    RestrictByNamesCheckBox.Enabled := True;
    RestrictedNamesEdit.Enabled := True;
    ActionDispatcherListEdit.Enabled := True;
    MaximumWorkTimeEdit.Enabled := True;
    StopCheckBox.Enabled := True;
    StartCheckBox.Enabled := True;
    EditButton.Caption := SaveCaption;
  end
  else
  begin
    CommonDataModule.SessionSettings.ValuesAsString[BotRemoteHost] := HostEdit.Text;
    CommonDataModule.SessionSettings.ValuesAsString[BotRemotePort] := PortEdit.Text;
    CommonDataModule.SessionSettings.ValuesAsInteger[BotNewConnectionsPerSecond] := strtoint(NewEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitCount] := strtoint(AutoJoinNumberEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitGamers] := strtoint(AutoJoinGamersEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoLeaveOnGamers] := strtoint(AutoLeaveBotOnGamersEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitTimeOut] := strtoint(TimeOutForSitDownEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoResponseTimeOut] := strtoint(TimeOutOnResponseBotEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotRefreshInterval] := strtoint(TimeOutOnRefreshEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotResponseTimeOutProcesses] := strtoint(ResponseTimeOutProcessesEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotResponseTimeOutOnBotEntry] := strtoint(ResponseTimeOutOnBotEntryEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsInteger[BotTimeOutOnHandTimeline] := strtoint(TimeOutOnHandTimelineEdit.Text);
    CommonDataModule.SessionSettings.ValuesAsString[BotMailList] := StringReplace(MailListMemo.Text, #13#10, ';', [rfReplaceAll]);
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotKeepConnected] := KeepConnectedCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotSSL] := SSLCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotCompressTraffic] := CompressTrafficCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotLogging] := LoggingCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsString[BotRestrictedNames] := RestrictedNamesEdit.Text;
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotRestrictByNames] := RestrictByNamesCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotAllowManyTables] := ManyTablesPlayCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotUseHeaders] := UseHeadersCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsString[BotActionDispatcherIDList] := ActionDispatcherListEdit.Text;
    CommonDataModule.SessionSettings.ValuesAsInteger[BotMaximumWorkTime] := strtointdef(MaximumWorkTimeEdit.Text, CommonDataModule.SessionSettings.ValuesAsInteger[BotMaximumWorkTime]);
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotStopAfterMaximumWorkTime] := StopCheckBox.Checked;
    CommonDataModule.SessionSettings.ValuesAsBoolean[BotRestartAfterMaximumWorkTime] := StartCheckBox.Checked;
    CommonDataModule.SaveToRegistry;
    Init;
  end;
end;

procedure TSettingsForm.NumberEditKeyPress(Sender: TObject; var Key: Char);
begin
  if ((Key >= ' ') and (Key < '0')) or (Key > '9') then
    Key := #0;
end;

procedure TSettingsForm.HostEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then
    Close;
end;

end.
