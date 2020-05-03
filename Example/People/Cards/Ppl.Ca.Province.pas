unit Ppl.Ca.Province;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, caMain, ArEdit, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.WinXCtrls;

type
  TPplCaProvince = class(TMainCard)
    EdtCode: TArStrEdit;
    EdtNameAR: TArStrEdit;
    EdtNameEN: TArStrEdit;
    EdtCallingCode: TArStrEdit;
    EdtSCountry: TArSearchEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnInsertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Ppl.Da.Region;

procedure TPplCaProvince.BtnInsertClick(Sender: TObject);
begin
  inherited;
  exit;
end;

procedure TPplCaProvince.FormCreate(Sender: TObject);
var
  LProvince: TPplDaProvince;
begin
  inherited;
  LProvince := TPplDaProvince(Self.DaEntity.DataAccess);
  Self.EdtNNumber.EnumField(LProvince.FldNumber);
  Self.EdtCode.EnumField(LProvince.FldCode);
  Self.EdtNameAR.EnumField(LProvince.FldNameAR);
  Self.EdtNameEN.EnumField(LProvince.FldNameEN);
  Self.EdtCallingCode.EnumField(LProvince.FldCallingCode);
  Self.EdtSCountry.EnumField(LProvince.FldCountry);
  Self.FocusComponent := Self.EdtSCountry;
end;

end.
