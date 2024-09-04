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
    FMaintenanceData: TObjectList<TMaintenanceModel>;
    FProductionOrders: TObjectList<TProductionOrderModel>;
    FTotalPartials: TObjectList<TPartialModel>;
    FMachineStops: TObjectList<TMachineStopModel>;


    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;
    property CellId: integer read FCellId write FCellId;
    property MaintenanceData: TObjectList<TMaintenanceModel> read FMaintenanceData write FMaintenanceData;
    property ProductionOrders: TObjectList<TProductionOrderModel> read FProductionOrders write FProductionOrders;
    property TotalPartials: TObjectList<TPartialModel> read FTotalPartials write FTotalPartials;
    property MachineStops: TObjectList<TMachineStopModel> read FMachineStops write FMachineStops;


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
begin
  FMaintenanceData.Free;
  FTotalPartials.Free;
  FProductionOrders.Free;
  FMachineStops.Free;
  inherited;
end;

end.
