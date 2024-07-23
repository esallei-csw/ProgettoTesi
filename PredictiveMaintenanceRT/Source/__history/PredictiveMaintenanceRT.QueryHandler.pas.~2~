unit PredictiveMaintenanceRT.QueryHandler;

interface

uses
  PredictiveMaintenanceRT.CellDataModel, PredictiveMaintenanceRT.PartialModel, Data.Win.ADODB, System.Generics.Collections,
  PredictiveMaintenanceRT.QueryExecutor;

type
  TQueryHandler = class

  private
  {Private declarations}
    FQueryExecutor: TQueryExecutor;

    function QueryToList(AQuery : TADOQuery): TList<TPartialModel>;

    function GetQueryExecutor: TQueryExecutor;
    property QueryExecutor: TQueryExecutor read GetQueryExecutor write FQueryExecutor;

  public
  {Public declarations}
    function PopulateCellModel(ACell :TCellDataModel): TCellDataModel;
  end;

implementation

{ TQueryHandler }
uses
  PredictiveMaintenanceRT.Constants, System.SysUtils, PredictiveMaintenanceRT.Messages;

function TQueryHandler.GetQueryExecutor: TQueryExecutor;
begin
  if not Assigned(FQueryExecutor) then
    FQueryExecutor := TQueryExecutor.Create(DEFAULT_USERNAME, DEFAULT_PASSWORD, DB_NAME, SERVER_NAME);
  Result := FQueryExecutor;
end;

function TQueryHandler.PopulateCellModel(ACell: TCellDataModel): TCellDataModel;
var
  LData: TADOQuery;
begin
  try
    LData := QueryExecutor.ExecuteQuery(Format(QUERY_PARTIALS, [intToStr(ACell.CellId)]));
    if LData <> nil then
      ACell.Partials := QueryToList(LData)
    else
      raise Exception.Create(SQL_DATA_NOTFOUND);
    Result := ACell;
  finally
    LData.Free;
  end;

end;

function TQueryHandler.QueryToList(AQuery: TADOQuery): TList<TPartialModel>;
var
  LPartials: TList<TPartialModel>;
  LPartial: TPartialModel;
begin
  LPartials := TList<TPartialModel>.Create;
  LPartial := TPartialModel.Create;
  try
    if not AQuery.Active then
      raise Exception.Create(DATASET_CLOSED);
    AQuery.First;
    while not AQuery.Eof do
    begin
      LPartial.PartialId := AQuery.FieldByName(PARTIAL_ID).AsInteger;
      LPartial.CellId := AQuery.FieldByName(PARTIAL_CELLID).AsInteger;
      LPartial.StartTime := AQuery.FieldByName(PARTIAL_START).AsFloat;
      LPartial.WorkHours := AQuery.FieldByName(PARTIAL_WORKHOURS).AsFloat;
      LPartial.EndTime := AQuery.FieldByName(PARTIAL_END).AsFloat;
      LPartial.Quantity := AQuery.FieldByName(PARTIAL_QUANTITY).AsFloat;
      LPartials.Add(LPartial);
      AQuery.Next;
    end;
    Result := LPartials;
  finally
//    LPartials.Free;
    LPartial.Free;
  end;
end;

end.
