unit PredictiveMaintenanceRT.ProductionOrderModel;

interface

uses
  system.Generics.Collections, PredictiveMaintenanceRT.PhaseModel;

type
  TProductionOrderModel = class
    private
    {Private declarations}
    FPOID: integer;
    FPieces: Double;
    FWorkHours: Double;
    FPhases: TObjectList<TPhaseModel>;

    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;

    property POID: integer read FPOID write FPOID;
    property Pieces: Double read FPieces write FPieces;
    property WorkHours: Double read FWorkHours write FWorkHours;
    property Phases: TObjectList<TPhaseModel> read FPhases write FPhases;
  end;

implementation

{ TProductionOrderModel }

constructor TProductionOrderModel.Create;
begin
  FPOID := varEmpty;
  FPieces := varEmpty;
  FWorkHours := varEmpty;
  FPhases := nil;
end;

destructor TProductionOrderModel.Destroy;
begin
  FPhases.Free;
  inherited;
end;

end.
