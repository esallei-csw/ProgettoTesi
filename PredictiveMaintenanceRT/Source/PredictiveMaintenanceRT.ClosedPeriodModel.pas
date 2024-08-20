unit PredictiveMaintenanceRT.ClosedPeriodModel;

interface

type
  TClosedPeriodModel = class

    private
    {Private declarations}
    FID: integer;
    FIDCell: integer;
    FDataInizio: Double;
    FDataFine: Double;
    FTipo: string;
    FDuration: Double;

    public
    {Public declarations}
    constructor Create;

    property ID: integer read FID write FID;
    property IDCell: integer read FIDCell write FIDCell;
    property DataInizio: Double read FDataInizio write FDataInizio;
    property DataFine: Double read FDataFine write FDataFine;
    property Tipo: string read FTipo write FTipo;
    property Duration: Double read FDuration write FDuration;
  end;

implementation

{ ClosedPeriodModel }

constructor TClosedPeriodModel.Create;
begin
  FID := varEmpty;
  FIDCell := varEmpty;
  FDataInizio := varEmpty;
  FDataFine := varEmpty;
  FTipo := '';
  FDuration := varEmpty;
end;

end.
