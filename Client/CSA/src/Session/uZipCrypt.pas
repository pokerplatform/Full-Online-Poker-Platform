unit uZipCrypt;

interface

uses LbCipher, LbClass, fcMemoryStream, Classes, SysUtils;

type
  TSecurityKey128 = TKey128;

// Security initiations
function GenerateMagicWord(): String;
function GenerateKey128(PassPhrase: String): TSecurityKey128;

// Security functions
function ZipCrypt(Data: string; AKey: TSecurityKey128): String;
function UnzipDecrypt(Data: String; AKey: TSecurityKey128): String;

// Compressing functions
function Zip(Data: string): String;
function Unzip(Data: String): String;

implementation

function GenerateMagicWord(): String;
var
  Loop    : Integer;
begin
  Result := '';
  Randomize;
  for Loop := 0 to 31 do
    Result := Result + chr(Random(50) + 33);
end;

function GenerateKey128(PassPhrase: String): TSecurityKey128;
begin
  GenerateLMDKey(Result, SizeOf(Result), PassPhrase);
end;


function ZipCrypt(Data: string; AKey: TSecurityKey128): String;
var
  BF: TLbBlowfish;
begin
  Result := Zip(Data);

  if Data <> '' then
  try
    { creating blowfish object }
    BF := TLbBlowfish.Create(nil);
    { setting cypher mode }
    BF.CipherMode := cmCBC;
    { setting key }
    BF.SetKey(AKey);
    { crypting zipped data }
    Result := BF.EncryptString(Result);
    { releasing object }
    BF.Free;
  except
    Result := '';
  end;
end;

function UnzipDecrypt(Data: String; AKey: TSecurityKey128): String;
var
  BF: TLbBlowfish;
begin
  Result := '';
  if Data <> '' then
  try
    { creating blowfish object }
    BF := TLbBlowfish.Create(nil);
    { setting cypher mode }
    BF.CipherMode := cmCBC;
    { setting key }
    BF.SetKey(AKey);
    { decrypting zipped data }
    Result := BF.DecryptString(Data);
    { releasing object }
    BF.Free;
  except
    Result := '';
  end;

  Result := Unzip(Result);
end;


function Zip(Data: string): String;
var
  Size: Integer;
  mStream: TfcMemoryStream;
begin
  Result := '';
  if Data <> '' then
  try
    { creating compressor stream }
    mStream := TfcMemoryStream.Create;
    { saving data to stream }
    mStream.Write(Data[1],Length(Data));
    mStream.Position := 0;
    { compressing data }
    mStream.compress;
    { getting compressed data size }
    mStream.Position := 0;
    Size := mStream.Size;
    SetLength(Result, Size);
    { getting compressed data }
    mStream.ReadBuffer(Result[1], Size);
    { releasing compressor stream }
    mStream.Free;
  except
    Result := '';
  end;
end;

function Unzip(Data: String): String;
var
  Size: Integer;
  mStream: TfcMemoryStream;
begin
  Result := '';
  if Data <> '' then
  try
    { creating compressor stream }
    mStream := TfcMemoryStream.Create;
    { saving zipped data to stream }
    mStream.Write(Data[1],Length(Data));
    mStream.Position := 0;
    { decompressing data }
    mStream.decompress;
    { getting decompressed data size }
    mStream.Position := 0;
    Size := mStream.Size;
    SetLength(Result, Size);
    { getting decompressed data }
    mStream.ReadBuffer(Result[1], Size);
    {releasing stream}
    mStream.Free;
  except
    Result := '';
  end;
end;

end.
