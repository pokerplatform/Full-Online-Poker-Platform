unit uLobbyModule;

interface

uses
  SysUtils, Classes, ShellAPI, Windows, Forms, StrUtils,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uDataList, uBotConnection;

type
  TLobbyModule = class
  private
    FStats: TDataList;
    FData: TDataList;

    FCurrentColumns: TDataList;
    FCurrentProcesses: TDataList;
    FCurrentProcessesInfo: TDataList;

    FCurrentCategoryID: Integer;
    FCurrentSubCategoryID: Integer;
    FCurrentProcessID: Integer;

    FPlayersCount: Integer;
    FProcessesCount: Integer;

    procedure Run_UpdateSummary(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_GetStats(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_GetCategories(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_GetProcesses(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_GetProcessInfo(BotConnection: TBotConnection; XMLRoot: IXMLNode);

    procedure UpdateCategories;
    procedure UpdateProcesses;
  public
    // Collections
    property Stats: TDataList read FStats;
    property Data: TDataList read FData;

    // Current Collections
    property CurrentColumns: TDataList read FCurrentColumns;
    property CurrentProcesses: TDataList read FCurrentProcesses;
    property CurrentProcessesInfo: TDataList read FCurrentProcessesInfo;

    // Summary info
    property PlayersCount: Integer read FPlayersCount;
    property ProcessesCount: Integer read FProcessesCount;

    // Current IDs
    property CurrentCategoryID: Integer read FCurrentCategoryID;
    property CurrentSubCategoryID: Integer read FCurrentSubCategoryiD;
    property CurrentProcessID: Integer read FCurrentProcessID;

    // Current sort values
    procedure Do_ChooseCategory(NewCategoryID: Integer);
    procedure Do_ChooseSubCategory(NewSubcategoryID: Integer);
    procedure Do_ChooseProcess(NewProcessID, NewProcessIndex: Integer);
    procedure Do_Refresh(BotConnection: TBotConnection);

    procedure RunCommand(BotConnection: TBotConnection; XMLRoot: IXMLNode);

    constructor Create;
    destructor  Destroy; override;
  end;

implementation

uses
  uLogger, uConstants, uCommonDataModule, uParserModule;

{ TLobbyModule }

constructor TLobbyModule.Create;
begin
  FStats := TDataList.Create(0, nil);
  FData := TDataList.Create(0, nil);

  FStats.Clear;
  FData.Clear;

  FCurrentCategoryID := 0;
  FCurrentSubCategoryID := 0;
  FCurrentProcessID := 0;
end;

destructor TLobbyModule.Destroy;
begin
  FStats.Free;
  FData.Free;
end;


// Run external commands

procedure TLobbyModule.RunCommand(BotConnection: TBotConnection; XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Log(0, ClassName, 'RunCommand', 'Run', ltCall);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := lowercase(XMLNode.NodeName);
        Logger.Log(0, ClassName, 'RunCommand', 'Found action:' + strNode, ltCall);

        if strNode = 'apgetprocessinfo' then
          Run_GetProcessInfo(BotConnection, XMLNode)
        else
        if strNode = 'apgetprocesses' then
          Run_GetProcesses(BotConnection, XMLNode)
        else
        if strNode = 'apgetcategories' then
          Run_GetCategories(BotConnection, XMLNode)
        else
        if strNode = 'apupdatesummary' then
          Run_UpdateSummary(BotConnection, XMLNode)
        else
        if strNode = 'apgetstats' then
          Run_GetStats(BotConnection, XMLNode);

      end;
  except
    on E: Exception do
      Logger.Log(0, ClassName, 'RunCommand', E.Message, ltException);
  end;

  strNode := '';
end;

procedure TLobbyModule.Run_UpdateSummary(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="lobby">
  <apupdatesummary players="2134" processes="576"/>
</object>
}
begin
  FPlayersCount := XMLRoot.Attributes['players'];
  FProcessesCount := XMLRoot.Attributes['processes'];
end;

procedure TLobbyModule.Run_GetStats(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="lobby">
  <apgetstats result="0|...">
    <stats id="1" name="Player Count" propertyid="1"/>
    <stats id="2" name="Watchers"     propertyid="1"/>
    <stats id="3" name="Bet"          propertyid="3"/>
    <stats id="4" name="Game Status"  propertyid="7"/>
  </apgetstats>
</object>
}
var
  ItemsCount: Integer;
  Loop    : Integer;
  XMLNode : IXMLNode;
  newItem : TDataList;
begin
  if CommonDataModule.CheckCommandResult(BotConnection, XMLRoot) then
  begin
    ItemsCount := XMLRoot.ChildNodes.Count;
    FStats.ClearItems(ItemsCount);

    for Loop := 0 to ItemsCount - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      newItem := FStats.AddItem(XMLNode.Attributes[XMLATTRNAME_ID], Loop);
      newItem.Name := XMLNode.Attributes[XMLATTRNAME_NAME];
      newItem.Value := XMLNode.Attributes['propertyid'];
    end;
  end;
end;

procedure TLobbyModule.Run_GetCategories(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="lobby">
  <apgetcategories result="0|...">
    <category id="1" name="Poker"/>
      <subcategory id="1" name="Texas Hold'em"/>
      <subcategory id="2" name="Omaha Hi"/>
      <subcategory id="3" name="Omaha Hi/Lo"/>
      <subcategory id="4" name="7 Card Stud Hi"/>
    <category/>
    <category id="2" name="Tetris"/>
    <category id="3" name="Chess"/>
    <category id="4" name="Solitaire"/>
  </apgetcategories>
</object>
}
var
  Loop    : Integer;
  CatCount: Integer;
  XMLNode : IXMLNode;

  Loop2   : Integer;
  SubCount: Integer;
  XMLSub  : IXMLNode;

  curCategory: TDataList;
  curSubcategory: TDataList;
begin
  if CommonDataModule.CheckCommandResult(BotConnection, XMLRoot) then
  begin
    CatCount := XMLRoot.ChildNodes.Count;
    FData.Clear;
    FData.ClearItems(CatCount);
    FCurrentColumns := nil;
    FCurrentProcesses := nil;
    FCurrentProcessesInfo := nil;

    for Loop := 0 to CatCount - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      curCategory := FData.AddItem(XMLNode.Attributes[XMLATTRNAME_ID], Loop);
      curCategory.Name := XMLNode.Attributes[XMLATTRNAME_Name];
      SubCount := XMLNode.ChildNodes.Count;
      curCategory.ClearItems(SubCount);

      for Loop2 := 0 to SubCount - 1 do
      begin
        XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
        curSubcategory := curCategory.AddItem(XMLSub.Attributes[XMLATTRNAME_ID], Loop2);
        curSubcategory.Name := XMLSub.Attributes[XMLATTRNAME_Name];
        curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] := 0;
        curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] := 0;
        curSubCategory.Add(SubCategoryColumnsItemID);
        curSubCategory.Add(SubCategoryProcessesItemID);
        curSubCategory.Add(SubCategoryProcessesInfoItemID);
      end;
    end;

    UpdateCategories;
  end;
end;

procedure TLobbyModule.Run_GetProcesses(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="lobby">
  <apgetprocesses  subcategoryid="1" result="0|...">
    <columns>
      <stats id="1" order="1"/>
      <stats id="2" order="4"/>
      <stats id="3" order="2"/>
      <stats id="4" order="3"/>
    </columns>
    <processes>
      <process id="1" name="Money table #123" currencyid="1" groupid="1">
        <stats id="1" value="12"/>
        <stats id="2" value="2.57"/>
        <stats id="4" value="456"/>
        <stats id="7" value="Waiting..."/>
      </process>
      <process id="1" name="Tournament" currencyid="2" groupid="1">
        <stats id="1" value="12"/>
        <stats id="5" value="Tetris"/>
        <stats id="8" value="456"/>
        <stats id="9" value="Waiting..."/>
      </process>
    </processes>
  </apgetprocesses>
</object>


**** OR

<object name="lobby">
  <togettournaments result="0|..." activetournamentscount="7" activaplayerscount="100">
    <columns>
      <stats id="1" order="1"/>
      <stats id="2" order="4"/>
      <stats id="3" order="2"/>
      <stats id="4" order="3"/>
    </columns>
    <processes>
      <process id="1" name="Tournament #1" currencyid="2" groupid="1">
        <stats id="1" value="12"/>
        <stats id="5" value="Holdem"/>
        <stats id="8" value="456"/>
        <stats id="9" value="Announced"/>
      </process>
    </processes>
  </apgetprocesses>
</object>

}
var
  Loop    : Integer;
  XMLNode : IXMLNode;
  strNode : String;
  Loop2   : Integer;
  XMLSub  : IXMLNode;
  Loop3   : Integer;
  XMLStat : IXMLNode;
  strTemp : String;

  curCategory: TDataList;
  curSubCategory: TDataList;
  curSubCategoryID: Integer;

  curColumns: TDataList;
  curColumn: TDataList;
  curStats: TDataList;
  curColumnID: Integer;

  curProcesses: TDataList;
  curProcess: TDataList;
  curProcessID: Integer;
  nPlayers: Integer;

  nPlayerCount: Integer;
  nProcessCount: Integer;

begin
  if CommonDataModule.CheckCommandResult(BotConnection, XMLRoot) then
  begin
    curSubCategoryID := XMLRoot.Attributes[XMLATTRNAME_SUBCATEGORYID];

    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(curSubCategoryID, curSubCategory) then
      begin
        nPlayerCount := 0;
        nProcessCount := 0;
        FCurrentColumns := nil;
        FCurrentProcesses := nil;

        for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
        begin
          XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
          strNode := lowercase(XMLNode.NodeName);

          if strNode = XMLNODENAME_COLUMNS then
          begin
            curColumns := curSubCategory.Add(SubCategoryColumnsItemID);
            curColumns.ClearData(0);
            curColumns.ClearItems(XMLNode.ChildNodes.Count);

            for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            begin
              XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
              curColumnID := XMLSub.Attributes[XMLATTRNAME_ID];
              if FStats.Find(curColumnID, curStats) then
              begin
                curColumn := curColumns.AddItem(curColumnID, Loop2);
                curColumn.Name  := curStats.Name;
                curColumn.Value := curStats.Value;
                curColumn.ValuesAsInteger['order'] := XMLSub.Attributes['order'];
              end
              else
              begin
                curColumn := curColumns.AddItem(curColumnID, Loop2);
                curColumn.Name  := inttostr(curColumnID);
                curColumn.Value := 4;
                curColumn.ValuesAsInteger['order'] := XMLSub.Attributes['order'];
              end;
            end;
            curColumns.SortItems('order', true, true);
          end;

          if strNode = XMLNODENAME_PROCESSES then
          begin
            curProcesses := curSubCategory.Add(SubCategoryProcessesItemID);
            curProcesses.ClearItems(XMLNode.ChildNodes.Count);

            for Loop2 := 0 to XMLNode.ChildNodes.Count - 1 do
            begin
              XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
              curProcessID := XMLSub.Attributes[XMLATTRNAME_ID];
              curProcess := curProcesses.AddItem(curProcessID, Loop2);
              curProcess.ClearData(XMLSub.ChildNodes.Count + 4);
              curProcess.ClearItems(0);
              curProcess.Name := XMLSub.Attributes[XMLATTRNAME_NAME];
              if curProcess.Name = '' then
                curProcess.Name := 'Table #' + inttostr(curProcessID);
              curProcess.Value := XMLSub.Attributes['groupid'];

              strTemp := ' ';
              for Loop3 := 0 to XMLSub.ChildNodes.Count - 1 do
              begin
                XMLStat := XMLSub.ChildNodes.Nodes[Loop3];
                curProcess.ValueNames[Loop3] := XMLStat.Attributes[XMLATTRNAME_ID];
                curProcess.Values[Loop3] :=XMLStat.Attributes['value'];

                if curProcess.ValueNames[Loop3] = inttostr(StatID_Stakes) then
                if pos('/', curProcess.Values[Loop3]) < 1 then
                  strTemp := copy(curProcess.Values[Loop3], 1, 3);
              end;

              curProcess.ValueNames[curProcess.ValueCount - 1] := 'currencyid';
              curProcess.Values[curProcess.ValueCount - 1] := XMLSub.Attributes['currencyid'];
              curProcess.ValueNames[curProcess.ValueCount - 2] := inttostr(StatID_TableName);
              curProcess.Values[curProcess.ValueCount - 2] := curProcess.Name;
              curProcess.ValueNames[curProcess.ValueCount - 3] := DATANAME_STAKESORT;
              curProcess.Values[curProcess.ValueCount - 3] := strTemp;

              curProcess.ValueNames[curProcess.ValueCount - 4] := XMLNODENAME_ACTIONDISPATCHERID;
              if XMLSub.HasAttribute(XMLNODENAME_ACTIONDISPATCHERID) then
                curProcess.Values[curProcess.ValueCount - 4] :=
                  XMLSub.Attributes[XMLNODENAME_ACTIONDISPATCHERID]
              else
                curProcess.Values[curProcess.ValueCount - 4] := 0;

              nPlayers := curProcess.ValuesAsInteger[inttostr(StatID_PlayersCount)];
              if nPlayers > 0 then
              begin
                nPlayerCount := nPlayerCount + nPlayers;
                nProcessCount := nProcessCount + 1;
              end;
            end;
            if XMLRoot.HasAttribute('activaplayerscount') then
              nPlayerCount := XMLRoot.Attributes['activaplayerscount'];
            if XMLRoot.HasAttribute('activetournamentscount') then
              nProcessCount := XMLRoot.Attributes['activetournamentscount'];
            curSubCategory.ValuesAsInteger[DATANAME_PLAYERCOUNT] := nPlayerCount;
            curSubCategory.ValuesAsInteger[DATANAME_PROCESSCOUNT] := nProcessCount;
          end;
        end;

      if curSubCategory.ID = FCurrentSubCategoryID then
        UpdateProcesses;
    end;
  end;

  strNode := '';
  strTemp := '';
end;

procedure TLobbyModule.Run_GetProcessInfo(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="lobby">
  <apgetprocessinfo processid="37" result="0">
    <group name="Players:" value="4">
      <data name="Player 1" city="Sim-City" value="$1000"/>
      <data name="Player 2" city="Sim-Town" value="$2000"/>
      <data name="Player 3" city="Sim-Village" value="$3000"/>
    </group>
    <group name="Waiting list:" value="1/2"/>
    <group name="Watchers:" value="3"/>
  </apgetprocessinfo>
</object>
}
var
  Loop: Integer;
  XMLNode: IXMLNode;
  Loop2: Integer;
  XMLSub: IXMLNode;

  curCategory: TDataList;
  curSubCategory: TDataList;
  curProcessesInfo: TDataList;
  curProcessInfo: TDataList;
  curProcesses: TDataList;
  curProcess: TDataList;
  curData: TDataList;
  RestrictNames: Boolean;
  RestrictedNames: String;
  RestrictedNamesCount: Integer;
begin
  RestrictNames := CommonDataModule.SessionSettings.ValuesAsBoolean[BotRestrictByNames];
  RestrictedNames := UpperCase(CommonDataModule.SessionSettings.ValuesAsString[BotRestrictedNames]);
  RestrictedNamesCount := 0;

  if CommonDataModule.CheckCommandResult(BotConnection, XMLRoot) then
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
        if curSubCategory.Find(SubCategoryProcessesItemID, curProcesses) then
        if curProcesses.Find(XMLRoot.Attributes[XMLATTRNAME_PROCESSID], curProcess) then
        if curSubCategory.Find(SubCategoryProcessesInfoItemID, curProcessesInfo) then
        begin
          curProcessInfo := curProcessesInfo.Add(XMLRoot.Attributes[XMLATTRNAME_PROCESSID]);
          curProcessInfo.Clear;

          for Loop := 0 to XMLRoot.ChildNodes.Count -1 do
          begin
            XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
            curData := curProcessInfo.Add((Loop + 1) * 100);
            curData.Name := XMLNode.Attributes[XMLATTRNAME_NAME];
            curData.ValuesAsString['value'] := XMLNode.Attributes['value'];
            curData.ValuesAsBoolean['isgroup'] := true;

            for Loop2 := 0 to XMLNode.ChildNodes.Count -1 do
            begin
              XMLSub := XMLNode.ChildNodes.Nodes[Loop2];
              curData := curProcessInfo.Add((Loop + 1 ) * 100 + Loop2 + 1);
              curData.Name := XMLSub.Attributes[XMLATTRNAME_NAME];
              if RestrictNames then
                if UpperCase(LeftStr(curData.Name, Length(RestrictedNames))) = RestrictedNames then
                  Inc(RestrictedNamesCount);
              curData.ValuesAsString['city'] := XMLSub.Attributes['city'];
              curData.ValuesAsString['value'] := XMLSub.Attributes['value'];
              curData.ValuesAsBoolean['isgroup'] := false;
            end;
          end;

          curProcess.ValuesAsInteger[XMLNODENAME_BOTSCOUNT] := RestrictedNamesCount;
        end;
end;


// Start and stop of showing visual window

// Update procedures

procedure TLobbyModule.UpdateCategories;
var
  curCategory: TDataList;
  BadSubCategoryID: Boolean;
  curSubCategory: TDataList;
  Changed: Boolean;
begin
  Changed := false;
  
  if FCurrentCategoryID <= 0 then
  begin
    FCurrentCategoryID := 0;
    FCurrentSubCategoryID := 0;
    FCurrentProcessID := 0;

    if Data.Count > 0 then
      FCurrentCategoryID := Data.Items(0).ID;
  end;

  BadSubCategoryID := true;
  if Data.Find(FCurrentCategoryID, curCategory) then
    if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
      BadSubCategoryID := false;


  if BadSubCategoryID then
  begin
    FCurrentSubCategoryID := 0;
    FCurrentProcessID := 0;
    if Data.Find(FCurrentCategoryID, curCategory) then
      if curCategory.Count > 0 then
      begin
        FCurrentSubCategoryID := curCategory.Items(0).ID;
        Changed := true;
      end;
  end;

  if Changed then
    Do_ChooseSubCategory(FCurrentSubCategoryID);
end;

procedure TLobbyModule.UpdateProcesses;
var
  BadProcessID: Boolean;
  curCategory: TDataList;
  curSubCategory: TDataList;
  curProcess: TDataList;
  OldProcessID: Integer;
begin
  BadProcessID := true;
  OldProcessID := FCurrentProcessID;

  FCurrentColumns := nil;
  FCurrentProcesses := nil;

  if Data.Find(FCurrentCategoryID, curCategory) then
    if curCategory.Find(FCurrentSubCategoryID, curSubCategory) then
      if curSubCategory.Find(SubCategoryColumnsItemID, FCurrentColumns) then
        if curSubCategory.Find(SubCategoryProcessesItemID, FCurrentProcesses) then
          if curSubCategory.Find(SubCategoryProcessesInfoItemID, FCurrentProcessesInfo) then
            if FCurrentProcesses.Find(FCurrentProcessID, curProcess) then
              BadProcessID := false;

  if BadProcessID then
    FCurrentProcessID := 0;

  if FCurrentProcessID = 0 then
    if FCurrentProcesses <> nil then
      if FCurrentProcesses.Count > 0 then
        FCurrentProcessID := FCurrentProcesses.Items(0).ID;

  if FCurrentProcessID <> OldProcessID then
    Do_ChooseProcess(FCurrentProcessID, 0);
end;

// Visual procedures

procedure TLobbyModule.Do_ChooseCategory(NewCategoryID: Integer);
begin
  FCurrentCategoryID := NewCategoryID;
  UpdateCategories;
end;

procedure TLobbyModule.Do_ChooseSubCategory(NewSubcategoryID: Integer);
begin
  FCurrentSubCategoryID := NewSubcategoryID;
  UpdateProcesses;
end;

procedure TLobbyModule.Do_ChooseProcess(NewProcessID, NewProcessIndex: Integer);
begin
  FCurrentProcessID := NewProcessID;
end;

procedure TLobbyModule.Do_Refresh(BotConnection: TBotConnection);
begin
  ParserModule.Send_UpdateSummary(BotConnection);

  if FCurrentSubCategoryID > 0 then
    ParserModule.Send_GetProcesses(BotConnection, FCurrentSubCategoryID)
  else
    UpdateCategories;

  if FCurrentProcessID > 0 then
    ParserModule.Send_GetProcessInfo(BotConnection, FCurrentProcessID)
  else
    UpdateProcesses;
end;

end.
