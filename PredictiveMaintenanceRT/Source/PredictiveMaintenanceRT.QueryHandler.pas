unit PredictiveMaintenanceRT.QueryHandler;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel, Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.QueryExecutor, PredictiveMaintenanceRT.MaintenanceModel, PredictiveMaintenanceRT.ProductionOrderModel,
  PredictiveMaintenanceRT.PhaseModel, PredictiveMaintenanceRT.QueryUtilityHandler,
  PredictiveMaintenanceRT.ClosedPeriodModel, PredictiveMaintenanceRT.CalendarModel;

type
  TQueryHandler = class

type
  TFunctInt<T> = reference to function(Value: TADOQuery): TList<T>;

  TFunc<T: class> = reference to function(Value: TADOQuery): TObjectList<T>;
  private
  {Private declarations}
    FQueryExecutor: TQueryExecutor;
    FQueryUtilityHandler: TQueryUtilityHandler;

    function PopulateCell<T: class>(const AQuery: string; AFunc: TFunc<T>): TObjectList<T>;

    function PopulateCellList(const AQuery: string; AFunc: TFunctInt<integer>): TList<integer>;

    function PopulateProductionOrders(APhases: TObjectList<TPhaseModel>): TObjectList<TProductionOrderModel>;

    function GetQueryExecutor: TQueryExecutor;
    property QueryExecutor: TQueryExecutor read GetQueryExecutor write FQueryExecutor;

    function GetRepCdCId(ACelProId: integer): integer;
    procedure GetCellInfo(ACelProId: integer; out ACode: String; out ADescription: string);

    function GetQueryUtilityHandler: TQueryUtilityHandler;
    property QueryUtilityHandler: TQueryUtilityHandler read GetQueryUtilityHandler write FQueryUtilityHandler;

  public
  {Public declarations}
    destructor Destroy; override;
    function PopulateCellModel(ACellId: integer): TCellDataModel;
    function GetCellsList: TList<integer>;
    function GetClosedPeriods(ACellId: integer): TObjectList<TClosedPeriodModel>;
    function GetCalendarData(ACellId: integer): TObjectList<TCalendarModel>;
    function GetWeekCalendar(ACalendarId: integer): TDictionary<integer, double>;
  end;

implementation

{ TQueryHandler }
uses
  PredictiveMaintenanceRT.Constants, System.SysUtils, PredictiveMaintenanceRT.Messages, PredictiveMaintenanceRT.MachineStopModel;

destructor TQueryHandler.Destroy;
begin
  if Assigned(FQueryExecutor) then
    FQueryExecutor.Free;
  if Assigned(FQueryUtilityHandler) then
    FQueryUtilityHandler.Free;
  inherited;
end;

function TQueryHandler.GetCalendarData(ACellId: integer): TObjectList<TCalendarModel>;
var
  LCalendarId: TCalendarModel;
begin
  //get Calendars
  Result := PopulateCell<TCalendarModel>(Format(QUERY_CALENDAR,[IntToStr(ACellId)]), QueryUtilityHandler.QueryToCalendars);
  if ( Result.Count = 0 ) then
  begin
    FreeAndNil(Result);

    var LRepCdCId: integer;
    LRepCdCID := GetRepCdCId(ACellId);
    Result := PopulateCell<TCalendarModel>(Format(QUERY_CALENDAR_DEPARTMENT,[IntToStr(LRepCdCID)]), QueryUtilityHandler.QueryToCalendars);
    if ( Result.Count = 0 ) then
    begin
      FreeAndNil(Result);
      Result := PopulateCell<TCalendarModel>(Format(QUERY_CALENDAR_PLANT,[IntToStr(ACellId)]), QueryUtilityHandler.QueryToCalendars);

      if ( Result.Count = 0 ) then
        Exit;
    end;
  end;

  //populate week calendar for each calendar found
  for LCalendarId in Result do
    LCalendarId.HourDaily := GetWeekCalendar(LCalendarId.IDCalendar);

end;

procedure TQueryHandler.GetCellInfo(ACelProId: integer; out ACode,
  ADescription: string);
var
  LQrySel: TADOQuery;
begin
  LQrySel := QueryExecutor.ExecuteQuery(Format(QUERY_GETCELPRO_INFO, [IntToStr(ACelProId)]));
  try
    ACode := LQrySel.FieldByName(CODICE).asString;
    ADescription := LQrySel.FieldByName(DESCRIZIONE).asString;
  finally
    LQrySel.Free;
  end;

end;

function TQueryHandler.GetCellsList: TList<integer>;
begin
  Result := PopulateCellList(QUERY_CELLS, QueryUtilityHandler.QueryToCellsList);
end;

function TQueryHandler.GetClosedPeriods(
  ACellId: integer): TObjectList<TClosedPeriodModel>;
begin
  Result := PopulateCell<TClosedPeriodModel>(Format(QUERY_CLOSEDPERIOD,[IntToStr(ACellId), IntToStr(GetRepCdCId(ACellId))]), QueryUtilityHandler.QueryToClosedPeriods);
