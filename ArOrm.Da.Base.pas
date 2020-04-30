unit ArOrm.Da.Base;

interface
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TEMP ]'}{*******************************}
{
type
  TNotifyEventWrapper = class(TComponent)
  private
    FProc: TProc<TObject>;
  public
    constructor Create(Owner: TComponent; Proc: TProc<TObject>);
  published
    procedure Event(Sender: TObject);
  end;

constructor TNotifyEventWrapper.Create(Owner: TComponent; Proc: TProc<TObject>);
begin
  inherited Create(Owner);
  FProc := Proc;
end;

procedure TNotifyEventWrapper.Event(Sender: TObject);
begin
  FProc(Sender);
end;

function AnonProc2NotifyEvent(Owner: TComponent; Proc: TProc<TObject>): TNotifyEvent;
begin
  Result := TNotifyEventWrapper.Create(Owner, Proc).Event;
end;


Button1.OnClick := AnonProc2NotifyEvent(
  Button1,
  procedure(Sender: TObject)
  begin
    (Sender as TButton).Caption := 'Clicked';
  end
);
-------------------------------------------


}
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
uses System.Generics.Collections, System.Classes, Data.Win.ADODB, ArOrm.Obj.Info;
{///////////////////////////////////////////////////////////////////////////}
type
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TBases ]'}{*****************************}
{######################}{$REGION '[ Types ]'}{##############################}
  TArClass = (acUnknown, acBasicField, acDaField, acDaStrField, acDbField, acDbStrField, acDaList);
  TArColSetting = (csIdentity, csAutoNumber, csAutoCode, csRandom, csCaption, csNotNull, csUnique,
    csPrimaryKey, csForeignKey);
  TArColCondetion = (ccNull, ccReadOnly, ccLocked, ccDisabled, ccHidden, ccChanged, ccNeeded);
  TArPutFlag = (pfInLoad, pfNew, pfByEditor, pfUserFlagA, pfUserFlagB);
  TArColSettings = set of TArColSetting;
  TArColCondetions = set of TArColCondetion;
  TArPutFlags = set of TArPutFlag;
  TBeforeChange = procedure of object;
  TAfterChange = procedure of object;
  TArAfterValueSet<T> = procedure(ASender:TObject;const AOld,ANew:T;const APutFlags:TArPutFlags);
  TArBeforeValueSet<T> = procedure(ASender:TObject;const AOld,ANew:T;const APutFlags:TArPutFlags);
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Bases ]'}{##############################}
  TArFilter = class;
  TArContainerBase = class;
  TArContainerClass = class of TArContainerBase;
  TArObjClass = class of TArObj;
  TArObj = class abstract(TInterfacedObject)
  strict private
    FOwner: TArObj;
  public
    constructor Create; overload; virtual; abstract;
    constructor Create(const AOwner:TArObj); overload; virtual;
    {================[ Fields ]================}
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; virtual;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; virtual;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; virtual;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ALength:Integer;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; virtual;

    class function GetActualClass: TArClass; virtual;
    class function GetActualTypeKind: TTypeKind; virtual;
    class function GetActualType: TArObjClass; virtual;
    property Owner: TArObj read FOwner;
  end;

  TArFieldBaseClass = class of TArFieldBase;
  TArFieldBase = class abstract(TArObj)
  end;

  TArFnResult = record
    Done: Boolean;
    Message: string;
    procedure ErrorResult(const AMessage:string);
    procedure DoneResult(const AMessage:string);
  end;

{######################}{$ENDREGION}{#######################################}
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TChangeEvent ]'}{***********************}
  TArPutInfo<T> = record
  strict private
    FOldValue: T;
    FNewValue: T;
    FWasNull: Boolean;
    FWillBeNull: Boolean;
    FPutFlags: TArPutFlags;
  public
    procedure SetPutFlags(const APutFlags: TArPutFlags);
    procedure SetOldValue(const AValue:T);
    procedure SetNewValue(const AValue:T);
    procedure SetWasNull(const AValue:Boolean);
    procedure SetWillBeNull(const AValue:Boolean);
    property OldValue: T read FOldValue write FOldValue;
    property NewValue: T read FNewValue write FNewValue;
    property WasNull: Boolean read FWasNull write FWasNull;
    property WillBeNull: Boolean read FWillBeNull write FWillBeNull;
    property PutFlags: TArPutFlags read FPutFlags write FPutFlags;
  end;

  TArChangeEvent<T> = reference to procedure(const APutInfo:TArPutInfo<T>);
  TArEventsManager<T> = class(TArObj)
  strict private
    FChangingEvents: TList<TArChangeEvent<T>>;
    FChangedEvents: TList<TArChangeEvent<T>>;
    FPutInfo: TArPutInfo<T>;
  public
    constructor Create(const Owner:TArObj); override;
    procedure DoAfterChangeEvents;
    procedure DoBeforeChangeEvents;
    procedure AddToDoAfterChange(const AEvent:TArChangeEvent<T>);
    procedure AddToDoBeforeChange(const AEvent:TArChangeEvent<T>);

    property PutInfo: TArPutInfo<T> read FPutInfo write FPutInfo;
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TFields ]'}{****************************}
{######################}{$REGION '[ BaseicField ]'}{########################}
  TArBasicField = class abstract(TArFieldBase)
  strict private type
    EvOnChange = TNotifyEvent;
    TCaptions = TArray<TArColumn>;
  strict private
    FDaClassType: TArObjClass;
    FDbOwner: TArTable;
    FColInfo: TArColumn;
    FColSettings: TArColSettings;
    FColCondetions: TArColCondetions;
    FCaptions: TCaptions;
    function fnGetIsNull: Boolean;
    function fnGetIsNotNull: Boolean;
    function fnGetIsChanged: Boolean;
    procedure proSetIsNull(const AValue:Boolean); overload;
    procedure proSetIsChanged(const AValue:Boolean);
  public
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ALength:Integer;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;


    function GetFullPath: string;
    function DaToString: string; virtual; abstract;
    procedure AddCondetions(const ACondetions: array of TArColCondetion);
    procedure SetIsNull(const AValue:Boolean;const APutFlags:TArPutFlags=[]); overload; virtual;

    procedure DoBeforeChange; virtual; abstract;
    procedure DoAfterChange; virtual; abstract;
    procedure SetEventManagerPutFlags(const APutFlags:TArPutFlags); virtual; abstract;
    procedure SetWasWillNull(const AWas, AWill:Boolean); virtual; abstract;

    property ColInfo: TArColumn read FColInfo write FColInfo;
    property DaClassType: TArObjClass read FDaClassType;
    property ColSettings: TArColSettings read FColSettings write FColSettings;
    property ColCondetions: TArColCondetions read FColCondetions write FColCondetions;
    property DbOwner: TArTable read FDbOwner;
    property IsNull: Boolean read fnGetIsNull write proSetIsNull;
    property IsNotNull: Boolean read fnGetIsNotNull;
    property IsChanged: Boolean read fnGetIsChanged write proSetIsChanged;
    property Captions: TCaptions read FCaptions write FCaptions;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DaField ]'}{############################}
  TArDaField<T> = class(TArBasicField)
  strict private
    FDaValue: T;
    FEventsManager: TArEventsManager<T>;
  public
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]); override;

    function DaToString: string; override;

    procedure SetValue(const AValue:T; const APutFlags:TArPutFlags=[]); virtual;
    procedure SetIsNull(const AValue: Boolean; const APutFlags: TArPutFlags = []); override;
    procedure DoAfterChange; override;
    procedure DoBeforeChange; override;
    procedure SetEventManagerPutFlags(const APutFlags: TArPutFlags); override;
    procedure SetWasWillNull(const AWas: Boolean; const AWill: Boolean); override;

    class function GetActualClass: TArClass; override;
    class function GetActualTypeKind: TTypeKind; override;
    class function GetActualType: TArObjClass; override;

    property EventsManager: TArEventsManager<T> read FEventsManager write FEventsManager;
    property Value: T read FDaValue write FDaValue;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DbField ]'}{############################}
  TArDbField<T> = class(TArDaField<T>)
  strict private
    FDbValue: T;

  public
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      override;

    procedure SetValue(const AValue:T; const APutFlags:TArPutFlags=[]); override;

    class function GetActualClass: TArClass; override;
    class function GetActualType: TArObjClass; override;
    property DbValue: T read FDbValue write FDbValue;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DaStrField ]'}{#########################}
  TArDaStrField = class(TArDaField<string>)
  strict private
    FLength: Integer;
  public
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ALength:Integer;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    class function GetActualClass: TArClass; override;

    property Length: Integer read FLength write FLength;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DbStrField ]'}{#########################}
  TArDbStrField = class(TArDbField<string>)
  strict private
    FLength: Integer;
  public
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;
    constructor Create(const AOwner:TArObj;
      const AColumn:TArColumn;const ALength:Integer;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    class function GetActualClass: TArClass; override;

    property Length: Integer read FLength write FLength;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DaList ]'}{#############################}
  TArDaList<T> = class(TArBasicField)
  strict private
    FFilter: TArFilter;
    FValue: TList<T>;
    FContainerClassType: TArObjClass;
    FEventsManager: TArEventsManager<T>;

    function GetCount: Integer;
  public
    constructor Create; override;
    constructor Create(const AOwner:TArObj;const AColumn:TArColumn;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]); overload; override;
    constructor Create(const AOwner:TArObj;const AClassType:TArObjCLass;const AColumn:TArColumn;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]); overload;

    class function GetActualClass: TArClass; override;

    function Item(const AIndex:Integer): T;
    function LoadFilter: TArFnResult;
    function DaToString: string; override;

    procedure Search(const AValue:string);
    procedure SetIsNull(const AValue:Boolean;const APutFlags:TArPutFlags=[]); override;

    procedure DoAfterChange; override;
    procedure DoBeforeChange; override;
    procedure SetEventManagerPutFlags(const APutFlags: TArPutFlags); override;
    procedure SetWasWillNull(const AWas: Boolean; const AWill: Boolean); override;

    property Items: TList<T> read FValue write FValue;
    property Count: Integer read GetCount;
    property Filter: TArFilter read FFilter write FFilter;
    property EventsManager: TArEventsManager<T> read FEventsManager;
    property ContainerClassType: TArObjClass read FContainerClassType write FContainerClassType;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DaInsList ]'}{##########################}
  TArDaInsList = class(TArDaList<TArContainerBase>)
  strict private
    FClassType: TArObjClass;
  public
    constructor Create(const AClassType:TArObjClass; const AOwner:TArObj;const AColumn:TArColumn;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]); reintroduce;
//    class function GetActualClass: TArClass; override;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DaSelect ]'}{###########################}
  TArDaSelect<T> = class(TArDaField<T>)
  strict private
    FItems: TArray<T>;
    FSelectedItem: Integer;
    FClassType: TArObjClass;

  public
    constructor Create(const AClassType:TArObjClass; const AOwner:TArObj;const AColumn:TArColumn;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]); reintroduce;
//    class function GetActualClass: TArClass; override;

    procedure SetValue(const AValue:T; const APutFlags:TArPutFlags=[]); virtual;

    property Items: TArray<T> read FItems write FItems;
    property SelectedItem: Integer read FSelectedItem write FSelectedItem;
  end;
{######################}{$ENDREGION}{#######################################}
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}

