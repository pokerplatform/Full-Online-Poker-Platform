unit uAboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, JvLabel, JvHotLink;

type
  TAboutForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ClientVersionDataLabel: TLabel;
    ServerVersionDataLabel: TLabel;
    ProtocolVersionDataLabel: TLabel;
    IPAdressLabel: TLabel;
    ServerTimeLabel: TLabel;
    OkButton: TButton;
    Copyrightlabel: TJvHotLink;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    function GetLocalIP: String;
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  AboutForm: TAboutForm;

implementation

uses uConstants, uLobbyModule, uThemeEngineModule, WinSock;

{$R *.dfm}

procedure TAboutForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
 Caption := 'About ' + AppName;   
 ThemeEngineModule.FormsChangeConstraints(Self, 355, 165);
 ClientVersionDataLabel.Caption := CSA_Version;
 ServerVersionDataLabel.Caption := '195';
 ProtocolVersionDataLabel.Caption := '1.01';
 IPAdressLabel.Caption := GetLocalIP;
 Copyrightlabel.Caption := 'Copyright ' + chr(169) + ' 2005 ' + AppName+'.com';
 Copyrightlabel.Url := 'http://'+AppName+'.com';
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  ServerTimeLabel.Caption := LobbyModule.ServerLongDateTime;
end;

procedure TAboutForm.OkButtonClick(Sender: TObject);
begin
  Close;
end;

function TAboutForm.GetLocalIP: String;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

end.
