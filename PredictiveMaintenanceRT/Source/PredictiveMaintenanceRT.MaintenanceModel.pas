unit PredictiveMaintenanceRT.MaintenanceModel;

interface

type
  TMaintenanceModel = class

  private
  {Private declarations}
    FDescription: string;
    FThresholdPieces: integer;
    FThresholdHoursWorked: Double;
    FThresholdDays: Integer;
    FThresholdMonths: Integer;
    FLastMaintenance: Double;

  public
  {Public declarations}
    constructor Create;
    property Description: string read FDescription write FDescription;
    property ThresholdPieces: integer read FThresholdPieces write FThresholdPieces;
    property ThresholdHoursWorked: Double read FThresholdHoursWorked write FThresholdHoursWorked;
    property ThresholdDays: Integer read FThresholdDays write FThresholdDays;
    property ThresholdMonths: Integer read FThresholdMonths write FThresholdMonths;
    property LastMaintenance: Double read FLastMaintenance write FLastMaintenance;


  end;

implementation

{ TMaintenanceModel }

uses
  System.SysUtils;

constructor TMaintenanceModel.Create;
begin
  FDescription := EmptyStr;
  FThresholdPieces := varEmpty;
  FThresholdHoursWorked := varEmpty;
  FThresholdDays := varEmpty;
  FThresholdMonths := varEmpty;
  FLastMaintenance := varEmpty;
end;

end.
