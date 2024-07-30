unit PredictiveMaintenanceRT.QueryHandler;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel, Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.QueryExecutor, PredictiveMaintenanceRT.MaintenanceModel, PredictiveMaintenanceRT.ProductionOrderModel;

type
  TQueryHandler = class

  private
  {Private declarations}
    FQueryExecutor: TQueryExecutor;

    function QueryToList(AQuery : TADOQuery): TList<TPartialModel>;
    function QueryToMaintenanceData(AQuery: TADOQuery): TList<TMaintenanceModel>;
    function QueryToListProductionOrder(AQuery: TADOQuery): TList<TProductionOrderModel>;

    function PopulatePartials(ACellId: integer; ALastMaintenance: Extended): TList<TPartialModel>;
    function PopulateMaintenanceData(ACellId: integer): TList<TMaintenanceModel>;
    function PopulateProductionOrders(ACellId: integer): TList<TProductionOrderModel>;

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

    Result.ProductionOrders := PopulateProductionOrders(ACellId);
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
  ACellId: integer): TList<TProductionOrderModel>;
var
  LQuery: TADOQuery;
begin
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_PRODUCTION_ORDERS, [intToStr(ACellId)]));
    if LQuery <> nil then
      Result := QueryToListProductionOrder(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
  finally
    LQuery.Free;
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

function TQueryHandler.QueryToListProductionOrder(
  AQuery: TADOQuery): TList<TProductionOrderModel>;
var
  LProductionOrder: TProductionOrderModel;
begin
  Result := TList<TProductionOrderModel>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LProductionOrder := TProductionOrderModel.Create;
      LProductionOrder.POID := AQuery.FieldByName(PO_ID).AsInteger;
      LProductionOrder.Pieces := AQuery.FieldByName(PO_PIECES).AsFloat;
      LProductionOrder.WorkHours := AQuery.FieldByName(PO_WORKHOURS).AsFloat;
      Result.Add(LProductionOrder);
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

end.




