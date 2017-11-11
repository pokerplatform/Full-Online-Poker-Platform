unit uInfoCash;

interface

uses
  Windows, Classes, SysUtils, SyncObjs, uLocker;

type
  TCachedString = record
    FID: Integer;
    FAlterID: Integer;
    FLastSetTime: TDateTime;
    FCachedString: String;
  end;

  TClonedCachedString = record
    CID: Integer;
    CAlterID: Integer;
    CCachedString: String;
  end;

  TInfoCache = class
    FObsoleteTime: Integer;
    FLastCheckObsoleteTime: TDateTime;

    FCriticalSection: TLocker;
    FCachedStringArray: array of TCachedString;
  public
    function GetCachedString(ID: Integer; var CachedString: String; AlterID: Integer = -1): Boolean;  // True if obsolete
    procedure SetCachedString(ID: Integer; CachedString: String; AlterID: Integer = -1);

    procedure CloneCache(NewCache: array of TClonedCachedString);

    constructor Create(ObsoleteTime, InitialCount: Integer);
    destructor Destroy; override;
  end;

implementation

uses
  DateUtils, uCommonDataModule, uLogger;

{ TInfoCache }

constructor TInfoCache.Create(ObsoleteTime, InitialCount: Integer);
var
  Loop: Integer;
begin
  inherited Create;

  FObsoleteTime := ObsoleteTime;
  FLastCheckObsoleteTime := Now;

  FCriticalSection := CommonDataModule.ThreadLockHost.Add('infocash');
  SetLength(FCachedStringArray, InitialCount);
  for Loop := 0 to InitialCount - 1 do
    with FCachedStringArray[Loop] do
    begin
      FID := -1;
      FAlterID := -1;
      FCachedString := '';
      FLastSetTime := Now;
    end;
end;

destructor TInfoCache.Destroy;
begin
  FCachedStringArray := nil;

   CommonDataModule.ThreadLockHost.Del(FCriticalSection);
  inherited;
end;

function TInfoCache.GetCachedString(ID: Integer; var CachedString: String; AlterID: Integer): Boolean;
var
  Loop: Integer;
begin
  CachedString := '';
  Result := True; // Cached string is obsolete - by default
  FCriticalSection.Lock;
  try
    for Loop := 0 to Length(FCachedStringArray) - 1 do
      with FCachedStringArray[Loop] do
        if (FID = ID) and (FAlterID = AlterID) then
        begin
          Result := SecondsBetween(Now, FLastSetTime) > FObsoleteTime;
          if Result then
          begin
            FID := -1;
            FAlterID := -1;
            FCachedString := '';
          end
          else
            CachedString := FCachedString;
          Break;
        end;
  finally
    FCriticalSection.UnLock;
  end;
end;

procedure TInfoCache.SetCachedString(ID: Integer; CachedString: String; AlterID: Integer);
var
  Index: Integer;
  EmptyIndex: Integer;
  Loop: Integer;
begin
  if (ID < 0) or (CachedString = '') then
    Exit;

  // Enter the critical section
  FCriticalSection.Lock;
  try
    if SecondsBetween(Now, FLastCheckObsoleteTime) > (FObsoleteTime * 100) then
    begin
      for Loop := 0 to Length(FCachedStringArray) - 1 do
      with FCachedStringArray[Loop] do
        if SecondsBetween(Now, FLastSetTime) > FObsoleteTime then
        begin
          FID := -1;
          FAlterID := -1;
          FCachedString := '';
        end;
      FLastCheckObsoleteTime := Now;
    end;

    Index := -1;
    EmptyIndex := -1;

    // Find record index with such ID1 and ID2
    for Loop := 0 to Length(FCachedStringArray) - 1 do
      with FCachedStringArray[Loop] do
      begin
        if (FID = ID) and (FAlterID = AlterID) then
        begin
          Index := Loop;
          Break;
        end
        else
          if (FID = -1) and (EmptyIndex = -1) then
            EmptyIndex := Loop;
      end;

    // Find or create empty record
    if Index = -1 then
    begin
      if EmptyIndex >= 0 then
        Index := EmptyIndex
      else
      begin
        Index := Length(FCachedStringArray);
        SetLength(FCachedStringArray, Length(FCachedStringArray) + 1);
      end;
    end;

    // Fill the record properties
    with FCachedStringArray[Index] do
    begin
      FID := ID;
      FAlterID := AlterID;
      FCachedString := CachedString;
      FLastSetTime := Now;
    end;
  finally
    // Leave the critical section
    FCriticalSection.UnLock;
  end;
end;

procedure TInfoCache.CloneCache(NewCache: array of TClonedCachedString);
var
  Loop: Integer;
begin
  FCriticalSection.Lock;
  try
    SetLength(FCachedStringArray, Length(NewCache));
    for Loop := 0 to Length(NewCache) - 1 do
      with FCachedStringArray[Loop] do
      with NewCache[Loop] do
      begin
        FID := CID;
        FAlterID := CAlterID;
        FCachedString := CCachedString;
        FLastSetTime := Now;
      end;
  finally
    FCriticalSection.UnLock;
  end;
end;

end.
