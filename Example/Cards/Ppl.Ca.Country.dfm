inherited PplCaCountry: TPplCaCountry
  Caption = 'PplCaCountry'
  ClientHeight = 612
  ClientWidth = 810
  OnCreate = FormCreate
  ExplicitWidth = 826
  ExplicitHeight = 650
  PixelsPerInch = 96
  TextHeight = 25
  inherited PnlMain: TPanel
    Width = 707
    Height = 612
    ExplicitWidth = 707
    ExplicitHeight = 612
    inherited PnlNavigator: TPanel
      Width = 707
      ExplicitWidth = 707
    end
    inherited PnlEditor: TPanel
      Width = 707
      Height = 577
      ExplicitWidth = 707
      ExplicitHeight = 577
      object EdtCode: TArStrEdit
        Left = 8
        Top = 6
        Width = 599
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 29
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1585#1605#1586
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 0
        LabelVisible = True
        LabelCaption = #1575#1604#1585#1605#1586
        LoadCaption = True
        Caption = #1575#1604#1585#1605#1586
      end
      object EdtNameAR: TArStrEdit
        Left = 8
        Top = 45
        Width = 599
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 53
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
      object EdtNameEN: TArStrEdit
        Left = 8
        Top = 84
        Width = 599
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 60
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1575#1587#1605' (en)'
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 2
        LabelVisible = True
        LabelCaption = #1575#1604#1575#1587#1605' (en)'
        LoadCaption = True
        Caption = #1575#1604#1575#1587#1605' (en)'
      end
      object EdtNationalityAR: TArStrEdit
        Left = 8
        Top = 123
        Width = 599
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 68
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1580#1606#1587#1610#1577' ('#1593')'
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 3
        LabelVisible = True
        LabelCaption = #1575#1604#1580#1606#1587#1610#1577' ('#1593')'
        LoadCaption = True
        Caption = #1575#1604#1580#1606#1587#1610#1577' ('#1593')'
      end
      object EdtNationalityEN: TArStrEdit
        Left = 8
        Top = 162
        Width = 599
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 75
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1575#1604#1580#1606#1587#1610#1577' (en)'
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 4
        LabelVisible = True
        LabelCaption = #1575#1604#1580#1606#1587#1610#1577' (en)'
        LoadCaption = True
        Caption = #1575#1604#1580#1606#1587#1610#1577' (en)'
      end
      object EdtCallingCode: TArStrEdit
        Left = 8
        Top = 201
        Width = 599
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 81
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = #1605#1601#1578#1575#1581' '#1575#1604#1575#1578#1589#1575#1604
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpRight
        TabOrder = 5
        LabelVisible = True
        LabelCaption = #1605#1601#1578#1575#1581' '#1575#1604#1575#1578#1589#1575#1604
        LoadCaption = True
        Caption = #1605#1601#1578#1575#1581' '#1575#1604#1575#1578#1589#1575#1604
      end
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 4
        Top = 243
        Width = 699
        Height = 330
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'GroupBox1'
        TabOrder = 6
      end
    end
  end
  inherited PnlController: TPanel
    Left = 707
    Height = 612
    ExplicitLeft = 707
    ExplicitHeight = 612
    inherited BtnExit: TButton
      Top = 574
      ExplicitTop = 574
    end
  end
end
