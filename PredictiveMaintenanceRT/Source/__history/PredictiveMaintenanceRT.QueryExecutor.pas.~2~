unit PredictiveMaintenanceRT.QueryExecutor;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Pool
  , FireDAC.Stan.Async, FireDAC.Phys.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase
  , FireDAC.Phys.MSSQL, FireDAC.VCLUI.Wait, FireDAC.DApt, FireDAC.Stan.Param
  , FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Stan.Option, Data.DB;
type
  TQueryExecutor = class
  private
    FConnection: TFDConnection;
    procedure SetupConnection(ADataBaseName, AServerName, AUserName, APassword: string);
  public
    constructor Create(ADataBaseName, AServerName, AUserName, APassword: string);
    destructor Destroy; override;
    function ExecuteQuery(AQuery: string): TDataSet;
  end;
implementation

uses
  PredictiveMaintenanceRT.Constants, PredictiveMaintenanceRT.Messages;

{ TQueryExecutor }
constructor TQueryExecutor.Create(ADataBaseName, AServerName, AUserName, APassword: string);
begin
  inherited Create;
  FConnection := TFDConnection.Create(nil);
  SetupConnection(ADataBaseName, AServerName, AUserName, APassword);
end;
destructor TQueryExecutor.Destroy;
begin
  FConnection.Free;
  inherited Destroy;
end;
procedure TQueryExecutor.SetupConnection(ADataBaseName, AServerName, AUserName, APassword: string);
begin
  // Configurazione della connessione al database
  FConnection.DriverName := DRIVER_NAME;
  FConnection.Params.Database := ADataBaseName;
  FConnection.Params.UserName := AUserName;
  FConnection.Params.Password := APassword;
  FConnection.Params.Add(SERVER + AServerName);

  FConnection.LoginPrompt := False;
  try
    FConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create(DATABASE_CONNECTION_ERROR + E.Message);
  end;
end;
function TQueryExecutor.ExecuteQuery(AQuery: string): TDataSet;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := AQuery;
    Query.Open;
    Result := Query;
  finally
    Query.Free;
  end;
end;
end.
