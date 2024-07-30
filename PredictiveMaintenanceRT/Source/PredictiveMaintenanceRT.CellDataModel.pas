unit PredictiveMaintenanceRT.CellDataModel;

interface

uses
  PredictiveMaintenanceRT.PartialModel, System.Generics.Collections, PredictiveMaintenanceRT.MaintenanceModel, PredictiveMaintenanceRT.ProductionOrderModel;

type
  TCellDataModel = class
    private
    {Private declarations}
    FCellId: integer;
    FMaintenanceData: TList<TMaintenanceModel>;
    FPartials: TList<TPartialModel>;
    FProductionOrders: TList<TProductionOrderModel>;


    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;
    property CellId: integer read FCellId write FCellId;

    property MaintenanceData: TList<TMaintenanceModel> read FMaintenanceData write FMaintenanceData;

    property Partials: TList<TPartialModel> read FPartials write FPartials;

    property ProductionOrders: TList<TProductionOrderModel> read FProductionOrders write FProductionOrders;


  end;

implementation

{ TCellDataModel }

constructor TCellDataModel.Create;
begin
  FCellId := varEmpty;
  FMaintenanceData := TList<TMaintenanceModel>.Create;
  FPartials := TList<TPartialModel>.Create;
  FProductionOrders := TList<TProductionOrderModel>.Create;
end;

destructor TCellDataModel.Destroy;
begin
  FMaintenanceData.Free;
  FPartials.Free;
  FProductionOrders.Free;
  inherited;
end;

end.
