unit uObjectPool;

// OffshoreCreations Inc. (C) 2004
// Author: Maxim Korablev

interface

uses
  Windows, SysUtils, DateUtils, SyncObjs, DXString,
  // Objects units
  uAPI, uAccount, uEmail, uFileManager, uSQLAdapter, uUser, uInfoCash,
  uCacheContainer, uLocker;

const
  UpdateCounters_Sec = 1000;
  Cache_UpdateCounters_Sec = 1;
  SQLAdapterTimeOut_Sec = 30;
  SQLAdapterConnectionAttempts = 10;
  SQLAdapterDelayBetweenAttempts_MilliSec = 100;

type
  TObjectPool = class
  private
    FAPICount: Integer;
    FAccountCount: Integer;
    FEmailCount: Integer;
    FFileManagerCount: Integer;
    FSQLAdapterCount: Integer;
    FUserCount: Integer;

    FLast_UpdateCounters: TDateTime;
    FCache_Last_UpdateCounters: TDateTime;

    FPrevSQLAdapter: TSQLAdapter;
    FPrevSQLAdapterSaveTime: TDateTime;
    FPrevSQLAdapterCriticalSection: TLocker;

  public
    // Cacheed strings

    GetFileInfoCache: TInfoCache;
    GetProcessFilesCache: TInfoCache;
    GetSystemFilesCache: TInfoCache;

    GetCategoriesCache: TInfoCache;
    GetSummaryCache: TInfoCache;
    GetSubCategoryStatsCache: TInfoCache;
    GetProcessesCache: TInfoCache;
    GetProcessInfoCache: TInfoCache;
    GetProcessInfoPersonalCache: TInfoCache;
    GetCurrenciesCache: TInfoCache;
    GetStatsCache: TInfoCache;
    GetCountriesCache: TInfoCache;
    GetStatesCache: TInfoCache;
    GetLeaderBoardCache: TInfoCache;
    GetConfigValues: TInfoCache;
    // Bots
    GetBotNames: TInfoCache;
    GetBotChatPostCache: TStringTableCache;

    //Oushing contetn cache
    GetPushingContentLobbyCache: TInfoCache;
    GetPushingContentTableCache: TInfoCache;

    // tournaments
    GetTournaments: TInfoCache;
    GetTournamentLeaderBoard: TInfoCache;
    GetTournamentInfo: TInfoCache;
    GetTournamentLevelsInfo: TInfoCache;
    GetTournamentPlayers: TInfoCache;
    GetTournamentProcesses: TInfoCache;
    GetTournamentInfoAdditional: TInfoCache;
    GetTournamentProcessPlayers: TInfoCache;


    function GetAPI: TAPI;
    function GetAccount: TAccount;
    function GetEmail: TEmail;
    function GetFileManager: TFileManager;
    function GetSQLAdapter: TSQLAdapter;
    function GetUser: TUser;

    procedure FreeAPI(API: TAPI);
    procedure FreeAccount(Account: TAccount);
    procedure FreeEmail(Email: TEmail);
    procedure FreeFileManager(FileManager: TFileManager);
    procedure FreeSQLAdapter(SQLAdapter: TSQLAdapter);
    procedure FreeUser(User: TUser);

    constructor Create(RefreshTime: Integer);
    destructor Destroy; override;
    procedure RingUp;

  end;

implementation

uses
  uCommonDataModule, uLogger;

{ TObjectPool }

// Create, Destroy and RingUp

