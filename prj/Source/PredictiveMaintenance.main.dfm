object frmPredictiveMaintenance: TfrmPredictiveMaintenance
  Left = 0
  Top = 0
  Caption = 'Predictive Maintenance'
  ClientHeight = 364
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblCellId: TLabel
    Left = 24
    Top = 21
    Width = 30
    Height = 13
    Caption = 'Cell Id'
  end
  object lblMaintenanceDate: TLabel
    Left = 151
    Top = 21
    Width = 87
    Height = 13
    Caption = 'Maintenance Date'
  end
  object edtCellId: TEdit
    Left = 24
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Cell Id'
  end
  object btnGetMaintenanceDate: TButton
    Left = 24
    Top = 67
    Width = 121
    Height = 54
    Caption = 'Get Maintenance Date'
    TabOrder = 1
    OnClick = btnGetMaintenanceDateClick
  end
  object edtMaintenanceDate: TEdit
    Left = 151
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Maintenance Date'
  end
end