{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TFilter ]'}{****************************}
  TArFilter = class(TArObj)
  strict private type
  {####################}{$REGION '[ Types ]'}{##############################}
    TArFilterComparison = (fcGreaterThan, fcGreaterOrEqual, fcLessThan, fcLessOrEqual,
      fcEqual, fcNotEual, fcIsNull, fcIsNotNull, fcLike, fcNotLike);
    TArFilterOperator = (foNone, foAnd, foOr, foAndNot, foOrNot);
    TArFilterPart = record
      Field: TArBasicField;
      Comparison: TArFilterComparison;
      Value: string;
    end;
  {####################}{$ENDREGION}{#######################################}
  strict private
    FSubFilters: array of TArFilter;
    FSubOperator: TArFilterOperator;
    FFilter: TArFilterPart;
    {##################}{$REGION '[ Events ]'}{#############################}
    function GetSubFilter(const I:Integer): TArFilter;
    function GetSubFiltersCount: Integer;
    procedure SetSubFilterCount(const AValue:Integer);
    function NewWhere(const AOperator:TArFilterOperator;const AField:TArBasicField;
      const AComparison:TArFilterComparison;const AValue:string): TArFilter; overload;
    function NewWhere(const AOperator:TArFilterOperator;const AFilter:TArFilter): TArFilter; overload;
    {##################}{$ENDREGION}{#######################################}
  public
    constructor Create; override;
    procedure InsertSubFilter(const AFilter:TArFilter);
    {##################}{$REGION '[ Where ]'}{##############################}
    function Where(const AField:TArBasicField;const AComparison:TArFilterComparison;
      const AValue:string): TArFilter; overload;

    function Where(const ACol:TArColumn;const AComparison:TArFilterComparison;
      const AValue:string): TArFilter; overload;

    function AndWhere(const AField:TArBasicField;const AComparison:TArFilterComparison;
      const AValue:string): TArFilter; overload;

    function AndWhere(const AFilter:TArFilter): TArFilter; overload;

    function OrWhere(const AField:TArBasicField;const AComparison:TArFilterComparison;
      const AValue:string): TArFilter; overload;

    function OrWhere(const AFilter:TArFilter): TArFilter; overload;

    function AndNotWhere(const AField:TArBasicField;const AComparison:TArFilterComparison;
      const AValue:string): TArFilter; overload;

    function AndNotWhere(const AFilter:TArFilter): TArFilter; overload;

    function OrNotWhere(const AField:TArBasicField;const AComparison:TArFilterComparison;
      const AValue:string): TArFilter; overload;

    function OrNotWhere(const AFilter:TArFilter): TArFilter; overload;
    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ Events ]'}{#############################}
    function ComparisonAsString(const AComparison:TArFilterComparison): string;
    function OperatorAsString(const AOperator:TArFilterOperator): string;
    {##################}{$ENDREGION}{#######################################}
    {##################}{$REGION '[ Properties ]'}{#########################}
    property SubFiltersCount: Integer read GetSubFiltersCount write SetSubFilterCount;
    property SubFilter[const I:Integer]: TArFilter read GetSubFilter;
    property SubOperator: TArFilterOperator read FSubOperator write FSubOperator;
    property Filter: TArFilterPart read FFilter write FFilter;
    {##################}{$ENDREGION}{#######################################}
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TEnumorators ]'}{***********************}
{######################}{$REGION '[ Base ]'}{###############################}
  TArEnumorator = class(TArObj)
    constructor Create(const AOwner:TArObj); override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; virtual; abstract;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; virtual; abstract;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; virtual; abstract;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;const ADbOwner:TArTable;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; virtual; abstract;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALinkCol:TArColumn;
      const ALinkedContainer:TArContainerBase;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; virtual; abstract;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Creator ]'}{############################}
  TArObjCreator = class(TArEnumorator)
  public
    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALinkCol:TArColumn;
      const ALinkedContainer:TArContainerBase;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Newer ]'}{##############################}
  TArObjNewer = class(TArEnumorator)
    function IncCode(const AValue:string): string;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALinkCol:TArColumn;
      const ALinkedContainer:TArContainerBase;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Updater ]'}{############################}
  TArObjUpdater = class(TArEnumorator)
  strict private type
    TTableValue = record
      TableInfo: TArTable;
      FieldsNames: array of string;
      FieldsValues: array of string;
    end;
  strict private
    FQuery: TADOQuery;
    FTables: array of TTableValue;
  public
    procedure Update(const AID:Integer);

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALinkCol:TArColumn;
      const ALinkedContainer:TArContainerBase;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;
  end;
{######################}{$ENDREGION}{#####################################}
{######################}{$REGION '[ Loader ]'}{#############################}

  TArTableValue = record
    TableInfo: TArTable;
    Fields: array of TArBasicField;
  end;

  TArObjLoader = class(TArEnumorator)
  strict private type
    TArTablesValues = array of TArTableValue;
    TArLoadPreposition = (lpLoad, lpSearch, lpCreateDB);
  strict private
    FQuery: TADOQuery;
    FLoadPreposetion: TArLoadPreposition;
    FTables: TArTablesValues;
    function GetTablesCount: Integer;
  public
    constructor Create(const AOwner:TArObj; APreposetion:TArLoadPreposition); reintroduce;

    function GenerateFilter(const AFilter:TArFilter): string; overload;
    function GenerateFilter(const AValue:string):TArFilter; overload;
    function IDLocation(const AFilter:TArFilter): string;

    procedure Load(const AID:Integer); overload;
    procedure Load(const AFilter: TArFilter); overload;
    procedure Load; overload;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALinkCol:TArColumn;
      const ALinkedContainer:TArContainerBase;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    property TablesCount: Integer read GetTablesCount;
    property Tables: TArTablesValues read FTables write FTables;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ LoaderApplay ]'}{#######################}
  TArObjLoaderApplayer = class(TArEnumorator)
  strict private
    FQuery: TADOQuery;
    FCurrentTableID: Integer;
    FCurrentLooper: Integer;
  public
    constructor Create(const AOwner: TArObj); override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALinkCol:TArColumn;
      const ALinkedContainer:TArContainerBase;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;
  end;
{**********************}{$ENDREGION}{***************************************}
{#########   ##########}{$REGION '[ Saver ]'}{##############################}
  TArObjSaver = class(TArEnumorator)
    {
    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;
      }
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Inserter ]'}{###########################}
  TArObjInserter = class(TArEnumorator)
  strict private type
    TTableValue = record
      TableName: string;
      FieldsNames: string;
      FieldsValues: string;
    end;
  strict private
    FQuery: TADOQuery;
    FTables: array of TTableValue;
  public
    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALinkCol:TArColumn;
      const ALinkedContainer:TArContainerBase;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure Insert;
  end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Searcher ]'}{############################}
  TArObjSearcher = class(TArEnumorator)
  strict private type
    TTableValue = record
      TableInfo: TArTable;
      FieldsNames: array of string;
    end;
  strict private
//    FQuery: TADOQuery;
    FTables: array of TTableValue;
  public
    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALength:Integer;
      const ADbOwner:TArTable;const ASettings:TArColSettings=[];const ACondetions:TArColCondetions=[]);
      overload; override;

    procedure EnumField(var AObj:TArObj;const AClassType:TArObjClass;
      const AColumn:TArColumn;const ALinkCol:TArColumn;
      const ALinkedContainer:TArContainerBase;const ASettings:TArColSettings=[];
      const ACondetions:TArColCondetions=[]);
      overload; override;

    function Search(const AFilter:TArFilter): TArFnResult;
  end;
{######################}{$ENDREGION}{#######################################}
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TContainers ]'}{************************}

  TArTableCondetion = (tcNew, tcUpdated, tcSaved, tcLoadded, tcDeleted);

  TArContainerBase = class(TArObj)
  strict private
    FFields: TArDaList<TArBasicField>;
    FFilter: TArFilter;
    FTableInfo: TArTable;

    FCreator: TArEnumorator;
    FNewer: TArEnumorator;
    FInserter: TArEnumorator;
    FLoader: TArEnumorator;
    FLOaderApplayer: TArEnumorator;
    FUpdator: TArEnumorator;


//    FSearcher: TArEnumorator;
//    FSaver: TArEnumorator;
//    FDeleter: TArEnumorator;

    FADOConnection: TADOConnection;
    FADOQuery: TADOQuery;
  strict protected
    procedure DoBeforeCreate; virtual;
    procedure DoAfterCreate; virtual;
  public
    constructor Create; override;
    constructor Create(const AOwner:TArObj); override;
    procedure EnumFields(const AEnumorator:TArEnumorator); virtual; abstract;

    procedure Next; virtual; abstract;
    procedure Back; virtual; abstract;
    procedure Last; virtual; abstract;
    procedure First; virtual; abstract;

    function New: TArFnResult; virtual;
    function Insert: TArFnResult; virtual;
    procedure BeforeInsert; virtual;
    function Load(const AID:Integer): TArFnResult; virtual;
    function LoadFilter: TArFnResult; virtual;
    function Update(const AID:Integer): TArFnResult; virtual;
    function Search: TArFnResult; virtual;
//    function Save: TArFnResult; virtual;
//    function Delete: TArFnResult; virtual;

    class function TableInfo_cls: TArTable; virtual; abstract;

    property Fields: TArDaList<TArBasicField> read FFields;
    property Filter: TArFilter read FFilter write FFilter;
    property TableInfo: TArTable read FTableInfo write FTableInfo;
    property Connection: TADOConnection read FADOConnection write FADOConnection;
    property Query: TADOQuery read FADOQuery write FADOQuery;
  end;

  TIDContainer = class(TArContainerBase)
  strict protected
    FID: TArDbField<Integer>;
  public
    function Load: TArFnResult; reintroduce; virtual;
    function Update: TArFnResult; reintroduce; virtual;

    procedure EnumFields(const AEnumorator:TArEnumorator); override;

    procedure First; override;
    procedure Last; override;
    procedure Next; override;
    procedure Back; override;

    property FldID: TArDbField<Integer> read FID;
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TDatabaseCreator]'}{********************}
  TArDatabaseCreator = class(TArObj)
  strict private type
    TArContainerClassArray = array of TArContainerClass;
  strict private
    FConnection: TADOConnection;
    FRecreate: Boolean;
    FDatabaseName: string;
    FTables: TArContainerClassArray;
    procedure SetDatabaseName(const AValue:string);
  public
    constructor Create(const AConnection:TADOConnection;const ARecreate:Boolean=False);

    function TableExists(const ATableName:string): Boolean;
    function GetFieldSettings(const AField:TArBasicField): TStringList;
    function DatabaseExists(const ADatabaseName:string):Boolean;
    function GetFieldProperty(const AField:TArBasicField): string;
    function Reconnect(const ADatabaseName:string): Boolean;

    procedure CreateDataBase(const ADatabaseName:string);
    procedure CreateDataBaseWhileNotExists(const ADatabaseName:string);
    procedure DropDataBaseWhileExists(const ADatabaseName:string);
    property Rereate: Boolean read FRecreate write FRecreate;
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
    property Tables: TArContainerClassArray read FTables write FTables;
  end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
implementation
{///////////////////////////////////////////////////////////////////////////}
uses ArOrm.Consts, System.Rtti, System.TypInfo, System.SysUtils, Data.Db;
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TBases ]'}{****************************}
constructor TArObj.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin
  Self.FOwner := AOwner;
end;

constructor TArObj.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ADbOwner: TArTable;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  Self.FOwner := AOwner;
end;

constructor TArObj.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ALength: Integer;
  const ADbOwner: TArTable; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  Self.FOwner := AOwner;
end;

constructor TArObj.Create(const AOwner: TArObj);
begin
  Self.FOwner := AOwner;
end;

constructor TArObj.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ALength: Integer;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  Self.FOwner := AOwner;
end;

class function TArObj.GetActualClass: TArClass;
begin
  Result := acUnknown;
end;

class function TArObj.GetActualType: TArObjClass;
begin
  Result := TArObj;
end;

class function TArObj.GetActualTypeKind: TTypeKind;
begin
  Result := tkClass;
end;

{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TFields ]'}{****************************}
{######################}{$REGION '[ BaseicField ]'}{########################}
constructor TArBasicField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ADbOwner: TArTable;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  inherited;
  Self.FDbOwner := ADbOwner;
  Self.FColInfo := AColumn;
  Self.FColSettings := ASettings;
  Self.FColCondetions := ACondetions;
  TArContainerBase(Self.Owner).Fields.Items.Add(Self);
end;


constructor TArBasicField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  inherited;
  Self.FColInfo := AColumn;
  Self.FColSettings := ASettings;
  Self.FColCondetions := ACondetions;
//  TArContainerBase(Self.Owner).Fields.Items.Add(Self);
end;

constructor TArBasicField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ALength: Integer; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin
  inherited;
end;

procedure TArBasicField.AddCondetions(const ACondetions: array of TArColCondetion);
var
  LCondetion: TArColCondetion;
  I: Integer;
begin
  for I := 0 to System.Length(ACondetions) - 1 do
  begin
    LCondetion := ACondetions[I];
    if not (LCondetion in Self.FColCondetions) then
      Self.FColCondetions := Self.FColCondetions + [LCondetion];
  end;
end;

constructor TArBasicField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ALength: Integer; const ADbOwner: TArTable;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  inherited;
  Self.FDbOwner := ADbOwner;
end;

function TArBasicField.fnGetIsChanged: Boolean;
begin
  Result := ccChanged in Self.FColCondetions;
end;

function TArBasicField.fnGetIsNotNull: Boolean;
begin
  Result := not (ccNull in Self.FColCondetions);
end;

function TArBasicField.fnGetIsNull: Boolean;
begin
  Result := ccNull in Self.FColCondetions;
end;

function TArBasicField.GetFullPath: string;
begin
  Result := TArContainerBase(Self.Owner).TableInfo_cls.Name + '.' + Self.FColInfo.Name;
end;

procedure TArBasicField.proSetIsChanged(const AValue: Boolean);
begin
  if AValue then Self.FColCondetions := Self.FColCondetions + [ccChanged]
  else Self.FColCondetions := Self.FColCondetions - [ccChanged];
end;

procedure TArBasicField.proSetIsNull(const AValue: Boolean);
begin
  Self.FColCondetions := Self.FColCondetions + [ccNull];
end;

procedure TArBasicField.SetIsNull(const AValue: Boolean; const APutFlags: TArPutFlags);
begin
  Self.SetEventManagerPutFlags(APutFlags);
  Self.SetWasWillNull(Self.IsNull, AValue);
  Self.DoBeforeChange;
  if AValue then Self.FColCondetions := Self.FColCondetions + [ccNull]
  else Self.FColCondetions := Self.FColCondetions - [ccNull];
  if pfInLoad in APutFlags then Self.FColCondetions := Self.FColCondetions - [ccChanged]
  else Self.FColCondetions := Self.FColCondetions + [ccChanged];
  Self.DoAfterChange;
end;

{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DaField ]'}{############################}
constructor TArDaField<T>.Create(const AOwner:TArObj;
  const AColumn: TArColumn; const ASettings: TArColSettings=[]; const ACondetions:TArColCondetions=[]);
var
  LClassType: TClass;
  Info     : PTypeInfo;
  LObjValue: TObject;
  LRefValue: T ABSOLUTE LObjValue;
begin
  inherited;
  Self.FEventsManager := TArEventsManager<T>.Create(Self);
  Info := System.TypeInfo(T);
  if Info <> nil then
  begin
    if Info^.Kind = tkClass then
    begin
      if (Owner = nil) or ((Owner <> nil) and (Owner.Owner = nil)) then
      begin
        LClassType := GetTypeData(Info).ClassType;
        LObjValue := TArObjClass(LClassType).Create(Self);
        FDaValue := LRefValue;
      end;
    end;
  end;
end;

function TArDaField<T>.DaToString: string;
var
  LContainer: TIDContainer;
begin
//  if Self.GetActualClass = '' then
//  if Self.GetActualTypeKind = '' then
//  if Self.GetActualType = '' then
//  exit;
  if Self.GetActualTypeKind = tkClass then
  begin
    LContainer := TIDContainer(TValue.From<T>(Self.Value).AsObject);
    Result := LContainer.FldID.Value.ToString;
  end
  else Result := TValue.From<T>(Self.FDaValue).ToString;
end;

procedure TArDaField<T>.DoAfterChange;
begin
  Self.FEventsManager.DoAfterChangeEvents;
end;

procedure TArDaField<T>.DoBeforeChange;
begin
  Self.FEventsManager.DoBeforeChangeEvents;
end;

class function TArDaField<T>.GetActualClass: TArClass;
begin
  Result := acDaField;
end;

class function TArDaField<T>.GetActualType: TArObjClass;
var
  LClassType: TClass;
  LTypeInfo: PTypeInfo;
  LObjValue: TObject;
  LRefValue: T ABSOLUTE LObjValue;
begin
  LTypeInfo := System.TypeInfo(T);
  if LTypeInfo <> nil then
  begin
    LClassType := GetTypeData(LTypeInfo).ClassType;
    Result := TArObjClass(LClassType);
  end;
end;

class function TArDaField<T>.GetActualTypeKind: TTypeKind;
var
  LClassType: TClass;
  Info     : PTypeInfo;
  LObjValue: TObject;
  LRefValue: T ABSOLUTE LObjValue;
begin
  Info := System.TypeInfo(T);
  if Info <> nil then
    Result := Info^.Kind
  else
    Result := tkUnknown;
end;

procedure TArDaField<T>.SetEventManagerPutFlags(const APutFlags: TArPutFlags);
begin
  Self.FEventsManager.PutInfo.SetPutFlags(APutFlags);
end;

procedure TArDaField<T>.SetIsNull(const AValue: Boolean; const APutFlags: TArPutFlags);
begin
  inherited;
end;

procedure TArDaField<T>.SetValue(const AValue: T; const APutFlags: TArPutFlags);
var
  I: Integer;
begin
  Self.SetWasWillNull(Self.IsNull, False);
  Self.EventsManager.PutInfo.SetOldValue(Self.Value);
  Self.EventsManager.PutInfo.SetNewValue(AValue);
  Self.FEventsManager.DoBeforeChangeEvents;

  Self.FDaValue := AValue;
  if [pfInLoad, pfNew] * APutFlags = [] then
    Self.ColCondetions := Self.ColCondetions + [ccChanged]
  else
    Self.ColCondetions := Self.ColCondetions - [ccChanged];
  Self.ColCondetions := Self.ColCondetions - [ccNull];
  Self.FEventsManager.DoAfterChangeEvents;
//    if Assigned(Self.OnChange) then {OnChange(Self, APutFlags);}
//    begin
//      for I := 0 to Self.OnChange.Count - 1 do
//        Self.OnChange[I];
//    end;
end;

procedure TArDaField<T>.SetWasWillNull(const AWas, AWill: Boolean);
begin
  Self.FEventsManager.PutInfo.SetWasNull(AWas);
  Self.FEventsManager.PutInfo.SetWillBeNull(AWill);
end;

{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DbField ]'}{############################}
constructor TArDbField<T>.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ADbOwner: TArTable;const ASettings: TArColSettings=[];
  const ACondetions:TArColCondetions=[]);
var
  {context : TRttiContext;typeInfo : TRttiType;prop : TRttiProperty;item : T;v : TValue;}
  LClassType: TClass;
  LTypeInfo: PTypeInfo;
  LObjValue: TObject;
  LRefValue: T ABSOLUTE LObjValue;
begin
  {context := TRttiContext.Create;try typeInfo := context.GetType(System.TypeInfo(T));finallycontext.Free;end;}
  inherited Create(AOwner, AColumn, ADbOwner, ASettings, ACondetions);
  Self.EventsManager := TArEventsManager<T>.Create(Self);
  LTypeInfo := System.TypeInfo(T);
  if LTypeInfo <> nil then
  begin
    if LTypeInfo^.Kind = tkClass then
    begin
      if (Owner <> nil) and (Owner.Owner <> nil) then
      begin

      end
      else
      begin
        LClassType := GetTypeData(LTypeInfo).ClassType;
        LObjValue := TArObjClass(LClassType).Create(Self);
        FDbValue := LRefValue;
      end;
    end;
  end;
end;

class function TArDbField<T>.GetActualClass: TArClass;
begin
  Result := acDbField;
end;
class function TArDbField<T>.GetActualType: TArObjClass;
begin
  Result := inherited GetActualType;
end;

procedure TArDbField<T>.SetValue(const AValue: T; const APutFlags: TArPutFlags);
var
  LClassType: TClass;
  Info     : PTypeInfo;
  LKind: TTypeKind;
  LObjValue: TObject;
  LRefValue: T ABSOLUTE LObjValue;
begin
  inherited;
  if pfInLoad in APutFlags then
  begin
    Self.FDbValue := AValue;
  end
  else
  begin
    Info := System.TypeInfo(T);
    LKind := Info^.Kind;
    if Info <> nil then
    begin
      case LKind of
        tkUnknown: ;
        tkInteger:
          if TValue.From<T>(Self.FDbValue).AsInteger <> TValue.From<T>(AValue).AsInteger then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkChar:
          if TValue.From<T>(Self.FDbValue).AsString <> TValue.From<T>(AValue).AsString then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkEnumeration: ;
        tkFloat:
          if TValue.From<T>(Self.FDbValue).AsExtended <> TValue.From<T>(AValue).AsExtended then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkString:
          if TValue.From<T>(Self.FDbValue).AsString <> TValue.From<T>(AValue).AsString then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkSet: ;
        tkClass:
          if TValue.From<T>(Self.FDbValue).AsObject <> TValue.From<T>(AValue).AsObject then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkMethod: ;
        tkWChar:
          if TValue.From<T>(Self.FDbValue).AsString <> TValue.From<T>(AValue).AsString then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkLString:
          if TValue.From<T>(Self.FDbValue).AsString <> TValue.From<T>(AValue).AsString then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkWString:
          if TValue.From<T>(Self.FDbValue).AsString <> TValue.From<T>(AValue).AsString then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkVariant: ;
        tkArray: ;
        tkRecord: ;
        tkInterface: ;
        tkInt64:
          if TValue.From<T>(Self.FDbValue).AsInt64 <> TValue.From<T>(AValue).AsInt64 then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkDynArray: ;
        tkUString:
          if TValue.From<T>(Self.FDbValue).AsString <> TValue.From<T>(AValue).AsString then
            Self.ColCondetions := Self.ColCondetions + [ccChanged]
          else
            Self.ColCondetions := Self.ColCondetions - [ccChanged];
        tkClassRef: ;
        tkPointer: ;
        tkProcedure: ;
      end;
    end;
  end;
end;

{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DaStrField ]'}{#########################}
constructor TArDaStrField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ALength: Integer; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin
  inherited;
  Self.EventsManager := TArEventsManager<string>.Create(Self);
  Self.FLength := ALength;
end;

constructor TArDaStrField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin
  inherited;
end;

constructor TArDaStrField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin
  inherited;
  Self.EventsManager := TArEventsManager<string>.Create(Self);
end;

constructor TArDaStrField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ALength: Integer; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin
  inherited;
  Self.EventsManager := TArEventsManager<string>.Create(Self);
end;

class function TArDaStrField.GetActualClass: TArClass;
begin
  Result := acDaStrField;
end;

{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ DbStrField ]'}{#########################}
constructor TArDbStrField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ALength: Integer; const ADbOwner: TArTable;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  inherited Create(AOwner, AColumn, ADbOwner, ASettings, ACondetions);
//  Self.EventsManager := TArEventsManager<string>.Create(Self);
  Self.FLength := ALength;
end;

constructor TArDbStrField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  inherited;
  Self.EventsManager := TArEventsManager<string>.Create(Self);
end;

constructor TArDbStrField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin
  inherited;
end;

constructor TArDbStrField.Create(const AOwner: TArObj;
  const AColumn: TArColumn; const ALength: Integer; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin
  inherited;
  Self.EventsManager := TArEventsManager<string>.Create(Self);
end;

class function TArDbStrField.GetActualClass: TArClass;
begin
  Result := acDbStrField;
end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ List ]'}{###############################}
constructor TArDaList<T>.Create(const AOwner: TArObj;const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  LClassType: TClass;
  LTypeInfo: PTypeInfo;
  LObjValue: TObject;
  LRefValue: T ABSOLUTE LObjValue;
begin
  inherited;
  Self.FEventsManager := TArEventsManager<T>.Create(Self);
  Self.FValue := TList<T>.Create;

  LTypeInfo := System.TypeInfo(T);
  if LTypeInfo <> nil then
  begin
    if LTypeInfo^.Kind = tkClass then
    begin
//      if (Owner = nil) or ((Owner <> nil) and (Owner.Owner = nil)) then
//      begin
        LClassType := GetTypeData(LTypeInfo).ClassType;
        Self.FContainerClassType := TArObjClass(LClassType);
//      end;
    end;
  end;
end;

constructor TArDaList<T>.Create(const AOwner: TArObj; const AClassType: TArObjCLass; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  Self.FEventsManager := TArEventsManager<T>.Create(Self);
  Self.Create(AOwner, AColumn, ASettings, ACondetions);
  Self.FContainerClassType := AClassType;
end;

constructor TArDaList<T>.Create;
begin
  Self.FValue := TList<T>.Create;
  Self.FEventsManager := TArEventsManager<T>.Create(Self);
end;

function TArDaList<T>.DaToString: string;
begin
  raise Exception.Create('Can convert list to string');
end;

procedure TArDaList<T>.DoAfterChange;
begin
  Self.FEventsManager.DoAfterChangeEvents;
end;

procedure TArDaList<T>.DoBeforeChange;
begin
  Self.FEventsManager.DoBeforeChangeEvents;
end;

class function TArDaList<T>.GetActualClass: TArClass;
begin
   Result := acDaList;
end;

function TArDaList<T>.GetCount: Integer;
begin
  Result := Self.FValue.Count;
end;

function TArDaList<T>.Item(const AIndex: Integer): T;
begin
  Result := Self.FValue.Items[AIndex];
end;

function TArDaList<T>.LoadFilter: TArFnResult;
var
  LClassType: TClass;
  Info     : PTypeInfo;
  LObjValue: TObject;
  LRefValue: T ABSOLUTE LObjValue;
  LQuery: TADOQuery;
  I: Integer;
  LLoader: TArEnumorator;
begin
  if Self.FFilter = nil then raise Exception.Create('Filter most be created.');
  if Self.FFilter.Filter.Field = nil then raise Exception.Create('Filter is empty.');
  Info := System.TypeInfo(T);
  if Info <> nil then
  begin
    if Info^.Kind = tkClass then
    begin
//      TArContainerBase(Self.Owner).Query := TADOQuery.Create(nil);
//      LQuery := TArContainerBase(Self.Owner).Query;
      LQuery := TADOQuery.Create(nil);
      LLoader := TArObjLoader.Create(Self.Owner, lpLoad);
//      LClassType := GetTypeData(Info).ClassType;
      LClassType := Self.ContainerClassType;
      LObjValue := TArObjClass(LClassType).Create(Self.Owner);
      TArContainerBase(LObjValue).EnumFields(LLoader);
      LQuery.Connection := TArContainerBase(Self.Owner).Connection;
      try
        LQuery.SQL.Text := TArObjLoader(LLoader).IDLocation(Self.Filter);
        LQuery.Open;
        Self.FValue.Count := LQuery.RecordCount;
        if LQuery.RecordCount > 0 then
        begin
          for I := 0 to LQuery.RecordCount - 1 do
          begin
            LQuery.RecNo := I + 1;
            LObjValue := TArObjClass(LClassType).Create(Self);
            TArContainerBase(LObjValue).Connection := LQuery.Connection;
            TArContainerBase(LObjValue).Load(LQuery.FieldByName('ID').AsInteger);
            Self.FValue[I] := LRefValue;
          end;
        end;
      finally
        FreeAndNil(LQuery);
        FreeAndNil(LLoader);
        FreeAndNil(LObjValue);
      end;
    end;
  end;
end;

procedure TArDaList<T>.Search(const AValue: string);
var
  LClassType: TArObjClass;
  Info     : PTypeInfo;
  LObjValue: TObject;
  LRefValue: T ABSOLUTE LObjValue;
  LQuery: TADOQuery;
  I: Integer;
  LLoader: TArEnumorator;
begin
//  if Self.FFilter = nil then raise Exception.Create('Filter most be created.');
//  if Self.FFilter.Filter.Field = nil then raise Exception.Create('Filter is empty.');
  Self.FValue.Count := 0;
  Info := System.TypeInfo(T);
  if Info <> nil then
  begin
    if Info^.Kind = tkClass then
    begin
      LLoader := TArObjLoader.Create(Self, lpSearch);
      LClassType := Self.FContainerClassType;
      LObjValue := LClassType.Create(Self);
      TArContainerBase(LObjValue).EnumFields(LLoader);
      if TArObjLoader(LLoader).TablesCount <> 0 then
      begin
        LQuery := TADOQuery.Create(nil);
        LQuery.Connection := TArContainerBase(Self.Owner).Connection;
        try
          Self.Filter := TArObjLoader(LLoader).GenerateFilter(AValue);
          LQuery.SQL.Text := TArObjLoader(LLoader).IDLocation(Self.Filter);
          LQuery.Open;
          if LQuery.RecordCount > 0 then
          begin
            Self.FValue.Count := LQuery.RecordCount;
            for I := 0 to LQuery.RecordCount - 1 do
            begin
              LQuery.RecNo := I + 1;
              LObjValue := TArObjClass(LClassType).Create(Self);
              TArContainerBase(LObjValue).Connection := LQuery.Connection;
              TArContainerBase(LObjValue).Load(LQuery.FieldByName('ID').AsInteger); //#4
              Self.FValue[I] := LRefValue;
            end;
          end;
        finally
          FreeAndNil(LQuery);
          FreeAndNil(LLoader);
//          FreeAndNil(LObjValue);
        end;
      end
      else
      begin
        FreeAndNil(LLoader);
        FreeAndNil(LObjValue);
        raise Exception.Create('Can not locate any [CAPTION] field.');
      end;
    end;
  end;
end;

procedure TArDaList<T>.SetEventManagerPutFlags(const APutFlags: TArPutFlags);
begin
  Self.EventsManager.PutInfo.SetPutFlags(APutFlags);
end;

procedure TArDaList<T>.SetIsNull(const AValue: Boolean; const APutFlags: TArPutFlags);
begin
  inherited;
  Self.FValue.Clear;
end;

procedure TArDaList<T>.SetWasWillNull(const AWas, AWill: Boolean);
begin
  Self.EventsManager.PutInfo.SetWasNull(AWas);
  Self.EventsManager.PutInfo.SetWillBeNull(AWill);
end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ TDaInsList ]'}{#########################}
constructor TArDaInsList.Create(const AClassType: TArObjClass; const AOwner: TArObj; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  inherited Create(AOwner, AColumn, ASettings, ACondetions);
  Self.FClassType := AClassType;
end;
{######################}{$ENDREGION}{#######################################}
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TEnumorators ]'}{***********************}
{######################}{$REGION '[ Base ]'}{###############################}
constructor TArEnumorator.Create(const AOwner:TArObj);
begin
  inherited;
end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Creator ]'}{############################}
procedure TArObjCreator.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DaField}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LSender: TArContainerBase;
begin
  LActualClass := AClassType.GetActualClass;
  LSender := TArContainerBase(Self.Owner);
  if LActualClass = acUnknown then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      '[' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most be a Field Object');
  if (LActualClass = acDbField) or (LActualClass = acDbStrField) then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'DbField [' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most contain a DbOwner');
  AObj := AClassType.Create(LSender, AColumn, ASettings, ACondetions);
end;

procedure TArObjCreator.EnumField(var AObj: TArObj; const AClassType: TArObjClass;
  const AColumn: TArColumn; const ADbOwner: TArTable;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbField}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LSender: TArContainerBase;
begin
  LActualClass := AClassType.GetActualClass;
  LSender := TArContainerBase(Self.Owner);
  if LActualClass = acUnknown then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
    '[' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most be a Field Object');
  if (LActualClass = acDaField) or (LActualClass = acDaStrField) then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'DaField [' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most not contain a DbOwner');
  if LActualClass = acDbStrField then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'DaStrField [' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most have [Length]');
  AObj := AClassType.Create(LSender, AColumn, ADbOwner, ASettings, ACondetions);
end;

procedure TArObjCreator.EnumField(var AObj: TArObj; const AClassType: TArObjClass;
  const AColumn: TArColumn; const ALength: Integer;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DaStrField}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LSender: TArContainerBase;
begin
  LActualClass := AClassType.GetActualClass;
  LSender := TArContainerBase(Self.Owner);
  if LActualClass = acUnknown then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      '[' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most be a Field Object');
  if (LActualClass = acDbField) or (LActualClass = acDbStrField) then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'DbField [' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most contain a DbOwner');
  AObj := AClassType.Create(LSender, AColumn, ALength, ASettings, ACondetions);
end;

procedure TArObjCreator.EnumField(var AObj: TArObj; const AClassType: TArObjClass;
  const AColumn: TArColumn; const ALength: Integer;
  const ADbOwner: TArTable; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbStrField}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LSender: TArContainerBase;
begin
  LActualClass := AClassType.GetActualClass;
  LSender := TArContainerBase(Self.Owner);
  if LActualClass = acUnknown then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      '[' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most be a Field Object');
  if (LActualClass = acDaField) or (LActualClass = acDaStrField) then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'DaField [' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most not contain a DbOwner');
  AObj := AClassType.Create(LSender, AColumn, ALength, ADbOwner, ASettings, ACondetions);
end;

procedure TArObjCreator.EnumField(var AObj: TArObj;
  const AClassType: TArObjClass; const AColumn, ALinkCol: TArColumn;
  const ALinkedContainer: TArContainerBase; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DaList}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LSender: TArContainerBase;
begin
  LActualClass := AClassType.GetActualClass;
  LSender := TArContainerBase(Self.Owner);
  if LActualClass = acUnknown then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      '[' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most be a Field Object');
  if (LActualClass = acDbField) or (LActualClass = acDbStrField) then
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'DbField [' + LSender.TableInfo_cls.Name + '.' + AColumn.Name + '] most contain a DbOwner');
  AObj := AClassType.Create(LSender, AColumn, ASettings, ACondetions);
end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Newer ]'}{##############################}
procedure TArObjNewer.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DaField}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LField: TArBasicField;
begin
  LActualClass := AClassType.GetActualClass;
  LField := TArBasicField(AObj);
  if LActualClass = acUnknown then Exit
  else if csIdentity in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbField');
  end
  else if csAutoNumber in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbField');
  end
  else if csAutoCode in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbStrField');
  end
  else TArBasicField(AObj).SetIsNull(True, [pfNew]);
