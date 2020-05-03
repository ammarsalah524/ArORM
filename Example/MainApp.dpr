program MainApp;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  MainUnit in 'MainUnit.pas' {MainForm},
  Ppl.Da.Region in 'People\DataAccess\Ppl.Da.Region.pas',
  Ppl.Consts in 'People\Ppl.Consts.pas',
  caMain in 'caMain.pas' {MainCard},
  Ppl.Ca.Country in 'People\Cards\Ppl.Ca.Country.pas' {PplCaCountry},
  Ppl.Ca.Province in 'People\Cards\Ppl.Ca.Province.pas' {PplCaProvince},
  Ppl.Ca.City in 'People\Cards\Ppl.Ca.City.pas' {PplCaCity},
  Ppl.Da.Contact in 'People\DataAccess\Ppl.Da.Contact.pas',
  Ppl.Ca.Contact in 'People\Cards\Ppl.Ca.Contact.pas' {PplCaContact},
  Ppl.Ca.Person in 'People\Cards\Ppl.Ca.Person.pas' {PplCaPerson},
  Ppl.Ca.Company in 'People\Cards\Ppl.Ca.Company.pas' {PplCaCompany},
  Ppl.Da.PhoneNumber in 'People\DataAccess\Ppl.Da.PhoneNumber.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
