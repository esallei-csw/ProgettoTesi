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
  FStartDay: Double;


  public
  {Public declarations}
  constructor Create;

  property IDCelPro: integer read FIDCelPro write FIDCelPro;
  property IDCalendar: integer read FIDCalendar write FIDCalendar;
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
  FStartDay := varEmpty;
end;

end.
