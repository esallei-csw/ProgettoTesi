unit PredictiveMaintenanceRT.Messages;

interface

resourcestring


  DATABASE_CONNECTION_ERROR = 'Errore di connessione al database: ';

  SQL_DATA_NOTFOUND = 'SQL Data Not Found';
  DATASET_CLOSED = 'Dataset is not open.';
  SQL_ERROR = 'SQL Error';

  VALUE_ZERO = 'Errore nel calcolo: valore = 0';

  FINISHED_PO = 'Finiti gli ordini di produzione';

  PO_ERROR = 'Populate Production Orders Error';

  WARNINGLIST = 'Warning List ';

  NOT_ENOUGH_PO = 'Not enough Production Orders to complete calculation';
  DAYS_CALC = 'Days Calculation';
  PIECES_CALC = 'Pieces Calculation';
  TIME_CALC = 'Time Calculation';
  USED_PAST_DATA = 'Used Past Data for PO n° ';
  ACTUALLY_USED_PAST_DATA = 'PastData actually used for PO n°';
  MAN_STRA = 'Data ultima manutenzione = 0';
  CELL_DATA_NIL = 'Cella Data Nil';
  MAINTENANCE_TODO_MSG = 'Maintenance date is before today, maintenance is due as soon as possible!';

implementation

end.
