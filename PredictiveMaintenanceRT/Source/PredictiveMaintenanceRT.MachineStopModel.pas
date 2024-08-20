unit PredictiveMaintenanceRT.MachineStopModel;

interface

type
TMachineStopModel = class

  private
  {Private declarations}
  FID: integer;
  FIDCell: integer;
  FDataInizio: Double;
  FDataFine: Double;
  FOraInizio: Double;
  FOraFine: Double;
  FDurata: Double;
  public
  {Public declarations}
  constructor Create;

  property ID: integer read FID write FID;
  property IDCell: integer read FIDCell write FIDCell;
  property DataInizio: Double read FDataInizio write FDataInizio;
  property DataFine: Double read FDataFine write FDataFine;
  property OraInizio: Double read FOraInizio write FOraInizio;
  property OraFine: Double read FOraFine write FOraFine;
  property Durata: Double read FDurata write FDurata;

end;

implementation

{ TMachineStopsModel }

constructor TMachineStopModel.Create;
begin
  FID := varEmpty;
  FIDCell := varEmpty;
  FDataInizio := varEmpty;
  FDataFine := varEmpty;
  FOraInizio := varEmpty;
  FOraFine := varEmpty;
  FDurata := varEmpty;
end;

end.
