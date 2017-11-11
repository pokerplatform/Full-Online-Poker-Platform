unit uMacTool;

interface

function GetMACAddress: string;
procedure GetLocalHostAndIP(var Host, IP: String);


implementation

uses
  NB30,
  WinSock,
  SysUtils,
  Windows;

type
  TAdaptor = record
    Adapter     : TAdapterStatus;
    NameBuffer  : array [0..29] of TNameBuffer;
  end;//record

function GetAdapterInfo(Lana: Char): string;
var
  Adapter: TAdaptor;
  NCB: TNCB;
begin
  Result := '';
  try
    FillChar(NCB, SizeOf(NCB), 0);
    NCB.ncb_command := Char(NCBRESET);
    NCB.ncb_lana_num := Lana;
    if Netbios(@NCB) = Char(NRC_GOODRET) then
    begin
      FillChar(NCB, SizeOf(NCB), 0);
      NCB.ncb_command := Char(NCBASTAT);
      NCB.ncb_lana_num := Lana;
      NCB.ncb_callname := '*               ';

      FillChar(Adapter, SizeOf(Adapter), 0);
      NCB.ncb_buffer := @Adapter;
      NCB.ncb_length := SizeOf(Adapter);
      if Netbios(@NCB) = Char(NRC_GOODRET) then
      Result :=
        IntToHex(Byte(Adapter.Adapter.adapter_address[0]), 2) + //'-' +
        IntToHex(Byte(Adapter.Adapter.adapter_address[1]), 2) + //'-' +
        IntToHex(Byte(Adapter.Adapter.adapter_address[2]), 2) + //'-' +
        IntToHex(Byte(Adapter.Adapter.adapter_address[3]), 2) + //'-' +
        IntToHex(Byte(Adapter.Adapter.adapter_address[4]), 2) + //'-' +
        IntToHex(Byte(Adapter.Adapter.adapter_address[5]), 2);
    end;
  except
  end;
  if Result = '' then
    Result := '000000000000';
end;

function GetMACAddress: string;
var
  AdapterList: TLanaEnum;
  NCB: TNCB;
  nIndx: Integer;
begin
  Result:= '';
  try
    FillChar(NCB, SizeOf(NCB), 0);
    NCB.ncb_command := Char(NCBENUM);
    NCB.ncb_buffer := @AdapterList;
    NCB.ncb_length := SizeOf(AdapterList);
    Netbios(@NCB);

    for nIndx:= 0 to (Byte(AdapterList.length) - 1) do begin
      if (Length(Result) < 50) then begin
        if (Result <> '') then Result:= Result + '|';
        Result:= Result + GetAdapterInfo(AdapterList.lana[nIndx]);
      end;//if
    end;//for
  except
  end;  
  if Result = '' then
    Result := '000000000000';
end;


procedure GetLocalHostAndIP(var Host, IP: String);
const
  WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Host := '';
  IP := '';
  if WSAStartup(WSVer, wsaData) = 0 then
  begin
    if GetHostName(@Buf, 128) = 0 then
    begin
      Host := StrPas(@Buf);
      P := GetHostByName(@Buf);
      if P <> nil then
        IP := iNet_ntoa(PInAddr(p^.h_addr^)^);
    end;
    WSACleanup;
  end;
end;




end.
