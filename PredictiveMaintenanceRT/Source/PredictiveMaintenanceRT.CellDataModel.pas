unit PredictiveMaintenanceRT.CellDataModel;

interface

uses
  PredictiveMaintenanceRT.PartialModel, System.Generics.Collections, PredictiveMaintenanceRT.MaintenanceModel;

type
  TCellDataModel = class
    private
    {Private declarations}
    FCellId: integer;
    FMaintenanceData: TMaintenanceModel;
    FPartials: TList<TPartialModel>;


    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;
    property CellId: integer read FCellId write FCellId;

    property MaintenanceData: TMaintenanceModel read FMaintenanceData write FMaintenanceData;

    property Partials: TList<TPartialModel> read FPartials write FPartials;


  end;

implementation

{ TCellDataModel }

constructor TCellDataModel.Create;
begin
  FCellId := varEmpty;
  FMaintenanceData := TMaintenanceModel.Create;
  FPartials := TList<TPartialModel>.Create;
end;

destructor TCellDataModel.Destroy;
begin
  FMaintenanceData.Free;
  FPartials.Free;
  inherited;
end;

end.
