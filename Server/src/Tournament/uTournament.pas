unit uTournament;

interface

uses
  SysUtils, xmldom, XMLIntf, msxmldom, XMLDoc
//
  , uTournamentList
  ;

type

  TTournament = class(TObject)
  private
    FTournamentListThread: TTournamentListThread;
  public
    property TournamentListThread: TTournamentListThread read FTournamentListThread;
    //
    procedure ProcessAction(ActionXML: IXMLNode);
//    procedure RingUp;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  uCommonDataModule
  , uLogger
  , uXMLActions
  , uTouConstants
  , uErrorConstants
  , uSQLAdapter
  , DateUtils
  , uXMLConstants
  ;

procedure TTournament.ProcessAction(ActionXML: IXMLNode);
begin
  CommonDataModule.Log( ClassName, 'OnProcessAction', 'Start OnProcessAction: ActionXML=[' + ActionXML.XML + ']', ltCall );

  // set initial values as undefined
  if not ActionXML.HasAttribute('name') then Exit;
  if not (ActionXML.Attributes['name'] = OBJ_TOURNAMENT) then Exit;

  FTournamentListThread.ProcessAction(ActionXML);

  CommonDataModule.Log( ClassName, 'OnProcessAction', 'Finish OnProcessAction', ltCall );
end;

// Service functionality

constructor TTournament.Create;
begin
  inherited;
  FTournamentListThread := TTournamentListThread.Create;
end;

destructor TTournament.Destroy;
begin
  FTournamentListThread.Free;
  inherited;
end;

end.