end;

procedure TArObjNewer.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ADbOwner: TArTable; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbField}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LField: TArBasicField;
  LOwnerName, LFieldName: string;
  LQuery: TADOQuery;
begin
  LActualClass := AClassType.GetActualClass;
  LField := TArBasicField(AObj);
  if LActualClass = acUnknown then Exit
  else if csIdentity in LField.ColSettings then
  begin

  end
  else if csAutoNumber in LField.ColSettings then
  begin
    // GetNewNumber;
    LQuery := TADOQuery.Create(nil);
    try
      LQuery.Connection := TArContainerBase(LField.Owner).Connection;
      LOwnerName := LField.DbOwner.Name;
      LFieldName := LField.ColInfo.Name;
      with LQuery.SQL do
      begin
        Add('SELECT MAX([' + LFieldName + ']) AS [' + LFieldName + ']');
        Add('FROM');
        Add('[' + LOwnerName + '];');
      end;
      LQuery.Open;
      if LQuery.IsEmpty then TArDbField<Integer>(LField).SetValue(0, [pfNew])
      else TArDbField<Integer>(LField).SetValue(LQuery.FieldByName(LFieldName).AsInteger + 1, [pfNew]);
    finally
      LQuery.Free;
    end;
  end
  else if csAutoCode in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbStrField');
  end
  else TArBasicField(AObj).SetIsNull(True, [pfNew]);
