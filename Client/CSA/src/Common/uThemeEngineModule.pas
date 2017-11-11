//      Project: Poker
//         Unit: uThemeEngineModule.pas
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es): TThemeEngineModule
//  Description: Keep ThemeEngine object, store visual theme

unit uThemeEngineModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Controls, te_engine, te_controls,
  ComCtrls, ExtCtrls, Graphics;

const
  TextOffset = 5;
  ThemeBorderHeight = 28;
  ThemeBorderWidth = 6;

type
  TThemeEngineModule = class(TDataModule)
    ThemeEngine: TTeThemeEngine;
    TeThemeList: TTeThemeList;
  public
    procedure FormsCreateParams(Form: TForm; var Params: TCreateParams);
    procedure FormsChangeConstraints(Form: TForm;
      ClientAreaWidth, ClientAreaHeight: Integer);
    procedure CenteringForm(Form: TForm);

    procedure FormsMinimized(Form: TForm);
    procedure FormsMaximized(Form: TForm);

    function  AskQuestion(const Text: String): Boolean;
    procedure ShowWarning(const Text: String);
    procedure ShowModalMessage(const Text: String);
    procedure ShowMessage(const Text: String);

    procedure ListViewDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState; CustomBackColor: TColor = -1);
    function CropText(var curText: String; curCanvas: TCanvas;
      curWidth: Integer): Integer;

    function GetThemeForm(Form: TForm): TTeForm;

    procedure DeActivateAllForms;
    procedure ActivateCurrentForm;
    procedure ActivateForm(Form: TForm);
  end;

var
  ThemeEngineModule: TThemeEngineModule;

implementation

uses
  uLogger, uSessionModule, uConstants,
  uMessageForm, Types;

{$R *.dfm}
                  
// Form procedures

procedure TThemeEngineModule.FormsCreateParams(Form: TForm;var Params: TCreateParams);
begin
  with Params do begin
    Style := Style OR WS_SYSMENU AND (NOT WS_MAXIMIZE);
    ExStyle := ExStyle OR WS_EX_APPWINDOW;
    WndParent := HWND_DESKTOP;
  end;
end;

procedure TThemeEngineModule.FormsChangeConstraints(Form: TForm;
  ClientAreaWidth, ClientAreaHeight: Integer);
