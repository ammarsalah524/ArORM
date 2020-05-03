unit caMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, ArEdit, ArOrm.Da.Base;

type
  TMainCard = class(TForm)
    PnlMain: TPanel;
    PnlNavigator: TPanel;
    PnlController: TPanel;
    PnlEditor: TPanel;
    BtnNew: TButton;
    BtnUpdate: TButton;
    BtnInsert: TButton;
    BtnDelete: TButton;
    BtnExit: TButton;
    BtnFirst: TButton;
    BtnBack: TButton;
    BtnLast: TButton;
    BtnNext: TButton;
    DaEntity: TArDaEntity;
    EdtNNumber: TArIntEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnUpdateClick(Sender: TObject);
    procedure BtnInsertClick(Sender: TObject);
    procedure BtnFirstClick(Sender: TObject);
    procedure BtnBackClick(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnLastClick(Sender: TObject);
  strict private
    FFocusComponent: TWinControl;
  protected
    procedure DoShow; override;
    property FocusComponent: TWinControl read FFocusComponent write FFocusComponent;
  public
    constructor Create(AOwner:TComponent; const ADaClass: TArObjClass); reintroduce;
  end;

implementation

{$R *.dfm}

uses MainUnit, Ppl.Da.Region;

{ TFrmMain }

procedure TMainCard.BtnBackClick(Sender: TObject);
begin
  Self.DaEntity.DataAccess.Back;
end;

procedure TMainCard.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainCard.BtnFirstClick(Sender: TObject);
begin
  Self.DaEntity.DataAccess.First;
end;

procedure TMainCard.BtnInsertClick(Sender: TObject);
begin
  Self.DaEntity.DataAccess.Insert;
end;

procedure TMainCard.BtnLastClick(Sender: TObject);
begin
  Self.DaEntity.DataAccess.Last;
end;

procedure TMainCard.BtnNewClick(Sender: TObject);
begin
  Self.DaEntity.DataAccess.New;
end;

procedure TMainCard.BtnNextClick(Sender: TObject);
begin
  Self.DaEntity.DataAccess.Next;
end;

procedure TMainCard.BtnUpdateClick(Sender: TObject);
begin
  TIDContainer(Self.DaEntity.DataAccess).Update;
end;

constructor TMainCard.Create(AOwner: TComponent; const ADaClass: TArObjClass);
begin
  inherited Create(AOwner);
  Self.DaEntity.EnumDataAccess(ADaClass);
  Self.DaEntity.DataAccess.Connection := TMainForm(AOwner).ADOConnection;
end;

procedure TMainCard.DoShow;
begin
  inherited;
  Self.DaEntity.DataAccess.New;
  if Self.FFocusComponent <> nil then Self.FFocusComponent.SetFocus;
end;

procedure TMainCard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.DaEntity.DataAccess.Free;
  Self.DaEntity.Free;
  Action := caFree;
end;

end.
