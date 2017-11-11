unit PFProCOMLib_TLB;

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
// File generated on 8/19/2004 5:41:33 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINNT\system32\PFProCOM.dll (1)
// LIBID: {17B9BE47-09EA-11D5-897B-0010B5759DED}
// LCID: 0
// Helpfile: 
// HelpString: PFProCOM 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TPNCom) : Server C:\WINNT\system32\PFProCOM.dll contains no icons
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

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  PFProCOMLibMajorVersion = 1;
  PFProCOMLibMinorVersion = 0;

  LIBID_PFProCOMLib: TGUID = '{17B9BE47-09EA-11D5-897B-0010B5759DED}';

  IID_IPFProCOM: TGUID = '{17B9BE54-09EA-11D5-897B-0010B5759DED}';
  CLASS_PNCom: TGUID = '{17B9BE57-09EA-11D5-897B-0010B5759DED}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPFProCOM = interface;
  IPFProCOMDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PNCom = IPFProCOM;


// *********************************************************************//
// Interface: IPFProCOM
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {17B9BE54-09EA-11D5-897B-0010B5759DED}
// *********************************************************************//
  IPFProCOM = interface(IDispatch)
    ['{17B9BE54-09EA-11D5-897B-0010B5759DED}']
    function Get_VendorID: WideString; safecall;
    procedure Set_VendorID(const pVal: WideString); safecall;
    function Get_VendorPassword: WideString; safecall;
    procedure Set_VendorPassword(const pVal: WideString); safecall;
    function Get_HostAddress: WideString; safecall;
    procedure Set_HostAddress(const pVal: WideString); safecall;
    function Get_HostPort: WideString; safecall;
    procedure Set_HostPort(const pVal: WideString); safecall;
    procedure ProcessTransaction; safecall;
    function Get_DebugMode: WideString; safecall;
    procedure Set_DebugMode(const pVal: WideString); safecall;
    function Get_TimeOut: WideString; safecall;
    procedure Set_TimeOut(const pVal: WideString); safecall;
    function Get_ProxyAddress: WideString; safecall;
    procedure Set_ProxyAddress(const pVal: WideString); safecall;
    function Get_ProxyPort: WideString; safecall;
    procedure Set_ProxyPort(const pVal: WideString); safecall;
    function Get_ProxyLogon: WideString; safecall;
    procedure Set_ProxyLogon(const pVal: WideString); safecall;
    function Get_ProxyPassword: WideString; safecall;
    procedure Set_ProxyPassword(const pVal: WideString); safecall;
    function Get_Response: WideString; safecall;
    procedure Set_Response(const pVal: WideString); safecall;
    function Get_ParmList: WideString; safecall;
    procedure Set_ParmList(const pVal: WideString); safecall;
    procedure AddBinParm(const name: WideString; value: OleVariant); safecall;
    procedure AddParm(const name: WideString; const value: WideString); safecall;
    function Get_DelayedCapture: Integer; safecall;
    procedure Set_DelayedCapture(pVal: Integer); safecall;
    procedure PNInit; safecall;
    procedure PNCleanup; safecall;
    function CreateContext(const HostAdd: WideString; HostPort: Integer; TimeOut: Integer; 
                           const ProxyAdd: WideString; ProxyPort: Integer; 
                           const ProxyLog: WideString; const ProxyPass: WideString): Integer; safecall;
    function SubmitTransaction(ptrCtx: Integer; const ParmList: WideString; ParmLen: Integer): WideString; safecall;
    procedure DestroyContext(ptrCtx: Integer); safecall;
    function Get_PartnerID: WideString; safecall;
    procedure Set_PartnerID(const pVal: WideString); safecall;
    function Get_UserID: WideString; safecall;
    procedure Set_UserID(const pVal: WideString); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const pVal: WideString); safecall;
    function CreateContext2: Integer; safecall;
    function SubmitTransaction2(ptrCtx: Integer): WideString; safecall;
    property VendorID: WideString read Get_VendorID write Set_VendorID;
    property VendorPassword: WideString read Get_VendorPassword write Set_VendorPassword;
    property HostAddress: WideString read Get_HostAddress write Set_HostAddress;
    property HostPort: WideString read Get_HostPort write Set_HostPort;
    property DebugMode: WideString read Get_DebugMode write Set_DebugMode;
    property TimeOut: WideString read Get_TimeOut write Set_TimeOut;
    property ProxyAddress: WideString read Get_ProxyAddress write Set_ProxyAddress;
    property ProxyPort: WideString read Get_ProxyPort write Set_ProxyPort;
    property ProxyLogon: WideString read Get_ProxyLogon write Set_ProxyLogon;
    property ProxyPassword: WideString read Get_ProxyPassword write Set_ProxyPassword;
    property Response: WideString read Get_Response write Set_Response;
    property ParmList: WideString read Get_ParmList write Set_ParmList;
    property DelayedCapture: Integer read Get_DelayedCapture write Set_DelayedCapture;
    property PartnerID: WideString read Get_PartnerID write Set_PartnerID;
    property UserID: WideString read Get_UserID write Set_UserID;
    property Password: WideString read Get_Password write Set_Password;
  end;

