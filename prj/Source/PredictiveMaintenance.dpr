program PredictiveMaintenance;

uses
  Vcl.Forms,
  PredictiveMaintenance.main in 'PredictiveMaintenance.main.pas' {frmPredictiveMaintenance};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;


  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPredictiveMaintenance, frmPredictiveMaintenance);
  Application.Run;
end.
