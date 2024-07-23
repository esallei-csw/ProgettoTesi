unit PredictiveMaintenanceRT.QueryHandler;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel, Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.QueryExecutor, PredictiveMaintenanceRT.MaintenanceModel;

type
  TQueryHandler = class

  private
  {Private declarations}
    FQueryExecutor: TQueryExecutor;

    function QueryToList(AQuery : TADOQuery): TList<TPartialModel>;
    function QueryToMaintenanceData(AQuery: TADOQuery): TMaintenanceModel;
    function PopulatePartials(ACellId: integer; ALastMaintenance: Extended): TList<TPartialModel>;
    function PopulateMaintenanceData(ACellId: integer): TMaintenanceModel;

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
  Result.CellId := ACellId;

  Result.MaintenanceData := PopulateMaintenanceData(ACellId).Clone;

  Result.Partials := PopulatePartials(ACellId, Result.MaintenanceData.LastMaintenance);

end;

function TQueryHandler.PopulateMaintenanceData(
  ACellId: integer): TMaintenanceModel;
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
//  LPartials: TList<TPartialModel>;
begin
  try
    LQuery := QueryExecutor.ExecuteQuery(Format(QUERY_PARTIALS, [intToStr(ACellId), FloatToStr(ALastMaintenance)]));
    if LQuery <> nil then
      Result := QueryToList(LQuery)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
//    Result := LPartials;
  finally
//    LPartials.Free;
    LQuery.Free;
  end;

end;

function TQueryHandler.QueryToList(AQuery: TADOQuery): TList<TPartialModel>;
var
  LPartials: TList<TPartialModel>;
  LPartial: TPartialModel;
begin
  LPartials := TList<TPartialModel>.Create;
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
      LPartials.Add(LPartial);
      AQuery.Next;
    end;
  except
    on E: Exception do
    begin
      LPartials.Free;
      raise;
    end;
  end;
  Result := LPartials;
end;

function TQueryHandler.QueryToMaintenanceData(
  AQuery: TADOQuery): TMaintenanceModel;
var
  LMaintenanceData: TMaintenanceModel;
begin
  LMaintenanceData := TMaintenanceModel.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LMaintenanceData.LastMaintenance := AQuery.FieldByName(ULTMAN).AsFloat;
      if AQuery.FieldByName(MAINTENANCE_QTA).AsInteger <> 0 then
        LMaintenanceData.ThresholdPieces := AQuery.FieldByName(MAINTENANCE_QTA).AsInteger;
      if AQuery.FieldByName(MAINTENANCE_HOURS).AsFloat <> 0 then
        LMaintenanceData.ThresholdHoursWorked := AQuery.FieldByName(MAINTENANCE_HOURS).AsFloat;
      if AQuery.FieldByName(GIORNI).AsInteger <> 0 then
        LMaintenanceData.ThresholdDays := AQuery.FieldByName(GIORNI).AsInteger;
      if AQuery.FieldByName(MESI).AsInteger <> 0 then
        LMaintenanceData.ThresholdMonths := AQuery.FieldByName(MESI).AsInteger;
      AQuery.Next;
    end;
    Result := LMaintenanceData;
  finally
    LMaintenanceData.Free;
  end;
end;

end.
