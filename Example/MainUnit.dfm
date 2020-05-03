object MainForm: TMainForm
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  Caption = 'MainForm'
  ClientHeight = 477
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MmMain
  OldCreateOrder = True
  ParentBiDiMode = False
  Position = poScreenCenter
  Visible = True
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security I' +
      'nfo=False;User ID="";Initial Catalog="";Data Source=DESKTOP-10VS' +
      '322;Initial File Name="";Server SPN=""'
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    Left = 24
    Top = 8
  end
  object MmMain: TMainMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 24
    Top = 64
    object MMContact: TMenuItem
      Caption = #1580#1607#1575#1578' '#1575#1604#1575#1578#1589#1575#1604
      object MiPplDeclerations: TMenuItem
        Caption = #1578#1593#1575#1585#1610#1601
        object MiCountry: TMenuItem
          Caption = #1575#1604#1576#1604#1583
          OnClick = MiCountryClick
        end
        object MiProvince: TMenuItem
          Caption = #1575#1604#1605#1606#1591#1602#1577
          OnClick = MiProvinceClick
        end
        object MiCity: TMenuItem
          Caption = #1575#1604#1605#1583#1610#1606#1577
          OnClick = MiCityClick
        end
      end
      object MiPplCards: TMenuItem
        Caption = #1576#1591#1575#1602#1575#1578
        object MiPerson: TMenuItem
          Caption = #1588#1582#1589
          OnClick = MiPersonClick
        end
        object MiCompany: TMenuItem
          Caption = #1588#1585#1603#1577
          OnClick = MiCompanyClick
        end
      end
    end
  end
end
