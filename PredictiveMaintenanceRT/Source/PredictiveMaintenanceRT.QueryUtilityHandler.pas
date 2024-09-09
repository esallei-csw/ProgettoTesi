unit PredictiveMaintenanceRT.QueryUtilityHandler;

interface

uses
  Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.PartialModel, PredictiveMaintenanceRT.MaintenanceModel,
  PredictiveMaintenanceRT.PhaseModel, PredictiveMaintenanceRT.ProductionOrderModel,
  PredictiveMaintenanceRT.ClosedPeriodModel, PredictiveMaintenanceRT.MachineStopModel,
  PredictiveMaintenanceRT.CalendarModel;

type TQueryUtilityHandler = class

  private
  {Private declarations}

  public
  {Public declarations}

    function QueryToPartialsList(AQuery : TADOQuery): TObjectList<TPartialModel>;
    function QueryToMaintenanceData(AQuery: TADOQuery): TObjectList<TMaintenanceModel>;
    function QueryToPhaseList(AQuery: TADOQuery): TObjectList<TPhaseModel>;
    function QueryToCellsList(AQuery:TADOQuery): TList<integer>;
    function QueryToClosedPeriods(AQuery:TADOQuery): TObjectList<TClosedPeriodModel>;
    function QueryToMachineStops(AQuery:TADOQuery): TObjectList<TMachineStopModel>;
    function QueryToCalendars(AQuery:TADOQuery): TObjectList<TCalendarModel>;
    procedure WorkHoursSum(AProductionOrders: TObjectList<TProductionOrderModel>);
end;

implementation

uses
  PredictiveMaintenanceRT.Constants, System.SysUtils, PredictiveMaintenanceRT.Messages;

{ TQueryUtilityHandler }

function TQueryUtilityHandler.QueryToCalendars(
  AQuery: TADOQuery): TObjectList<TCalendarModel>;
var
  LDay: TCalendarModel;
begin
  Result := TObjectList<TCalendarModel>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;

    while not AQuery.Eof do
    begin
      LDay := TCalendarModel.Create;
      LDay.IDCalendar := AQuery.FieldByName(CALENDAR_ID).AsInteger;
      LDay.StartDay := AQuery.FieldByName(CALENDAR_STARTDAY).AsFloat;

      Result.Add(LDay);
      AQuery.Next;
    end;
  except
    begin
      Result.Free;
      raise;
    end;
  end;
end;

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
      LCellId := AQuery.FieldByName(IDCELPRO).AsInteger;
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

function TQueryUtilityHandler.QueryToPartialsList(
  AQuery: TADOQuery): TObjectList<TPartialModel>;
var
  LPartial: TPartialModel;
begin
  Result := TObjectList<TPartialModel>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LPartial := TPartialModel.Create;
      LPartial.PartialId := AQuery.FieldByName(ID).AsInteger;
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

function TQueryUtilityHandler.QueryToClosedPeriods(
  AQuery: TADOQuery): TObjectList<TClosedPeriodModel>;
var
  LPeriod: TClosedPeriodModel;
begin
  Result := TObjectList<TClosedPeriodModel>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LPeriod := TClosedPeriodModel.Create;
      LPeriod.ID := AQuery.FieldByName(ID).AsInteger;
      LPeriod.IDCell := AQuery.FieldByName(IDCELPRO).AsInteger;
      LPeriod.DataInizio := AQuery.FieldByName(CPERIOD_DATAINI).AsFloat;
      LPeriod.DataFine := AQuery.FieldByName(CPERIOD_DATAFIN).AsFloat;
      LPeriod.Tipo := AQuery.FieldByName(CPERIOD_TIPO).AsString;
      LPeriod.Duration := AQuery.FieldByName(CPERIOD_DURATION).AsInteger;
      Result.Add(LPeriod);
      AQuery.Next;
    end;
  except
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TQueryUtilityHandler.QueryToMachineStops(
  AQuery: TADOQuery): TObjectList<TMachineStopModel>;
var
  LMachineStop: TMachineStopModel;
begin
  Result := TObjectList<TMachineStopModel>.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LMachineStop := TMachineStopModel.Create;
      LMachineStop.ID := AQuery.FieldByName(ID).AsInteger;
      LMachineStop.IDCell := AQuery.FieldByName(IDCELPRO).AsInteger;
      LMachineStop.DataInizio := AQuery.FieldByName(STOPS_DATAIN).AsFloat;
      LMachineStop.DataFine := AQuery.FieldByName(STOPS_DATAFIN).AsFloat;
      LMachineStop.OraInizio := AQuery.FieldByName(STOPS_ORAIN).AsFloat;
      LMachineStop.OraFine := AQuery.FieldByName(STOPS_ORAFIN).AsFloat;
      LMachineStop.Durata := AQuery.FieldByName(STOPS_DURATA).AsFloat;
      Result.Add(LMachineStop);
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
  AQuery: TADOQuery): TObjectList<TMaintenanceModel>;
var
  LMaintenanceData: TMaintenanceModel;
begin
  Result := TObjectList<TMaintenanceModel>.Create;
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
  AQuery: TADOQuery): TObjectList<TPhaseModel>;
var
  LPhase: TPhaseModel;
begin
  Result := TObjectList<TPhaseModel>.Create();
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


procedure TQueryUtilityHandler.WorkHoursSum(
  AProductionOrders: TObjectList<TProductionOrderModel>);
var
  LProductionOrder: TProductionOrderModel;
  LPhase: TPhaseModel;
begin
  if ( AProductionOrders = nil )  then
    Exit;

  for LProductionOrder in AProductionOrders do
  begin
    for LPhase in LProductionOrder.Phases do
    begin
      LProductionOrder.WorkHours := LProductionOrder.WorkHours + LPhase.WorkTime;
    end;
  end;
end;
end.
