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

  PO_ID = 'ID';
  PO_PIECES = 'QTAOP';
  PO_PRDHOURS = 'PRDORA';
  PO_WORKHOURS = 'TempoLavoroInOre';

  ULTMAN = 'ULTMAN';
  GIORNI = 'GIORNI';
  MESI = 'MESI';
  MAINTENANCE_QTA = 'QTA';
  MAINTENANCE_HOURS = 'TempoInOre';

  QUERY_PARTIALS = 'select ID, Inizio, TemLav*24 as TempoLavoroInOre, Fine, QtOut from OPSdlPar where (IDCelPro = %s) AND (Inizio > %s) order by ID desc';
  QUERY_MAINTENANCE = 'select IDCELPRO, TEMPO*24 as TempoInOre, QTA, GIORNI, MESI, ULTMAN from MANUTENZIONI where IDCELPRO = %s';
  QUERY_PRODUCTION_ORDERS = 'SELECT OPTES.ID, OPTES.QTAOP, OPSDLFAS.PRDORA, TEMESE*24 as TempoLavoroInOre from OPTES left join OPSDLFAS on OPTES.ID = OPSDLFAS.IDOPTES left join LAVORAZIONI on LAVORAZIONI.ID = OPSDLFAS.IDLAV where LAVORAZIONI.IDCELPRO = %s order by OPTES.DATRIC desc';

  CONNECTION_STRING = 'Provider=SQLOLEDB.1;' +
                      'Persist Security Info=False;' +
                      'User ID=%s;' +
                      'Password=%s;' +
                      'Initial Catalog=%s;' +
                      'Data Source=%s;';

implementation

end.
