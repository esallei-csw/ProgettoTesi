unit PredictiveMaintenanceRT.MachineStopsModel;

interface

type
TMachineStopsModel = class

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

constructor TMachineStopsModel.Create;
begin
  FID := 0;
  FIDCell := 0;
  FDataInizio := 0;
  FDataFine := 0;
  FOraInizio := 0;
  FOraFine := 0;
  FDurata := 0;
end;

end.
