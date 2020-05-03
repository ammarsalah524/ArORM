unit Ppl.Ca.Person;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Ppl.Ca.Contact, ArEdit, Vcl.StdCtrls,
  Vcl.WinXCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.Imaging.pngimage;

type
  TPplCaPerson = class(TPplCaContact)
    PnlNames: TPanel;
    PnlENNames: TPanel;
    PnlARNames: TPanel;
    EdtFirstNameEN: TArStrEdit;
    EdtLastNameEN: TArStrEdit;
    EdtFatherNameEN: TArStrEdit;
    EdtMotherNameEN: TArStrEdit;
    EdtFirstNameAR: TArStrEdit;
    EdtLastNameAR: TArStrEdit;
    EdtFatherNameAR: TArStrEdit;
    EdtMotherNameAR: TArStrEdit;
    GroupBox1: TGroupBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    procedure DoCreate; override;
  end;

implementation

{$R *.dfm}

uses Ppl.Da.Contact;

procedure TPplCaPerson.DoCreate;
var
  LPerson: TPplDaPerson;
begin
  inherited;
  LPerson := TPplDaPerson(Self.DaEntity.DataAccess);
  Self.EdtNNumber.EnumField(LPerson.FldNumber);
  Self.EdtFirstNameAR.EnumField(LPerson.FldFirstNameAR);
  Self.EdtFirstNameEN.EnumField(LPerson.FldFirstNameEN);
  Self.EdtLastNameAR.EnumField(LPerson.FldLastNameAR);
  Self.EdtLastNameEN.EnumField(LPerson.FldLastNameEN);
  Self.EdtFatherNameAR.EnumField(LPerson.FldFatherNameAR);
  Self.EdtFatherNameEN.EnumField(LPerson.FldFatherNameEN);
  Self.EdtMotherNameAR.EnumField(LPerson.FldMotherNameAR);
  Self.EdtMotherNameEN.EnumField(LPerson.FldMotherNameEN);
  Self.FocusComponent := Self.EdtSNationality;
end;

procedure TPplCaPerson.FormCreate(Sender: TObject);
begin
  inherited;
//  Self.LMDGrid1.DataRowCount := 7;
end;

procedure TPplCaPerson.FormResize(Sender: TObject);
begin
  inherited;
  Self.PnlENNames.Width := Self.PnlNames.Width div 2;
  Self.PnlARNames.Width := Self.PnlNames.Width div 2;
end;

end.
