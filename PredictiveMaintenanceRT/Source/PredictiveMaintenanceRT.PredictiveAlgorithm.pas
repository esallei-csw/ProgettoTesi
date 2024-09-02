unit PredictiveMaintenanceRT.PredictiveAlgorithm;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel,
  PredictiveMaintenanceRT.MaintenanceModel, System.Generics.Collections, PredictiveMaintenanceRT.WorkHoursCalculator,
  PredictiveMaintenanceRT.ProductionOrderModel, PredictiveMaintenanceRT.ResultModel,
  PredictiveMaintenanceRT.ClosedPeriodModel, PredictiveMaintenanceRT.MachineStopModel;

type
  TPredictiveAlgorithm = class

  private
  {Private declarations}
    FIDCell: integer;
    FUsePastData: boolean;
    FWorkHoursCalculator: TWorkHoursCalculator;

    //Utility functions
    function GetMedianHoursPerPiece(APartials: TList<TPartialModel>; AIDArtico: integer): Double;
    function GetMedianDailyMachineStops(AMachineStops: TList<TMachineStopModel>): Double;
    function CalcMaintenancePT(AMaintenanceData: TMaintenanceModel; Acell: TCellDataModel): TResultModel;

    //Calc Date functions
    function CalcDatePieces(AThreshold, ATotalThreshold: Double; ACell: TCellDataModel): TResultModel;
    function CalcDateTime(AThreshold, ATotalThreshold: Double; ACell: TCellDataModel): TResultModel;
    function CalcDateDays(AIndex: integer; ACell: TCellDataModel): TResultModel;

    //Threshold functions
    function GetPiecesToMaintenance(APartials: TList<TPartialModel>; AMaintenanceData: TMaintenanceModel): Double;
    function GetTimeToMaintenance(APartials: TList<TPartialModel>; AMaintenanceData: TMaintenanceModel): Double;

    function GetWorkHoursCalculator: TWorkHoursCalculator;
    property WorkHoursCalculator: TWorkHoursCalculator read GetWorkHoursCalculator write FWorkHoursCalculator;

  public
  {Public declarations}
    constructor Create;
    destructor Destroy; override;
    function CalculateMaintenanceDate(ACell: TCellDataModel): TList<TResultModel>;
    property UsePastData: boolean read FUsePastData write FUsePastData;
  end;

implementation

uses
  PredictiveMaintenanceRT.Constants, PredictiveMaintenanceRT.Messages, System.SysUtils, System.Math, system.Variants;

{ TPredictiveAlgorithm }

function TPredictiveAlgorithm.CalcDateTime(AThreshold, ATotalThreshold: Double; ACell: TCellDataModel): TResultModel;
var
  LPOIter: integer;
  LProductionOrderList: TList<TProductionOrderModel>;
  LWorkHours: Double;
  LTotPerc: Double;
  LCountPerc: Double;
  LRealWorkHours: Double;
begin
  Result := TResultModel.Create;
  Result.MaintenanceDate := now;
  LPOIter := 0;
  LProductionOrderList := ACell.ProductionOrders;
  LTotPerc := ATotalThreshold;
  LCountPerc := ATotalThreshold - AThreshold;

  Result.WarningList.Add(TIME_CALC);
  LWorkHours := LProductionOrderList[LPOIter].WorkHours;
  while true do
  begin
    //Daily Work Hours Calc
    LRealWorkHours := WorkHoursCalculator.GetWorkHours(Result.MaintenanceDate);
    if LRealWorkHours > 0 then
      LRealWorkHours := LRealWorkHours - GetMedianDailyMachineStops(ACell.MachineStops);
    AThreshold := AThreshold - LRealWorkHours;
    LWorkHours := LWorkHours - LRealWorkHours;
    LCountPerc := LCountPerc + LRealWorkHours;

    //Threshold Check
    if AThreshold <= 0 then
    begin
      Result.Percent := (LCountPerc * 100) / LTotPerc;
      exit;
    end;
    if LWorkHours <= 0 then
    begin
      if LPOIter = LProductionOrderList.Count - 1 then
      begin
        Result.WarningList.Add(NOT_ENOUGH_PO);
        Result.Percent := (100 * LCountPerc) / LTotPerc;
        exit;
      end;
      LPOIter := LPOIter + 1;
      LWorkHours := LProductionOrderList[LPOIter].WorkHours;

    end;
    if not Assigned(LProductionOrderList[LPOIter]) then
      raise Exception.Create(FINISHED_PO);

    Result.MaintenanceDate := Result.MaintenanceDate + 1;
  end;
end;

