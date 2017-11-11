unit uSelectLogoImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, GIFImage;

type
  TOnOkButtonClick = procedure(ImageBitmap,LogoBitmap: TBitmap) of object;

  TSelectLogoImageForm = class(TForm)
    PictureImage: TImage;
    LogoImage: TImage;
    OkButton: TButton;
    CancelButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure CancelButtonClick(Sender: TObject);
    procedure PictureImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PictureImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PictureImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    TemplateBitmap: TBitmap;
    Capturing : Boolean;
    Captured : Boolean;
    RecCanResize: Boolean;
    StartPlace : TPoint;
    EndPlace : TPoint;
    OldStartPlace : TPoint;
    OldEndPlace : TPoint;
    OldX, OldY: Integer;
    Kprop: Real;
    FOnOkButtonClick: TOnOkButtonClick;
    procedure SetOnOkButtonClick(const Value: TOnOkButtonClick);
    function MakeRect(Pt1: TPoint; Pt2: TPoint): TRect;
    procedure DrawRect(Canv: TCanvas;StartP, EndP: TPoint);
    procedure RedrawMainPicture(Bitmap: TBitmap);
    procedure MakeBitmapLess(var Bitmap: TBitmap; dx, dy: real);
    //procedure MakeBitmapLess(var Bitmap: TBitmap;);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    ImageWidth, ImageHeight: Integer;
    MouseDowned: Boolean;
    ImageBitMap: TBitmap;
    LogoBitMap: TBitmap;
    CurImageBitmap,FullImageBitmap : TBitmap;
    procedure ShowForm(ImageFileName: String);
    procedure EllipticBitmap(var Bmp:TBitmap;Bitmap: TBitmap);overload;
    procedure EllipticBitmap(var Bitmap: TBitmap);overload;
    function JPEGtoBMP(const FileName: TFileName):TBitMap;
    property OnOkButtonClick: TOnOkButtonClick read FOnOkButtonClick write SetOnOkButtonClick;
  end;

Const
    LogoWidth = 60;
    LogoHeight = 60;
var
  SelectLogoImageForm: TSelectLogoImageForm;

implementation

uses Types, uThemeEngineModule, uSessionModule, uConstants;

//uses uThemeEngineModule;

{$R *.dfm}


{ TSelectImageForm }

procedure TSelectLogoImageForm.ShowForm(ImageFileName: String);
begin
  FullImageBitmap := TBitmap.Create;
  CurImageBitmap := TBitmap.Create;
  if (pos('jpg',ImageFileName) > 0) or (pos('jpeg',ImageFileName) > 0) then
   CurImageBitmap := JPEGtoBMP(ImageFileName)
  else
   CurImageBitmap.LoadFromFile(ImageFileName);

  FullImageBitmap.Width := CurImageBitmap.Width;
  FullImageBitmap.Height := CurImageBitmap.Height;
  FullImageBitmap.Canvas.CopyRect(Rect(0,0,CurImageBitmap.Width, CurImageBitmap.Height),CurImageBitmap.Canvas,
                                  Rect(0,0,CurImageBitmap.Width, CurImageBitmap.Height));


  StartPlace.X := CurImageBitmap.Width div 2 - LogoWidth div 2;
  StartPlace.Y := CurImageBitmap.Height div 2 - LogoHeight div 2;
  EndPlace.X := StartPlace.X + LogoWidth;
  EndPlace.Y := StartPlace.Y + LogoHeight;
  DrawRect(CurImageBitmap.Canvas,StartPlace,EndPlace);
  RedrawMainPicture(CurImageBitmap);

  Kprop :=  CurImageBitmap.Width / (PictureImage.Width);
  if Kprop < 1 then
   Kprop := CurImageBitmap.Height / (PictureImage.Height);

  ShowModal;
end;

procedure TSelectLogoImageForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

 
function TSelectLogoImageForm.MakeRect(Pt1: TPoint; Pt2: TPoint): TRect;
begin
  if pt1.x < pt2.x then
  begin
    Result.Left := pt1.x;
    Result.Right := pt2.x;
  end
  else
  begin
    Result.Left := pt2.x;
    Result.Right := pt1.x;
  end;
  if pt1.y < pt2.y then
  begin
    Result.Top := pt1.y;
    Result.Bottom := pt2.y;
  end
  else
  begin
    Result.Top := pt2.y;
    Result.Bottom := pt1.y;
  end;
