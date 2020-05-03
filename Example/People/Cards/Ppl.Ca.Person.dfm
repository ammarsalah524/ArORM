inherited PplCaPerson: TPplCaPerson
  Caption = 'PplCaPerson'
  ClientHeight = 617
  ClientWidth = 721
  OnResize = FormResize
  ExplicitWidth = 737
  ExplicitHeight = 655
  PixelsPerInch = 96
  TextHeight = 25
  inherited PnlMain: TPanel
    Width = 618
    Height = 617
    ExplicitWidth = 618
    ExplicitHeight = 617
    inherited PnlNavigator: TPanel
      Width = 618
      ExplicitWidth = 618
      inherited EdtNNumber: TArIntEdit
        EditLabel.Width = 3
        EditLabel.Caption = ''
        EditLabel.ExplicitLeft = 70
        EditLabel.ExplicitTop = 5
        EditLabel.ExplicitWidth = 3
        LabelVisible = True
        LabelCaption = ''
        Caption = ''
      end
    end
    inherited PnlEditor: TPanel
      Width = 618
      Height = 582
      ExplicitWidth = 618
      ExplicitHeight = 582
      inherited EdtSNationality: TArSearchEdit
        Width = 510
        EditLabel.ExplicitLeft = 521
        ExplicitWidth = 510
      end
      inherited EdtNameEN: TArStrEdit
        Top = 245
        Width = 510
        EditLabel.ExplicitLeft = 521
        EditLabel.ExplicitTop = 249
        TabOrder = 3
        ExplicitTop = 245
        ExplicitWidth = 510
      end
      inherited EdtNameAR: TArStrEdit
        Top = 206
        Width = 510
        EditLabel.ExplicitLeft = 521
        EditLabel.ExplicitTop = 210
        TabOrder = 2
        ExplicitTop = 206
        ExplicitWidth = 510
      end
      object PnlNames: TPanel
        Left = 8
        Top = 45
        Width = 604
        Height = 155
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        TabOrder = 1
        object PnlENNames: TPanel
          Left = 0
          Top = 0
          Width = 297
          Height = 155
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            297
            155)
          object EdtFirstNameEN: TArStrEdit
            Left = 0
            Top = 0
            Width = 193
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 93
            EditLabel.Height = 25
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = #1575#1604#1575#1587#1605' '#1575#1604#1571#1608#1604' (EN)'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpRight
            TabOrder = 0
            LabelVisible = True
            LabelCaption = #1575#1604#1575#1587#1605' '#1575#1604#1571#1608#1604' (EN)'
            LoadCaption = True
            Caption = #1575#1604#1575#1587#1605' '#1575#1604#1571#1608#1604' (EN)'
          end
          object EdtLastNameEN: TArStrEdit
            Left = 0
            Top = 39
            Width = 193
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 93
            EditLabel.Height = 25
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = #1575#1587#1605' '#1575#1604#1593#1575#1574#1604#1577' (EN)'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpRight
            TabOrder = 1
            LabelVisible = True
            LabelCaption = #1575#1587#1605' '#1575#1604#1593#1575#1574#1604#1577' (EN)'
            LoadCaption = True
            Caption = #1575#1587#1605' '#1575#1604#1593#1575#1574#1604#1577' (EN)'
          end
          object EdtFatherNameEN: TArStrEdit
            Left = 0
            Top = 78
            Width = 193
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 82
            EditLabel.Height = 25
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = #1575#1587#1605' '#1575#1604#1571#1576' (EN)'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpRight
            TabOrder = 2
            LabelVisible = True
            LabelCaption = #1575#1587#1605' '#1575#1604#1571#1576' (EN)'
            LoadCaption = True
            Caption = #1575#1587#1605' '#1575#1604#1571#1576' (EN)'
          end
          object EdtMotherNameEN: TArStrEdit
            Left = 0
            Top = 117
            Width = 193
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 78
            EditLabel.Height = 25
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = #1575#1587#1605' '#1575#1604#1571#1605' (EN)'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpRight
            TabOrder = 3
            LabelVisible = True
            LabelCaption = #1575#1587#1605' '#1575#1604#1571#1605' (EN)'
            LoadCaption = True
            Caption = #1575#1587#1605' '#1575#1604#1571#1605' (EN)'
          end
        end
        object PnlARNames: TPanel
          Left = 303
          Top = 0
          Width = 301
          Height = 155
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            301
            155)
          object EdtFirstNameAR: TArStrEdit
            Left = 0
            Top = 0
            Width = 207
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 84
            EditLabel.Height = 25
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = #1575#1604#1575#1587#1605' '#1575#1604#1571#1608#1604' ('#1593')'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpRight
            TabOrder = 0
            LabelVisible = True
            LabelCaption = #1575#1604#1575#1587#1605' '#1575#1604#1571#1608#1604' ('#1593')'
            LoadCaption = True
            Caption = #1575#1604#1575#1587#1605' '#1575#1604#1571#1608#1604' ('#1593')'
          end
          object EdtLastNameAR: TArStrEdit
            Left = 0
            Top = 39
            Width = 207
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 84
            EditLabel.Height = 25
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = #1575#1587#1605' '#1575#1604#1593#1575#1574#1604#1577' ('#1593')'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpRight
            TabOrder = 1
            LabelVisible = True
            LabelCaption = #1575#1587#1605' '#1575#1604#1593#1575#1574#1604#1577' ('#1593')'
            LoadCaption = True
            Caption = #1575#1587#1605' '#1575#1604#1593#1575#1574#1604#1577' ('#1593')'
          end
          object EdtFatherNameAR: TArStrEdit
            Left = 0
            Top = 78
            Width = 207
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 73
            EditLabel.Height = 25
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = #1575#1587#1605' '#1575#1604#1571#1576' ('#1593')'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpRight
            TabOrder = 2
            LabelVisible = True
            LabelCaption = #1575#1587#1605' '#1575#1604#1571#1576' ('#1593')'
            LoadCaption = True
            Caption = #1575#1587#1605' '#1575#1604#1571#1576' ('#1593')'
          end
          object EdtMotherNameAR: TArStrEdit
            Left = 0
            Top = 117
            Width = 207
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 69
            EditLabel.Height = 25
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = #1575#1587#1605' '#1575#1604#1571#1605' ('#1593')'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpRight
            TabOrder = 3
            LabelVisible = True
            LabelCaption = #1575#1587#1605' '#1575#1604#1571#1605' ('#1593')'
            LoadCaption = True
            Caption = #1575#1587#1605' '#1575#1604#1571#1605' ('#1593')'
          end
        end
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 280
        Width = 604
        Height = 297
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #1593#1606#1575#1608#1610#1606' '#1575#1604#1575#1578#1589#1575#1604': '
        TabOrder = 4
      end
    end
  end
  inherited PnlController: TPanel
    Left = 618
    Height = 617
    ExplicitLeft = 618
    ExplicitHeight = 617
    inherited BtnExit: TButton
      Top = 579
      ExplicitTop = 579
    end
  end
end
