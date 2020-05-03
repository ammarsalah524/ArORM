unit Ppl.Consts;

interface

uses ArOrm.Obj.Info;

const
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ Tables ]'}{*****************************}
  CTbl_PplRegion:                TArTable = (ID:1;Name:'PplRegion');
  CTbl_PplCountry:               TArTable = (ID:2;Name:'PplCountry');
  CTbl_PplProvince:              TArTable = (ID:3;Name:'PplProvince');
  CTbl_PplCity:                  TArTable = (ID:4;Name:'PplCity');
  CTbl_PplContact:               TArTable = (ID:5;Name:'PplContact');
  CTbl_PplPerson:                TArTable = (ID:6;Name:'PplPerson');
  CTbl_PplCompany:               TArTable = (ID:7;Name:'PplCompany');
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ Columns ]'}{****************************}
  CCol_NationalityAR:            TArColumn = (ID:7;Name:'NationalityAR';Caption_AR:'«·Ã‰”Ì… (⁄)';Caption_EN:'Nationality (AR)');
  CCol_NationalityEN:            TArColumn = (ID:8;Name:'NationalityEN';Caption_AR:'«·Ã‰”Ì… (EN)';Caption_EN:'Nationality (EN)');
  CCol_CallingCode:              TArColumn = (ID:9;Name:'CallingCode';Caption_AR:'„› «Õ «·« ’«·';Caption_EN:'Calling Code');
  CCol_Provinces:                TArColumn = (ID:10;Name:'Provinces';Caption_AR:'«·„‰«ÿﬁ';Caption_EN:'Provinces');
  CCol_NationalityID:            TArColumn = (ID:11;Name:'NationalityID';Caption_AR:'«·Ã‰”Ì…';Caption_EN:'Nationality');
  CCol_CountryID:                TArColumn = (ID:12;Name:'CountryID';Caption_AR:'«·»·œ';Caption_EN:'Country');
  CCol_ProvinceID:               TArColumn = (ID:13;Name:'ProvinceID';Caption_AR:'«·„‰ÿﬁ…';Caption_EN:'Province');
  CCol_FatherNameAR:             TArColumn = (ID:14;Name:'FatherNameAR';Caption_AR:'«”„ «·√» (⁄)';Caption_EN:'Father''s Name (AR)');
  CCol_FatherNameEN:             TArColumn = (ID:15;Name:'FatherNameEN';Caption_AR:'«”„ «·√» (EN)';Caption_EN:'Father''s Name (EN)');
  CCol_MotherNameAR:             TArColumn = (ID:16;Name:'MotherNameAR';Caption_AR:'«”„ «·√„ (⁄)';Caption_EN:'Mother''s Name (AR)');
  CCol_MotherNameEN:             TArColumn = (ID:17;Name:'MotherNameEN';Caption_AR:'«”„ «·√„ (EN)';Caption_EN:'Mother''s Name (EN)');
  CCol_Berthday:                 TArColumn = (ID:18;Name:'Berthday';Caption_AR:' «—ÌŒ «·„Ì·«œ';Caption_EN:'Berthday');
  CCol_FirstNameAR:              TArColumn = (ID:19;Name:'FirstNameAR';Caption_AR:'«·«”„ «·√Ê· (⁄)';Caption_EN:'First Name (AR)');
  CCol_LastNameAR:               TArColumn = (ID:20;Name:'LastNameAR';Caption_AR:'«·«”„ «·⁄«∆·… (⁄)';Caption_EN:'Last Name (EN)');
  CCol_FirstNameEN:              TArColumn = (ID:21;Name:'FirstNameEN';Caption_AR:'«·«”„ «·√Ê· (EN)';Caption_EN:'First Name (EN)');
  CCol_LastNameEN:               TArColumn = (ID:22;Name:'LastNameEN';Caption_AR:'«”„ «·⁄«∆·… (EN)';Caption_EN:'Last Name (EN)');
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

implementation

end.
