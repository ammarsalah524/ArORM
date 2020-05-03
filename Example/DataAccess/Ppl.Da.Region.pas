unit Ppl.Da.Region;

interface

uses ArOrm.Da.Base, ArOrm.Obj.Info, ArOrm.Consts, Ppl.Consts;

type
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TBases ]'}{*****************************}
  TPplDaRegion = class;
  TPplDaCountry = class;
  TPplDaProvince = class;
  TPplDaCity = class;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaRegion ]'}{***********************}
  TPplDaRegion = class(TIDContainer)
  strict private
    {##################}{$REGION '[ Fields ]'}{#############################}
    FNumber: TArDbField<Integer>;
    FCode: TArDbStrField;
    FNameAR: TArDbStrField;
    FNameEN: TArDbStrField;
    FCallingCode: TArDbStrField;
    {##################}{$ENDREGION}{#######################################}
  public
    {##################}{$REGION '[ Events ]'}{#############################}
    procedure EnumFields(const AEnumorator: TArEnumorator); override;
    class function TableInfo_cls: TArTable; override;
    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ GFields ]'}{############################}
    property FldNumber: TArDbField<Integer> read FNumber;
    property FldCode: TArDbStrField read FCode;
    property FldNameAR: TArDbStrField read FNameAR;
    property FldNameEN: TArDbStrField read FNameEN;
    property FldCallingCode: TArDbStrField read FCallingCode;
    {##################}{$ENDREGION}{#######################################}
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaCountry ]'}{**********************}
  TPplDaCountry = class(TPplDaRegion)
  strict private
    {##################}{$REGION '[ Fields ]'}{#############################}
    FID: TArDbField<Integer>;
    FNumber: TArDbField<Integer>;
    FNationalityAR: TArDbStrField;
    FNationalityEN: TArDbStrField;
    FCallingCode: TArDbStrField;
    FProvinces: TArDaList<TPplDaProvince>;
    {##################}{$ENDREGION}{#######################################}
  public
    {##################}{$REGION '[ Events ]'}{#############################}
    class function TableInfo_cls: TArTable; override;
    procedure EnumFields(const AEnumorator: TArEnumorator); override;
    procedure BeforeInsert; override;
    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ GFields ]'}{############################}
    property FldID: TArDbField<Integer> read FID;
    property FldNumber: TArDbField<Integer> read FNumber;
    property FldNationalityAR: TArDbStrField read FNationalityAR;
    property FldNationalityEN: TArDbStrField read FNationalityEN;
    property FldCallingCode: TArDbStrField read FCallingCode;
    property FldProvinces: TArDaList<TPplDaProvince> read FProvinces;
    {##################}{$ENDREGION}{#######################################}
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaProvince ]'}{*********************}
  TPplDaProvince = class(TPplDaRegion)
  strict private
    {##################}{$REGION '[ Fields ]'}{#############################}
    FID: TArDbField<Integer>;
    FNumber: TArDbField<Integer>;
    FCallingCode: TArDbStrField;
    FCountry: TArDbField<TPplDaCountry>;
    {##################}{$ENDREGION}{#######################################}
  public
    {##################}{$REGION '[ Events ]'}{#############################}
    class function TableInfo_cls: TArTable; override;
    procedure EnumFields(const AEnumorator: TArEnumorator); override;
    procedure BeforeInsert; override;
    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ GFields ]'}{############################}
    property FldID: TArDbField<Integer> read FID;
    property FldNumber: TArDbField<Integer> read FNumber;
//    property FldCode: TArDbStrField read FCode;
//    property FldNationality: TArDbField<TPplDaCountry> read FNationality;
    property FldCallingCode: TArDbStrField read FCallingCode;
    property FldCountry: TArDbField<TPplDaCountry> read FCountry;
//    property FldParent: TArDbField<TPplDaRegion> read FParent;
    {##################}{$ENDREGION}{#######################################}
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaCity ]'}{*************************}
  TPplDaCity = class(TPplDaRegion)
  strict private
    {##################}{$REGION '[ Fields ]'}{#############################}
    FID: TArDbField<Integer>;
    FNumber: TArDbField<Integer>;
    FProvince: TArDbField<TPplDaProvince>;
    {##################}{$ENDREGION}{#######################################}
  public
    {##################}{$REGION '[ Events ]'}{#############################}
    class function TableInfo_cls: TArTable; override;
    procedure EnumFields(const AEnumorator: TArEnumorator); override;
    procedure BeforeInsert; override;
    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ GFields ]'}{############################}
    property FldID: TArDbField<Integer> read FID;
    property FldNumber: TArDbField<Integer> read FNumber;
    property FldProvince: TArDbField<TPplDaProvince> read FProvince;
//    property FldCode: TArDbStrField read FCode;
//    property FldProvince: TArDbField<TPplDaProvince> read FProvince;
    {##################}{$ENDREGION}{#######################################}
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
implementation

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaRegion ]'}{***********************}
procedure TPplDaRegion.EnumFields(const AEnumorator: TArEnumorator);
begin
  inherited;
  AEnumorator.EnumField(TArObj(Self.FID), TArDbField<Integer>, CCol_ID, CTbl_PplRegion, [csNotNull, csAutoNumber, csIdentity, csPrimaryKey], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNumber), TArDbField<Integer>, CCol_Number, CTbl_PplRegion, [csAutoNumber], [ccReadOnly, ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FCode), TArDbStrField, CCol_Code, 20, CTbl_PplRegion, [csAutoCode, csNotNull, csUnique], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNameAR), TArDbStrField, CCol_NameAR, 40, CTbl_PplRegion, [csCaption], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNameEN), TArDbStrField, CCol_NameEN, 40, CTbl_PplRegion, [csCaption], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FCallingCode), TArDbStrField, CCol_CallingCode, 10, CTbl_PplRegion, [], [ccNeeded]);
end;

class function TPplDaRegion.TableInfo_cls: TArTable;
begin
  Result := CTbl_PplRegion;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaCountry ]'}{**********************}
procedure TPplDaCountry.BeforeInsert;
begin
  inherited;
  TPplDaRegion(Self).FldCallingCode.SetValue(Self.FCallingCode.Value);
end;

procedure TPplDaCountry.EnumFields(const AEnumorator: TArEnumorator);
begin
  inherited;
  AEnumorator.EnumField(TArObj(Self.FID), TArDbField<Integer>, CCol_ID, CTbl_PplCountry, [csNotNull, csPrimaryKey, csForeignKey], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNumber), TArDbField<Integer>, CCol_Number, CTbl_PplCountry, [csAutoNumber], [ccReadOnly, ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNationalityAR), TArDbStrField, CCol_NationalityAR, 40, CTbl_PplCountry, [csCaption], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNationalityEN), TArDbStrField, CCol_NationalityEN, 40, CTbl_PplCountry, [csCaption], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FCallingCode), TArDbStrField, CCol_CallingCode, 10, CTbl_PplCountry, [], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FProvinces), TArDaList<TPplDaProvince>, CCol_Provinces, CCol_CountryID, Self);
