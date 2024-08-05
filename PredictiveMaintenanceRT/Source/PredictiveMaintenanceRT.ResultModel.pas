unit PredictiveMaintenanceRT.ResultModel;

interface

uses
  System.Generics.Collections;

type
  TResultModel = class

    private
    {Private declarations}
    FDescription: string;
    FMaintenanceDate: Double;
    FPercent: Double;
    FWarningList: TList<string>;
    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;
    property Description: string read FDescription write FDescription;
    property MaintenanceDate: Double read FMaintenanceDate write FMaintenanceDate;
    property Percent: Double read FPercent write FPercent;
    property WarningList: TList<string> read FWarningList write FWarningList;
  end;

implementation

{ TResultModel }

constructor TResultModel.Create;
begin
  FDescription := '';
  FMaintenanceDate := varEmpty;
  FPercent := varEmpty;
  FWarningList := TList<string>.Create;
end;

destructor TResultModel.Destroy;
begin
  FWarningList.Free;
  inherited;
end;

end.
