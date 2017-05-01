{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie können es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    veröffentlicht, weitergeben und/oder modifizieren, gemäß Version 2 der Lizenz.
 Description:
	Beinhaltet viele Allgemein nützlich Procedures und Klassen
==============================================================================}

unit Uanderes;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,math,StdCtrls;



type
  //TDimension = (dimMeter, dimAngleBod, dimAngleDeg, dimLambda);

  //TRPhy=record
    //v:real;
    //Dimension:TDimension;
  //end;

  TAngleKind=(akalpha,akgamma);
  TXYZKind=(xyzkX,xyzkY,xyzkZ);

  TBoolRect=record
    Left,Right,Bottom,Top:boolean;
  end;

  TEdges=(TopLeft,BottomRight,TopRight,BottomLeft);

  TR2Vec=record
    x,y:real;
  end;
  

  TR3Vec=record
    x,y,z:real;
  end;

  // Koor Types
  TKoorKind=(kkx, kkLS, kkz,
             kkImage,
             kkOGLx, kkOGLy, kkOGLz,
             kkOGLRealityx, kkOGLRealityy, kkOGLRealityz,
             kkPixelx, kkPixely, kkPixelz);  //kkImage ist für die Intensitätsverlauf, also den farbigen hintergrund

  TKoorSet= set of TKoorKind;
  
  TKoor1=record
    v:real;    //v=value
    Kind:TKoorKind;
  end;

  TKoor3=record
    x,y,z:TKoor1;
  end;

  TKoor1Range=record
    Min,
    Max:TKoor1;
  end;

  TR2RectSimple=record
    Bottom:real;
    Top:real;
    Left:real;
    Right:real;
  end;

  
  TChartValue=record
    pos:TKoor3;      //pos.x =^ x-value; pos.y =^ Image-value; pos.z =^ LS-value;                //LS= Light Status (diese Koordinate nimmt mal Amplite, als Intensity auf
    TitleEnabled:boolean;
    Title:string;
    Color:TColor;
    Tag, Tag2:Longint;
  end;

  { TR2Rect }

  TR2Rect = class    // unten links ist ursprung!
  private
    function ReadFWidth:real;
    procedure WriteFWidth(Width:real);
    function ReadFHeight:real;
    procedure WriteFHeight(Height:real);
  public
    Bottom:real;
    Top:real;
    Left:real;
    Right:real;

    function  ratio:real;  // breite / höhe

    procedure R2Rect(aLeft, aBottom, awidth, aheight: real);
    function R2Rect2Str: string;

    property Height:real read ReadFHeight write WriteFHeight;
    property Width:real read ReadFWidth write WriteFWidth;
    
    constructor create;
  end;
  
  
  { TRealRange }

  TRealRange=record
    Min,
    Max:real;
  end;
  

  {-----------------------------------------------------------------------------
   Class:   TDynArray
   Description:
  -----------------------------------------------------------------------------}
    Tsetofchar=set of char;
  {-----------------------------------------------------------------------------
   Class:   TDynArray
   Description:
  -----------------------------------------------------------------------------}
    TsetofInteger=set of byte;

  {-----------------------------------------------------------------------------
   Class:   TIntegerArray
   Description:
  -----------------------------------------------------------------------------}
    TIntegerArray=class
    private
      Farr:array of Integer;
      function readFarr(idx:integer):Integer;
      procedure writeFarr(idx:integer; value:Integer);
    public
      function count:integer;
      procedure delete(idx:integer);
      procedure add(value:Integer);
      procedure insert(idx:integer; value:Integer);
      function LastItem:integer;
      procedure DelDubbleValues(const SourceArray:TIntegerArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]); //das Scource Array wird nicht verändert

      property arr[idx:integer]: Integer read readFarr write writeFarr; default;
    end;

  {-----------------------------------------------------------------------------
   Class:   TRealArray
   Description:
  -----------------------------------------------------------------------------}

    { TRealArray }

    TRealArray=class
    private
      Farr:array of real;
      function readFarr(idx:integer):real;
      procedure writeFarr(idx:integer; value:real);
    public
      function count:integer;
      procedure delete(idx:integer);
      procedure clear;
      procedure add(value:real);
      procedure insert(idx:integer; value:real);
      function LastItem:real;
      procedure DelDubbleValues(const SourceArray:TRealArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]); //das Scource Array wird nicht verändert

      property arr[idx:integer]: real read readFarr write writeFarr; default;
    end;


  {-----------------------------------------------------------------------------
   Class:   TChartValueArray
   Description:
  -----------------------------------------------------------------------------}

    { TChartValueArray }

    TChartValueArray=class
    private
      Farr:array of TChartValue;
      FMaxXRange: TRealRange;
      FMaxYRange: TRealRange;
      FMaxZRange: TRealRange;
      BlankRanges:boolean;
      function readFarr(idx:integer):TChartValue;
      procedure writeFarr(idx:integer; value:TChartValue);
    public
      function count:integer;
      procedure delete(idx:integer);
      procedure add(value:TChartValue);    overload;
      procedure add(x, y, z:TKoor1; Color:Tcolor); overload;
      procedure add(pos:TKoor3; Color:Tcolor); overload;
      procedure add(x, y, z:TKoor1; Title:string; Color:Tcolor); overload;
      procedure add(pos:TKoor3; Title:string; Color:Tcolor); overload;
      procedure add(pos:TKoor3; Title:string; Color:Tcolor; Tag:longint); overload;
      procedure clear;
      procedure insert(idx:integer; value:TChartValue);
      function LastItem:TChartValue;


      function GetRightValue(idx:integer; WhatValue:TXYZKind):real;
      function GetRightKoor(idx:integer; WhatValue:TXYZKind):TKoor1;
      procedure SetRightValue(newvalue:real; idx:integer; WhatValue:TXYZKind);

      procedure sort(SortKind:TXYZKind);
      procedure DelDubbleValues(const SourceArray:TChartValueArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]); //das Scource Array wird nicht verändert

      property arr[idx:integer]: TChartValue read readFarr write writeFarr; default;
      property MaxXRange:TRealRange read FMaxXRange    ;
      property MaxYRange:TRealRange read FMaxYRange   ;
      property MaxZRange:TRealRange read FMaxZRange   ;

      constructor create;
      destructor destroy; override;
    end;


  {-----------------------------------------------------------------------------
   Class:   TClassArray
   Description:   Tropfenarray
  -----------------------------------------------------------------------------}

  { TClassArray }

  TClassArray=class
  private
    FastAdding:boolean;
    FastMaxIdx:integer;

    Farr:array of TObject;
    function readFarr(idx:integer):TObject;
    procedure writeFarr(idx:integer; value:TObject);
  public
    count:integer;
    function countFast:integer;
    procedure delete(idx:integer);
    procedure deleteAndFree(idx:integer);
    function add(value:TObject):integer;
//    procedure add(CBrushColor,CBorderColor:Tcolor; Cposition:TR3Vec;  Cradius:TR2Vec; CcountPoints:integer; Ctransparency:byte); overload;
    procedure insert(idx:integer; value:TObject);
    function LastItem:TObject;
    function FirstItem:TObject;
    procedure SwapIdx(idx1,idx2:integer);

    property arr[idx:integer]: TObject read readFarr write writeFarr; default;


    constructor create(CFastAdding:boolean; CFastMaxIdx:integer=50); virtual;
    destructor destroy;  override;
    destructor destroyAndFreeObjects;
  end;


  {-----------------------------------------------------------------------------
   Description: public Procedures and functions
  -----------------------------------------------------------------------------}

  function RandomBool:boolean;
  function boolsign(a:boolean):shortint;
  function boolUngleich(a,b:boolean):boolean;
  function boolGleich(a,b:boolean):boolean;
  function boolto01(a:boolean):byte;

  procedure korrigiere(var s:AnsiString; const zeichen:Tsetofchar=['0'..'9','-',',']; DelDoublePoint:boolean=true); overload;
  procedure korrigiere(var edit:Tedit; const zeichen:Tsetofchar=['0'..'9','-',',']); overload;
  procedure korrigiere(var r:real;  min,max:real);         overload;
  procedure korrigiere(var e:extended;  min,max:extended);         overload;
  procedure korrigiere(var w:integer;  min,max:integer);         overload;

  function Asign(wert:real):shortint; overload;
  function Asign(wert:integer):shortint; overload;
  function RandomSign:shortint;

  function PrettyFormatFloat(value:extended; ExponentWhenScientific:integer):string;
  function PrettyFormatFloatWithMinMax(value:extended; ExponentWhenScientific:integer; Min,Max:extended; ExtraPrecisionDigits:byte=1):string; overload;
  function PrettyFormatFloatWithMinMax(value:extended; ExponentWhenScientific:integer; MinMax:TRealRange; ExtraPrecisionDigits:byte=1):string; overload;

  function Aroundto(zahl:real; Vielfaches:integer; Aufrunden:boolean):integer;

  procedure timetohhmmss(const r:real; var hh,mm,ss:byte); overload;
  function timetohhmmss(r:real):string;                    overload;
  procedure timetohhmm(const r:real; var hh,mm:byte);    overload;
  function timetohhmm(r:real):string;                      overload;
  function hhmmsstotime(hh,mm,ss:real; msec:integer):real;    overload;
  function hhmmsstotime(hh,mm,ss:real):real; overload;
  function hhmmsstotime(hh,mm:real):real;   overload;

  function anzstellen(zahl:cardinal):integer;       overload;
  function anzstellen(zahl:string):integer;        overload;

  function randomchar(const zeichen:Tsetofchar=['0'..'9','A'..'Z','a'..'z']):char;
  function randomstring(length:byte; const zeichen:Tsetofchar=['0'..'9','A'..'Z','a'..'z']):string;
  function ReplikeString(s:string; count:integer):string;
  procedure ADelay(msec:longint);
  procedure Delay(msecs:integer);
  procedure zaehlefps;
  procedure SwapReal(var zahl1,zahl2:real);
  function  Exponent10(value:extended):integer;
  function  Mantisse10(value:extended):extended;
  function  IsInRange(value,min,max:extended; swapIfNeed:boolean=true; IncludeMin:boolean=true; IncludeMax:boolean=true):boolean;
  function  MakeInRange(value,min,max:extended; swapIfNeed:boolean=true):real;
  procedure shellsort(var a:array of cardinal);
  function RandomRRange(min,max:real; IncludeMin:boolean=true; IncludeMax:boolean=true):real;
  function RandomRRangeSpecial(min,max:real; IncreaseProbability, DecreaseProbability:boolean; IncludeMin:boolean=true; IncludeMax:boolean=true):real;
  procedure RInc(var value:real; const inc:real); overload;
  procedure RInc(var value1,value2:real; const inc:real); overload;
  procedure RInc(var value1,value2,value3:real; const inc:real); overload;
  procedure RInc(var value1,value2,value3,value4:real; const inc:real); overload;

  function schaltjahr(year:longint):boolean;
  function monatslaenge(mon:byte; year:integer):integer;
  function gregtojul(time:real; day,mon,year:integer):extended;overload;
  function gregtojul(hour,min,sec,day,mon,year:integer):extended;overload;
  procedure jultogreg(var day,mon,year:integer; const juldatum:real);

  function ChooseNearest(zahl:extended; ar:TRealArray):extended;
  function ReduceRangeFromCenterGetMin(Min,Max,ReduceFactor:real; CenterIsMidlle:boolean=true; Center:real=0):real;
  function ReduceRangeFromCenterGetMax(Min,Max,ReduceFactor:real; CenterIsMidlle:boolean=true; Center:real=0):real;

  procedure writeGrid(const zahl:string=''; faktor:string=''; Fermat:string=''; Euler:string='');                overload;
  procedure writeGrid(zeile:cardinal; const  zahl:string=''; faktor:string=''; Fermat:string=''; Euler:string='');overload;

  function teilbar(zahl,m:integer):boolean;                  overload;

  function modulo(zahl,red:extended; ForcePositiv:boolean=false):extended;
  function radtoBog(Rad:extended):extended;
  function BogtoRad(Bog:extended):extended;
  procedure AZoom(Min,Max,ZoomCenter,ZoomPercentage:real; var NewMin,NewMax:real);


  procedure DivideString(s:string; const Separator, DivideList:TStrings);
  function AddLineEndingAfterChar(s:string):string;
  function KorrectUmlaut(s: string): char;

  function randomColor:Tcolor;
  function ColtoStr(color:Tcolor):string;
  procedure ColorValues(const color: Tcolor; var R,G,B:byte);
  function  IntensityColor(col:TColor; Intensity:real):TColor;
  function AddColors(color1,color2: tcolor): TColor;  overload;
  function AddColors(color1,color2: tcolor; percentage1,percentage2:real): TColor;overload;
  procedure MergeBmp(var merged:TBitmap;  bmp1,bmp2:TBitmap);
  function  WavelengthToRGB(const lambda:real):Tcolor;
  function GegenFarbe(color:TColor):TColor;
  function ColortoHTMLColor(Color:TColor):string;
  function HTMLColorString(s:string; color:TColor):string;

  function OverRect(pos:TPoint; rec:Trect; TopToBottom:boolean=true):boolean; overload;
  function OverRect(pos:TR3Vec; rec:Trect; TopToBottom:boolean=true):boolean; overload;
  function OverRect(x,y:real; rec:Trect; TopToBottom:boolean=true):boolean;   overload;

  function PosInRect(Ground:Trect; Big,Font:TR3Vec; BigEdge,LetterEdge:TEdges; Position:TR3vec):TR3vec; overload;
  function PosInRect(Ground:Trect; Big,Font:TR3vec; BigEdge,LetterEdge:TEdges; Position:TR3vec; depth:real):TR3Vec; overload;
  function PosInRect(Ground:Trect; AnzLines,LineDistance,AnzLetters,FontSize:integer; BigEdge,LetterEdge:TEdges; Position:TR3vec):TR3vec; overload;
  function PosInRect(Ground:Trect; Big,Font:TR3vec; BigEdge,LetterEdge:TEdges; Position:TBoolRect):TR3vec;   overload;
  function PosInRect(Ground:Trect; Big,Font:TR3vec; BigEdge,LetterEdge:TEdges; Position:TBoolRect; depth:real):TR3Vec; overload;


  function BoolRect(Left,Right,Bottom,Top:boolean):TBoolRect;
  
  function ChartValue(x,y,z:TKoor1; Title:string; TitleEnabled:boolean; Color: TColor; Tag,Tag2:Longint):TChartValue;overload;
  function ChartValue(x,y,z:TKoor1; Title:string; TitleEnabled:boolean; Color: TColor; Tag:longint):TChartValue;overload;
  function ChartValue(pos:TKoor3; Title:string; TitleEnabled:boolean; Color: TColor; Tag:longint):TChartValue;overload;
  function ChartValue(pos:TKoor3; Title:string; TitleEnabled:boolean; Color: TColor; Tag,Tag2:longint):TChartValue;overload;
  function ChartValue(x,y,z:TKoor1; Title:string; TitleEnabled:boolean; Color: TColor):TChartValue;overload;
  function ChartValue(x,y,z:TKoor1; Title:string; Color:TColor):TChartValue;        overload;
  function ChartValue(x,y,z:TKoor1; Color: TColor):TChartValue;                     overload;

  function R3Vec(x,y,z:real):TR3Vec;
  function R2Vec(x,y:real):TR2Vec;
  function RealRange(Min,Max:real):TRealRange;
  function R3Vec2Str(x,y,z:real):string;  overload;
  function R3Vec2Str(vec:TR3Vec):string;  overload;
  function R2RectSimple2Str(rect:TR2RectSimple): string;

  
  function Change2OGL(Kind:TKoorKind):TKoorKind;
  function Change2OGLReality(Kind:TKoorKind):TKoorKind;
  function Change2Pixel(Kind:TKoorKind):TKoorKind;

  function Koor1(v:real; Kind:TKoorKind):TKoor1;
  function Koor3(x,y,z:TKoor1):TKoor3; overload;
  function Koor3(x,y,z:real; Kindx, Kindy, Kindz:TKoorKind):TKoor3; overload;
  function Koor3OGL(x, y, z: real): TKoor3;
  function Koor3Pixel(x, y, z: real): TKoor3;

  function KoorKind2Str(koorKind:TKoorKind):string;
  function MinKoor(koor1,koor2:TKoor1):TKoor1;
  function MaxKoor(koor1,koor2:TKoor1):TKoor1;

  function AbsolutePosition(comp:TControl):TPoint;


