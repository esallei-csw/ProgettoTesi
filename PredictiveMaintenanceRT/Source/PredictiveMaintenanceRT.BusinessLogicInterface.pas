unit PredictiveMaintenanceRT.BusinessLogicInterface;

interface

type
  IPredictiveMaintenance = interface
    ['{B5B7A05E-1DCE-4F5E-9C2C-3A58F9B63EFA}']

    function GetMaintenanceDate(ACellId: integer): Extended;
  end;

implementation

end.