end;

procedure TArObjNewer.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DaStrField}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LField: TArBasicField;
begin
  LActualClass := AClassType.GetActualClass;
  LField := TArBasicField(AObj);
  if LActualClass = acUnknown then Exit
  else if csIdentity in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbField');
  end
  else if csAutoNumber in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbField');
  end
  else if csAutoCode in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbStrField');
  end
  else TArBasicField(AObj).SetIsNull(True, [pfNew]);
end;

procedure TArObjNewer.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbStrField}{!!!!!!!!!!!!!}
  LActualClass: TArClass;
  LField: TArBasicField;
  LOwnerName, LFieldName: string;
  LQuery: TADOQuery;
begin
  LActualClass := AClassType.GetActualClass;
  LField := TArBasicField(AObj);
  if LActualClass = acUnknown then Exit
  else if csIdentity in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbField');
  end
  else if csAutoNumber in LField.ColSettings then
  begin
    raise Exception.Create(#13 + '::' + Self.ClassName + '::' + #13 +
      'Field [' + LField.GetFullPath + '] most be DbField');
  end
  else if csAutoCode in LField.ColSettings then
  begin
    //NewCode;
    LQuery := TADOQuery.Create(nil);
    try
      LQuery.Connection := TArContainerBase(LField.Owner).Connection;
      LOwnerName := LField.DbOwner.Name;
      LFieldName := LField.ColInfo.Name;
      with LQuery.SQL do
      begin
        Add('SELECT MAX([' + LFieldName + ']) AS ' + LFieldName);
        Add('FROM');
        Add('[' + LOwnerName + '];');
      end;
      LQuery.Open;
      if LQuery.IsEmpty then TArDbField<Integer>(LField).SetValue(0, [pfNew])
      else TArDbField<string>(LField).SetValue(Self.IncCode(LQuery.FieldByName(LFieldName).AsString), [pfNew]);
    finally
      LQuery.Free;
    end;
  end
  else TArBasicField(AObj).SetIsNull(True, [pfNew]);
end;

function TArObjNewer.IncCode(const AValue: string): string;
var
  LLastChar: char;
  LResult: string;
  LCodeLength: Integer;
begin
  {0..9 -> 48..57}
  {A..Z -> 65..90}
  {a..z -> 97..122}
  LCodeLength := System.Length(AValue);
  if LCodeLength = 0 then
  begin
    Result := '0001';
    exit;
  end
  else
  begin
    LLastChar := AValue[LCodeLength];
    if (Ord(LLastChar) >= 48) and (Ord(LLastChar) < 57) then
    begin
      Result := copy(AValue, 0, Length(AValue) - 1) + Char(Ord(LLastChar) + 1);
    end
    else
    if LCodeLength <> 1 then
    begin
      LResult := copy(AValue, 0, LCodeLength - 1);
      Result := IncCode(LResult) + '0';
    end
    else Result := '0001';
  end;
end;

procedure TArObjNewer.EnumField(var AObj: TArObj; const AClassType: TArObjClass;
  const AColumn, ALinkCol: TArColumn; const ALinkedContainer: TArContainerBase;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  TArDaList<TArContainerBase>(AObj).Items.Clear;
end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Inserter ]'}{###########################}
procedure TArObjInserter.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaField}{!!!!!!!!!!!!!}
begin
  Exit;
end;

procedure TArObjInserter.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ADbOwner: TArTable; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbField}{!!!!!!!!!!!!!}
  LField: TArDbStrField;
  LOwnerName, LFieldName: string;
  I, LTableIndex, LTablesLength: Integer;
begin
  LField := TArDbStrField(AObj);
  LFieldName := LField.ColInfo.Name;
  LOwnerName := LField.DbOwner.Name;
  if csIdentity in LField.ColSettings then exit;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerName = Self.FTables[I].TableName then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableName := LOwnerName;
    LTableIndex := LTablesLength - 1;
  end;
  if LField.IsNotNull then
  begin
    if Self.FTables[LTableIndex].FieldsNames <> '' then
    begin
      Self.FTables[LTableIndex].FieldsNames :=
        Self.FTables[LTableIndex].FieldsNames + ', ';
      Self.FTables[LTableIndex].FieldsValues :=
        Self.FTables[LTableIndex].FieldsValues + ', ';
    end;
    Self.FTables[LTableIndex].FieldsNames :=
      Self.FTables[LTableIndex].FieldsNames + LFieldName;
    Self.FTables[LTableIndex].FieldsValues :=
      Self.FTables[LTableIndex].FieldsValues + LField.DaToString; //error on search
  end;
end;

procedure TArObjInserter.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaStrField}{!!!!!!!!!!!!!}
begin
  Exit;
end;

procedure TArObjInserter.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbStrField}{!!!!!!!!!!!!!}
  LField: TArDbStrField;
  LOwnerName, LFieldName: string;
  I, LTableIndex, LTablesLength: Integer;
begin
  LField := TArDbStrField(AObj);
  LFieldName := LField.ColInfo.Name;
  LOwnerName := LField.DbOwner.Name;
  if csIdentity in LField.ColSettings then exit;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerName = Self.FTables[I].TableName then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableName := LOwnerName;
    LTableIndex := LTablesLength - 1;
  end;
  if LField.IsNotNull then
  begin
    if Self.FTables[LTableIndex].FieldsNames <> '' then
    begin
      Self.FTables[LTableIndex].FieldsNames :=
        Self.FTables[LTableIndex].FieldsNames + ', ';
      Self.FTables[LTableIndex].FieldsValues :=
        Self.FTables[LTableIndex].FieldsValues + ', ';
    end;
    Self.FTables[LTableIndex].FieldsNames :=
      Self.FTables[LTableIndex].FieldsNames + LFieldName;
    Self.FTables[LTableIndex].FieldsValues :=
      Self.FTables[LTableIndex].FieldsValues + LField.DaToString.QuotedString;
  end;
end;

procedure TArObjInserter.Insert;
var
  I: Integer;