procedure test;
var
      //für fps
      fps:real;
      fpszeit1:longint;
      fpsbilder:integer;

implementation
uses unit1;





function BoolRect(Left,Right,Bottom,Top:boolean):TBoolRect;
begin
  result.Left:=Left;
  result.Right:=Right;
  result.Bottom:=Bottom;
  result.Top:=Top;
end;


function ChartValue(x, y, z: TKoor1; Title: string; TitleEnabled: boolean;
  Color: TColor; Tag,Tag2:Longint): TChartValue;
begin
  result.pos.x:=x;
  result.pos.y:=y;
  result.pos.z:=z;
  Result.Title:=Title;
  Result.TitleEnabled:=TitleEnabled;
  Result.Color:=Color;
  Result.Tag:=Tag;
  Result.Tag2:=Tag2;
end;

function ChartValue(x, y, z: TKoor1; Title: string; TitleEnabled: boolean; Color: TColor; Tag: longint): TChartValue;
begin
  result:=ChartValue(x,y,z, Title, TitleEnabled, Color, Tag, 0);
end;

function ChartValue(pos: TKoor3; Title: string; TitleEnabled: boolean; Color: TColor; Tag: longint): TChartValue;
begin
  result:=ChartValue(pos.x,pos.y,pos.z, Title, TitleEnabled, Color, Tag);
end;

function ChartValue(pos: TKoor3; Title: string; TitleEnabled: boolean;
  Color: TColor; Tag, Tag2: longint): TChartValue;
begin
  result:=ChartValue(pos.x,pos.y,pos.z, Title, TitleEnabled, Color, Tag, Tag2);
end;

function ChartValue(x, y, z: TKoor1; Title: string; TitleEnabled: boolean;  Color: TColor): TChartValue;
begin
  result:=ChartValue(x,y,z, Title, TitleEnabled, Color, 0);
end;

function ChartValue(x, y, z: TKoor1; Title: string; Color: TColor ): TChartValue;
begin
  Result:=ChartValue(x,y,z,Title,true, Color);
end;


function ChartValue(x, y, z: TKoor1; Color: TColor): TChartValue;
begin
  Result:=ChartValue(x,y,z,'',false,Color);
end;



function R2Vec(x,y:real):TR2Vec;
begin
  result.x:=x;
  result.y:=y;
end;

function RealRange(Min, Max: real): TRealRange;
begin
  result.Min:=Min;
  result.Max:=Max;
end;


function R3Vec2Str(x, y, z: real): string;
begin
  Result:='x= '+FormatFloat('0.00', x)+
          '  y= '+FormatFloat('0.00', y)+
          '  z= '+FormatFloat('0.00', z)  ;
end;


function R3Vec2Str(vec: TR3Vec): string;
begin
  Result:=R3Vec2Str(vec.x, vec.y, vec.z);
end;

function R2RectSimple2Str(rect: TR2RectSimple): string;
begin
  Result:='left= '+FormatFloat('0.##', rect.Left)+
          '  right= '+FormatFloat('0.##', rect.right)+
          '  bottom= '+FormatFloat('0.##', rect.bottom) +
          '  top= '+FormatFloat('0.##', rect.top)  ;
end;


function Change2Koor(Kind: TKoorKind): TKoorKind;
begin
  Result:=Kind;
  case Kind of
    kkOGLRealityx, kkOGLx, kkPixelx:  result:=kkx;
    kkOGLRealityy, kkOGLy, kkPixely:  result:=kkLS;
    kkOGLRealityz, kkOGLz, kkPixelz:  result:=kkz;
  end;
end;

function Change2OGL(Kind: TKoorKind): TKoorKind;
begin
  Result:=Kind;
  case Kind of
    kkOGLRealityx, kkx, kkPixelx:  result:=kkOGLx;
    kkOGLRealityy, kkLS, kkImage, kkPixely:  result:=kkOGLy;
    kkOGLRealityz, kkz, kkPixelz:  result:=kkOGLz;
  end;
end;

function Change2OGLReality(Kind: TKoorKind): TKoorKind;
begin
  Result:=Kind;
  case Kind of
    kkOGLx, kkx, kkPixelx:  result:=kkOGLRealityx;
    kkOGLy, kkLS, kkImage, kkPixely:  result:=kkOGLRealityy;
    kkOGLz, kkz, kkPixelz:  result:=kkOGLRealityz;
  end;
end;

function Change2Pixel(Kind: TKoorKind): TKoorKind;
begin
  Result:=Kind;
  case Kind of
    kkOGLx, kkx, kkOGLRealityx:  result:=kkPixelx;
    kkOGLy, kkLS, kkImage, kkOGLRealityy:  result:=kkPixely;
    kkOGLz, kkz, kkOGLRealityz:  result:=kkPixelz;
  end;
end;

function Koor1(v: real; Kind: TKoorKind): TKoor1;
begin
   Result.v:=v;
  Result.Kind:=Kind;
end;

function Koor3(x, y, z: TKoor1): TKoor3;
begin
  Result.x:=x;
  Result.y:=y;
  Result.z:=z;
end;

function Koor3(x, y, z: real; Kindx: TKoorKind; Kindy: TKoorKind;  Kindz: TKoorKind): TKoor3;
begin
  Result.x:=Koor1(x,Kindx);
  Result.y:=Koor1(y,Kindy);
  Result.z:=Koor1(z,Kindz);
end;

function Koor3OGL(x, y, z: real): TKoor3;
begin
  Result.x:=Koor1(x,kkOGLx);
  Result.y:=Koor1(y,kkOGLy);
  Result.z:=Koor1(z,kkOGLz);
end;

function Koor3Pixel(x, y, z: real): TKoor3;
begin
  Result.x:=Koor1(x,kkPixelx);
  Result.y:=Koor1(y,kkPixely);
  Result.z:=Koor1(z,kkPixelz);
end;



function R2Rect2Str(rect: TR2Rect): string;
begin
  Result:='left= '+FormatFloat('0.##', rect.Left)+
          '  right= '+FormatFloat('0.##', rect.right)+
          '  bottom= '+FormatFloat('0.##', rect.bottom) +
          '  top= '+FormatFloat('0.##', rect.top)  ;
end;



function R3Vec(x,y,z:real):TR3Vec;
begin
  result.x:=x;
  result.y:=y;
  result.z:=z;
end;




{ TR2Rect }


function TR2Rect.ReadFWidth: real;
begin
  Result:=Right-Left;
end;

procedure TR2Rect.WriteFWidth(Width: real);
begin
  Right:=Left+Width;
end;

function TR2Rect.ReadFHeight: real;
begin
  Result:=Top-Bottom;
end;

procedure TR2Rect.WriteFHeight(Height: real);
begin
  Top:=Bottom+Height;
end;


function TR2Rect.ratio: real;
begin
  Result:=Width/Height;
end;

procedure TR2Rect.R2Rect(aLeft, aBottom, awidth, aheight: real);
begin
  self.Left:=aLeft;
  self.Bottom:=aBottom;
  self.Width:=awidth;
  self.Height:=aheight;
