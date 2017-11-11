unit uLocker;

interface

uses SyncObjs, SysUtils, Contnrs;

type
  TThreadLockHost = class;

  TLocker = class
  private
    FCriticalSection: TCriticalSection;
    FLastActivity: TDateTime;
    FOwner: TThreadLockHost;
    FIsLocked: Boolean;
    FName: string;
  public
    property IsLocked: Boolean read FIsLocked;
    property Name: string read FName;
    //
    procedure Lock;
    procedure UnLock;
    //
    constructor Create(aOwner: TThreadLockHost; sName: string = '');
    destructor Destroy; override;
  end;

  TThreadLockHost = class(TObjectList)
  private
    FAutoUnlockTimeOut: Integer;
    function GetItem(nIndex: Integer): TLocker;
  public
    property Item[nIndex: Integer]: TLocker  read GetItem;
    //
    function Add(sName: string): TLocker;
    procedure Del(aItem: TLocker);
    procedure RingUp;
    //
    constructor Create(nAutoUnlockTimeOut: Integer = 10);
    destructor Destroy; override;
  end;

implementation

uses
  Classes, DateUtils
  //po
  , uLogger
  , uCommonDataModule;

{ TLocker }

constructor TLocker.Create(aOwner: TThreadLockHost; sName: string = '');
begin
  inherited Create;

  FOwner := aOwner;
  FLastActivity := Now;
  FIsLocked := False;
  FName := sName;

  FCriticalSection := TCriticalSection.Create;
end;

destructor TLocker.Destroy;
begin
  if FIsLocked then FCriticalSection.Leave;
  FCriticalSection.Free;
  inherited;
end;

procedure TLocker.Lock;
begin
  FLastActivity := Now;
  FCriticalSection.Enter;
  FIsLocked := True;
end;

procedure TLocker.UnLock;
begin
  FIsLocked := False;
  FCriticalSection.Leave;
end;

{ TThreadLockHost }

function TThreadLockHost.Add(sName: string): TLocker;
begin
  Result := TLocker.Create(Self);
  Result.FName := sName;
  inherited Add(Result as TObject);
end;

constructor TThreadLockHost.Create(nAutoUnlockTimeOut: Integer);
begin
  inherited Create;

  FAutoUnlockTimeOut := nAutoUnlockTimeOut;
end;

procedure TThreadLockHost.Del(aItem: TLocker);
begin
  inherited Remove(aItem as TObject);
end;

destructor TThreadLockHost.Destroy;
begin
  Clear;
  inherited;
end;

function TThreadLockHost.GetItem(nIndex: Integer): TLocker;
begin
  Result := TLocker(inherited Items[nIndex]);
end;

procedure TThreadLockHost.RingUp;
var
  Loop: Integer;
  aItem: TLocker;
  aNow: TDateTime;
begin
  aNow := Now;
  for Loop := 0 to Count - 1 do begin
    aItem := Item[Loop];
    if not aItem.IsLocked then Continue;
    if (SecondsBetween(aItem.FLastActivity, aNow) < FAutoUnlockTimeOut) then
      Continue;

    CommonDataModule.Log(ClassName, 'RingUp',
      '[ERROR]: Item named [' + aItem.FName + '] was unlocked automatically.',
      ltError);

    aItem.UnLock;
  end;
end;


end.
