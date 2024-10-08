unit PredictiveMaintenanceRT.BusinessLogicInterface;

interface

uses
  System.Generics.Collections, PredictiveMaintenanceRT.ResultModel;

type
  IPredictiveMaintenance = interface
    ['{B5B7A05E-1DCE-4F5E-9C2C-3A58F9B63EFA}']

    function GetMaintenanceDate(ACellId: integer): TObjectList<TResultModel>;
    procedure UsePastData(AFlag: boolean);
    function GetCellsList: TList<integer>;
  end;

  IPredictiveMaintenanceFactory = interface
    ['{DB2FD86E-A759-4656-A673-9F7E99127F4D}']

    function objPredictiveMaintenance: IPredictiveMaintenance;
  end;

implementation

end.