end;

function TR2Rect.R2Rect2Str: string;
begin
  Result:='left= '+FormatFloat('0.##', Left)+
          '  right= '+FormatFloat('0.##', right)+
          '  bottom= '+FormatFloat('0.##', bottom) +
          '  top= '+FormatFloat('0.##', top)  ;
end;




constructor TR2Rect.create;
begin
  inherited;
  
  Top:=100;
  Bottom:=0;
  Left:=0;
  Right:=100;
end;



{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray
TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray
TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray  TIntegerArray
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}


{-----------------------------------------------------------------------------
  Description:
  Procedure:    readFarr
  Arguments:    idx:integer
  Result:       integer
  Detailed description:
-----------------------------------------------------------------------------}
function TIntegerArray.readFarr(idx:integer):integer;
begin
  result:=self.Farr[idx];
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeFarr
  Arguments:    idx:integer; value:integer
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TIntegerArray.writeFarr(idx:integer; value:integer);
begin
  if Farr=nil then
    setlength(Farr,1);
  if idx>high(Farr) then
    setlength(Farr,idx+1);

  Farr[idx]:=value;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    delete
  Arguments:    idx:integer
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TIntegerArray.delete(idx:integer);
var i:integer;
begin
  if idx>high(Farr) then exit;

  for i:=idx to high(Farr)-1 do
    Farr[i]:=Farr[i+1];
  setlength(Farr,high(Farr));
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    add
  Arguments:    value:integer
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TIntegerArray.add(value:integer);
begin
  if Farr=nil then
    writeFarr(0,value)
  else
    writeFarr(length(Farr),value);
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    insert
  Arguments:    idx:integer; value:integer
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TIntegerArray.insert(idx:integer; value:integer);
var i:integer;
begin
  setlength(Farr,length(Farr)+1);

  for i:=high(Farr)-1 downto idx do
    Farr[i+1]:=Farr[i];

  Farr[idx]:=value;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    LastItem
  Arguments:    None
  Result:       integer
  Detailed description:
-----------------------------------------------------------------------------}
function TIntegerArray.LastItem:integer;
begin
  result:=self.Farr[count-1];
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    count
  Arguments:    None
  Result:       word
  Detailed description:
-----------------------------------------------------------------------------}
function TIntegerArray.count:integer;
begin
  result:=length(Farr);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    DelDubbleValues
  Arguments:    const SourceArray:TIntegerArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TIntegerArray.DelDubbleValues(const SourceArray:TIntegerArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]); //das Scource Array wird nicht verändert
var i,j:integer;
    del:TIntegerArray;
begin
  del:=TIntegerArray.Create;
  try
    //Überschneidungen finden und in del speichern
    for i:= 0 to SourceArray.count-1 do
      begin
      if i in ExcludeIdxSource then
        continue;     //werte überspringen
      j:=0;
      while j< self.count do
        begin
        if j in ExcludeIdxHere then
          inc(j);     //werte überspringen    inc(j) entspricht continue;
        if Farr[j]=SourceArray[i] then
          del.add(j);
        inc(j);
        end;
      end;
    //Überschneidungen löschen
    for i:=del.count-1 downto 0 do
      self.delete(del[i]);
  finally
    del.free;
  end;
end;


{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray
TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray
TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray  TRealArray
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}





{-----------------------------------------------------------------------------
  Description:
  Procedure:    readFarr
  Arguments:    idx:integer
  Result:       real
  Detailed description:
-----------------------------------------------------------------------------}
function TRealArray.readFarr(idx:integer):real;
begin
  result:=self.Farr[idx];
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeFarr
  Arguments:    idx:integer; value:real
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TRealArray.writeFarr(idx:integer; value:real);
begin
  if Farr=nil then
    setlength(Farr,1);
  if idx>high(Farr) then
    setlength(Farr,idx+1);

  Farr[idx]:=value;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    delete
  Arguments:    idx:integer
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TRealArray.delete(idx:integer);
var i:integer;
begin
  if idx>high(Farr) then exit;

  for i:=idx to high(Farr)-1 do
    Farr[i]:=Farr[i+1];
  setlength(Farr,high(Farr));
end;

procedure TRealArray.clear;
begin
  setlength(Farr,0);
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    add
  Arguments:    value:real
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TRealArray.add(value:real);
begin
  if Farr=nil then
    writeFarr(0,value)
  else
    writeFarr(length(Farr),value);
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    insert
  Arguments:    idx:integer; value:real
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TRealArray.insert(idx:integer; value:real);
var i:integer;
begin
  setlength(Farr,length(Farr)+1);

  for i:=high(Farr)-1 downto idx do
    Farr[i+1]:=Farr[i];

  Farr[idx]:=value;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    LastItem
  Arguments:    None
  Result:       real
  Detailed description:
-----------------------------------------------------------------------------}
function TRealArray.LastItem:real;
begin
  result:=self.Farr[count-1];
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    count
  Arguments:    None
  Result:       word
  Detailed description:
-----------------------------------------------------------------------------}
function TRealArray.count:integer;
begin
  result:=length(Farr);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    DelDubbleValues
  Arguments:    const SourceArray:TRealArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TRealArray.DelDubbleValues(const SourceArray:TRealArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]); //das Scource Array wird nicht verändert
var i,j:integer;
    del:TIntegerArray;
begin
  del:=TIntegerArray.Create;
  try
    //Überschneidungen rauswerfen
    for i:= 0 to SourceArray.count-1 do
      begin
      if i in ExcludeIdxSource then
        continue;     //werte überspringen
      j:=0;
      while j< self.count do
        begin
        if j in ExcludeIdxHere then
          inc(j);     //werte überspringen    inc(j) entspricht continue;
        if Farr[j]=SourceArray[i] then
          del.add(j);
        inc(j);
        end;
      end;
    //überschneidungen löschen
    for i:=del.count-1 downto 0 do
      self.delete(del[i]);
  finally
    del.free;
  end;
end;




procedure test;
var ar:TRealArray;
    s:string;
    i:integer;
begin
  ar:=TRealArray.Create;
  s:='';
  ar.insert(5,45);

  ar.add(0);
  ar.add(1);
  ar.add(2);
  ar.add(3);
  ar.add(4);
  ar.add(5);
  ar.add(6);

  s:=s+#13+'ar'+#13;
  for i:=0 to ar.count-1 do
    s:=s+floattostr(ar[i])+#13;
  s:=s+#13;

  ar.insert(5,45);
  s:=s+#13+'ar'+#13;
  for i:=0 to ar.count-1 do
    s:=s+floattostr(ar[i])+#13;

  showmessage(s);

  ar.Free;
end;






{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray
TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray
TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray  TChartValueArray
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}





{-----------------------------------------------------------------------------
  Description:
  Procedure:    readFarr
  Arguments:    idx:integer
  Result:       TChartValue
  Detailed description:
-----------------------------------------------------------------------------}
function TChartValueArray.readFarr(idx:integer):TChartValue;
begin
  result:=self.Farr[idx];
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeFarr
  Arguments:    idx:integer; value:TChartValue
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TChartValueArray.writeFarr(idx:integer; value:TChartValue);
begin
  if Farr=nil then
    setlength(Farr,1);
  if idx>high(Farr) then
    setlength(Farr,idx+1);

  Farr[idx]:=value;


  //set the ranges

  if BlankRanges then
    begin
    FMaxXRange.Max:=value.pos.x.v;
    FMaxXRange.Min:=value.pos.x.v;
    FMaxYRange.Max:=value.pos.y.v;
    FMaxYRange.Min:=value.pos.y.v;
    FMaxZRange.Max:=value.pos.z.v;
    FMaxZRange.Min:=value.pos.z.v;
    BlankRanges:=false;
    end
  else
    begin
    if value.pos.x.v > FMaxXRange.Max then
      FMaxXRange.Max:=value.pos.x.v
    else
      if value.pos.x.v < FMaxXRange.Min then
        FMaxXRange.Min:=value.pos.x.v;

    if value.pos.y.v > FMaxYRange.Max then
      FMaxYRange.Max:=value.pos.y.v
    else
      if value.pos.y.v < FMaxYRange.Min then
        FMaxYRange.Min:=value.pos.y.v;

    if value.pos.z.v > FMaxZRange.Max then
      FMaxZRange.Max:=value.pos.z.v
    else
      if value.pos.z.v < FMaxZRange.Min then
        FMaxZRange.Min:=value.pos.z.v;
    end;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    delete
  Arguments:    idx:integer
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TChartValueArray.delete(idx:integer);
var i:integer;
begin
  if idx>high(Farr) then exit;

  for i:=idx to high(Farr)-1 do
    Farr[i]:=Farr[i+1];
  setlength(Farr,high(Farr));
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    add
  Arguments:    value:TChartValue
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TChartValueArray.add(value:TChartValue);
begin
  if Farr=nil then
    writeFarr(0,value)
  else
    writeFarr(length(Farr),value);
end;




procedure TChartValueArray.add(x, y, z:TKoor1; Color: Tcolor);
begin
  add(ChartValue(x, y, z,Color));
end;

procedure TChartValueArray.add(pos: TKoor3; Color: Tcolor);
begin
  add(ChartValue(pos.x, pos.y, pos.z, Color));
end;


procedure TChartValueArray.add(x, y, z:TKoor1; Title: string; Color: Tcolor);
begin
  add(ChartValue(x, y, z,Title, Color));
end;

procedure TChartValueArray.add(pos: TKoor3; Title: string; Color: Tcolor);
begin
  add(ChartValue(pos.x, pos.y, pos.z,Title, Color));
end;

procedure TChartValueArray.add(pos: TKoor3; Title: string; Color: Tcolor; Tag: longint);
begin
  add(ChartValue(pos.x, pos.y, pos.z,Title,true, Color, Tag));
end;



procedure TChartValueArray.clear;
begin
  setlength(Farr,0);

  FMaxXRange:=RealRange(0,0);
  FMaxYRange:=RealRange(0,0);
  FMaxZRange:=RealRange(0,0);
  BlankRanges:=true;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    insert
  Arguments:    idx:integer; value:TChartValue
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TChartValueArray.insert(idx:integer; value:TChartValue);
var i:integer;
begin
  setlength(Farr,length(Farr)+1);

  for i:=high(Farr)-1 downto idx do
    Farr[i+1]:=Farr[i];

  Farr[idx]:=value;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    LastItem
  Arguments:    None
  Result:       TChartValue
  Detailed description:
-----------------------------------------------------------------------------}
function TChartValueArray.LastItem:TChartValue;
begin
  result:=self.Farr[count-1];
end;



function TChartValueArray.GetRightValue(idx: integer; WhatValue: TXYZKind): real;
begin
  Result:=GetRightKoor(idx, WhatValue).v;
end;


function TChartValueArray.GetRightKoor(idx: integer; WhatValue: TXYZKind): TKoor1;
begin
  case WhatValue of
    xyzkX: Result:=arr[idx].pos.x;
    xyzkY: Result:=arr[idx].pos.y;
    xyzkZ: Result:=arr[idx].pos.z;
  end;
end;

procedure TChartValueArray.SetRightValue(newvalue: real; idx: integer;  WhatValue: TXYZKind);
var temp:TChartValue;
begin
  temp:=arr[idx];
  case WhatValue of
    xyzkX: temp.pos.x.v:=newvalue;
    xyzkY: temp.pos.y.v:=newvalue;
    xyzkZ: temp.pos.z.v:=newvalue;
  end;
  arr[idx]:=temp;
end;



