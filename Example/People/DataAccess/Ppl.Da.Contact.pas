unit Ppl.Da.Contact;

interface

uses ArOrm.Consts, ArOrm.Da.Base, ArOrm.Obj.Info, Ppl.Consts, Ppl.Da.Region;

type
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TBases ]'}{*****************************}
  TArConnectionType = (ctPhone, ctEmail, ctWebSite, ctOther);
  TPplDaContact = class;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaContact ]'}{**********************}
  TPplDaContact = class(TIDContainer)
  strict private
//    FID: TArDbField<Integer>;
    FNumber: TArDbField<Integer>;
    FNameAR: TArDbStrField;
    FNameEN: TArDbStrField;
    FNationality: TArDbField<TPplDaCountry>;
  public
    {##################}{$REGION '[ Events ]'}{#############################}
    procedure EnumFields(const AEnumorator: TArEnumorator); override;
    class function TableInfo_cls: TArTable; override;
    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ GFields ]'}{############################}
    property FldID: TArDbField<Integer> read FID;
    property FldNumber: TArDbField<Integer> read FNumber;
    property FldNameAR: TArDbStrField read FNameAR;
    property FldNameEN: TArDbStrField read FNameEN;
    property FldNationality: TArDbField<TPplDaCountry> read FNationality;
    {##################}{$ENDREGION}{#######################################}
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaConnection ]'}{*******************}
  TPplDaConnection = class(TIDContainer)
  strict private
    FNumber: TArDbField<Integer>;
    FConnection: TArDbStrField;
    FType: TArConnectionType;
  public

  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaPerson ]'}{**********************}
  TPplDaPerson = class(TPplDaContact)
  strict private
    FID: TArDbField<Integer>;
    FNumber: TArDbField<Integer>;
    FFirstNameAR: TArDbStrField;
    FFirstNameEN: TArDbStrField;
    FLastNameAR: TArDbStrField;
    FLastNameEN: TArDbStrField;
    FFatherNameAR: TArDbStrField;
    FFatherNameEN: TArDbStrField;
    FMotherNameAR: TArDbStrField;
    FMotherNameEN: TArDbStrField;

    procedure OnNameARChange(const APutInfo:TArPutInfo<string>);
    procedure OnNameENChange(const APutInfo:TArPutInfo<string>);

    function GetNameAR: string;
    function GetNameEN: string;

  strict protected
    procedure DoAfterCreate; override;

  public
    {##################}{$REGION '[ Events ]'}{#############################}
    procedure EnumFields(const AEnumorator: TArEnumorator); override;
    class function TableInfo_cls: TArTable; override;

    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ GFields ]'}{############################}
    property FldID: TArDbField<Integer> read FID;
    property FldNumber: TArDbField<Integer> read FNumber;
    property FldFirstNameAR: TArDbStrField read FFirstNameAR;
    property FldFirstNameEN: TArDbStrField read FFirstNameEN;
    property FldLastNameAR: TArDbStrField read FLastNameAR;
    property FldLastNameEN: TArDbStrField read FLastNameEN;
    property FldFatherNameAR: TArDbStrField read FFatherNameAR;
    property FldFatherNameEN: TArDbStrField read FFatherNameEN;
    property FldMotherNameAR: TArDbStrField read FMotherNameAR;
    property FldMotherNameEN: TArDbStrField read FMotherNameEN;
    {##################}{$ENDREGION}{#######################################}
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaCompany ]'}{**********************}
  TPplDaCompany = class(TPplDaContact)
  strict private
    FID: TArDbField<Integer>;
    FNumber: TArDbField<Integer>;
  public
    {##################}{$REGION '[ Events ]'}{#############################}
    procedure EnumFields(const AEnumorator: TArEnumorator); override;
    class function TableInfo_cls: TArTable; override;
    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ GFields ]'}{############################}
    property FldID: TArDbField<Integer> read FID;
    property FldNumber: TArDbField<Integer> read FNumber;
    {##################}{$ENDREGION}{#######################################}
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
implementation

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaContact ]'}{**********************}
procedure TPplDaContact.EnumFields(const AEnumorator: TArEnumorator);
begin
  inherited;
  AEnumorator.EnumField(TArObj(Self.FID), TArDbField<Integer>, CCol_ID, CTbl_PplContact, [csNotNull, csAutoNumber, csIdentity, csPrimaryKey], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNumber), TArDbField<Integer>, CCol_Number, CTbl_PplContact, [csAutoNumber], [{ccNeeded}]);
  AEnumorator.EnumField(TArObj(Self.FNameAR), TArDbStrField, CCol_NameAR, 40, CTbl_PplContact, [csCaption], [{ccNeeded}]);
  AEnumorator.EnumField(TArObj(Self.FNameEN), TArDbStrField, CCol_NameEN, 40, CTbl_PplContact, [csCaption], [{ccNeeded}]);
  AEnumorator.EnumField(TArObj(Self.FNationality), TArDbField<TPplDaCountry>, CCol_NationalityID, CTbl_PplContact, [csForeignKey], [{ccNeeded}]);
  Self.FNationality.Captions := [CCol_NationalityAR, CCol_NationalityEN];
