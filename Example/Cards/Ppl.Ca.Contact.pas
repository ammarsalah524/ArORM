unit Ppl.Ca.Contact;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, caMain, Vcl.StdCtrls, Vcl.WinXCtrls,
  ArEdit, Vcl.ExtCtrls;

type
  TPplCaContact = class(TMainCard)
    EdtSNationality: TArSearchEdit;
    EdtNameEN: TArStrEdit;
    EdtNameAR: TArStrEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Ppl.Da.Contact;

procedure TPplCaContact.FormCreate(Sender: TObject);
var
  LContact: TPplDaContact;
begin
  inherited;
  LContact := TPplDaContact(Self.DaEntity.DataAccess);
  Self.EdtNNumber.EnumField(LContact.FldNumber);
  Self.EdtNameAR.EnumField(LContact.FldNameAR);
  Self.EdtNameEN.EnumField(LContact.FldNameEN);
  Self.EdtSNationality.EnumField(LContact.FldNationality);
  Self.FocusComponent := Self.EdtSNationality;
end;

end.