function TPredictiveAlgorithm.CalcDateDays(AIndex: integer; ACell: TCellDataModel): TResultModel;
begin
  Result := TResultModel.Create;
  Result.WarningList.Add(DAYS_CALC);
  //Increment Months
  Result.MaintenanceDate := IncMonth(ACell.MaintenanceData[AIndex].LastMaintenance, ACell.MaintenanceData[AIndex].ThresholdMonths);
  //Increment Days
  Result.MaintenanceDate := Result.MaintenanceDate + ACell.MaintenanceData[AIndex].ThresholdDays;
  Result.Percent := 100;
end;

function TPredictiveAlgorithm.CalcDatePieces(AThreshold, ATotalThreshold: Double; ACell: TCellDataModel): TResultModel;
var
  LPOIter: integer;
  LProductionOrderList: TList<TProductionOrderModel>;
  LPiecesADay: Double;
  LPiecesAnHour: Double;
  LQuantity: Double;
  LWorkHours: Double;
  LTotPerc: Double;
  LCountPerc: Double;
  LRealWorkHours: Double;
begin
  Result := TResultModel.Create;
  Result.MaintenanceDate:= now;
  LPOIter := 0;
  LProductionOrderList := ACell.ProductionOrders;
  LTotPerc := ATotalThreshold;
  LCountPerc := ATotalThreshold - AThreshold;
  LPiecesADay := 0;
  LPiecesAnHour := 0;

  Result.WarningList.Add(PIECES_CALC);
  Lquantity := LProductionOrderList[LPOIter].Phases[0].Quantity;
  while true do
  begin
    LWorkHours := LProductionOrderList[LPOIter].WorkHours;
    //Past Data Calc
    if (LWorkHours = 0) and (UsePastData) then
    begin
      LWorkHours := (LProductionOrderList[LPOIter].Pieces * GetMedianHoursPerPiece(ACell.TotalPartials, LProductionOrderList[LPOIter].Phases[0].ArticleID));
      if LWorkHours <> 0 then
        Result.WarningList.Add(USED_PAST_DATA + IntToStr(LProductionOrderList[LPOIter].POID));
    end;
    //se il tempo di lavoro è sempre uguale a 0 skip
    if LWorkHours = 0 then
    begin
      LPiecesAnHour := 0;
      LPOIter := LPOIter + 1;
    end
    else
      LPiecesAnHour := LProductionOrderList[LPOIter].Phases[0].Quantity / LWorkHours;
    //Daily Work Hours Calc
    LRealWorkHours := WorkHoursCalculator.GetWorkHours(Result.MaintenanceDate);
    if LRealWorkHours > 0 then
      LRealWorkHours := LRealWorkHours - GetMedianDailyMachineStops(ACell.MachineStops);

    LPiecesADay := LRealWorkHours * LPiecesAnHour;
    AThreshold := AThreshold - LPiecesADay;
    LQuantity := LQuantity - LPiecesADay;
    LCountPerc := LCountPerc + LPiecesADay;
    //Threshold Checks
    if AThreshold <= 0 then
    begin
      Result.Percent := (LCountPerc * 100) / LTotPerc;
      exit;
    end;
    if LQuantity <= 0 then
    begin
      if LPOIter = LProductionOrderList.Count - 1 then
      begin
        Result.WarningList.Add(NOT_ENOUGH_PO);
        Result.Percent := (LCountPerc * 100) / LTotPerc;
        exit;
      end;
      LPOIter := LPOIter + 1;
      LQuantity := LProductionOrderList[LPOIter].Phases[0].Quantity;

    end;
    Result.MaintenanceDate := Result.MaintenanceDate + 1;
  end;
end;

function TPredictiveAlgorithm.CalculateMaintenanceDate(ACell: TCellDataModel): TList<TResultModel>;
var
  LMaintenanceData: TMaintenanceModel;
  LResult: TResultModel;
  LIndex: integer;
begin
  if ACell = nil then
    raise Exception.Create(CELL_DATA_NIL);
  LIndex := 0;
  Result := TList<TResultModel>.Create;
  FIDCell := ACell.CellId;

  for LMaintenanceData in ACell.MaintenanceData do
  begin
    if LMaintenanceData.LastMaintenance = 0 then
    begin
      LResult := TResultModel.Create;
      LResult.Description := LMaintenanceData.Description;
      LResult.WarningList.Add(MAN_STRA);
      Result.Add(LResult);
    end
    else
    begin
      if (LMaintenanceData.ThresholdDays = 0) and (LMaintenanceData.ThresholdMonths = 0) then
      begin
        Result.Add(CalcMaintenancePT(LMaintenanceData, ACell));
      end
      else
        Result.Add(CalcDateDays(LIndex, ACell));
      Result[LIndex].Description := LMaintenanceData.Description;
      Result[LIndex].CellID := FIDCell;
      if Result[LIndex].MaintenanceDate < now then
        Result[LIndex].WarningList.Add(MAINTENANCE_TODO_MSG);
    end;
    LIndex := LIndex + 1;
  end;