// *********************************************************************//
// DispIntf:  IPFProCOMDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {17B9BE54-09EA-11D5-897B-0010B5759DED}
// *********************************************************************//
  IPFProCOMDisp = dispinterface
    ['{17B9BE54-09EA-11D5-897B-0010B5759DED}']
    property VendorID: WideString dispid 1;
    property VendorPassword: WideString dispid 2;
    property HostAddress: WideString dispid 3;
    property HostPort: WideString dispid 4;
    procedure ProcessTransaction; dispid 5;
    property DebugMode: WideString dispid 6;
    property TimeOut: WideString dispid 7;
    property ProxyAddress: WideString dispid 8;
    property ProxyPort: WideString dispid 9;
    property ProxyLogon: WideString dispid 10;
    property ProxyPassword: WideString dispid 11;
    property Response: WideString dispid 12;
    property ParmList: WideString dispid 13;
    procedure AddBinParm(const name: WideString; value: OleVariant); dispid 14;
    procedure AddParm(const name: WideString; const value: WideString); dispid 15;
    property DelayedCapture: Integer dispid 16;
    procedure PNInit; dispid 17;
    procedure PNCleanup; dispid 18;
    function CreateContext(const HostAdd: WideString; HostPort: Integer; TimeOut: Integer; 
                           const ProxyAdd: WideString; ProxyPort: Integer; 
                           const ProxyLog: WideString; const ProxyPass: WideString): Integer; dispid 19;
    function SubmitTransaction(ptrCtx: Integer; const ParmList: WideString; ParmLen: Integer): WideString; dispid 20;
    procedure DestroyContext(ptrCtx: Integer); dispid 21;
    property PartnerID: WideString dispid 22;
    property UserID: WideString dispid 23;
    property Password: WideString dispid 24;
    function CreateContext2: Integer; dispid 25;
    function SubmitTransaction2(ptrCtx: Integer): WideString; dispid 26;
  end;

// *********************************************************************//
// The Class CoPNCom provides a Create and CreateRemote method to          
// create instances of the default interface IPFProCOM exposed by              
// the CoClass PNCom. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPNCom = class
    class function Create: IPFProCOM;
    class function CreateRemote(const MachineName: string): IPFProCOM;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TPNCom
