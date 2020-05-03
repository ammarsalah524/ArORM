unit Ppl.Ca.Company;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Ppl.Ca.Contact, ArEdit, Vcl.StdCtrls,
  Vcl.WinXCtrls, Vcl.ExtCtrls;

type
  TPplCaCompany = class(TPplCaContact)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
