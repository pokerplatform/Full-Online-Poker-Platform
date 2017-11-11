unit uLoyaltyStore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ExtCtrls, ComCtrls, StdCtrls, jpeg;

type
  TLoyaltyStoreForm = class(TForm)
    BackImage: TImage;
    TeHeaderPanel1: TTeHeaderPanel;
    TeHeaderControl1: TTeHeaderControl;
    TableListView: TTeListView;
    Label1: TLabel;
    CloseButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;  
  public
    { Public declarations }
  end;

var
  LoyaltyStoreForm: TLoyaltyStoreForm;

implementation

uses uThemeEngineModule, uConstants;

{$R *.dfm}

procedure TLoyaltyStoreForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self, Params);
end;

procedure TLoyaltyStoreForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Loyalty Store';
  ThemeEngineModule.FormsChangeConstraints(Self, 394, 287);
  Label1.Caption := 'Loyalty Store' + #13#10 + 'Opening Soon!';
end;

procedure TLoyaltyStoreForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

end.
