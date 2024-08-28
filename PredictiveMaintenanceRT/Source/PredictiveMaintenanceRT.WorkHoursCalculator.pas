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
    FCalendar: TList<TCalendarModel>;
    function IsHoliday(const ADate: Double): Boolean;
    procedure AddClosedPeriods;
    function GetCalendarWeek(ADate: Double): Double;

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
  FCalendar := QueryHandler.GetCalendarData(FIDCell);
end;
destructor TWorkHoursCalculator.Destroy;
begin
  FHolidayList.Free;
  if Assigned(FQueryHandler) then
    FQueryHandler.Free;
  FCalendar.Free;

  inherited;
end;
procedure TWorkHoursCalculator.AddClosedPeriods;
var
  LClosedPeriod: TClosedPeriodModel;
  LClosedPeriods: TList<TClosedPeriodModel>;
  LCPDay: Double;
begin
  LClosedPeriod := TClosedPeriodModel.Create;
  LClosedPeriods := QueryHandler.GetClosedPeriods(FIDCell);
  try
    for LClosedPeriod in LClosedPeriods do
    begin
      LCPDay := LClosedPeriod.DataInizio;
      while LCPDay <> LClosedPeriod.DataFine do
      begin
        AddHoliday(LCPDay);
        LCPDay := LCPDay + 1;
      end;
    end;
  finally
    LClosedPeriod.Free;
    LClosedPeriods.Free;
  end;
end;

procedure TWorkHoursCalculator.AddHoliday(const AHoliday: Double);
begin
  FHolidayList.Add(AHoliday);
end;

function TWorkHoursCalculator.IsHoliday(const ADate: Double): Boolean;
begin
  Result := FHolidayList.Contains(ADate);
end;

function TWorkHoursCalculator.GetCalendarWeek(ADate: Double): Double;
var
  LCalendar: TCalendarModel;
  LResCalendar: TCalendarModel;
begin

  LResCalendar := nil;
  //select correct calendar for ADate
  for LCalendar in FCalendar do
  begin
    if (LCalendar.StartDay <= ADate) and ( ( LResCalendar = nil ) or (LCalendar.StartDay > LResCalendar.StartDay ) )then
      LResCalendar := LCalendar
    else if ( LCalendar.StartDay > ADate ) then
      Break;
  end;

  LResCalendar.HourDaily.TryGetValue(
    DayOfTheWeek(ADate)
    , Result
  );

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

  Result := GetCalendarWeek(ADate);
end;
end.
