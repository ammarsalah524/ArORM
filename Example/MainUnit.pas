unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ArOrm.Da.Base, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls,
  Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.WinXCtrls, Vcl.Grids;

type
  TMainForm = class(TForm)
    ADOConnection: TADOConnection;
    MmMain: TMainMenu;
    MMContact: TMenuItem;
    MiPplDeclerations: TMenuItem;
    MiCountry: TMenuItem;
    MiProvince: TMenuItem;
    MiCity: TMenuItem;
    MiPplCards: TMenuItem;
    MiPerson: TMenuItem;
    MiCompany: TMenuItem;
    procedure MiCountryClick(Sender: TObject);
    procedure MiProvinceClick(Sender: TObject);
    procedure MiCityClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure MiPersonClick(Sender: TObject);
    procedure MiCompanyClick(Sender: TObject);
  protected
    procedure DoCreate; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses ArOrm.Consts, caMain,
  Ppl.Da.Region, Ppl.Da.Contact,

  Ppl.Ca.Country, Ppl.Ca.Province, Ppl.Ca.City, Ppl.Ca.Contact, Ppl.Ca.Person,
  Ppl.Ca.Company;

procedure TMainForm.DoCreate;
var
  LDBCreator: TArDatabaseCreator;
begin
  inherited;
  LDBCreator := TArDatabaseCreator.Create(SelF.ADOConnection, False);
  with LDBCreator do
  begin
    Tables := [TPplDaRegion, TPplDaCountry, TPplDaProvince, TPplDaCity, TPplDaContact,
      TPplDaPerson, TPplDaCompany];
    CreateDataBase('Testing');
  end;
end;

procedure TMainForm.MiCityClick(Sender: TObject);
begin
  TPplCaCity.Create(Self, TPplDaCity).Show;
end;

procedure TMainForm.MiCountryClick(Sender: TObject);
begin
  TPplCaCountry.Create(Self, TPplDaCountry).Show;
end;

procedure TMainForm.MiProvinceClick(Sender: TObject);
begin
  TPplCaProvince.Create(Self, TPplDaProvince).Show;
  Self.Color := clBlack;
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  TPplCaContact.Create(Self, TPplDaContact).Show;
end;

procedure TMainForm.MiPersonClick(Sender: TObject);
begin
  TPplCaPerson.Create(Self, TPplDaPerson).Show;
end;

procedure TMainForm.MiCompanyClick(Sender: TObject);
begin
  TPplCaCompany.Create(Self, TPplDaCompany).Show;
end;

end.
