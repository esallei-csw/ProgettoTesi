unit PredictiveMaintenanceRT.ProductionOrderModel;

interface

type
  TProductionOrderModel = class
    private
    {Private declarations}
    FPOID: integer;
    FPieces: Double;
    FWorkHours: Double;

    public
    {Public declarations}
    constructor Create;

    property POID: integer read FPOID write FPOID;
    property Pieces: Double read FPieces write FPieces;
    property WorkHours: Double read FWorkHours write FWorkHours;
  end;

implementation

{ TProductionOrderModel }

constructor TProductionOrderModel.Create;
begin
  FPOID := varEmpty;
  FPieces := varEmpty;
  FWorkHours := varEmpty;
end;

end.