end;

procedure TSelectLogoImageForm.PictureImageMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
 X := round(X * Kprop);
 Y := round(Y * Kprop);
 Captured := false;
 with CurImageBitmap.Canvas do
 begin
  if (X >= StartPlace.x) and (X <= EndPlace.X) and (Y >= StartPlace.Y) and (Y <= EndPlace.Y) then
  begin
    Capturing := true;
    OldStartPlace.X := StartPlace.X;
    OldStartPlace.Y := StartPlace.Y;
    OldEndPlace.X := EndPlace.X;
    OldEndPlace.Y := EndPlace.Y;
    OldX := X;
    OldY := Y;
  end
  else
    Capturing := false;
 end;
  RecCanResize := false;
  if  (X >= EndPlace.x-3) and (X <= EndPlace.x)   and  (Y >= EndPlace.Y-3) and (Y <= EndPlace.Y) then
  begin
   RecCanResize := true;
   PictureImage.Cursor := crSizeNWSE;
  end;
end;

procedure TSelectLogoImageForm.DrawRect(Canv: TCanvas;StartP, EndP: TPoint);
var
  RectWidth, RectHeight: Integer;
  tempbrush: TBrush;
begin
  RectWidth := EndP.X - StartP.X;
  RectHeight := EndP.Y - StartP.Y;
  with Canv do
  begin
   //Pen.Mode := pmXor;
   Pen.Color := clBlack;
   Pen.Width := 1;
   Pen.Style := psDash; {}
   MoveTo(StartP.X,StartP.Y);
   LineTo(StartP.X + RectWidth,StartP.Y);
   LineTo(StartP.X + RectWidth,StartP.Y + RectHeight);
   LineTo(StartP.X,StartP.Y + RectHeight);
   LineTo(StartP.X,StartP.Y);
   tempbrush := TBrush.Create;
   tempbrush.Assign(Brush);
   Brush.Color := clBlack;
   FillRect(Rect(StartP.X+1,StartP.Y+1,StartP.X+5,StartP.y+5));
   FillRect(Rect(StartP.X+RectWidth-4,StartPlace.Y+1,StartP.X+RectWidth,StartP.Y+5));
   FillRect(Rect(StartP.X+RectWidth-4,StartP.Y+RectHeight-4,StartP.X+RectWidth,StartP.Y+RectHeight));
   FillRect(Rect(StartPlace.X+1,StartPlace.Y+RectHeight-4,StartPlace.X+5,StartPlace.Y+RectHeight));{}
   Brush.Assign(tempbrush);
   tempbrush.Free;{}
  end;
end;

