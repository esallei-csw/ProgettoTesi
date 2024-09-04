unit PredictiveMaintenanceRT.Factory;

interface

uses
  PredictiveMaintenanceRT.BusinessLogicInterface
  , PredictiveMaintenanceRT.BusinessLogic;

type
  TPredictiveMaintenanceFactory = class(TInterfacedObject, IPredictiveMaintenanceFactory)
  public
    {Public declarations}
    function objPredictiveMaintenance: IPredictiveMaintenance;
    class function New: IPredictiveMaintenanceFactory;
  end;


implementation

{ TPredictiveMaintenanceFactory }

class function TPredictiveMaintenanceFactory.New: IPredictiveMaintenanceFactory;
begin
  Result := Self.Create;
end;

function TPredictiveMaintenanceFactory.objPredictiveMaintenance: IPredictiveMaintenance;
begin
  Result := TPredictiveMaintenance.Create;
end;

end.
