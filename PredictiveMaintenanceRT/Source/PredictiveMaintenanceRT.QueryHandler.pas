unit PredictiveMaintenanceRT.QueryHandler;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel, Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.QueryExecutor, PredictiveMaintenanceRT.MaintenanceModel, PredictiveMaintenanceRT.ProductionOrderModel,
  PredictiveMaintenanceRT.PhaseModel, PredictiveMaintenanceRT.QueryUtilityHandler,
  PredictiveMaintenanceRT.ClosedPeriodModel, PredictiveMaintenanceRT.CalendarDayModel;

type
  TQueryHandler = class

type
  TFunc<T> = reference to function(Value: TADOQuery): TList<T>;
  private
  {Private declarations}
    FQueryExecutor: TQueryExecutor;
    FQueryUtilityHandler: TQueryUtilityHandler;

    function PopulateCell<T>(const AQuery: string; AFunc: TFunc<T>): TList<T>;

    function PopulateProductionOrders(APhases: TList<TPhaseModel>): TList<TProductionOrderModel>;

    function GetQueryExecutor: TQueryExecutor;
    property QueryExecutor: TQueryExecutor read GetQueryExecutor write FQueryExecutor;

    function GetQueryUtilityHandler: TQueryUtilityHandler;
    property QueryUtilityHandler: TQueryUtilityHandler read GetQueryUtilityHandler write FQueryUtilityHandler;

  public
  {Public declarations}
    function PopulateCellModel(ACellId: integer): TCellDataModel;
    function GetCellsList: TList<integer>;
    function GetClosedPeriods(ACellId: integer): TList<TClosedPeriodModel>;
    function GetCalendarData(ACellId: integer): TList<TCalendarDayModel>;
  end;

implementation

{ TQueryHandler }
uses
  PredictiveMaintenanceRT.Constants, System.SysUtils, PredictiveMaintenanceRT.Messages, PredictiveMaintenanceRT.MachineStopModel;

function TQueryHandler.GetCalendarData(ACellId: integer): TList<TCalendarDayModel>;
begin
  Result := PopulateCell<TCalendarDayModel>(Format(QUERY_CALENDAR,[IntToStr(ACellId)]), QueryUtilityHandler.QueryToCalendar);
end;

function TQueryHandler.GetCellsList: TList<integer>;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  try
    LQuery := QueryExecutor.ExecuteQuery(QUERY_CELLS);
    if LQuery <> nil then
      Result := QueryUtilityHandler.QueryToCellsList(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
  finally
    LQuery.Free;
  end;

end;

function TQueryHandler.GetClosedPeriods(
  ACellId: integer): TList<TClosedPeriodModel>;
begin
  Result := PopulateCell<TClosedPeriodModel>(Format(QUERY_CLOSEDPERIOD,[IntToStr(ACellId)]), QueryUtilityHandler.QueryToClosedPeriods);
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

function TQueryHandler.PopulateCellModel(ACellId: integer): TCellDataModel;
begin
  Result := TCellDataModel.Create;
  try
    Result.CellId := ACellId;

    Result.MaintenanceData := PopulateCell<TMaintenanceModel>(Format(QUERY_MAINTENANCE ,[IntToStr(ACellId)]), QueryUtilityHandler.QueryToMaintenanceData);

    Result.TotalPartials := PopulateCell<TPartialModel>(Format(QUERY_TOTAL_PARTIALS, [intToStr(ACellId)]), QueryUtilityHandler.QueryToPartialsList);

    Result.ProductionOrders := PopulateProductionOrders(PopulateCell<TPhaseModel>(Format(QUERY_PHASES ,[IntToStr(ACellId)]), QueryUtilityHandler.QueryToPhaseList));

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
  APhases: TList<TPhaseModel>): TList<TProductionOrderModel>;
var
  LPhase: TPhaseModel;
  LProductionOrder: TProductionOrderModel;
begin
  Result := TList<TProductionOrderModel>.Create;
  LProductionOrder := TProductionOrderModel.Create;
  try
    for LPhase in APhases do
    begin
      if LPhase.POID <> LProductionOrder.POID then
      begin
        LProductionOrder := TProductionOrderModel.Create;
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
  AFunc: TFunc<T>): TList<T>;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
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