constructor TObjectPool.Create(RefreshTime: Integer);
begin
  inherited Create;

  GetFileInfoCache := TInfoCache.Create(100000, 1);
  GetProcessFilesCache := TInfoCache.Create(100000, 10);
  GetSystemFilesCache := TInfoCache.Create(300, 1);

  GetCategoriesCache := TInfoCache.Create(100000, 1);
  GetSummaryCache := TInfoCache.Create(3 * RefreshTime, 1);
  GetSubCategoryStatsCache := TInfoCache.Create(100000, 1);
  GetProcessesCache := TInfoCache.Create(3 * RefreshTime, 1);
  GetProcessInfoCache := TInfoCache.Create(3 * RefreshTime, 100);
  GetProcessInfoPersonalCache := TInfoCache.Create(RefreshTime, 100);
  GetCurrenciesCache := TInfoCache.Create(100000, 1);
  GetStatsCache := TInfoCache.Create(100000, 1);
  GetCountriesCache := TInfoCache.Create(100000, 1);
  GetStatesCache := TInfoCache.Create(100000, 1);
  GetLeaderBoardCache := TInfoCache.Create(300, 1);
  GetConfigValues := TInfoCache.Create(300, 1);

  // bots
  GetBotNames := TInfoCache.Create(100000, 1);
  GetBotChatPostCache := TStringTableCache.Create(1800);

  //pushing content cache
  GetPushingContentLobbyCache:= TInfoCache.Create(2 * RefreshTime, 100);
  GetPushingContentTableCache:= TInfoCache.Create(2 * RefreshTime, 100);

  // tournaments
  GetTournaments := TInfoCache.Create(RefreshTime, 1);
  GetTournamentLeaderBoard := TInfoCache.Create(RefreshTime, 1);
  GetTournamentInfo := TInfoCache.Create(RefreshTime, 100);
  GetTournamentLevelsInfo := TInfoCache.Create(3 * RefreshTime, 100);
  GetTournamentPlayers := TInfoCache.Create(RefreshTime, 100);
  GetTournamentProcesses := TInfoCache.Create(RefreshTime, 100);
  GetTournamentInfoAdditional := TInfoCache.Create(RefreshTime, 100);
  GetTournamentProcessPlayers := TInfoCache.Create(RefreshTime, 100);


  FLast_UpdateCounters := Now - 1;
  FCache_Last_UpdateCounters := FLast_UpdateCounters;

  FPrevSQLAdapter := nil;
  FPrevSQLAdapterSaveTime := Now;

  FPrevSQLAdapterCriticalSection := CommonDataModule.ThreadLockHost.Add('sqladapter');

  CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
end;

destructor TObjectPool.Destroy;
begin
  FLast_UpdateCounters := Now - 1;
  RingUp;
  CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);

  GetFileInfoCache.Free;
  GetProcessFilesCache.Free;
  GetSystemFilesCache.Free;

  GetCategoriesCache.Free;
  GetSummaryCache.Free;
  GetSubCategoryStatsCache.Free;
  GetProcessesCache.Free;
  GetProcessInfoCache.Free;
  GetProcessInfoPersonalCache.Free;
  GetCurrenciesCache.Free;
  GetStatsCache.Free;
  GetCountriesCache.Free;
  GetStatesCache.Free;
  GetLeaderBoardCache.Free;
  GetConfigValues.Free;

  // bots
  GetBotNames.Free;
  GetBotChatPostCache.Free;

  //pushing content cache
  GetPushingContentLobbyCache.Free;
  GetPushingContentTableCache.Free;

  // tournaments
  GetTournaments.Free;
  GetTournamentLeaderBoard.Free;
  GetTournamentInfo.Free;
  GetTournamentLevelsInfo.Free;
  GetTournamentPlayers.Free;
  GetTournamentProcesses.Free;
  GetTournamentInfoAdditional.Free;
  GetTournamentProcessPlayers.Free;

  CommonDataModule.ThreadLockHost.Del(FPrevSQLAdapterCriticalSection);
  inherited;
end;

procedure TObjectPool.RingUp;
{
var
  sXML                    : String;
}  
begin

  try
    if (SecondsBetween(Now, FCache_Last_UpdateCounters) > Cache_UpdateCounters_Sec) then begin

      //update cache content
      GetBotChatPostCache.UpdateByTime();
//      GetPushingContentCache.UpdateByTime();

      //update all clients with new info
{
      if (GetPushingContentCache.Updated) then begin
        sXML:= '';

        //check if there were any changes in pushing content
        if (CommonDataModule.ObjectPool.GetPushingContentCache.CurrentPushingContentID <> -1) then
          if (CommonDataModule.ObjectPool.GetPushingContentCache.Items[CommonDataModule.ObjectPool.GetPushingContentCache.CurrentPushingContentID].State = CIS_UPDATED) then
            sXML:= CommonDataModule.ObjectPool.GetPushingContentCache.GenerateXML(CommonDataModule.ObjectPool.GetPushingContentCache.CurrentPushingContentID);

        //reset cache state
        GetPushingContentCache.ResetUpdated();

        //notify all clients with new content
        if (sXML <> '') then
          CommonDataModule.NotifyAllUsers('<object name="filemanager">'+sXML+'</object>');
      end;//if

 }
      FCache_Last_UpdateCounters:= Now;
    end;//if
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'RingUp', E.Message, ltException);
  end;//try-except


  try
    if (SecondsBetween(Now, FLast_UpdateCounters) > UpdateCounters_Sec) then begin
      CommonDataModule.Log(ClassName, 'RingUp',
        'API=' + inttostr(FAPICount) +
        ', Account=' + inttostr(FAccountCount) +
        ', Email=' + inttostr(FEmailCount) +
        ', FileManager=' + inttostr(FFileManagerCount) +
        ', SQLAdapter=' + inttostr(FSQLAdapterCount) +
        ', User=' + inttostr(FUserCount), ltBase);


      FLast_UpdateCounters:= Now;
    end;//if
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'RingUp', E.Message, ltException);
  end;
