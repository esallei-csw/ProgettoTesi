unit PredictiveMaintenanceRT.Messages;

interface

resourcestring


  DATABASE_CONNECTION_ERROR = 'Errore di connessione al database: ';

  SQL_DATA_NOTFOUND = 'SQL Data Not Found';
  DATASET_CLOSED = 'Dataset is not open.';
  SQL_ERROR = 'SQL Error';

  MAINTENANCE_BEFORE_NOW = 'Attenzione, la manutenzione dovrebbe gi� essere stata fattam procedere alla manutenzione il prima possibile o aggiornare la data di ultima manutenzione';
  VALUE_ZERO = 'Errore nel calcolo: valore = 0';

  FINISHED_PO = 'Finiti gli ordini di produzione';

  PO_ERROR = 'Populate Production Orders Error';

  WARNINGLIST = 'Warning List ';

  NOT_ENOUGH_PO = 'Not enough Production Orders to complete calculation';
  DAYS_CALC = 'Days Calculation';
  PIECES_CALC = 'Pieces Calculation';
  TIME_CALC = 'Time Calculation';
  USED_PAST_DATA = 'Used Past Data for PO n� ';
  ACTUALLY_USED_PAST_DATA = 'PastData actually used for PO n�';
  MAN_STRA = 'Manutenzione straordinaria';

implementation

end.
