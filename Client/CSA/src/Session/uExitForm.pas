unit uExitForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg;

type
  TExitForm = class(TForm)
    Image1: TImage;
    ExitTimer: TTimer;
    procedure ExitTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExitForm: TExitForm;

implementation

uses uCashierForm;

{$R *.dfm}

procedure TExitForm.ExitTimerTimer(Sender: TObject);
begin
  close;
end;

procedure TExitForm.FormShow(Sender: TObject);
begin
  ExitTimer.Enabled  := true;
end;

end.
