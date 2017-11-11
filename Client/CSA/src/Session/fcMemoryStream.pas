unit fcMemoryStream;

interface

uses Classes, ZLib;

type
 TfcMemoryStream = class (TMemoryStream)
 public
   procedure     compress;
   procedure     decompress;
 end;

implementation

// COMPRESS
procedure TfcMemoryStream.compress;
var
    InpBuf,OutBuf     : Pointer;
    InpBytes,OutBytes : integer;
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
   if InpBuf <> nil then FreeMem(InpBuf);
   if OutBuf <> nil then FreeMem(OutBuf);
 end;
end;

// DECOMPRESS
procedure TfcMemoryStream.decompress;
var
    InpBuf,OutBuf     : Pointer;
    OutBytes,sz          : integer;
begin
 InpBuf := nil;
 OutBuf := nil;
 sz := self.size-self.Position;
 if sz > 0 then begin
      try
        // Read part of stream into buffer (from 'position' to end)
        GetMem(InpBuf,sz);
        self.Read(InpBuf^,sz);
     // Decompress buffer into output buffer
        decompressBuf(InpBuf,sz,0,OutBuf,OutBytes);
     // Clear stream and copy output buffer to stream
     self.clear;
        self.Write(OutBuf^,OutBytes);
      finally
        if InpBuf <> nil then FreeMem(InpBuf);
        if OutBuf <> nil then FreeMem(OutBuf);
      end;
 end;
end;

end.
