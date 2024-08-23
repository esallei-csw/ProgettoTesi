unit PredictiveMaintenanceRT.WorkHoursCalculator;

interface

uses
  System.SysUtils, System.DateUtils, System.Generics.Collections, PredictiveMaintenanceRT.QueryHandler,
  PredictiveMaintenanceRT.ClosedPeriodModel,
  PredictiveMaintenanceRT.CalendarModel;


type
  TWorkHoursCalculator = class
  private
    FIDCell: integer;
    FHolidayList: TList<Double>;
    FQueryHandler: TQueryHandler;
    FClosedPeriods: TList<TClosedPeriodModel>;
    FCalendar: TList<TCalendarModel>;
    function IsHoliday(const ADate: Double): Boolean;
    procedure AddClosedPeriods;
    procedure InitializeCalendar;
    function GetCalendarWeek(ADate: Double): TList<Double>;

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
  AddClosedPeriods;
  InitializeCalendar;
end;
destructor TWorkHoursCalculator.Destroy;
begin
  FHolidayList.Free;
  inherited;
end;
procedure TWorkHoursCalculator.AddClosedPeriods;
var
  LClosedPeriod: TClosedPeriodModel;
  LCPDay: Double;
begin
  FClosedPeriods := QueryHandler.GetClosedPeriods(FIDCell);

  for LClosedPeriod in FClosedPeriods do
  begin
    LCPDay := LClosedPeriod.DataInizio;
    while LCPDay <> LClosedPeriod.DataFine do
    begin
      AddHoliday(LCPDay);
      LCPDay := LCPDay + 1;
    end;
  end;
end;

procedure TWorkHoursCalculator.AddHoliday(const AHoliday: Double);
begin
  FHolidayList.Add(AHoliday);
end;
procedure TWorkHoursCalculator.InitializeCalendar;
begin
  FCalendar := QueryHandler.GetCalendarData(FIDCell);
end;

function TWorkHoursCalculator.IsHoliday(const ADate: Double): Boolean;
begin
  Result := FHolidayList.Contains(ADate);
end;

function TWorkHoursCalculator.GetCalendarWeek(ADate: Double): TList<Double>;
var
  LCalendar: TCalendarModel;
  LDateTmp: Double;
  LResultID: integer;
begin
  //check fcalendar and find correct calendar
  for LCalendar in FCalendar do
  begin
    if (LCalendar.StartDay < ADate) and (LCalendar.StartDay > LDateTmp) then
    begin
      LDateTmp := LCalendar.StartDay;
      LResultID := LCalendar.IDCalendar;
    end;
  end;
  //get calendar week of that calendar
  Result := QueryHandler.GetWeekCalendar(LResultID);
end;

function TWorkHoursCalculator.GetQueryHandler: TQueryHandler;
begin
  if not Assigned(FQueryHandler) then
    FQueryHandler := TQueryHandler.Create;
  Result := FQueryHandler;
end;

function TWorkHoursCalculator.GetWorkHours(ADate: Double): Double;
begin
  if IsHoliday(ADate) then
    Exit(0);

  Result := GetCalendarWeek(ADate)[DayOfTheWeek(ADate)];
end;
end.
