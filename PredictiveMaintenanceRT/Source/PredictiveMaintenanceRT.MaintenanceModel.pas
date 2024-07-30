unit PredictiveMaintenanceRT.MaintenanceModel;

interface

type
  TMaintenanceModel = class

  private
  {Private declarations}
    FThresholdPieces: integer;
    FThresholdHoursWorked: Double;
    FThresholdDays: Integer;
    FThresholdMonths: Integer;
    FLastMaintenance: Double;

  public
  {Public declarations}
    constructor Create;
    property ThresholdPieces: integer read FThresholdPieces write FThresholdPieces;
    property ThresholdHoursWorked: Double read FThresholdHoursWorked write FThresholdHoursWorked;
    property ThresholdDays: Integer read FThresholdDays write FThresholdDays;
    property ThresholdMonths: Integer read FThresholdMonths write FThresholdMonths;
    property LastMaintenance: Double read FLastMaintenance write FLastMaintenance;

    function Clone: TMaintenanceModel;


  end;

implementation

{ TMaintenanceModel }

function TMaintenanceModel.Clone: TMaintenanceModel;
begin
  Result := TMaintenanceModel.Create;
  Result.FThresholdPieces := Self.FThresholdPieces;
  Result.FThresholdHoursWorked := Self.FThresholdHoursWorked;
  Result.FThresholdDays := Self.FThresholdDays;
  Result.FThresholdMonths := Self.FThresholdMonths;
  Result.FLastMaintenance := Self.FLastMaintenance;
end;

constructor TMaintenanceModel.Create;
begin
  FThresholdPieces := varEmpty;
  FThresholdHoursWorked := varEmpty;
  FThresholdDays := varEmpty;
  FThresholdMonths := varEmpty;
  FLastMaintenance := varEmpty;
end;

end.
