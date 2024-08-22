unit PredictiveMaintenanceRT.WorkHoursCalculator;

interface

uses
  System.SysUtils, System.DateUtils, System.Generics.Collections, PredictiveMaintenanceRT.QueryHandler,
  PredictiveMaintenanceRT.ClosedPeriodModel, PredictiveMaintenanceRT.CalendarDayModel,
  PredictiveMaintenanceRT.CalendarModel;


type
  TWorkHoursCalculator = class
  private
    FIDCell: integer;
    FHolidayList: TList<Double>;
    FQueryHandler: TQueryHandler;
    FClosedPeriods: TList<TClosedPeriodModel>;
    FDayCalendar: TList<TCalendarDayModel>;
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
var
  LDay: TCalendarDayModel;
  LCalendar: TCalendarModel;
begin

  //get only calendar
  //get week from calendar x
  //modificare i model e le query

  LDay := TCalendarDayModel.Create;
  FDayCalendar := QueryHandler.GetCalendarData(FIDCell);
  FCalendar := TList<TCalendarModel>.Create;
  LCalendar := TCalendarModel.Create;
  for LDay in FDayCalendar do
  begin
    if LCalendar.IDCalendar = 0 then
    begin
      LCalendar.IDCelPro := LDay.IDCell;
      LCalendar.IDCalendar := LDay.IDCalendar;
      LCalendar.StartDay := LDay.StartDay;
      LCalendar.DayOfWeek[LDay.Day] := LDay.TotOre;
    end
    else
      begin
      if LCalendar.IDCalendar <> LDay.IDCalendar then
      begin
        FCalendar.Add(LCalendar);
        LCalendar := TCalendarModel.Create;
        LCalendar.IDCelPro := LDay.IDCell;
        LCalendar.IDCalendar := LDay.IDCalendar;
        LCalendar.StartDay := LDay.StartDay;
        LCalendar.DayOfWeek[LDay.Day] := LDay.TotOre;
      end
      else
      begin
        LCalendar.DayOfWeek[LDay.Day] := LDay.TotOre;
      end;
    end;


  end;

end;

function TWorkHoursCalculator.IsHoliday(const ADate: Double): Boolean;
begin
  Result := FHolidayList.Contains(ADate);
end;

function TWorkHoursCalculator.GetCalendarWeek(ADate: Double): TList<Double>;
var
  LDateTmp: Double;
  LCalendar: TCalendarModel;
begin
  for LCalendar in FCalendar do
  begin
    if (LCalendar.StartDay < ADate) and (LCalendar.StartDay > LDateTmp) then
    begin
      LDateTmp := LCalendar.StartDay;
      Result := LCalendar.DayOfWeek;
    end;
  end;
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
