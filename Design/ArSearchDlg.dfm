object ArSearchDialog: TArSearchDialog
  Left = 0
  Top = 0
  ActiveControl = EdtSearch
  BiDiMode = bdRightToLeft
  Caption = 'SearchDialog'
  ClientHeight = 458
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Sakkal Majalla'
  Font.Style = [fsBold]
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 25
  object PnlController: TPanel
    Left = 0
    Top = 0
    Width = 455
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      455
      41)
    object EdtSearch: TEdit
      Left = 8
      Top = 4
      Width = 439
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = EdtSearchChange
      OnKeyPress = EdtSearchKeyPress
    end
  end
  object GrdSearchResult: TStringGrid
    Left = 0
    Top = 41
    Width = 455
    Height = 417
    Align = alClient
    ColCount = 1
    DefaultColWidth = 150
    DrawingStyle = gdsClassic
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowMoving, goColMoving, goRowSelect]
    TabOrder = 1
    OnDblClick = GrdSearchResultDblClick
    OnKeyPress = GrdSearchResultKeyPress
    ColWidths = (
      150)
    RowHeights = (
      24
      24)
  end
end
