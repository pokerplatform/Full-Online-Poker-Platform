//      Project: Poker
//         Unit: uTalingForm.pas
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es):
//  Description:

unit uTakingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, jpeg, ExtCtrls, StdCtrls,
  uThemeEngineModule, uConstants,
  uSessionModule;

type
  TTakingFormCloseEventProc = procedure (ID1, ID2: Integer) of object;

  TTakingForm = class(TForm)
    BackgroundPanel: TTeHeaderPanel;
    StatusLabel: TTeLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    FOnCloseForm: TTakingFormCloseEventProc;
    FID1: Integer;
    FID2: Integer;
  public
    procedure SetOnCloseEvent(OnCloseForm: TTakingFormCloseEventProc;
      ID1, ID2: Integer);
  end;

implementation

{$R *.dfm}

procedure TTakingForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TTakingForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self, 350, 100);
  ThemeEngineModule.CenteringForm(Self);

  Caption := AppName;
  //TeForm.Caption := Caption;
  FOnCloseForm := nil;
  FID1 := 0;
  FID2 := 0;
end;

procedure TTakingForm.SetOnCloseEvent(OnCloseForm: TTakingFormCloseEventProc;
  ID1, ID2: Integer);
begin
  FOnCloseForm := OnCloseForm;
  FID1 := ID1;
  FID2 := ID2;
end;

procedure TTakingForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FOnCloseForm) then
    FOnCloseForm(FID1, FID2);
end;

end.
