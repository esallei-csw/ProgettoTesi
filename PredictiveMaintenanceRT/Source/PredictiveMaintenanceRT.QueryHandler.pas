unit PredictiveMaintenanceRT.QueryHandler;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel, Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.QueryExecutor, PredictiveMaintenanceRT.MaintenanceModel, PredictiveMaintenanceRT.ProductionOrderModel,
  PredictiveMaintenanceRT.PhaseModel;

type
  TQueryHandler = class

  private
  {Private declarations}
    FQueryExecutor: TQueryExecutor;

    function QueryToList(AQuery : TADOQuery): TList<TPartialModel>;
    function QueryToMaintenanceData(AQuery: TADOQuery): TList<TMaintenanceModel>;
    function QueryToPhaseList(AQuery: TADOQuery): TList<TPhaseModel>;

    function PopulatePartials(ACellId: integer; ALastMaintenance: Extended): TList<TPartialModel>;
    function PopulateMaintenanceData(ACellId: integer): TList<TMaintenanceModel>;
    function PopulateProductionOrders(APhases: TList<TPhaseModel>): TList<TProductionOrderModel>;

    function GetPhaseList(ACellId: integer): TList<TPhaseModel>;
    procedure WorkHoursSum(AProductionOrders: TList<TProductionOrderModel>);

    function GetQueryExecutor: TQueryExecutor;
    property QueryExecutor: TQueryExecutor read GetQueryExecutor write FQueryExecutor;

  public
  {Public declarations}
    function PopulateCellModel(ACellId: integer): TCellDataModel;
  end;

implementation

{ TQueryHandler }
uses
  PredictiveMaintenanceRT.Constants, System.SysUtils, PredictiveMaintenanceRT.Messages;

function TQueryHandler.GetPhaseList(ACellId: integer): TList<TPhaseModel>;
var
  LQuery: TADOQuery;
begin
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_PHASES ,[IntToStr(ACellId)]));
    if LQuery <> nil then
      Result := QueryToPhaseList(LQuery)
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

function TQueryHandler.PopulateCellModel(ACellId: integer): TCellDataModel;
begin
  Result := TCellDataModel.Create;
  try
    Result.CellId := ACellId;

    Result.MaintenanceData := PopulateMaintenanceData(ACellId);

    Result.Partials := PopulatePartials(ACellId, Result.MaintenanceData[0].LastMaintenance);

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
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_MAINTENANCE ,[IntToStr(ACellId)]));
    if LQuery <> nil then
      Result := QueryToMaintenanceData(LQuery)
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
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_PARTIALS, [intToStr(ACellId), FloatToStr(ALastMaintenance)]));
    if LQuery <> nil then
      Result := QueryToList(LQuery)
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

function TQueryHandler.QueryToList(AQuery: TADOQuery): TList<TPartialModel>;
var
  LPartial: TPartialModel;
begin
  Result := TList<TPartialModel>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LPartial := TPartialModel.Create;
      LPartial.PartialId := AQuery.FieldByName(PARTIAL_ID).AsInteger;
      LPartial.StartTime := AQuery.FieldByName(PARTIAL_START).AsFloat;
      LPartial.WorkHours := AQuery.FieldByName(PARTIAL_WORKHOURS).AsFloat;
      LPartial.EndTime := AQuery.FieldByName(PARTIAL_END).AsFloat;
      LPartial.Quantity := AQuery.FieldByName(PARTIAL_QUANTITY).AsFloat;
      LPartial.IDArtico := AQuery.FieldByName(PARTIAL_IDARTICO).AsInteger;
      Result.Add(LPartial);
      AQuery.Next;
    end;
  except
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TQueryHandler.QueryToMaintenanceData(
  AQuery: TADOQuery): TList<TMaintenanceModel>;
var
  LMaintenanceData: TMaintenanceModel;
begin
  Result := TList<TMaintenanceModel>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LMaintenanceData := TMaintenanceModel.Create;
      LMaintenanceData.LastMaintenance := AQuery.FieldByName(ULTMAN).AsFloat;
      LMaintenanceData.ThresholdPieces := AQuery.FieldByName(MAINTENANCE_QTA).AsInteger;
      LMaintenanceData.ThresholdHoursWorked := AQuery.FieldByName(MAINTENANCE_HOURS).AsFloat;
      LMaintenanceData.ThresholdDays := AQuery.FieldByName(GIORNI).AsInteger;
      LMaintenanceData.ThresholdMonths := AQuery.FieldByName(MESI).AsInteger;
      Result.Add(LMaintenanceData);
      AQuery.Next;
    end;
  except
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TQueryHandler.QueryToPhaseList(AQuery: TADOQuery): TList<TPhaseModel>;
var
  LPhase: TPhaseModel;
begin
  Result := TList<TPhaseModel>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LPhase := TPhaseModel.Create;
      LPhase.POID := AQuery.FieldByName(PO_ID).AsInteger;
      LPhase.PhaseID := AQuery.FieldByName(PHASE_ID).AsInteger;
      LPhase.ArticleID := AQuery.FieldByName(ARTICO_ID).AsInteger;
      LPhase.WorkTime := AQuery.FieldByName(PHASE_WORKTIME).AsFloat;
      LPhase.Quantity := AQuery.FieldByName(PO_PIECES).AsFloat;
      Result.Add(LPhase);
      AQuery.Next;
    end;
  except
    begin
      Result.Free;
      raise;
    end;
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




