unit PredictiveMaintenanceRT.CellDataModel;

interface

uses
  PredictiveMaintenanceRT.PartialModel, System.Generics.Collections, PredictiveMaintenanceRT.MaintenanceModel,
  PredictiveMaintenanceRT.ProductionOrderModel, PredictiveMaintenanceRT.ClosedPeriodModel,
  PredictiveMaintenanceRT.MachineStopModel;

type
  TCellDataModel = class
    private
    {Private declarations}
    FCellId: integer;
    FMaintenanceData: TList<TMaintenanceModel>;
    //FPartials: TList<TPartialModel>;
    FProductionOrders: TList<TProductionOrderModel>;
    FTotalPartials: TList<TPartialModel>;
    //FClosedPeriods: TList<TClosedPeriodModel>;
    FMachineStops: TList<TMachineStopModel>;


    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;
    property CellId: integer read FCellId write FCellId;
    property MaintenanceData: TList<TMaintenanceModel> read FMaintenanceData write FMaintenanceData;
    //property Partials: TList<TPartialModel> read FPartials write FPartials;
    property ProductionOrders: TList<TProductionOrderModel> read FProductionOrders write FProductionOrders;
    property TotalPartials: TList<TPartialModel> read FTotalPartials write FTotalPartials;
    //property ClosedPeriods: TList<TClosedPeriodModel> read FClosedPeriods write FClosedPeriods;
    property MachineStops: TList<TMachineStopModel> read FMachineStops write FMachineStops;


  end;

implementation

{ TCellDataModel }

constructor TCellDataModel.Create;
begin
  FCellId := varEmpty;
  FMaintenanceData := TList<TMaintenanceModel>.Create;
  //FPartials := TList<TPartialModel>.Create;
  FProductionOrders := TList<TProductionOrderModel>.Create;
  FTotalPartials := TList<TPartialModel>.Create;
  //FClosedPeriods := TList<TClosedPeriodModel>.Create;
  FMachineStops := TList<TMachineStopModel>.Create;
end;

destructor TCellDataModel.Destroy;
begin
  FMaintenanceData.Free;
  //FPartials.Free;
  FProductionOrders.Free;
  FTotalPartials.Free;
  //FClosedPeriods.Free;
  FMachineStops.Free;
  inherited;
end;

end.
