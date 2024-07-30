unit PredictiveMaintenanceRT.PartialModel;

interface

type
  TPartialModel = class
  private
    FPartialId: integer;
    FStartTime: Double;
    FEndTime: Double;
    FWorkHours: Double;
    FQuantity: Double;
  public
    constructor Create;

    property PartialId: integer read FPartialId write FPartialId;
    property StartTime: Double read FStartTime write FStartTime;
    property EndTime: Double read FEndTime write FEndTime;
    property WorkHours: Double read FWorkHours write FWorkHours;
    property Quantity: Double read FQuantity write FQuantity;
  end;

implementation

{ TPartial }

constructor TPartialModel.Create;
begin
  FPartialId := varEmpty;
  FStartTime := varEmpty;
  FEndTime := varEmpty;
  FWorkHours := varEmpty;
  FQuantity := varEmpty;
end;

end.
