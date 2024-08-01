unit PredictiveMaintenanceRT.PredictiveAlgorithm;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel,
  PredictiveMaintenanceRT.MaintenanceModel, System.Generics.Collections, PredictiveMaintenanceRT.WorkHoursCalculator,
  PredictiveMaintenanceRT.ProductionOrderModel;

type
  TPredictiveAlgorithm = class

  private
  {Private declarations}
    FWorkHoursCalculator: TWorkHoursCalculator;
    FDays: TList<Double>;

    //Partials utility functions
    function GetTotalPiecesMade(APartials: TList<TPartialModel>): Double;
    function GetTotalTimeWorked(APartials: TList<TPartialModel>): Double;
    function GetPiecesAnHour(APartials: TList<TPartialModel>): Double;
    function GetMedianHoursPerPiece(APartials: TList<TPartialModel>; AIDArtico: integer): Double;

    //Calc Date functions
    function CalcDatePieces(AThreshold: Double; ACell: TCellDataModel): Double;
    function CalcDateTime(AThreshold: Double; ACell: TCellDataModel): Double;
    function CalcDateDays(AThreshold: Double; ACell: TCellDataModel): Double;

    //Threshold functions
    function GetDaysToMaintenance(AMaintenanceData: TMaintenanceModel): Double;
    function GetPiecesToMaintenance(APartials: TList<TPartialModel>; AMaintenanceData: TMaintenanceModel): Double;
    function GetTimeToMaintenance(APartials: TList<TPartialModel>; AMaintenanceData: TMaintenanceModel): Double;

    function GetWorkHoursCalculator: TWorkHoursCalculator;
    property WorkHoursCalculator: TWorkHoursCalculator read GetWorkHoursCalculator write FWorkHoursCalculator;

  public
  {Public declarations}
  destructor Destroy; override;
    function CalculateMaintenanceDate(ACell: TCellDataModel): TList<Double>;
  end;

implementation

uses
  PredictiveMaintenanceRT.Constants, PredictiveMaintenanceRT.Messages, System.SysUtils, System.Math, system.Variants;

{ TPredictiveAlgorithm }

function TPredictiveAlgorithm.CalcDateTime(AThreshold: Double; ACell: TCellDataModel): Double;
var
  LPOIter: integer;
  LProductionOrderList: TList<TProductionOrderModel>;
  LWorkHours: Double;
begin
  Result := now;
  LPOIter := 0;
  LProductionOrderList := ACell.ProductionOrders;

  while true do
  begin
    LWorkHours := LProductionOrderList[LPOIter].WorkHours;
    AThreshold := AThreshold - WorkHoursCalculator.GetWorkHours(Result);
    LWorkHours := LWorkHours - WorkHoursCalculator.GetWorkHours(Result);

    if AThreshold <= 0 then
      exit;
    if LProductionOrderList[LPOIter].WorkHours <= 0 then
      LPOIter := LPOIter + 1;
    if not Assigned(LProductionOrderList[LPOIter]) then
      raise Exception.Create(FINISHED_PO);

    Result := Result + 1;
  end;
end;

function TPredictiveAlgorithm.CalcDateDays(AThreshold: Double; ACell: TCellDataModel): Double;
begin
  Result := now + AThreshold;
end;

function TPredictiveAlgorithm.CalcDatePieces(AThreshold: Double; ACell: TCellDataModel): Double;
var
  LPOIter: integer;
  LProductionOrderList: TList<TProductionOrderModel>;
  LPiecesADay: Double;
  LPiecesAnHour: Double;
  LQuantity: Double;
  LWorkHours: Double;
