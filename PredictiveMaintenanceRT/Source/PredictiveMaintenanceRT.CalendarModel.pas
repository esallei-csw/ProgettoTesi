unit PredictiveMaintenanceRT.CalendarModel;

interface

uses
  System.Generics.Collections;

type
  TCalendarModel = class

  private
  {Private declarations}
  FIDCelPro: integer;
  FIDCalendar: integer;
//  FDayOfWeek: TList<Double>;
  FStartDay: Double;


  public
  {Public declarations}
  constructor Create;

  property IDCelPro: integer read FIDCelPro write FIDCelPro;
  property IDCalendar: integer read FIDCalendar write FIDCalendar;
//  property DayOfWeek: TList<Double> read FDayOfWeek write FDayOfWeek;
  property StartDay: Double read FStartDay write FStartDay;

end;

implementation

{ TCalendarModel }

constructor TCalendarModel.Create;
var
  I: integer;
begin
  FIDCelPro := varEmpty;
  FIDCalendar := varEmpty;
//  FDayOfWeek := TList<Double>.Create;
  FStartDay := varEmpty;
  //inizializzo la lista dei giorni della settimana
//  for I := 0 to 7 do
//  begin
//    FDayOfWeek.Add(0);
//  end;
end;

end.
