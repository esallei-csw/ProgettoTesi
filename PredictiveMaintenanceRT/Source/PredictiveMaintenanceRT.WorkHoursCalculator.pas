unit PredictiveMaintenanceRT.WorkHoursCalculator;

interface

uses
  System.SysUtils, System.DateUtils, System.Generics.Collections, PredictiveMaintenanceRT.QueryHandler,
  PredictiveMaintenanceRT.ClosedPeriodModel;


type
  TWorkHoursCalculator = class
  private
    FIDCell: integer;
    FHolidayList: TList<Double>;
    FQueryHandler: TQueryHandler;
    FClosedPeriods: TList<TClosedPeriodModel>;
    function IsHoliday(const ADate: Double): Boolean;
    procedure GetData;

    function GetQueryHandler: TQueryHandler;
    property QueryHandler: TQueryHandler read GetQueryHandler write FQueryHandler;

  public
    constructor Create(ACellId: integer);
    destructor Destroy; override;
    function GetWorkHours(ADate: Double): Double;
    procedure AddHoliday(const AHoliday: Double);
  end;

implementation


constructor TWorkHoursCalculator.Create(ACellId: integer);
begin
  FIDCell := ACellId;
  FHolidayList := TList<Double>.Create;
end;
destructor TWorkHoursCalculator.Destroy;
begin
  FHolidayList.Free;
  inherited;
end;
procedure TWorkHoursCalculator.AddHoliday(const AHoliday: Double);
begin
  FHolidayList.Add(AHoliday);
end;
function TWorkHoursCalculator.IsHoliday(const ADate: Double): Boolean;
begin
  Result := FHolidayList.Contains(ADate);
end;
procedure TWorkHoursCalculator.GetData;
begin
end;

function TWorkHoursCalculator.GetQueryHandler: TQueryHandler;
begin
  if not Assigned(FQueryHandler) then
    FQueryHandler := TQueryHandler.Create;
  Result := FQueryHandler;
end;

function TWorkHoursCalculator.GetWorkHours(ADate: Double): Double;
var
  DayOfWeek: Integer;
begin
  if IsHoliday(ADate) then
    Exit(0);

  // Determine the day of the week
  DayOfWeek := DayOfTheWeek(ADate);
  // Check if it's a weekend
  if (DayOfWeek = DaySaturday) or (DayOfWeek = DaySunday) then
    Exit(0);
  // Otherwise, it's a standard workday
  Result := 8;
end;
end.
