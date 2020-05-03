unit ArGrid;

interface
{
$004F4737
$00625A4B
$007E7461
}
uses
  System.SysUtils, System.Types, System.Classes, Vcl.Controls, Vcl.Grids,
  ArOrm.Da.Base, ArOrm.Obj.Info, ArEdit;

type
  TArGrid = class(TDrawGrid)
  strict private
    FCapasity: Integer;
    FDaEntity: TArDaEntity;
    FList: TArDaList<TArContainerBase>;
    FColumns: TArTablesColumns;
    FFields: array of TArBasicField;
  private
    procedure SetCapasity(const AValue: Integer);
//    function GetCells(ACol,ARow:Integer): TArField;
//    procedure SetCells(ACol,ARow):TArField;

  protected
    procedure DrawCell(ACol:Integer;ARow:Integer;ARect:TRect;AState:TGridDrawState); override;
    function GetFieldByColRow(const ACol, ARow:Integer): TArBasicField;
    function GetTableColumn(const ACol: Integer): TArTableColumn;

  public
    constructor Create(AOwner: TComponent); override;

    procedure EnumList(const AList:TArDaList<TArContainerBase>;const AColumns: TArTablesColumns);

    property Capasity: Integer read FCapasity write SetCapasity;
    property DaEntity: TArDaEntity read FDaEntity write FDaEntity;
    property List: TArDaList<TArContainerBase> read FList write FList;
//    property Cells[ACol, ARow: Integer]: string read GetCells write SetCells;
  published

  end;

procedure Register;

implementation

uses Vcl.Graphics;

procedure Register;
begin
  RegisterComponents('ArOrm', [TArGrid]);
end;

{ TArGrid }

constructor TArGrid.Create(AOwner: TComponent);
begin
  inherited;
  DefaultDrawing := True;
  //DefaultColWidth := 150;
  FCapasity := 4;
  DefaultDrawing := False;
  ColCount := 5;
  RowCount := Self.FCapasity + 1;
  FixedCols := 1;
  Repaint;
end;

