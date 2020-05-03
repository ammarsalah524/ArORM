unit ArOrm.Obj.Info;

interface

type
  TArTable = record
    ID: Integer;
    Name: string;
  end;

  TArForm = record
    Name: string;
    Caption_AR: string;
    Caption_EN: string;
  end;

  TArColumn = record
    ID: Integer;
    Name: string;
    Caption_AR: string;
    Caption_EN: string;
  end;

  TArTableColumn = record
    Table: TArTable;
    Column: TArColumn;
  end;

  TArTableColumns = record
    Table: TArTable;
    Columns: array of TArColumn;
  end;

  TArTablesColumns = array of TArTableColumns;

implementation

end.
