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
    FCellCode: string;
    FCellDescription: string;


    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;
    property CellId: integer read FCellId write FCellID;
    property CellCode: string read FCellCode write FCellCode;
    property CellDescription: string read FCellDescription write FCellDescription;
    property MaintenanceData: TObjectList<TMaintenanceModel> read FMaintenanceData write FMaintenanceData;
    property ProductionOrders: TObjectList<TProductionOrderModel> read FProductionOrders write FProductionOrders;
    property TotalPartials: TObjectList<TPartialModel> read FTotalPartials write FTotalPartials;
    property MachineStops: TObjectList<TMachineStopModel> read FMachineStops write FMachineStops;


  end;

implementation

uses
  System.SysUtils;

{ TCellDataModel }

constructor TCellDataModel.Create;
begin
  FCellId := varEmpty;
  FCellCode := EmptyStr;
  FCellDescription := EmptyStr;
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
