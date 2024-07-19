unit PredictiveMaintenanceRT.CellDataModel;

interface

uses
  PredictiveMaintenanceRT.PartialModel;

type
  TCellDataModel = class
    private
    {Private declarations}
    FCellId: integer;
    FThresholdPieces: integer;
    FThresholdHoursWorked: Extended;
    FLastMaintenance: Extended;
    FDaysToMaintenance: Extended;
    FPartials: TArray<TPartialModel>;


    public
    {Public declarations}
    constructor Create;
    property CellId: integer read FCellId write FCellId;
    property ThresholdPieces: integer read FThresholdPieces write FThresholdPieces;
    property ThresholdHoursWorked: Extended read FThresholdHoursWorked write FThresholdHoursWorked;
    property LastMaintenance: Extended read FLastMaintenance write FLastMaintenance;
    property DaysToMaintenance: Extended read FDaysToMaintenance write FDaysToMaintenance;
    property Partials: TArray<TPartialModel> read FPartials write FPartials;


  end;

implementation

{ TCellDataModel }

constructor TCellDataModel.Create;
begin
  FCellId := varEmpty;
  FThresholdPieces := varEmpty;
  FThresholdHoursWorked := varEmpty;
  FLastMaintenance := varEmpty;
  FDaysToMaintenance := varEmpty;
  FPartials := nil;
end;

end.
