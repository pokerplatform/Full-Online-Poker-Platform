unit uWaitingListJoinForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, StdCtrls;

type
  TWaitingListJoinForm = class(TForm)
    TeGroupBox1: TTeGroupBox;
    TeLabel1: TTeLabel;
    TableRadioButton: TTeRadioButton;
    GroupRadioButton: TTeRadioButton;
    PlayersSpinEdit: TTeSpinEdit;
    JoinButton: TTeButton;
    Cancel: TTeButton;
    TablePlayersLabel: TTeLabel;
    GroupBox1: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure TableRadioButtonClick(Sender: TObject);
    procedure GroupRadioButtonClick(Sender: TObject);
    procedure JoinButtonClick(Sender: TObject);
  private
    FProcessID: Integer;
    FGroupID: Integer;

    procedure OnWaitingList(ProcessID, GroupID, WaitingListPlayersCount: Integer;
      ProcessName: String);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  WaitingListJoinForm: TWaitingListJoinForm;

implementation

uses
  uLogger,
  uProcessModule,
  uLobbyModule,
  uThemeEngineModule, uConstants;

{$R *.dfm}

procedure TWaitingListJoinForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Join the Hold''em waiting list...';
  ThemeEngineModule.FormsChangeConstraints(Self, 350, 140);
  ProcessModule.OnWaitingList := OnWaitingList;
end;

procedure TWaitingListJoinForm.TableRadioButtonClick(Sender: TObject);
begin
  PlayersSpinEdit.Enabled := false;
end;

procedure TWaitingListJoinForm.GroupRadioButtonClick(Sender: TObject);
begin
  PlayersSpinEdit.Enabled := true;
end;

procedure TWaitingListJoinForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TWaitingListJoinForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TWaitingListJoinForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

procedure TWaitingListJoinForm.CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TWaitingListJoinForm.OnWaitingList(ProcessID, GroupID, WaitingListPlayersCount: Integer;
    ProcessName: String);
begin
  FProcessID := ProcessID;
  FGroupID := GroupID;
  TableRadioButton.Caption := ProcessName + ' table';
  TablePlayersLabel.Caption := 'There are ' + inttostr(WaitingListPlayersCount) + ' users before you.';

  TableRadioButton.Checked := true;
  GroupRadioButton.Checked := false;
  PlayersSpinEdit.Enabled := false;
  if not Visible then
    ThemeEngineModule.CenteringForm(Self);
  Show;
end;

procedure TWaitingListJoinForm.JoinButtonClick(Sender: TObject);
begin
  if TableRadioButton.Checked then
    ProcessModule.Do_RegisterWaitingList(FProcessID, 0, 0)
  else
    ProcessModule.Do_RegisterWaitingList(0, FGroupID, PlayersSpinEdit.AsInteger);
  Close;
end;

end.
