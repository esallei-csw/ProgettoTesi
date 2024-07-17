unit PredictiveMaintenanceRT.PredictiveAlgorithm;

interface

uses
  PredictiveMaintenanceRT.CellDataModel;

type
  TPredictiveAlgorithm = class

  private
    {Private declarations}

    function WorkTimeToDays(AHours: Extended): Extended;

    function PiecesDay(Apieces: Extended): Extended;

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
  for I := 0 to Length(ACell.Partials) do
  begin
    LTotalPiecesMade := LTotalPiecesMade + ACell.Partials[I].Quantity;
  end;

  LPiecesToNextMaintenance := ACell.ThresholdPieces - LTotalPiecesMade;

  //pezzi all ora := pezzi prodotti / ore impiegate (dati che vengono presi da un parziale)
  //in questo caso vengono presi dal primo parziale per comodit�
  //sarebbe meglio prenderli dall ultimo che dovrebbe essere quello pi� corretto ed aggiornato
  LPiecesAnHour := ACell.Partials[0].Quantity / ACell.Partials[0].WorkHours;

  //ore di lavoro per produrre x pezzi := xpezzi / pezzi all ora
  LHoursToMakeXPieces := LPiecesToNextMaintenance / LPiecesAnHour;
  //calcolare quanti pezzi produco all ora in media:
  //pezzi prodotti / ore di lavoro per produrre x pezzi := pezzi prodotti in un ora
  //questi dati vengono presi dall ultimo parziale, si potrebbe prendere facendo una media degli ultimi x parziali(in un secondo momento)
  LPiecesMadeInAnHour := LPiecesToNextMaintenance / LHoursToMakeXPieces;

  //trovare a questo punto i pezzi prodotti in una giornata di lavoro:
  //pezzi prodotti in un ora * 8 := pezzi prodotti in un giorno(8 ore)
  LPiecesADay := PiecesDay(LPiecesMadeInAnHour);

  //trovare i giorni che servono per produrre x pezzi:
  //x pezzi da produrre / pezzi prodotti in un giorno := giorni per produrre x pezzi
  LDaysToMakeXPieces := LPiecesToNextMaintenance / LPiecesADay;

  Result := DATE_INT + LDaysToMakeXPieces;

  //bisogna tenere in considerazione i giorni non lavorativi
  //(forse prendendo in considerazione le settimane piuttosto che i giorni)


end;

function TPredictiveAlgorithm.PiecesDay(Apieces: Extended): Extended;
begin
  Result := Apieces * WORK_HOURS_IN_A_DAY;
end;

function TPredictiveAlgorithm.WorkTimeToDays(AHours: Extended): Extended;
begin
  Result := AHours / WORK_HOURS_IN_A_DAY;
end;

end.
