unit NetCompress_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 8/18/2005 1:24:24 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\OffshoreCreations\NetCompressDeploy\NetCompress.tlb (1)
// LIBID: {EC250966-AF1A-42B1-B43B-9F0BA58B10B3}
// LCID: 0
// Helpfile: 
// HelpString: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v1.10 mscorlib, (C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322\mscorlib.tlb)
// Errors:
//   Error creating palette bitmap of (TZip) : Server C:\WINDOWS\System32\mscoree.DLL contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  NetCompressMajorVersion = 1;
  NetCompressMinorVersion = 0;

  LIBID_NetCompress: TGUID = '{EC250966-AF1A-42B1-B43B-9F0BA58B10B3}';

  IID__Zip: TGUID = '{8FF1FB27-49CE-4EA6-B61E-C55B25BC7DEB}';
  CLASS_Zip: TGUID = '{E0018697-8E45-436E-960C-F450F69269E2}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _Zip = interface;
  _ZipDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Zip = _Zip;


// *********************************************************************//
// Interface: _Zip
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8FF1FB27-49CE-4EA6-B61E-C55B25BC7DEB}
// *********************************************************************//
  _Zip = interface(IDispatch)
    ['{8FF1FB27-49CE-4EA6-B61E-C55B25BC7DEB}']
    function Get__Error: WideString; safecall;
    procedure Set__Error(const pRetVal: WideString); safecall;
    function Extract(const buf: WideString): WideString; safecall;
    function Compress(const buf: WideString): WideString; safecall;
    property _Error: WideString read Get__Error write Set__Error;
  end;

// *********************************************************************//
// DispIntf:  _ZipDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8FF1FB27-49CE-4EA6-B61E-C55B25BC7DEB}
// *********************************************************************//
  _ZipDisp = dispinterface
    ['{8FF1FB27-49CE-4EA6-B61E-C55B25BC7DEB}']
    property _Error: WideString dispid 1;
    function Extract(const buf: WideString): WideString; dispid 2;
    function Compress(const buf: WideString): WideString; dispid 3;
  end;

// *********************************************************************//
// The Class CoZip provides a Create and CreateRemote method to          
// create instances of the default interface _Zip exposed by              
// the CoClass Zip. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoZip = class
    class function Create: _Zip;
    class function CreateRemote(const MachineName: string): _Zip;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TZip
// Help String      : 
// Default Interface: _Zip
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TZipProperties= class;
{$ENDIF}
  TZip = class(TOleServer)
  private
    FIntf:        _Zip;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TZipProperties;
    function      GetServerProperties: TZipProperties;
{$ENDIF}
    function      GetDefaultInterface: _Zip;
  protected
    procedure InitServerData; override;
    function Get__Error: WideString;
    procedure Set__Error(const pRetVal: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _Zip);
    procedure Disconnect; override;
    function Extract(const buf: WideString): WideString;
    function Compress(const buf: WideString): WideString;
    property DefaultInterface: _Zip read GetDefaultInterface;
    property _Error: WideString read Get__Error write Set__Error;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TZipProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TZip
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TZipProperties = class(TPersistent)
  private
    FServer:    TZip;
    function    GetDefaultInterface: _Zip;
    constructor Create(AServer: TZip);
  protected
    function Get__Error: WideString;
    procedure Set__Error(const pRetVal: WideString);
  public
    property DefaultInterface: _Zip read GetDefaultInterface;
  published
    property _Error: WideString read Get__Error write Set__Error;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoZip.Create: _Zip;
begin
  Result := CreateComObject(CLASS_Zip) as _Zip;
end;

class function CoZip.CreateRemote(const MachineName: string): _Zip;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Zip) as _Zip;
end;

procedure TZip.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{E0018697-8E45-436E-960C-F450F69269E2}';
    IntfIID:   '{8FF1FB27-49CE-4EA6-B61E-C55B25BC7DEB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TZip.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _Zip;
  end;
end;

procedure TZip.ConnectTo(svrIntf: _Zip);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TZip.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TZip.GetDefaultInterface: _Zip;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TZip.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TZipProperties.Create(Self);
{$ENDIF}
end;

destructor TZip.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TZip.GetServerProperties: TZipProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TZip.Get__Error: WideString;
begin
    Result := DefaultInterface._Error;
end;

procedure TZip.Set__Error(const pRetVal: WideString);
  { Warning: The property _Error has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant._Error := pRetVal;
end;

function TZip.Extract(const buf: WideString): WideString;
begin
  Result := DefaultInterface.Extract(buf);
end;

function TZip.Compress(const buf: WideString): WideString;
begin
  Result := DefaultInterface.Compress(buf);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TZipProperties.Create(AServer: TZip);
begin
  inherited Create;
  FServer := AServer;
end;

function TZipProperties.GetDefaultInterface: _Zip;
begin
  Result := FServer.DefaultInterface;
end;

function TZipProperties.Get__Error: WideString;
begin
    Result := DefaultInterface._Error;
end;

procedure TZipProperties.Set__Error(const pRetVal: WideString);
  { Warning: The property _Error has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant._Error := pRetVal;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TZip]);
end;

end.
