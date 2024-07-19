unit PredictiveMaintenanceRT.BusinessLogic;

interface

uses
  PredictiveMaintenanceRT.BusinessLogicInterface, PredictiveMaintenanceRT.PredictiveAlgorithm, 
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.QueryExecutor,
  PredictiveMaintenanceRT.PartialModel, Data.DB, System.Generics.Collections,
  FireDAC.Comp.Client, Data.Win.ADODB, PredictiveMaintenanceRT.QueryHandler;

type
  TPredictiveMaintenance = class(TInterfacedObject, IPredictiveMaintenance)

  private
    {Private declarations}
    FPredictiveAlgorithm: TPredictiveAlgorithm;
    FQueryHandler: TQueryHandler;
    FQueryExecutor: TQueryExecutor;

    function GetPredictiveAlgorithm: TPredictiveAlgorithm;
    property PredictiveAlgorithm: TPredictiveAlgorithm read GetPredictiveAlgorithm write FPredictiveAlgorithm;

    function GetQueryHandler: TQueryHandler;
    property QueryHandler: TQueryHandler read getQueryHandler write FQueryHandler;

    function GetQueryExecutor: TQueryExecutor;
    property QueryExecutor: TQueryExecutor read GetQueryExecutor write FQueryExecutor;


    function GetCellModel(ACellId: integer): TCellDataModel;
  public
    {Public declarations}
    function GetMaintenanceDate(ACellId: integer): Extended;

  end;

implementation

{ TPredictiveMaintenance }
uses
  PredictiveMaintenanceRT.Constants, PredictiveMaintenanceRT.Messages, System.SysUtils;

function TPredictiveMaintenance.GetMaintenanceDate(ACellId: integer): Extended;
begin
  Result := PredictiveAlgorithm.CalculateMaintenanceDate(GetCellModel(ACellId));
end;

function TPredictiveMaintenance.GetPredictiveAlgorithm: TPredictiveAlgorithm;
begin
  if not Assigned(FPredictiveAlgorithm) then
    FPredictiveAlgorithm := TPredictiveAlgorithm.Create;
  Result := FPredictiveAlgorithm;
end;

 function TPredictiveMaintenance.GetQueryExecutor: TQueryExecutor;
begin
  if not Assigned(FQueryExecutor) then
    FQueryExecutor := TQueryExecutor.Create(DEFAULT_USERNAME, DEFAULT_PASSWORD, DB_NAME, SERVER_NAME);
  Result := FQueryExecutor;
end;

function TPredictiveMaintenance.GetQueryHandler: TQueryHandler;
begin
  if not Assigned(FQueryHandler) then
    FQueryHandler := TQueryHandler.Create;
  Result:= FQueryHandler;
end;

function TPredictiveMaintenance.GetCellModel(
  ACellId: integer): TCellDataModel;
var
  LCellModel: TCellDataModel;
begin
  LCellModel := TCellDataModel.Create;
  LCellModel.CellId := ACellId;
  LCellModel.ThresholdPieces := 500;
  //funzione che popola i dati del modello tramite querySQL
  LCellModel := QueryHandler.PopulateCellModel(LCellModel);
  Result := LCellModel;
end;

end.