begin
  Self.FQuery := TArContainerBase(Self.Owner).Query;
  I := 0;
  Self.FQuery.SQL.Add('INSERT INTO');
  Self.FQuery.SQL.Add(Self.FTables[I].TableName);
  Self.FQuery.SQL.Add('(' + Self.FTables[I].FieldsNames + ')');
  Self.FQuery.SQL.Add('VALUES');
  Self.FQuery.SQL.Add('(' + Self.FTables[I].FieldsValues + ');');
  Self.FQuery.SQL.Add('DECLARE @LastID INT = (SELECT MAX(ID) FROM ' + Self.FTables[I].TableName + ');');
  for I := 1 to System.Length(Self.FTables) - 1 do
  begin
    Self.FQuery.SQL.Add('INSERT INTO');
    Self.FQuery.SQL.Add(Self.FTables[I].TableName);
    Self.FQuery.SQL.Add('(ID, ' + Self.FTables[I].FieldsNames + ')');
    Self.FQuery.SQL.Add('VALUES');
    Self.FQuery.SQL.Add('(@LastID, ' + Self.FTables[I].FieldsValues + ');');
  end;
end;

procedure TArObjInserter.EnumField(var AObj: TArObj;
  const AClassType: TArObjClass; const AColumn, ALinkCol: TArColumn;
  const ALinkedContainer: TArContainerBase; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin

end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Loader ]'}{#############################}
procedure TArObjLoader.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaField}{!!!!!!!!!!!!!}
begin
  if AObj.GetActualClass = acDaList then
  begin
    Exit;
  end else Exit;
end;

procedure TArObjLoader.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ADbOwner: TArTable; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbField}{!!!!!!!!!!!!!}
  I: Integer;
  LTableIndex, LTablesLength: Integer;
  LFieldName: string;
  LField: TArDbStrField;
  LOwnerTable: TArTable;
begin
  LField := TArDbStrField(AObj);

  LOwnerTable := LField.DbOwner;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerTable.ID = Self.FTables[I].TableInfo.ID then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableInfo := LOwnerTable;
    LTableIndex := LTablesLength - 1;
  end;

  case Self.FLoadPreposetion of
    lpLoad: if [ccNeeded] * LField.ColCondetions = [] then Exit;
    lpSearch: if [csCaption] * LField.ColSettings = [] then Exit;
  end;
  LFieldName := LField.ColInfo.Name;


  for I := 0 to System.Length(Self.FTables[LTableIndex].Fields) - 1 do
    if LField.ColInfo.ID = Self.FTables[LTableIndex].Fields[I].ColInfo.ID then
      Exit;
  Self.FTables[LTableIndex].Fields :=
    Self.FTables[LTableIndex].Fields + [LField];
end;

procedure TArObjLoader.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaStrField}{!!!!!!!!!!!!!}
begin
  Exit;
end;

constructor TArObjLoader.Create(const AOwner: TArObj; APreposetion: TArLoadPreposition);
begin
  Inherited Create(AOwner);
  Self.FLoadPreposetion := APreposetion;
end;

procedure TArObjLoader.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbStrField}{!!!!!!!!!!!!!}
  I: Integer;
  LTableIndex, LTablesLength: Integer;
  LFieldName: string;
  LField: TArDbStrField;
  LOWnerTable: TArTable;
begin
  LField := TArDbStrField(AObj);

  LOwnerTable := LField.DbOwner;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerTable.ID = Self.FTables[I].TableInfo.ID then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableInfo := LOWnerTable;
    LTableIndex := LTablesLength - 1;
  end;


  case Self.FLoadPreposetion of
    lpLoad: if [ccNeeded] * LField.ColCondetions = [] then Exit;
    lpSearch: if [csCaption] * LField.ColSettings = [] then Exit;
  end;
  LFieldName := LField.ColInfo.Name;

  for I := 0 to System.Length(Self.FTables[LTableIndex].Fields) - 1 do
    if LField.ColInfo.ID = Self.FTables[LTableIndex].Fields[I].ColInfo.ID then
      Exit;
  Self.FTables[LTableIndex].Fields :=
    Self.FTables[LTableIndex].Fields + [LField];
end;

procedure TArObjLoader.EnumField(var AObj: TArObj;
  const AClassType: TArObjClass; const AColumn, ALinkCol: TArColumn;
  const ALinkedContainer: TArContainerBase; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin

end;

function TArObjLoader.GenerateFilter(const AValue: string): TArFilter;
var
  I: Integer;
  J: Integer;
begin
  Result := TArFilter.Create;
  for I := 0 to High(Self.FTables) do
  begin
    if I = 0 then
    begin
      if System.Length(Self.FTables[I].Fields) > 0 then
        Result := Result.Where(Self.FTables[I].Fields[0], fcLike, AValue)
    end
    else
    begin
      if System.Length(Self.FTables[I].Fields) > 0 then
        Result := Result.OrWhere(Self.FTables[I].Fields[0], fcLike, AValue);
    end;
    for J := 1 to High(Self.FTables[I].Fields) do
    begin
      Result := Result.OrWhere(Self.FTables[I].Fields[J], fcLike, AValue);
    end;
  end;
end;

function TArObjLoader.GetTablesCount: Integer;
begin
  Result := System.Length(Self.FTables);
end;

function TArObjLoader.IDLocation(const AFilter: TArFilter): string;
var
  I: Integer;
  LResult: TStringList;
begin
  LResult := TStringList.Create;
  try
    LResult.Add('SELECT [A].[ID]');
    LResult.Add('FROM [' + Self.FTables[0].TableInfo.Name + '][' + Char(65) + ']');
    for I := 1 to System.Length(Self.FTables) - 1 do
    begin
      LResult.Add('INNER JOIN [' + Self.FTables[I].TableInfo.Name + '][' + Char(I + 65) + ']');
      LResult.Add('ON [A].[ID] = [' + Char(I + 65) + '].[ID]');
    end;
    LResult.Add('WHERE');
    LResult.Add(Self.GenerateFilter(AFilter));
    Result := LResult.Text;
  finally
    LResult.Free;
  end;
end;

function TArObjLoader.GenerateFilter(const AFilter: TArFilter): string;
var
  I: Integer;
  LFieldName, LFilter: string;
  LTablesLength, LTableIndex: Integer;
  LOwnerTable: TArTable;
begin
  LOwnerTable := AFilter.Filter.Field.DbOwner;
  LFieldName := AFilter.Filter.Field.ColInfo.Name;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerTable.ID = Self.FTables[I].TableInfo.ID then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableInfo := LOWnerTable;
    LTableIndex := LTablesLength - 1;
  end;
  LFilter := LFilter + AFilter.OperatorAsString(AFilter.SubOperator);
  if AFilter.SubFiltersCount <> 0 then LFilter := LFilter + '(';
  LFilter := LFilter + '([' + Char(LTableIndex + 65) + '].[' + LFieldName + ']'
    + AFilter.ComparisonAsString(AFilter.Filter.Comparison);
  if not (AFilter.Filter.Comparison in [fcIsNull, fcIsNull]) then
    if AFilter.Filter.Field.GetActualTypeKind in [tkString, tkWChar, tkLString, tkWString,tkUString,
      tkAnsiChar, tkWideChar, tkUnicodeString, tkAnsiString, tkWideString, tkShortString] then
        LFilter := LFilter + QuotedStr('%' + AFilter.Filter.Value + '%')
    else LFilter := LFilter + AFilter.Filter.Value;
  LFilter := LFilter + ')';
  if AFilter.SubFiltersCount <> 0 then
  begin
    for I := 0 to AFilter.SubFiltersCount - 1 do
    begin
      LFilter := LFilter + Self.GenerateFilter(AFilter.SubFilter[I]);
    end;
  end;
  if AFilter.SubFiltersCount <> 0 then LFilter := LFilter + ')';
  Result := LFilter;
end;

procedure TArObjLoader.Load;
begin

end;

procedure TArObjLoader.Load(const AFilter: TArFilter);
var
  I, J: Integer;
  LFilter: string;
begin
  Self.FQuery := TArContainerBase(Self.Owner).Query;
  with Self.FQuery.SQL do
  begin
    Add('SELECT');
    for I := 0 to System.Length(Self.FTables) - 1 do
    begin
      for J := 0 to System.Length(Self.FTables[I].Fields) - 1 do
        Add('[' + Char(I + 65) + '].[' + Self.FTables[I].Fields[J].ColInfo.Name + ']' +
          '[' + Char(I + 65) + '_' + Self.FTables[I].Fields[J].ColInfo.Name + '], ');
    end;
    Self.FQuery.SQL.Text := Copy(Text, 0, System.Length(Text) - 4);
    Add('FROM [' + Self.FTables[0].TableInfo.Name + '][' + Char(65) + ']');
  end;
  for I := 1 to System.Length(Self.FTables) - 1 do
  begin
    with Self.FQuery.SQL do
    begin
      Add('INNER JOIN [' + Self.FTables[I].TableInfo.Name + '][' + Char(I + 65) + ']');
      Add('ON [A].[ID] = [' + Char(I + 65) + '].[ID]');
    end;
  end;
  LFilter := Self.GenerateFilter(AFilter);
  Self.FQuery.SQL.Add('WHERE');
  Self.FQuery.SQL.Add(LFilter);
end;

procedure TArObjLoader.Load(const AID: Integer);
var
  I, J: Integer;
begin
  Self.FQuery := TArContainerBase(Self.Owner).Query;
  with Self.FQuery.SQL do
  begin
    Add('SELECT');
    for I := 0 to System.Length(Self.FTables) - 1 do
    begin
      for J := 0 to System.Length(Self.FTables[I].Fields) - 1 do
        Add('[' + Char(I + 65) + '].[' + Self.FTables[I].Fields[J].ColInfo.Name + ']' +
          '[' + Char(I + 65) + '_' + Self.FTables[I].Fields[J].ColInfo.Name + '], ');
    end;
    Self.FQuery.SQL.Text := Copy(Text, 0, System.Length(Text) - 4);
    Add('FROM [' + Self.FTables[0].TableInfo.Name + '][' + Char(65) + ']');
  end;
  for I := 1 to System.Length(Self.FTables) - 1 do
  begin
    with Self.FQuery.SQL do
    begin
      Add('INNER JOIN [' + Self.FTables[I].TableInfo.Name + '][' + Char(I + 65) + ']');
      Add('ON [A].[ID] = [' + Char(I + 65) + '].[ID]');
    end;
  end;
  Self.FQuery.SQL.Add('WHERE [A].[ID] = ' + IntToStr(AID));
end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ LoaderApplayer ]'}{#####################}
procedure TArObjLoaderApplayer.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaField}{!!!!!!!!!!!!!}
//var
//  LField: TArBasicField;
begin
//  if AObj.GetActualClass = acDaList then
//  begin
//    LField := TArBasicField(AObj);
//    TArDaList<TArContainerBase>(LField).Search('Syria');            //#3
//  end else Exit;
end;

procedure TArObjLoaderApplayer.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ADbOwner: TArTable; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbField}{!!!!!!!!!!!!!}
  LTypeKind: TTypeKind;
  LFieldName, LTotalFieldName: string;
  LField: TArBasicField;
  LOwnerTable: TArTable;
  LContainer: TArObj;
begin
  LTypeKind := TArBasicField(AObj).GetActualTypeKind;
  LField := TArBasicField(AObj);
  LFieldName := LField.ColInfo.Name;
  LOwnerTable := LField.DbOwner;
  Self.FQuery := TArContainerBase(Self.Owner).Query;

  if Self.FCurrentTableID <> LOwnerTable.ID then
  begin
    Self.FCurrentTableID := LOWnerTable.ID;
    Self.FCurrentLooper := Self.FCurrentLooper + 1;
  end;

  LTotalFieldName := Char(Self.FCurrentLooper + 65) + '_' + LFieldName;
  if Self.FQuery.FieldByName(LTotalFieldName).IsNull then
    LField.SetIsNull(True, [pfInLoad])
  else
  begin
    case LTypeKind of
      tkUnknown: ;
      tkInteger:
        TArDbField<Integer>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsInteger, [pfInLoad]);
      tkChar: ;
      tkEnumeration: ;
      tkFloat:
        TArDbField<Double>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsFloat, [pfInLoad]);
      tkString:
        TArDbField<string>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      tkSet: ;
      tkClass:
      begin
        LContainer := AClassType.GetActualType.Create(LField);
        TArContainerBase(LContainer).Connection := Self.FQuery.Connection;
        TArContainerBase(LContainer).Load(Self.FQuery.FieldByName(LTotalFieldName).AsInteger);
        TArDbField<TArContainerBase>(LField).SetValue(TArContainerBase(LContainer), [pfInLoad]);
//        LContainer := TArContainerBase(AClassType).Create;
//        LContainer.Load(Self.FQuery.FieldByName(LTotalFieldName).AsInteger);
//        TArDbField<TArContainerBase>(LField).SetValue(LContainer, [pfInLoad]);
//        TArDbField<TArContainerBase>(LField)
//        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      end;
      tkMethod: ;
      tkWChar: ;
      tkLString:
        TArDbField<string>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      tkWString:
        TArDbField<string>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      tkVariant: ;
      tkArray: ;
      tkRecord: ;
      tkInterface: ;
      tkInt64:
        TArDbField<int64>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsLargeInt, [pfInLoad]);
      tkDynArray: ;
      tkUString:
        TArDbField<string>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      tkClassRef: ;
      tkPointer: ;
      tkProcedure: ;
    end;
  end;
end;

procedure TArObjLoaderApplayer.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaStrField}{!!!!!!!!!!!!!}
begin
  Exit;
end;

constructor TArObjLoaderApplayer.Create(const AOwner: TArObj);
begin
  inherited;
  Self.FCurrentTableID := -1;
  Self.FCurrentLooper := -1;
end;