{-----------------------------------------------------------------------------
  Description:  Eine der schnellsten methoden zum Sortieren  mit shellsort
  Procedure:    sort
  Detailed description:    Ich habe diese Prozedur NICHT geschrieben
-----------------------------------------------------------------------------}
procedure TChartValueArray.sort(SortKind: TXYZKind);
var  bis,i,j,k:longint;
      h:TChartValue;
begin
  bis:=count-1;

  if count<=1 then
    exit;

  k:= bis shr 1;
  while k>0 do
    begin
    for i:=0 to bis - k do
      begin
      j:=i;
      if IsNan(GetRightValue(j, SortKind)) or IsNan(GetRightValue(j+k, SortKind)) then
        begin
        showmessage('nan'+#13+'j.x= '+floattostr(Farr[j].pos.x.v)+'  j.y= '+floattostr(Farr[j].pos.y.v)+'  j.z= '+floattostr(Farr[j].pos.z.v));
        continue;
        end;

      while (j>=0) and(GetRightValue(j, SortKind)>GetRightValue(j+k, SortKind)) do
        begin
        h:=Farr[j];
        Farr[j]:=Farr[j+k];
        Farr[j+k]:=h;
        if j>k then dec(j,k) else j:=0;
        end;
      end;
    k:= k shr 1;
    end;
end;



procedure ShellSort(var aSort: array of integer);
var
  iI, iJ, iK,
  iSize: integer;
  wTemp: integer;
begin
  iSize := High(aSort);
  iK := iSize shr 1;
  while iK > 0 do
  begin
    for iI := 0 to iSize - iK do
    begin
      iJ := iI;
      while (iJ >= 0) and (aSort[iJ] > aSort[iJ + iK]) do
      begin
        wTemp := aSort[iJ];
        aSort[iJ] := aSort[iJ + iK];
        aSort[iJ + iK] := wTemp;
        if iJ > iK then
          Dec(iJ, iK)
        else
          iJ := 0
      end;
    end;
    iK := iK shr 1;
  end;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    count
  Arguments:    None
  Result:       word
  Detailed description:
-----------------------------------------------------------------------------}
function TChartValueArray.count:integer;
begin
  if Farr<>nil then
    result:=length(Farr)
  else
    Result:=0;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    DelDubbleValues
  Arguments:    const SourceArray:TChartValueArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TChartValueArray.DelDubbleValues(const SourceArray:TChartValueArray; const ExcludeIdxHere:TsetofInteger=[]; const ExcludeIdxSource:TsetofInteger=[]); //das Scource Array wird nicht verändert
var i,j:integer;
    del:TIntegerArray;
begin
  del:=TIntegerArray.Create;
  try
    //Überschneidungen rauswerfen
    for i:= 0 to SourceArray.count-1 do
      begin
      if i in ExcludeIdxSource then
        continue;     //werte überspringen
      j:=0;
      while j< self.count do
        begin
        if j in ExcludeIdxHere then
          inc(j);     //werte überspringen    inc(j) entspricht continue;
        if (Farr[j].pos.x.v=SourceArray[i].pos.x.v)and(Farr[j].pos.y.v=SourceArray[i].pos.y.v) then
          del.add(j);
        inc(j);
        end;
      end;
    //Überschneidungen löschen
    for i:=del.count-1 downto 0 do
      self.delete(del[i]);
  finally
    del.free;
  end;
end;


constructor TChartValueArray.create;
begin
  inherited create;

  clear;
end;




destructor TChartValueArray.destroy;
begin
  clear;

  inherited destroy;
end;






{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray
TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray
TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray  TClassArray
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}

{-----------------------------------------------------------------------------
  Description:
  Procedure:    create
  Arguments:    CFastAdding:boolean; CFastMaxIdx:integer=50
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
constructor TClassArray.create(CFastAdding:boolean; CFastMaxIdx:integer=50);
begin
  inherited create;

  self.FastAdding:=CFastAdding;
  self.FastMaxIdx:=CFastMaxIdx;

  if FastAdding then
    setlength(Farr,FastMaxIdx);

  count:=0;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    destroy
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
destructor TClassArray.destroy;
begin
  Farr:=nil;

  inherited destroy;
end;



destructor TClassArray.destroyAndFreeObjects;
var I:integer;
begin
  for i:= Count-1 downto 0 do
    if Farr[i]<> nil then
      Farr[i].Free;


  destroy;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    readFarr
  Arguments:    idx:integer
  Result:       TObject
  Detailed description:
-----------------------------------------------------------------------------}
function TClassArray.readFarr(idx:integer):TObject;
begin
  result:=self.Farr[idx];
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeFarr
  Arguments:    idx:integer; value:TObject
  Result:       None
  Detailed description:   Überall wo ich Farr[]:=value mache ist etwas ganz besonderes
                          Ich kopiere nämlich den Pointer value auf Farr[]
                          Ich kopiere nicht die Objekte, sondern nur die Pointer,
                          dh. Farr[] muss nicht created werden, da es nun auf ein bereits createtes
                          Objekt zeigt. Ich muss nun nur value:=nil setzten und ich habe nun nur noch
                          Farr[] was auf den ehemligen value zeigt und value zeigt auf nichts mehr.
-----------------------------------------------------------------------------}
procedure TClassArray.writeFarr(idx:integer; value:TObject);
begin
  if self.FastAdding then
    begin
    if Farr=nil then
      setlength(Farr,FastMaxIdx);

    if countFast-count<=0 then
      setlength(Farr,count+FastMaxIdx);

    if idx>=count then
      begin
      Farr[count]:=value;
      inc(count);
      end
    else
      Farr[idx]:=value;
    end
  else
    begin
    if Farr=nil then
      setlength(Farr,1);

    if idx>=count then
      begin
      setlength(Farr,count+1);
      Farr[count]:=value;
      inc(count);
      end
    else
      Farr[idx]:=value;
    end;
end;   { End of  TClassArray.writeFarr }



{-----------------------------------------------------------------------------
  Procedure:    delete
  Arguments:    idx:integer
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TClassArray.delete(idx:integer);
var i:integer;
begin
  if idx>count-1 then exit;

  for i:=idx to count-2 do
    Farr[i]:=Farr[i+1];

  Farr[count-1]:=nil;
  dec(count);


  if FastAdding then
    begin
    if countFast-count>=2*FastMaxIdx then
      setlength(Farr,countFast-FastMaxIdx);
    end
  else
    setlength(Farr,count);
end;



procedure TClassArray.deleteAndFree(idx:integer);
begin
  if idx>count-1 then exit;

  Farr[idx].Free;
  
  delete(idx);
end;


function TClassArray.add(value:TObject):integer;
begin
  Result:=count;
  writeFarr(count,value);
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    add
  Arguments:    CBrushColor,CBorderColor:Tcolor; Cposition:TR3Vec; Cradius:TChartValue; CcountPoints:integer; Ctransparency:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
{procedure TClassArray.add(CBrushColor,CBorderColor:Tcolor; Cposition:TR3Vec;  Cradius:TChartValue; CcountPoints:integer; Ctransparency:byte);
var drop:TObject;
begin
  drop:=TObject.create(self.count,CBrushColor,CBorderColor,Cposition,Cradius,CcountPoints,Ctransparency);

  add(drop);

//  drop.Free;
  drop:=nil;    //wieso free ich hier nicht? Ganz einfach, der Pointer von drops[i] zeigt nun auf das Object,
                  //und ich kann ohne Leichen zu erzeugen das nil setzten
end;}

{-----------------------------------------------------------------------------
  Description:
  Procedure:    insert
  Arguments:    idx:integer; value:TObject
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TClassArray.insert(idx:integer; value:TObject);
var i:integer;
begin
  if assigned(self.Farr) then
    setlength(Farr,length(Farr)+1)
  else
    setlength(Farr,1);

  for i:=high(Farr)-1 downto idx do
    Farr[i+1]:=Farr[i];

  Farr[idx]:=value;
  inc(count);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    LastItem
  Arguments:    None
  Result:       TObject
  Detailed description:
-----------------------------------------------------------------------------}
function TClassArray.LastItem:TObject;
begin
  if assigned(self.Farr) and (count>0) then
    result:=self.Farr[count-1]
  else
    result:=nil;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    FirstItem
  Arguments:    None
  Result:       TObject
  Detailed description:
-----------------------------------------------------------------------------}
function TClassArray.FirstItem:TObject;
begin
  if assigned(self.Farr) and (count>0) then
    result:=self.Farr[0]
  else
    result:=nil;
end;




{==============================================================================
  Procedure:    SwapIdx
  Belongs to:   TClassArray
  Result:       None
  Parameters:
                  idx1 : word  =
                  idx2 : word  =

  Description:
==============================================================================}
procedure TClassArray.SwapIdx(idx1,idx2:integer);
var temp:TObject;
begin
  temp:=Farr[idx1];
  Farr[idx1]:=Farr[idx2];
  Farr[idx2]:=temp;

  temp:=nil;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    countFast
  Arguments:    None
  Result:       word
  Detailed description:
-----------------------------------------------------------------------------}
function TClassArray.countFast:integer;
begin
  if assigned(self.Farr) then
    result:=length(Farr)
  else
    result:=0;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    RandomBool
  Arguments:    None
  Result:       boolean
  Detailed description:
-----------------------------------------------------------------------------}
function RandomBool:boolean;
begin
  result:=random(2)=0  ;
end;



{-----------------------------------------------------------------------------
  Description:  Gibt den Werte eines Boolean als 1 oder -1 aus
  Procedure:    boolsign
  Arguments:    a:boolean
  Result:       shortint
  Detailed description:
-----------------------------------------------------------------------------}
function boolsign(a:boolean):shortint;
begin
  if a then
    result:=1
  else
    result:=-1;
end;

{-----------------------------------------------------------------------------
  Description:  Boolean to 0 or 1
  Procedure:    boolto01
  Arguments:    a:boolean
  Result:       byte
  Detailed description:
-----------------------------------------------------------------------------}
function boolto01(a:boolean):byte;
begin
  if a then
    result:=1
  else
    result:=0;
end;



{-----------------------------------------------------------------------------
  Description:  Vergleicht boolean  a<>b then true
  Procedure:    boolUngleich
  Arguments:    a,b:boolean
  Result:       boolean
  Detailed description:
-----------------------------------------------------------------------------}
function boolUngleich(a,b:boolean):boolean;
begin
  result:=true;                                              // Überprüfung durch Überprüfung des Gegenteils
  if (a and b) or  (not(a) and not(b))  then result:=false;
end;

{-----------------------------------------------------------------------------
  Description:   a=b then true
  Procedure:    boolGleich
  Arguments:    a,b:boolean
  Result:       boolean
  Detailed description:
-----------------------------------------------------------------------------}
function boolGleich(a,b:boolean):boolean;
begin
  result:=false;                                              // Überprüfung durch Überprüfung des Gegenteils
  if (a and b) or  (not(a) and not(b))  then result:=true;
end;







