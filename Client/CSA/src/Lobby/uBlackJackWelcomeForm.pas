unit uBlackJackWelcomeForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, jpeg, ExtCtrls;

type
  TBlackJackWelcomeForm = class(TForm)
    BlackJackWelcmeBackImage: TImage;
    RealMoneyButton: TTeButton;
    PlayMoneyButton: TTeButton;
    CancelButton: TTeButton;
    ButtonsBackgroundPanel: TTeHeaderPanel;
    procedure FormCreate(Sender: TObject);
    procedure RealMoneyButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;  
  public
    { Public declarations }
  end;

var
  BlackJackWelcomeForm: TBlackJackWelcomeForm;

implementation

uses uThemeEngineModule, uBlackJackLobbyForm;

{$R *.dfm}

procedure TBlackJackWelcomeForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self,
    BlackJackWelcmeBackImage.Width + 2, BlackJackWelcmeBackImage.Height-1);
end;

procedure TBlackJackWelcomeForm.RealMoneyButtonClick(Sender: TObject);
begin
  BlackJackLobbyForm.Show;
  Close;
end;

procedure TBlackJackWelcomeForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TBlackJackWelcomeForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TBlackJackWelcomeForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMaximized(Self);
end;

procedure TBlackJackWelcomeForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

end.
