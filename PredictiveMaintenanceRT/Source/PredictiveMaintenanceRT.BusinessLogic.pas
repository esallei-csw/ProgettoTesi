unit PredictiveMaintenanceRT.BusinessLogic;

interface

uses
  PredictiveMaintenanceRT.BusinessLogicInterface, PredictiveMaintenanceRT.PredictiveAlgorithm
  , PredictiveMaintenanceRT.CellDataModel;

type
  TPredictiveMaintenance = class(TInterfacedObject, IPredictiveMaintenance)

  private
    {Private declarations}
    FPredictiveAlgorithm: TPredictiveAlgorithm;

    function GetPredictiveAlgorithm: TPredictiveAlgorithm;
    property PredictiveAlgorithm: TPredictiveAlgorithm read GetPredictiveAlgorithm write FPredictiveAlgorithm;

    function PopulateCellModel(ACellId: integer): TCellDataModel;
  public
    {Public declarations}
    function GetMaintenanceDate(ACellId: integer): Extended;

  end;

implementation

{ TPredictiveMaintenance }

function TPredictiveMaintenance.GetMaintenanceDate(ACellId: integer): Extended;
begin
  Result := PredictiveAlgorithm.CalculateMaintenanceDate(PopulateCellModel(ACellId));
end;

function TPredictiveMaintenance.GetPredictiveAlgorithm: TPredictiveAlgorithm;
begin
  if not Assigned(FPredictiveAlgorithm) then
    FPredictiveAlgorithm := TPredictiveAlgorithm.Create;
  Result := FPredictiveAlgorithm;
end;

 function TPredictiveMaintenance.PopulateCellModel(
  ACellId: integer): TCellDataModel;
var
  LCellModel: TCellDataModel;
begin
  LCellModel := TCellDataModel.Create;
  LCellModel.CellId := ACellId;
  //funzione che popola i dati del modello tramite querySQL
  Result := LCellModel;
end;

end.