{-----------------------------------------------------------------------------
  Description:  Löscht Zeichen die da nicht reinpassen
  Procedure:    korrigiere
  Arguments:    var s:String; const zeichen:Tsetofchar   ; DelDoublePoint:boolean=true
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure korrigiere(var s:AnsiString; const zeichen:Tsetofchar=['0'..'9','-',',']; DelDoublePoint:boolean=true);
var c : word;
    schonkomma:boolean;
begin
  schonkomma:=false;
  c:=1;
  while c<= length(s) do
    begin
    if not(s[c] in zeichen)  then
      delete(s,c,1)
    else
      begin
      if DelDoublePoint and (s[c]=DecimalSeparator) then
        if not schonkomma then
          begin
          schonkomma:=true;
          inc(c);
          end
        else
          delete(s,c,1)         //doppelte Komma löschen
      else
        inc(c);
      end;
    end;
end;
{-----------------------------------------------------------------------------
  Description:  Direkt edite Korrigieren
  Arguments:    var edit:Tedit; const zeichen:Tsetofchar=['0'..'9','-',',']
-----------------------------------------------------------------------------}
procedure korrigiere(var edit:Tedit; const zeichen:Tsetofchar=['0'..'9','-',',']);
var s:ansistring;
begin
  s:=edit.Text ;
  korrigiere(s,zeichen);
  edit.Text:=s;
end;


{-----------------------------------------------------------------------------
  Description:  Korrigiere real Zahl
  Arguments:    var r:real;  max,min:real
-----------------------------------------------------------------------------}
procedure korrigiere(var r:real;  min,max:real);
var temp:real;
begin
  if max<min then
    begin
    temp:=min;
    min:=max;
    max:=temp;
    end;

  if r<min then r:=min;
  if r>max then r:=max;
end;
{-----------------------------------------------------------------------------
  Description:  Korrigiere real Zahl
  Arguments:    var e:extended;  min,max:extended
-----------------------------------------------------------------------------}
procedure korrigiere(var e:extended;  min,max:extended);
var temp:extended;
begin
  if max<min then
    begin
    temp:=min;
    min:=max;
    max:=temp;
    end;

  if e<min then e:=min;
  if e>max then e:=max;
end;
{-----------------------------------------------------------------------------
  Description:  Korrigiere Word Zahl
  Arguments:    var r:integer;  max,min:integer
-----------------------------------------------------------------------------}
procedure korrigiere(var w:integer;  min,max:integer);
var temp:integer;
begin
  if max<min then
    begin
    temp:=min;
    min:=max;
    max:=temp;
    end;

  if w<min then w:=min;
  if w>max then w:=max;
end;











{-----------------------------------------------------------------------------
  Description:
  Procedure:    Asign
  Arguments:    wert:real
  Result:       shortint
  Detailed description:
-----------------------------------------------------------------------------}
function Asign(wert:real):shortint;
begin
  if wert<0 then
    result:=-1
  else
    result:=1;
end;
{-----------------------------------------------------------------------------
  Description:
  Arguments:    wert:integer
-----------------------------------------------------------------------------}
function Asign(wert:integer):shortint;
begin
  if wert<0 then
    result:=-1
  else
    result:=1;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    RandomSign
  Arguments:    None
  Result:       shortint
  Detailed description:
-----------------------------------------------------------------------------}
function RandomSign:shortint;
begin
  if random(2)=0  then
    result:=1
  else
    result:=-1;
end;


function PrettyFormatFloat(value: extended; ExponentWhenScientific: integer): string;
begin
  if (abs(Exponent10(value))<ExponentWhenScientific) then
    Result:=Formatfloat('0.#',value)
  else
    Result:=Formatfloat('0.#E-0',value);
end;



function PrettyFormatFloatWithMinMax(value: extended;
  ExponentWhenScientific: integer; Min, Max: extended; ExtraPrecisionDigits:byte): string;
var sformat, spoint:string;
    i, digits:integer;
    temp:extended;
begin
  if Max<Min then
    begin
    temp:=Max;
    Max:=Min;
    Min:=temp;
    end;

  if (abs(Exponent10(value))<ExponentWhenScientific) then
    begin
    digits:=math.max( abs(Exponent10(abs(Min)))  ,  abs(Exponent10(abs(Max)))     );
    digits:=math.max( digits  ,  abs(Exponent10(abs(value)))     );
    digits:=math.max( digits  ,  abs(Exponent10(abs(Max-Min)))     );

    sformat:=ReplikeString('#', digits+ExtraPrecisionDigits);
    spoint:='.';
    if sformat='' then
      spoint:='';
    Result:=Formatfloat('0'+spoint+sformat,value);
    end
  else
    Result:=Formatfloat('0.#E-0',value);
end;


function PrettyFormatFloatWithMinMax(value: extended;
  ExponentWhenScientific: integer; MinMax: TRealRange; ExtraPrecisionDigits:byte): string;
begin
  result:=PrettyFormatFloatWithMinMax(value, ExponentWhenScientific, MinMax.Min, MinMax.Max, ExtraPrecisionDigits);
end;



{-----------------------------------------------------------------------------
  Description:  Rundet auf eine Bestimmte Vorkomma Zahl
  Procedure:    Aroundto
  Arguments:    zahl:real; Vielfaches:integer; Aufrunden:boolean
  Result:       cardinal
  Detailed description:
-----------------------------------------------------------------------------}
function Aroundto(zahl:real; Vielfaches:integer; Aufrunden:boolean):integer;
begin
  if  Aufrunden then
    result:=(trunc(zahl/Vielfaches)  + 1) * Vielfaches
  else
    result:= (trunc(zahl/Vielfaches)  - 1) * Vielfaches;

{  showmessage('zahl= '+floattostr(zahl)+#13+'Vielfaches= '+inttostr(Vielfaches)+#13+'Aufrunden= '+booltostr(Aufrunden,true)+#13
              +'result= '+inttostr(result));}
end;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    timetohhmmss
  Arguments:    const r:real; var hh,mm,ss:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure timetohhmmss(const r:real; var hh,mm,ss:byte);
begin
  timetohhmm(r,hh,mm);
  ss:=round(   ((r-hh)*60 - mm)*60    );
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    rtimetostime
  Arguments:    r:real
  Result:       string
  Detailed description:
-----------------------------------------------------------------------------}
function timetohhmmss(r:real):string;
var hh,mm,ss:byte;
begin
  result:=timetohhmm(r)+':';
  timetohhmmss(r,hh,mm,ss);

  if ss<10 then
    result:=result+'0';
  result:=result+inttostr(ss);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    timetohhmm
  Arguments:    const r:real; var hh,mm:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure timetohhmm(const r:real; var hh,mm:byte);
begin
  hh:=trunc(r);
  mm:=trunc(  (r-trunc(r))*60);
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    rtimetohhmm
  Arguments:    r:real
  Result:       string
  Detailed description:
-----------------------------------------------------------------------------}
function timetohhmm(r:real):string;
var hh,mm:byte;
begin
  timetohhmm(r,hh,mm);
  result:=inttostr(hh)+':';
  if mm<10 then
    result:=result+'0';
  result:=result+inttostr(mm);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    hhmmsstotime
  Arguments:    hh,mm,ss:byte; msec:integer
  Result:       real
  Detailed description:
-----------------------------------------------------------------------------}
function hhmmsstotime(hh,mm,ss:real; msec:integer):real;
begin
  result:=hh+mm/60+ss/3600+msec/3600/1000;
end;
{-----------------------------------------------------------------------------
  Arguments:    hh,mm,ss:byte
-----------------------------------------------------------------------------}
function hhmmsstotime(hh,mm,ss:real):real;
begin
  result:=hhmmsstotime(hh,mm,ss,0);
end;
{-----------------------------------------------------------------------------
  Arguments:    hh,mm,ss:byte
-----------------------------------------------------------------------------}
function hhmmsstotime(hh,mm:real):real;
begin
  result:=hhmmsstotime(hh,mm,0,0);
end;




{-----------------------------------------------------------------------------
  Arguments:    zahl:cardinal
-----------------------------------------------------------------------------}
function anzstellen(zahl:cardinal):integer;
begin
  result:=length(inttostr(zahl));
end;
{-----------------------------------------------------------------------------
  Arguments:    zahl:string
-----------------------------------------------------------------------------}
function anzstellen(zahl:string):integer;
begin
  result:=length(zahl);
end;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    randomchar
  Arguments:    const zeichen:Tsetofchar=['0'..'9','A'..'Z','a'..'z']
  Result:       char
  Detailed description:
-----------------------------------------------------------------------------}
function randomchar(const zeichen:Tsetofchar=['0'..'9','A'..'Z','a'..'z']):char;
begin
  repeat
    result:=chr(random(75)+48);
  until  result in  zeichen;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    randomstring
  Arguments:    length:byte; const zeichen:Tsetofchar=['0'..'9','A'..'Z','a'..'z']
  Result:       string
  Detailed description:
-----------------------------------------------------------------------------}
function randomstring(length:byte; const zeichen:Tsetofchar=['0'..'9','A'..'Z','a'..'z']):string;
var i:integer;
begin
  result:='';
  for i:= 0 to length-1   do
    result:=result+randomchar(zeichen);
end;







function ReplikeString(s: string; count: integer): string;
var i:integer;
begin
  Result:='';;
  for i := 1 to count do
    Result:=Result+s;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    ADelay
  Arguments:    msec:longint
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure ADelay(msec:longint);
var start:longint;
begin
{  start:=gettickcount;
  repeat
    application.ProcessMessages;
  until  gettickcount-start>=msec;}
end;









{-----------------------------------------------------------------------------
  Description:
  Procedure:    Delay
  Arguments:    msecs:integer
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure Delay(msecs:integer);
var
  FirstTickCount:longint;
begin
{  FirstTickCount:=GetTickCount;
  repeat
  sleep(5);
  Application.ProcessMessages; {allowing access to other controls, etc.}
//  until ((GetTickCount-FirstTickCount) >= Longint(msecs));}
end;




{-----------------------------------------------------------------------------
  Description:  FPS
  Procedure:    zaehlefps
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure zaehlefps;
begin
//fps
{fpsbilder:=fpsbilder+1;
if gettickcount-fpszeit1>100 then
  begin
  fps:=fpsbilder/(gettickcount-fpszeit1)*1000;
  fpszeit1:=gettickcount-1;
  fpsbilder:=0;
  end;}
end;



procedure SwapReal(var zahl1, zahl2: real);
var temp:real;
begin
  temp:=zahl2;
  zahl2:=zahl1;
  zahl1:=temp;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    Exponent10
  Arguments:    value:integer
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function  Exponent10(value:extended):integer;
begin
  if value=0 then
    begin
    Result:=0;
    exit;
    end;
    
  result:=trunc(log10(abs(value)));
  if abs(value)<=1 then
    dec(result);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    Mantisse10
  Arguments:    value:extended
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function  Mantisse10(value:extended):extended;
begin
  result:=value/power(10,Exponent10(value));
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    IsInRange
  Arguments:    value,min,max:extended; swapIfNeed:boolean=true; IncludeMin:boolean=true; IncludeMax:boolean=true
  Result:       boolean
  Detailed description:
-----------------------------------------------------------------------------}
function  IsInRange(value,min,max:extended; swapIfNeed:boolean=true; IncludeMin:boolean=true; IncludeMax:boolean=true):boolean;
var temp:extended;
begin
  if swapIfNeed and (min>max) then
    begin
    temp:=max;
    max:=min;
    min:=temp;
    end;


  result:= (value>=min)and(value<=max);

  if not IncludeMin and  (value=min ) then
    result:= false;
  if not IncludeMax and  (value=max ) then
    result:= false;
end; { End of  IsInRange }


function MakeInRange(value, min, max: extended; swapIfNeed: boolean): real;
var temp:extended;
begin
  if swapIfNeed and (min>max) then
    begin
    temp:=max;
    max:=min;
    min:=temp;
    end;

  Result:=value;
  if value>max then
    Result:=max;
  if value<min then
    Result:=min;
end;

{-----------------------------------------------------------------------------
  Description:  Eine der schnellsten methoden zum Sortieren
  Procedure:    shellsort
  Arguments:    var a:array of cardinal
  Result:       None
  Detailed description:    Ich habe diese Prozedur NICHT geschrieben
-----------------------------------------------------------------------------}
procedure shellsort(var a:array of cardinal);
var  bis,i,j,k:longint;
      h:integer;
begin
  bis:=high(a);
  k:= bis shr 1;
  while k>0 do
    begin
    for i:=0 to bis-k do
      begin
      j:=i;
      while (j>=0) and(a[j]>a[j+k]) do
        begin
        h:=a[j];
        a[j]:=a[j+k];
        a[j+k]:=h;
        if j>k then dec(j,k) else j:=0;
        end;
      end;
    k:= k shr 1;
    end;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    RandomRRange
  Arguments:    min,max:real; IncludeMin:boolean=true; IncludeMax:boolean=true
  Result:       real
  Detailed description:
-----------------------------------------------------------------------------}
function RandomRRange(min,max:real; IncludeMin:boolean=true; IncludeMax:boolean=true):real;
var i:byte;
begin
  result:=min;
  i:=0;
  repeat
    inc(i);
    result:=(random*1.1)*(max-min)+min;
  until IsInRange(result,min,max,true,IncludeMin,IncludeMax) or (i>=200);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    RandomRRangeSpecial
  Arguments:    min,max:real; IncreaseProbability, DecreaseProbability:boolean; IncludeMin:boolean=true; IncludeMax:boolean=true
  Result:       real
  Detailed description:  Falls IncreaseProbability dann kommen die größeren Zahlen linear häufiger vor als die kleineren
                         Falls DecreaseProbability dann kommen die kleineren Zahlen linear häufiger vor als die größeren
                         Falls beide, dann kommen die mittlere Zahlen linear häufiger vor als die größeren und kleineren
-----------------------------------------------------------------------------}
function RandomRRangeSpecial(min,max:real; IncreaseProbability, DecreaseProbability:boolean; IncludeMin:boolean=true; IncludeMax:boolean=true):real;
begin
  if IncreaseProbability and DecreaseProbability then
    begin
    if randombool then
      result:=RandomRRangeSpecial(min,max/2,true,false,IncludeMin,IncludeMax)  //links
    else
      result:=RandomRRangeSpecial(min+(max-min)/2,max,false,true,IncludeMin,IncludeMax);    //rechts
    end
  else
    begin
    result:=RandomRRange(0,1,IncludeMin,IncludeMax);

    if IncreaseProbability and not DecreaseProbability then
      result:=sign(result)*sqrt(abs(result));

    if not IncreaseProbability and DecreaseProbability then
      result:=1- sign(result)*sqrt(abs(result));

    result:=result*(max-min)+min;
    end;

