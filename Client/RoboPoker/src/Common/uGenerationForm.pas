unit uGenerationForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls;

type
  TGenerationForm = class(TForm)
    NameEdit: TLabeledEdit;
    MaskRadioButton: TRadioButton;
    FileRadioButton: TRadioButton;
    LocationEdit: TLabeledEdit;
    LocationCheckBox: TCheckBox;
    FileNameEdit: TEdit;
    CountEdit: TLabeledEdit;
    PasswordEdit: TLabeledEdit;
    MaleCheckBox: TCheckBox;
    ProgressLabel: TLabel;
    FileOpenDialog: TOpenDialog;
    BrowseButton: TSpeedButton;
    GenerateButton: TSpeedButton;
    CancelButton: TSpeedButton;
    procedure GenerateButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NumberEditKeyPress(Sender: TObject; var Key: Char);
    procedure BrowseButtonClick(Sender: TObject);
    procedure FileNameEditMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NameEditMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NameEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FileNameEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Init;
    procedure OnComplete(Percent: Integer);
  end;

var
  GenerationForm: TGenerationForm;

implementation

{$R *.dfm}

uses
  uLogger, uConstants, uCommonDataModule, uDataList, uConversions;


procedure TGenerationForm.FormCreate(Sender: TObject);
begin
  Init;
  DoubleBuffered := True;
  Logger.Log(0, ClassName, 'FormCreate', 'Created sucessfully', ltBase);
end;

procedure TGenerationForm.FormDestroy(Sender: TObject);
begin
  Logger.Log(0, ClassName, 'FormDestroy', 'Destroyed sucessfully', ltBase);
end;

procedure TGenerationForm.FormShow(Sender: TObject);
begin
  Init;
end;

procedure TGenerationForm.CancelButtonClick(Sender: TObject);
begin
  Init;
  Close;
end;

procedure TGenerationForm.Init;
begin
  ProgressLabel.Caption := ' ';
  FileNameEdit.Text := '';
  MaskRadioButton.Checked := True;
  NameEdit.Text := CommonDataModule.SessionSettings.ValuesAsString[BotGenerationName];
  PasswordEdit.Text := CommonDataModule.SessionSettings.ValuesAsString[BotGenerationPassword];
  LocationEdit.Text := CommonDataModule.SessionSettings.ValuesAsString[BotGenerationLocation];
  CountEdit.Text := inttostr(CommonDataModule.SessionSettings.ValuesAsInteger[BotGenerationCount]);
  LocationCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotGenerationPrivate];
  MaleCheckBox.Checked := CommonDataModule.SessionSettings.ValuesAsBoolean[BotGenerationMale];
end;

procedure TGenerationForm.GenerateButtonClick(Sender: TObject);
begin
  with CommonDataModule.SessionSettings do
  begin
    ValuesAsString[BotGenerationName] := NameEdit.Text;
    ValuesAsString[BotGenerationPassword] := PasswordEdit.Text;
    ValuesAsString[BotGenerationLocation] := LocationEdit.Text;
    ValuesAsInteger[BotGenerationCount] := strtoint(CountEdit.Text);
    ValuesAsBoolean[BotGenerationPrivate] := LocationCheckBox.Checked;
    ValuesAsBoolean[BotGenerationMale] :=MaleCheckBox.Checked;
  end;

  if MaskRadioButton.Checked then
  begin
    CommonDataModule.GenerateBotsByMask(OnComplete);
    ShowMessage('Bots "' + NameEdit.Text + '1".."' +
       NameEdit.Text + CountEdit.Text + '" were generated!');
  end
  else
  if FileExists(FileNameEdit.Text) then
  begin
    CommonDataModule.GenerateBotsFromFile(OnComplete, FileNameEdit.Text);
    ShowMessage('Bots from file ' + FileNameEdit.Text + ' were generated!');
  end
  else
    ShowMessage('File ' + FileNameEdit.Text + ' does not exists!');
  ProgressLabel.Caption := '';
end;

procedure TGenerationForm.BrowseButtonClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then
    FileNameEdit.Text := FileOpenDialog.FileName;
end;

procedure TGenerationForm.FileNameEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  FileRadioButton.Checked := True;
end;

procedure TGenerationForm.FileNameEditMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FileRadioButton.Checked := True;
end;

procedure TGenerationForm.NameEditMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MaskRadioButton.Checked := True;
end;

procedure TGenerationForm.NameEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  MaskRadioButton.Checked := True;
end;

procedure TGenerationForm.NumberEditKeyPress(Sender: TObject; var Key: Char);
begin
  if ((Key >= ' ') and (Key < '0')) or (Key > '9') then
    Key := #0;
end;

procedure TGenerationForm.OnComplete(Percent: Integer);
begin
  ProgressLabel.Caption := inttostr(Percent) + '% done.';
end;

end.
