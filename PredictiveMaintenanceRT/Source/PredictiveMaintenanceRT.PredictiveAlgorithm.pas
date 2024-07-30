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



    function GetTotalPiecesMade(APartials: TList<TPartialModel>): Double;
    function GetTotalTimeWorked(APartials: TList<TPartialModel>): Double;
    function GetPiecesAnHour(APartials: TList<TPartialModel>): Double;

    function CalcDatePieces(AThreshold: Double; ACell: TCellDataModel): Double;
    function CalcDateTime(AThreshold: Double; ACell: TCellDataModel): Double;
    function CalcDateDays(AThreshold: Double; ACell: TCellDataModel): Double;

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
  PredictiveMaintenanceRT.Constants, PredictiveMaintenanceRT.Messages, System.SysUtils, System.Math;

{ TPredictiveAlgorithm }

function TPredictiveAlgorithm.CalcDateTime(AThreshold: Double; ACell: TCellDataModel): Double;
var
  LPOIter: integer;
  LProductionOrderList: TList<TProductionOrderModel>;
begin
  Result := now;
  LPOIter := 0;
  LProductionOrderList := ACell.ProductionOrders;

  while true do
  begin
    AThreshold := AThreshold - WorkHoursCalculator.GetWorkHours(Result);
    LProductionOrderList[LPOIter].WorkHours := LProductionOrderList[LPOIter].WorkHours - WorkHoursCalculator.GetWorkHours(Result);

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
begin
  Result:= now;
  LPOIter := 0;
  LProductionOrderList := ACell.ProductionOrders;

  while true do
  begin
    LPiecesAnHour := LProductionOrderList[LPOIter].Pieces / LProductionOrderList[LPOIter].WorkHours;
    LPiecesADay := WorkHoursCalculator.GetWorkHours(Result) * LPiecesAnHour;
    AThreshold := AThreshold - LPiecesADay;
    LProductionOrderList[LPOIter].Pieces := LProductionOrderList[LPOIter].Pieces - LPiecesADay;

    if AThreshold <= 0 then
      exit;
    if LProductionOrderList[LPOIter].Pieces <= 0 then
      LPOIter := LPOIter + 1;
    if not Assigned(LProductionOrderList[LPOIter]) then
      raise Exception.Create(FINISHED_PO);

    Result := Result + 1;
  end;



end;


  //alla fine dei calcoli avr� una data per ogni manutenzione trovata
  //quindi sarebbe corretto restituire una lista di Double
  //il main andr� poi a visualizzare x date differenti(volendo con anche la descrizione della manutenzione di fianco
  //e in ordine cronologico)




  //la funzione deve prendere sia i valori passati che i valori futuri
  //per quanto riguarda i valori passati possiamo utilizzarli per sapere quanti pezzi rimangono da produrre prima
  //di una certa manutenzione/tempo che rimane prima della prossima manutenzione
  //entrambi questi dati devono essere calcolati in base ai dati di partials e maintenance data
  //questa funzione deve prendere in considerazione sia il tempo che i pezzi in modo tale che possa essere utilizzata
  //per qualsiasi tipo di soglia(soglia tempo, soglia pezzi)
  //ritorner� valori come PiecesToNextMaintenance o timeToNextMaintenance
  //che sono gli unici valori interessanti che posso prendere solo dallo storico

  //dopodich� ciclare sui giorni successivi a quello odierno
  //controllare per ogni giorno: ore lavorative(0 se non lavorativo/feriale)
  //pezzi che si stima vengano prodotti quel giorno

  //in modo tale che in quel giorno li so che verranno prodotti x pezzi perch� me lo dice il previsionale
  //e quindi posso sottrarre i pezzi prodotti quel giorno dai piecesToNextMaintenance

  //per quanto riguarda il tempo posso dire che lavorer� x ore quel giorno su quella macchina
  //e quindi sottrarr� x ore da TimeTONextMaintenance

  //per entrambi fino ad arrivare al punto in cui la sottrazione porta a 0 o a un numero negativo



function TPredictiveAlgorithm.CalculateMaintenanceDate(ACell: TCellDataModel): TList<Double>;
var
  LMaintenanceData: TMaintenanceModel;
  LDaysToMaintenance: Double;
  LPiecesToMaintenance: Double;
  LTimeToMaintenance: Double;
begin

  for LMaintenanceData in ACell.MaintenanceData do
  begin
    LDaysToMaintenance := GetDaysToMaintenance(LMaintenanceData);
    LPiecesToMaintenance := GetPiecesToMaintenance(ACell.Partials, LMaintenanceData);
    LTimeToMaintenance := GetTimeToMaintenance(ACell.Partials, LMaintenanceData);

    //calcolo per trovare la data in basa alla soglia Giorni/Mesi
    if CalcDateDays(LDaysToMaintenance, ACell) = now then
      Result.Add(Min(CalcDatePieces(LPiecesToMaintenance, ACell), CalcDateTime(LTimeToMaintenance, ACell)))
    else
      Result.Add(CalcDateDays(LDaysToMaintenance, ACell));
  end;

  //trovare quanti pezzi posso fare prima della manutenzione := LPiecesToNextMaintenance
  //confrontarli con i pezzi che dovranno essere fatti nel futuro in base agli ordini di produzione
  //salvo all interno della cella una lista degli ordini di produzione,
  //dopodich� li sommo uno a uno e quando arrivo all ordine che supera i pezzi,
  //segno la data di fine dell ordine di produzione precedente
  //cosi da inserire la manutenzione tra 2 ordini di produzione

  //nel caso non sia necessario inserire la manutenzione tra 2 ordini di produzione
  //mi baster� prendere la data di inizio dell ordine di produzione

  //implementare il calcolo dei previsionali + cambiare metodo di calcolo della data
  //ovvero controllo giorno per giorno #fatto
  //aggiungere il modello per il previsionale(dopo aver capito cosa mi serve)


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
