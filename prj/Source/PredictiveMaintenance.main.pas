unit PredictiveMaintenance.main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PredictiveMaintenanceRT.BusinessLogicInterface,
  PredictiveMaintenanceRT.BusinessLogic;

type
  TfrmPredictiveMaintenance = class(TForm)
    edtCellId: TEdit;
    lblCellId: TLabel;
    btnGetMaintenanceDate: TButton;
    edtMaintenanceDate: TEdit;
    lblMaintenanceDate: TLabel;
    lbMaintenanceDates: TListBox;
    procedure btnGetMaintenanceDateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FPredictiveMaintenance: TPredictiveMaintenance;


    function GetPredictiveMaintenance: TPredictiveMaintenance;
    property PredictiveMaintenance: TPredictiveMaintenance read GetPredictiveMaintenance write FPredictiveMaintenance;
  public
    { Public declarations }
  end;

var
  frmPredictiveMaintenance: TfrmPredictiveMaintenance;

implementation

{$R *.dfm}

uses
  PredictiveMaintenanceRT.Constants, System.Generics.Collections;

procedure TfrmPredictiveMaintenance.btnGetMaintenanceDateClick(Sender: TObject);
var
  LDate: TDateTime;
  LDoubleList: TList<Double>;
  LDateList: TList<TDateTime>;
  I: Integer;
begin
  LDoubleList := PredictiveMaintenance.GetMaintenanceDate(StrToInt(edtCellId.Text));

  for I := 0 to LDateList.Count do
  begin
    LDateList.Add(FloatToDateTime(LDoubleList[I]));
    lbMaintenanceDates.Items.Add(DateTimeToStr(LDateList[I]));
  end;




//  LDate := FloatToDateTime(PredictiveMaintenance.GetMaintenanceDate(StrToInt(edtCellId.Text)));
//  edtMaintenanceDate.Text := DateTimeToStr(LDate);
end;

procedure TfrmPredictiveMaintenance.FormCreate(Sender: TObject);
begin
  edtCellId.Text := inttostr(DEFAULT_CELLID);
  FPredictiveMaintenance := nil;
end;

procedure TfrmPredictiveMaintenance.FormDestroy(Sender: TObject);
begin
  if Assigned(FPredictiveMaintenance) then
    FPredictiveMaintenance.Free;
end;

function TfrmPredictiveMaintenance.GetPredictiveMaintenance: TPredictiveMaintenance;
begin
  if not Assigned(FPredictiveMaintenance) then
    FPredictiveMaintenance := TPredictiveMaintenance.Create;
  Result := FPredictiveMaintenance;
end;
end.
