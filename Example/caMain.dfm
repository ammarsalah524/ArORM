object MainCard: TMainCard
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  ClientHeight = 362
  ClientWidth = 484
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Sakkal Majalla'
  Font.Style = [fsBold]
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 25
  object PnlMain: TPanel
    Left = 0
    Top = 0
    Width = 381
    Height = 362
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PnlNavigator: TPanel
      Left = 0
      Top = 0
      Width = 381
      Height = 35
      Align = alTop
      TabOrder = 0
      object BtnFirst: TButton
        Left = 8
        Top = 3
        Width = 33
        Height = 29
        Caption = '>>'
        TabOrder = 0
        OnClick = BtnFirstClick
      end
      object BtnBack: TButton
        Left = 41
        Top = 3
        Width = 33
        Height = 29
        Caption = '>'
        TabOrder = 1
        OnClick = BtnBackClick
      end
      object BtnLast: TButton
        Left = 231
        Top = 3
        Width = 33
        Height = 29
        Caption = '<<'
        TabOrder = 2
        OnClick = BtnLastClick
      end
      object BtnNext: TButton
        Left = 198
        Top = 3
        Width = 33
        Height = 29
        Caption = '<'
        TabOrder = 3
        OnClick = BtnNextClick
      end
      object EdtNNumber: TArIntEdit
        Left = 76
        Top = 1
        Width = 121
        Height = 33
        EditLabel.Width = 82
        EditLabel.Height = 25
        EditLabel.BiDiMode = bdRightToLeft
        EditLabel.Caption = 'EdtNNumber'
        EditLabel.ParentBiDiMode = False
        LabelPosition = lpLeft
        TabOrder = 4
        LabelVisible = False
        LabelCaption = 'EdtNNumber'
        LoadCaption = False
        Caption = 'EdtNNumber'
      end
    end
    object PnlEditor: TPanel
      Left = 0
      Top = 35
      Width = 381
      Height = 327
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Sakkal Majalla'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object PnlController: TPanel
    Left = 381
    Top = 0
    Width = 103
    Height = 362
    Align = alRight
    TabOrder = 1
    DesignSize = (
      103
      362)
    object BtnNew: TButton
      Left = 4
      Top = 8
      Width = 95
      Height = 30
      Caption = #1580#1583#1610#1583
      TabOrder = 0
      OnClick = BtnNewClick
    end
    object BtnUpdate: TButton
      Left = 4
      Top = 44
      Width = 95
      Height = 30
      Caption = #1578#1593#1583#1610#1604
      TabOrder = 1
      OnClick = BtnUpdateClick
    end
    object BtnInsert: TButton
      Left = 4
      Top = 80
      Width = 95
      Height = 30
      Caption = #1573#1606#1588#1575#1569
      TabOrder = 2
      OnClick = BtnInsertClick
    end
    object BtnDelete: TButton
      Left = 4
      Top = 116
      Width = 95
      Height = 30
      Caption = #1581#1584#1601
      TabOrder = 3
    end
    object BtnExit: TButton
      Left = 4
      Top = 324
      Width = 95
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = #1573#1594#1604#1575#1602
      TabOrder = 4
      OnClick = BtnExitClick
    end
  end
  object DaEntity: TArDaEntity
    Left = 40
    Top = 67
  end
end
