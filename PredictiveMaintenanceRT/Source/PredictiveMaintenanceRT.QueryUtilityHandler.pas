unit PredictiveMaintenanceRT.QueryUtilityHandler;

interface

uses
  Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.PartialModel, PredictiveMaintenanceRT.MaintenanceModel,
  PredictiveMaintenanceRT.PhaseModel;

type TQueryUtilityHandler = class

  private
  {Private declarations}

  public
  {Public declarations}

    function QueryToList(AQuery : TADOQuery): TList<TPartialModel>;
    function QueryToMaintenanceData(AQuery: TADOQuery): TList<TMaintenanceModel>;
    function QueryToPhaseList(AQuery: TADOQuery): TList<TPhaseModel>;
    function QueryToCellsList(AQuery:TADOQuery): TList<integer>;
end;

implementation

uses
  PredictiveMaintenanceRT.Constants, System.SysUtils, PredictiveMaintenanceRT.Messages;

{ TQueryUtilityHandler }

function TQueryUtilityHandler.QueryToCellsList(
  AQuery: TADOQuery): TList<integer>;
var
  LCellId: integer;
begin
  Result := TList<integer>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LCellId := AQuery.FieldByName('IDCELPRO').AsInteger;
      Result.Add(LCellId);
      AQuery.Next;
    end;
  except
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TQueryUtilityHandler.QueryToList(
  AQuery: TADOQuery): TList<TPartialModel>;
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

function TQueryUtilityHandler.QueryToMaintenanceData(
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
      LMaintenanceData.Description := AQuery.FieldByName(MAINTENANCE_DESCR).AsString;
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

function TQueryUtilityHandler.QueryToPhaseList(
  AQuery: TADOQuery): TList<TPhaseModel>;
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

end.
