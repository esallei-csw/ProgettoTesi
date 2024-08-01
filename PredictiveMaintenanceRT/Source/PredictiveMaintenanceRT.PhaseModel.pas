unit PredictiveMaintenanceRT.PhaseModel;

interface

type
  TPhaseModel = class

    private
    {Private declarations}
    FPOID: integer;
    FPhaseID: integer;
    FArticleID: integer;
    FWorkTime: Double;
    FQuantity: Double;
    public
    {Public declarations}
    constructor Create;
    property POID: integer read FPOID write FPOID;
    property PhaseID: integer read FPhaseID write FPhaseID;
    property ArticleID: integer read FArticleID write FArticleID;
    property WorkTime: Double read FWorkTime write FWorkTime;
    property Quantity: Double read FQuantity write FQuantity;
  end;

implementation

{ TPhaseModel }

constructor TPhaseModel.Create;
begin
  FPOID := varEmpty;
  FPhaseID := varEmpty;
  FArticleID := varEmpty;
  FWorkTime := varEmpty;
  FQuantity := varEmpty;
end;

end.
