unit ArEdit;

interface

uses
  Vcl.Dialogs, System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.Graphics, WinAPI.Messages, ArOrm.Obj.Info, ArOrm.Da.Base;

type
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TDaEntity ]'}{**************************}
  TArDaEntity = class(TComponent)
  private
    FDataAccess: TArContainerBase;
    function GetDataAccess: TArContainerBase;
    procedure SetDataAccess(const AValue:TArContainerBase);
  public
    constructor Create(AOwner: TComponent); override;
    procedure EnumDataAccess(const AClassType:TArObjClass);
  published
    property DataAccess: TArContainerBase read GetDataAccess write SetDataAccess;
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TStrEdit ]'}{***************************}
  TArStrEdit = class(TLabeledEdit)
  private
    FLoadCaption: Boolean;
    FDaEntity: TArDaEntity;
    FDaField: TArDbStrField;
    function GetLabelVisible: Boolean;
    function GetLabelCaption: string;
    procedure SetLabelVisble(const AValue:Boolean);
    procedure SetLabelCaption(const AValue:string);
    function GetCaption: string;
    procedure SetCaption(const AValue:string);
  protected
    procedure DoExit; override;
    procedure LoadValue(ASender:TObject;const APutFlag:TArPutFlags);
    procedure OnChange(const APutInfo:TArPutInfo<string>);
  public
    constructor Create(AOwner: TComponent); override;
    procedure EnumField(const AField:TArDbStrField);
  published
    property DaEntity: TArDaEntity read FDaEntity write FDaEntity;
    property DaField: TArDbStrField read FDaField write FDaField;
    property LabelVisible: Boolean read GetLabelVisible write SetLabelVisble;
    property LabelCaption: string read GetLabelCaption write SetLabelCaption;
    property LoadCaption: Boolean read FLoadCaption write FLoadCaption;
    property Caption: string read GetCaption write SetCaption;
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TIntEdit ]'}{***************************}
  TArIntEdit = class(TLabeledEdit)
  private
    FLoadCaption: Boolean;
    FDaEntity: TArDaEntity;
    FDaField: TArDbField<Integer>;
    function GetLabelVisible: Boolean;
    function GetLabelCaption: string;
    procedure SetLabelVisble(const AValue:Boolean);
    procedure SetLabelCaption(const AValue:string);
    function GetCaption: string;
    procedure SetCaption(const AValue:string);
  protected
    procedure DoExit; override;
    procedure LoadValue(ASender:TObject;const AFlag:TArPutFlags);
    procedure OnChange(const APutInfo:TArPutInfo<Integer>);
  public
    constructor Create(AOwner: TComponent); override;
    procedure EnumField(const AField:TArDbField<Integer>);
  published
    property DaEntity: TArDaEntity read FDaEntity write FDaEntity;
    property DaField: TArDbField<Integer> read FDaField write FDaField;
    property LabelVisible: Boolean read GetLabelVisible write SetLabelVisble;
    property LabelCaption: string read GetLabelCaption write SetLabelCaption;
    property LoadCaption: Boolean read FLoadCaption write FLoadCaption;
    property Caption: string read GetCaption write SetCaption;
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TCustomSearchEdit ]'}{******************}
  TArCustomSearchEdit = class(TSearchBox)
  private
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FLabelSpacing: Integer;
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelSpacing(const Value: Integer);
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
    procedure CMVisiblechanged(var Message: TMessage);
      message CM_VISIBLECHANGED;
    procedure CMEnabledchanged(var Message: TMessage);
      message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage);
      message CM_BIDIMODECHANGED;

    property EditLabel: TBoundLabel read FEditLabel;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpAbove;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetupInternalLabel;
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TSearchEdit ]'}{************************}
  TArSearchEdit = class(TArCustomSearchEdit)
  private
    FLoadCaption: Boolean;
    FDaEntity: TArDaEntity;
    FDaField: TArBasicField;
    FValue: TArContainerBase;
    FValueCaption: string;
    FValueCode: string;
    procedure SetCaption(const AValue:string);
    function GetCaption: string;

  protected
    procedure InvokeSearch; override;
    procedure DoExit; override;
    procedure LoadValue(ASender:TObject);
    procedure OnFieldChange(ASender:TObject;const AFlag:TArPutFlags);
    procedure OnChange(const APutInfo:TArPutInfo<TArContainerBase>);
  public
    procedure EnumField(const AField:TArBasicField);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Value: TArContainerBase read FValue;
  published
    property EditLabel;
    property LabelPosition;
    property LabelSpacing;
    property LoadCaption: Boolean read FLoadCaption write FLoadCaption;
    property Caption: string read GetCaption write SetCaption;
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

procedure Register;

implementation

