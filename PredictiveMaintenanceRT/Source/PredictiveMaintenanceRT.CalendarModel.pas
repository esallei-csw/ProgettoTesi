unit PredictiveMaintenanceRT.CalendarModel;

interface

type
TCalendarModel = class

  private
  {Private declarations}
    FID: integer;
    FIDCalendar: integer;
    FIDCell: integer;
    FDay: integer;
    FTotOre: Double;
    FStartDay: Double;


  public
  {Public declarations}
  constructor Create;

  property ID: integer read FID write FID;
  property IDCalendar: integer read FIDCalendar write FIDCalendar;
  property IDCell: integer read FIDCell write FIDCell;
  property Day: integer read FDay write FDay;
  property TotOre: Double read FTotOre write FTotOre;
  property StartDay: Double read FStartDay write FStartDay;

end;

implementation

{ TCalendarModel }

constructor TCalendarModel.Create;
begin
  FID := varEmpty;
  FIDCalendar := varEmpty;
  FIDCell := varEmpty;
  FDay := varEmpty;
  FTotOre := varEmpty;
  FStartDay := varEmpty;
end;

end.
