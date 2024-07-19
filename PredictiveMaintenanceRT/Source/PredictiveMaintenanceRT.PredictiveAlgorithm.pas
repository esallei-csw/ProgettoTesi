unit PredictiveMaintenanceRT.PredictiveAlgorithm;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel, System.Generics.Collections;

type
  TPredictiveAlgorithm = class

  private
    {Private declarations}

    function GetTotalPiecesMade(APartials: TList<TPartialModel>): Extended;
    function GetPiecesAnHour(APartials: TList<TPartialModel>): Extended;
  public
    {Public declarations}

    function CalculateMaintenanceDate(ACell: TCellDataModel): Extended;
  end;

implementation

uses
  PredictiveMaintenanceRT.Constants, PredictiveMaintenanceRT.Messages;

{ TPredictiveAlgorithm }

function TPredictiveAlgorithm.CalculateMaintenanceDate(ACell: TCellDataModel): Extended;
var
  LPiecesAnHour: Extended;
  LPiecesToNextMaintenance: Extended;
  LHoursToMakeXPieces: Extended;
  LDaysToMakeXPieces: Extended;
  LPiecesMadeInAnHour: Extended;
  LPiecesADay: Extended;
  LTotalPiecesMade: Extended;
  I: integer;
begin
  LTotalPiecesMade := 0;
  //convertire FWorkTimeToNextMaintenance in giorni di lavoro calcolando che la macchina lavorer� teoricamente
  //8 ore al giorno e solo 5 giorni alla settimana quindi fare un calcolo che ritorna una data nel futuro


  //prendere in considerazione solo i tempi di lavoro per calcolare la data in base alla soglia tramite tempo di lavoro+

  //prendere in considerazione solo i pezzi prodotti per calcolare la data in base alla soglia tramite i pezzi prodotti


  //se so che la soglia � di 100 pezzi e ne ho gi� prodotti 30 fino ad adesso la data sar�:
  //data di oggi + giorni che servono per produrre altri 70 pezzi

  //per calcolare i giorni che servono per produrre x pezzi dovro sapere quanti pezzi penso di produrre in un giorno
  //potrei prendere questa informazione dai record passati

  //per sapere i giorni di lavoro � meglio passare dicendo quanti pezzi produco in un ora di lavoro

  //pezzi prodotti prima della prossima manutenzione - pezzi prodotti dall ultima manutenzione
  //:= pezzi da produrre prima della prossima manutenzione
  //dati presi dalle manutenzioni = 5000
  //dati sommati dai parziali 15+10+3

  //calcolo i pezzi totali fatti prendendoli dai parziali di una cella di lavoro

  LTotalPiecesMade := GetTotalPiecesMade(ACell.Partials);

  LPiecesToNextMaintenance := ACell.ThresholdPieces - LTotalPiecesMade;

  //pezzi all ora := pezzi prodotti / ore impiegate (dati che vengono presi da un parziale)
  //in questo caso vengono presi dal primo parziale per comodit�
  //sarebbe meglio prenderli dall ultimo che dovrebbe essere quello pi� corretto ed aggiornato
  LPiecesAnHour := GetPiecesAnHour(ACell.Partials);

  //ore di lavoro per produrre x pezzi := xpezzi / pezzi all ora
  LHoursToMakeXPieces := LPiecesToNextMaintenance / LPiecesAnHour;
  //calcolare quanti pezzi produco all ora in media:
  //pezzi prodotti / ore di lavoro per produrre x pezzi := pezzi prodotti in un ora
  //questi dati vengono presi dall ultimo parziale, si potrebbe prendere facendo una media degli ultimi x parziali(in un secondo momento)
  LPiecesMadeInAnHour := LPiecesToNextMaintenance / LHoursToMakeXPieces;

  //trovare a questo punto i pezzi prodotti in una giornata di lavoro:
  //pezzi prodotti in un ora * 8 := pezzi prodotti in un giorno(8 ore)
  LPiecesADay := LPiecesMadeInAnHour * WORK_HOURS_IN_A_DAY;

  //trovare i giorni che servono per produrre x pezzi:
  //x pezzi da produrre / pezzi prodotti in un giorno := giorni per produrre x pezzi
  LDaysToMakeXPieces := LPiecesToNextMaintenance / LPiecesADay;

  Result := DATE_INT + LDaysToMakeXPieces;

  //bisogna tenere in considerazione i giorni non lavorativi

end;

function TPredictiveAlgorithm.GetPiecesAnHour(
  APartials: TList<TPartialModel>): Extended;
var
  I: integer;
  LMedian: Extended;
begin
  LMedian := 0;
  for I := 0 to APartials.Count - 1 do
  begin
    LMedian := LMedian + (APartials[I].Quantity / APartials[I].WorkHours);
  end;
  Result := LMedian / APartials.Count;
end;

function TPredictiveAlgorithm.GetTotalPiecesMade(
  APartials: TList<TPartialModel>): Extended;
var
  I: integer;
  LTotalPiecesMade: Extended;
begin
  LTotalPiecesMade := 0;
  for I := 0 to APartials.Count - 1 do
  begin
    LTotalPiecesMade := LTotalPiecesMade + APartials.Items[I].Quantity;
  end;
  Result := LTotalPiecesMade;
end;

end.