uses ArSearchDlg, System.Types;

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ Register ]'}{***************************}
procedure Register;
begin
  RegisterComponents('ArOrm', [TArDaEntity]);
  RegisterComponents('ArOrm', [TArStrEdit]);
  RegisterComponents('ArOrm', [TArIntEdit]);
  RegisterComponents('ArOrm', [TArSearchEdit]);
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TDaEntity ]'}{**************************}
constructor TArDaEntity.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TArDaEntity.EnumDataAccess(const AClassType: TArObjClass);
var
  LContainer: TArObj;
begin
  LContainer := AClassType.Create;
  Self.FDataAccess := TArContainerBase(LContainer);
end;

function TArDaEntity.GetDataAccess: TArContainerBase;
begin
  Result := Self.FDataAccess;
end;

procedure TArDaEntity.SetDataAccess(const AValue: TArContainerBase);
begin
  Self.FDataAccess := AValue;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TStrEdit ]'}{***************************}
constructor TArStrEdit.Create(AOwner: TComponent);
begin
  inherited;
  Self.LabelPosition := lpRight;
  Self.Name := 'Edt';
  Self.FLoadCaption := True;
end;

procedure TArStrEdit.DoExit;
begin
  inherited;
  if Self.FDaField <> nil then
  begin
    if Self.FDaField.Value <> Self.Text then
    begin
      if System.Length(Self.Text) = 0 then
      begin
        if Self.FDaField.IsNotNull then
          Self.FDaField.SetIsNull(True, [pfByEditor])
      end
      else Self.FDaField.SetValue(Self.Text, [pfByEditor]);
    end;
  end;
end;

procedure TArStrEdit.EnumField(const AField: TArDbStrField);
begin
  Self.FDaField := AField;
  if Self.FDaField <> nil then
  begin
    Self.FDaField.AddCondetions([ccNeeded]);
//    Self.FDaField.OnChange.Add(Self.LoadValue);
      Self.FDaField.EventsManager.AddToDoAfterChange(OnChange);
    if Self.FLoadCaption then
      Self.EditLabel.Caption := Self.FDaField.ColInfo.Caption_AR;
  end;
end;

function TArStrEdit.GetCaption: string;
begin
  Result := Self.EditLabel.Caption;
end;

function TArStrEdit.GetLabelCaption: string;
begin
  Result := Self.EditLabel.Caption;
end;

procedure TArStrEdit.SetCaption(const AValue: string);
begin
  Self.EditLabel.Caption := AValue;
end;

procedure TArStrEdit.SetLabelCaption(const AValue: string);
begin
  Self.EditLabel.Caption := AValue;
end;

function TArStrEdit.GetLabelVisible: Boolean;
begin
  Result := Self.EditLabel.Visible;
end;

procedure TArStrEdit.SetLabelVisble(const AValue: Boolean);
begin
  Self.EditLabel.Visible := AValue;
end;

procedure TArStrEdit.LoadValue;
begin
  if Self.FDaField = nil then Exit;
  if Self.FDaField.IsNull then Self.Text := ''
  else Self.Text := Self.FDaField.Value;
end;

procedure TArStrEdit.OnChange(const APutInfo:TArPutInfo<string>);
begin
  if Self.FDaField.IsNotNull then Self.Text := APutInfo.NewValue
  else Self.Text := '';
end;

{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TIntEdit ]'}{***************************}
constructor TArIntEdit.Create(AOwner: TComponent);
begin
  inherited;
  Self.LabelPosition := lpRight;
  Self.Name := 'EdtN';
  Self.FLoadCaption := True;
end;

procedure TArIntEdit.DoExit;
begin
  inherited;
  if Self.FDaField <> nil then
  begin
    if Self.FDaField.Value <> StrToInt(Self.Text) then
    begin
      if System.Length(Self.Text) = 0 then
      begin
        if Self.FDaField.IsNotNull then
          Self.FDaField.SetIsNull(True, [pfByEditor])
      end
      else Self.FDaField.SetValue(StrToInt(Self.Text), [pfByEditor]);
    end;
  end;
end;

procedure TArIntEdit.EnumField(const AField: TArDbField<Integer>);
begin
  Self.FDaField := AField;
  if Self.FDaField <> nil then
  begin
    Self.FDaField.AddCondetions([ccNeeded]);
      Self.FDaField.EventsManager.AddToDoAfterChange(OnChange);
    if Self.FLoadCaption then
      Self.EditLabel.Caption := Self.FDaField.ColInfo.Caption_AR;
  end;
end;

function TArIntEdit.GetCaption: string;
begin
  Result := Self.EditLabel.Caption;
end;

function TArIntEdit.GetLabelCaption: string;
begin
  Result := Self.EditLabel.Caption;
end;

procedure TArIntEdit.SetCaption(const AValue:string);
begin
  Self.EditLabel.Caption := AValue;
