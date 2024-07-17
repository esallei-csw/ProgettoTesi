unit PredictiveMaintenance.main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls
  , PredictiveMaintenanceRT.BusinessLogicInterface, PredictiveMaintenanceRT.BusinessLogic ;

type
  TfrmPredictiveMaintenance = class(TForm)
    edtCellId: TEdit;
    lblCellId: TLabel;
    btnGetMaintenanceDate: TButton;
    edtMaintenanceDate: TEdit;
    lblMaintenanceDate: TLabel;
    procedure btnGetMaintenanceDateClick(Sender: TObject);
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

procedure TfrmPredictiveMaintenance.btnGetMaintenanceDateClick(Sender: TObject);
begin
  edtMaintenanceDate.Text := PredictiveMaintenance.GetMaintenanceDate(edtCellId.Text);
end;

function TfrmPredictiveMaintenance.GetPredictiveMaintenance: IPredictiveMaintenance;
begin
  if not Assigned(FPredictiveMaintenance) then
    FPredictiveMaintenance := TPredictiveMaintenance.Create;
  Result := FPredictiveMaintenance;
end;

end.