procedure TSelectLogoImageForm.PictureImageMouseMove(Sender: TObject;
Shift: TShiftState; X, Y: Integer);
var dx, dy: Integer;
begin
 X := round(X * Kprop);
 Y := round(Y * Kprop);
   {SelectLogoImageForm.Caption := 'StartPlace.X:' + IntToStr(StartPlace.x) +
                                  ' StartPlace.Y:' + IntToStr(StartPlace.y) +
                                  ' EndPlace.X:' + IntToStr(EndPlace.x) +
                                  ' EndPlace.Y:' + IntToStr(EndPlace.y) +
                                  ' X:' + IntToStr(x) +
                                  ' Y:' + IntToStr(Y);{}
   dx := (OldX - X); dy := (OldY - Y);
  if (OldStartPlace.x - dx < 0) or (OldStartPlace.y - dy < 0) or (OldEndPlace.x - dx > CurImageBitmap.Width) or (OldEndPlace.Y - dy > CurImageBitmap.Height) then
  begin
    exit;
  end;

  if (X > StartPlace.x) and (X < EndPlace.X) and (Y > StartPlace.Y) and (Y < EndPlace.Y) then
   PictureImage.Cursor := crSizeAll
  else
   PictureImage.Cursor := crDefault;

  if  (X >= EndPlace.x-3) and (X <= EndPlace.x)   and  (Y >= EndPlace.Y-3) and (Y <= EndPlace.Y) then
  begin
   PictureImage.Cursor := crSizeNWSE;
   RecCanResize := true;
  end;
  
  if Capturing then
  with CurImageBitmap.Canvas do
  begin
    Captured := true;
     DrawFocusRect(MakeRect(StartPlace,EndPlace));
    if RecCanResize then
    begin
     if dx > dy then
     begin
      EndPlace.X := OldEndPlace.X - dx ;
      EndPlace.Y := OldEndPlace.Y - dx;
     end
     else
     begin
      EndPlace.X := OldEndPlace.X - dy ;
      EndPlace.Y := OldEndPlace.Y - dy;
     end;
     {if (StartPlace.X - EndPlace.X <= 60) or (StartPlace.Y - EndPlace.Y <= 60) then
       exit;{}
    end
    else
    begin
     StartPlace.x := OldStartPlace.x - dx;
     StartPlace.y := OldStartPlace.y - dy;
     EndPlace.x :=   OldEndPlace.x - dx;
     EndPlace.y := OldEndPlace.y - dy;
    end;
    CurImageBitmap.Canvas.DrawFocusRect(MakeRect(StartPlace,EndPlace));
    RedrawMainPicture(CurImageBitmap);
  end;{}
end;

procedure TSelectLogoImageForm.MakeBitmapLess(var Bitmap: TBitmap; dx, dy: real);
var
  bmp: TBitMap;
  z1, z2: single;
  k, k1, k2: single;
  x1, y1: integer;
  c: array [0..1, 0..1, 0..2] of byte;
  res: array [0..2] of byte;
  x, y: integer;
  xp, yp: integer;
  xo, yo: integer;
  col: integer;
  pix: TColor;
  t: Integer;
begin
 if (dx>0.5) and (dx<0.76) and (dy>0.5) and (dy<0.76) then
    t:=1
  else
  if (dx>0.6) and (dx<0.84) and (dy>0.76) and (dy<0.84) then
    t:=2
  else
  if (dx>0.84) and (dx<0.88) and (dy>0.84) and (dy<0.88) then
    t:=3
  else
   t := 0;

 bmp := TBitMap.Create;
 bmp.Width := round(bitmap.Width * dx);
 bmp.Height := round(bitmap.Height * dy);
 for y := 0 to bmp.Height - 1 do
 begin
  for x := 0 to bmp.Width - 1 do
  begin
    xo := trunc(x / dx)-t;
    yo := trunc(y / dy)-t;
    x1 := round(xo * dx)+t;
    y1 := round(yo * dy)+t;

    for yp := 0 to 1 do
     for xp := 0 to 1 do
     begin
       pix := Bitmap.Canvas.Pixels[xo + xp, yo + yp];
       c[xp, yp, 0] := GetRValue(pix);
       c[xp, yp, 1] := GetGValue(pix);
       c[xp, yp, 2] := GetBValue(pix);
      end;

    for col := 0 to 2 do begin
      k1 := (c[1,0,col] - c[0,0,col]) / dx;
      z1 := x * k1 + c[0,0,col] - x1 * k1;
      k2 := (c[1,1,col] - c[0,1,col]) / dx;
      z2 := x * k2 + c[0,1,col] - x1 * k2;
      k := (z2 - z1) / dy;
      res[col] := round(y * k + z1 - y1 * k);
    end;
      bmp.Canvas.Pixels[x,y] := RGB(res[0], res[1], res[2]);
  end;
 end;
 Bitmap.Assign(Bmp);
end;

procedure TSelectLogoImageForm.PictureImageMouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
var
  Bitmap, Bmp: TBitmap;
  LessenBitmap: TBitmap;
  dx, dy: Real;
begin
 //DrawRect(CurImageBitmap.Canvas,OldStartPlace,OldEndPlace);
  Capturing := false;
 if Captured then
 begin
  RedrawMainPicture(FullImageBitmap);
  CurImageBitmap.Canvas.CopyRect(Rect(0,0,CurImageBitmap.Width, CurImageBitmap.Height),FullImageBitmap.Canvas,
                                  Rect(0,0,CurImageBitmap.Width, CurImageBitmap.Height));
  Bmp :=  TBitmap.Create;
  Bmp.Width := TemplateBitmap.Width;
  Bmp.Height := TemplateBitmap.Height;
  Bmp.Canvas.CopyRect(Rect(0,0,LogoImage.Width,LogoImage.Height),TemplateBitmap.Canvas,Rect(0,0,LogoImage.Width,LogoImage.Height));
  Bitmap := TBitmap.Create;
  Bitmap.Canvas.CopyMode := cmSrcCopy;
  LessenBitmap := TBitmap.Create;
  LessenBitmap.Width := LogoWidth;{}
  LessenBitmap.Height := LogoHeight;{}

  Bitmap.Width := EndPlace.X - StartPlace.X;
  Bitmap.Height := EndPlace.Y - StartPlace.Y;
  Bitmap.Canvas.CopyRect(Rect(0,0,Bitmap.Width,Bitmap.Height),CurImageBitmap.Canvas,MakeRect(StartPlace,EndPlace));{}

  dx := LessenBitmap.Width / Bitmap.Width;
  dy := LessenBitmap.Height / Bitmap.Height;
  MakeBitmapLess(Bitmap, dx , dy);
  LessenBitmap.Assign(Bitmap);

  LogoBitMap.Width := 60;
  LogoBitMap.Height := 60;{}
  LogoBitMap.Canvas.CopyRect(Rect(0,0,LogoBitMap.Width,LogoBitMap.Height),LessenBitmap.Canvas,Rect(0,0,LessenBitmap.Width,LessenBitmap.Height));{}
  EllipticBitmap(LogoBitMap);


  EllipticBitmap(Bmp,LessenBitmap);
  ImageBitMap.Assign(Bmp);

  LogoImage.Canvas.Draw(0, 0, ImageBitmap);

  Bitmap.Free;
  LessenBitmap.free;
  Bmp.Free;
  DrawRect(CurImageBitmap.Canvas,StartPlace,EndPlace);
  RedrawMainPicture(CurImageBitmap);
 end;
end;

procedure TSelectLogoImageForm.FormShow(Sender: TObject);
Var Bitmap: TBitmap;
    Bmp: TBitmap;
begin

 if LogoBitMap <> nil then
    LogoBitMap.Free;
 if ImageBitMap <> nil then
    ImageBitMap.Free;
  LogoBitMap := TBitmap.Create;
  ImageBitMap := TBitmap.Create;
  Bitmap := TBitmap.Create;
  Bmp := TBitmap.Create;
  Bmp.Width := TemplateBitmap.Width;
  Bmp.Height := TemplateBitmap.Height;
  Bmp.Canvas.CopyRect(Rect(0,0,LogoImage.Width,LogoImage.Height),TemplateBitmap.Canvas,Rect(0,0,LogoImage.Width,LogoImage.Height));

  CurImageBitmap.Canvas.DrawFocusRect(MakeRect(StartPlace, EndPlace));{}
  //DrawRect(PictureImage.Canvas,StartPlace, EndPlace);
  Bitmap.Canvas.CopyMode := cmSrcCopy;
  Bitmap.Width := LogoWidth;
  Bitmap.Height := LogoHeight;
  Bitmap.Canvas.CopyRect(Rect(0,0,LogoWidth,LogoHeight),CurImageBitmap.Canvas,MakeRect(StartPlace,EndPlace));{}
  EllipticBitmap(Bmp,Bitmap);
  ImageBitMap.Assign(Bmp);
  LogoBitMap.Width := LogoWidth;
  LogoBitMap.Height := LogoHeight;
  LogoBitMap.Canvas.CopyRect(Rect(0,0,LogoWidth,LogoHeight),Bitmap.Canvas,Rect(0,0,LogoWidth,LogoHeight));{}
  EllipticBitmap(LogoBitMap);

  LogoImage.Canvas.Draw(0,0,ImageBitmap);

  Bitmap.Free;
  Bmp.Free;
  DrawRect(CurImageBitmap.Canvas,StartPlace,EndPlace);
end;

procedure TSelectLogoImageForm.EllipticBitmap(var Bmp:TBitmap;Bitmap: TBitmap);
type
  TRGB = record
    B, G, R: Byte;
  end;
  pRGB = ^TRGB;
var
  C: TRGB;
  x, y: Integer;
  Dest, Src: pRGB;
  Col: Longint;
  dx, dy, i: Integer;
begin
  Bitmap.PixelFormat := pf24Bit;
  Col := ColorToRGB(Color);
  C.R     := Col;
  C.G     := Col shr 8;
  C.B     := Col shr 16;
  Bmp.PixelFormat := Bitmap.PixelFormat;
  with Bmp.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBlack;
    Pen.Style := psClear;
    dx := abs(Bmp.Width - Bitmap.Width) div 2 - 1;
    dy := abs(Bmp.Height - Bitmap.Height) div 2 - 1;
    Ellipse(Rect(dx , dy, Bitmap.Width + dx + 2 , Bitmap.Height + dy + 3));  {}
  end;

  for y := 0 to Bitmap.Height - 1 do
  begin
    Src := Bitmap.ScanLine[y];
    Dest := Bmp.ScanLine[dy + y];
    for i := 0 to dx-1 do
     Inc(Dest);
    for x := 0 to Bitmap.Width - 1 do
    begin
      if Dest^.r = 0 then
      begin
        Dest^.R := Src^.R;
        Dest^.G := Src^.G;
        Dest^.B := Src^.B;
      end;
      if Src^.R = 255 then
      begin
        Dest^ := C;
      end;
      Inc(Dest);
      Inc(Src);
    end;

  end;   {}

end;

procedure TSelectLogoImageForm.EllipticBitmap(var Bitmap: TBitmap);
type
  TRGB = record
    B, G, R: Byte;
  end;
  pRGB = ^TRGB;
var
  C: TRGB;
  x, y: Integer;
  Dest, Src: pRGB;
  Col: Longint;
  Bmp: TBitmap;
begin
  Bitmap.PixelFormat := pf24Bit;
  Col := ColorToRGB(clWhite);
  C.R     := Col;
  C.G     := Col shr 8;
  C.B     := Col shr 16;
   try
    Bmp := TBitmap.Create;
    Bmp.Width := Bitmap.Width;
    Bmp.Height := Bitmap.Height;
    Bmp.PixelFormat := Bitmap.PixelFormat;
    with Bmp.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := clWhite;
      FillRect(Rect(0,0,Bmp.Width,Bmp.Height));
      Brush.Color := clBlack;
      Pen.Style := psClear;
      Ellipse(Rect(0, 0, Bmp.Width, Bmp.Height));  {}
    end;
    for y := 0 to Bitmap.Height - 1 do
    begin
      Src := Bmp.ScanLine[y];
      Dest := Bitmap.ScanLine[y];
      for x := 0 to Bitmap.Width - 1 do
      begin
        if Src^.R = 255 then
        begin
          Dest^ := C;
        end;
        Inc(Dest);
        Inc(Src);{}
      end;
    end;
   finally
    Bmp.Free;
   end;  
end;

function TSelectLogoImageForm.JPEGtoBMP(const FileName: TFileName):TBitMap;
var
  jpeg: TJPEGImage;
  bmp:  TBitmap;
begin
  jpeg := TJPEGImage.Create;
  try
    jpeg.CompressionQuality := 100; {Default Value}
    jpeg.LoadFromFile(FileName);
    bmp := TBitmap.Create;
    try
      bmp.Assign(jpeg);
      //bmp.SaveTofile(ChangeFileExt(FileName, '.bmp'));
      Result := bmp;
    finally
      //bmp.Free
    end;
  finally
    jpeg.Free
  end;
end;

procedure TSelectLogoImageForm.OkButtonClick(Sender: TObject);
begin
 if Assigned(FOnOkButtonClick) then
  FOnOkButtonClick(ImageBitMap,LogoBitmap);
 Close;
end;

procedure TSelectLogoImageForm.SetOnOkButtonClick(const Value: TOnOkButtonClick);
begin
  FOnOkButtonClick := Value;
end;

procedure TSelectLogoImageForm.FormCreate(Sender: TObject);
begin
 ThemeEngineModule.FormsChangeConstraints(Self,471,343);
 TemplateBitmap := TBitmap.Create;
 TemplateBitmap.Width := LogoImage.Width;
 TemplateBitmap.Height := LogoImage.Height;
 TemplateBitmap.Canvas.CopyRect(Rect(0,0,LogoImage.Width,LogoImage.Height),LogoImage.Picture.Bitmap.Canvas, Rect(0,0,LogoImage.Width,LogoImage.Height));
 DoubleBuffered := true;
 Caption := AppName + ' - Select Image';
end;

procedure TSelectLogoImageForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TSelectLogoImageForm.RedrawMainPicture(Bitmap: TBitmap);
begin
  //FullImageBitmap.Canvas.StretchDraw(Rect(0,0,PictureImage.Width,PictureImage.Height),FullImageBitmap);
  PictureImage.Picture.Bitmap.Assign(Bitmap);
end;

end.