procedure TArObjLoaderApplayer.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbStrField}{!!!!!!!!!!!!!}
  LTypeKind: TTypeKind;
  LFieldName, LTotalFieldName: string;
  LField: TArBasicField;
  LOwnerTable: TArTable;
begin
  LTypeKind := TArBasicField(AObj).GetActualTypeKind;
  LField := TArBasicField(AObj);
  LFieldName := LField.ColInfo.Name;
  LOwnerTable := LField.DbOwner;
  Self.FQuery := TArContainerBase(Self.Owner).Query;
  if Self.FCurrentTableID <> LOwnerTable.ID then
  begin
    Self.FCurrentTableID := LOWnerTable.ID;
    Self.FCurrentLooper := Self.FCurrentLooper + 1;
  end;
  LTotalFieldName := Char(Self.FCurrentLooper + 65) + '_' + LFieldName;
  if Self.FQuery.FieldByName(LTotalFieldName).IsNull then
    LField.SetIsNull(True, [pfInLoad])
  else
  begin
    case LTypeKind of
      tkUnknown: ;
      tkInteger:
        TArDbField<Integer>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsInteger, [pfInLoad]);
      tkChar: ;
      tkEnumeration: ;
      tkFloat:
        TArDbField<Double>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsFloat, [pfInLoad]);
      tkString:
        TArDbField<string>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      tkSet: ;
      tkClass: ;
      tkMethod: ;
      tkWChar: ;
      tkLString:
        TArDbField<string>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      tkWString:
        TArDbField<string>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      tkVariant: ;
      tkArray: ;
      tkRecord: ;
      tkInterface: ;
      tkInt64:
        TArDbField<int64>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsLargeInt, [pfInLoad]);
      tkDynArray: ;
      tkUString:
        TArDbField<string>(LField)
        .SetValue(Self.FQuery.FieldByName(LTotalFieldName).AsString, [pfInLoad]);
      tkClassRef: ;
      tkPointer: ;
      tkProcedure: ;
    end;
  end;
end;

procedure TArObjLoaderApplayer.EnumField(var AObj: TArObj;
  const AClassType: TArObjClass; const AColumn, ALinkCol: TArColumn;
  const ALinkedContainer: TArContainerBase; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
var
  LField, LLinkedField: TArBasicField;
  LContainer: TArObj;
  LList: TArDaList<TArContainerBase>;
  LClass: TArObjClass;
  I: Integer;
begin
  LList := TArDaList<TArContainerBase>(AObj);
  LClass := LList.ContainerClassType;
  LContainer := LClass.Create(Self);
  try
    for I := 0 to TArContainerBase(LContainer).Fields.Count - 1 do
    begin
      LField := TArContainerBase(LContainer).Fields.Items[I];
      if LField.ColInfo.ID = ALinkCol.ID then
      begin
        LLinkedField := LField;
        Break;
      end;
    end;
    if not Assigned(LLinkedField) then
      raise Exception.Create('Can not locate [' + ALinkCol.Name + '] into [' + TArContainerBase(LContainer).TableInfo.Name + ']')
    else
    begin
      LList.Filter := TArFilter.Create;
      LList.Filter.Where(LLinkedField, fcEqual, TIDContainer(ALinkedContainer).FldID.DaToString);
      LList.LoadFilter;
      LList.Filter.Free;
    end;
  finally
    LContainer.Free;
  end;
end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Updater ]'}{############################}
procedure TArObjUpdater.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaField}{!!!!!!!!!!!!!}
begin
  Exit;
end;

procedure TArObjUpdater.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ADbOwner: TArTable; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbField}{!!!!!!!!!!!!!}
  I: Integer;
  LTableIndex, LTablesLength: Integer;
  LFieldName: string;
  LField: TArDbStrField;
  LOwnerTable: TArTable;
begin
  LField := TArDbStrField(AObj);
  if not (ccChanged in LField.ColCondetions) or (csIdentity in LField.ColSettings) then Exit;
  LFieldName := LField.ColInfo.Name;
  LOwnerTable := LField.DbOwner;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerTable.ID = Self.FTables[I].TableInfo.ID then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableInfo := LOwnerTable;
    LTableIndex := LTablesLength - 1;
  end;
  Self.FTables[LTableIndex].FieldsNames :=
    Self.FTables[LTableIndex].FieldsNames + [LFieldName];
  if ccNull in LField.ColCondetions then
    Self.FTables[LTableIndex].FieldsValues :=
        Self.FTables[LTableIndex].FieldsValues + ['NULL']
  else
    Self.FTables[LTableIndex].FieldsValues :=
      Self.FTables[LTableIndex].FieldsValues + [LField.DaToString];
  LField.DbValue := LField.Value;
  LField.IsChanged := False;
end;

procedure TArObjUpdater.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaStrField}{!!!!!!!!!!!!!}
begin
  Exit;
end;

procedure TArObjUpdater.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DbStrField}{!!!!!!!!!!!!!}
var
  I: Integer;
  LTableIndex, LTablesLength: Integer;
  LFieldName: string;
  LField: TArDbStrField;
  LOwnerTable: TArTable;
begin
  LField := TArDbStrField(AObj);
  if not (ccChanged in LField.ColCondetions) or (csIdentity in LField.ColSettings) then Exit;
  LFieldName := LField.ColInfo.Name;
  LOwnerTable := LField.DbOwner;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerTable.ID = Self.FTables[I].TableInfo.ID then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableInfo := LOwnerTable;
    LTableIndex := LTablesLength - 1;
  end;
  Self.FTables[LTableIndex].FieldsNames :=
    Self.FTables[LTableIndex].FieldsNames + [LFieldName];
  if ccNull in LField.ColCondetions then
    Self.FTables[LTableIndex].FieldsValues :=
        Self.FTables[LTableIndex].FieldsValues + ['NULL']
  else
    Self.FTables[LTableIndex].FieldsValues :=
      Self.FTables[LTableIndex].FieldsValues + [LField.DaToString.QuotedString];
  LField.DbValue := LField.Value;
  LField.IsChanged := False;
end;

procedure TArObjUpdater.Update(const AID: Integer);
var
  I, J: Integer;
begin
  Self.FQuery := TArContainerBase(Self.Owner).Query;
  with Self.FQuery.SQL do
  begin
    for I := 0 to System.Length(Self.FTables) - 1 do
    begin
      Add('UPDATE');
      Add(Self.FTables[I].TableInfo.Name + ' SET ');
      for J := 0 to System.Length(Self.FTables[I].FieldsNames) - 1 do
        Add('[' + Self.FTables[I].FieldsNames[J] + ']' +
          ' = ' + Self.FTables[I].FieldsValues[J] + ', ');
      Self.FQuery.SQL.Text := Copy(Text, 0, System.Length(Text) - 4);
      Self.FQuery.SQL.Add('WHERE ' + Self.FTables[I].TableInfo.Name + '.[ID] = ' + IntToStr(AID) + ';');
    end;
  end;
end;

procedure TArObjUpdater.EnumField(var AObj: TArObj;
  const AClassType: TArObjClass; const AColumn, ALinkCol: TArColumn;
  const ALinkedContainer: TArContainerBase; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin

end;
{######################}{$ENDREGION}{#######################################}
{######################}{$REGION '[ Searcher ]'}{############################}
procedure TArObjSearcher.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaField}{!!!!!!!!!!!!!}
begin
  Exit;
end;

procedure TArObjSearcher.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ADbOwner: TArTable; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbField}{!!!!!!!!!!!!!}
  I: Integer;
  LTableIndex, LTablesLength: Integer;
  LFieldName: string;
  LField: TArDbStrField;
  LOwnerTable: TArTable;
begin
  LField := TArDbStrField(AObj);
  if [csCaption] * LField.ColSettings = [] then Exit;
  LFieldName := LField.ColInfo.Name;
  LOwnerTable := LField.DbOwner;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerTable.ID = Self.FTables[I].TableInfo.ID then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableInfo := LOwnerTable;
    LTableIndex := LTablesLength - 1;
  end;
  Self.FTables[LTableIndex].FieldsNames :=
    Self.FTables[LTableIndex].FieldsNames + [LFieldName];
end;

procedure TArObjSearcher.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ASettings: TArColSettings; const ACondetions: TArColCondetions);
  {!!!!!!!!!!!!}{Info: DaStrField}{!!!!!!!!!!!!!}
begin
  Exit;
end;

