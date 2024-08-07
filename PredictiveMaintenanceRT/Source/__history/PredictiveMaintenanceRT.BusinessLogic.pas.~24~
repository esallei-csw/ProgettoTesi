unit PredictiveMaintenanceRT.BusinessLogic;

interface

uses
  PredictiveMaintenanceRT.BusinessLogicInterface, PredictiveMaintenanceRT.PredictiveAlgorithm,
  PredictiveMaintenanceRT.CellDataModel,
  PredictiveMaintenanceRT.PartialModel, Data.DB, System.Generics.Collections,
  Data.Win.ADODB, PredictiveMaintenanceRT.QueryHandler, PredictiveMaintenanceRT.ResultModel;

type
  TPredictiveMaintenance = class(TInterfacedObject, IPredictiveMaintenance)

  private
    {Private declarations}
    FPredictiveAlgorithm: TPredictiveAlgorithm;
    FQueryHandler: TQueryHandler;

    function GetPredictiveAlgorithm: TPredictiveAlgorithm;
    property PredictiveAlgorithm: TPredictiveAlgorithm read GetPredictiveAlgorithm write FPredictiveAlgorithm;

    function GetQueryHandler: TQueryHandler;
    property QueryHandler: TQueryHandler read getQueryHandler write FQueryHandler;


    function GetCellModel(ACellId: integer): TCellDataModel;
  public
    {Public declarations}
    function GetMaintenanceDate(ACellId: integer): TList<TResultModel>;
    procedure UsePastData(AFlag: boolean);

  end;

implementation

{ TPredictiveMaintenance }
uses
  PredictiveMaintenanceRT.Constants, PredictiveMaintenanceRT.Messages, System.SysUtils;

function TPredictiveMaintenance.GetMaintenanceDate(ACellId: integer): TList<TResultModel>;
begin
  Result := PredictiveAlgorithm.CalculateMaintenanceDate(GetCellModel(ACellId));
end;

function TPredictiveMaintenance.GetCellModel(
  ACellId: integer): TCellDataModel;
begin
  Result := QueryHandler.PopulateCellModel(ACellId);
end;

function TPredictiveMaintenance.GetPredictiveAlgorithm: TPredictiveAlgorithm;
begin
  if not Assigned(FPredictiveAlgorithm) then
    FPredictiveAlgorithm := TPredictiveAlgorithm.Create;
  Result := FPredictiveAlgorithm;
end;

function TPredictiveMaintenance.GetQueryHandler: TQueryHandler;
begin
  if not Assigned(FQueryHandler) then
    FQueryHandler := TQueryHandler.Create;
  Result:= FQueryHandler;
end;

procedure TPredictiveMaintenance.UsePastData(AFlag: boolean);
begin
  PredictiveAlgorithm.UsePastData := AFlag;
end;

end.
