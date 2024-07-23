unit PredictiveMaintenanceRT.QueryExecutor;

interface

uses
  System.SysUtils, Data.Win.ADODB, Data.DB;
type
  TQueryExecutor = class
  private
    FConnection: TADOConnection;
    procedure SetupConnection(AUserName, APassword, ADBName, AServerName: string);
  public
    constructor Create(AUserName, APassword, ADBName, AServerName: string);
    destructor Destroy; override;
    function ExecuteQuery(SQL: string): TADOQuery;
  end;
implementation
{ TQueryExecutor }
uses
  PredictiveMaintenanceRT.Constants;

constructor TQueryExecutor.Create(AUserName, APassword, ADBName, AServerName: string);
begin
  inherited Create;
  FConnection := TADOConnection.Create(nil);
  SetupConnection(AUserName, APassword, ADBName, AServerName);
end;

destructor TQueryExecutor.Destroy;
begin
  FConnection.Free;
  inherited Destroy;
end;

procedure TQueryExecutor.SetupConnection(AUserName, APassword, ADBName, AServerName: string);
begin
  FConnection.ConnectionString := Format(CONNECTION_STRING ,[AUserName, APassword, ADBName, AServerName]);
  FConnection.LoginPrompt := False;
  FConnection.Connected := True;
end;

function TQueryExecutor.ExecuteQuery(SQL: string): TADOQuery;
//var
//  LQuery: TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  try
    Result.Connection := FConnection;
    Result.SQL.Text := SQL;
    Result.Open;
//    Result := LQuery;
  except
    on E: Exception do
    begin
//      LQuery.Free;
      raise;
    end;
  end;
end;
end.
