unit ArSearchDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Menus, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, Vcl.StdCtrls, ArOrm.Da.Base, ArEdit,
  ArOrm.Consts, ArOrm.Obj.Info;

type
  TArSearchDialog = class(TForm)
    PnlController: TPanel;
    GrdSearchResult: TStringGrid;
    EdtSearch: TEdit;
    procedure EdtSearchChange(Sender: TObject);
    procedure GrdSearchResultKeyPress(Sender: TObject; var Key: Char);
    procedure EdtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure GrdSearchResultDblClick(Sender: TObject);
    function GetSelected: Integer;
  private
    FDaEntity: TArDaEntity;
    FDaField: TArBasicField;
    FList: TArDaList<TArContainerBase>;
    FCaptionAddresss: array of integer;
    FSelected: Integer;
  protected
  public
    constructor Create(Owner:TComponent;const ADaEntity:TArDaEntity;const ADaField:TArBasicField;
      const AValue:string=''); reintroduce; overload;
    function SearchResult: TArContainerBase;
  end;

var
  SearchDialog: TArSearchDialog;

implementation

{$R *.dfm}

uses Data.Win.ADODB, Data.Db, System.Rtti;

{ TSearchDialog }

constructor TArSearchDialog.Create(Owner: TComponent; const ADaEntity: TArDaEntity; const ADaField: TArBasicField;
  const AValue: string);
var
  I, J: Integer;
  LField: TArBasicField;
  LContainer: TArObj;
  LCol: TArColumn;
  LColCount: Integer;
begin
  inherited Create(Owner);
  Self.FDaEntity := ADaEntity;
  Self.FDaField := ADaField;
  LField := Self.FDaField;
  Self.FList := TArDaList<TArContainerBase>.Create(LField.Owner, LField.GetActualType, LField.ColInfo, LField.ColSettings, LField.ColCondetions);
  LContainer := LField.GetActualType.Create;
  LColCount := System.Length(Self.FDaField.Captions);
  Self.GrdSearchResult.ColCount := LColCount;
  Self.Width := (LColCount) * 150 + 20;
  for I := 0 to LColCount - 1 do
  begin
    LCol := Self.FDaField.Captions[I];
    Self.GrdSearchResult.Cells[I, 0] := LCol.Caption_AR;
    for J := 0 to  TArContainerBase(LContainer).Fields.Count -1 do
    begin
      if TArContainerBase(LContainer).Fields.Item(j).ColInfo.ID = LCol.ID then
      Self.FCaptionAddresss := Self.FCaptionAddresss + [J];
    end;
  end;
  Self.FSelected := -1;
  Self.EdtSearch.Text := AValue;
end;

procedure TArSearchDialog.EdtSearchChange(Sender: TObject);
var
  I, J: Integer;
  LContainer: TArContainerBase;
begin
  if Self.EdtSearch.Text = '' then Exit;
  Self.GrdSearchResult.RowCount := 2;
  Self.GrdSearchResult.Rows[1].Clear;
  Self.FList.Search(Self.EdtSearch.Text);
  if Self.FList.Count <> 0 then
  begin
    Self.GrdSearchResult.RowCount := Self.FList.Count + 1;
    for I := 0 to Self.FList.Count - 1 do
    begin
      LContainer := Self.FList.Item(I);
      for J := 0 to System.Length(Self.FCaptionAddresss) - 1 do
      begin
        Self.GrdSearchResult.Cells[J, I + 1] :=
          LContainer.Fields.Item(Self.FCaptionAddresss[J]).DaToString;
      end;
    end;
  end;
  Self.GrdSearchResult.Row := 1;
end;

procedure TArSearchDialog.EdtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if Self.GetSelected <> -1 then
    begin
      Self.ModalResult := mrOk;
      key := #0;
    end;
  end;
end;

function TArSearchDialog.GetSelected: Integer;
begin
  if Self.FList.Count = 0 then Result := -1
  else Result := Self.GrdSearchResult.Row - 1;
end;

procedure TArSearchDialog.GrdSearchResultDblClick(Sender: TObject);
begin
  if Self.GetSelected <> -1 then
  begin
    Self.ModalResult := mrOk;
  end;
end;

procedure TArSearchDialog.GrdSearchResultKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if Self.GetSelected <> -1 then
    begin
      Self.ModalResult := mrOk;
      key := #0;
    end;
  end;
end;

function TArSearchDialog.SearchResult: TArContainerBase;
begin
  if Self.GetSelected <> -1 then Result := Self.FList.Item(Self.GetSelected)
  else Result := nil;
end;

end.