procedure TArObjSearcher.EnumField(var AObj: TArObj; const AClassType: TArObjClass; const AColumn: TArColumn;
  const ALength: Integer; const ADbOwner: TArTable; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
var
  {!!!!!!!!!!!!}{Info: DbStrField}{!!!!!!!!!!!!!}
  I: Integer;
  LTableIndex, LTablesLength: Integer;
  LFieldName: string;
  LField: TArDbStrField;
  LOWnerTable: TArTable;
begin
  LField := TArDbStrField(AObj);
  if [csCaption] * LField.ColSettings = [] then Exit;
  LFieldName := LField.ColInfo.Name;
  LOwnerTable := LField.DbOwner;
  LTablesLength := System.Length(Self.FTables);
  LTableIndex := - 1;
  for I := 0 to LTablesLength - 1 do
  begin
    if LOwnerTable.ID = Self.FTables[I].TableInfo.ID then
    begin
      LTableIndex := I;
      Break;
    end;
  end;
  if LTableIndex = - 1 then
  begin
    LTablesLength := LTablesLength + 1;
    System.SetLength(Self.FTables, LTablesLength);
    Self.FTables[LTablesLength - 1].TableInfo := LOWnerTable;
    LTableIndex := LTablesLength - 1;
  end;
  Self.FTables[LTableIndex].FieldsNames :=
    Self.FTables[LTableIndex].FieldsNames + [LFieldName];
end;

function TArObjSearcher.Search(const AFilter:TArFilter): TArFnResult;
//var
//  I, J: Integer;
begin
{
  if not Assigned(AFilter) then
  begin
    Result.ErrorResult('Filter most be assigned.');
    Exit;
  end;

  Self.FQuery := TArContainerBase(Self.Owner).Query;
  with Self.FQuery.SQL do
  begin
    Add('SELECT');
    for I := 0 to System.Length(Self.FTables) - 1 do
    begin
      for J := 0 to System.Length(Self.FTables[I].FieldsNames) - 1 do
        Add('[' + Char(I + 65) + '].[' + Self.FTables[I].FieldsNames[J] + ']' +
          '[' + Char(I + 65) + '_' + Self.FTables[I].FieldsNames[J] + '], ');
    end;
    Self.FQuery.SQL.Text := Copy(Text, 0, System.Length(Text) - 4);
    Add('FROM [' + Self.FTables[0].TableInfo.Name + '][' + Char(65) + ']');
  end;

  for I := 1 to System.Length(Self.FTables) - 1 do
  begin
    with Self.FQuery.SQL do
    begin
      Add('INNER JOIN [' + Self.FTables[I].TableInfo.Name + '][' + Char(I + 65) + ']');
      Add('ON [A].[ID] = [' + Char(I + 65) + '].[ID]');
    end;
  end;
  Self.FQuery.SQL.Add('WHERE ' + AFilter.Value);
}
end;

procedure TArObjSearcher.EnumField(var AObj: TArObj;
  const AClassType: TArObjClass; const AColumn, ALinkCol: TArColumn;
  const ALinkedContainer: TArContainerBase; const ASettings: TArColSettings;
  const ACondetions: TArColCondetions);
begin

end;
{######################}{$ENDREGION}{#######################################}
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TContainers ]'}{************************}

{ TArContainerBase }

constructor TArContainerBase.Create;
begin
  Self.DoBeforeCreate;
  Self.FTableInfo := Self.TableInfo_cls;
  Self.FFields := TArDaList<TArBasicField>.Create;
  Self.FCreator := TArObjCreator.Create(Self);
  try
    Self.EnumFields(Self.FCreator);
  finally
    FreeAndNil(Self.FCreator);
  end;
  Self.DoAfterCreate;
end;

procedure TArContainerBase.BeforeInsert;
begin

end;

constructor TArContainerBase.Create(const AOwner: TArObj);
begin
  inherited;
  Self.DoBeforeCreate;
  Self.FTableInfo := Self.TableInfo_cls;
  Self.FCreator := TArObjCreator.Create(Self);
  Self.FFields := TArDaList<TArBasicField>.Create(Self, CCol_ID);
  try
    Self.EnumFields(Self.FCreator);
  finally
    FreeAndNil(Self.FCreator);
  end;
  Self.DoAfterCreate;
end;

procedure TArContainerBase.DoAfterCreate;
begin

end;

procedure TArContainerBase.DoBeforeCreate;
begin

end;

function TArContainerBase.Insert: TArFnResult;
begin
  Self.BeforeInsert;
  Self.FInserter := TArObjInserter.Create(Self);
  Self.Query := TADOQuery.Create(nil);
  try
    Self.Query.Connection := Self.Connection;
    Self.EnumFields(Self.FInserter);
    TArObjInserter(Self.FInserter).Insert;
    Self.Query.ExecSQL;
  finally
    Self.Query.Free;
    FreeAndNil(Self.FInserter);
  end;
end;

function TArContainerBase.Load(const AID: Integer): TArFnResult;
begin
  if Self.Owner <> nil then
  begin
    if Self.Owner.Owner <> nil then
      if Self.Owner.Owner.Owner <> nil then
        if Self.Owner.Owner.Owner.Owner <> nil then
        begin
          if (TIDContainer(Self.Owner.Owner.Owner.Owner).FldID.Value = AID) and
            (TArContainerBase(Self.Owner.Owner.Owner.Owner).TableInfo.ID = Self.TableInfo.ID) then
          begin
            Self := TArContainerBase(Self.Owner.Owner.Owner.Owner);
            Exit;
          end;
        end;
  end;
  Self.FLoader := TArObjLoader.Create(Self, lpLoad);            //#1
  Self.FLOaderApplayer := TArObjLoaderApplayer.Create(Self);
  Self.Query := TADOQuery.Create(nil);
  try
    Self.Query.Connection := Self.Connection;
    Self.EnumFields(Self.FLoader);
    TArObjLoader(Self.FLoader).Load(AID);
    Self.Query.Open;
    if Self.Query.RecordCount > 0 then
    begin
      if Self.Query.RecordCount = 1 then
      begin
        Self.EnumFields(Self.FLOaderApplayer);                 //#2
{        for I := 0 to Self.Fields.Count - 1 do
        begin
          LField := Self.Fields.Items[I];
          if LField.GetActualClass = acDaList then
          begin
            if TArObj(LField.GetActualType).ClassParent = TArContainerBase then
            begin
//              LContainersList := TArDaList<TArContainerBase>(Self.Fields.Items[I]);
//              LContainersList.Filter := LContainersList.Filter.Where(, Equal, AID)
            end;
          end;
        end;}
        Result.DoneResult('Loaded.');
      end
      else
      begin
        Result.ErrorResult('More than one record are loaded.');
      end;
    end
    else
    begin
      Result.ErrorResult('No record is loaded.');
    end;
  finally
    Self.Query.Free;
    FreeAndNil(Self.FLOaderApplayer);
    FreeAndNil(Self.FLoader);
  end;
end;

function TArContainerBase.LoadFilter: TArFnResult;
begin
  if Self.FFilter = nil then raise Exception.Create('Filter most be created.');
  if Self.FFilter.Filter.Field = nil then raise Exception.Create('Filter is empty.');
  Self.FLoader := TArObjLoader.Create(Self, lpLoad);
  Self.FLOaderApplayer := TArObjLoaderApplayer.Create(Self);
  Self.Query := TADOQuery.Create(nil);
  try
    Self.Query.Connection := Self.Connection;
    Self.EnumFields(Self.FLoader);
    TArObjLoader(Self.FLoader).Load(Self.FFilter);
    Self.Query.Open;
    if Self.Query.RecordCount > 0 then
    begin
      if Self.Query.RecordCount = 1 then
      begin
        Self.EnumFields(Self.FLOaderApplayer);
        Result.DoneResult('Loaded.');
      end
      else
      begin
        Result.ErrorResult('More than one record are loaded.');
      end;
    end
    else
    begin
      Result.ErrorResult('No record is loaded.');
    end;
  finally
    Self.Query.Free;
    FreeAndNil(Self.FLOaderApplayer);
    FreeAndNil(Self.FLoader);
  end;
end;

function TArContainerBase.New: TArFnResult;
begin
  Self.FNewer := TArObjNewer.Create(Self);
  try
    Self.EnumFields(Self.FNewer);
  finally
    FreeAndNil(Self.FNewer);
  end;
end;

function TArContainerBase.Search: TArFnResult;
begin
{
  if Self.FFilter = nil then raise Exception.Create('Filter most be created.');
  if Self.FFilter.Value = '' then raise Exception.Create('Filter is empty.');
  Self.FSearcher := TArObjSearcher.Create(Self);
  Self.FLoader := TArObjLoader.Create(Self);
  Self.FLOaderApplayer := TArObjLoaderApplayer.Create(Self);
  Self.Query := TADOQuery.Create(nil);
  try
    Self.Query.Connection := Self.Connection;
    Self.EnumFields(Self.FSearcher);
    TArObjSearcher(Self.FSearcher).Search(Self.FFilter);
    Self.Query.Open;
    if Self.Query.RecordCount > 0 then
    begin
      if Self.Query.RecordCount = 1 then
      begin
        Self.EnumFields(Self.FLOaderApplayer);
        Result.DoneResult('Loaded.');
      end
      else
      begin
        Result.ErrorResult('More than one record are loaded.');
      end;
    end
    else
    begin
      Result.ErrorResult('No record is loaded.');
    end;
  finally
    Self.Query.Free;
    FreeAndNil(Self.FSearcher);
    FreeAndNil(Self.FLOaderApplayer);
    FreeAndNil(Self.FLoader);
  end;
}
end;


function TArContainerBase.Update(const AID: Integer): TArFnResult;
begin
  Self.FUpdator := TArObjUpdater.Create(Self);
  Self.Query := TADOQuery.Create(nil);
  Self.Query.Connection := Self.Connection;
  try
    Self.EnumFields(Self.FUpdator);
    TArObjUpdater(Self.FUpdator).Update(AID);
    try
      if Self.Query.ExecSQL = 1 then Result.Done := True
      else
      begin
        Result.Done := False;
        Result.Message := 'Failed to update.';
      end;
    finally
      Self.Query.Free;
    end;
  finally
    FreeAndNil(FUpdator);
  end;
end;

{ TIDContainer }

procedure TIDContainer.First;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.Connection;
  try
    with LQuery.SQL do
    begin
      Add('SELECT TOP 1 ID AS ID');
      Add('FROM ' + Self.TableInfo_cls.Name);
      Add('ORDER BY ID ASC');
    end;
    LQuery.Open;
    if not LQuery.Eof then
      inherited Load(LQuery.FieldByName('ID').AsInteger);
  finally
    LQuery.Free;
  end;
end;

procedure TIDContainer.Last;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.Connection;
  try
    with LQuery.SQL do
    begin
      Add('SELECT TOP 1 ID AS ID');
      Add('FROM ' + Self.TableInfo_cls.Name);
      Add('ORDER BY ID DESC');
    end;
    LQuery.Open;
    if not LQuery.Eof then
      inherited Load(LQuery.FieldByName('ID').AsInteger);
  finally
    LQuery.Free;
  end;
end;

procedure TIDContainer.Next;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.Connection;
  try
    with LQuery.SQL do
    begin
      Add('SELECT TOP 1 ID AS ID');
      Add('FROM ' + Self.TableInfo_cls.Name);
      Add('WHERE ID > ' + Self.FID.Value.ToString);
      Add('ORDER BY ID ASC');
    end;
    LQuery.Open;
    if not LQuery.Eof then inherited Load(LQuery.FieldByName('ID').AsInteger)
    else Self.Last;
  finally
    LQuery.Free;
  end;
end;

procedure TIDContainer.Back;
var
  LQuery: TADOQuery;
begin
  if Self.FID.Value = 0 then
  begin
    Self.Last;
    Exit;
  end;
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.Connection;
  try
    with LQuery.SQL do
    begin
      Add('SELECT TOP 1 ID AS ID');
      Add('FROM ' + Self.TableInfo_cls.Name);
      Add('WHERE ID < ' + Self.FID.Value.ToString);
      Add('ORDER BY ID DESC');
    end;
    LQuery.Open;
    if not LQuery.Eof then inherited Load(LQuery.FieldByName('ID').AsInteger)
    else Self.First;
  finally
    LQuery.Free;
  end;
end;

procedure TIDContainer.EnumFields(const AEnumorator: TArEnumorator);
begin
  inherited;
//  AEnumorator.EnumField(TArObj(Self.FID), TArDbField<Integer>, CCol_ID, Self.TableInfo_cls, [csIdentity, csPrimaryKey], []);
end;

function TIDContainer.Load: TArFnResult;
begin
  inherited Load(Self.FldID.Value);
end;

function TIDContainer.Update: TArFnResult;
begin
  inherited Update(Self.FldID.Value);
end;

{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ FnResult ]'}{***************************}
procedure TArFnResult.DoneResult(const AMessage: string);
begin
  Self.Done := True;
  Self.Message := AMessage;
end;

procedure TArFnResult.ErrorResult(const AMessage: string);
begin
  Self.Done := False;
  Self.Message := AMessage;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TFilter ]'}{****************************}
constructor TArFilter.Create;
begin
  inherited;

end;

function TArFilter.ComparisonAsString(const AComparison: TArFilterComparison): string;
begin
  case AComparison of
    fcGreaterThan: Result := ' > ';
    fcGreaterOrEqual: Result := ' >= ';
    fcLessThan: Result := ' < ';
    fcLessOrEqual: Result := ' <= ';
    fcEqual: Result := ' = ';
    fcNotEual: Result := ' <> ';
    fcIsNull: Result := ' IS NULL';
    fcIsNotNull: Result := ' IS NOT NULL';
    fcLike: Result := ' LIKE ';
    fcNotLike: Result := ' NOT LIKE ';
  end;
end;

function TArFilter.OperatorAsString(const AOperator: TArFilterOperator): string;
begin
  case AOperator of
    foNone: Result := '';
    foAnd: Result := ' AND ';
    foOr: Result := ' OR ';
    foAndNot: Result := ' AND NOT ';
    foOrNot: Result := ' OR NOT ';
  end;
end;

function TArFilter.GetSubFilter(const I: Integer): TArFilter;
begin
  Result := Self.FSubFilters[I];
end;

function TArFilter.GetSubFiltersCount: Integer;
begin
  Result := System.Length(Self.FSubFilters)
end;

procedure TArFilter.InsertSubFilter(const AFilter: TArFilter);
begin
  Self.FSubFilters := Self.FSubFilters + [AFilter];
end;

function TArFilter.NewWhere(const AOperator: TArFilterOperator; const AField: TArBasicField;
  const AComparison: TArFilterComparison; const AValue: string): TArFilter;
var
  LFilter: TArFilter;
begin
  LFilter := TArFilter.Create;
  LFilter.SetSubFilterCount(0);
  LFilter.FSubOperator := AOperator;
  LFilter.FFilter.Field := AField;
  LFilter.FFilter.Comparison := AComparison;
  LFilter.FFilter.Value := AValue;
  Self.InsertSubFilter(LFilter);
  Self.FSubOperator := foNone;
  Result := Self;
end;

function TArFilter.NewWhere(const AOperator: TArFilterOperator; const AFilter: TArFilter): TArFilter;
var
  LFilter: TArFilter;
begin
  LFilter := AFilter;
  LFilter.SubOperator := AOperator;
  Self.InsertSubFilter(LFilter);
  Self.FSubOperator := foNone;
  Result := Self;
end;

procedure TArFilter.SetSubFilterCount(const AValue: Integer);
begin
  System.SetLength(Self.FSubFilters, AValue);
end;

function TArFilter.Where(const AField: TArBasicField; const AComparison: TArFilterComparison;
  const AValue: string): TArFilter;
begin
  Self.SetSubFilterCount(0);
  Self.FSubOperator := foNone;
  Self.FFilter.Field := AField;
  Self.FFilter.Comparison := AComparison;
  Self.FFilter.Value := AValue;
  Result := Self;
end;

function TArFilter.Where(const ACol: TArColumn; const AComparison: TArFilterComparison;
  const AValue: string): TArFilter;
begin
  Self.SetSubFilterCount(0);
  Self.FSubOperator := foNone;
//  Self.FFilter.Field := AField;
  Self.FFilter.Comparison := AComparison;
  Self.FFilter.Value := AValue;
  Result := Self;
end;

function TArFilter.AndWhere(const AField: TArBasicField; const AComparison: TArFilterComparison;
  const AValue: string): TArFilter;
begin
  Result := Self.NewWhere(foAnd, AField, AComparison, AValue);
end;

function TArFilter.AndNotWhere(const AField: TArBasicField; const AComparison: TArFilterComparison;
  const AValue: string): TArFilter;
begin
  Result := Self.NewWhere(foAndNot, AField, AComparison, AValue);
end;

function TArFilter.AndNotWhere(const AFilter: TArFilter): TArFilter;
begin
  Result := Self.NewWhere(foAndNot, AFilter);
end;

function TArFilter.AndWhere(const AFilter: TArFilter): TArFilter;
begin
  Result := Self.NewWhere(foAnd, AFilter);
end;

function TArFilter.OrWhere(const AField: TArBasicField; const AComparison: TArFilterComparison;
  const AValue: string): TArFilter;
begin
  Result := Self.NewWhere(foOr, AField, AComparison, AValue);
end;

function TArFilter.OrNotWhere(const AField: TArBasicField; const AComparison: TArFilterComparison;
  const AValue: string): TArFilter;
begin
  Result := Self.NewWhere(foOrNot, AField, AComparison, AValue);
end;

function TArFilter.OrNotWhere(const AFilter: TArFilter): TArFilter;
begin
  Result := Self.NewWhere(foOrNot, AFilter);
end;