begin
  Result:= now;
  LPOIter := 0;
  LProductionOrderList := ACell.ProductionOrders;

  Lquantity := LProductionOrderList[LPOIter].Phases[0].Quantity;
  while true do
  begin
    if LProductionOrderList[LPOIter].WorkHours = 0 then
      LWorkHours := (LProductionOrderList[LPOIter].Pieces * GetMedianHoursPerPiece(ACell.Partials, LProductionOrderList[LPOIter].Phases[0].ArticleID))
    else
      LWorkHours := LProductionOrderList[LPOIter].WorkHours;
    //se workhours � sempre 0 allora gli assegno un valore standard = 100
    if LWorkHours = 0 then
      LWorkHours := 100;
    LPiecesAnHour := LProductionOrderList[LPOIter].Phases[0].Quantity / LWorkHours;
    LPiecesADay := WorkHoursCalculator.GetWorkHours(Result) * LPiecesAnHour;
    AThreshold := AThreshold - LPiecesADay;
    LQuantity := LQuantity - LPiecesADay;

    if AThreshold <= 0 then
      exit;
    if LQuantity <= 0 then
    begin
      if LPOIter = LProductionOrderList.Count - 1 then
      begin
        Result := 100000;
        exit;
      end;
      LPOIter := LPOIter + 1;
      LQuantity := LProductionOrderList[LPOIter].Phases[0].Quantity;

    end;
    Result := Result + 1;
  end;
end;

function TPredictiveAlgorithm.CalculateMaintenanceDate(ACell: TCellDataModel): TList<Double>;
var
  LMaintenanceData: TMaintenanceModel;
  LDaysToMaintenance: Double;
  LPiecesToMaintenance: Double;
  LTimeToMaintenance: Double;
begin
  Result := TList<Double>.Create;

  for LMaintenanceData in ACell.MaintenanceData do
  begin
    LDaysToMaintenance := GetDaysToMaintenance(LMaintenanceData);

    //calcolo per trovare la data in basa alla soglia Giorni/Mesi
    if LDaysToMaintenance <= 0 then
    begin
      LPiecesToMaintenance := GetPiecesToMaintenance(ACell.Partials, LMaintenanceData);
      LTimeToMaintenance := GetTimeToMaintenance(ACell.Partials, LMaintenanceData);
      Result.Add(Min(CalcDatePieces(LPiecesToMaintenance, ACell), CalcDateTime(LTimeToMaintenance, ACell)));
    end
    else
      Result.Add(CalcDateDays(LDaysToMaintenance, ACell));
  end;
end;

destructor TPredictiveAlgorithm.Destroy;
begin
  if Assigned(FWorkHoursCalculator) then
    FWorkHoursCalculator.Free;
  inherited;
end;

function TPredictiveAlgorithm.GetPiecesAnHour(
  APartials: TList<TPartialModel>): Double;
var
  I: integer;
  LMedian: Double;
begin
  LMedian := 0;
  for I := 0 to APartials.Count - 1 do
  begin
    if APartials[I].WorkHours <> 0 then
      LMedian := LMedian + (APartials[I].Quantity / APartials[I].WorkHours);
  end;
  Result := LMedian / APartials.Count;
end;

function TPredictiveAlgorithm.GetPiecesToMaintenance(APartials: TList<TPartialModel>;
  AMaintenanceData: TMaintenanceModel): Double;
var
  LTotalPiecesMade: Double;
begin
  LTotalPiecesMade := varEmpty;
  //calcolo i pezzi totali fatti prendendoli dai parziali di una cella di lavoro
  LTotalPiecesMade := GetTotalPiecesMade(APartials);
  //calcolo i pezzi che mancano fino alla prossima manutenzione
  Result := AMaintenanceData.ThresholdPieces - LTotalPiecesMade;
end;

function TPredictiveAlgorithm.GetDaysToMaintenance(
  AMaintenanceData: TMaintenanceModel): Double;
var
  LTimeFromLastMaintenance: Double;
  LThresholdDays: Integer;
begin
  LTimeFromLastMaintenance := varEmpty;
  Result := varEmpty;
  LThresholdDays := varEmpty;

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
  Result := Result / LCount;
end;

function TPredictiveAlgorithm.GetTimeToMaintenance(
  APartials: TList<TPartialModel>; AMaintenanceData: TMaintenanceModel): Double;
var
  LTotalTimeWorked: Double;
begin
  LTotalTimeWorked := varEmpty;
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
