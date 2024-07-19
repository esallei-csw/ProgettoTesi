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
    procedure btnGetMaintenanceDateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FPredictiveMaintenance: IPredictiveMaintenance;

    function GetPredictiveMaintenance: IPredictiveMaintenance;
    property PredictiveMaintenance: IPredictiveMaintenance read GetPredictiveMaintenance write FPredictiveMaintenance;
  public
    { Public declarations }
  end;

var
  frmPredictiveMaintenance: TfrmPredictiveMaintenance;

implementation

{$R *.dfm}

uses
  PredictiveMaintenanceRT.Constants;

procedure TfrmPredictiveMaintenance.btnGetMaintenanceDateClick(Sender: TObject);
var
  LDate: TDateTime;
begin
  LDate := FloatToDateTime(PredictiveMaintenance.GetMaintenanceDate(StrToInt(edtCellId.Text)));
  edtMaintenanceDate.Text := DateTimeToStr(LDate);
end;

procedure TfrmPredictiveMaintenance.FormCreate(Sender: TObject);
begin
  edtCellId.Text := inttostr(DEFAULT_CELLID);
end;

function TfrmPredictiveMaintenance.GetPredictiveMaintenance: IPredictiveMaintenance;
begin
  if not Assigned(FPredictiveMaintenance) then
    FPredictiveMaintenance := TPredictiveMaintenance.Create;
  Result := FPredictiveMaintenance;
end;

end.
