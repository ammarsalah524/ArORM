unit ArOrm.Consts;

interface

uses ArOrm.Obj.Info;

const
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ Tables ]'}{*****************************}
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ Columns ]'}{****************************}
  CCol_ID:                       TArColumn = (ID:1;Name:'ID');
  CCol_Number:                   TArColumn = (ID:2;Name:'Number';Caption_AR:'«·—ﬁ„';Caption_EN:'Number');
  CCol_Code:                     TArColumn = (ID:3;Name:'Code';Caption_AR:'«·—„“';Caption_EN:'Code');
  CCol_ParentID:                 TArColumn = (ID:4;Name:'ParentID';Caption_AR:'«·√»';Caption_EN:'Parent');
  CCol_NameAR:                   TArColumn = (ID:5;Name:'NameAR';Caption_AR:'«·«”„ (⁄)';Caption_EN:'Name (AR)');
  CCol_NameEN:                   TArColumn = (ID:6;Name:'NameEN';Caption_AR:'«·«”„ (EN)';Caption_EN:'Name (EN)');
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

implementation

end.