end;

procedure TArIntEdit.SetLabelCaption(const AValue: string);
begin
  Self.EditLabel.Caption := AValue;
end;

function TArIntEdit.GetLabelVisible: Boolean;
begin
  Result := Self.EditLabel.Visible;
end;

procedure TArIntEdit.SetLabelVisble(const AValue: Boolean);
begin
  Self.EditLabel.Visible := AValue;
end;

procedure TArIntEdit.LoadValue;
begin
  if Self.FDaField = nil then Exit;
  if Self.FDaField.IsNull then Self.Text := ''
  else Self.Text := Self.FDaField.Value.ToString;
end;
procedure TArIntEdit.OnChange(const APutInfo:TArPutInfo<Integer>);
begin
  if Self.FDaField.IsNotNull then Self.Text := IntToStr(APutInfo.NewValue)
  else Self.Text := '';
end;

{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TCustomSearchEdit ]'}{******************}
procedure TArCustomSearchEdit.CMBidimodechanged(var Message: TMessage);
begin
inherited;
  if FEditLabel <> nil then
    FEditLabel.BiDiMode := BiDiMode;
end;

procedure TArCustomSearchEdit.CMEnabledchanged(var Message: TMessage);
begin
inherited;
  if FEditLabel <> nil then
    FEditLabel.Enabled := Enabled;
end;

procedure TArCustomSearchEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.Visible := Visible;
end;

constructor TArCustomSearchEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabelPosition := lpAbove;
  FLabelSpacing := 3;
  SetupInternalLabel;
end;

procedure TArCustomSearchEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
end;

procedure TArCustomSearchEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

function AdjustedAlignment(RightToLeftAlignment: Boolean; Alignment: TAlignment): TAlignment;
begin
  Result := Alignment;
  if RightToLeftAlignment then
    case Result of
      taLeftJustify: Result := taRightJustify;
      taRightJustify: Result := taLeftJustify;
    end;
end;

procedure TArCustomSearchEdit.SetLabelPosition(const Value: TLabelPosition);
var
  P: TPoint;
begin
  if FEditLabel = nil then Exit;
  FLabelPosition := Value;
  case Value of
    lpAbove:
      case AdjustedAlignment(UseRightToLeftAlignment, Alignment) of
        taLeftJustify: P := Point(Left, Top - FEditLabel.Height - FLabelSpacing);
        taRightJustify: P := Point(Left + Width - FEditLabel.Width,
          Top - FEditLabel.Height - FLabelSpacing);
        taCenter: P := Point(Left + (Width - FEditLabel.Width) div 2,
          Top - FEditLabel.Height - FLabelSpacing);
      end;
    lpBelow:
      case AdjustedAlignment(UseRightToLeftAlignment, Alignment) of
        taLeftJustify: P := Point(Left, Top + Height + FLabelSpacing);
        taRightJustify: P := Point(Left + Width - FEditLabel.Width,
          Top + Height + FLabelSpacing);
        taCenter: P := Point(Left + (Width - FEditLabel.Width) div 2,
          Top + Height + FLabelSpacing);
      end;
    lpLeft : P := Point(Left - FEditLabel.Width - FLabelSpacing,
                    Top + ((Height - FEditLabel.Height) div 2));
    lpRight: P := Point(Left + Width + FLabelSpacing,
                    Top + ((Height - FEditLabel.Height) div 2));
  end;
  FEditLabel.SetBounds(P.x, P.y, FEditLabel.Width, FEditLabel.Height);
end;

procedure TArCustomSearchEdit.SetLabelSpacing(const Value: Integer);
begin
  FLabelSpacing := Value;
  SetLabelPosition(FLabelPosition);
end;

procedure TArCustomSearchEdit.SetName(const Value: TComponentName);
var
  LClearText: Boolean;
begin
  if (csDesigning in ComponentState) and (FEditLabel <> nil) and
     ((FEditlabel.GetTextLen = 0) or
     (CompareText(FEditLabel.Caption, Name) = 0)) then
    FEditLabel.Caption := Value;
  LClearText := (csDesigning in ComponentState) and (Text = '');
  inherited SetName(Value);
  if LClearText then
    Text := '';
end;

procedure TArCustomSearchEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
  FEditLabel.Visible := True;
end;

procedure TArCustomSearchEdit.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
//  FEditLabel.FocusControl := Self;
end;

{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TSearchEdit ]'}{************************}
constructor TArSearchEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.LabelPosition := lpRight;
  Self.Name := 'EdtS';
  Self.FLoadCaption := True;
end;

destructor TArSearchEdit.Destroy;
begin
  inherited;
end;

