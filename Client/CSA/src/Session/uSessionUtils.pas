unit uSessionUtils;

interface

uses
  Classes, SysUtils,
  ZLib, LbCipher, LbClass,
  IdCoder, IdCoder3to4, IdCoderMIME, IdBaseComponent;

type
  TSecurityKey128 = TKey128;

  TCompressedStream = class (TMemoryStream)
  public
    procedure Compress;
    procedure Decompress;
  end;

// Compressing
function Zip(const Data: String): String;
function Unzip(const Data: String): String;

// Base64 encoding
function DecodeBase64(const Data: String): String;
function EncodeBase64(const Data: String): String;

// Security initiations
function GenerateMagicWord: String;
function GenerateKey128(const PassPhrase: String): TSecurityKey128;

// Security functions
function ZipCrypt(const Data: string; AKey: TSecurityKey128): String;
function UnzipDecrypt(const Data: String; AKey: TSecurityKey128): String;

implementation

procedure TCompressedStream.Compress;
var
  InpBuf, OutBuf: Pointer;
  InpBytes, OutBytes: Integer;
begin
 InpBuf := nil;
 OutBuf := nil;
 try
   // Read whole stream into buffer
   self.position := 0;
   GetMem(InpBuf,self.size);
   InpBytes := self.Read(InpBuf^,self.size);
   // Compress buffer into second buffer
   compressBuf(InpBuf,InpBytes,OutBuf,OutBytes);
   // Clear stream and write second buffer to stream
   self.Clear;
   self.Write(OutBuf^,OutBytes);
 finally
   if InpBuf <> nil then
     FreeMem(InpBuf);
   if OutBuf <> nil then
     FreeMem(OutBuf);
 end;
end;

// DECOMPRESS
procedure TCompressedStream.Decompress;
var
  InpBuf, OutBuf: Pointer;
  OutBytes, sz: Integer;
begin
 InpBuf := nil;
 OutBuf := nil;
 sz := self.size-self.Position;
 if sz > 0 then
  try
    // Read part of stream into buffer (from 'position' to end)
    GetMem(InpBuf,sz);
    self.Read(InpBuf^,sz);
    // Decompress buffer into output buffer
    decompressBuf(InpBuf,sz,0,OutBuf,OutBytes);
    // Clear stream and copy output buffer to stream
    self.clear;
    self.Write(OutBuf^, OutBytes);
  finally
    if InpBuf <> nil then
      FreeMem(InpBuf);
    if OutBuf <> nil then
      FreeMem(OutBuf);
  end;
end;

function Zip(const Data: string): String;
var
  Size: Integer;
  mStream: TCompressedStream;
begin
  Result := '';
  if Data <> '' then
  try
    { creating compressor stream }
    mStream := TCompressedStream.Create;
    try
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
    finally
      { releasing compressor stream }
      mStream.Clear;
      mStream.Free;
    end;
  except
    Result := '';
  end;
end;

function Unzip(const Data: String): String;
var
  Size: Integer;
  mStream: TCompressedStream;
begin
  Result := '';
  if Data <> '' then
  try
    { creating compressor stream }
    mStream := TCompressedStream.Create;
    try
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
    finally
      { releasing compressor stream }
      mStream.Clear;
      mStream.Free;
    end;
  except
    Result := '';
  end;
end;


// Base64 encoding
function EncodeBase64(const Data: String): String;
Var
  IdEncoderMIME : TIdEncoderMIME;
begin
  try
    IdEncoderMIME := TIdEncoderMIME.Create(nil) ;
    try
      Result := IdEncoderMIME.EncodeString(Data);
    finally
      IdEncoderMIME.Free;
    end;
  except
    Result := '';
  end;
end;

function DecodeBase64(const Data: String): String;
Var
  IdDecoderMIME : TIdDecoderMIME;
begin
  try
    IdDecoderMIME := TIdDecoderMIME.Create(nil) ;
    try
      Result := IdDecoderMIME.DecodeString(Data);
    finally
      IdDecoderMIME.Free;
    end;
  except
    Result := '';
  end;
end;


// BlowFish encoding

function GenerateMagicWord: String;
var
  Loop: Integer;
begin
  Result := '';
  Randomize;
  for Loop := 0 to 31 do
    Result := Result + chr(Random(50) + 33);
end;

function GenerateKey128(const PassPhrase: String): TSecurityKey128;
begin
  GenerateLMDKey(Result, SizeOf(Result), PassPhrase);
end;


function ZipCrypt(const Data: string; AKey: TSecurityKey128): String;
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

function UnzipDecrypt(const Data: String; AKey: TSecurityKey128): String;
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

end.
