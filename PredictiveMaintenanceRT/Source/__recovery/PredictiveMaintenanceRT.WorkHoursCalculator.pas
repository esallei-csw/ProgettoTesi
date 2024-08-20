unit PredictiveMaintenanceRT.WorkHoursCalculator;

interface

uses
  System.SysUtils, System.DateUtils, System.Generics.Collections, PredictiveMaintenanceRT.QueryHandler,
  PredictiveMaintenanceRT.ClosedPeriodModel, PredictiveMaintenanceRT.CalendarModel;


type
  TWorkHoursCalculator = class
  private
    FIDCell: integer;
    FHolidayList: TList<Double>;
    FQueryHandler: TQueryHandler;
    FClosedPeriods: TList<TClosedPeriodModel>;
    FCalendar: TList<TCalendarModel>;
    function IsHoliday(const ADate: Double): Boolean;

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
var
  I: Integer;
begin
  FIDCell := ACellId;
  FHolidayList := TList<Double>.Create;
  FClosedPeriods := QueryHandler.GetClosedPeriods(FIDCell);
  FCalendar := QueryHandler.GetCalendarData(FIDCell);
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

function TWorkHoursCalculator.GetQueryHandler: TQueryHandler;
begin
  if not Assigned(FQueryHandler) then
    FQueryHandler := TQueryHandler.Create;
  Result := FQueryHandler;
end;

function TWorkHoursCalculator.GetWorkHours(ADate: Double): Double;
var
  LDayOfWeek: Integer;
  LDay: TCalendarModel;
begin
  if IsHoliday(ADate) then
    Exit(0);

  // Determine the day of the week
  LDayOfWeek := DayOfTheWeek(ADate);

  for LDay in FCalendar do
  begin
    if LDayOfWeek = LDay.Day then
      Exit(LDay.TotOre);
  end;
  Result := 0;
end;
end.
