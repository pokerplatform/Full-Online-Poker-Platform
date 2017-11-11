unit uTournamentLeaderBoardForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, ComCtrls, uDataList;

type
  TPLeaderBoard = ^TLeaderBoard;
  TLeaderBoard = record
    LoginName: string;
    Points: Currency;
  end;

  TTournamentLeaderBoardForm = class(TForm)
    DataListView: TListView;
    Button1: TButton;
    PeriodLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ShowForm;
    procedure AddItems;
    procedure ShellSort(PlayersList: TList);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  TournamentLeaderBoardForm: TTournamentLeaderBoardForm;

implementation

uses uThemeEngineModule, uLobbyModule;

{$R *.dfm}

{ TTournamentLeaderForm }

procedure TTournamentLeaderBoardForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  ThemeEngineModule.FormsCreateParams(Self,  Params);
end;

procedure TTournamentLeaderBoardForm.FormCreate(Sender: TObject);
begin
  ThemeEngineModule.FormsChangeConstraints(Self, 449,368);
end;

procedure TTournamentLeaderBoardForm.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TTournamentLeaderBoardForm.ShowForm;
begin
  AddItems;
  WindowState := wsNormal;
  Show;
end;

procedure TTournamentLeaderBoardForm.AddItems;
var Loop: Integer;
   ListItem: TListItem;
   Data: TDataList;
   Period: string;
   Item: TPLeaderBoard;
   PlayersList: TList;
begin
 try
  PlayersList := TList.Create;

  DataListView.Clear;
  Period := LobbyModule.LeaderBoardRequestType;

  if Period = 'thisweek' then  Period := 'This Week';
  if Period = 'thismonth' then  Period := 'This Month';
  if Period = 'thisyear' then  Period := 'This Year';
  if Period = 'previousweek' then  Period := 'Previous Week';
  if Period = 'previousmonth' then  Period := 'Previous Month';
  if Period = 'previousyear' then  Period := 'Previous Year';

  Caption := 'Tournament Leader Board - '+ Period;
  PeriodLabel.Caption := 'From '+ LobbyModule.LeaderBoardFromTime + ' to ' +
             LobbyModule.LeaderBoardToTime;

  DataListView.Columns[0].Width := 0;
  for Loop := 0 to LobbyModule.LeaderBoards.Count-1 do
  begin
    LobbyModule.LeaderBoards.Find(Loop,Data);
    new(Item);
    Item^.LoginName := Data.ValuesAsString['loginname'];
    Item^.Points := Data.ValuesAsCurrency['points'];
    PlayersList.Add(Item);
  end;{}
  ShellSort(PlayersList);
  for Loop := 0 to PlayersList.Count-1 do
  begin
    Item := PlayersList.Items[Loop];
    ListItem := DataListView.Items.Add;
    ListItem.Caption := '';
    ListItem.SubItems.Add(IntToStr(Loop+1));
    ListItem.SubItems.Add(Item^.LoginName);
    ListItem.SubItems.Add(CurrToStr(Trunc(Item^.Points)));{}
  end;
 finally
   PlayersList.Free;
 end;
end;

procedure TTournamentLeaderBoardForm.ShellSort(PlayersList: TList);
var d, i : integer;
     k : boolean; { пpизнак пеpестановки }
     Item1, Item2: TPLeaderBoard;
     tempData: TPLeaderBoard;
     Count: Integer;
begin
  Count := PlayersList.Count;
  d:= Count div 2;  { начальное значение интеpвала }
   while d > 0 do
   begin { цикл с yменьшением интеpвала до 1 }
     { пyзыpьковая соpтиpовка с интеpвалом d }
     k:=true;
     while k do
     begin  { цикл, пока есть пеpестановки }
       k:=false;
       for i:=0 to Count-d-1 do
       begin
         { сpавнение эл-тов на интеpвале d }
         Item1 := PlayersList.Items[i];
         Item2 := PlayersList.Items[i+d];
         if Item1^.Points < Item2^.Points then
         begin
           tempData := PlayersList.Items[i]; PlayersList.Items[i]:=PlayersList.Items[i+d];
           PlayersList.Items[i+d]:=tempData; { пеpестановка }
           k:=true;  { пpизнак пеpестановки }
         end; { if ... }
       end; { for ... }
     end; { while k }
     d:=d div 2;  { yменьшение интеpвала }
   end;  { while d>0 }
 (**)
end;


end.