end;


procedure RInc(var value: real; const inc: real);
begin
  value:=value+inc;
end;

procedure RInc(var value1, value2: real; const inc: real);
begin
  RInc(value1,inc);
  RInc(value2,inc);
end;

procedure RInc(var value1, value2, value3: real; const inc: real);
begin
  RInc(value1,inc);
  RInc(value2,inc);
  RInc(value3,inc);
end;

procedure RInc(var value1, value2, value3, value4: real; const inc: real);
begin
  RInc(value1, value2, inc);
  RInc(value3, value4, inc);
end;



{-----------------------------------------------------------------------------
  Description:  Prüft ob es ein Schaltjahr ist
  Procedure:    schaltjahr
  Arguments:    year:longint
  Result:       boolean
  Detailed description:
-----------------------------------------------------------------------------}
function schaltjahr(year:longint):boolean;
begin
  schaltjahr:= (year mod 4=0)and( (year mod 400=0)or(year mod 100 <>0));
end;

{-----------------------------------------------------------------------------
  Description:  schauen wie viele Tage der monat hat
  Procedure:    monatslaenge
  Arguments:    mon:byte; year:integer
  Result:       integer
  Detailed description:
-----------------------------------------------------------------------------}
function monatslaenge(mon:byte; year:integer):integer;
begin
  case mon of
    2: if schaltjahr(year) then monatslaenge:=29  else monatslaenge:=28;
    4,6,9,11 : monatslaenge:=30;
  else
    monatslaenge:=31;
  end;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    gregtojul
  Arguments:    day,mon,year:longint
  Result:       real
  Detailed description:
-----------------------------------------------------------------------------}
function gregtojul(time:real; day,mon,year:integer):extended;
var y,a,b:real;
begin
  y:=year+(mon-2.85)/12;
  a:=trunc(367*y)  -1.75 *trunc(y)+day;
  b:=trunc(a) -0.75 *trunc(y/100);

  result:= trunc(b) +  1721115;

  result:=result+time/24-0.5;  //umrechnung von stunden auf juljaische tagesbruchteile ; tagesbeginn um 12:00 Uhr
end;
{-----------------------------------------------------------------------------
  Arguments:    hour,min,sec,day,mon,year:integer
  Result:       real
-----------------------------------------------------------------------------}
function gregtojul(hour,min,sec,day,mon,year:integer):extended;
begin
  result:=gregtojul(hour+min/60+sec/3600,day,mon,year);
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    jultogreg
  Arguments:    var day,mon,year:INTEGER; const juldatum:real
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure jultogreg(var day,mon,year:integer; const juldatum:real);
const jd0=1721426;
var n400,r400,n100,r100,n4,r4,n1,lt,jd:integer;
    i:integer;
begin
  jd:=trunc(juldatum);

  N400 :=(JD - JD0) div 146097;
  R400 := (JD - JD0)mod 146097;
  N100 := R400 div 36524 ;
  R100 := R400 mod 36524;
  if (N100=4) then
  begin
    N100:=3;
    R100:=36524;
  end;
  N4 := R100 div 1461 ;
  R4 := R100 mod 1461 ;
  N1 := R4 div 365 ;
  LT := R4 mod 365 ;
  if (N1=4) then
  begin
    N1:=3;
    LT:=365;
  end;
  year := 400*N400 + 100*N100 + 4*N4 + N1  +1;
  day:=LT+1;

  mon:=1;  {das muss sein da sonst mon manchmal alt}
  for i:= 1 to 12 do
  begin
    if day<=monatslaenge(i,year) then break;
    day:=day-monatslaenge(i,year);
    mon:=i+1;
  end;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    ChooseNearest
  Arguments:    zahl:extended; ar:TRealArray
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function ChooseNearest(zahl:extended; ar:TRealArray):extended;
var dist,resdist:extended;
    i,resi:integer;
begin
  result:=zahl;
  if not assigned(ar) or (ar.count=0) then
    exit;

  resdist:=max(ar[0],zahl)-min(ar[0],zahl);
  resi:=0;
  for I := 0 to ar.count-1 do
    begin
    dist:=max(ar[i],zahl)-min(ar[i],zahl);
    if dist<resdist then
      begin
      resdist:=dist;
      resi:=i;
      end;
    end;
  result:=ar[resi];
end;

function ReduceRangeFromCenterGetMin(Min, Max, ReduceFactor: real;
  CenterIsMidlle: boolean; Center: real): real;
begin
  if CenterIsMidlle then
    Center:=Min+(Max-Min)/2;
    
  Result:=Center-(Center-Min)*ReduceFactor;
end;

function ReduceRangeFromCenterGetMax(Min, Max, ReduceFactor: real;
  CenterIsMidlle: boolean; Center: real): real;
begin
  if CenterIsMidlle then
    Center:=Min+(Max-Min)/2;

  Result:=Center+ (Max-Center)*ReduceFactor;
end;


{-----------------------------------------------------------------------------
  Description:  Schreibt in das Stringgrid  und fügt immer eine neue Zeile hinzu
  Procedure:    writeGrid
  Arguments:    const zahl:string=''; faktor:string=''; Fermat:string=''; Euler:string=''
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure writeGrid(const zahl:string=''; faktor:string=''; Fermat:string=''; Euler:string='');
begin
{  form1.StringGrid1.RowCount:=form1.StringGrid1.RowCount+1;
  form1.StringGrid1.Cells[0,form1.StringGrid1.RowCount-1]:=zahl;
  form1.StringGrid1.Cells[1,form1.StringGrid1.RowCount-1]:=faktor;
  form1.StringGrid1.Cells[2,form1.StringGrid1.RowCount-1]:=Fermat;
  form1.StringGrid1.Cells[3,form1.StringGrid1.RowCount-1]:=Euler;
  form1.StringGrid1.Row:=form1.StringGrid1.RowCount-1;
  form1.StringGrid1.Col:=0;}
end;


{-----------------------------------------------------------------------------
  Description:  Schreibt in das Stringgrid und kann auch Zeilen überschreiben
  Procedure:    writeGrid
  Arguments:    zeile:cardinal; const zahl:string=''; faktor:string=''; Fermat:string=''; Euler:string=''
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure writeGrid(zeile:cardinal; const  zahl:string=''; faktor:string=''; Fermat:string=''; Euler:string='');
begin
{  if zeile>=form1.StringGrid1.RowCount then writeGrid(zahl,faktor,fermat,euler)
  else
    begin
    form1.StringGrid1.Cells[0,zeile]:=zahl;
    form1.StringGrid1.Cells[1,zeile]:=faktor;
    form1.StringGrid1.Cells[2,zeile]:=Fermat;
    form1.StringGrid1.Cells[3,zeile]:=Euler;
    if zeile=0 then form1.StringGrid1.Row:=1;
    form1.StringGrid1.Col:=0;
    end;}
end;




{-----------------------------------------------------------------------------
  Arguments:    zahl,m:integer
-----------------------------------------------------------------------------}
function teilbar(zahl,m:integer):boolean;
begin
  result:= zahl mod m =0;
end;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    modulo
  Arguments:    zahl,red:extended; ForcePositiv:boolean=false
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function modulo(zahl,red:extended; ForcePositiv:boolean=false):extended;
begin
  if abs(zahl)>=red then
    result:=sign(zahl)*(abs(zahl)-trunc(abs(zahl)/red)*red)
  else
    result:=zahl;

  if ForcePositiv and (result<0)then
    result:=result+red;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    radtoBog
  Arguments:    Rad:extended
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function radtoBog(Rad:extended):extended;
begin
  result:=Rad/180*pi;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    BogtoRad
  Arguments:    Bog:extended
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function BogtoRad(Bog:extended):extended;
begin
  result:=Bog/pi*180;
end;




{==============================================================================
  Procedure:    AZoom
  Belongs to:   None
  Result:       None
  Parameters:
                  Min : extended  =
                  Max : extended  =
                  ZoomCenter : extended  =
                  ZoomPercentage : extended  =
                  NewMin : extended  =
                  NewMax : extended  =

  Description:
==============================================================================}
procedure AZoom(Min,Max,ZoomCenter,ZoomPercentage:real; var NewMin,NewMax:real);
begin
  if ZoomPercentage>=0.95 then
    ZoomPercentage:=0.95;

  ZoomPercentage:=1-ZoomPercentage;

  NewMin:=ZoomCenter-  (ZoomCenter-Min) *ZoomPercentage;
  NewMax:=ZoomCenter+  (Max-ZoomCenter) *ZoomPercentage;
end;






{-----------------------------------------------------------------------------
  Description:  Zerteilt einen String; Zerteilung erfolgt anhand von
                Teilstrings, die nicht mit ausgegeben werden
  Author:       Alexander Roth
  Procedure:    DivideString
  Arguments:    s:string; const Separator, DivideList:TStrings
-----------------------------------------------------------------------------}
procedure DivideString(s:string; const Separator, DivideList:TStrings);

    function FindNext:TPoint; // sucht den als ersten vorkommenden Seperator
    var i:integer;
        tempstelle:integer;
        schongefunden:boolean; // führe ich ein, damit er auf jeden Fall
                               // die 1. Fundstelle aufschreibt
    begin
      schongefunden:=false;
      result.y:=0;
      result.x:=0;
      for i:=0 to Separator.Count-1 do
        begin
        tempstelle:=pos(Separator.Strings[i], s);
        //schreibt die als nächstes kommende Trennzeichenstelle auf
        if     (tempstelle > 0)
           and ((tempstelle < result.y) or not schongefunden) then
           // es darf niemals sein dass er eine stelle
           // aufschreibt die nicht da ist
          begin
          schongefunden:=true;
          result.y:=tempstelle;
          result.x:=i;
          end;
        end;
    end;


var tempS:string;
    find:TPoint;  // y = Fundstelle, x = Index des Separators;
                  // hier habe ich keinen eigenen Typ gewählt,
                  // der Übersichtlicher wäre, um die Implementierung des
                  // Codes einfacher zu gestalten
begin
  if assigned(Separator) and assigned(DivideList) then
    begin
    if (s <> '') and (Separator.Count > 0) then // falls man irgendwelche
                                                // schrottige Angaben gemacht hat
                                                // wird man hier rausgeworfen
      begin
      find:=FindNext;

      while (find.y > 0) and (length(s) > 0) do
        begin
        tempS:=copy(s, 1, find.Y-1);

        if length(tempS) > 0 then
          DivideList.Append(tempS);
        delete(s, 1, find.y-1 + length(Separator[find.x]));

        find:=FindNext;
        end;
      if length(s) > 0 then   // das ist dafür das auch die letzte resttext Übernommen wird
        DivideList.Append(s);
      end;
    end;
end;   { End of  FindNext }


{procedure DemoDivideList;
const s = ',;,hallo|;guda,ggt;ds|gh,d;,;;;,f;,g,';
var StrList, NewList:TStringlist;
    i:integer;
begin
  StrList:=TStringlist.Create;
  NewList:=TStringlist.Create;
  try
    StrList.Append(',');
    StrList.Append(';');
    StrList.Append('|');

    DivideString(s, StrList, NewList);
    for i :=0 to NewList.Count-1 do
      ShowMessage(
        NewList.Strings[i]+#13+
        inttostr(length(NewList.Strings[i]))
      );
  finally
    NewList.free;
    StrList.free;
  end;
end;}






function AddLineEndingAfterChar(s: string): string;
var i:integer;
begin
  Result:='';
  for i := 1 to length(s) do
    Result:=result+LineEnding+s[i];
end;


function KorrectUmlaut(s: string): char;
begin
  if s='ö' then         Result:=chr(246)
  else if s='Ö' then    Result:=chr(214)
  else if s='ä' then    Result:=chr(228)
  else if s='Ä' then    Result:=chr(196)
  else if s='ü' then    Result:=chr(252)
  else if s='Ü' then    Result:=chr(220)
  else if s='ß' then    Result:=chr(223)
  else if s='°' then    Result:=chr(176);
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    randomColor
  Arguments:    None
  Result:       Tcolor
  Detailed description:
-----------------------------------------------------------------------------}
function randomColor:Tcolor;
begin
  result:=graphics.RGBToColor(random(256),random(256),random(256));
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    ColtoStr
  Arguments:    color:Tcolor
  Result:       string
  Detailed description:
-----------------------------------------------------------------------------}
function ColtoStr(color:Tcolor):string;
var r,g,b:byte;
begin
  ColorValues(color,r,g,b);
  result:='R ='+inttostr(R)+'  G ='+inttostr(G)+'  B ='+inttostr(B);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    ColorValues
  Arguments:    const color: Tcolor; var R,G,B:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure ColorValues(const color: Tcolor; var R,G,B:byte);
