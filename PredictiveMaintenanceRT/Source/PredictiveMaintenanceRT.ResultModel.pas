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
    FCellCode: string;
    FCellId: integer;
    FCellDescription: string;
    public
    {Public declarations}
    constructor Create;
    destructor Destroy; override;

    property CellId: integer read FCellId write FCellId;
    property CellCode: string read FCellCode write FCellCode;
    property CellDescription: string read FCellDescription write FCellDescription;
    property Description: string read FDescription write FDescription;
    property MaintenanceDate: Double read FMaintenanceDate write FMaintenanceDate;
    property Percent: Double read FPercent write FPercent;
    property WarningList: TList<string> read FWarningList write FWarningList;
  end;

implementation

uses
  System.SysUtils;

{ TResultModel }

constructor TResultModel.Create;
begin
  FCellId := varEmpty;
  FCellCode := EmptyStr;
  FCellDescription := EmptyStr;
  FDescription := EmptyStr;
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