end;

function TPredictiveAlgorithm.CalcMaintenancePT(
  AMaintenanceData: TMaintenanceModel; Acell: TCellDataModel): TResultModel;
var
  LPiecesToMaintenance: Double;
  LTimeToMaintenance: Double;
  LResultPieces: TResultModel;
  LResultTime: TResultModel;
begin
  LPiecesToMaintenance := GetPiecesToMaintenance(ACell.TotalPartials, AMaintenanceData);

  LTimeToMaintenance := GetTimeToMaintenance(ACell.TotalPartials, AMaintenanceData);

  LResultPieces := CalcDatePieces(LPiecesToMaintenance, AMaintenanceData.ThresholdPieces, ACell);

  LResultTime := CalcDateTime(LTimeToMaintenance, AMaintenanceData.ThresholdHoursWorked, ACell);

  if LResultPieces.MaintenanceDate < LResultTime.MaintenanceDate then
  begin
    Result := LResultPieces;
    LResultTime.Free;
  end
  else
  begin
    Result := LResultTime;
    LResultPieces.Free;
  end;
end;

constructor TPredictiveAlgorithm.Create;
begin
  FUsePastData := false;
end;

destructor TPredictiveAlgorithm.Destroy;
begin
  if Assigned(FWorkHoursCalculator) then
    FWorkHoursCalculator.Free;
  inherited;
end;

function TPredictiveAlgorithm.GetPiecesToMaintenance(APartials: TList<TPartialModel>;
  AMaintenanceData: TMaintenanceModel): Double;
var
  LTotalPiecesMade: Double;
  I: Integer;
begin
  LTotalPiecesMade := 0;
  //calcolo i pezzi totali fatti prendendoli dai parziali di una cella di lavoro
  for I := 0 to APartials.Count - 1 do
  begin
    if APartials[I].StartTime >= AMaintenanceData.LastMaintenance then
      LTotalPiecesMade := LTotalPiecesMade + APartials[I].Quantity;
  end;

  //calcolo i pezzi che mancano fino alla prossima manutenzione
  Result := AMaintenanceData.ThresholdPieces - LTotalPiecesMade;
end;

function TPredictiveAlgorithm.GetMedianHoursPerPiece(
  APartials: TList<TPartialModel>; AIDArtico: integer): Double;
var
  LPartial: TPartialModel;
  LCount: integer;
begin
  Result := varEmpty;
  LCount := varEmpty;

  for LPartial in APartials do
  begin
    if LPartial.IDArtico = AIDArtico then
    begin
      if LPartial.Quantity <> 0 then
      begin
        Result := Result + (LPartial.WorkHours / LPartial.Quantity);
        LCount := LCount + 1;
      end;
    end;
  end;
  if LCount = 0 then
    Result := 0
  else
    Result := Result / LCount;
end;

function TPredictiveAlgorithm.GetMedianDailyMachineStops(
  AMachineStops: TList<TMachineStopModel>): Double;
var
  LMachineStop: TMachineStopModel;
  LDays: Double;
  LStopsVal: Double;
  LDaysCount: Double;
begin
  LStopsVal := 0;
  LDaysCount := 0;
  if AMachineStops.count = 0 then
    Exit(0);
  for LMachineStop in AMachineStops do
  begin
    LDays := (LMachineStop.DataFine - LMachineStop.DataInizio) + 1;
    LDaysCount := LDaysCount + LDays;
    LStopsVal := LStopsVal + (LMachineStop.Durata / LDays);
  end;

  Result := LStopsVal / LDaysCount;
end;

function TPredictiveAlgorithm.GetTimeToMaintenance(
  APartials: TList<TPartialModel>; AMaintenanceData: TMaintenanceModel): Double;
var
  LTotalTimeWorked: Double;
  I: Integer;
begin
  LTotalTimeWorked := 0;
  //calcolo i pezzi totali fatti prendendoli dai parziali di una cella di lavoro
  for I := 0 to APartials.Count - 1 do
  begin
    if APartials[I].StartTime >= AMaintenanceData.LastMaintenance then
      LTotalTimeWorked := LTotalTimeWorked + APartials[I].Quantity;
  end;

  //calcolo i pezzi che mancano fino alla prossima manutenzione
  Result := AMaintenanceData.ThresholdHoursWorked - LTotalTimeWorked;
end;

function TPredictiveAlgorithm.GetWorkHoursCalculator: TWorkHoursCalculator;
begin
  if not Assigned(FWorkHoursCalculator) then
    FWorkHoursCalculator := TWorkHoursCalculator.Create(FIDCell);
  Result := FWorkHoursCalculator;
end;

end.
