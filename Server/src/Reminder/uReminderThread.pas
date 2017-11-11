unit uReminderThread;

interface

uses
  Classes, SyncObjs, ActiveX, DXString,
  uSettings, uLocker;

type
  TRemindAction = record
    RemindCommand: String;
    ExecTime: TDateTime;
    ProcessID: Integer;
    SessionID: Integer;
    ID: String;
    Data: String;
  end;

  TReminderThread = class(TThread)
  private
    FCriticalSection: TLocker;
    FRemindActions: array of TRemindAction;
    FRemindCommands: array of TRemindAction;

    procedure Add(RemindAction: TRemindAction);
    procedure Change(RemindAction: TRemindAction);
    procedure Remove(RemindAction: TRemindAction);
    procedure Reset(RemindAction: TRemindAction);

    function Find(ID: String; var Index: Integer): Boolean;
  protected
    procedure Execute; override;
  public
    procedure AddCommand(ACommand, AID, AData: String;
      AExecTime: TDateTime; ASessionID, AProcessID: Integer);

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses SysUtils, Variants
  , uCommonDataModule
  , uLogger
  , uXMLConstants
  , ComObj, Math;

{ TReminderThread }

// Create and Destroy

constructor TReminderThread.Create;
begin
  inherited Create(True);
  FCriticalSection := CommonDataModule.ThreadLockHost.Add('reminder');
  SetLength(FRemindActions, 0);
  SetLength(FRemindCommands, 0);
  Resume;
end;


destructor TReminderThread.Destroy;
begin
  Terminate;
  WaitFor;

  SetLength(FRemindActions, 0);
  SetLength(FRemindCommands, 0);

  CommonDataModule.ThreadLockHost.Del(FCriticalSection);
  inherited;
end;

// Command

procedure TReminderThread.AddCommand(ACommand, AID, AData: String;
  AExecTime: TDateTime; ASessionID, AProcessID: Integer);
begin
  FCriticalSection.Lock;
  try
    SetLength(FRemindCommands, Length(FRemindCommands) + 1);
    with FRemindCommands[Length(FRemindCommands) - 1] do
    begin
      RemindCommand := ACommand;
      ID := AID;
      Data := AData;
      ExecTime := AExecTime;
      SessionID := ASessionID;
      ProcessID := AProcessID;
    end;
  finally
    FCriticalSection.UnLock;
  end;
end;


// Actions

function TReminderThread.Find(ID: String; var Index: Integer): Boolean;
var
  Loop: Integer;
begin
  Result := False;
  for Loop := 0 to Length(FRemindActions) - 1 do
    if FRemindActions[Loop].ID = ID then
    begin
      Index := Loop;
      Result := True;
      break;
    end;
end;

procedure TReminderThread.Add(RemindAction: TRemindAction);
var
  Index: Integer;
  Loop: Integer;
  nCount: Integer;
begin
  nCount := Length(FRemindActions);
  Index := -1;
  for Loop := 0 to nCount - 1 do
  begin
    if FRemindActions[Loop].ID = '' then
      Index := Loop
    else
    if FRemindActions[Loop].ID = RemindAction.ID then
    begin
      CommonDataModule.Log(ClassName, 'Add',
        'Reminder already exists ID=' + RemindAction.ID, ltError);
      Exit;
    end;
  end;
    
  if Index >= 0 then
    FRemindActions[Index] := RemindAction
  else
  begin
    SetLength(FRemindActions, nCount + 10);
    FRemindActions[nCount] := RemindAction;
    for Loop := nCount + 1 to Length(FRemindActions) - 1 do
      with FRemindActions[Loop] do
      begin
        ID := '';
        Data := '';
        RemindCommand := '';
        ExecTime := MaxDouble;
        ProcessID := 0;
        SessionID := 0;
      end;
  end;
end;

procedure TReminderThread.Change(RemindAction: TRemindAction);
var
  Index: Integer;
begin
  if Find(RemindAction.ID, Index) then
    FRemindActions[Index] := RemindAction
  else
    CommonDataModule.Log(ClassName, 'Change', 'Reminder does not exists ID=' + RemindAction.ID, ltError);
end;

procedure TReminderThread.Reset(RemindAction: TRemindAction);
var
  Index: Integer;
begin
  if Find(RemindAction.ID, Index) then
    FRemindActions[Index].ExecTime := RemindAction.ExecTime
  else
    CommonDataModule.Log(ClassName, 'Reset', 'Reminder does not exists ID=' + RemindAction.ID, ltError);
end;

procedure TReminderThread.Remove(RemindAction: TRemindAction);
var
  Index: Integer;
begin
  if Find(RemindAction.ID, Index) then
  with FRemindActions[Index] do
  begin
    ID := '';
    Data := '';
    RemindCommand := '';
    ExecTime := MaxDouble;
    ProcessID := 0;
    SessionID := 0;
  end
  else
    CommonDataModule.Log(ClassName, 'Remove', 'Reminder does not exists ID=' + RemindAction.ID, ltCall);
end;


// Thread execution

procedure TReminderThread.Execute;
var
  Loop: Integer;
  RemindAction: TRemindAction;
  NowTime: TDateTime;
begin
  inherited;

  CommonDataModule.Log(ClassName, 'Execute', 'Thread has been started', ltBase);
  CoInitialize(nil);

  while not Terminated do
  try
    // Do Reminder commands
    FCriticalSection.Lock;
    try
      if Length(FRemindCommands) > 0 then
        for Loop := 0 to Length(FRemindCommands) - 1 do
        begin
          RemindAction := FRemindCommands[Loop];
          if RemindAction.RemindCommand = SC_CREATEREMIND then
            Add(RemindAction)
          else
          if RemindAction.RemindCommand = SC_CHANGEREMIND then
            Change(RemindAction)
          else
          if RemindAction.RemindCommand = SC_REMOVEREMIND then
            Remove(RemindAction)
          else
          if RemindAction.RemindCommand = SC_RESETREMIND then
            Reset(RemindAction);
        end;
      SetLength(FRemindCommands, 0);
    finally
      FCriticalSection.UnLock;
    end;

    NowTime := Now;
    if Length(FRemindActions) > 0 then
      for Loop := 0 to Length(FRemindActions) - 1 do
      with FRemindActions[Loop] do
        if (ID <> '') and (ExecTime <= NowTime) then
        begin
          CommonDataModule.Log(ClassName, 'Execute', 'Process: ' + Data, ltRequest);
          CommonDataModule.ProcessAction(Data);
          ID := '';
          Data := '';
          RemindCommand := '';
          ExecTime := MaxDouble;
          ProcessID := 0;
          SessionID := 0;
        end;

    Sleep(500);
  except
    on e: Exception do
      CommonDataModule.Log(ClassName, 'Execute', e.Message, ltException);
  end;

  CoUninitialize;
  CommonDataModule.Log(ClassName, 'Execute', 'Thread has been finished', ltBase);
end;

end.