begin
  Form.Caption := Form.Caption;
  Form.BorderIcons := [biSystemMenu,biMinimize];

  //FormWidth := ClientAreaWidth + ThemeBorderWidth;
  //FormHeight := ClientAreaHeight + ThemeBorderHeight;
  Form.ClientWidth := ClientAreaWidth;
  Form.ClientHeight := ClientAreaHeight;

  Form.Constraints.MinWidth := Form.Width;
  Form.Constraints.MinHeight := Form.Height;
  Form.Constraints.MaxWidth := Form.Width;
  Form.Constraints.MaxHeight := Form.Height;{}

  {TeForm.Constraints.MinWidth := FormWidth;
  TeForm.Constraints.MinHeight := FormHeight;
  TeForm.Constraints.MaxWidth := FormWidth;
  TeForm.Constraints.MaxHeight := FormHeight;{}

 { Form.Width := FormWidth;
  Form.Height := FormHeight;{}

  //TeForm.Active := True;
end;

procedure TThemeEngineModule.CenteringForm(Form: TForm);
begin
  if (Screen.WorkAreaHeight <= Form.Height) or
    (Screen.WorkAreaWidth <= Form.Width) then
  begin
    Form.Left := 0;//(Screen.Width - Form.Width) div 2;
    Form.Top := 0;//(Screen.Height - Form.Height) div 2;
  end
  else
  begin
    Form.Left := Screen.WorkAreaRect.Left +
      ((Screen.WorkAreaRect.Right - Screen.WorkAreaRect.Left - Form.Width) div 2);
    Form.Top := Screen.WorkAreaRect.Top +
      ((Screen.WorkAreaRect.Bottom - Screen.WorkAreaRect.Top - Form.Height) div 2);
  end;
end;

function TThemeEngineModule.GetThemeForm(Form: TForm): TTeForm;
var
  i: integer;
begin
  Result := nil;
  if Form <> nil then
  begin
    for i := 0 to Form.ComponentCount - 1 do
      if Form.Components[i] is TTeForm then
      begin
        Result := Form.Components[i] as TTeForm;
        Exit;
      end;
  end;
end;

procedure TThemeEngineModule.FormsMaximized(Form: TForm);
begin
  if Form.Top < 0 then Form.Top := 0;
  if Form.Left < 0 then Form.Left := 0;
end;

procedure TThemeEngineModule.FormsMinimized(Form: TForm);
begin
//
end;


// Activate/Deactivate forms

procedure TThemeEngineModule.DeActivateAllForms;
var
  Loop: Integer;
  curTeForm: TTeForm;
begin
  for Loop := 0 to Screen.FormCount - 1 do
  begin
    curTeForm := GetThemeForm(Screen.Forms[Loop]);
    if curTeForm <> nil then
      if curTeForm.StayOnTop then
        if curTeForm.Tag <> 777 then
        begin
          curTeForm.StayOnTop := false;
          curTeForm.Update;
        end;
  end;
end;

procedure TThemeEngineModule.ActivateCurrentForm;
begin
  if SessionModule.SessionState <> poTerminating then
    ActivateForm(Screen.ActiveForm)
end;

procedure TThemeEngineModule.ActivateForm(Form: TForm);
var
  curTeForm: TTeForm;
  Loop: Integer;
  curForm: TForm;
begin
  if SessionModule.SessionState <> poTerminating then
    if Form <> nil then
      if (Screen.WorkAreaHeight <= Form.Height) or
        (Screen.WorkAreaWidth <= Form.Width) then
      begin
        curTeForm := GetThemeForm(Form);
        if curTeForm <> nil then
        begin
          curTeForm.StayOnTop := true;
          curTeForm.Update;

          if curTeForm.Tag <> 777 then
            for Loop := 0 to Screen.FormCount - 1 do
            begin
              curForm := Screen.Forms[Loop];
              if curForm <> Form then
                if curForm.Visible and (curForm.WindowState <> wsMinimized) then
                begin
                  curTeForm := GetThemeForm(curForm);
                  if curTeForm.Tag = 777 then
                  begin
                    curTeForm.StayOnTop := not curTeForm.StayOnTop;
                    curTeForm.StayOnTop := not curTeForm.StayOnTop;
                    curTeForm.Update;
                  end;
                end;
            end;
        end;
      end;
end;

// Alerts

function TThemeEngineModule.AskQuestion(const Text: String): Boolean;
var
  MessageForm: TMessageForm;
begin
  MessageForm := TMessageForm.CreateParented(0);
  Result := MessageForm.StartWork(msgConfirm, True, Text);
end;

procedure TThemeEngineModule.ShowWarning(const Text: String);
var
  MessageForm: TMessageForm;
begin
  MessageForm := TMessageForm.CreateParented(0);
  MessageForm.StartWork(msgWarning, True, Text);
end;

procedure TThemeEngineModule.ShowMessage(const Text: String);
var
  MessageForm: TMessageForm;
begin
 if Text <> '' then
 begin
  MessageForm := TMessageForm.CreateParented(0);
  MessageForm.StartWork(msgMessage, False, Text);
 end; 
end;

procedure TThemeEngineModule.ShowModalMessage(const Text: String);
var
  MessageForm: TMessageForm;
begin  MessageForm := TMessageForm.CreateParented(0);
  MessageForm.StartWork(msgMessage, True, Text);
end;


// List item draw

procedure TThemeEngineModule.ListViewDrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState; CustomBackColor: TColor = -1);
var
  myCanvas: TCanvas;
  Loop: Integer;
  ListView: TTeListView;
  curText: String;
  X: Integer;
  curColumn: TListColumn;
begin
  ListView := Sender as TTeListView;
  myCanvas := TCanvas.Create;
  myCanvas.Handle := GetDC(ListView.Handle);
  myCanvas.Brush.Style := bsSolid;
  if CustomBackColor >= 0 then
    myCanvas.Brush.Color := CustomBackColor
  else
    if odSelected in State then
      myCanvas.Brush.Color := ListViewSelectedBackgroundColor
    else
      if Item.Index mod 2 = 1 then
        myCanvas.Brush.Color := ListViewBackgroundColor
      else
        myCanvas.Brush.Color := ListViewRowBackgroundColor;

  Rect.Left := 0;
  Rect.Right := ListView.Width - 1;
  myCanvas.FillRect(Rect);

  myCanvas.Font.Color := ListViewTextColor;
  myCanvas.Font.Name := 'Tahoma';
  myCanvas.Font.Size := 8;
  myCanvas.Font.Style := [];
  myCanvas.TextFlags := ETO_OPAQUE;
  X := TextOffset;

  for Loop := 0 to ListView.Columns.Count - 1 do
  begin

    if Loop = 0 then
      curText := Item.Caption
    else
      if Loop - 1 < Item.SubItems.Count then
        curText := Item.SubItems.Strings[Loop - 1]
      else
        curText := '';

    curColumn := ListView.Columns.Items[Loop];
    CropText(curText, myCanvas, curColumn.Width - TextOffset);
    myCanvas.TextOut(X, Rect.Top, curText);
    X := X + curColumn.Width;
  end;

  if odFocused in State then
    myCanvas.DrawFocusRect(Rect);
end;

function TThemeEngineModule.CropText(var curText: String;
  curCanvas: TCanvas; curWidth: Integer): Integer;
var
  txtLength: Integer;
begin
  while curCanvas.TextWidth(curText) > curWidth do
  begin
    txtLength := length(curText);
    if txtLength > 4 then
    begin
      SetLength(curText, txtLength - 1);
      curText[txtLength - 1] := '.';
      curText[txtLength - 2] := '.';
      curText[txtLength - 3] := '.';
    end
    else
    begin
      curText := '...';
      break;
    end;
  end;
  Result := (curWidth - curCanvas.TextWidth(curText)) div 2;
end;

end.