end;

class function TPplDaContact.TableInfo_cls: TArTable;
begin
  Result := CTbl_PplContact;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaPerson ]'}{***********************}
procedure TPplDaPerson.DoAfterCreate;
begin
  inherited;
  Self.FldFirstNameAR.EventsManager.AddToDoAfterChange(Self.OnNameARChange);
  Self.FldLastNameAR.EventsManager.AddToDoAfterChange(Self.OnNameARChange);
  Self.FldFatherNameAR.EventsManager.AddToDoAfterChange(Self.OnNameARChange);

  Self.FldFirstNameEN.EventsManager.AddToDoAfterChange(Self.OnNameENChange);
  Self.FldLastNameEN.EventsManager.AddToDoAfterChange(Self.OnNameENChange);
  Self.FldFatherNameEN.EventsManager.AddToDoAfterChange(Self.OnNameENChange);
end;

procedure TPplDaPerson.EnumFields(const AEnumorator: TArEnumorator);
begin
  inherited;
  AEnumorator.EnumField(TArObj(Self.FID), TArDbField<Integer>, CCol_ID, CTbl_PplPerson, [csNotNull, csPrimaryKey, csForeignKey], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNumber), TArDbField<Integer>, CCol_Number, CTbl_PplPerson, [csAutoNumber]);
  AEnumorator.EnumField(TArObj(Self.FFirstNameAR), TArDbStrField, CCol_NameAR, 40, CTbl_PplPerson);
  AEnumorator.EnumField(TArObj(Self.FFirstNameEN), TArDbStrField, CCol_FirstNameEN, 40, CTbl_PplPerson);
  AEnumorator.EnumField(TArObj(Self.FLastNameAR), TArDbStrField, CCol_LastNameAR, 40, CTbl_PplPerson);
  AEnumorator.EnumField(TArObj(Self.FLastNameEN), TArDbStrField, CCol_LastNameEN, 40, CTbl_PplPerson);
  AEnumorator.EnumField(TArObj(Self.FFatherNameAR), TArDbStrField, CCol_FatherNameAR, 40, CTbl_PplPerson);
  AEnumorator.EnumField(TArObj(Self.FFatherNameEN), TArDbStrField, CCol_FatherNameEN, 40, CTbl_PplPerson);
  AEnumorator.EnumField(TArObj(Self.FMotherNameAR), TArDbStrField, CCol_MotherNameAR, 40, CTbl_PplPerson);
  AEnumorator.EnumField(TArObj(Self.FMotherNameEN), TArDbStrField, CCol_MotherNameEN, 40, CTbl_PplPerson);
end;

function TPplDaPerson.GetNameAR: string;
var
  LFirstNameAR: string;
  LLastNameAR: string;
  LFatherNameAR: string;
begin
  LFirstNameAR := Self.FldFirstNameAR.Value;
  LLastNameAR := Self.FldLastNameAR.Value;
  LFatherNameAR := Self.FldFatherNameAR.Value;
  Result := LFirstNameAR;
  if LFatherNameAR <> '' then Result := Result + ' ' + LFatherNameAR;
  if LLastNameAR <> '' then Result := Result + ' ' + LLastNameAR;
end;

function TPplDaPerson.GetNameEN: string;
var
  LFirstNameEN: string;
  LLastNameEN: string;
  LFatherNameEN: string;
begin
  LFirstNameEN := Self.FldFirstNameEN.Value;
  LLastNameEN := Self.FldLastNameEN.Value;
  LFatherNameEN := Self.FldFatherNameEN.Value;
  Result := LFirstNameEN;
  if LFatherNameEN <> '' then Result := Result + ' ' + LFatherNameEN;
  if LLastNameEN <> '' then Result := Result + ' ' + LLastNameEN;
end;

procedure TPplDaPerson.OnNameARChange(const APutInfo:TArPutInfo<string>);
begin
  if [pfInLoad, pfNew] * APutInfo.PutFlags <> [] then Exit;
  Self.FldNameAR.SetValue(Self.GetNameAR, [pfUserFlagA]);
end;

procedure TPplDaPerson.OnNameENChange(const APutInfo:TArPutInfo<string>);
begin
  if [pfInLoad, pfNew] * APutInfo.PutFlags <> [] then Exit;
  Self.FldNameEN.SetValue(Self.GetNameEN, [pfUserFlagA]);
end;

class function TPplDaPerson.TableInfo_cls: TArTable;
begin
  Result := CTbl_PplPerson;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaCompany ]'}{***********************}
procedure TPplDaCompany.EnumFields(const AEnumorator: TArEnumorator);
begin
  inherited;
  AEnumorator.EnumField(TArObj(Self.FID), TArDbField<Integer>, CCol_ID, CTbl_PplCompany, [csNotNull, csPrimaryKey, csForeignKey], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNumber), TArDbField<Integer>, CCol_Number, CTbl_PplCompany, [csAutoNumber]);
end;

class function TPplDaCompany.TableInfo_cls: TArTable;
begin
  Result := CTbl_PplCompany;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
end.
