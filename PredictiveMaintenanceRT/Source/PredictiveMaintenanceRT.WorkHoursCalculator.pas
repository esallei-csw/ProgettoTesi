unit PredictiveMaintenanceRT.WorkHoursCalculator;

interface

uses
  System.SysUtils, System.DateUtils, System.Generics.Collections;


type
  TWorkHoursCalculator = class
  private
    FHolidayList: TList<Double>;
    function IsHoliday(const ADate: Double): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function GetWorkHours(ADate: Double): Double;
    procedure AddHoliday(const AHoliday: Double);
  end;

implementation


constructor TWorkHoursCalculator.Create;
begin
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
function TWorkHoursCalculator.GetWorkHours(ADate: Double): Double;
var
  DayOfWeek: Integer;
begin
  // Determine the day of the week
  DayOfWeek := DayOfTheWeek(ADate);
  // Check if it's a weekend
  if (DayOfWeek = DaySaturday) or (DayOfWeek = DaySunday) then
    Exit(0);
  // Check if it's a holiday
  if IsHoliday(ADate) then
    Exit(0);
  // Otherwise, it's a standard workday
  Result := 8;
end;
end.
