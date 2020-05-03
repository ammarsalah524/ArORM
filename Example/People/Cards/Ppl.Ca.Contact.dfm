inherited PplCaContact: TPplCaContact
  ActiveControl = EdtSNationality
  Caption = 'PplCaC'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 25
  inherited PnlMain: TPanel
    inherited PnlEditor: TPanel
      DesignSize = (
        381
        327)
      object EdtSNationality: TArSearchEdit
        Left = 8
        Top = 6
        Width = 281
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        EditLabel.Width = 46
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1580#1606#1587#1610#1577
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        LoadCaption = True
        Caption = #1575#1604#1580#1606#1587#1610#1577
      end
      object EdtNameEN: TArStrEdit
        Left = 8
        Top = 84
        Width = 281
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 61
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1575#1587#1605' (EN)'
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 2
        LabelVisible = True
        LabelCaption = #1575#1604#1575#1587#1605' (EN)'
        LoadCaption = True
        Caption = #1575#1604#1575#1587#1605' (EN)'
      end
      object EdtNameAR: TArStrEdit
        Left = 8
        Top = 45
        Width = 281
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 52
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1575#1587#1605' ('#1593')'
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 1
        LabelVisible = True
        LabelCaption = #1575#1604#1575#1587#1605' ('#1593')'
        LoadCaption = True
        Caption = #1575#1604#1575#1587#1605' ('#1593')'
      end
    end
  end
end
