unit PredictiveMaintenanceRT.PredictiveAlgorithm;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel,
  PredictiveMaintenanceRT.MaintenanceModel, System.Generics.Collections, PredictiveMaintenanceRT.WorkHoursCalculator,
  PredictiveMaintenanceRT.ProductionOrderModel, PredictiveMaintenanceRT.ResultModel;

type
  TPredictiveAlgorithm = class

  private
  {Private declarations}
    FUsePastData: boolean;
    FWorkHoursCalculator: TWorkHoursCalculator;

    //Partials utility functions
    function GetTotalPiecesMade(APartials: TList<TPartialModel>): Double;
    function GetTotalTimeWorked(APartials: TList<TPartialModel>): Double;
    function GetMedianHoursPerPiece(APartials: TList<TPartialModel>; AIDArtico: integer): Double;

    //Calc Date functions
    function CalcDatePieces(AThreshold, ATotalThreshold: Double; ACell: TCellDataModel): TResultModel;
    function CalcDateTime(AThreshold, ATotalThreshold: Double; ACell: TCellDataModel): TResultModel;
    function CalcDateDays(AThreshold: Double; ACell: TCellDataModel): TResultModel;

    //Threshold functions
    function GetDaysToMaintenance(AMaintenanceData: TMaintenanceModel): Double;
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
begin
  Result := TResultModel.Create;
  Result.WarningList.Add(TIME_CALC);
  Result.MaintenanceDate := now;
  LPOIter := 0;
  LProductionOrderList := ACell.ProductionOrders;
  LTotPerc := ATotalThreshold;
  LCountPerc := ATotalThreshold - AThreshold;

  LWorkHours := LProductionOrderList[LPOIter].WorkHours;
  while true do
  begin
    AThreshold := AThreshold - WorkHoursCalculator.GetWorkHours(Result.MaintenanceDate);
    LWorkHours := LWorkHours - WorkHoursCalculator.GetWorkHours(Result.MaintenanceDate);
    LCountPerc := LCountPerc + WorkHoursCalculator.GetWorkHours(Result.MaintenanceDate);

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

function TPredictiveAlgorithm.CalcDateDays(AThreshold: Double; ACell: TCellDataModel): TResultModel;
begin
  Result := TResultModel.Create;
  Result.WarningList.Add(DAYS_CALC);
  Result.MaintenanceDate := now + AThreshold;
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
begin
  Result := TResultModel.Create;
  Result.WarningList.Add(PIECES_CALC);
  Result.MaintenanceDate:= now;
  LPOIter := 0;
  LProductionOrderList := ACell.ProductionOrders;
  LTotPerc := ATotalThreshold;
  LCountPerc := ATotalThreshold - AThreshold;
  LPiecesADay := 0;
  LPiecesAnHour := 0;

  Lquantity := LProductionOrderList[LPOIter].Phases[0].Quantity;
  while true do
  begin
    LWorkHours := LProductionOrderList[LPOIter].WorkHours;
    if (LWorkHours = 0) and (UsePastData) then
    begin
      LWorkHours := (LProductionOrderList[LPOIter].Pieces * GetMedianHoursPerPiece(ACell.TotalPartials, LProductionOrderList[LPOIter].Phases[0].ArticleID));
      Result.WarningList.Add(USED_PAST_DATA + IntToStr(LProductionOrderList[LPOIter].POID));
      if LWorkHours <> 0 then
        Result.WarningList.Add('PastData actually used for PO n�' + IntToStr(LProductionOrderList[LPOIter].POID));
    end;

    if LWorkHours = 0 then
    begin
      LPiecesAnHour := 0;
      LPOIter := LPOIter + 1;
    end
    else
      LPiecesAnHour := LProductionOrderList[LPOIter].Phases[0].Quantity / LWorkHours;

    LPiecesADay := WorkHoursCalculator.GetWorkHours(Result.MaintenanceDate) * LPiecesAnHour;
    AThreshold := AThreshold - LPiecesADay;
    LQuantity := LQuantity - LPiecesADay;
    LCountPerc := LCountPerc + LPiecesADay;


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
  LDaysToMaintenance: Double;
  LPiecesToMaintenance: Double;
  LTimeToMaintenance: Double;
  LResultPieces: TResultModel;
  LResultTime: TResultModel;
  LResult: TResultModel;