function TArFilter.OrWhere(const AFilter: TArFilter): TArFilter;
begin
  Result := Self.NewWhere(foOr, AFilter);
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ Notes ]'}{******************************}
{
SELECT sobjects.name
FROM sysobjects sobjects
WHERE sobjects.xtype = 'U'
Here is a list of other object types you can search for as well:

AF: Aggregate function (CLR)
C: CHECK constraint
D: Default or DEFAULT constraint
F: FOREIGN KEY constraint
L: Log
FN: Scalar function
FS: Assembly (CLR) scalar-function
FT: Assembly (CLR) table-valued function
IF: In-lined table-function
IT: Internal table
P: Stored procedure
PC: Assembly (CLR) stored-procedure
PK: PRIMARY KEY constraint (type is K)
RF: Replication filter stored procedure
S: System table
SN: Synonym
SQ: Service queue
TA: Assembly (CLR) DML trigger
TF: Table function
TR: SQL DML Trigger
TT: Table type
U: User table
UQ: UNIQUE constraint (type is K)
V: View
X: Extended stored procedure

//CREATE SEQUENCE  sequence_name START WITH here_higher_number_than_max_existed_value_in_column INCREMENT BY 1;
//ALTER TABLE table_name ADD CONSTRAINT constraint_name DEFAULT NEXT VALUE FOR sequence_name FOR column_name

SELECT NEXT VALUE FOR [dbo].[SequenceCounter];

CREATE SEQUENCE [dbo].[RecycleSequence]
 AS INT
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 3
 CYCLE

 SELECT current_value FROM sys.sequences WHERE name = 'RecycleSequence';

IF EXISTS (SELECT name FROM sys.sequences WHERE name = N'RecycleSequence')
DROP SEQUENCE  [dbo].[RecycleSequence]
}
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ DatabaseCreator ]'}{********************}
constructor TArDatabaseCreator.Create(const AConnection: TADOConnection;
  const ARecreate:Boolean=False);
begin
  Self.FConnection := AConnection;
  Self.FRecreate := ARecreate;
end;

procedure TArDatabaseCreator.CreateDataBase(const ADatabaseName: string);
var
  I: Integer;
  LContainer: TArContainerBase;
  LClass: TArContainerClass;
  LLoader: TArEnumorator;
  LQuery: TADOQuery;
  LTable: TArTableValue;
  LField: TArBasicField;
  LSettings: TStringList;
  K: Integer;
  L: Integer;
  M: Integer;
begin
  Self.FDatabaseName := ADatabaseName;
  LLoader := TArObjLoader.Create(Self, lpCreateDB);
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.FConnection;
  if Self.FRecreate then
  begin
    Self.DropDataBaseWhileExists(ADatabaseName);
    Self.CreateDataBaseWhileNotExists(ADatabaseName);
  end
  else
  begin
    if not Self.DatabaseExists(ADatabaseName) then
      Self.CreateDataBaseWhileNotExists(ADataBaseName);
  end;
  if not Self.Reconnect(ADatabaseName) then
    raise Exception.Create('Can not connect to database');
  try
    for I := 0 to System.Length(Self.FTables) - 1 do
    begin
      LClass := Self.FTables[I];
      LContainer := LClass.Create;
      LSettings := TStringList.Create;
      try
        LContainer.EnumFields(LLoader);
        for K := 0 to TArObjLoader(LLoader).TablesCount - 1 do
        begin
          LTable := TArObjLoader(LLoader).Tables[K];
          if Self.TableExists(LTable.TableInfo.Name) then
          Continue
          else
          begin
            LQuery.SQL.Clear;
            LQuery.SQL.Add('CREATE TABLE ' + LTable.TableInfo.Name + '(');

            LField := LTable.Fields[0];
            LSettings.AddObject('', Self.GetFieldSettings(LField));
            LQuery.SQL.Add(LField.ColInfo.Name + ' ' + Self.GetFieldProperty(LField));
            for L := 1 to System.Length(LTable.Fields) - 1 do
            begin
              LField := LTable.Fields[L];
              LSettings.AddObject('', Self.GetFieldSettings(LField));
              LQuery.SQL.Add(',' + LField.ColInfo.Name + ' ' + Self.GetFieldProperty(LField));
            end;
            LQuery.SQL.Add(');');
            for L := 0 to LSettings.Count - 1 do
            begin
              for M := 0 to TStringList(LSettings.Objects[L]).Count - 1 do
              begin
                LQuery.SQL.Add(TStringList(LSettings.Objects[L]).Strings[M]);
              end;
            end;
            try
              LQuery.ExecSQL;
            except
              on E: Exception do
              raise Exception.Create(E.Message);
            end;
          end;
        end;
      finally
        LContainer.Free;
        for K := 0 to LSettings.Count - 1 do LSettings.Objects[K].Free;
        LSettings.Free;
      end;
    end;
  finally
    LQuery.Free;
    LLoader.Free;
  end;
end;

procedure TArDatabaseCreator.CreateDataBaseWhileNotExists(
  const ADataBaseName: string);
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.FConnection;
  LQuery.SQL.Add('USE master');
  LQuery.SQL.Add('IF NOT EXISTS(SELECT Name FROM sys.databases WHERE name LIKE ' +
    QuotedStr(ADatabaseName) + ')');
  LQuery.SQL.Add('CREATE DATABASE [' + ADataBaseName + ']');
  try
    try
      LQuery.ExecSQL;
    except
      on E: Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TArDatabaseCreator.DatabaseExists(
  const ADatabaseName: string): Boolean;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.FConnection;
  LQuery.SQL.Add('USE master');
  LQuery.SQL.Add('IF EXISTS(SELECT Name FROM sys.databases WHERE name LIKE ' +
    QuotedStr(ADatabaseName) + ')');
  LQuery.SQL.Add('SELECT 1 AS Result ELSE SELECT 0 AS Result');
  try
    try
      LQuery.Open;
      if LQuery.FieldByName('Result').AsInteger = 1 then Result := True
      else Result := False;
    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

procedure TArDatabaseCreator.DropDataBaseWhileExists(
  const ADataBaseName: string);
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.FConnection;
  LQuery.SQL.Add('USE master');
  LQuery.SQL.Add('IF EXISTS(SELECT Name FROM sys.databases WHERE name LIKE ' +
    QuotedStr(ADatabaseName) + ')');
  LQuery.SQL.Add('DROP DATABASE [' + ADataBaseName + ']');
  try
    try
      LQuery.ExecSQL;
    except
      on E: Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TArDatabaseCreator.GetFieldProperty(const AField: TArBasicField): string;
begin
//  AField.GetActualClass; Returns DBField
//  AField.GetActualTypeKind; Returns tkInteger,..
//  AField.GetActualType; Returns TArClass
  case AField.GetActualTypeKind of
    tkInteger:
    begin
      Result := 'INT';
    end;
    tkFloat:
    begin
      Result := 'FLOAT';
    end;
    tkString, tkWChar, tkLString, tkWString, tkUString, tkAnsiChar:
    begin
      Result := 'VARCHAR(' + TArDbStrField(AField).Length.ToString + ')';
    end;
    tkClass:
    begin
      Result := 'INT';
    end;
  end;
end;

function TArDatabaseCreator.GetFieldSettings(const AField: TArBasicField): TStringList;
var
  I: TArColSetting;
  LConstraintName, LReferencedTable: string;
  LContainer: TArObj;
  LClass: TArObjClass;
  LKind: TTypeKind;
begin
  Result := TStringList.Create;
  for I := Low(TArColSetting) to High(TArColSetting) do
  begin
    if I in AField.ColSettings then
    case i of
      csIdentity: ;
      csAutoNumber:
      begin
        LConstraintName := 'Seq_' + AField.DbOwner.Name + '(' + AField.ColInfo.Name + ')';
        Result.Add('CREATE SEQUENCE [dbo].[' + LConstraintName + ']');
        Result.Add('AS INT');
        Result.Add('START WITH 1');
        Result.Add('INCREMENT BY 1;');

        Result.Add('ALTER TABLE [' + AField.DbOwner.Name + ']');
        Result.Add('ADD CONSTRAINT [Cons_' + LConstraintName + ']');
        Result.Add('DEFAULT NEXT VALUE FOR [dbo].[' + LConstraintName + ']');
        Result.Add('FOR [' + AField.ColInfo.Name + '];');
      end;
      csUnique:
      begin
        LConstraintName := 'UNQ_' + AField.DbOwner.Name + '(' + AField.ColInfo.Name + ')';
        Result.Add('ALTER TABLE [' + AField.DbOwner.Name + ']');
        Result.Add('ADD CONSTRAINT [' + LConstraintName + ']');
        Result.Add('UNIQUE([' + AField.ColInfo.Name + ']);');
      end;
      csNotNull:
      begin
        Result.Add('ALTER TABLE [' + AField.DbOwner.Name + ']');
        Result.Add('ALTER COLUMN [' + AField.ColInfo.Name + '] ' +
          Self.GetFieldProperty(AField) + ' NOT NULL;');
      end;
      csPrimaryKey:
      begin
        LConstraintName := 'PK_' + AField.DbOwner.Name + '(' + AField.ColInfo.Name + ')';
        Result.Add('ALTER TABLE [' + AField.DbOwner.Name + ']');
        Result.Add('ADD CONSTRAINT [' + LConstraintName + ']');
        Result.Add('PRIMARY KEY ([' + AField.ColInfo.Name + ']);');
      end;
      csForeignKey:
      begin
        LConstraintName := 'FK_' + AField.DbOwner.Name + '(' + AField.ColInfo.Name + ')';
        LKind := AField.GetActualTypeKind;
        if LKind = tkInteger then
        begin
          LClass := TArObjClass(AField.Owner.ClassParent);
          LContainer := LClass.Create;
          try
            LReferencedTable := TArContainerBase(LContainer).TableInfo_cls.Name;
          finally
            LContainer.Free;
          end;
        end
        else if LKind = tkClass then
        begin
          LClass := AField.GetActualType;
          LContainer := LClass.Create;
          try
            LReferencedTable := TArContainerBase(LContainer).TableInfo_cls.Name;
          finally
            LContainer.Free;
          end;
        end;
        LConstraintName := LConstraintName + '_' + LReferencedTable + '(ID)';
        Result.Add('ALTER TABLE [' + AField.DbOwner.Name + ']');
        Result.Add('ADD CONSTRAINT [' + LConstraintName + ']');
        Result.Add('FOREIGN KEY ([' + AField.ColInfo.Name + '])');
        Result.Add('REFERENCES [' + LReferencedTable + ']([ID]);');
      end;
    end;
  end;
end;

function TArDatabaseCreator.Reconnect(const ADatabaseName: string): Boolean;
begin
  Self.FConnection.Connected := False;
  Self.FConnection.Properties.Item['Initial Catalog'].Value := ADatabaseName;
  try
    Self.FConnection.Connected;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TArDatabaseCreator.SetDatabaseName(const AValue: string);
begin
  FDatabaseName := AValue;
  Self.Reconnect(AValue)
end;

function TArDatabaseCreator.TableExists(const ATableName: string): Boolean;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  LQuery.Connection := Self.FConnection;
  try
    with LQuery.SQL do
    begin
      Add('SELECT sobjects.name');
      Add('FROM sysobjects sobjects');
      Add('WHERE sobjects.xtype = ' + QuotedStr('U'));
      Add('AND sobjects.name like ' + QuotedStr(ATableName));
    end;
    LQuery.Open;
    if LQuery.IsEmpty then Result := False
    else Result := True;
  finally
    LQuery.Free;
  end;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TEventsManager ]'}{*********************}
constructor TArEventsManager<T>.Create(const Owner: TArObj);
begin
  inherited Create(Owner);
  Self.FChangingEvents := TList<TArChangeEvent<T>>.Create;
  Self.FChangedEvents := TList<TArChangeEvent<T>>.Create;
end;

procedure TArEventsManager<T>.DoAfterChangeEvents;
var
  I: Integer;
  LPutFlags: TArPutFlags;
begin
  for I := 0 to Self.FChangedEvents.Count - 1 do
    Self.FChangedEvents.Items[I](Self.FPutInfo);
  LPutFlags := Self.PutInfo.PutFlags;
  if pfNew in LPutFlags then
  begin
    LPutFlags := LPutFlags - [pfNew];
    Self.FPutInfo.SetPutFlags(LPutFlags);
  end;
end;

procedure TArEventsManager<T>.DoBeforeChangeEvents;
var
  I: Integer;
begin
  for I := 0 to Self.FChangingEvents.Count - 1 do
    Self.FChangingEvents.Items[I](Self.FPutInfo);
end;

procedure TArEventsManager<T>.AddToDoAfterChange(const AEvent:TArChangeEvent<T>);
begin
  Self.FChangedEvents.Add(AEvent);
end;

procedure TArEventsManager<T>.AddToDoBeforeChange(const AEvent:TArChangeEvent<T>);
begin
  Self.FChangedEvents.Add(AEvent);
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{///////////////////////////////////////////////////////////////////////////}
{**********************}{$REGION '[ TArPutInfo ]'}{*************************}
procedure TArPutInfo<T>.SetNewValue(const AValue: T);
begin
  Self.FNewValue := AValue;
end;

procedure TArPutInfo<T>.SetOldValue(const AValue: T);
begin
  Self.FOldValue := AValue;
end;

procedure TArPutInfo<T>.SetPutFlags(const APutFlags: TArPutFlags);
begin
  Self.FPutFlags := APutFlags;
end;

procedure TArPutInfo<T>.SetWasNull(const AValue: Boolean);
begin
  Self.FWasNull := AValue;
end;

procedure TArPutInfo<T>.SetWillBeNull(const AValue: Boolean);
begin
  Self.FWillBeNull := AValue;
end;
{**********************}{$ENDREGION}{***************************************}
{///////////////////////////////////////////////////////////////////////////}
{ TArDaSelect<T> }

constructor TArDaSelect<T>.Create(const AClassType: TArObjClass;
  const AOwner: TArObj; const AColumn: TArColumn;
  const ASettings: TArColSettings; const ACondetions: TArColCondetions);
begin
  inherited Create(AOwner, AColumn, ASettings, ACondetions);
  Self.FClassType := AClassType;
end;

procedure TArDaSelect<T>.SetValue(const AValue: T;
  const APutFlags: TArPutFlags);
begin

end;

end.
