unit PredictiveMaintenanceRT.Constants;

interface

const
  DRIVER_NAME = 'MSSQL';
  SERVER = 'Server=';

  WORK_HOURS_IN_A_DAY = 8;
  DATE_INT = 45491;

  DB_NAME = 'SAMTESI';
  SERVER_NAME = 'CSW325';
  DEFAULT_USERNAME = 'sa';
  DEFAULT_PASSWORD = '1Password1';
  DEFAULT_CELLID = 13;

  PARTIAL_ID = 'ID';
  PARTIAL_CELLID = 'IDCelPro';
  PARTIAL_START = 'Inizio';
  PARTIAL_WORKHOURS = 'TempoLavoroInOre';
  PARTIAL_END = 'Fine';
  PARTIAL_QUANTITY = 'QtOut';

  QUERY_PARTIALS = 'select ID, IDCelPro, Inizio, TemLav*24 as TempoLavoroInOre, Fine, QtOut from OPSdlPar where (IDCelPro = %s) AND (Inizio > 45383) order by ID desc';

  CONNECTION_STRING = 'Provider=SQLOLEDB.1;' +
                      'Persist Security Info=False;' +
                      'User ID=%s;' +
                      'Password=%s;' +
                      'Initial Catalog=%s;' +
                      'Data Source=%s;';

implementation

end.
