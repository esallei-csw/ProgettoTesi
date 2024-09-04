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
  LMaintenanceData: TMaintenanceModel;
  LTotalPartial: TPartialModel;
  LProductionOrder: TProductionOrderModel;
  LMachineStop: TMachineStopModel;
begin
  for LMaintenanceData in FMaintenanceData do
    LMaintenanceData.Free;
  FMaintenanceData.Free;
  for LTotalPartial in FTotalPartials do
    LTotalPartial.Free;
  FTotalPartials.Free;
  for LProductionOrder in FProductionOrders do
    LProductionOrder.Free;
  FProductionOrders.Free;
  for LMachineStop in FMachineStops do
    LMachineStop.Free;
  FMachineStops.Free;
  inherited;
end;

end.