procedure TArSearchEdit.DoExit;
begin
  inherited;
  if Self.Text= '' then Exit;
  if (Self.Text <> Self.FValueCode + ' - ' + Self.FValueCaption) or
  ((Self.Text = Self.FValueCode + ' - ' + Self.FValueCaption) and (Self.FValueCaption = '')) then
  begin
    Self.InvokeSearch;
    Abort;
  end;
end;

//procedure TArSearchEdit.DrawButton(Canvas: TCanvas);
//begin
//  inherited;
//
//end;

procedure TArSearchEdit.EnumField(const AField: TArBasicField);
begin
  Self.FDaField := AField;
  if Self.FDaField <> nil then
  begin
    Self.FDaField.AddCondetions([ccNeeded]);
      TArDbField<TArContainerBase>(Self.FDaField).EventsManager.AddToDoAfterChange(OnChange);
    if Self.FLoadCaption then
      Self.EditLabel.Caption := Self.FDaField.ColInfo.Caption_AR;
  end;
end;

function TArSearchEdit.GetCaption: string;
begin
  Result := Self.EditLabel.Caption;
end;

procedure TArSearchEdit.InvokeSearch;
var
  I: Integer;
  LSearchDlg: TArSearchDialog;
  LCode, LCaption: string;
begin
  inherited;
  if Self.Text = Self.FValueCode + ' - ' + Self.FValueCaption then LCaption := Self.FValueCaption
  else LCaption := Self.Text;
  LSearchDlg := TArSearchDialog.Create(Self, Self.FDaEntity, Self.FDaField, LCaption);
  LCaption := '';
  if LSearchDlg.ShowModal = mrOk then
  begin
    Self.FValue := LSearchDlg.SearchResult;
//    Self.FValue := TArDbField<TArContainerBase>(Self.FDaField).Value;
    if Self.FValue <> nil then
    begin
      TArDbField<TArContainerBase>(Self.FDaField).SetValue(Self.FValue);
      for I := 0 to Self.FValue.Fields.Count - 1 do
      begin
        if Self.FValue.Fields.Item(I).ColSettings * [csAutoCode] <> [] then
          LCode := Self.FValue.Fields.Item(I).DaToString
        else
        if Self.FValue.Fields.Item(I).ColSettings * [csCaption] <> [] then
          if LCaption = '' then LCaption := Self.FValue.Fields.Item(I).DaToString;
      end;
      Self.FValueCaption := LCaption;
      Self.FValueCode := LCode;
      Self.Text := LCode + ' - ' + LCaption;
    end;
  end;
end;
procedure TArSearchEdit.LoadValue(ASender: TObject);
begin

end;

procedure TArSearchEdit.OnChange(const APutInfo:TArPutInfo<TArContainerBase>);
var
  I: Integer;
  LCode, LCaption: string;
begin
  if not APutInfo.WillBeNull then
  begin
    if APutInfo.NewValue <> nil then
    begin
      Self.FValue := APutInfo.NewValue;
      if Self.FValue <> nil then
      begin
        for I := 0 to Self.FValue.Fields.Count - 1 do
        begin
          if Self.FValue.Fields.Item(I).ColSettings * [csAutoCode] <> [] then
            LCode := Self.FValue.Fields.Item(I).DaToString
          else
          if Self.FValue.Fields.Item(I).ColSettings * [csCaption] <> [] then
            if LCaption = '' then LCaption := Self.FValue.Fields.Item(I).DaToString;
        end;
        Self.FValueCaption := LCaption;
        Self.FValueCode := LCode;
        Self.Text := LCode + ' - ' + LCaption;
      end
      else Self.Text := '';
    end
    else
    begin
      Self.FValue := nil;
      Self.Text := '';
    end;
  end
  else
  begin
    Self.FValue := nil;
    Self.Text := '';
  end;
end;

procedure TArSearchEdit.OnFieldChange(ASender: TObject;const AFlag:TArPutFlags);
var
  I: Integer;
  LCode, LCaption: string;
begin
  if Self.FDaField.IsNull then Self.FValue := nil
  else Self.FValue := TArDbField<TArContainerBase>(Self.FDaField).Value;
  if Self.FValue <> nil then
  begin
    for I := 0 to Self.FValue.Fields.Count - 1 do
    begin
      if Self.FValue.Fields.Item(I).ColSettings * [csAutoCode] <> [] then
        LCode := Self.FValue.Fields.Item(I).DaToString
      else
      if Self.FValue.Fields.Item(I).ColSettings * [csCaption] <> [] then
        if LCaption = '' then LCaption := Self.FValue.Fields.Item(I).DaToString;
    end;
    Self.FValueCaption := LCaption;
    Self.FValueCode := LCode;
    Self.Text := LCode + ' - ' + LCaption;
  end
  else Self.Text := '';
end;

procedure TArSearchEdit.SetCaption(const AValue: string);
begin
  Self.EditLabel.Caption := AValue;
end;

{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
end.
