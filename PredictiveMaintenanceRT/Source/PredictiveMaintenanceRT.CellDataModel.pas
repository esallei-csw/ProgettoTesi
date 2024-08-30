unit PredictiveMaintenanceRT.CellDataModel;

interface

uses
  PredictiveMaintenanceRT.PartialModel, System.Generics.Collections, PredictiveMaintenanceRT.MaintenanceModel,
  PredictiveMaintenanceRT.ProductionOrderModel,
  PredictiveMaintenanceRT.MachineStopModel;

type
  TCellDataModel = class
    private
    {Private declarations}
    FCellId: integer;
    FMaintenanceData: TList<TMaintenanceModel>;
    FProductionOrders: TList<TProductionOrderModel>;
    FTotalPartials: TList<TPartialModel>;
    FMachineStops: TList<TMachineStopModel>;


    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;
    property CellId: integer read FCellId write FCellId;
    property MaintenanceData: TList<TMaintenanceModel> read FMaintenanceData write FMaintenanceData;
    property ProductionOrders: TList<TProductionOrderModel> read FProductionOrders write FProductionOrders;
    property TotalPartials: TList<TPartialModel> read FTotalPartials write FTotalPartials;
    property MachineStops: TList<TMachineStopModel> read FMachineStops write FMachineStops;


  end;

implementation

{ TCellDataModel }

constructor TCellDataModel.Create;
begin
  FCellId := varEmpty;
  FMaintenanceData := nil;
  FProductionOrders := nil;
  FTotalPartials := nil;
  FMachineStops := nil;
end;

destructor TCellDataModel.Destroy;
var
  I: integer;
begin
  for I := 0 to FMaintenanceData.Count - 1 do
    FMaintenanceData.Items[I].Free;
  FMaintenanceData.Free;
  for I := 0 to FTotalPartials.Count - 1 do
    FTotalPartials.Items[I].Free;
  FTotalPartials.Free;
  for I := 0 to FProductionOrders.Count - 1 do
    FProductionOrders.Items[I].Free;
  FProductionOrders.Free;
  for I := 0 to FMachineStops.Count - 1 do
    FMachineStops.Items[I].Free;
  FMachineStops.Free;
  inherited;
end;

end.