// Help String      : PNCom Class
// Default Interface: IPFProCOM
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TPNComProperties= class;
{$ENDIF}
  TPNCom = class(TOleServer)
  private
    FIntf:        IPFProCOM;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TPNComProperties;
    function      GetServerProperties: TPNComProperties;
{$ENDIF}
    function      GetDefaultInterface: IPFProCOM;
  protected
    procedure InitServerData; override;
    function Get_VendorID: WideString;
    procedure Set_VendorID(const pVal: WideString);
    function Get_VendorPassword: WideString;
    procedure Set_VendorPassword(const pVal: WideString);
    function Get_HostAddress: WideString;
    procedure Set_HostAddress(const pVal: WideString);
    function Get_HostPort: WideString;
    procedure Set_HostPort(const pVal: WideString);
    function Get_DebugMode: WideString;
    procedure Set_DebugMode(const pVal: WideString);
    function Get_TimeOut: WideString;
    procedure Set_TimeOut(const pVal: WideString);
    function Get_ProxyAddress: WideString;
    procedure Set_ProxyAddress(const pVal: WideString);
    function Get_ProxyPort: WideString;
    procedure Set_ProxyPort(const pVal: WideString);
    function Get_ProxyLogon: WideString;
    procedure Set_ProxyLogon(const pVal: WideString);
    function Get_ProxyPassword: WideString;
    procedure Set_ProxyPassword(const pVal: WideString);
    function Get_Response: WideString;
    procedure Set_Response(const pVal: WideString);
    function Get_ParmList: WideString;
    procedure Set_ParmList(const pVal: WideString);
    function Get_DelayedCapture: Integer;
    procedure Set_DelayedCapture(pVal: Integer);
    function Get_PartnerID: WideString;
    procedure Set_PartnerID(const pVal: WideString);
    function Get_UserID: WideString;
    procedure Set_UserID(const pVal: WideString);
    function Get_Password: WideString;
    procedure Set_Password(const pVal: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPFProCOM);
    procedure Disconnect; override;
    procedure ProcessTransaction;
    procedure AddBinParm(const name: WideString; value: OleVariant);
    procedure AddParm(const name: WideString; const value: WideString);
    procedure PNInit;
    procedure PNCleanup;
    function CreateContext(const HostAdd: WideString; HostPort: Integer; TimeOut: Integer; 
                           const ProxyAdd: WideString; ProxyPort: Integer; 
                           const ProxyLog: WideString; const ProxyPass: WideString): Integer;
    function SubmitTransaction(ptrCtx: Integer; const ParmList: WideString; ParmLen: Integer): WideString;
    procedure DestroyContext(ptrCtx: Integer);
    function CreateContext2: Integer;
    function SubmitTransaction2(ptrCtx: Integer): WideString;
    property DefaultInterface: IPFProCOM read GetDefaultInterface;
    property VendorID: WideString read Get_VendorID write Set_VendorID;
    property VendorPassword: WideString read Get_VendorPassword write Set_VendorPassword;
    property HostAddress: WideString read Get_HostAddress write Set_HostAddress;
    property HostPort: WideString read Get_HostPort write Set_HostPort;
    property DebugMode: WideString read Get_DebugMode write Set_DebugMode;
    property TimeOut: WideString read Get_TimeOut write Set_TimeOut;
    property ProxyAddress: WideString read Get_ProxyAddress write Set_ProxyAddress;
    property ProxyPort: WideString read Get_ProxyPort write Set_ProxyPort;
    property ProxyLogon: WideString read Get_ProxyLogon write Set_ProxyLogon;
    property ProxyPassword: WideString read Get_ProxyPassword write Set_ProxyPassword;
    property Response: WideString read Get_Response write Set_Response;
    property ParmList: WideString read Get_ParmList write Set_ParmList;
    property DelayedCapture: Integer read Get_DelayedCapture write Set_DelayedCapture;
    property PartnerID: WideString read Get_PartnerID write Set_PartnerID;
    property UserID: WideString read Get_UserID write Set_UserID;
    property Password: WideString read Get_Password write Set_Password;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TPNComProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TPNCom
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TPNComProperties = class(TPersistent)
  private
    FServer:    TPNCom;
    function    GetDefaultInterface: IPFProCOM;
    constructor Create(AServer: TPNCom);
  protected
    function Get_VendorID: WideString;
    procedure Set_VendorID(const pVal: WideString);
    function Get_VendorPassword: WideString;
    procedure Set_VendorPassword(const pVal: WideString);
    function Get_HostAddress: WideString;
    procedure Set_HostAddress(const pVal: WideString);
    function Get_HostPort: WideString;
    procedure Set_HostPort(const pVal: WideString);
    function Get_DebugMode: WideString;
    procedure Set_DebugMode(const pVal: WideString);
    function Get_TimeOut: WideString;
    procedure Set_TimeOut(const pVal: WideString);
    function Get_ProxyAddress: WideString;
    procedure Set_ProxyAddress(const pVal: WideString);
    function Get_ProxyPort: WideString;
    procedure Set_ProxyPort(const pVal: WideString);
    function Get_ProxyLogon: WideString;
    procedure Set_ProxyLogon(const pVal: WideString);
    function Get_ProxyPassword: WideString;
    procedure Set_ProxyPassword(const pVal: WideString);
    function Get_Response: WideString;
    procedure Set_Response(const pVal: WideString);
    function Get_ParmList: WideString;
    procedure Set_ParmList(const pVal: WideString);
    function Get_DelayedCapture: Integer;
    procedure Set_DelayedCapture(pVal: Integer);
    function Get_PartnerID: WideString;
    procedure Set_PartnerID(const pVal: WideString);
    function Get_UserID: WideString;
    procedure Set_UserID(const pVal: WideString);
    function Get_Password: WideString;
    procedure Set_Password(const pVal: WideString);
  public
    property DefaultInterface: IPFProCOM read GetDefaultInterface;
  published
    property VendorID: WideString read Get_VendorID write Set_VendorID;
    property VendorPassword: WideString read Get_VendorPassword write Set_VendorPassword;
    property HostAddress: WideString read Get_HostAddress write Set_HostAddress;
    property HostPort: WideString read Get_HostPort write Set_HostPort;
    property DebugMode: WideString read Get_DebugMode write Set_DebugMode;
    property TimeOut: WideString read Get_TimeOut write Set_TimeOut;
    property ProxyAddress: WideString read Get_ProxyAddress write Set_ProxyAddress;
    property ProxyPort: WideString read Get_ProxyPort write Set_ProxyPort;
    property ProxyLogon: WideString read Get_ProxyLogon write Set_ProxyLogon;
    property ProxyPassword: WideString read Get_ProxyPassword write Set_ProxyPassword;
    property Response: WideString read Get_Response write Set_Response;
    property ParmList: WideString read Get_ParmList write Set_ParmList;
    property DelayedCapture: Integer read Get_DelayedCapture write Set_DelayedCapture;
    property PartnerID: WideString read Get_PartnerID write Set_PartnerID;
    property UserID: WideString read Get_UserID write Set_UserID;
    property Password: WideString read Get_Password write Set_Password;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'COM+';

  dtlOcxPage = 'COM+';

