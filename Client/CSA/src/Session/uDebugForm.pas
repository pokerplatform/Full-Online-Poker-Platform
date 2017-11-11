unit uDebugForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TDebugStatus = (dsReady, dsWorking, dsDone, dsError);

  TDebugForm = class(TForm)
    XMLMemo: TMemo;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RobotNameEdit: TLabeledEdit;
    RobotQuantityEdit: TLabeledEdit;
    RobotsButton: TButton;
    GroupBox3: TGroupBox;
    SrvRqstButton: TButton;
    SrvRqstEdit: TLabeledEdit;
    GroupBox4: TGroupBox;
    SrvRspnButton: TButton;
    SrvRspnEdit: TLabeledEdit;
    LoadXMLButton: TButton;
    ButtonSaveXML: TButton;
    StatusLabel: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure SrvRspnButtonClick(Sender: TObject);
    procedure LoadXMLButtonClick(Sender: TObject);
    procedure SrvRqstButtonClick(Sender: TObject);
    procedure ButtonSaveXMLClick(Sender: TObject);
    procedure RobotsButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure SetStatus(NewDebugStatus: TDebugStatus; ResultLine: String; TimeCount: Cardinal);
  public
    { Public declarations }
  end;

implementation

uses
  uParserModule, uTCPSocketModule;

{$R *.dfm}

procedure TDebugForm.SetStatus(NewDebugStatus: TDebugStatus;
  ResultLine: String; TimeCount: Cardinal);
var
  StatusLine: String;
begin
  StatusLine := '';
  case NewDebugStatus of
    dsReady:
      StatusLine := 'Ready...';
    dsWorking:
      StatusLine := 'Working...';
    dsDone:
      StatusLine := 'Done.';
    dsError:
      StatusLine := 'Error...';
  end;
  StatusLabel.Caption := StatusLine + #13#10 + ResultLine + #13#10 +
    'Time: ' + IntToStr(TimeCount) + 'cnt';
end;

procedure TDebugForm.LoadXMLButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    XMLMemo.Lines.LoadFromFile(OpenDialog.FileName);
end;

procedure TDebugForm.ButtonSaveXMLClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    XMLMemo.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TDebugForm.SrvRqstButtonClick(Sender: TObject);
var
  LoopCount: Integer;
  Loop: Integer;
  TimeCount: Cardinal;
begin
  LoopCount := StrToIntDef(SrvRqstEdit.Text, 0);
  if LoopCount < 1 then
    SetStatus(dsError, '', 0)
  else
  begin
    TimeCount := GetTickCount;
    for Loop := 1 to LoopCount do
    begin
      SetStatus(dsWorking, inttostr(Loop), GetTickCount - TimeCount);
      Application.ProcessMessages;
      TCPSocketModule.Send(XMLMemo.Lines.Text);
      sleep(0);
    end;
    SetStatus(dsDone, '', GetTickCount - TimeCount);
  end;
end;

procedure TDebugForm.SrvRspnButtonClick(Sender: TObject);
var
  LoopCount: Integer;
  Loop: Integer;
  TimeCount: Cardinal;
begin
  LoopCount := StrToIntDef(SrvRspnEdit.Text, 0);
  if LoopCount < 1 then
    SetStatus(dsError, '', 0)
  else
  begin
    TimeCount := GetTickCount;
    for Loop := 1 to LoopCount do
    begin
      SetStatus(dsWorking, inttostr(Loop), GetTickCount - TimeCount);
      Application.ProcessMessages;
      ParserModule.OnCommandReceived(XMLMemo.Lines.Text);
      sleep(0);
    end;
    SetStatus(dsDone, '', GetTickCount - TimeCount);
  end;
end;

procedure TDebugForm.RobotsButtonClick(Sender: TObject);
var
  LoopCount: Integer;
  Loop: Integer;
  TimeCount: Cardinal;
  RobotName: String;
begin
  LoopCount := StrToIntDef(SrvRspnEdit.Text, 0);
  if LoopCount < 1 then
    SetStatus(dsError, '', 0)
  else
  begin
    TimeCount := GetTickCount;
    for Loop := 1 to LoopCount do
    begin
      SetStatus(dsWorking, inttostr(Loop), GetTickCount - TimeCount);
      Application.ProcessMessages;
      RobotName := RobotNameEdit.Text + inttostr(Loop);
      ParserModule.Send_Register(RobotName, 'qwerty1', RobotName, RobotName,
        RobotName + '@email.com', RobotName, true, 1);
      sleep(0);
    end;
    SetStatus(dsDone, '', GetTickCount - TimeCount);
  end;
end;

procedure TDebugForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.


