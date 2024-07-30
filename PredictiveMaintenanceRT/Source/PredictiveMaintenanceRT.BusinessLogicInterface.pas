unit PredictiveMaintenanceRT.BusinessLogicInterface;

interface

uses
  System.Generics.Collections;

type
  IPredictiveMaintenance = interface
    ['{B5B7A05E-1DCE-4F5E-9C2C-3A58F9B63EFA}']

    function GetMaintenanceDate(ACellId: integer): TList<Double>;
  end;

implementation

end.