begin
  // zerlegen von Farbe
  R := Graphics.Red(color); // ROT
  G := Graphics.Green(color); // GRÜN
  B := Graphics.Blue(color); // BLAU
end;

{==============================================================================
  Procedure:    IntensityColor
  Belongs to:   None
  Result:       TColor
  Parameters:
                  col : TColor  =
                  Intensity : real  =

  Description:
==============================================================================}
function  IntensityColor(col:TColor; Intensity:real):TColor;
var r1, g1, b1: integer;
begin
  Intensity:=abs(Intensity);

  r1 := round(Graphics.Red(col)*Intensity);
  g1 := round(Graphics.Green(col)*Intensity);
  b1 := round(Graphics.Blue(col)*Intensity);

  r1:=min(r1, 255);
  g1:=min(g1 , 255);
  b1:=min(b1 , 255);

  result := RGBToColor(r1,g1,b1);
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    AddColors
  Arguments:    const color1,color2: tcolor
  Result:       TColor
  Detailed description:
-----------------------------------------------------------------------------}
function AddColors(color1,color2: tcolor): TColor;
var r1, g1, b1,
    r2, g2, b2: byte;
    r3, g3, b3: integer;
begin
  // falls es sich um eine Windows-Standartfarbe wie z.b clBtnface handelt:
  color1 := colortorgb(color1);
  color2 := colortorgb(color2);

  ColorValues(color1,R1,G1,B1);
  ColorValues(color2,R2,G2,B2);

  // addieren
  r3 := r1+r2;
  g3 := g1+g2;
  b3 := b1+b2;
  korrigiere(r3,0,255);
  korrigiere(g3,0,255);
  korrigiere(b3,0,255);

  // farbwerte zusammensetzen
  result := RGBToColor(r3,g3,b3);
end;


{==============================================================================
  Procedure:    AddColors
  Belongs to:   None
  Result:       TColor
  Parameters:
                  color1 : tcolor  =
                  color2 : tcolor  =
                  percentage1 : real  =
                  percentage2 : real  =

  Description:
==============================================================================}
function AddColors(color1,color2: tcolor; percentage1,percentage2:real): TColor;
begin
  result:=AddColors(IntensityColor(color1,percentage1),IntensityColor(color2,percentage2));
end;


{-----------------------------------------------------------------------------
  Description:  Kombiniert die Farben in den Bildern nach der Additiven Arbsynthese
  Procedure:    MergeBmp
  Arguments:    bmp1,bmp2:TBitmap
  Result:       TBitmap
  Detailed description:
-----------------------------------------------------------------------------}
procedure MergeBmp(var merged:TBitmap;  bmp1,bmp2:TBitmap);
var i,j:integer;
begin
  merged.Height:=bmp1.Height;
  merged.width:=bmp1.width;
  merged.PixelFormat:=bmp1.PixelFormat;

  for i := 0 to bmp1.Height - 1 do
    for j := 0 to bmp1.Width - 1 do
      merged.Canvas.Pixels[j,i]:=AddColors(bmp1.Canvas.Pixels[j,i],bmp2.Canvas.Pixels[j,i]);
end;




{-----------------------------------------------------------------------------
  Description:  Diese Tabelle benutze ich um die Farben umzurechnen
  Procedure:    WavelengthToRGB
  Arguments:    const lambda:real
  Result:       Tcolor
  Detailed description:  Diese Tabelle benutze ich um die Farben umzurechnen
-----------------------------------------------------------------------------}
function  WavelengthToRGB(const lambda:real):Tcolor;
begin
  result:=0;

  if (lambda>= 380E-09) and (lambda< 385E-09) then    result:=6357089;
  if (lambda>= 385E-09) and (lambda< 390E-09) then    result:=7798895;
  if (lambda>= 390E-09) and (lambda< 395E-09) then    result:=9240697;
  if (lambda>= 395E-09) and (lambda< 400E-09) then    result:=10551424;
  if (lambda>= 400E-09) and (lambda< 405E-09) then    result:=11862147;
  if (lambda>= 405E-09) and (lambda< 410E-09) then    result:=13107330;
  if (lambda>= 410E-09) and (lambda< 415E-09) then    result:=14352510;
  if (lambda>= 415E-09) and (lambda< 420E-09) then    result:=15532150;
  if (lambda>= 420E-09) and (lambda< 425E-09) then    result:=16711786;
  if (lambda>= 425E-09) and (lambda< 430E-09) then    result:=16711764;
  if (lambda>= 430E-09) and (lambda< 435E-09) then    result:=16711741;
  if (lambda>= 435E-09) and (lambda< 440E-09) then    result:=16711715;
  if (lambda>= 440E-09) and (lambda< 445E-09) then    result:=16711680;
  if (lambda>= 445E-09) and (lambda< 450E-09) then    result:=16721920;
  if (lambda>= 450E-09) and (lambda< 455E-09) then    result:=16729600;
  if (lambda>= 455E-09) and (lambda< 460E-09) then    result:=16736512;
  if (lambda>= 460E-09) and (lambda< 465E-09) then    result:=16743168;
  if (lambda>= 465E-09) and (lambda< 470E-09) then    result:=16749056;
  if (lambda>= 470E-09) and (lambda< 475E-09) then    result:=16754944;
  if (lambda>= 475E-09) and (lambda< 480E-09) then    result:=16760832;
  if (lambda>= 480E-09) and (lambda< 485E-09) then    result:=16766208;
  if (lambda>= 485E-09) and (lambda< 490E-09) then    result:=16771584;
  if (lambda>= 490E-09) and (lambda< 495E-09) then    result:=16776960;
  if (lambda>= 495E-09) and (lambda< 500E-09) then    result:=13369088;
  if (lambda>= 500E-09) and (lambda< 505E-09) then    result:=9633536;
  if (lambda>= 505E-09) and (lambda< 510E-09) then    result:=5570304;
  if (lambda>= 510E-09) and (lambda< 515E-09) then    result:=65280;
  if (lambda>= 515E-09) and (lambda< 520E-09) then    result:=65311;
  if (lambda>= 520E-09) and (lambda< 525E-09) then    result:=65334;
  if (lambda>= 525E-09) and (lambda< 530E-09) then    result:=65354;
  if (lambda>= 530E-09) and (lambda< 535E-09) then    result:=65374;
  if (lambda>= 535E-09) and (lambda< 540E-09) then    result:=65392;
  if (lambda>= 540E-09) and (lambda< 545E-09) then    result:=65409;
  if (lambda>= 545E-09) and (lambda< 550E-09) then    result:=65426;
  if (lambda>= 550E-09) and (lambda< 555E-09) then    result:=65443;
  if (lambda>= 555E-09) and (lambda< 560E-09) then    result:=65459;
  if (lambda>= 560E-09) and (lambda< 565E-09) then    result:=65475;
  if (lambda>= 565E-09) and (lambda< 570E-09) then    result:=65490;
  if (lambda>= 570E-09) and (lambda< 575E-09) then    result:=65505;
  if (lambda>= 575E-09) and (lambda< 580E-09) then    result:=65520;
  if (lambda>= 580E-09) and (lambda< 585E-09) then    result:=65535;
  if (lambda>= 585E-09) and (lambda< 590E-09) then    result:=61439;
  if (lambda>= 590E-09) and (lambda< 595E-09) then    result:=57343;
  if (lambda>= 595E-09) and (lambda< 600E-09) then    result:=53247;
  if (lambda>= 600E-09) and (lambda< 605E-09) then    result:=48895;
  if (lambda>= 605E-09) and (lambda< 610E-09) then    result:=44543;
  if (lambda>= 610E-09) and (lambda< 615E-09) then    result:=39935;
  if (lambda>= 615E-09) and (lambda< 620E-09) then    result:=35327;
  if (lambda>= 620E-09) and (lambda< 625E-09) then    result:=30719;
  if (lambda>= 625E-09) and (lambda< 630E-09) then    result:=25599;
  if (lambda>= 630E-09) and (lambda< 635E-09) then    result:=20479;
  if (lambda>= 635E-09) and (lambda< 640E-09) then    result:=14847;
  if (lambda>= 640E-09) and (lambda< 645E-09) then    result:=8703;
  if (lambda>= 645E-09) and (lambda< 650E-09) then    result:=255;
  if (lambda>= 650E-09) and (lambda< 655E-09) then    result:=255;
  if (lambda>= 655E-09) and (lambda< 660E-09) then    result:=255;
  if (lambda>= 660E-09) and (lambda< 665E-09) then    result:=255;
  if (lambda>= 665E-09) and (lambda< 670E-09) then    result:=255;
  if (lambda>= 670E-09) and (lambda< 675E-09) then    result:=255;
  if (lambda>= 675E-09) and (lambda< 680E-09) then    result:=255;
  if (lambda>= 680E-09) and (lambda< 685E-09) then    result:=255;
  if (lambda>= 685E-09) and (lambda< 690E-09) then    result:=255;
  if (lambda>= 690E-09) and (lambda< 695E-09) then    result:=255;
  if (lambda>= 695E-09) and (lambda< 700E-09) then    result:=255;
  if (lambda>= 700E-09) and (lambda< 705E-09) then    result:=255;
  if (lambda>= 705E-09) and (lambda< 710E-09) then    result:=246;
  if (lambda>= 710E-09) and (lambda< 715E-09) then    result:=237;
  if (lambda>= 715E-09) and (lambda< 720E-09) then    result:=228;
  if (lambda>= 720E-09) and (lambda< 725E-09) then    result:=219;
  if (lambda>= 725E-09) and (lambda< 730E-09) then    result:=209;
  if (lambda>= 730E-09) and (lambda< 735E-09) then    result:=200;
  if (lambda>= 735E-09) and (lambda< 740E-09) then    result:=190;
  if (lambda>= 740E-09) and (lambda< 745E-09) then    result:=181;
  if (lambda>= 745E-09) and (lambda< 750E-09) then    result:=171;
  if (lambda>= 750E-09) and (lambda< 755E-09) then    result:=161;
  if (lambda>= 755E-09) and (lambda< 760E-09) then    result:=151;
  if (lambda>= 760E-09) and (lambda< 765E-09) then    result:=141;
  if (lambda>= 765E-09) and (lambda< 770E-09) then    result:=130;
  if (lambda>= 770E-09) and (lambda< 775E-09) then    result:=119;
  if (lambda>= 775E-09) and (lambda< 780E-09) then    result:=109;