procedure TArGrid.DrawCell(ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
//var
//  I: Integer;
//  J: Integer;
//  LRect: TRect;
//  LColNum: Integer;
//  LFields: TArDaList<TArBasicField>;
begin
  inherited;
  if  (ARow mod 2 = 0) then
  begin
    if (ARow = 0) or (ACol = 0) then Canvas.Brush.Color := $002B2726 //Fixed row
    else Canvas.Brush.Color := $00625844; //Dark row
    Canvas.Font.Color := clWhite;
  end
  else
  begin
    if (ACol = 0) then Canvas.Brush.Color := $00433D3A //fixed col
    else
    Canvas.Brush.Color := $00796D55; // Light Row
    Canvas.Font.Color := clWhite;
  end;
  if (gdFocused in AState)or(gdSelected in AState) then
  begin
    Canvas.Brush.Color := clGreen; // Selected Cell
    Canvas.Font.Color := clWhite;
  end;
  Canvas.FillRect(ARect);
{
  Canvas.Brush.Style := bsClear;
  LColNum := 0;
  if ARow = 0 then
  begin
    if ACol = 0 then Canvas.TextRect(ARect, ARect.Left + 3, ARect.Top + 3, '#')
    else
    for I := 0 to System.Length(Self.FColumns) - 1 do
      for J := 0 to System.Length(Self.FColumns[I].Columns) - 1 do
        begin
          LColNum := LColNum + 1;
          LRect := Self.CellRect(LColNum, 0);
          Canvas.TextRect(LRect, LRect.Left + 3, LRect.Top + 3, Self.FColumns[I].Columns[J].Caption_AR);
        end;
  end
  else
  begin
    if ACol = 0 then
    begin
      Canvas.TextRect(ARect, ARect.Left + 3, ARect.Top + 3, IntToStr(ARow));
    end
    else
    if Self.FList.Items.Count > 0 then
    begin
      Canvas.TextRect(ARect, ARect.Left + 3, ARect.Top + 3, Self.GetFieldByColRow(ACol, ARow).DaToString);
    end;
  end;

{
  LColNum := 0;
  if Self.FList <> nil then
  begin
    for I := 0 to System.Length(FColumns) - 1 do
    begin
      LRect := Self.CellRect(0, 0);
      Canvas.TextRect(LRect, LRect.Left + 3, LRect.Top + 3, '#');
      for J := 0 to System.Length(FColumns[I].Columns) - 1 do
      begin
        LColNum := LColNum + 1;
        LRect := Self.CellRect(LColNum, 0);
        Canvas.TextRect(LRect, LRect.Left + 3, LRect.Top + 3, Self.FColumns[I].Columns[J].Caption_AR);
      end;
    end;
  end
  else
  begin
    Canvas.TextRect(ARect, ARect.Left + 3, ARect.Top + 3, '');
  end;
}
end;


{
        if (ARow > 0) and (ACol > 0) then
        begin
          if Self.FList.Items.Count > 0 then
          begin
            LFields := Self.FList.Items[ARow - 1].Fields;
            for K := 0 to LFields.Items.Count - 1 do
            begin
              LField := LFields.Items[K];
              if (LField.DbOwner.ID = Self.FColumns[I].Tables.ID) and (LField.ColInfo.ID = Self.FColumns[I].Columns[J].ID) then
              begin
                Self.Canvas.TextRect(ARect, ARect.Left + 3, ARect.Top + 3, LField.DaToString);
                Break;
              end;
            end;
          end;
        end;
}

procedure TArGrid.EnumList(const AList: TArDaList<TArContainerBase>;const AColumns: TArTablesColumns);
var
  I: Integer;
  J: Integer;
  K: Integer;
  LColNum: Integer;
  LContainer: TArObj;
  LField: TArBasicField;
begin
  Self.FColumns := AColumns;
  Self.FList := AList;
  Self.DefaultDrawing := True;
  Self.ColCount := 0;
  Self.FixedCols := 0;
  LColNum := 0;
  LContainer := AList.ContainerClassType.Create;
  try
    for I := 0 to System.Length(AColumns) - 1 do
    begin
      Self.ColCount := Self.ColCount + System.Length(AColumns[I].Columns);
      Self.FixedCols := 1;
    end;
    for I := 0 to Length(AColumns) - 1 do
    begin
      for J := 0 to Length(AColumns[I].Columns) - 1 do
      begin
        for K := 0 to TArContainerBase(LContainer).Fields.Count - 1 do
        begin
          LField := TArContainerBase(LContainer).Fields.Items[K];
          if (LField.DbOwner.ID = AColumns[I].Table.ID) and (LField.ColInfo.ID = AColumns[I].Columns[J].ID) then
          Self.FFields := Self.FFields + [LField];
        end;
        LColNum := LColNum + 1;
        Self.ColWidths[LColNum] := Self.Canvas.TextWidth(AColumns[I].Columns[J].Caption_AR) + 50;
        Self.RowHeights[0] := Self.Canvas.TextHeight(AColumns[I].Columns[J].Caption_AR) + 15;
      end;
    end;
  finally
    LContainer.Free;
  end;
  Self.Repaint;
end;

function TArGrid.GetFieldByColRow(const ACol, ARow: Integer): TArBasicField;
var
  I: Integer;
  LTableColumn: TArTableColumn;
  LField: TArBasicField;
begin
  LTableColumn := Self.GetTableColumn(ACol);
  for I := 0 to Self.FList.Items[0].Fields.Items.Count - 1 do
  begin
    if Self.FList.Items.Count > 0 then
    begin
      if Self.FList.Items[ARow - 1].Fields.Items.Count > 0 then
      begin
        LField := Self.FList.Items[ARow - 1].Fields.Items[I];
        if (LField.DbOwner.ID = LTableColumn.Table.ID) and (LField.ColInfo.ID = LTableColumn.Column.ID) then
        begin
          Break;
        end;
      end;
    end;
  end;
//  if LField <> nil then Result := LField
  Result := nil;
end;

function TArGrid.GetTableColumn(const ACol: Integer): TArTableColumn;
var
  I: Integer;
  J: Integer;
  LColNum: Integer;
begin
  LColNum := 0;
  for I := 0 to Length(Self.FColumns) - 1 do
    for J := 0 to Length(Self.FColumns[I].Columns) - 1 do
    begin
      LColNum := LColNum + 1;
      if LColNum = ACol then
      begin
        Result.Table := Self.FColumns[I].Table;
        Result.Column := Self.FColumns[I].Columns[J];
        Break;
      end;
    end;
end;

procedure TArGrid.SetCapasity(const AValue: Integer);
begin
  FCapasity := AValue;
end;

end.
