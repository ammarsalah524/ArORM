unit ArColumnGrid;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Grids, ArOrm.Da.Base, ArOrm.Obj.Info, Winapi.Windows;

type
  TArColumnType = (ctCheckBox, ctText, ctInteger, ctFloat, ctTime, ctDate, ctDateTime);

  TArColumnOption = (coCenter, coLeft, coRight);

  TArColumnOptions = set of TArColumnOption;

{  TArColumnGrid = class(TAdvColumnGrid)
  private
    FList: TArDaList<TIDContainer>;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure EnumListField(const AListField:TArDaList<TIDContainer>);
//    procedure AddColumn(const AColumnType: TArColumnType;const AField:TArBasicField;
//      const AColumnOptions:TArColumnOptions=[]); overload;
    procedure AddColumn(const AColumnType: TArColumnType;const ATable:TArTable;
      const AColumn:TArColumn; const AColumnOptions:TArColumnOptions=[]); overload;
    procedure AddRowCheckColumn;
    procedure AddRowNumberColumn;
    procedure InsertRows(RowIndex: Integer; RCount: Integer;
      UpdateCellControls: Boolean = True); override;
    procedure Initialize;

  end;
}
procedure Register;

implementation

procedure Register;
begin
{  RegisterComponents('ArOrm', [TArColumnGrid]);}
end;

{ TArColumnGrid }

//procedure TArColumnGrid.AddColumn(const AColumnType: TArColumnType;
//  const AField: TArBasicField; const AColumnOptions: TArColumnOptions=[]);
//var
//  LColumn: TGridColumnItem;
//begin
//  LColumn := Self.Columns.Add;
//  case AColumnType of
//    ctCheckBox: LColumn.Editor := edDataCheckBox;
//    ctText: LColumn.Editor := edNormal;
//    ctInteger: LColumn.Editor := edNumeric;
//    ctFloat: LColumn.Editor := edFloat;
//    ctTime: LColumn.Editor := edTimeEdit;
//    ctDate: LColumn.Editor := edDateEdit;
//    ctDateTime: LColumn.Editor := edDateTimeEdit;
//  end;
//  LColumn.Rows[0] := AField.ColInfo.Caption_AR;
//  if coCenter in AColumnOptions then
//    LColumn.HeaderAlignment := taCenter
//  else if coLeft in AColumnOptions then
//    LColumn.HeaderAlignment := taLeftJustify
//  else if coRight in AColumnOptions then
//    LColumn.HeaderAlignment := taRightJustify;
//  Self.Font.Size := 12;
//end;
{
procedure TArColumnGrid.AddColumn(const AColumnType: TArColumnType; const ATable:TArTable;
  const AColumn:TArColumn;const AColumnOptions: TArColumnOptions);
var
  LColumn: TGridColumnItem;
begin
  LColumn := Self.Columns.Add;
  case AColumnType of
    ctCheckBox: LColumn.Editor := edDataCheckBox;
    ctText: LColumn.Editor := edNormal;
    ctInteger: LColumn.Editor := edNumeric;
    ctFloat: LColumn.Editor := edFloat;
    ctTime: LColumn.Editor := edTimeEdit;
    ctDate: LColumn.Editor := edDateEdit;
    ctDateTime: LColumn.Editor := edDateTimeEdit;
  end;
  LColumn.Rows[0] := AColumn.Caption_AR;
  if coCenter in AColumnOptions then
    LColumn.HeaderAlignment := taCenter
  else if coLeft in AColumnOptions then
    LColumn.HeaderAlignment := taLeftJustify
  else if coRight in AColumnOptions then
    LColumn.HeaderAlignment := taRightJustify;
  Self.Font.Size := 12;
end;

procedure TArColumnGrid.AddRowCheckColumn;
var
  LColumn: TGridColumnItem;
begin
  LColumn := Self.Columns.Add;
  LColumn.Editor := edDataCheckBox;
  LColumn.Rows[0] := '*';
end;

procedure TArColumnGrid.AddRowNumberColumn;
var
  LColumn: TGridColumnItem;
begin
  LColumn := Self.Columns.Add;
  LColumn.Editor := edNumeric;
  LColumn.Rows[0] := '#';
  LColumn.HeaderAlignment := taCenter;
  LColumn.Alignment := taCenter;
  LColumn.ColumnKind := ckAutoNumber;
end;

constructor TArColumnGrid.Create(AOwner: TComponent);
begin
  inherited;
  Self.Font.Size := 12;
  Self.DefaultColWidth := 120;
  Self.DefaultRowHeight := 28;
end;

procedure TArColumnGrid.EnumListField(const AListField: TArDaList<TIDContainer>);
var
  I: Integer;
begin
  for I := 0 to Self.Columns.Count - 1 do
    Self.Columns.Delete(0);
  Self.RowCount := 0;
  Self.FList := AListField;
end;

procedure TArColumnGrid.Initialize;
var
  I: Integer;
begin
  Self.RowCount := 0;
  for I := 0 to 0 do
  begin
    InsertRows(RowCount, 1);
  end;
end;

procedure TArColumnGrid.InsertRows(RowIndex, RCount: Integer;
  UpdateCellControls: Boolean);
var
  I: Integer;
  LColumn: TGridColumnItem;
begin
  inherited;
  if Self.Columns.Items[0].ColumnKind = ckAutoNumber then
  begin
    Self.Cells[0, Self.RowCount -1] := IntToStr(RowIndex);
  end;
end;

procedure TArColumnGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if key = VK_DOWN then
  begin
    if Self.Row = Self.RowCount - 1 then
      Self.InsertRows(RowCount, 1);
      Self.Row := Self.LastRow;
  end;
end;
}
end.