end;

// Account

function TObjectPool.GetAccount: TAccount;
begin
  InterlockedIncrement(FAccountCount);
  Result := TAccount.Create;
end;

procedure TObjectPool.FreeAccount(Account: TAccount);
begin
  try
    Account.Free;
    InterlockedDecrement(FAccountCount);
  except
  end;
end;

// API

function TObjectPool.GetAPI: TAPI;
begin
  InterlockedIncrement(FAPICount);
  Result := TAPI.Create;
end;

procedure TObjectPool.FreeAPI(API: TAPI);
begin
  try
    API.Free;
    InterlockedDecrement(FAPICount);
  except
  end;
end;

// EMail

function TObjectPool.GetEmail: TEmail;
begin
  InterlockedIncrement(FEmailCount);
  Result := TEmail.Create;
end;

procedure TObjectPool.FreeEmail(Email: TEmail);
begin
  try
    Email.Free;
    InterlockedDecrement(FEmailCount);
  except
  end;
end;

// FileManager

function TObjectPool.GetFileManager: TFileManager;
begin
  InterlockedIncrement(FFileManagerCount);
  Result := TFileManager.Create;
end;

procedure TObjectPool.FreeFileManager(FileManager: TFileManager);
begin
  try
    FileManager.Free;
    InterlockedDecrement(FFileManagerCount);
  except
  end;
end;

// SQLAdapter

function TObjectPool.GetSQLAdapter: TSQLAdapter;
var
  Loop: Integer;
  SleepTime: Integer;
begin
  if FSQLAdapterCount > 10 then
  begin
    SleepTime := FSQLAdapterCount;
    if SleepTime < 10 then
      SleepTime := 10;
    if SleepTime > 100 then
      SleepTime := 100;
    Sleep(SleepTime);
  end;

  FPrevSQLAdapterCriticalSection.Lock;
  try
    if FPrevSQLAdapter <> nil then
      if SecondsBetween(Now, FPrevSQLAdapterSaveTime) < SQLAdapterTimeOut_Sec then
      begin
        Result := FPrevSQLAdapter;
        FPrevSQLAdapter := nil;
        Exit;
      end
      else
      begin
        try
          FPrevSQLAdapter.Free;
        except
        end;
        FPrevSQLAdapter := nil;
      end;
  finally
    FPrevSQLAdapterCriticalSection.UnLock;
  end;

  Result := TSQLAdapter.Create;
  for Loop := 1 to SQLAdapterConnectionAttempts do
  begin
    Result.Connected := True;
    if Result.Connected then
      Break;
    Sleep(SQLAdapterDelayBetweenAttempts_MilliSec);
  end;

  if Result.Connected then
    InterlockedIncrement(FSQLAdapterCount)
  else
  begin
    FreeSQLAdapter(Result);
    raise Exception.Create('SQLAdapter was not connected');
  end;
end;

procedure TObjectPool.FreeSQLAdapter(SQLAdapter: TSQLAdapter);
begin
  if SQLAdapter.Connected then
  begin
    FPrevSQLAdapterCriticalSection.Lock;
    try
      if FPrevSQLAdapter = nil then
      begin
        SQLAdapter.Clear;
        FPrevSQLAdapter := SQLAdapter;
        FPrevSQLAdapterSaveTime := Now;
        Exit;
      end;
    finally
      FPrevSQLAdapterCriticalSection.UnLock;
    end;
  end;

  try
    SQLAdapter.Free;
    InterlockedDecrement(FSQLAdapterCount);
  except
  end;
end;

// User

function TObjectPool.GetUser: TUser;
begin
  InterlockedIncrement(FUserCount);
  Result := TUser.Create;
end;


procedure TObjectPool.FreeUser(User: TUser);
begin
  try
    User.Free;
    InterlockedDecrement(FUserCount);
  except
  end;
end;


end.
