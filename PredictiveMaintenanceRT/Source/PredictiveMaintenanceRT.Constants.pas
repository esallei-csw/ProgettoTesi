unit PredictiveMaintenanceRT.Constants;

interface

const

  DB_NAME = 'SAMTESI';
  SERVER_NAME = 'CSW325';
  DEFAULT_USERNAME = 'sa';
  DEFAULT_PASSWORD = '1Password1';
  DEFAULT_CELLID = 2;

  DAYS_IN_A_MONTH = 30;

  ID = 'ID';
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

  CPERIOD_DATAINI = 'DATINI';
  CPERIOD_DATAFIN = 'DATFIN';
  CPERIOD_TIPO = 'TIPO';
  CPERIOD_DURATION = 'DURATA';

  STOPS_DATAIN = 'DATIN';
  STOPS_DATAFIN = 'DATFI';
  STOPS_ORAIN = 'OraInizio';
  STOPS_ORAFIN = 'OraFine';
  STOPS_DURATA = 'DurataInOre';

  CALENDAR_ID = 'IDPROFTES';
  IDCELPRO = 'IDCELPRO';
  CALENDAR_DAY = 'GIORNO';
  CALENDAR_TOTORE = 'TotInOre';
  CALENDAR_STARTDAY = 'GGINIZIO';
  GIORNO = 'GIORNO';
  CODICE = 'Codice';
  DESCRIZIONE = 'Descr';
  ID_REPARTO ='IdRepCdC';

  CONNECTION_STRING = 'Provider=SQLOLEDB.1;' +
                      'Persist Security Info=False;' +
                      'User ID=%s;' +
                      'Password=%s;' +
                      'Initial Catalog=%s;' +
                      'Data Source=%s;';
  //Query Constants
  QUERY_PARTIALS = 'select ID, Inizio, TemLav*24 as TempoLavoroInOre, Fine, QtOut, IDARTICO '+
                    'from OPSdlPar '+
                    'where (IDCelPro = %s) AND (Inizio > %s) '+
                    'order by ID desc';

  QUERY_MAINTENANCE = 'select IDCELPRO, VARDB.DESCR as Descrizione, TEMPO*24 as TempoInOre, QTA, GIORNI, MESI, ULTMAN '+
                      'from MANUTENZIONI '+
                      'left join VARDB on MANUTENZIONI.IDVARDB = VARDB.ID '+
                      'where (MANUTENZIONI.OBSOLETA=0) and (IDCELPRO = %s) and (MANUTENZIONI.IsStra = 0) ';

  QUERY_PHASES = 'SELECT OPTES.ID as IDOrdineProduzione, OPTES.STATO, OPSDLFAS.ID as IDFase, LAVORAZIONI.IDCELPRO as IDCella, '+
                'OPTES.IDARTICO as IDArticolo, OPTES.QTAOP, OPSDLFAS.TEMESE*24 as TempoLavoroInOreTeorico, OPTES.DATRIC as DataRichiesta '+
                'from OPTES '+
                'left join OPSDLFAS on OPTES.ID = OPSDLFAS.IDOPTES '+
                'left join LAVORAZIONI on LAVORAZIONI.ID = OPSDLFAS.IDLAV '+
                'where (LAVORAZIONI.IDCELPRO = %s) and ((OPTES.STATO = ''C'') or (OPTES.STATO = ''M'')) '+
                'order by DataRichiesta, IDOrdineProduzione asc';

  QUERY_TOTAL_PARTIALS = 'select ID, Inizio, TemLav*24 as TempoLavoroInOre, Fine, QtOut, IDARTICO '+
                          'from OPSdlPar '+
                          'where IDCelPro = %s '+
                          'order by ID desc';

  QUERY_CELLS = 'select distinct IDCELPRO '+
                'from MANUTENZIONI '+
                'where IDCELPRO is not null';

  QUERY_CLOSEDPERIOD = 'select ID, IDCELPRO, DATINI, DATFIN, TIPO, DURATA '+
                        'from TAPCCF '+
                        'where (IDCELPRO = %s) or (TIPO = ''SA'') or ((TIPO = ''SR'') and (IDREPCDC=%s))';

  QUERY_MACHINESTOPS = 'select ID, IDCELPRO, DATIN, ORAIN*24 as OraInizio, DATFI, ORAFI*24 as OraFine, DUR*24 as DurataInOre '+
                        'from ALLARMI '+
                        'where IDCELPRO = %s and APERTO = 0';

  QUERY_CALENDAR = 'select PROFASS.IDPROFTES, PROFASS.GGINIZIO ' +
                    'from PROFASS ' +
                      'join PROFTES on PROFTES.ID = PROFASS.IDPROFTES '+
                    'where (PROFASS.IDCELPRO = %s) and (PROFASS.TIPO=''C'') '+
                    'order by GGINIZIO ';

  QUERY_CALENDAR_DEPARTMENT = 'select PROFASS.IDPROFTES, PROFASS.GGINIZIO ' +
                    'from PROFASS ' +
                      'join PROFTES on PROFTES.ID = PROFASS.IDPROFTES '+
                    'where (PROFASS.IDREPCDC = %s) and (PROFASS.TIPO=''R'') '+
                    'order by GGINIZIO ';

  QUERY_CALENDAR_PLANT = 'select PROFASS.IDPROFTES, PROFASS.GGINIZIO ' +
                    'from PROFASS ' +
                      'join PROFTES on PROFTES.ID = PROFASS.IDPROFTES '+
                    'where (PROFASS.TIPO=''A'') '+
                    'order by GGINIZIO ';

  QUERY_WEEK_CALENDAR = 'select GIORNO, TOTORE*24 as TotInOre '+
                        'from PROFDET '+
                        'where IDPROFTES = %s and VARIANTE	= ''0000''';

  QUERY_GETREPCDC_FROMCELPRO = 'select IdRepCdC from CelPro where (ID=%s) ';
  QUERY_GETCELPRO_INFO = 'select Codice, Descr from CelPro where (ID=%s) ';

implementation

end.