implementation

uses ComObj;

class function CoPNCom.Create: IPFProCOM;
begin
  Result := CreateComObject(CLASS_PNCom) as IPFProCOM;
end;

class function CoPNCom.CreateRemote(const MachineName: string): IPFProCOM;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PNCom) as IPFProCOM;
end;

procedure TPNCom.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{17B9BE57-09EA-11D5-897B-0010B5759DED}';
    IntfIID:   '{17B9BE54-09EA-11D5-897B-0010B5759DED}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPNCom.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPFProCOM;
  end;
end;

procedure TPNCom.ConnectTo(svrIntf: IPFProCOM);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPNCom.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPNCom.GetDefaultInterface: IPFProCOM;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TPNCom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TPNComProperties.Create(Self);
{$ENDIF}
end;

destructor TPNCom.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TPNCom.GetServerProperties: TPNComProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TPNCom.Get_VendorID: WideString;
begin
    Result := DefaultInterface.VendorID;
end;

procedure TPNCom.Set_VendorID(const pVal: WideString);
  { Warning: The property VendorID has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VendorID := pVal;
end;

function TPNCom.Get_VendorPassword: WideString;
begin
    Result := DefaultInterface.VendorPassword;
end;

procedure TPNCom.Set_VendorPassword(const pVal: WideString);
  { Warning: The property VendorPassword has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VendorPassword := pVal;
end;

function TPNCom.Get_HostAddress: WideString;
begin
    Result := DefaultInterface.HostAddress;
end;

procedure TPNCom.Set_HostAddress(const pVal: WideString);
  { Warning: The property HostAddress has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HostAddress := pVal;
end;

function TPNCom.Get_HostPort: WideString;
begin
    Result := DefaultInterface.HostPort;
end;

procedure TPNCom.Set_HostPort(const pVal: WideString);
  { Warning: The property HostPort has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HostPort := pVal;
end;

function TPNCom.Get_DebugMode: WideString;
begin
    Result := DefaultInterface.DebugMode;
end;

procedure TPNCom.Set_DebugMode(const pVal: WideString);
  { Warning: The property DebugMode has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DebugMode := pVal;
end;

function TPNCom.Get_TimeOut: WideString;
begin
    Result := DefaultInterface.TimeOut;
end;

procedure TPNCom.Set_TimeOut(const pVal: WideString);
  { Warning: The property TimeOut has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.TimeOut := pVal;
end;

function TPNCom.Get_ProxyAddress: WideString;
begin
    Result := DefaultInterface.ProxyAddress;
end;

procedure TPNCom.Set_ProxyAddress(const pVal: WideString);
  { Warning: The property ProxyAddress has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ProxyAddress := pVal;
end;

function TPNCom.Get_ProxyPort: WideString;
begin
    Result := DefaultInterface.ProxyPort;
end;

procedure TPNCom.Set_ProxyPort(const pVal: WideString);
  { Warning: The property ProxyPort has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ProxyPort := pVal;
end;

function TPNCom.Get_ProxyLogon: WideString;
begin
    Result := DefaultInterface.ProxyLogon;
end;

procedure TPNCom.Set_ProxyLogon(const pVal: WideString);
  { Warning: The property ProxyLogon has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ProxyLogon := pVal;
end;

function TPNCom.Get_ProxyPassword: WideString;
begin
    Result := DefaultInterface.ProxyPassword;
end;

procedure TPNCom.Set_ProxyPassword(const pVal: WideString);
  { Warning: The property ProxyPassword has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ProxyPassword := pVal;
end;

function TPNCom.Get_Response: WideString;
begin
    Result := DefaultInterface.Response;
end;

procedure TPNCom.Set_Response(const pVal: WideString);
  { Warning: The property Response has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Response := pVal;
end;

function TPNCom.Get_ParmList: WideString;
begin
    Result := DefaultInterface.ParmList;
end;

procedure TPNCom.Set_ParmList(const pVal: WideString);
  { Warning: The property ParmList has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ParmList := pVal;
end;

function TPNCom.Get_DelayedCapture: Integer;
begin
    Result := DefaultInterface.DelayedCapture;
end;

procedure TPNCom.Set_DelayedCapture(pVal: Integer);
begin
  DefaultInterface.Set_DelayedCapture(pVal);
end;

function TPNCom.Get_PartnerID: WideString;
begin
    Result := DefaultInterface.PartnerID;
end;

procedure TPNCom.Set_PartnerID(const pVal: WideString);
  { Warning: The property PartnerID has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PartnerID := pVal;
end;

function TPNCom.Get_UserID: WideString;
begin
    Result := DefaultInterface.UserID;
end;

procedure TPNCom.Set_UserID(const pVal: WideString);
  { Warning: The property UserID has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.UserID := pVal;
end;

function TPNCom.Get_Password: WideString;
begin
    Result := DefaultInterface.Password;
end;

procedure TPNCom.Set_Password(const pVal: WideString);
  { Warning: The property Password has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Password := pVal;
end;

procedure TPNCom.ProcessTransaction;
begin
  DefaultInterface.ProcessTransaction;
end;

procedure TPNCom.AddBinParm(const name: WideString; value: OleVariant);
begin
  DefaultInterface.AddBinParm(name, value);
end;

procedure TPNCom.AddParm(const name: WideString; const value: WideString);
begin
  DefaultInterface.AddParm(name, value);
end;

procedure TPNCom.PNInit;
begin
  DefaultInterface.PNInit;
end;

procedure TPNCom.PNCleanup;
begin
  DefaultInterface.PNCleanup;
end;

function TPNCom.CreateContext(const HostAdd: WideString; HostPort: Integer; TimeOut: Integer; 
                              const ProxyAdd: WideString; ProxyPort: Integer; 
                              const ProxyLog: WideString; const ProxyPass: WideString): Integer;
begin
  Result := DefaultInterface.CreateContext(HostAdd, HostPort, TimeOut, ProxyAdd, ProxyPort, 
                                           ProxyLog, ProxyPass);
end;

function TPNCom.SubmitTransaction(ptrCtx: Integer; const ParmList: WideString; ParmLen: Integer): WideString;
begin
  Result := DefaultInterface.SubmitTransaction(ptrCtx, ParmList, ParmLen);
end;

procedure TPNCom.DestroyContext(ptrCtx: Integer);
begin
  DefaultInterface.DestroyContext(ptrCtx);
end;

function TPNCom.CreateContext2: Integer;
begin
  Result := DefaultInterface.CreateContext2;
end;

function TPNCom.SubmitTransaction2(ptrCtx: Integer): WideString;
begin
  Result := DefaultInterface.SubmitTransaction2(ptrCtx);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TPNComProperties.Create(AServer: TPNCom);
begin
  inherited Create;
  FServer := AServer;
end;

function TPNComProperties.GetDefaultInterface: IPFProCOM;
begin
  Result := FServer.DefaultInterface;
end;

function TPNComProperties.Get_VendorID: WideString;
begin
    Result := DefaultInterface.VendorID;
end;

procedure TPNComProperties.Set_VendorID(const pVal: WideString);
  { Warning: The property VendorID has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VendorID := pVal;
end;

function TPNComProperties.Get_VendorPassword: WideString;
begin
    Result := DefaultInterface.VendorPassword;
end;

procedure TPNComProperties.Set_VendorPassword(const pVal: WideString);
  { Warning: The property VendorPassword has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VendorPassword := pVal;
end;

function TPNComProperties.Get_HostAddress: WideString;
begin
    Result := DefaultInterface.HostAddress;
end;

procedure TPNComProperties.Set_HostAddress(const pVal: WideString);
  { Warning: The property HostAddress has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HostAddress := pVal;
end;

function TPNComProperties.Get_HostPort: WideString;
begin
    Result := DefaultInterface.HostPort;
end;

procedure TPNComProperties.Set_HostPort(const pVal: WideString);
  { Warning: The property HostPort has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HostPort := pVal;
end;

function TPNComProperties.Get_DebugMode: WideString;
begin
    Result := DefaultInterface.DebugMode;
end;

procedure TPNComProperties.Set_DebugMode(const pVal: WideString);
  { Warning: The property DebugMode has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DebugMode := pVal;
end;

function TPNComProperties.Get_TimeOut: WideString;
begin
    Result := DefaultInterface.TimeOut;
end;

procedure TPNComProperties.Set_TimeOut(const pVal: WideString);
  { Warning: The property TimeOut has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.TimeOut := pVal;
end;

function TPNComProperties.Get_ProxyAddress: WideString;
begin
    Result := DefaultInterface.ProxyAddress;
end;

procedure TPNComProperties.Set_ProxyAddress(const pVal: WideString);
  { Warning: The property ProxyAddress has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ProxyAddress := pVal;
end;

function TPNComProperties.Get_ProxyPort: WideString;
begin
    Result := DefaultInterface.ProxyPort;
end;

procedure TPNComProperties.Set_ProxyPort(const pVal: WideString);
  { Warning: The property ProxyPort has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ProxyPort := pVal;
end;

function TPNComProperties.Get_ProxyLogon: WideString;
begin
    Result := DefaultInterface.ProxyLogon;
end;

procedure TPNComProperties.Set_ProxyLogon(const pVal: WideString);
  { Warning: The property ProxyLogon has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ProxyLogon := pVal;
end;

function TPNComProperties.Get_ProxyPassword: WideString;
begin
    Result := DefaultInterface.ProxyPassword;
end;

procedure TPNComProperties.Set_ProxyPassword(const pVal: WideString);
  { Warning: The property ProxyPassword has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ProxyPassword := pVal;
end;

function TPNComProperties.Get_Response: WideString;
begin
    Result := DefaultInterface.Response;
end;

procedure TPNComProperties.Set_Response(const pVal: WideString);
  { Warning: The property Response has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Response := pVal;
end;

function TPNComProperties.Get_ParmList: WideString;
begin
    Result := DefaultInterface.ParmList;
end;

procedure TPNComProperties.Set_ParmList(const pVal: WideString);
  { Warning: The property ParmList has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ParmList := pVal;
end;

function TPNComProperties.Get_DelayedCapture: Integer;
begin
    Result := DefaultInterface.DelayedCapture;
end;

procedure TPNComProperties.Set_DelayedCapture(pVal: Integer);
begin
  DefaultInterface.Set_DelayedCapture(pVal);
end;

function TPNComProperties.Get_PartnerID: WideString;
begin
    Result := DefaultInterface.PartnerID;
end;

procedure TPNComProperties.Set_PartnerID(const pVal: WideString);
  { Warning: The property PartnerID has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PartnerID := pVal;
end;

function TPNComProperties.Get_UserID: WideString;
begin
    Result := DefaultInterface.UserID;
end;

procedure TPNComProperties.Set_UserID(const pVal: WideString);
  { Warning: The property UserID has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.UserID := pVal;
end;

function TPNComProperties.Get_Password: WideString;
begin
    Result := DefaultInterface.Password;
end;

procedure TPNComProperties.Set_Password(const pVal: WideString);
  { Warning: The property Password has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Password := pVal;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TPNCom]);
end;

end.
