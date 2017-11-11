unit uChangePlayerImageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls, jpeg, GIFImage, ExtDlgs, XMLDoc, xmldom,
  XMLIntf, msxmldom;

type
  TChangePlayerImageForm = class(TForm)
    SaveButton: TTeButton;
    CancelButton: TTeButton;
    SelectImageButton: TTeButton;
    InfoLabel: TTeLabel;
    PlayerImage: TImage;
    OpenPictureDialog: TOpenPictureDialog;

    procedure FormCreate(Sender: TObject);
    procedure TeFormMaximize(Sender: TObject; var CallDefault: Boolean);
    procedure TeFormMinimize(Sender: TObject; var CallDefault: Boolean);
    procedure SelectImageButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SelectLogoImageFormOnOkButtonClick(ImageBitmap, LogoBitmap: TBitmap);
    procedure SaveButtonClick(Sender: TObject);
    procedure HTTPPostThreadResult(WebServiceResult: string);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    StringStream: TStringStream;
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ChangePlayerImageForm: TChangePlayerImageForm;

implementation

uses uSelectLogoImage, uThemeEngineModule, uSessionUtils, uHTTPPostThread,
  uUserModule, uConstants, uSessionModule;

//uses uThemeEngineModule;

{$R *.dfm}

procedure TChangePlayerImageForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TChangePlayerImageForm.FormCreate(Sender: TObject);
begin
   ThemeEngineModule.FormsChangeConstraints(Self,277,215);
   StringStream := TStringStream.Create('');
   SaveButton.Enabled := false;
   Caption := AppName + ' - Select Image';
end;

procedure TChangePlayerImageForm.TeFormMaximize(Sender: TObject;
  var CallDefault: Boolean);
begin
  //ThemeEngineModule.FormsMaximized(Self);
end;

procedure TChangePlayerImageForm.TeFormMinimize(Sender: TObject;
  var CallDefault: Boolean);
begin
  //ThemeEngineModule.FormsMinimized(Self);
end;

procedure TChangePlayerImageForm.SelectImageButtonClick(Sender: TObject);
begin
 //SelectImageForm.ShowForm('');
 SelectLogoImageForm.OnOkButtonClick := SelectLogoImageFormOnOkButtonClick;
 if OpenPictureDialog.Execute then
   SelectLogoImageForm.ShowForm(OpenPictureDialog.FileName);{}
end;

procedure TChangePlayerImageForm.CancelButtonClick(Sender: TObject);
begin
 Close;
end;

procedure TChangePlayerImageForm.SelectLogoImageFormOnOkButtonClick(ImageBitmap, LogoBitmap: TBitmap);
var
  JPEG: TJPEGImage;
  //Str: TMemoryStream;
begin
  PlayerImage.Picture.Bitmap.Assign(ImageBitmap);
  JPEG := TJPEGImage.Create;
  try
    JPEG.Assign(LogoBitmap);
    //JPEG.SaveToFile('d:\Logo.jpg');
    StringStream :=TStringStream.Create('');
    JPEG.SaveToStream(StringStream);
  finally
    JPEG.Free;
  end;{}
  SaveButton.Enabled := true;
end;

procedure TChangePlayerImageForm.SaveButtonClick(Sender: TObject);
var
  Buf: string;
  HTTPPostThread: THTTPPostThread;
  URL: String;
begin
 // URL := '196.40.45.132';
 URL := SessionModule.SessionSettings.ValuesAsString[SessionWebserviceHost];
  if StringStream <> nil then
  begin
    Buf := StringStream.DataString;
    Buf := EncodeBase64(Buf);
    HTTPPostThread := THTTPPostThread.Create(Self, Buf, StringStream.Size,StringStream.Size,IntToStr(UserModule.UserID)+'.jpg',
                          URL,'Avatars/'+UserModule.UserName,UserModule.UserID);
    HTTPPostThread.OnResult := HTTPPostThreadResult;
  end;  {}
  Close;
end;

procedure TChangePlayerImageForm.HTTPPostThreadResult(
  WebServiceResult: string);
begin
 if WebServiceResult = 'true' then
  ThemeEngineModule.ShowModalMessage(cstrUserLogoPosted)
 else
  ThemeEngineModule.ShowModalMessage(cstrUserPostError);
end;

procedure TChangePlayerImageForm.FormShow(Sender: TObject);
begin
 SaveButton.Enabled := false;
end;

end.
