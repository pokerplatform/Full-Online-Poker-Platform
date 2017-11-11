unit uFirePay;

interface

uses
  Classes, IdHTTP, IdSSLOpenSSL, SysUtils;

function Encode(s : widestring) : string;
function Decode(s : string) : string;
function MakeRequestFirePay(s : string; var RespMsg : string; var AuthCode : string) : integer;
function ParseResp(Res: string; var Error : string; var AuthCode : string) : integer;

implementation

uses
  uXMLConstants, uErrorConstants, uCommonDataModule, uLogger;
const
    FIREPAYURL  = 'https://realtime.test.firepay.com/servlet/DPServlet';
//    FIREPAYURL  = 'https://realtime.firepay.com/servlet/DPServlet';

function Encode(s : widestring) : string;
begin
    Result := s;
end;

function MakeRequestFirePay(s : string; var RespMsg : string; var AuthCode : string) : integer;
var
  ss   : TStringStream;
  HTTP : TIdHTTP;
  SSL  : TIdSSLIOHandlerSocket;
  Res  : string;
begin
  CommonDataModule.Log('TAccount', 'MakeRequestFirePay',
    'Entry. Params: s=[' + s + ']', ltCall);

{$IFDEF __NOREALMONEY__}
  Result := 0;
  EXIT;
{$ENDIF}

  ss   := nil;
  SSL  := nil;
  HTTP := nil;
  try
    ss   := TStringStream.Create(s);
    HTTP := TIdHTTP.Create(nil);
    HTTP.HTTPOptions := HTTP.HTTPOptions + [hoForceEncodeParams];
    SSL  := TIdSSLIOHandlerSocket.Create(nil);
    HTTP.IOHandler := SSL;
    Res  := HTTP.Post(FIREPAYURL,ss);

    CommonDataModule.Log('TAccount', 'MakeRequestFirePay', 'Response from FirePay=[' + Res + ']', ltCall);

    SSL.Free;
    HTTP.Free;
    ss.Free;
    Result  := ParseResp(Res,RespMsg,AuthCode);
  except on e : Exception do
    begin
      CommonDataModule.Log('TAccount', 'MakeRequestFirePay', '[EXCEPTION]: ' + e.Message, ltException);
      Result := 1;
      SSL.Free;
      HTTP.Free;
      ss.Free;
    end;
  end;

end;

function ParseResp(Res: string; var Error : string; var AuthCode : string) : integer;
var
    sl      : TStringList;
    s,ss    : string;
    i       : integer;
begin
    sl := TStringList.Create;
    s  := Res;
    while Length(s) > 0 do begin
        i := Pos('&',s);
        if i = 0 then begin
            ss := s;
            s  := '';
        end else begin
            ss := Copy(s,1,i-1);
            s  := Copy(s,i+1,Length(s)-i);
        end;
        sl.Add(ss);
    end;

    AuthCode := '';
    s := Trim(sl.Values['status']);
    if Length(s) = 0 then begin
        Result := AC_ERR_WRONGRESPONSEFROMFIREPAY;
        Error  := 'Wrong response string from FirePay';
        sl.Free;
        Exit;
    end;
    if s = 'E' then begin
        Result := AC_ERR_FIREPAYTRANSACTIONFAILED;
        Error  := Decode(Trim(sl.Values['errString']));
    end else if s = 'SP' then begin
        Result := 0;
        AuthCode := Decode(Trim(sl.Values['authCode']));
        Error  := '';
    end else begin
        Result := AC_ERR_WRONGRESPONSEFROMFIREPAY;
        Error  := 'Wrong response string from FirePay';
    end;
    sl.Free;

end;

function Decode(s : string) : string;
var
    ss : string;
    ch : char;
    i  : integer;
begin
    ss := ''; i := 1;
    while true do begin
        if i > Length(s) then break;
        ch := s[i];
        case ch of
            '+' : ch := ' ';
            '%' : begin
                    ch := Chr(StrToInt('$'+s[i+1]+s[i+2]));
                    i := i + 2;
                  end;
        end;
        ss := ss + ch;
        i := i + 1;
    end;
    Result := ss;
end;

end.
