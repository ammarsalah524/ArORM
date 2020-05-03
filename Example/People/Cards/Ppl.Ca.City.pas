unit Ppl.Ca.City;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, caMain, ArEdit, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls;

type
  TPplCaCity = class(TMainCard)
    EdtCode: TArStrEdit;
    EdtNameAR: TArStrEdit;
    EdtNameEN: TArStrEdit;
    EdtSProvince: TArSearchEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Ppl.Da.Region;

procedure TPplCaCity.FormCreate(Sender: TObject);
var
  LCity: TPplDaCity;
begin
  inherited;
  LCity := TPplDaCity(Self.DaEntity.DataAccess);
  Self.EdtSProvince.EnumField(LCity.FldProvince);
  Self.EdtNNumber.EnumField(LCity.FldNumber);
  Self.EdtCode.EnumField(LCity.FldCode);
  Self.EdtNameAR.EnumField(LCity.FldNameAR);
  Self.EdtNameEN.EnumField(LCity.FldNameEN);
  Self.FocusComponent := Self.EdtSProvince;
end;

end.