begin
  Result := TList<TResultModel>.Create;

  for LMaintenanceData in ACell.MaintenanceData do
  begin
    LDaysToMaintenance := GetDaysToMaintenance(LMaintenanceData);

    //calcolo per trovare la data in basa alla soglia Giorni/Mesi
    if LDaysToMaintenance <= 0 then
    begin
      LPiecesToMaintenance := GetPiecesToMaintenance(ACell.Partials, LMaintenanceData);
      LTimeToMaintenance := GetTimeToMaintenance(ACell.Partials, LMaintenanceData);
      LResultPieces := CalcDatePieces(LPiecesToMaintenance, LMaintenanceData.ThresholdPieces, ACell);
      LResultTime := CalcDateTime(LTimeToMaintenance, LMaintenanceData.ThresholdHoursWorked, ACell);
      if LResultPieces.MaintenanceDate < LResultTime.MaintenanceDate then
        Result.Add(LResultPieces)
      else
        Result.Add(LResultTime);
    end
    else
      Result.Add(CalcDateDays(LDaysToMaintenance, ACell));

    Result[Result.Count - 1].Description := LMaintenanceData.Description;
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
begin
  //calcolo i pezzi totali fatti prendendoli dai parziali di una cella di lavoro
  LTotalPiecesMade := GetTotalPiecesMade(APartials);
  //calcolo i pezzi che mancano fino alla prossima manutenzione
  Result := AMaintenanceData.ThresholdPieces - LTotalPiecesMade;
end;

function TPredictiveAlgorithm.GetDaysToMaintenance(
  AMaintenanceData: TMaintenanceModel): Double;
var
  LTimeFromLastMaintenance: Double;
  LThresholdDays: Double;
begin
  //queta funzione deve ritornare la data calcolandola in base alle soglie di tempo(Giorni e mesi)
  //Calcolare prima di tutto il tempo passato dall ultima manutenzione
  LTimeFromLastMaintenance := now - AMaintenanceData.LastMaintenance;

  //convertire i mesi e giorni in giorni
  LThresholdDays := AMaintenanceData.ThresholdDays + (AMaintenanceData.ThresholdMonths * DAYS_IN_A_MONTH);

  //sottrarre dal tempo soglia il tempo dall ultima manutenzione
  Result := LThresholdDays - LTimeFromLastMaintenance;
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

function TPredictiveAlgorithm.GetTimeToMaintenance(
  APartials: TList<TPartialModel>; AMaintenanceData: TMaintenanceModel): Double;
var
  LTotalTimeWorked: Double;
begin
  //calcolo i pezzi totali fatti prendendoli dai parziali di una cella di lavoro
  LTotalTimeWorked := GetTotalTimeWorked(APartials);
  //calcolo i pezzi che mancano fino alla prossima manutenzione
  Result := AMaintenanceData.ThresholdHoursWorked - LTotalTimeWorked;
end;

function TPredictiveAlgorithm.GetTotalPiecesMade(
  APartials: TList<TPartialModel>): Double;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to APartials.Count - 1 do
  begin
    Result := Result + APartials.Items[I].Quantity;
  end;
end;

function TPredictiveAlgorithm.GetTotalTimeWorked(
  APartials: TList<TPartialModel>): Double;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to APartials.Count - 1 do
  begin
    Result := Result + APartials.Items[I].WorkHours;
  end;
end;

function TPredictiveAlgorithm.GetWorkHoursCalculator: TWorkHoursCalculator;
begin
  if not Assigned(FWorkHoursCalculator) then
    FWorkHoursCalculator := TWorkHoursCalculator.Create;
  Result := FWorkHoursCalculator;
end;

end.
