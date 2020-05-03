unit Ppl.Ca.Country;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, caMain, ArEdit, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.WinXCtrls,
  Vcl.Grids, ArGrid;

type
  TPplCaCountry = class(TMainCard)
    EdtCode: TArStrEdit;
    EdtNameAR: TArStrEdit;
    EdtNameEN: TArStrEdit;
    EdtNationalityAR: TArStrEdit;
    EdtNationalityEN: TArStrEdit;
    EdtCallingCode: TArStrEdit;
    GroupBox1: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ArOrm.Da.Base, Ppl.Da.Region, Ppl.Consts, ArOrm.Consts, ArOrm.Obj.Info;

procedure TPplCaCountry.BtnNextClick(Sender: TObject);
//var
//  LProvince: TPplDaProvince;
begin
  inherited;
//  LProvince := TPplDaProvince(TPplDaCountry(Self.DaEntity.DataAccess).FldProvinces.Item(2));
end;

procedure TPplCaCountry.FormCreate(Sender: TObject);
var
  LCountry: TPplDaCountry;
  LColumns: TArTablesColumns;
  LProvince: TPplDaProvince;
begin
  inherited;
  LCountry := TPplDaCountry(Self.DaEntity.DataAccess);
  Self.EdtNNumber.EnumField(LCountry.FldNumber);
  Self.EdtCode.EnumField(LCountry.FldCode);
  Self.EdtNameAR.EnumField(LCountry.FldNameAR);
  Self.EdtNameEN.EnumField(LCountry.FldNameEN);
  Self.EdtNationalityAR.EnumField(LCountry.FldNationalityAR);
  Self.EdtNationalityEN.EnumField(LCountry.FldNationalityEN);
  Self.EdtCallingCode.EnumField(LCountry.FldCallingCode);
  System.SetLength(LColumns, 2);
  LColumns[0].Table := CTbl_PplRegion;
  LColumns[1].Table := CTbl_PplProvince;
  LColumns[0].Columns := LColumns[0].Columns + [CCol_Code, CCol_NameAR];
  LColumns[1].Columns := LColumns[1].Columns + [CCol_CallingCode];
{  with Self.GrdProvinces do
  begin
    EnumListField(TArDaList<TIDContainer>(LCountry.FldProvinces));
    AddRowNumberColumn;
    AddColumn(ctText, CTbl_PplProvince, CCol_Code, [coCenter]);
    AddColumn(ctText, CTbl_PplProvince, CCol_NameAR, [coCenter]);
    AddColumn(ctText, CTbl_PplProvince, CCol_NameEN, [coCenter]);
    AddColumn(ctText, CTbl_PplProvince, CCol_CallingCode, [coCenter]);
    Initialize;
  end;
  }
//  Self.GbxProvinces.EnumList(TArDaList<TArContainerBase>(LCountry.FldProvinces), LColumns);
//  Self.FocusComponent := Self.EdtNameAR;
end;

end.