end;

function TQueryHandler.GetQueryExecutor: TQueryExecutor;
begin
  if not Assigned(FQueryExecutor) then
    FQueryExecutor := TQueryExecutor.Create(DEFAULT_USERNAME, DEFAULT_PASSWORD, DB_NAME, SERVER_NAME);
  Result := FQueryExecutor;
end;

function TQueryHandler.GetQueryUtilityHandler: TQueryUtilityHandler;
begin
  if not Assigned(FQueryUtilityHandler) then
    FQueryUtilityHandler := TQueryUtilityHandler.Create;
  Result := FQueryUtilityHandler;
end;

function TQueryHandler.GetRepCdCId(ACelProId: integer): integer;
var
  LQrySel: TADOQuery;
begin
  LQrySel := QueryExecutor.ExecuteQuery(Format(QUERY_GETREPCDC_FROMCELPRO, [IntToStr(ACelProId)]));
  try
    Result := LQrySel.FieldByName(ID_REPARTO).asInteger;
  finally
    LQrySel.Free;
  end;


end;

function TQueryHandler.GetWeekCalendar(ACalendarId: integer): TDictionary<integer, double>;
var
  LQrySel: TADOQuery;
begin
  //initialize result list
  Result := TDictionary<integer, double>.Create;

  LQrySel := QueryExecutor.ExecuteQuery(Format(QUERY_WEEK_CALENDAR, [IntToStr(ACalendarId)]));
  try
    try
      while not LQrySel.Eof do
      begin
        Result.Add(
          LQrySel.FieldByName(GIORNO).AsInteger
          , LQrySel.FieldByName(CALENDAR_TOTORE).AsFloat
        );

        LQrySel.Next;
      end;
    except
      begin
        Result.Free;
        raise;
      end;
    end;
  finally
    LQrySel.Free;
  end;
end;

function TQueryHandler.PopulateCellModel(ACellId: integer): TCellDataModel;
var
  LObjPhases: TObjectList<TPhaseModel>;
  LCode: string;
  LDescription: string;
begin
  Result := TCellDataModel.Create;
  try
    Result.CellId := ACellId;

    GetCellInfo(Result.CellId, LCode, LDescription);

    Result.CellCode := LCode;
    Result.CellDescription := LDescription;

    Result.MaintenanceData := PopulateCell<TMaintenanceModel>(Format(QUERY_MAINTENANCE ,[IntToStr(ACellId)]), QueryUtilityHandler.QueryToMaintenanceData);

    Result.TotalPartials := PopulateCell<TPartialModel>(Format(QUERY_TOTAL_PARTIALS, [intToStr(ACellId)]), QueryUtilityHandler.QueryToPartialsList);

    LObjPhases := PopulateCell<TPhaseModel>(Format(QUERY_PHASES ,[IntToStr(ACellId)]), QueryUtilityHandler.QueryToPhaseList);
    try
      Result.ProductionOrders := PopulateProductionOrders(LObjPhases);
    finally
      LObjPhases.Free;
    end;

    QueryUtilityHandler.WorkHoursSum(Result.ProductionOrders);

    Result.MachineStops := PopulateCell<TMachineStopModel>(Format(QUERY_MACHINESTOPS, [IntToStr(ACellId)]), QueryUtilityHandler.QueryToMachineStops);

  except
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TQueryHandler.PopulateProductionOrders(
  APhases: TObjectList<TPhaseModel>): TObjectList<TProductionOrderModel>;
var
  LPhase: TPhaseModel;
  LProductionOrder: TProductionOrderModel;

begin
  LProductionOrder := nil;
  APhases.OwnsObjects := False;

  Result := TObjectList<TProductionOrderModel>.Create;
  try
    for LPhase in APhases do
    begin
      if ( LProductionOrder = nil ) or ( LPhase.POID <> LProductionOrder.POID ) then
      begin
        LProductionOrder := TProductionOrderModel.Create;
        LProductionOrder.Phases := TObjectList<TPhaseModel>.Create;
        LProductionOrder.POID := LPhase.POID;
        Result.Add(LProductionOrder);
      end;

      LProductionOrder.Phases.Add(LPhase);
    end;
  except
    Result.Free;
    raise Exception.Create(PO_ERROR);
  end;
end;

function TQueryHandler.PopulateCell<T>(const AQuery: string;
  AFunc: TFunc<T>): TObjectList<T>;
var
  LQuery: TADOQuery;

  LObj: T;
begin
  try
    LQuery := QueryExecutor.ExecuteQuery(AQuery);
    if LQuery <> nil then
      Result := AFunc(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
  finally
    LQuery.Free;
  end;
end;

function TQueryHandler.PopulateCellList(const AQuery: string;
  AFunc: TFunctInt<integer>): TList<integer>;
var
  LQuery: TADOQuery;
begin
  LQuery := nil;
  try
    LQuery := QueryExecutor.ExecuteQuery(AQuery);
    if LQuery <> nil then
      Result := AFunc(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
  finally
    LQuery.Free;
  end;
end;

end.
