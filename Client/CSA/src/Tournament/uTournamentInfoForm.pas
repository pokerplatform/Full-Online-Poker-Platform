unit uTournamentInfoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, te_controls, ComCtrls, StdCtrls, uDataList;

type
  TTournamentInfoForm = class(TForm)
    Label1: TLabel;
    StartingChipsCountLabel: TLabel;
    Label3: TLabel;
    LevelsListView: TListView;
    PrizesListView: TListView;
    CloseButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
    FStartingChips: string;
    FLevelsData: TDataList;
    FPrizesData: TDataList;
    procedure SetData(const Value: TDataList);
    procedure SetStartingChips(const Value: string);
    procedure SetPrizesData(const Value: TDataList);
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    property StartingChips: string read FStartingChips write SetStartingChips;
    property LevelsData: TDataList read FLevelsData write SetData;
    property PrizesData: TDataList read FPrizesData write SetPrizesData;

    procedure ShowForm;
  end;

implementation

uses uThemeEngineModule, uConstants;

{$R *.dfm}

procedure TTournamentInfoForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TTournamentInfoForm.FormCreate(Sender: TObject);
begin
  Caption := AppName + ' - Tournament Info';
  ThemeEngineModule.FormsChangeConstraints(Self, 440, 510);
end;

procedure TTournamentInfoForm.SetData(const Value: TDataList);
begin
  FLevelsData := Value;
end;

procedure TTournamentInfoForm.SetStartingChips(const Value: string);
begin
  FStartingChips := Value;
end;

procedure TTournamentInfoForm.SetPrizesData(const Value: TDataList);
begin
  FPrizesData := Value;
end;

procedure TTournamentInfoForm.FormShow(Sender: TObject);
var ListItem: TListItem;
    Loop: Integer;
    DataItem: TDataList;
    ante: string;
begin
  StartingChipsCountLabel.Caption := StartingChips;
  LevelsListView.Clear;
  LevelsListView.Columns[0].Width := 0;
  for Loop := 0 to LevelsData.Count-1 do
  begin
    ListItem := LevelsListView.Items.Add;
    ListItem.Caption := '';
    LevelsData.Find(Loop,DataItem);
    ListItem.SubItems.Add(IntToStr(Loop+1));
    ListItem.SubItems.Add(DataItem.ValuesAsString['blinds']);
    ante := DataItem.ValuesAsString['ante'];
    if ante <> '0' then
      ListItem.SubItems.Add(ante)
    else
      ListItem.SubItems.Add('');
    ListItem.SubItems.Add(DataItem.ValuesAsString['time']);
  end;
  PrizesListView.Columns[0].Width := 0;
  for Loop := 0 to PrizesData.Count-1 do
  begin
    ListItem := PrizesListView.Items.Add;
    ListItem.Caption := '';
    PrizesData.Find(Loop,DataItem);
    ListItem.SubItems.Add(IntToStr(Loop+1));
    ListItem.SubItems.Add(DataItem.ValuesAsString['value']);
  end;
end;

procedure TTournamentInfoForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTournamentInfoForm.ShowForm;
begin
 WindowState := wsNormal;
 Show;
end;

end.
