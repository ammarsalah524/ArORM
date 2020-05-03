inherited PplCaProvince: TPplCaProvince
  Caption = 'PplCaProvince'
  ClientWidth = 499
  OnCreate = FormCreate
  ExplicitWidth = 515
  PixelsPerInch = 96
  TextHeight = 25
  inherited PnlMain: TPanel
    Width = 396
    ExplicitWidth = 396
    inherited PnlNavigator: TPanel
      Width = 396
      ExplicitWidth = 396
    end
    inherited PnlEditor: TPanel
      Width = 396
      ExplicitWidth = 396
      object EdtCode: TArStrEdit
        Left = 8
        Top = 45
        Width = 288
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 29
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1585#1605#1586
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 1
        LabelVisible = True
        LabelCaption = #1575#1604#1585#1605#1586
        LoadCaption = True
        Caption = #1575#1604#1585#1605#1586
      end
      object EdtNameAR: TArStrEdit
        Left = 8
        Top = 84
        Width = 288
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 53
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1575#1587#1605' ('#1593')'
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 2
        LabelVisible = True
        LabelCaption = #1575#1604#1575#1587#1605' ('#1593')'
        LoadCaption = True
        Caption = #1575#1604#1575#1587#1605' ('#1593')'
      end
      object EdtNameEN: TArStrEdit
        Left = 8
        Top = 123
        Width = 288
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 60
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1575#1587#1605' (en)'
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 3
        LabelVisible = True
        LabelCaption = #1575#1604#1575#1587#1605' (en)'
        LoadCaption = True
        Caption = #1575#1604#1575#1587#1605' (en)'
      end
      object EdtCallingCode: TArStrEdit
        Left = 8
        Top = 162
        Width = 288
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 81
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1605#1601#1578#1575#1581' '#1575#1604#1575#1578#1589#1575#1604
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 4
        LabelVisible = True
        LabelCaption = #1605#1601#1578#1575#1581' '#1575#1604#1575#1578#1589#1575#1604
        LoadCaption = True
        Caption = #1605#1601#1578#1575#1581' '#1575#1604#1575#1578#1589#1575#1604
      end
      object EdtSCountry: TArSearchEdit
        Left = 8
        Top = 6
        Width = 288
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        EditLabel.Width = 25
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1576#1604#1583
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        LoadCaption = False
        Caption = #1575#1604#1576#1604#1583
      end
    end
  end
  inherited PnlController: TPanel
    Left = 396
    ExplicitLeft = 396
  end
  inherited DaEntity: TArDaEntity
    Top = 115
  end
end
