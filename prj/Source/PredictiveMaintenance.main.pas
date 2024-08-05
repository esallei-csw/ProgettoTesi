unit PredictiveMaintenance.main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PredictiveMaintenanceRT.BusinessLogicInterface,
  PredictiveMaintenanceRT.BusinessLogic, Vcl.ComCtrls, PredictiveMaintenanceRT.ResultModel
  , System.Generics.Collections;

type
  TfrmPredictiveMaintenance = class(TForm)
    edtCellId: TEdit;
    lblCellId: TLabel;
    btnGetMaintenanceDate: TButton;
    lblMaintenanceDate: TLabel;
    cbUsePastData: TCheckBox;
    lvMaintenanceDates: TListView;
    lbWarningList: TListBox;
    lblWarningList: TLabel;
    procedure btnGetMaintenanceDateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvMaintenanceDatesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    FResultList: TList<TResultModel>;
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
  PredictiveMaintenanceRT.Constants, PredictiveMaintenanceRT.Messages;

procedure TfrmPredictiveMaintenance.btnGetMaintenanceDateClick(Sender: TObject);
var
  LListItem: TListItem;
  LResultItem: TResultModel;
begin
  FResultList := PredictiveMaintenance.GetMaintenanceDate(StrToInt(edtCellId.Text));

  lvMaintenanceDates.Items.BeginUpdate;

  try
    lvMaintenanceDates.Items.Clear;
    for LResultItem in FResultList do
    begin
      LListItem := lvMaintenanceDates.Items.Add;
      LListItem.Caption := LResultItem.Description;
      LListItem.subitems.add(DateTimeToStr(FloatToDateTime(LResultItem.MaintenanceDate)));
      LListItem.SubItems.Add(FloatToStr(LResultItem.Percent));
      LListItem.SubItems.Add(LResultItem.WarningList.ToString);
    end;
  finally
      lvMaintenanceDates.Items.EndUpdate;
    end;
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
procedure TfrmPredictiveMaintenance.lvMaintenanceDatesSelectItem(
  Sender: TObject; Item: TListItem; Selected: Boolean);
var
  LWarningString: string;
begin
  lblWarningList.Caption := WARNINGLIST + FResultList[item.Index].Description;
  lbWarningList.Items.Clear;
  for LWarningString in FResultList[Item.Index].WarningList do
    lbWarningList.Items.Add(LWarningString);
end;

end.