end;


function ColortoHTMLColor(Color:TColor):string;
begin
  result:=IntToHex(Red(Color),2)+IntToHex(Green(Color),2)+IntToHex(Blue(Color),2);
end;



function HTMLColorString(s:string; color:TColor):string;
begin
  result:='<font color="'+ColorToString(color)+'">'+s+'</font>';
end;


{==============================================================================
  Procedure:    GegenFarbe	
  Belongs to:   None
  Result:       TColor
  Parameters:   
                  color : TColor  =   
                    
  Description:
==============================================================================}
function GegenFarbe(color:TColor):TColor;
begin
  result := ColorToRGB(color) xor $FFFFFF;
end;


function OverRect(pos:TPoint; rec:Trect; TopToBottom:boolean=true):boolean;
begin
  result:=OverRect(pos.x,pos.y,rec,TopToBottom);
end;

function OverRect(pos:TR3Vec; rec:Trect; TopToBottom:boolean=true):boolean;
begin
  result:=OverRect(pos.x,pos.y,rec,TopToBottom);
end;

function OverRect(x,y:real; rec:Trect; TopToBottom:boolean=true):boolean;
begin
  if TopToBottom then
    result:=  (X>=rec.Left)and(X<=rec.Right)
              and(Y>=rec.Top)and(Y<=rec.Bottom)
  else
    result:=  (X>=rec.Left)and(X<=rec.Right)
              and(Y<=rec.Top)and(Y>=rec.Bottom);
end;




{==============================================================================
  Procedure:    PosInRect
  Belongs to:   None
  Result:       TR3vec
  Parameters:   
                  Ground : Trect  =    Das ClientRect meistens
                  Big : TR3vec  =   Wie groß ist das was ausgerichtet werden soll
                  Font : TR3vec  =   Welche Ausmaße hat ein Buchstabe?
                  BigEdge : TEdges  =  Welche Ecke soll zurückgegeebn werden
                  LetterEdge : TEdges  =  Welche Ecke des Buchstabens soll zurückgegeben werden
                  Position : TR3vec  =  x und y sind das Teilungsverhältniss den den Strecken x und y
                                        x und y sind somit fast immer im Intervall von [0;1]

  Description:
==============================================================================}
function PosInRect(Ground:Trect; Big,Font:TR3vec; BigEdge,LetterEdge:TEdges; Position:TR3vec):TR3vec;


  procedure Umrechnen(var res:TR3vec; const ecke:TEdges; Size:TR3vec);
  begin
    //  TEdges=(TopLeft,BottomRight,TopRight,BottomLeft);
    //BottomLeft bekommt er rein

    if ecke=TopRight then
      begin
      res.x:=res.x+size.x;
      res.y:=res.y+size.y;
      end;

    if ecke=BottomRight then
      res.x:=res.x+size.x;

    if ecke=TopLeft then
      res.y:=res.y+size.y;
  end;

begin
  //er bekommt die linke untere Ecke
  result.x:=Ground.Left+  (Ground.Right-Ground.Left-Big.x)*Position.x;
  result.y:=Ground.bottom+  (Ground.top-Ground.bottom-Big.y)*Position.y;

  Umrechnen(result,BigEdge,R3Vec(Big.x-Font.x, Big.y-Font.y,0));
  Umrechnen(result,LetterEdge,Font);
end;   { End of  PosInRect }
{==============================================================================
  Result:       TR3Vec
  Parameters:   
                  Ground : Trect  =    Das ClientRect meistens
                  Big : TR3vec  =   Wie groß ist das was ausgerichtet werden soll
                  Font : TR3vec  =   Welche Ausmaße hat ein Buchstabe?
                  BigEdge : TEdges  =  Welche Ecke soll zurückgegeebn werden
                  LetterEdge : TEdges  =  Welche Ecke des Buchstabens soll zurückgegeben werden
                  Position : TR3vec  =  x und y sind das Teilungsverhältniss den den Strecken x und y
                                        x und y sind somit fast immer im Intervall von [0;1]
                  depth : real  =
==============================================================================}
function PosInRect(Ground:Trect; Big,Font:TR3vec; BigEdge,LetterEdge:TEdges; Position:TR3vec; depth:real):TR3Vec;
var temp:TR3vec;
begin
  temp:=PosInRect(Ground, Big,Font, BigEdge,LetterEdge, Position);
  result:=R3Vec(temp.x,temp.y,depth);
end;
{==============================================================================
  Result:       TR3vec
  Parameters:   
                  Ground : Trect  =   
                  AnzLines : integer  =   
                  LineDistance : integer  =   
                  AnzLetters : integer  =   
                  FontSize : integer  =   
                  BigEdge : TEdges  =
                  LetterEdge : TEdges  =   
                  Position : TR3vec  =
==============================================================================}
function PosInRect(Ground:Trect; AnzLines,LineDistance,AnzLetters,FontSize:integer; BigEdge,LetterEdge:TEdges; Position:TR3vec):TR3vec;
begin
  LineDistance:=LineDistance-10;
  FontSize:=FontSize-15;
  result:=PosInRect(Ground, R3Vec(AnzLetters*(FontSize+7) ,
                                            AnzLines*FontSize +(AnzLines-1)*LineDistance, 0)  ,
                            R3Vec(FontSize, FontSize+10+LineDistance div 2, 0) ,
                  BigEdge,LetterEdge, Position);
end;


{==============================================================================
  Procedure:    PosInRect
  Belongs to:   None
  Result:       TR3vec
  Parameters:
                  Ground : Trect  =    Das ClientRect meistens
                  Big : TR3vec  =   Wie groß ist das was ausgerichtet werden soll
                  Font : TR3vec  =   Welche Ausmaße hat ein Buchstabe?
                  BigEdge : TEdges  =  Welche Ecke soll zurückgegeebn werden
                  LetterEdge : TEdges  =  Welche Ecke des Buchstabens soll zurückgegeben werden
                  Position : TBoolRect  =  Wo soll das ausgerichtet werden (oben, unten, mitte,..)

  Description:   Der Koordinaten-Ursprung befindet sich links unten!!! Wichtig!!!
==============================================================================}
function PosInRect(Ground:Trect; Big,Font:TR3vec; BigEdge,LetterEdge:TEdges; Position:TBoolRect):TR3vec;
begin
  if boolGleich(Position.Left, Position.right) then
    result.x:=PosInRect(Ground,Big,Font,BigEdge,LetterEdge,R3Vec(0.5,0.5 ,0)).x
  else
    begin
    if Position.left then
      result.x:=PosInRect(Ground,Big,Font,BigEdge,LetterEdge,R3Vec(0,0.5 ,0)).x;
    if Position.right then
      result.x:=PosInRect(Ground,Big,Font,BigEdge,LetterEdge,R3Vec(1,0.5 ,0)).x;
    end;


  if boolGleich(Position.bottom, Position.top) then
    result.y:=PosInRect(Ground,Big,Font,BigEdge,LetterEdge,R3Vec(0.5,0.5, 0)).y
  else
    begin
    if Position.bottom then
      result.y:=PosInRect(Ground,Big,Font,BigEdge,LetterEdge,R3Vec(0.5,0,0)).y;
    if Position.top then
      result.y:=PosInRect(Ground,Big,Font,BigEdge,LetterEdge,R3Vec(0.5,1,0)).y;
    end;
end;
{==============================================================================
  Result:       TR3Vec
  Parameters:   
                  Ground : Trect  =    Das ClientRect meistens
                  Big : TR3vec  =   Wie groß ist das was ausgerichtet werden soll
                  Font : TR3vec  =   Welche Ausmaße hat ein Buchstabe?
                  BigEdge : TEdges  =  Welche Ecke soll zurückgegeebn werden
                  LetterEdge : TEdges  =  Welche Ecke des Buchstabens soll zurückgegeben werden
                  Position : TBoolRect  =  Wo soll das ausgerichtet werden (oben, unten, mitte,..)
                  depth : real  =
==============================================================================}
function PosInRect(Ground:Trect; Big,Font:TR3vec; BigEdge,LetterEdge:TEdges; Position:TBoolRect; depth:real):TR3Vec;
var temp:TR3vec;
begin
  temp:=PosInRect(Ground, Big,Font, BigEdge,LetterEdge, Position);
  result:=R3Vec(temp.x,temp.y,depth);
end;


function KoorKind2Str(koorKind: TKoorKind): string;
begin
  case koorKind of
    kkx:            Result:='kkx';
    kkLS:           Result:='kkLS';
    kkz:            Result:='kkz';
    kkImage:        Result:='kkImage';
    kkOGLx:         Result:='kkOGLx';
    kkOGLy:         Result:='kkOGLy';
    kkOGLz:         Result:='kkOGLz';
    kkOGLRealityx:  Result:='kkOGLRealityx';
    kkOGLRealityy:  Result:='kkOGLRealityy';
    kkOGLRealityz : Result:='kkOGLRealityz';
    kkPixelx:       Result:='kkPixelx';
    kkPixely:       Result:='kkPixely';
    kkPixelz:       Result:='kkPixelz';
  end;
end;

function MinKoor(koor1, koor2: TKoor1): TKoor1;
begin
  result:=koor1;
  if koor1.v>koor2.v then
    Result:=koor2;
end;

function MaxKoor(koor1, koor2: TKoor1): TKoor1;
begin
  result:=koor1;
  if koor1.v<koor2.v then
    Result:=koor2;
end;


{==============================================================================
  Procedure:    AbsolutePosition	
  Belongs to:   None
  Result:       TPoint
  Parameters:   
                  comp : TControl  =   
                    
  Description:  
==============================================================================}
function AbsolutePosition(comp:TControl):TPoint;
var cou:integer;
begin
  cou:=0;
  Result.X:=0;
  Result.y:=0;
  while not (comp is TForm) do
    begin
    inc(cou);
    if cou>1000 then exit;
    Result.X:=Result.X+comp.Left;
    Result.y:=Result.y+comp.Top;
    if comp is TGroupBox then
      Result.y:=Result.y+17;
    comp:=comp.Parent;
    end;
end;




end.
