unit uTournamentList;

interface

uses XMLIntf, XMLDoc, SyncObjs, Classes, ActiveX
//
  , uTouClasses
  , uXMLActions
  , uSQLAdapter
  , uSettings
  , uLocker
  ;

var
  CriticalSection: TLocker;

type

// *************************************
// Tournament List with Thread Executor context
// *************************************
  TTournamentListThread = class(TThread)
  private
    FInputActions: TXMLActions;
    FTournaments: TtsTournamentList;

    FLastCheckUpdateLobbyInfoTime: TDateTime;
    FLastCheckEventsTime: TDateTime;
    FLastCheckFinishedTime: TDateTime;
  protected
    procedure Execute; override;

  public
    property Tournaments: TtsTournamentList read FTournaments;

    // methods
    procedure ProcessAction(ActionXML: IXMLNode);
    procedure RingUp;

    // constructor & destructor
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, DateUtils
{$IFDEF __TEST__}
  , uTournamentTest
{$ENDIF}
  , uCommonDataModule
  , uLogger
  , uTouConstants
  , uErrorConstants
  , uXMLConstants
  , uGameConnector
  , uCommonFunctions
  , uEmail, DB;

{ TTournamentListThread }

constructor TTournamentListThread.Create;
var
  FSQL: TSQLAdapter;
  I: Integer;
  aTrn: TtsTournament;
begin
  inherited Create(True);
{$IFDEF __TEST__}
  FSQL := nil;
{$ELSE}
  FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

  FInputActions := TXMLActions.Create;
  FTournaments := TtsTournamentList.Create;
  FTournaments.LoadFromDB(FSQL);

  FLastCheckUpdateLobbyInfoTime := Now;
  FLastCheckEventsTime := Now;
  FLastCheckFinishedTime := Now;

  for I:=0 to FTournaments.Count - 1 do begin
    aTrn := FTournaments.Items[I];
    if aTrn.TournamentStatusID <> tstAdminPause then
      aTrn.StopTournament(FSQL, aTrn.Actions)
    else
      aTrn.EndPauseByAdminOnCreate(FSQL);
  end;
  FTournaments.StoreToDB(FSQL);

{$IFNDEF __TEST__}
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
{$ENDIF}

  CriticalSection := CommonDataModule.ThreadLockHost.Add('tournamentlist');

  Resume;
end;

destructor TTournamentListThread.Destroy;
var
  FSQL: TSQLAdapter;
  I: Integer;
  aTrn: TtsTournament;
begin
  Terminate;
  WaitFor;

{$IFDEF __TEST__}
  FSQL := nil;
{$ELSE}
  FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

  for I:=0 to FTournaments.Count - 1 do begin
    aTrn := FTournaments.Items[I];
    aTrn.PauseByAdminOnDestroy(FSQL);
    if (aTrn.TournamentStatusID <> tstAdminPause) then
      aTrn.StopTournament(FSQL, aTrn.Actions);
  end;
  FTournaments.StoreToDB(FSQL);

  FInputActions.Free;

{$IFNDEF __TEST__}
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
{$ENDIF}

  CommonDataModule.ThreadLockHost.Del(CriticalSection);
  FTournaments.Free;

  inherited;
end;

procedure TTournamentListThread.Execute;
var
  aAct: TXMLAction;
begin
  inherited;
  CommonDataModule.Log( ClassName, 'Execute', 'Thread has been started', ltCall );
  CoInitialize(nil);

  while not Terminated do begin
    try
      try
        RingUp;
      except
        on e: Exception do
          CommonDataModule.Log(ClassName, 'Execute', '[EXCEPTION]: ' + e.Message, ltException);
      end;

      if FInputActions.Count > 0 then
      try
        while FInputActions.Count > 0 do begin
          CriticalSection.Lock;
          try
            aAct := FInputActions.Item[0];
          finally
            CriticalSection.UnLock;
          end;

          // check on TournamentID (must be > 0)
          if not ((aAct.Name = anEndOfHand)      or
                  (aAct.Name = anGetDefaultProperty) or
                  (aAct.Name = anSetDefaultProperty)
                 )
          then begin
            if aAct.TournamentID <= 0 then begin
              CriticalSection.Lock;
              try
                FInputActions.Del(aAct);
              finally
                CriticalSection.UnLock;
              end;
              Continue;
            end;
          end;

          CriticalSection.Lock;
          try
            FTournaments.ProcessAction(aAct);
            FInputActions.Del(aAct);
          finally
            CriticalSection.UnLock;
          end;
        end;
      except
        on E:Exception do
        begin
          CommonDataModule.Log(ClassName, 'Execute',
            '[EXCEPTION] in main circle: ' + E.Message, ltException);
          FInputActions.Clear;
        end;
      end;

      // execute responce packets
      CriticalSection.Lock;
      try
        FTournaments.Execute;
      finally
        CriticalSection.UnLock;
      end;

    finally
      // nothing
    end;

    Sleep(10);
  end;

  CriticalSection.Lock;
  try
    FInputActions.Clear;
  finally
    CriticalSection.UnLock;
  end;

  CommonDataModule.Log( ClassName, 'ProcessAction', 'Finish ProcessAction', ltCall );
  CoUninitialize;
end;

procedure TTournamentListThread.ProcessAction(ActionXML: IXMLNode);
var
  I: Integer;
begin
  try
    for I := 0 to ActionXML.ChildNodes.Count - 1 do
    begin
      CriticalSection.Lock;
      try
        FInputActions.Add(ActionXML.ChildNodes[I]);
      finally
        CriticalSection.UnLock;
      end;
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ProcessAction', E.Message, ltException);
  end;
end;

procedure TTournamentListThread.RingUp;
var
  I: Integer;
  aTrn: TtsTournament;
begin
  // Check timer events for update lobby info
  if IncSecond(FLastCheckUpdateLobbyInfoTime, ttcCheckUpdateLobbyInfo_Sec) < Now then
  begin
    CriticalSection.Lock;
    try
      FTournaments.UpdateLobbyInfo;
    finally
      CriticalSection.UnLock;
    end;
    FLastCheckUpdateLobbyInfoTime := Now;
  end;

  // Check timer events of all tournaments
  if IncSecond(FLastCheckEventsTime, ttcCheckEvents_Sec) < Now then
  begin
    for I:=0 to FTournaments.Count - 1 do begin
      CriticalSection.Lock;
      try
        aTrn := FTournaments.Items[I];
        aTrn.CheckOnTimeEvent(aTrn.Actions);
      finally
        CriticalSection.UnLock;
      end;
      //aTrn.Execute;
    end;
    FLastCheckEventsTime := Now;
  end;


  // check on delete on finish time
  if IncSecond(FLastCheckFinishedTime, ttcCheckFinished_Sec) < Now then
  begin
    for I:= FTournaments.Count - 1 downto 0 do begin
      CriticalSection.Lock;
      try
        aTrn := FTournaments.Items[I];
        if aTrn.IsCompleted then begin
          if IncHour(aTrn.TournamentFinishTime, DELETEONFINISHINTERVAL) <= Now then begin
            FTournaments.Del(aTrn);
          end;
        end;

        if aTrn.IsStopped then begin
          FTournaments.Del(aTrn);
        end;
      finally
        CriticalSection.UnLock;
      end;
    end;
    FLastCheckFinishedTime := Now;
  end;
end;


end.
