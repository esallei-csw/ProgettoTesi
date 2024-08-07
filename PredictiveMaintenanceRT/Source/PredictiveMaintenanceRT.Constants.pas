unit PredictiveMaintenanceRT.Constants;

interface

const

  DB_NAME = 'SAMTESI';
  SERVER_NAME = 'CSW325';
  DEFAULT_USERNAME = 'sa';
  DEFAULT_PASSWORD = '1Password1';
  DEFAULT_CELLID = 13;


  WORK_HOURS_IN_A_DAY = 8;
  DAYS_IN_A_MONTH = 30;

  PARTIAL_ID = 'ID';
  PARTIAL_START = 'Inizio';
  PARTIAL_WORKHOURS = 'TempoLavoroInOre';
  PARTIAL_END = 'Fine';
  PARTIAL_QUANTITY = 'QtOut';
  PARTIAL_IDARTICO = 'IDARTICO';

  PO_ID = 'IDOrdineProduzione';
  PO_PIECES = 'QTAOP';
  PO_PRDHOURS = 'PRDORA';
  PO_WORKHOURS = 'TempoLavoroInOre';

  PHASE_ID = 'IDFase';
  ARTICO_ID = 'IDArticolo';
  PHASE_WORKTIME = 'TempoLavoroInOreTeorico';

  ULTMAN = 'ULTMAN';
  GIORNI = 'GIORNI';
  MESI = 'MESI';
  MAINTENANCE_QTA = 'QTA';
  MAINTENANCE_HOURS = 'TempoInOre';
  MAINTENANCE_DESCR = 'Descrizione';

  QUERY_PARTIALS = 'select ID, Inizio, TemLav*24 as TempoLavoroInOre, Fine, QtOut, IDARTICO from OPSdlPar where (IDCelPro = %s) AND (Inizio > %s) order by ID desc';
  QUERY_MAINTENANCE = 'select IDCELPRO, VARDB.DESCR as Descrizione, TEMPO*24 as TempoInOre, QTA, GIORNI, MESI, ULTMAN from MANUTENZIONI left join VARDB on MANUTENZIONI.IDARTICO = VARDB.IDARTICO where IDCELPRO = %s';
  QUERY_PHASES = 'SELECT OPTES.ID as IDOrdineProduzione, OPTES.STATO, OPSDLFAS.ID as IDFase, LAVORAZIONI.IDCELPRO as IDCella, OPTES.IDARTICO as IDArticolo, OPTES.QTAOP, OPSDLFAS.TEMESE*24 as TempoLavoroInOreTeorico, OPTES.DATRIC as DataRichiesta '+
                'from OPTES '+
                'left join OPSDLFAS on OPTES.ID = OPSDLFAS.IDOPTES '+
                'left join LAVORAZIONI on LAVORAZIONI.ID = OPSDLFAS.IDLAV '+
                'where (LAVORAZIONI.IDCELPRO = %s) and ((OPTES.STATO = ''C'') or (OPTES.STATO = ''M'')) '+
                'order by DataRichiesta, IDOrdineProduzione asc';
  QUERY_TOTAL_PARTIALS = 'select ID, Inizio, TemLav*24 as TempoLavoroInOre, Fine, QtOut, IDARTICO from OPSdlPar where IDCelPro = %s order by ID desc';
  QUERY_CELLS = 'select distinct IDCELPRO from MANUTENZIONI where IDCELPRO is not null';

  CONNECTION_STRING = 'Provider=SQLOLEDB.1;' +
                      'Persist Security Info=False;' +
                      'User ID=%s;' +
                      'Password=%s;' +
                      'Initial Catalog=%s;' +
                      'Data Source=%s;';

implementation

end.
