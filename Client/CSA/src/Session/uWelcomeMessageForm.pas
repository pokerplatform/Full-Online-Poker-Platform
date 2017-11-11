unit uWelcomeMessageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, OleCtrls, SHDocVw;

type
  TWelcomeMessageForm = class(TForm)
    Ok: TTeButton;
    MessageBrowser: TWebBrowser;
    DonShowtCheckBox: TTeCheckBox;
    procedure OkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DonShowtCheckBoxClick(Sender: TObject);
    procedure MessageBrowserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure MessageBrowserNavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure ShowForm;
  end;

var
  WelcomeMessageForm: TWelcomeMessageForm;

implementation

uses uThemeEngineModule, uLobbyForm, uSessionModule,uConstants, ShellApi,
  uLobbyModule;

{$R *.dfm}

procedure TWelcomeMessageForm.OkClick(Sender: TObject);
begin
  Close;
end;

procedure TWelcomeMessageForm.FormCreate(Sender: TObject);
begin
 ThemeEngineModule.FormsChangeConstraints(Self, 465,346);
 Caption := AppName + 'Welcome Message';
 if not SessionModule.SessionSettings.ValuesAsBoolean[SessionHideWelcomeMessage] then
  MessageBrowser.Navigate(cstrWelcomeMessageLink);
end;

procedure TWelcomeMessageForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  LobbyForm.ShowLobby;
end;

procedure TWelcomeMessageForm.ShowForm;
begin
  if not SessionModule.SessionSettings.ValuesAsBoolean[SessionHideWelcomeMessage] then
   Show;{}
end;

procedure TWelcomeMessageForm.DonShowtCheckBoxClick(Sender: TObject);
begin
  if DonShowtCheckBox.Checked then
   SessionModule.SessionSettings.ValuesAsBoolean[SessionHideWelcomeMessage] := true;
end;

procedure TWelcomeMessageForm.MessageBrowserBeforeNavigate2(
  Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName,
  PostData, Headers: OleVariant; var Cancel: WordBool);
var Link : String;
begin
  if lowercase(URL) = lowercase(cstrWelcomeMessageLink) then
   cancel := false
  else
  begin
    cancel := true;
    Link := URL;
    ShellExecute(0,pchar('open'),pchar(Link),nil,nil,SW_RESTORE);
  end;
end;

procedure TWelcomeMessageForm.MessageBrowserNavigateComplete2(
  Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  {LobbyModule.WB_Set3DBorderStyle(Sender, False);
  // Draw a double line border
  LobbyModule.WB_SetBorderStyle(Sender, 'double');
  // Set a border color
  LobbyModule.WB_SetBorderColor(Sender, '#6495ED');{}
  MessageBrowser.OleObject.Document.Body.Style.OverflowX := 'hidden';
  MessageBrowser.OleObject.Document.Body.Style.OverflowY := 'hidden';
end;

procedure TWelcomeMessageForm.FormShow(Sender: TObject);
begin
  MessageBrowser.Navigate(cstrWelcomeMessageLink);
end;

procedure TWelcomeMessageForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

end.
