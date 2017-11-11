unit uBlackJackLobbyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, jpeg, ExtCtrls;

type
  TBlackJackLobbyForm = class(TForm)
    BlackJackLobbyBackGroundImage: TImage;
    TeButton1: TTeButton;
    procedure FormCreate(Sender: TObject);
    procedure TeButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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
  BlackJackLobbyForm: TBlackJackLobbyForm;

implementation

uses uThemeEngineModule, uLobbyModule;

{$R *.dfm}

procedure TBlackJackLobbyForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self,
    BlackJackLobbyBackGroundImage.Width, BlackJackLobbyBackGroundImage.Height);
end;

procedure TBlackJackLobbyForm.TeButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TBlackJackLobbyForm.FormActivate(Sender: TObject);
begin
  LobbyModule.MinimizeLobby;
end;

procedure TBlackJackLobbyForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  LobbyModule.ShowLobby;
end;

procedure TBlackJackLobbyForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TBlackJackLobbyForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
 ThemeEngineModule.FormsMaximized(Self);
end;

procedure TBlackJackLobbyForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  ThemeEngineModule.FormsMinimized(Self);
end;

end.