end;

class function TPplDaCountry.TableInfo_cls: TArTable;
begin
  Result := CTbl_PplCountry;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaProvince ]'}{*********************}
procedure TPplDaProvince.BeforeInsert;
var
  LCallingCode: string;
begin
  inherited;
  LCallingCode := TPplDaRegion(Self.FCountry.Value).FldCallingCode.DaToString;
  LCallingCode := LCallingCode + Copy(Self.FCallingCode.Value, 2, Length(Self.FCallingCode.Value));
  TPplDaRegion(Self).FldCallingCode.SetValue(LCallingCode);
end;

procedure TPplDaProvince.EnumFields(const AEnumorator: TArEnumorator);
begin
  inherited;
  AEnumorator.EnumField(TArObj(Self.FID), TArDbField<Integer>, CCol_ID, CTbl_PplProvince, [csNotNull, csPrimaryKey, csForeignKey], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNumber), TArDbField<Integer>, CCol_Number, CTbl_PplProvince, [csAutoNumber], [ccReadOnly, ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FCallingCode), TArDbStrField, CCol_CallingCode, 10, CTbl_PplProvince, [], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FCountry), TArDbField<TPplDaCountry>, CCol_CountryID, CTbl_PplProvince, [csForeignKey], [ccNeeded]);
  Self.FCountry.Captions := [CCol_NameAR, CCol_NameEN, CCol_NationalityAR, CCol_NationalityEN];
end;

class function TPplDaProvince.TableInfo_cls: TArTable;
begin
  Result := CTbl_PplProvince;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TPplDaCity ]'}{*************************}
procedure TPplDaCity.BeforeInsert;
begin
  inherited;
  Self.FldCallingCode.SetValue(Self.FldProvince.Value.FldCallingCode.Value);
end;

procedure TPplDaCity.EnumFields(const AEnumorator: TArEnumorator);
begin
  inherited;
  AEnumorator.EnumField(TArObj(Self.FID), TArDbField<Integer>, CCol_ID, CTbl_PplCity, [csNotNull, csPrimaryKey, csForeignKey], [ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FNumber), TArDbField<Integer>, CCol_Number, CTbl_PplCity, [csAutoNumber], [ccReadOnly, ccNeeded]);
  AEnumorator.EnumField(TArObj(Self.FProvince), TArDbField<TPplDaProvince>, CCol_ProvinceID, CTbl_PplCity, [csForeignKey], [ccNeeded]);
  Self.FProvince.Captions := [CCol_NameAR, CCol_NameEN];
end;

class function TPplDaCity.TableInfo_cls: TArTable;
begin
  Result := CTbl_PplCity;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
end.
