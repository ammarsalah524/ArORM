inherited PplCaCity: TPplCaCity
  ActiveControl = EdtSProvince
  Caption = 'PplCaCity'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 25
  inherited PnlMain: TPanel
    inherited PnlEditor: TPanel
      object EdtCode: TArStrEdit
        Left = 8
        Top = 51
        Width = 273
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
        Top = 90
        Width = 273
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
        Top = 129
        Width = 273
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
      object EdtSProvince: TArSearchEdit
        Left = 8
        Top = 12
        Width = 273
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        EditLabel.Width = 39
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1605#1606#1591#1602#1577
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        LoadCaption = False
        Caption = #1575#1604#1605#1606#1591#1602#1577
      end
    end
  end
end
