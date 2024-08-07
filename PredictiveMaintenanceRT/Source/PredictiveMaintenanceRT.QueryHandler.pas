unit PredictiveMaintenanceRT.QueryHandler;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel, Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.QueryExecutor, PredictiveMaintenanceRT.MaintenanceModel, PredictiveMaintenanceRT.ProductionOrderModel,
  PredictiveMaintenanceRT.PhaseModel, PredictiveMaintenanceRT.QueryUtilityHandler;

type
  TQueryHandler = class

  private
  {Private declarations}
    FQueryExecutor: TQueryExecutor;
    FQueryUtilityHandler: TQueryUtilityHandler;

    function PopulatePartials(ACellId: integer; ALastMaintenance: Extended): TList<TPartialModel>;
    function PopulateMaintenanceData(ACellId: integer): TList<TMaintenanceModel>;
    function PopulateProductionOrders(APhases: TList<TPhaseModel>): TList<TProductionOrderModel>;
    function PopulateTotalPartials(ACellId: integer): TList<TPartialModel>;

    function GetPhaseList(ACellId: integer): TList<TPhaseModel>;
    procedure WorkHoursSum(AProductionOrders: TList<TProductionOrderModel>);

    function GetQueryExecutor: TQueryExecutor;
    property QueryExecutor: TQueryExecutor read GetQueryExecutor write FQueryExecutor;

    function GetQueryUtilityHandler: TQueryUtilityHandler;
    property QueryUtilityHandler: TQueryUtilityHandler read GetQueryUtilityHandler write FQueryUtilityHandler;

  public
  {Public declarations}
    function PopulateCellModel(ACellId: integer): TCellDataModel;
    function GetCellsList: TList<integer>;
  end;

implementation

{ TQueryHandler }
uses
  PredictiveMaintenanceRT.Constants, System.SysUtils, PredictiveMaintenanceRT.Messages;

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

function TQueryHandler.GetPhaseList(ACellId: integer): TList<TPhaseModel>;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_PHASES ,[IntToStr(ACellId)]));
    if LQuery <> nil then
      Result := QueryUtilityHandler.QueryToPhaseList(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
  finally
    LQuery.Free;
  end;
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

    Result.MaintenanceData := PopulateMaintenanceData(ACellId);

    Result.Partials := PopulatePartials(ACellId, Result.MaintenanceData[0].LastMaintenance);

    Result.TotalPartials := PopulateTotalPartials(ACellId);

    Result.ProductionOrders := PopulateProductionOrders(GetPhaseList(ACellId));

    WorkHoursSum(Result.ProductionOrders);
  except
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TQueryHandler.PopulateMaintenanceData(
  ACellId: integer): TList<TMaintenanceModel>;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_MAINTENANCE ,[IntToStr(ACellId)]));
    if LQuery <> nil then
      Result := QueryUtilityHandler.QueryToMaintenanceData(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
  finally
    LQuery.Free;
  end;
end;

function TQueryHandler.PopulatePartials(ACellId: integer; ALastMaintenance: Extended): TList<TPartialModel>;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_PARTIALS, [intToStr(ACellId), FloatToStr(ALastMaintenance)]));
    if LQuery <> nil then
      Result := QueryUtilityHandler.QueryToList(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
  finally
    LQuery.Free;
  end;

end;

function TQueryHandler.PopulateProductionOrders(
  APhases: TList<TPhaseModel>): TList<TProductionOrderModel>;
var
  LPhase: TPhaseModel;
  LProductionOrder: TProductionOrderModel;
begin
  Result := TList<TProductionOrderModel>.Create;
  try
  LProductionOrder := TProductionOrderModel.Create;

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

function TQueryHandler.PopulateTotalPartials(
  ACellId: integer): TList<TPartialModel>;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_TOTAL_PARTIALS, [intToStr(ACellId)]));
    if LQuery <> nil then
      Result := QueryUtilityHandler.QueryToList(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
  finally
    LQuery.Free;
  end;

end;

procedure TQueryHandler.WorkHoursSum(AProductionOrders: TList<TProductionOrderModel>);
var
  LProductionOrder: TProductionOrderModel;
  LPhase: TPhaseModel;
begin
  for LProductionOrder in AProductionOrders do
  begin
    for LPhase in LProductionOrder.Phases do
    begin
      LProductionOrder.WorkHours := LProductionOrder.WorkHours + LPhase.WorkTime;
    end;
  end;
end;

end.
