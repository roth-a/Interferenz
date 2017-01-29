{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie können es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    veröffentlicht, weitergeben und/oder modifizieren, gemäß Version 2 der Lizenz.
 Description:
-----------------------------------------------------------------------------}


unit UChart;

{$mode objfpc}{$H+}

interface


{

Die Achsen sind auf z= 0
Die folgenden Charts sind auf z= nChart


}

uses
  Classes,  SysUtils,uanderes,lcltype, graphics, math, Messages,
  LResources, Forms, Controls, Dialogs, Interfaces,
  StdCtrls,  ExtCtrls, gl,glu, nxGL, nxTypes,  utxt,UVector;
  
type
  TAxisKind=(YAxisKind,XAxisKind);
  TAxisPosition = (apMin, apMax, ap0);
  TTickPosition = (tpMin, tpMax, tpCenter);
  TLabelPosition = (lpMin,lpMax,lp0,lpCenter);

  TTitlePosition=record
    MainPosition,
    SidePosition:TLabelPosition;
    AutoSidePosition:boolean;
  end;
  


  { TOGLRect }

  TOGLRect=class
  private
  public
    r:TR2RectSimple;
    Visible:boolean;
    Filled:boolean;
    BrushColor:Tcolor;
    BrushAlpha:real;
    Pen:TPen;
    PenAlpha:real;

    procedure Draw(Depth:TKoor1); overload;
    procedure Draw(Position:TR2RectSimple; Depth:TKoor1); overload;

    constructor Create;
    destructor Destroy; override;
  end;

  
  { TOGL3DNSlit }

  TOGL3DNSlit=class
  public
    Pos, SpaceToBorder, Sizes:TKoor3; // in oglreality
    beta, theta:real;
    ColorGrid, Colorbeta, Colortheta:TColor;
    AutoVisible,
    Visible:boolean;
  
    procedure DrawOGL;

    constructor Create(aPos, aSpaceToBorder, aSizes:TKoor3);
  end;


  { TOGlLabel }

  TOGlLabel = class
  private
    DividedStrings:TStringList;

    FText: string;
    procedure setFText(const AValue: string);

    function TextLenght:real;
    function TextHeight:real;
  public
    pos:TKoor3;
    Enabled:boolean;
    Color:TColor;
    PosXIs,
    PosYIs:TAnchorKind;
    procedure Draw; virtual;

    constructor Create; virtual;
    destructor Destroy; override;

    property Text:string read FText write setFText;
  end;


  { TOGlLabelBackground }

  TOGlLabelBackground = class(TOGlLabel)
  private
  public
    BackgroundColor:TColor;
    BackgroundAlpha:real;

    procedure Draw; override;

    constructor Create; override;
    destructor Destroy; override;
  end;
  

  { TAxis }

  TAxis = class
  private
    Depth:TKoor1;
    FAxisPosition:TAxisPosition;

    function ReadVisibleRect:TKoor1Range;

    procedure writeAxisPosition(value:TAxisPosition);
    procedure WriteVisibleRect(Value:TKoor1Range);
    
    function PrettyIncrement(aMinValue, aMaxValue: real; aCountTicks:integer): real;
    procedure DrawArrows(Pos1,Pos2:TKoor3;  bold:real=1; ArrowSize:real=0.05; BeginningPeak:boolean=false; EndingPeak:boolean=true);
    procedure DrawTicksBasic(Pos1, Pos2: TKoor3; aPos1Value, aPos2Value, aLengthTick:real;  acolor:Tcolor;  ShowFirstValue:boolean; PrettyIncre:real; DeepRecursion:integer=1);
    procedure DrawTicks(Pos1, Pos2: TKoor3; aPos1Value, aPos2Value, aLengthTick:real; aCountTicks:integer;   acolor:Tcolor;  CenterTicks:boolean=true);
    procedure DrawTitle(Pos1,Pos2:TKoor3);
  public
    CountBigTicks:integer;
    CountTicks:integer;// between bigticks

    Koor,
    VisibleKoor,
    DefaultKoor:TRealRange;

    LengthAxis,
    LengthBigTick,     // in %
    LengthTick:real;   // in %
    AxisKind:TAxisKind;
    KoorKind:TKoorKind;
    Visible:boolean;
    Title:TOGlLabelBackground;
    MainDescription,
    DimensionDescription,
    Dimension:string;
    
    TickPosition:TTickPosition;
    LabelPosition:TLabelPosition;
    TitlePosition:TTitlePosition;
    TempAxisPosition:TAxisPosition;
    AxisAlwaysVisible:boolean;
    LabelSpace:TKoor1;  // in koor


    BigTickPositions:TRealArray;

    ColorAxis,
    ColorBigTicks,
    ColorTicks,
    ColorMainGrid:TColor;
    ShowMainGrid:boolean;

    function KoorSize:real;

    property AxisPosition:TAxisPosition read FAxisPosition write writeAxisPosition;
    property VisibleRect:TKoor1Range read ReadVisibleRect write WriteVisibleRect;   //in koor

    procedure ResetKoor;

    procedure Draw(Pos1,Pos2:TKoor3; bold:real=1; ArrowSize:real=0.02);   // Pos ist immer auf der virtuellen Koor Koordinaten
    procedure DrawMainGrid(Pos1,Pos2:TKoor3; OtherAxis:TAxis; bold:real=1);

    constructor Create(aAxisKind:TAxisKind);
    destructor Destroy; override;
  end;


  
  TTransChartFunc = function(akoor:TKoor1):TKoor1  of object;
  TTransChartExtendedFunc = function(akoor:TKoor1; ReturnKoorKind:TKoorKind):TKoor1  of object;
  TZoomRectEvent = Procedure(Sender: TObject; Shift: TShiftState; rect:TRect) of object;
  TZoomEvent = Procedure(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Factor:real; Axis:TKoorSet) of object;


  { TOGlBox }

  TOGlBox = class(TPanel)
  private
    FQuotientLS2Image: real;
  	//gContextID: tsContextID;
    OGLRectZoom:TOGLRect;
    DepthOverlay:TKoor1;
    StoredIdleDraw:boolean;

    FShowCross:boolean;
    OGLReality:TR2Rect;
    FIsPaning,
    FIsZoomingRect:boolean;
    FZoomFactor:real; // in facator

    FOnBeginPan:TMouseEvent;
    FOnEndPan:TMouseEvent;
    FOnPan:TMouseMoveEvent;
    FOnZoom:TZoomEvent;
    FOnUnZoom:TZoomEvent;
    FOnZoomRect:TZoomRectEvent;
    FOnBeginZoomRect:TZoomRectEvent;
    FOnEndZoomRect:TZoomRectEvent;
    FOnResetZoom:TZoomEvent;

    FOnKoorChange:TNotifyEvent;
    FOnXAxisPosChange:TNotifyEvent;
    FOnImageAxisPosChange:TNotifyEvent;
    FOnLSAxisPosChange:TNotifyEvent;

    FKeyPan:TShiftState;
    FKeyZoomUnZoomXAxis:TShiftState;
    FKeyZoomUnZoomLSAxis:TShiftState;
    FKeyResetZoom:TShiftState;
    FKeyZoomRect:TShiftState;
    FKeyChartInfo:TShiftState;
    FWriteQuotientLS2Image: real;

    function readXAxisPosition:TAxisPosition;
    function readImageAxisPosition:TAxisPosition;
    function readLSAxisPosition:TAxisPosition;
    function readXAxisAlwaysVisible:boolean;
    function readImageAxisAlwaysVisible:boolean;
    function readLSAxisAlwaysVisible:boolean;

    procedure writeXAxisPosition(value:TAxisPosition);
    procedure writeImageAxisPosition(value:TAxisPosition);
    procedure writeLSAxisPosition(value:TAxisPosition);
    procedure writeXAxisAlwaysVisible(value:boolean);
    procedure writeImageAxisAlwaysVisible(value:boolean);
    procedure writeLSAxisAlwaysVisible(value:boolean);
    procedure WriteQuotientLS2Image(value:real);

    Procedure Paint; override;
    procedure DoEnter; override;
    procedure DoExit; override;

    procedure DoBeginPan(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
    procedure DoEndPan(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
    procedure DoPan(Shift: TShiftState; X,Y: Integer);
    procedure DoZoom(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Factor:real; Axis:TKoorSet);
    procedure DoUnZoom(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Factor:real; Axis:TKoorSet);
    procedure DoResetZoom(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Factor:real; Axis:TKoorSet);
    procedure DoZoomRect(Sender: TObject; Shift: TShiftState; rect:TRect);
    procedure DoBeginZoomRect(Sender: TObject; Shift: TShiftState; rect:TRect);
    procedure DoEndZoomRect(Sender: TObject; Shift: TShiftState; rect:TRect);

    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
    procedure MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;  MousePos: TPoint; var result:Boolean);
    procedure MouseEnter(Sender: TObject);

    procedure DrawAxis;
    procedure DrawAllCharts;
    procedure DrawRect;

    function MouseButtonOnly(Shift: TShiftState):TMouseButton;
    function MouseButtonDelete(Shift: TShiftState):TShiftState;

    //muss nicht öffentlich sein, da es ja nur die speziellen Funktionen sind
    function TransOGL2OGLReality(akoor:TKoor1):TKoor1;
    function TransOGLReality2OGL(akoor:TKoor1):TKoor1;
    function TransDeltaOGL2OGLReality(akoor:TKoor1):TKoor1;
    function TransDeltaOGLReality2OGL(akoor:TKoor1):TKoor1;

    function TransKoor2OGL(akoor:TKoor1):TKoor1;
    function TransKoor2OGLReality(akoor:TKoor1):TKoor1;
    function TransPixel2OGLReality(akoor:TKoor1):TKoor1;
    function TransOGLReality2Pixel(akoor:TKoor1):TKoor1;
    
    function TransDeltaKoor2OGLReality(akoor:TKoor1):TKoor1;
    function TransDeltaKoor2Pixel(akoor:TKoor1):TKoor1;
    function TransDeltaOGLReality2Pixel(akoor:TKoor1):TKoor1;
    function TransDeltaPixel2OGLReality(akoor:TKoor1):TKoor1;

    function TransOGL2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind):TKoor1;
    function TransOGLReality2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind):TKoor1;
    function TransDeltaOGLReality2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind):TKoor1;
    function TransPixel2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind):TKoor1;
    function TransDeltaPixel2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind):TKoor1;
  public
    RectPen:TPen;
    RectStart,
    LastMouseMovePos:TPoint;

    xAxis,
    ImageAxis,
    LSAxis:TAxis;
    Header:TOGlLabelBackground;
    MiniSlit:TOGL3DNSlit;

    HelpBoxZoom:TOGlLabelBackground;


    property QuotientLS2Image:real read FQuotientLS2Image write WriteQuotientLS2Image;
    property IsPaning:boolean read FIsPaning;
    property IsZoomingRect:boolean read FIsZoomingRect;

    function KoorIsVisible(akoor:TKoor3; tolerance:real=0.02):boolean;
    function KoorIsVisible(x,y,z:real; tolerance:real=0.02):boolean;


    procedure glWrite(textstr: String; Font_index:integer=0);
    procedure Resize; override;

    procedure WriteFShowCross(ShowCross:boolean);

    function ratio:real;   //width/height

    procedure ResetView;

    function TransAll(akoor:TKoor3; func:TTransChartFunc):TKoor3;         overload;
    function TransAll(akoor:TKoor3; ReturnAxisX, ReturnAxisY, ReturnAxisZ:TKoorKind; func:TTransChartExtendedFunc):TKoor3; overload;

    function Trans2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind):TKoor1;
    function Trans2OGL(akoor:TKoor1):TKoor1;
    function Trans2OGLReality(akoor:TKoor1):TKoor1;
    function Trans2Pixel(akoor:TKoor1):TKoor1;

    function TransDelta2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind):TKoor1;
    function TransDelta2OGL(akoor:TKoor1):TKoor1;
    function TransDelta2OGLReality(akoor:TKoor1):TKoor1;
    function TransDelta2Pixel(akoor:TKoor1):TKoor1;


    procedure OGLVertex3f2OGL(akoor:TKoor3);overload;          // NOT OGLReality
    procedure OGLVertex3f2OGL(x,y,z:real; Kindx,Kindy,Kindz:TKoorKind);overload;  // NOT OGLReality


    procedure OGLRasterPos3f(akoor:TKoor3);overload;
    procedure OGLRasterPos3f(x,y,z:TKoor1);  overload;
    procedure OGLRasterPos3f(x,y,z:real; Kindx, Kindy, Kindz:TKoorKind);  overload;
    
    procedure OGLVertex3f(akoor:TKoor3);overload;
    procedure OGLVertex3f(x,y,z:TKoor1);overload;
    procedure OGLVertex3f(x,y,z:real; Kindx, Kindy, Kindz:TKoorKind);  overload;
    
    procedure OGLTranslate3f(akoor:TKoor3);overload;
    procedure OGLTranslate3f(x,y,z:real; Kindx, Kindy, Kindz:TKoorKind);  overload;
    procedure OGLColor(aColor:TColor);  overload;
    procedure OGLColor(aColor:TColor; Alpha:real);  overload;

    procedure DrawOGL;

    procedure Initnx;
    procedure Enable2D;
    procedure Disable2D;
    procedure DrawTestTriangle;

    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ZoomFactor:real read FZoomFactor write FZoomFactor;
    property ShowCross:boolean read FShowCross write WriteFShowCross;
    property LSAxisPosition:TAxisPosition read ReadLSAxisPosition write writeLSAxisPosition;
    property ImageAxisPosition:TAxisPosition read ReadImageAxisPosition write writeImageAxisPosition;
    property XAxisPosition:TAxisPosition read ReadXAxisPosition write writeXAxisPosition;
    property XAxisAlwaysVisible:boolean read ReadXAxisAlwaysVisible write writeXAxisAlwaysVisible;
    property LSAxisAlwaysVisible:boolean read ReadLSAxisAlwaysVisible write writeLSAxisAlwaysVisible;
    property ImageAxisAlwaysVisible:boolean read ReadImageAxisAlwaysVisible write writeImageAxisAlwaysVisible;


    property OnXAxisPosChange:TNotifyEvent read FOnXAxisPosChange write FOnXAxisPosChange;
    property OnImageAxisPosChange:TNotifyEvent read FOnImageAxisPosChange write FOnImageAxisPosChange;
    property OnLSAxisPosChange:TNotifyEvent read FOnLSAxisPosChange write FOnLSAxisPosChange;
    property OnPan:TMouseMoveEvent read FOnPan write FOnPan;
    property OnBeginPan:TMouseEvent read FOnBeginPan write FOnBeginPan;
    property OnEndPan:TMouseEvent read FOnEndPan write FOnEndPan;
    property OnZoom:TZoomEvent read FOnZoom write FOnZoom;
    property OnUnZoom:TZoomEvent read FOnUnZoom write FOnUnZoom;
    property OnResetZoom:TZoomEvent read FOnResetZoom write FOnResetZoom;
    property OnZoomRect:TZoomRectEvent read FOnZoomRect write FOnZoomRect;
    property OnBeginZoomRect:TZoomRectEvent read FOnBeginZoomRect write FOnBeginZoomRect;
    property OnEndZoomRect:TZoomRectEvent read FOnEndZoomRect write FOnEndZoomRect;

    property KeyPan:TShiftState read FKeyPan write FKeyPan;
    property KeyZoomUnZoomXAxis:TShiftState read FKeyZoomUnZoomXAxis write FKeyZoomUnZoomXAxis;
    property KeyZoomUnZoomLSAxis:TShiftState read FKeyZoomUnZoomLSAxis write FKeyZoomUnZoomLSAxis;
    property KeyResetZoom:TShiftState read FKeyResetZoom write FKeyResetZoom;
    property KeyZoomRect:TShiftState read FKeyZoomRect write FKeyZoomRect;
    property KeyChartInfo:TShiftState read FKeyChartInfo write FKeyChartInfo;
  end;


  { TChart }

  TChart = class(TComponent)
  private
    procedure OGLColor(aColor: TColor);
  public
    Visible:boolean;
    Color:TColor;
    Box:TOGlBox;
    Pen:TPen;
    UseIntensityColor:Boolean;
    IntensityColorFactor:real;
    WhatIsXValue,
    WhatIsYValue,
    WhatIsColorIntensityValue:TXYZKind;

    Depth:TKoor1;
    ValuePointer:TChartValueArray;
    
    constructor Create(OGLBox:TOGlBox; aValuePointer:TChartValueArray); virtual;
    destructor Destroy; override;
  end;
  
  
  { TLineChart }

  TLineChart = class(TChart)
  private
  public
    procedure DrawOGL;  virtual;
  end;


  { TBackgroundChart }

  TBackgroundChart = class(TChart)
  private
  public
    procedure DrawOGL; virtual;

    constructor Create(OGLBox:TOGlBox; aValuePointer:TChartValueArray); override;
  end;


  { TBorderdBackgroundChart }

  TBorderdBackgroundChart = class(TBackgroundChart)
  private
  public
    procedure DrawOGL; override;
  end;



  { TGradientBackgroundChart }

  TGradientBackgroundChart = class(TChart)
  private
  public
    LeftTop,
    LeftBottom,
    RightTop,
    RightBottom:TColor;

    procedure DrawOGL; virtual;  // call this after everything else has finnished!!! For blending!
    
    constructor Create(OGLBox:TOGlBox); virtual;
    destructor Destroy; override;
  end;


  { TPointChart }

  TPointChart = class(TChart)
  private
  public
    procedure DrawOGL; virtual;
  end;




//function InitTextSuite:boolean;
//procedure TSCheckError;

  

const
  znear=0;
  zfar=1000000;
var
  OGLBox:TOGlBox;
  amrechnen:boolean;

implementation
uses unit1,Uapparatus;







{ TOGlBox }

procedure TOGlBox.DrawOGL;
begin
  if not nx.AllOK then exit;
  nx.Clear(true,true);

  Enable2D;
  //nx.rs.AddBlend:=true;

  glTranslatef(0,0, -1000);


  DrawAllCharts;
  DrawAxis;
  Header.Draw;
  if Form1.CheckViewLittleHelp2.Checked then
    HelpBoxZoom.Draw;

  if IsZoomingRect then
    DrawRect;

  MiniSlit.DrawOGL;

  Disable2D;
  nx.Flip;
end;

procedure TOGlBox.Initnx;
begin
  nx.CreateGlWindow(self);
  nx.CreateFont('Courier',Font.Size,256);
  //nx.CreateBasicFont;

  nx.window.OnMouseMove:=@MouseMove;
  nx.window.OnMouseDown:=@MouseDown;
  nx.window.OnMouseUp:=@MouseUp;
  nx.window.OnMouseWheel:=@MouseWheel;
  nx.window.OnMouseEnter:=@MouseEnter;

  if nx.LastError<>'' then showmessage(nx.LastError);
end;

procedure TOGlBox.Enable2D;
begin
  nx.Enable2D;
  glMatrixMode(GL_PROJECTION);    { prepare for and then }
  glLoadIdentity ();               { define the projection }
  //glOrtho(OGLReality.Left, OGLReality.Right, OGLReality.Bottom, OGLReality.Top,  znear,  zfar);
  glOrtho(OGLReality.Left, OGLReality.Right, OGLReality.Bottom, OGLReality.Top,  znear,  zfar);
  //glMatrixMode (GL_MODELVIEW);  { back to modelview matrix }
  //glViewport(0,0, Width, Height);         { define the viewport }
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  //glLoadIdentity;
  nx.rs.CullBack:=False;
  nx.rs.CullFront:=False;
  nx.rs.AddBlend:=True;
end;

procedure TOGlBox.Disable2D;
begin
  nx.Disable2D;
end;

procedure TOGlBox.DrawTestTriangle;
begin
    //paint test triangle
  glPushMatrix;
  //glTranslatef(0,0,0);
  glScalef(100,100,1);
  glBegin(GL_TRIANGLES);
    glColor3f(1, 0, 0);
    glVertex3f(-1, -1, 0);

    glColor3f(0, 1, 0);
    glVertex3f(1, -1, 0);

    glColor3f(0, 0, 1);
    glVertex3f(0, 1, 0);
  glEnd;
  glPopMatrix;
end;





function TOGlBox.TransOGL2OGLReality(akoor: TKoor1): TKoor1;
begin
  Result:=akoor;
  case akoor.Kind of
    kkOGLx: result:=Koor1( akoor.v - xAxis.Koor.Min*OGLReality.Width/xAxis.KoorSize +OGLReality.Left   ,  Change2OGLReality(akoor.Kind))  ;
    kkOGLy: Result:=Koor1( akoor.v - LSAxis.Koor.Min*OGLReality.Height/LSAxis.KoorSize +OGLReality.Bottom   ,  Change2OGLReality(akoor.Kind))  ;
    kkOGLz: Result:=Koor1(akoor.v  ,  kkOGLRealityz);
  end;
end;

function TOGlBox.TransOGLReality2OGL(akoor: TKoor1): TKoor1;
begin
  Result:=akoor;
  case akoor.Kind of
    kkOGLRealityx: Result:=Koor1( akoor.v + xAxis.Koor.Min*OGLReality.Width/xAxis.KoorSize -OGLReality.Left   ,  Change2OGL(akoor.Kind))  ;
    kkOGLRealityy: Result:=Koor1( akoor.v + LSAxis.Koor.Min*OGLReality.Height/LSAxis.KoorSize -OGLReality.Bottom   ,  Change2OGL(akoor.Kind))  ;
    kkOGLRealityz: Result:=Koor1(akoor.v  ,  kkOGLRealityz);
  end;
end;

function TOGlBox.TransDeltaOGL2OGLReality(akoor: TKoor1): TKoor1;
begin
  Result:=akoor;
end;

function TOGlBox.TransDeltaOGLReality2OGL(akoor: TKoor1): TKoor1;
begin
  Result:=akoor;
end;





function TOGlBox.TransKoor2OGL(akoor:TKoor1): TKoor1;
begin
  Result:=TransOGLReality2OGL(TransKoor2OGLReality(akoor));
  
  //result:=akoor;
  //case akoor.Kind of
    //kkx:      Result:=Koor1(akoor.v* OGLReality.Width/ xAxis.KoorSize  ,  Change2OGL(akoor.Kind));
    //kkImage:  Result:=Koor1(akoor.v* OGLReality.Height/ ImageAxis.KoorSize  ,  Change2OGL(akoor.Kind));
    //kkLS:     Result:=Koor1(akoor.v* OGLReality.Height/ LSAxis.KoorSize  ,  Change2OGL(akoor.Kind));
    //kkz:      Result:=Koor1(akoor.v  ,  Change2OGL(akoor.Kind));
  //end;
end;



function TOGlBox.TransKoor2OGLReality(akoor:TKoor1): TKoor1;
begin
  Result:=akoor;
  case akoor.Kind of
    kkx:      Result:=Koor1((akoor.v-xAxis.Koor.Min)* OGLReality.Width/ xAxis.KoorSize + OGLReality.Left  ,  Change2OGLReality(akoor.Kind));
    kkImage:  Result:=Koor1((akoor.v-ImageAxis.Koor.Min)* OGLReality.Height/ ImageAxis.KoorSize + OGLReality.Bottom  ,  Change2OGLReality(akoor.Kind));
    kkLS:     Result:=Koor1((akoor.v-LSAxis.Koor.Min)* OGLReality.Height/ LSAxis.KoorSize + OGLReality.Bottom  ,  Change2OGLReality(akoor.Kind));
    kkz:      Result:=Koor1(akoor.v  ,  kkOGLRealityz);
  end;
end;

function TOGlBox.TransDeltaKoor2OGLReality(akoor:TKoor1): TKoor1;
begin
  result:=akoor;
  case akoor.Kind of
    kkx: Result:=Koor1(akoor.v* OGLReality.Width/ xAxis.KoorSize   ,  Change2OGLReality(akoor.Kind));
    kkImage: Result:=Koor1(akoor.v* OGLReality.Height/ ImageAxis.KoorSize  ,  Change2OGLReality(akoor.Kind));
    kkLS: Result:=Koor1(akoor.v* OGLReality.Height/ LSAxis.KoorSize  ,  Change2OGLReality(akoor.Kind));
    kkz: Result:=Koor1(akoor.v  ,  kkOGLRealityz);
  end;
end;

function TOGlBox.TransDeltaKoor2Pixel(akoor:TKoor1): TKoor1;
begin
  result:=TransDeltaOGLReality2Pixel(TransDeltaKoor2OGLReality(akoor));
end;


function TOGlBox.TransOGL2Koor(akoor: TKoor1; ReturnKoorKind:TKoorKind): TKoor1;
begin
  Result:=TransOGLReality2Koor(TransOGL2OGLReality(akoor), ReturnKoorKind);
end;


function TOGlBox.TransOGLReality2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind): TKoor1;
begin
  //es wird erwartet dass returnkoorkind mit dem ankommenden akoor.kind zusammenpasst (d.h. NOT: akoor=kkOGLRealityx and ReturnKoorKind =kkLS)

  result:=akoor;
  case akoor.Kind of
    kkOGLRealityx: Result:=Koor1((akoor.v - OGLReality.Left) * xAxis.KoorSize/OGLReality.Width + xAxis.Koor.Min  ,  ReturnKoorKind);
    kkOGLRealityy:
      case ReturnKoorKind of
        kkLS:     Result:=Koor1((akoor.v - OGLReality.Bottom) * LSAxis.KoorSize/ OGLReality.Height  + LSAxis.Koor.Min  ,  ReturnKoorKind);
        kkImage:  Result:=Koor1((akoor.v - OGLReality.Bottom) * ImageAxis.KoorSize/ OGLReality.Height  + ImageAxis.Koor.Min  ,  ReturnKoorKind);
      end;
    kkOGLRealityz: Result:=Koor1(akoor.v  ,  ReturnKoorKind);
  end;

  
  //case akoor.Kind of
    //kkx: Result:=Koor1(akoor.v/ OGLReality.Width* Koor.Width;
    //kkLS: Result:=Koor1(akoor.v/ OGLReality.Height* Koor.Height;
    //kkz: Result:=Koor1(akoor.v;
  //end;
end;



function TOGlBox.TransDeltaOGLReality2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind): TKoor1;
begin
  result:=akoor;
  case akoor.Kind of
    kkOGLRealityx: Result:=Koor1(akoor.v * xAxis.KoorSize/OGLReality.Width  ,  ReturnKoorKind);
    kkOGLRealityy:
      case ReturnKoorKind of
        kkLS:     Result:=Koor1(akoor.v  * LSAxis.KoorSize/ OGLReality.Height  ,  ReturnKoorKind);
        kkImage:  Result:=Koor1(akoor.v  * ImageAxis.KoorSize/ OGLReality.Height ,  ReturnKoorKind);
      end;
    kkOGLRealityz: Result:=Koor1(akoor.v  ,  ReturnKoorKind);
  end;
end;



function TOGlBox.TransPixel2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind): TKoor1;
begin
  result:= TransOGLReality2Koor(   TransPixel2OGLReality(akoor) , ReturnKoorKind);
end;


function TOGlBox.TransDeltaPixel2Koor(akoor:TKoor1; ReturnKoorKind:TKoorKind): TKoor1;
begin
  result:=  TransDeltaOGLReality2Koor(TransDeltaPixel2OGLReality(akoor),ReturnKoorKind);
end;

procedure TOGlBox.glWrite(textstr: String; Font_index: integer);
begin
  tex.Enable;
    glPushMatrix;
    glScalef(1,-1,1);
    glScalef(10/Font.Size,10/Font.Size,1);
    nx.SetFont(Font_index);
    nx.Font[Font_index].Draw(0, -nx.Font[0].height div 2, textstr);
    glPopMatrix;
  tex.Disable;
end;




function TOGlBox.TransPixel2OGLReality(akoor:TKoor1): TKoor1;
begin
  result:=akoor;
  case akoor.Kind of
    kkPixelx:  Result:=Koor1(akoor.v+ OGLReality.Left  ,  Change2OGLReality(akoor.Kind));
    kkPixely: Result:=Koor1(-akoor.v-OGLReality.Bottom  ,  Change2OGLReality(akoor.Kind));
    kkPixelz:  Result:=Koor1(akoor.v  ,  Change2OGLReality(akoor.Kind));
  end;
end;


function TOGlBox.TransDeltaPixel2OGLReality(akoor:TKoor1): TKoor1;
begin
  result:=Koor1(akoor.v, Change2OGLReality(akoor.Kind));
end;



function TOGlBox.TransOGLReality2Pixel(akoor:TKoor1): TKoor1;
begin
  result:=akoor;
  case akoor.Kind of
    kkOGLRealityx: Result:=Koor1(akoor.v- OGLReality.Left  ,  Change2Pixel(akoor.Kind));
//    kkImage: Result:=Koor1(aOGLReality-OGLReality.Bottom  ,  Change2Pixel(akoor.Kind));
    kkOGLRealityy: Result:=Koor1(akoor.v-OGLReality.Bottom  ,  Change2Pixel(akoor.Kind));
    kkOGLRealityz: Result:=Koor1(akoor.v  ,  Change2Pixel(akoor.Kind));
  end;
end;

function TOGlBox.TransDeltaOGLReality2Pixel(akoor:TKoor1): TKoor1;
begin
  result:=Koor1(akoor.v, Change2Pixel(akoor.Kind));
end;


procedure TOGlBox.OGLVertex3f2OGL(akoor: TKoor3);
var temp:TKoor3;
begin
  temp:=TransAll(akoor, @Trans2OGL);
  glVertex3f(temp.x.v,temp.y.v,temp.z.v);
end;

procedure TOGlBox.OGLVertex3f2OGL(x, y, z: real; Kindx, Kindy, Kindz: TKoorKind);
begin
  OGLVertex3f2OGL(Koor3(x,y,z, Kindx, Kindy, Kindz));
end;



procedure TOGlBox.OGLRasterPos3f(akoor: TKoor3);
var temp:TKoor3;
begin
  temp:=TransAll(akoor, @Trans2OGLReality);
  glRasterPos3f(temp.x.v,temp.y.v,temp.z.v);
end;

procedure TOGlBox.OGLRasterPos3f(x, y, z: TKoor1);
begin
   OGLRasterPos3f(Koor3(x,y,z));
end;

procedure TOGlBox.OGLRasterPos3f(x, y, z: real; Kindx, Kindy, Kindz: TKoorKind);
begin
  OGLRasterPos3f(Koor3(x, y, z,  Kindx, Kindy, Kindz));
end;



procedure TOGlBox.OGLVertex3f(akoor: TKoor3);
var temp:TKoor3;
begin
  temp:=TransAll(akoor, @Trans2OGLReality);
  glVertex3f(temp.x.v,temp.y.v,temp.z.v);
end;

procedure TOGlBox.OGLVertex3f(x, y, z: TKoor1);
begin
  OGLVertex3f(Koor3(x,y,z));
end;

procedure TOGlBox.OGLVertex3f(x, y, z: real; Kindx, Kindy, Kindz:TKoorKind);
begin
  OGLVertex3f(Koor3(x,y,z,Kindx,Kindy,Kindz));
end;



procedure TOGlBox.OGLTranslate3f(akoor: TKoor3);
var temp:TKoor3;
begin
  temp:=TransAll(akoor, @Trans2OGLReality);
  glTranslatef(temp.x.v,temp.y.v,temp.z.v);
end;

procedure TOGlBox.OGLTranslate3f(x, y, z: real; Kindx, Kindy, Kindz: TKoorKind);
begin
  OGLTranslate3f(Koor3(x,y,z,Kindx,Kindy,Kindz));
end;




procedure TOGlBox.OGLColor(aColor: TColor);
var r,g,b:byte;
begin
  ColorValues(aColor,r,g,b);
  glColor3f(r/255,g/255,b/255);
end;

procedure TOGlBox.OGLColor(aColor: TColor; Alpha: real);
var r,g,b:byte;
begin
  ColorValues(aColor,r,g,b);
  glColor4f(r/255,g/255,b/255, Alpha);
end;



procedure TOGlBox.Resize;
begin
  inherited;

  if ([csLoading,csDestroying]*ComponentState<>[]) then exit;

  if Parent=nil then
    exit;


  OGLReality.R2Rect(-self.Width/2, -self.Height/2, self.Width, self.Height);

  Header.pos.y.v:= OGLReality.Top-OGLReality.Height/50;
  Header.pos.y.Kind:=kkOGLy;
  Header.pos.x.v:= OGLReality.Left+OGLReality.Width/2 - Length(Header.Text)/2*5;
  Header.pos.x.Kind:=kkOGLx;

  MiniSlit.Pos:=Koor3(OGLReality.Left, OGLReality.Bottom, DepthOverlay.v, kkOGLRealityx, kkOGLRealityy, kkOGLRealityz);
end;





procedure TOGlBox.Paint;
begin
  inherited Paint;
  
  DrawOGL;
end;

procedure TOGlBox.DoEnter;
begin
  self.SetFocus;

  inherited DoEnter;
end;

procedure TOGlBox.DoExit;
begin

  inherited DoExit;
end;






procedure TOGlBox.DoBeginPan(Button: TMouseButton; Shift: TShiftState; X,  Y: Integer);
begin
  StoredIdleDraw:=Form1.EnableIdleDraw;
  Form1.EnableIdleDraw:=true;
end;

procedure TOGlBox.DoEndPan(Button: TMouseButton; Shift: TShiftState; X,  Y: Integer);
begin
  Form1.EnableIdleDraw := StoredIdleDraw;
end;

procedure TOGlBox.DoPan(Shift: TShiftState; X, Y: Integer);
var delta:real;
begin
  delta:=TransDelta2Koor(Koor1(-X +LastMouseMovePos.X , kkPixelx), kkX).v;
  xAxis.Koor.Min:=xAxis.Koor.Min + delta;
  xAxis.Koor.Max:=xAxis.Koor.Max + delta;

  delta:=TransDelta2Koor(Koor1(+y -LastMouseMovePos.y , kkPixely), kkLS).v;
  LSAxis.Koor.Min:=LSAxis.Koor.Min + delta;
  LSAxis.Koor.Max:=LSAxis.Koor.Max + delta;

  delta:=TransDelta2Koor(Koor1(+y -LastMouseMovePos.y , kkPixely), kkImage).v;
  ImageAxis.Koor.Min:=ImageAxis.Koor.Min + delta;
  ImageAxis.Koor.Max:=ImageAxis.Koor.Max + delta;
end;

procedure TOGlBox.DoZoom(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Factor: real; Axis:TKoorSet);
begin
  if  kkX in Axis then
    AZoom(xAxis.Koor.Min, xAxis.Koor.Max, Trans2Koor(Koor1(MousePos.x, kkPixelx), kkX).v, ZoomFactor, xAxis.Koor.Min, xAxis.Koor.Max);
  if kkLS in Axis then
    AZoom(LSAxis.Koor.Min, LSAxis.Koor.Max, Trans2Koor(Koor1(MousePos.y, kkPixely), kkLS).v, ZoomFactor, LSAxis.Koor.Min, LSAxis.Koor.Max);
  if kkImage in Axis then
    AZoom(ImageAxis.Koor.Min, ImageAxis.Koor.Max, Trans2Koor(Koor1(MousePos.y, kkPixely), kkImage).v, ZoomFactor, ImageAxis.Koor.Min, ImageAxis.Koor.Max);

  DrawOGL;
end;


procedure TOGlBox.DoUnZoom(Sender: TObject; Shift: TShiftState;  MousePos: TPoint; Factor: real; Axis:TKoorSet);
begin
  if kkX in Axis then
    AZoom(xAxis.Koor.Min, xAxis.Koor.Max, Trans2Koor(Koor1(MousePos.x, kkPixelx), kkX).v, -ZoomFactor, xAxis.Koor.Min, xAxis.Koor.Max);
  if kkLS in Axis then
    AZoom(LSAxis.Koor.Min, LSAxis.Koor.Max, Trans2Koor(Koor1(MousePos.y, kkPixely), kkLS).v, -ZoomFactor, LSAxis.Koor.Min, LSAxis.Koor.Max);
  if kkLS in Axis then
    AZoom(ImageAxis.Koor.Min, ImageAxis.Koor.Max, Trans2Koor(Koor1(MousePos.y, kkPixely), kkImage).v, -ZoomFactor, ImageAxis.Koor.Min, ImageAxis.Koor.Max);


  DrawOGL;
end;

procedure TOGlBox.DoResetZoom(Sender: TObject; Shift: TShiftState;  MousePos: TPoint; Factor: real; Axis:TKoorSet);
begin
  ResetView;

  //with Koor do
    //begin
    //if Axis= xAxisKind then
      //begin
      //Left:=-95 ;
      //Right:=95 ;
      //end
    //else if Axis= YAxisKind then
      //begin
      //Top:=1.1 ;
      //Bottom:=-1.1 ;
      //end
   //end;

  DrawOGL;
end;

procedure TOGlBox.DoZoomRect(Sender: TObject; Shift: TShiftState; rect: TRect);
begin
end;

procedure TOGlBox.DoBeginZoomRect(Sender: TObject; Shift: TShiftState; rect:TRect);
begin
end;


procedure TOGlBox.DoEndZoomRect(Sender: TObject; Shift: TShiftState; rect:TRect);
var anfang,ende:TKoor3;
    RX,RLS,RImage:TKoor1Range;
begin
  anfang:=Koor3Pixel(rect.Left, rect.Bottom, 0);
  ende:=Koor3Pixel(rect.Right, rect.Top, 0);

  if (ende.x.v-anfang.x.v=0) or(ende.y.v-anfang.y.v=0) then
    exit;
  
  anfang:=TransAll(anfang, kkX, kkLS, kkZ, @Trans2Koor);
  ende:=TransAll(ende, kkX, kkLS, kkZ, @Trans2Koor);

  
  rX.Min:=MinKoor(anfang.x,ende.x);
  rX.Max:=MaxKoor(anfang.x,ende.x);
  rLS.Min:=MinKoor(anfang.y,ende.y);
  rLS.Max:=MaxKoor(anfang.y,ende.y);


  xAxis.VisibleRect:=RX;
  LSAxis.VisibleRect:=RLS;

  QuotientLS2Image:=QuotientLS2Image;

  DrawOGL;
end;




procedure TOGlBox.MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  
  Shift:=Shift-[ssCaps, ssNum,ssScroll,ssTriple,ssQuad, ssAlt];

  //pan
  if (FKeyPan=Shift) and (Button=mbLeft) then
    begin
    FIsPaning:=true;

    if assigned(FOnBeginPan) then
      FOnBeginPan(self, Button, Shift,x,y)
    else
      begin
      // here do something before pan
      DoBeginPan(Button, Shift, X ,y );
      end;
    end;


  //ZoomRect
  if (FKeyZoomRect=Shift) then
    begin
    FIsZoomingRect:=true;
    RectStart:=Point(x,y);
    
    Form1.EnableIdleDraw:=true;
    OGLRectZoom.Visible:=true;
    if assigned(FOnBeginZoomRect) then
      FOnBeginZoomRect(self,  Shift, Rect(X ,y, X ,y))
    else
      begin
      // here do something before zoomrect
      DoBeginZoomRect(self,  Shift, Rect(X ,y, X ,y) );
      end;
    end;


  //Reset Zoom
  if (FKeyResetZoom=Shift) then
    if assigned(FOnResetZoom) then
      begin
      FOnResetZoom(self, Shift,Point(x,y), ZoomFactor,[kkX, kkLS, kkImage]);
      end
    else
      begin
      // here do resetzoom
      DoResetZoom(self, Shift, Point(X ,y) , ZoomFactor,[kkX, kkLS, kkImage]);
      end;


  LastMouseMovePos.X:=x;
  LastMouseMovePos.y:=y;
end;



procedure TOGlBox.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  
  Shift:=Shift-[ssCaps, ssNum,ssScroll,ssTriple,ssQuad];
  //pan
  if IsPaning {(FKeyPan=Shift)} then
    begin
    if Assigned(FOnPan) then
      FOnPan(self, Shift,x,y)
    else
      begin
      // here do something during pan
      DoPan(Shift, X ,y );
      end;
    end;
    
    
  //ZoomRect
  if IsZoomingRect  {(FKeyZoomRect=Shift)}  then
    if assigned(FOnZoomRect) then
      FOnZoomRect(self, Shift, Rect( RectStart.X, RectStart.y,  x, y))
    else
      begin
      // here do zoomrect
      DoZoomRect(self, Shift, Rect(RectStart.X, RectStart.y,  x, y ) );
      end;


  LastMouseMovePos.X:=x;
  LastMouseMovePos.y:=y;
end;




procedure TOGlBox.MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  
  Shift:=Shift-[ssCaps, ssNum,ssScroll,ssTriple,ssQuad];
  //pan
  if FIsPaning then
    begin
    FIsPaning:=false;

    if assigned(FOnEndPan) then
      FOnEndPan(self, Button, Shift,x,y)
    else
      begin
      // here do something after pan
      DoEndPan(Button, Shift, X ,y );
      end;
    end;


  //ZoomRect
  if FIsZoomingRect then
    begin
    FIsZoomingRect:=false;
    OGLRectZoom.Visible:=false;
    Form1.EnableIdleDraw:=false;

    if assigned(FOnEndZoomRect) then
      FOnEndZoomRect(self, Shift, Rect(RectStart.X, RectStart.y,  x, y))
    else
      begin
      // here do something after zoomrect
      DoEndZoomRect(self, Shift, Rect(RectStart.X, RectStart.y,  x, y));
      end;
    DrawOGL;
    end;
end;



procedure TOGlBox.MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;  MousePos: TPoint; var result:Boolean);
var i:integer;
  a:Tpoint;
begin
  Result:=inherited DoMouseWheel(Shift, WheelDelta, MousePos);

  Shift:=Shift-[ssCaps, ssNum,ssScroll,ssTriple,ssQuad];


  //zoom
  if (WheelDelta>0) then
    if assigned(FOnZoom) then
      FOnZoom(self,  Shift, MousePos, ZoomFactor, [kkX])
    else
      begin
      // here do zoom
      if (FKeyZoomUnZoomXAxis = Shift) then
        DoZoom(self,  Shift, MousePos, ZoomFactor,[kkX])
      else if (FKeyZoomUnZoomLSAxis = Shift) then
        DoZoom(self,  Shift, MousePos, ZoomFactor,[kkLS, kkImage]);
      end;
      
  //Unzoom
  if (WheelDelta<0) then
    if assigned(FOnUnZoom) then
      FOnUnZoom(self,  Shift,MousePos, ZoomFactor,[kkX])
    else
      begin
      // here do Unzoom
      if (FKeyZoomUnZoomxAxis=Shift) then
        DoUnZoom(self,  Shift, MousePos, ZoomFactor, [kkX])
      else if (FKeyZoomUnZoomLSAxis=Shift) then
        DoUnZoom(self,  Shift, MousePos, ZoomFactor, [kkLS, kkImage]);
      end;
end;

procedure TOGlBox.MouseEnter(Sender: TObject);
begin
  inherited MouseEnter;

//  Self.SetFocus;
end;





function TOGlBox.readXAxisPosition: TAxisPosition;
begin
  Result:=xAxis.AxisPosition;
end;

function TOGlBox.readImageAxisPosition: TAxisPosition;
begin
  Result:=ImageAxis.AxisPosition;
end;

function TOGlBox.readLSAxisPosition: TAxisPosition;
begin
  Result:=LSAxis.AxisPosition;
end;


function TOGlBox.readXAxisAlwaysVisible: boolean;
begin
  result:=xAxis.AxisAlwaysVisible;
end;

function TOGlBox.readImageAxisAlwaysVisible: boolean;
begin
  result:=ImageAxis.AxisAlwaysVisible;
end;

function TOGlBox.readLSAxisAlwaysVisible: boolean;
begin
  result:=LSAxis.AxisAlwaysVisible;
end;



procedure TOGlBox.writeXAxisPosition(value: TAxisPosition);
begin
  xAxis.AxisPosition:=value;
   
  if Assigned(FOnXAxisPosChange) then
    FOnXAxisPosChange(self);
end;

procedure TOGlBox.writeImageAxisPosition(value: TAxisPosition);
begin
  ImageAxis.AxisPosition:=value;

  if Assigned(FOnImageAxisPosChange) then
    FOnImageAxisPosChange(self);
end;

procedure TOGlBox.writeLSAxisPosition(value: TAxisPosition);
begin
  LSAxis.AxisPosition:=value;

  if Assigned(FOnLSAxisPosChange) then
    FOnLSAxisPosChange(self);
end;

procedure TOGlBox.writeXAxisAlwaysVisible(value: boolean);
begin
  if xAxis.AxisAlwaysVisible = value then
    exit;
    
  xAxis.AxisAlwaysVisible:=value;
  DrawOGL;
end;

procedure TOGlBox.writeImageAxisAlwaysVisible(value: boolean);
begin
  if ImageAxis.AxisAlwaysVisible = value then
    exit;

  ImageAxis.AxisAlwaysVisible:=value;
  DrawOGL;
end;

procedure TOGlBox.writeLSAxisAlwaysVisible(value: boolean);
begin
  if LSAxis.AxisAlwaysVisible = value then
    exit;

  LSAxis.AxisAlwaysVisible:=value;
  DrawOGL;
end;

procedure TOGlBox.WriteQuotientLS2Image(value: real);
begin
  //kein exit wenn der Wert gleich ist, da doppeltes etzten der Grenzen der Achsenn nicht schaden kann
  FQuotientLS2Image:=value;

  if assigned(ImageAxis) then
    begin
    ImageAxis.Koor.Min:=LSAxis.Koor.Min/QuotientLS2Image;   // hier kann ich eintragen was ich will. Es sollte allerdings linear gleich sein mit der anderen y Achse
    ImageAxis.Koor.Max:=LSAxis.Koor.Max/QuotientLS2Image;    // hier kann ich eintragen was ich will. Es sollte allerdings linear gleich sein mit der anderen y Achse
    end;
end;




function TOGlBox.KoorIsVisible(akoor: TKoor3; tolerance:real=0.02): boolean;
begin
  if (akoor.x.Kind<>kkOGLx) or (akoor.y.Kind<>kkOGLy) or (akoor.z.Kind<>kkOGLz) then
    begin
    Result:=false;
    exit;
    end;
    
  Result:=    IsInRange(akoor.x.v*(1-tolerance), xAxis.VisibleRect.Min.v, xAxis.VisibleRect.Max.v)
          and IsInRange(akoor.y.v*(1-tolerance), LSAxis.VisibleRect.Min.v, LSAxis.VisibleRect.Max.v)
          and IsInRange(akoor.z.v*(1-tolerance), znear, zfar);
end;

function TOGlBox.KoorIsVisible(x, y, z: real; tolerance: real): boolean;
begin

end;






//procedure TOGlBox.DrawAxis;
//const
  //size=98;
  //XaxisSpace=5;
  //LSAxisSpace=8;
  //TitleSpace=5;
//var   re, vr:TR2RectSimple;
      //temp:real;


  //function LSAxisPosition2X:real;
  //begin
    //case LSAxisPosition of
      //apMin: Result:=Re.Left;
      //apMax: Result:=re.Right;
      //ap0: Result:=0;
    //end;
  //end;
  //function XAxisPosition2Y:real;
  //begin
    //case XAxisPosition of
      //apMin: Result:=Re.Bottom;
      //apMax: Result:=re.Top;
      //ap0: Result:=0;
    //end;
  //end;


//begin
  //vr:=VisibleRect;

  //re.Left:=ReduceRangeFromCenterGetMin(vr.Left, vr.Right, size/100);
  //re.Right:=ReduceRangeFromCenterGetMax(vr.Left, vr.Right, size/100);
  //re.Bottom:=ReduceRangeFromCenterGetMin(vr.Bottom, vr.Top, size/100 );
  //re.Top:=ReduceRangeFromCenterGetMax(vr.Bottom, vr.Top, (size-4)/100);

  //case LSAxisPosition of
    //apMin:
      //begin
      //re.Left:=ReduceRangeFromCenterGetMin(vr.Left, vr.Right, (size-LSAxisSpace)/100);
      //LSAxis.TickPosition:=tpMin;
      //LSAxis.LabelPosition:=lpMax;
      //end;
    //apMax:
      //begin
      //re.Right:=ReduceRangeFromCenterGetMax(vr.Left, vr.Right, (size-LSAxisSpace)/100);
      //LSAxis.TickPosition:=tpMax;
      //LSAxis.LabelPosition:=lpMin;
      //end;
    //ap0:
      //begin
      //LSAxis.TickPosition:=tpMin;
      //LSAxis.LabelPosition:=lpMax;
      //end;
  //end;

  //case XAxisPosition of
    //apMin:
      //begin
      //re.Bottom:=ReduceRangeFromCenterGetMin(vr.Bottom, vr.Top, (size-XaxisSpace)/100 );
      //xAxis.TickPosition:=tpMin;
      //xAxis.LabelPosition:=lpMax;
      //end;
    //apMax:
      //begin
      //re.Top:=ReduceRangeFromCenterGetMax(vr.Bottom, vr.Top, (size-XaxisSpace-TitleSpace)/100);
      //xAxis.TickPosition:=tpMax;
      //xAxis.LabelPosition:=lpMin;
      //end;
    //ap0:
      //begin
      //temp:=ReduceRangeFromCenterGetMin(vr.Bottom, vr.Top, (size-XaxisSpace)/100 );
      //if XAxisAlwaysVisible  and (re.Bottom<temp) then
        //re.Bottom:=temp;

      //xAxis.TickPosition:=tpMin;
      //xAxis.LabelPosition:=lpMax;
      //end;
  //end;

  //xAxis.Draw(R2Vec(re.Left ,XAxisPosition2Y),R2Vec(re.Right,XAxisPosition2Y));
  //LSAxis.Draw(R2Vec(LSAxisPosition2X,re.Bottom),R2Vec(LSAxisPosition2X, re.Top));
//end;


procedure TOGlBox.DrawAxis;
var   reX, reLS, reI:TR2RectSimple;
      tempMin, tempMax:real;
  size,
  TitleSpace:real;


  function GetRightPosition(axis, OtherAxis:TAxis; size,PreMinSpace,PostMaxSpace,DownSideSpace,UpperSideSpace:real):TR2RectSimple;
  var VR, OtherVR:TKoor1Range;
  begin
  VR:=axis.VisibleRect;
  OtherVR:=OtherAxis.VisibleRect;
  
  axis.LabelSpace.Kind:=OtherAxis.KoorKind;


  result.Bottom:=ReduceRangeFromCenterGetMin(VR.Min.v, VR.Max.v, size/100 )+PreMinSpace;
  result.Top:=ReduceRangeFromCenterGetMax(VR.Min.v, VR.Max.v, size/100)-PostMaxSpace;

  case axis.AxisPosition of
    apMin:
      begin
      result.Left:=ReduceRangeFromCenterGetMin(OtherVR.Min.v, OtherVR.Max.v, size/100);
      result.Right:=result.Left;

      axis.TickPosition:=tpMin;
      Axis.LabelPosition:=lpMax;
      end;
    apMax:
      begin
      result.Left:=ReduceRangeFromCenterGetMax(OtherVR.Min.v, OtherVR.Max.v, size/100);
      result.Right:=result.Left;

      Axis.TickPosition:=tpMax;
      Axis.LabelPosition:=lpMin;
      end;
    ap0:
      begin
      Axis.TempAxisPosition:=ap0;
      //tempMin:=ReduceRangeFromCenterGetMin(OtherVR.Min.v, OtherVR.Max.v, size/100);
      //tempMax:=ReduceRangeFromCenterGetMax(OtherVR.Min.v, OtherVR.Max.v, size/100);
      tempMin:=OtherVR.Min.v;
      tempMax:=OtherVR.Max.v;

      result.Left:=0;
      if result.Left<tempMin then
        begin
        result.Left:=tempMin;
        Axis.TempAxisPosition:=apMin;
        end;
      if result.Left>tempMax then
        begin
        result.Left:=tempMax;
        Axis.TempAxisPosition:=apMax;
        end;
      result.Right:=result.Left;

      axis.TickPosition:=tpMin;
      axis.LabelPosition:=lpMax;
      end;
  end;
  case Axis.AxisKind of
    XAxisKind:
      begin
      SwapReal(Result.Left, Result.Bottom);
      SwapReal(Result.Right, Result.Top);
      end;
    YAxisKind: ;
  end;
  end;



begin
  size:=98;
  
  if Header.Enabled then
    TitleSpace:=5
  else
    TitleSpace:=0;

  
  //WriteLn('-----------------------------------------');
  //WriteLn('X-Axis');
  //WriteLn('-----------------------------------------');
  reX:=GetRightPosition(xAxis, LSAxis, size, LSAxis.LabelSpace.v,ImageAxis.LabelSpace.v,0,0);
  //WriteLn('-----------------------------------------');
  //WriteLn('LS-Axis');
  //WriteLn('-----------------------------------------');
  reLS:=GetRightPosition(LSAxis, xAxis , size, 0 {xAxis.LabelSpace.v},TransDelta2Koor(Koor1(TitleSpace, kkPixely), kkLS).v,0,0);
  //WriteLn('-----------------------------------------');
  //WriteLn('Image-Axis');
  //WriteLn('-----------------------------------------');
  reI:=GetRightPosition(ImageAxis, xAxis , size, xAxis.LabelSpace.v,TransDelta2Koor(Koor1(TitleSpace, kkPixely), kkImage).v,0,0);

  xAxis.Draw(Koor3(reX.Left ,reX.Bottom, 0, kkx, kkLS, kkz),Koor3(reX.Right,reX.Top, 0, kkx, kkLS, kkz));
  if xAxis.ShowMainGrid then
    LSAxis.DrawMainGrid(Koor3(reLS.Left ,reLS.Bottom, 0, kkx, kkLS, kkz),Koor3(reLS.Right,reLS.Top, 0, kkx, kkLS, kkz), xAxis);

  LSAxis.Draw(Koor3(reLS.Left ,reLS.Bottom, 0, kkx, kkLS, kkz),Koor3(reLS.Right,reLS.Top, 0, kkx, kkLS, kkz));
  if LSAxis.ShowMainGrid then
    xAxis.DrawMainGrid(Koor3(reX.Left ,reX.Bottom, 0, kkx, kkLS, kkz),Koor3(reX.Right,reX.Top, 0, kkx, kkLS, kkz), LSAxis);

  ImageAxis.Draw(Koor3(reI.Left ,reI.Bottom, 0, kkx, kkImage, kkz),Koor3(reI.Right,reI.Top, 0, kkx, kkImage, kkz));
  if ImageAxis.ShowMainGrid then
    xAxis.DrawMainGrid(Koor3(reX.Left ,reX.Bottom, 0, kkx, kkLS, kkz),Koor3(reX.Right,reX.Top, 0, kkx, kkLS, kkz), ImageAxis);
end;





procedure TOGlBox.DrawAllCharts;
begin
  SaS.DrawOGLOnlyVisible;
end;

procedure TOGlBox.DrawRect;
var anfang,ende:TKoor3;
    r:TR2RectSimple;
begin
  // umdrehen damit es von rechts unten anfängt
  anfang:=Koor3Pixel(RectStart.x, RectStart.y, 0);
  ende:=Koor3Pixel(LastMouseMovePos.x, LastMouseMovePos.y, 0);
  
  anfang:=TransAll(anfang, @Trans2OGLReality);
  ende:=TransAll(ende, @Trans2OGLReality);

  r.Left:=anfang.x.v;
  r.Bottom:=anfang.y.v;
  r.Right:=ende.x.v;
  r.Top:=ende.y.v;

  OGLRectZoom.Draw(r, DepthOverlay);
end;






function TOGlBox.MouseButtonOnly(Shift: TShiftState): TMouseButton;
begin
  if ssLeft in Shift then
    Result:=mbLeft
  else if ssRight in Shift then
    Result:=mbRight
  else if ssMiddle in Shift then
    Result:=mbMiddle;
end;

function TOGlBox.MouseButtonDelete(Shift: TShiftState): TShiftState;
begin
  result:=Shift;
  
  if ssLeft in Shift then
    Exclude(Result, ssLeft)
  else if ssRight in Shift then
    Exclude(Result, ssRight)
  else if ssMiddle in Shift then
    Exclude(Result, ssMiddle);
end;



procedure TOGlBox.WriteFShowCross(ShowCross: boolean);
begin
  FShowCross:=ShowCross;
  xAxis.ShowMainGrid:=FShowCross;
  LSAxis.ShowMainGrid:=FShowCross;
end;

function TOGlBox.ratio: real;
begin
  Result:=Width/Height;
end;


procedure TOGlBox.ResetView;
begin
  xAxis.ResetKoor;
  LSAxis.ResetKoor;

  QuotientLS2Image:=QuotientLS2Image;
end;




function TOGlBox.TransAll(akoor: TKoor3; func: TTransChartFunc): TKoor3;
begin
  Result.x:=func(akoor.x);
  Result.y:=func(akoor.y);
  Result.z:=func(akoor.z);
end;



function TOGlBox.TransAll(akoor: TKoor3; ReturnAxisX, ReturnAxisY, ReturnAxisZ:TKoorKind; func: TTransChartExtendedFunc): TKoor3;
begin
  Result.x:=func(akoor.x, ReturnAxisX);
  Result.y:=func(akoor.y, ReturnAxisY);
  Result.z:=func(akoor.z, ReturnAxisZ);
end;



function TOGlBox.Trans2Koor(akoor: TKoor1; ReturnKoorKind:TKoorKind): TKoor1;
begin
  case akoor.Kind of
    kkx, kkLS, kkz, kkImage                     : Result:=akoor;
    kkOGLx, kkOGLy, kkOGLz                      : Result:=TransOGL2Koor(akoor, ReturnKoorKind);
    kkOGLRealityx, kkOGLRealityy, kkOGLRealityz : Result:=TransOGLReality2Koor(akoor, ReturnKoorKind);
    kkPixelx, kkPixely, kkPixelz                : Result:=TransPixel2Koor(akoor, ReturnKoorKind);
  end;
end;

function TOGlBox.Trans2OGL(akoor: TKoor1): TKoor1;
begin
  case akoor.Kind of
    kkx, kkLS, kkz, kkImage                     : Result:=TransKoor2OGL(akoor);
    kkOGLx, kkOGLy, kkOGLz                      : Result:=akoor;
    kkOGLRealityx, kkOGLRealityy, kkOGLRealityz : Result:=TransOGLReality2OGL(akoor);
    kkPixelx, kkPixely, kkPixelz                : Result:=TransOGLReality2OGL(TransPixel2OGLReality(akoor));
  end;
end;

function TOGlBox.Trans2OGLReality(akoor: TKoor1): TKoor1;
begin
  case akoor.Kind of
    kkx, kkLS, kkz, kkImage                     : Result:=TransKoor2OGLReality(akoor);
    kkOGLx, kkOGLy, kkOGLz                      : Result:=TransOGL2OGLReality(akoor);
    kkOGLRealityx, kkOGLRealityy, kkOGLRealityz : Result:=akoor;
    kkPixelx, kkPixely, kkPixelz                : Result:=TransPixel2OGLReality(akoor);
  end;
end;

function TOGlBox.Trans2Pixel(akoor: TKoor1): TKoor1;
begin
  case akoor.Kind of
    kkx, kkLS, kkz, kkImage                     : Result:=TransOGLReality2Pixel(TransKoor2OGLReality(akoor));
    kkOGLx, kkOGLy, kkOGLz                      : Result:=TransOGLReality2Pixel(TransOGL2OGLReality(akoor));
    kkOGLRealityx, kkOGLRealityy, kkOGLRealityz : Result:=TransOGLReality2Pixel(akoor);
    kkPixelx, kkPixely, kkPixelz                : Result:=akoor;
  end;
end;


function TOGlBox.TransDelta2Koor(akoor: TKoor1; ReturnKoorKind: TKoorKind): TKoor1;
begin
  case akoor.Kind of
    kkx, kkLS, kkz, kkImage                     : Result:=akoor;
    kkOGLx, kkOGLy, kkOGLz                      : Result:=TransDeltaOGLReality2Koor( TransDeltaOGL2OGLReality(akoor), ReturnKoorKind);
    kkOGLRealityx, kkOGLRealityy, kkOGLRealityz : Result:=TransDeltaOGLReality2Koor(akoor, ReturnKoorKind);
    kkPixelx, kkPixely, kkPixelz                : Result:=TransDeltaPixel2Koor(akoor, ReturnKoorKind);
  end;
end;

function TOGlBox.TransDelta2OGL(akoor: TKoor1): TKoor1;
begin
  case akoor.Kind of
    kkx, kkLS, kkz, kkImage                     : Result:=TransDeltaOGLReality2OGL(TransDeltaKoor2OGLReality(akoor));
    kkOGLx, kkOGLy, kkOGLz                      : Result:=akoor;
    kkOGLRealityx, kkOGLRealityy, kkOGLRealityz : Result:=TransDeltaOGLReality2OGL(akoor);
    kkPixelx, kkPixely, kkPixelz                : Result:=TransDeltaOGLReality2OGL(TransDeltaPixel2OGLReality(akoor));
  end;
end;

function TOGlBox.TransDelta2OGLReality(akoor: TKoor1): TKoor1;
begin
  case akoor.Kind of
    kkx, kkLS, kkz, kkImage                     : Result:=TransDeltaKoor2OGLReality(akoor);
    kkOGLx, kkOGLy, kkOGLz                      : Result:=TransDeltaOGL2OGLReality(akoor);
    kkOGLRealityx, kkOGLRealityy, kkOGLRealityz : Result:=akoor;
    kkPixelx, kkPixely, kkPixelz                : Result:=TransDeltaPixel2OGLReality(akoor);
  end;
end;

function TOGlBox.TransDelta2Pixel(akoor: TKoor1): TKoor1;
begin
  case akoor.Kind of
    kkx, kkLS, kkz, kkImage                     : Result:=TransDeltaOGLReality2Pixel(TransDeltaKoor2OGLReality(akoor));
    kkOGLx, kkOGLy, kkOGLz                      : Result:=TransDeltaOGLReality2Pixel(TransDeltaOGL2OGLReality(akoor));
    kkOGLRealityx, kkOGLRealityy, kkOGLRealityz : Result:=TransOGLReality2Pixel(akoor);
    kkPixelx, kkPixely, kkPixelz                : Result:=akoor;
  end;
end;




constructor TOGlBox.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  amrechnen:=false;
  
  OGLRectZoom:=TOGLRect.Create;
  DepthOverlay:=Koor1(900,kkz);
  //self
  //Left:=TheOwner.OptioScreen.Left+TheOwner.OptioScreen.Width+10;
  //Top:=10;
  //Height:=TheOwner.Height-10-TheOwner.GroupBoxLambda.Height;
  //Width:=200;


  OGLReality:=TR2Rect.Create;

  QuotientLS2Image:=1/15;
  Font.Size:=10;
  RectPen:=TPen.Create;


  xAxis:=TAxis.Create(XAxisKind);
  xAxis.KoorKind:=kkx;
  xAxis.AxisPosition:=ap0;

  LSAxis:=TAxis.Create(YAxisKind);
  LSAxis.KoorKind:=kkLS;
  LSAxis.AxisPosition:=apMin;
  LSAxis.TitlePosition.SidePosition:=lpMax;

  ImageAxis:=TAxis.Create(YAxisKind);
  ImageAxis.KoorKind:=kkImage;
  ImageAxis.AxisPosition:=apMax;
  LSAxis.TitlePosition.SidePosition:=lpMin;

  
  ResetView;  // erst nach den achsen!!!

  
  Header:=TOGlLabelBackground.Create;
  Header.pos.z:=DepthOverlay;


  MiniSlit:=TOGL3DNSlit.Create(Koor3(0,0, DepthOverlay.v, kkOGLRealityx, kkOGLRealityy, kkOGLRealityz),
                               Koor3(130,30, 0, kkOGLRealityx, kkOGLRealityy, kkOGLRealityz),
                               Koor3(100,100,1/15*2, kkOGLRealityx, kkOGLRealityy, kkOGLRealityz));


  FKeyPan:=[ssLeft];
  FKeyZoomUnZoomXAxis:=[];
  FKeyZoomUnZoomLSAxis:=[ssCtrl];
  FKeyResetZoom:=[ssMiddle];
  FKeyZoomRect:=[ssCtrl, ssLeft];
  FKeyChartInfo:=[ssAlt, ssLeft];
  
  FZoomFactor:=0.15;

  HelpBoxZoom:=TOGlLabelBackground.Create;
  with HelpBoxZoom do
    begin
    Text:='STRG dr'+KorrectUmlaut('ü')+'cken um vertikal zu zoomen'+#13+'Rechteck-zoomen mit STRG und Maus ziehen';
    BackgroundColor:=clGreen;
    BackgroundAlpha:=0.5;
    Color:=clBlue;
    end;
end;



destructor TOGlBox.Destroy;
begin
  nx.KillGLWindow;
  xAxis.Free;
  LSAxis.Free;
  ImageAxis.Free;
  Header.Free;
  OGLReality.Free;
  RectPen.Free;
  OGLRectZoom.Free;
  MiniSlit.Free;
  HelpBoxZoom.Free;

  inherited Destroy;
end;

{ TChart }

procedure TChart.OGLColor(aColor: TColor);
var r,g,b:byte;
begin
  ColorValues(aColor,r,g,b);
  glColor3f(r/255,g/255,b/255);
end;




constructor TChart.Create(OGLBox:TOGlBox; aValuePointer:TChartValueArray);
begin
  inherited create(OGLBox);
  Depth:=Koor1(10,kkz);
  
  Visible:=true;
  UseIntensityColor:=false;
  IntensityColorFactor:=1;
  Box:=OGLBox;
  ValuePointer:=aValuePointer;
  Pen:=TPen.Create;
  WhatIsXValue:=xyzkX;
  WhatIsYValue:=xyzkY;
  WhatIsColorIntensityValue:=xyzkZ;
end;

destructor TChart.Destroy;
begin
  Pen.Free;

  inherited;
end;

{ TLineChart }

procedure TLineChart.DrawOGL;
var i:integer;
begin
  if not Visible then
    exit;





  glPushMatrix;
  //linie
  glBegin(gl_Line_Strip);
    Box.OGLColor(Color);
    glLineWidth(Pen.Width);

    for i := 0 to ValuePointer.count-1 do
      begin
      if UseIntensityColor then
        Box.OGLColor(IntensityColor(Color, ValuePointer.GetRightValue(i, WhatIsColorIntensityValue)*IntensityColorFactor))
      else
        Box.OGLColor(ValuePointer[i].Color);

      Box.OGLVertex3f(ValuePointer.GetRightKoor(i, WhatIsXValue), ValuePointer.GetRightKoor(i, WhatIsYValue), Depth);
      end;
  glEnd;
  glPopMatrix;
end;


{ TBackgroundChart }


procedure TBackgroundChart.DrawOGL;
var i:integer;
begin
  if not Visible then
    exit;

  glPushMatrix;
  //linie
  glDisable(GL_DEPTH_TEST);
  glEnable(GL_BLEND);
  glBlendFunc(GL_ONE, GL_ONE);

  glBegin(GL_Quad_STRIP);

    for i := 0 to ValuePointer.count-1 do
      begin
      if UseIntensityColor then
        Box.OGLColor(IntensityColor(Color, abs(ValuePointer.GetRightValue(i, WhatIsColorIntensityValue))*IntensityColorFactor), ValuePointer.GetRightValue(i, WhatIsColorIntensityValue)*IntensityColorFactor)
      else
        Box.OGLColor(ValuePointer[i].Color);

      //Box.OGLVertex3f(ValuePointer[i].Pos.x, min(OGLBox.LSAxis.Koor.Min, OGLBox.LSAxis.Koor.Max), Depth);
      //Box.OGLVertex3f(ValuePointer[i].Pos.x, max(OGLBox.LSAxis.Koor.Min, OGLBox.LSAxis.Koor.Max), Depth);
      Box.OGLVertex3f(ValuePointer.GetRightValue(i, WhatIsXValue), ValuePointer.GetRightValue(i, WhatIsYValue)-aperture.LaserHeight/2, Depth.v, ValuePointer.GetRightKoor(i, WhatIsXValue).Kind, ValuePointer.GetRightKoor(i, WhatIsYValue).Kind, Depth.Kind);
      Box.OGLVertex3f(ValuePointer.GetRightValue(i, WhatIsXValue), ValuePointer.GetRightValue(i, WhatIsYValue)+aperture.LaserHeight/2, Depth.v, ValuePointer.GetRightKoor(i, WhatIsXValue).Kind, ValuePointer.GetRightKoor(i, WhatIsYValue).Kind, Depth.Kind);
      end;
  glEnd;

  glDisable(GL_BLEND);
  glEnable(GL_DEPTH_TEST);
  glPopMatrix;
end;

constructor TBackgroundChart.Create(OGLBox: TOGlBox; aValuePointer:TChartValueArray);
begin
  inherited;
  
  UseIntensityColor:=true;
end;





{ TGradientBackgroundChart }

procedure TGradientBackgroundChart.DrawOGL;
begin
  if not Visible then
    exit;

  glBegin(GL_QUADS);
  
    OGLColor(LeftBottom);
    glVertex3f(OGLBox.OGLReality.Left,OGLBox.OGLReality.Bottom,Depth.v);

    OGLColor(RightBottom);
    glVertex3f(OGLBox.OGLReality.Right,OGLBox.OGLReality.Bottom,Depth.v);

    OGLColor(RightTop);
    glVertex3f(OGLBox.OGLReality.Right, OGLBox.OGLReality.Top,Depth.v);

    OGLColor(LeftTop);
    glVertex3f(OGLBox.OGLReality.Left, OGLBox.OGLReality.Top,Depth.v);

  glEnd;
end;

constructor TGradientBackgroundChart.Create(OGLBox: TOGlBox);
begin
  ValuePointer:=TChartValueArray.Create;

  inherited create(OGLBox, ValuePointer);
  
  LeftTop:=RGBToColor(245,211,129);
  LeftBottom:=RGBToColor(245,211,129);
  RightTop:=RGBToColor(255,251,240);
  RightBottom:=RGBToColor(255,251,240);
  Depth:=Koor1(-300,kkz);
end;

destructor TGradientBackgroundChart.Destroy;
begin
  ValuePointer.Free;

  inherited;
end;




{ TPointChart }



procedure TPointChart.DrawOGL;
var i:integer;
    p:Pointer;
    radius:real;
begin
  if not Visible then
    exit;
    
  radius:=4;
  for i := 0 to ValuePointer.count-1 do
    begin
    //if  not Box.koorIsVisible(ValuePointer[i].Pos.x, ValuePointer[i].Pos.y, Depth) then
      //continue;
    glPushMatrix;
      if UseIntensityColor then
        Box.OGLColor(IntensityColor(Color, ValuePointer.GetRightValue(i, WhatIsColorIntensityValue)*IntensityColorFactor))
      else
        Box.OGLColor(ValuePointer[i].Color);

      p := gluNewQuadric();
      Box.OGLTranslate3f(Koor3(ValuePointer.GetRightKoor(i, WhatIsXValue), ValuePointer.GetRightKoor(i, WhatIsYValue), Depth));
      gluDisk(p, 0, radius, 10,10);
      gluDeleteQuadric(p);
      
      if ValuePointer[i].TitleEnabled then
        begin
        glPushMatrix;
        glTranslatef(-Length(ValuePointer[i].Title)/2*5 ,radius*1.5,0);
        Box.glWrite(ValuePointer[i].Title);
        glPopMatrix;
        end;
    glPopMatrix;
    end;
end;





{ TAxis }


function TAxis.ReadVisibleRect: TKoor1Range;
var size:TKoor1Range;
begin
  case AxisKind of
    XAxisKind:
      begin
      size.Min.v:=0;
      size.Max.v:=OGLBox.Width;
      end;
    YAxisKind:
      begin
      size.Max.v:=0;
      size.Min.v:=OGLBox.Height;
      end;
  end;

  result.Min:=OGLBox.Trans2Koor(Koor1(size.Min.v, Change2Pixel(KoorKind)), KoorKind);
  result.Max:=OGLBox.Trans2Koor(Koor1(size.Max.v, Change2Pixel(KoorKind)), KoorKind);

  //WriteLn(Title.Title);
  //WriteLn(floattostr(Result.Min.v)+'        '+KoorKind2Str(Result.Min.Kind));
  //WriteLn(floattostr(Result.Max.v)+'        '+KoorKind2Str(Result.Max.Kind));
end;




procedure TAxis.writeAxisPosition(value: TAxisPosition);
begin
  FAxisPosition:=value;
  
  TempAxisPosition:=value;
end;


procedure TAxis.WriteVisibleRect(Value: TKoor1Range);
begin
  Koor.Min:=Value.Min.v;
  Koor.Max:=Value.Max.v;
end;



function TAxis.PrettyIncrement(aMinValue, aMaxValue: real; aCountTicks:integer): real;
var fak:real;
    temp:real;
    ar:TRealArray;
begin
  if aMinValue>aMaxValue then
    begin
    temp:=aMinValue;
    aMinValue:=aMaxValue;
    aMaxValue:=temp;
    end;


  if ((aMinValue-aMaxValue)=0) or (aCountTicks=0) then
    begin
    Result:=1; // nur damit nicht allzuviel dahinter abstürzt
    exit;   // dann das ist schrott
    end;

  temp:=(aMaxValue-aMinValue)/ aCountTicks;     //  temp= (100-(-100))/20  = 10
  fak:=power(10,Exponent10(temp));     //  10 --> ex=1 --> fak=10
  temp:=temp/fak;     //  10/ 10 =1
  ar:=TRealArray.Create;
  try
    ar.add(1);
    ar.add(2);
    ar.add(2.5);
    ar.add(5);
    ar.add(10);
    Result:=ChooseNearest(temp,ar)*fak;
//      showmessage('temp= '+floattostr(temp)+#13+'ChooseNearest(temp,ar)= '+floattostr(ChooseNearest(temp,ar)));
  finally
    ar.Free;
  end;
  
  
  //log
  //form1.AddLog('PrettyIncrement:');
  //form1.AddLog('VisibleKoor.Min '+floattostr(aMinValue));
  //form1.AddLog('Start Position '+floattostr(aMaxValue));
  //form1.AddLog('');
  //form1.AddLog('PrettyIncrement:');
end;




procedure TAxis.DrawArrows(Pos1, Pos2: TKoor3; bold: real; ArrowSize: real;
  BeginningPeak: boolean; EndingPeak: boolean);


  procedure DrawArrowPeak(Pos1,Pos2:TKoor3);
  var RealArrowLength:TR2Vec;
  begin
    RealArrowLength.x:=Pos2.x.v-Pos1.x.v;
    RealArrowLength.y:=Pos2.y.v-Pos1.y.v;

    glPushMatrix;
      OGlBox.OGLTranslate3f(Pos2);
      glRotatef(30,0,0,1);

      glBegin(GL_LINES);
        OGLBox.OGLColor(ColorAxis);
        OGLBox.OGLVertex3f2OGL(0,0,Depth.v, Pos2.x.Kind, Pos2.y.Kind, Depth.Kind);
        OGLBox.OGLVertex3f2OGL(-RealArrowLength.x*ArrowSize,-RealArrowLength.y*ArrowSize,Depth.v, Pos2.x.Kind, Pos2.y.Kind, Depth.Kind);
      glEnd;
    glPopMatrix;

    glPushMatrix;
      OGlBox.OGLTranslate3f(Pos2);
      glRotatef(-30,0,0,1);

      glBegin(GL_LINES);
        OGLBox.OGLColor(ColorAxis);
        OGLBox.OGLVertex3f2OGL(0,0,Depth.v, Pos2.x.Kind, Pos2.y.Kind, Depth.Kind);
        OGLBox.OGLVertex3f2OGL(-RealArrowLength.x*ArrowSize,-RealArrowLength.y*ArrowSize,Depth.v, Pos2.x.Kind, Pos2.y.Kind, Depth.Kind);
      glEnd;
    glPopMatrix;
  end;


begin
  //linie
  glBegin(GL_LINES);
    OGLBox.OGLColor(ColorAxis);

    OGLBox.OGLVertex3f(Pos1.x, Pos1.y, Depth);
    OGLBox.OGLVertex3f(Pos2.x, Pos2.y, Depth);
  glEnd;

  //pfeilspitze
  if EndingPeak then
    DrawArrowPeak(Pos1,Pos2);
  if BeginningPeak then
    DrawArrowPeak(Pos2,Pos1);
end;




procedure TAxis.DrawTicksBasic(Pos1, Pos2: TKoor3; aPos1Value, aPos2Value,  aLengthTick: real; acolor: Tcolor;  ShowFirstValue:boolean; PrettyIncre:real; DeepRecursion: integer);
var
  temp:real;
  i:Integer;
  vorzeichen:integer;
  

  function Proceed:boolean;
  begin
    if vorzeichen>0 then
      Result:=  aPos1Value+i*PrettyIncre<=aPos2Value
    else
      Result:=  aPos1Value+i*PrettyIncre>=aPos2Value;
  end;

  function GetRealLengthTickX:real;
  begin
    result:=aLengthTick/100* OGLBox.xAxis.LengthAxis;
  end;
  function GetRealLengthTickY:real;
  begin
    result:=aLengthTick/100* OGLBox.LSAxis.LengthAxis;
  end;

  function GetVerschiebenTP:real; // wegen der TickPosition
  begin
    case AxisKind of
      XAxisKind:
        case TickPosition of
          tpMin:    result:=0;
          tpMax:    result:=+GetRealLengthTickY;
          tpCenter: result:=+GetRealLengthTickY/2;
        end;
      YAxisKind:
        case TickPosition of
          tpMin:    result:=0;
          tpMax:    result:=+GetRealLengthTickX;
          tpCenter: result:=+GetRealLengthTickX/2;
        end;
    end;
  end;


  function VerschiebeLabel(text:string):TKoor3;
  const textst=7;
        CenterFaktor=1.7;
        AdditionalDistance=3;
  var  len,heig:real;
  begin
    result:=Koor3Pixel(0,0,0);
    len:=length(text)*textst;
    heig:=textst;

    //label selber
    case AxisKind of
      XAxisKind:
        case TickPosition of
          tpMin:    result.y.v:=result.y.v -heig -AdditionalDistance;
          tpMax:    result.y.v:=result.y.v +0    +AdditionalDistance ;
          tpCenter: result.y.v:=result.y.v -heig/2;
        end;
      YAxisKind:
        case TickPosition of
          tpMin:    result.x.v:=result.x.v -len -AdditionalDistance;
          tpMax:    result.x.v:=result.x.v +0   +AdditionalDistance;
          tpCenter: result.x.v:=result.x.v +len/2;
        end;
    end;

    //label in anderer Richtung zentrieren
    case AxisKind of
      XAxisKind:  result.x.v:=result.x.v -len/CenterFaktor;
      YAxisKind:  result.y.v:=result.y.v -heig/CenterFaktor;
    end;

    //transformieren
    Result:=OGLBox.TransAll(Result, kkx,kkLS,kkz, @OGLBox.TransDelta2Koor);

    //wegen tickls verschieben
    case AxisKind of
      XAxisKind:
        case TickPosition of
          tpMin:    result.y.v:=result.y.v -GetRealLengthTickY;
          tpMax:    result.y.v:=result.y.v +GetRealLengthTickY;
          tpCenter: result.y.v:=result.y.v +GetRealLengthTickY/2;
        end;
      YAxisKind:
        case TickPosition of
          tpMin:    result.x.v:=result.x.v -GetRealLengthTickx;
          tpMax:    result.x.v:=result.x.v +GetRealLengthTickx;
          tpCenter: result.x.v:=result.x.v +GetRealLengthTickx/2;
        end;
    end;
  end;


  procedure DrawLabel;
  var pos:TKoor3;
      text:string;
      zaehl,fak:integer;
  begin
    if DeepRecursion<>1 then exit;

    if aPos1Value+i*PrettyIncre<>0 then
      fak:=Exponent10(aPos1Value+i*PrettyIncre)
    else
      fak:=0;

      
    text:=PrettyFormatFloatWithMinMax(aPos1Value+i*PrettyIncre, 3, aPos1Value, aPos2Value);

    case AxisKind of
      XAxisKind:
        pos:=koor3(aPos1Value+i*PrettyIncre +VerschiebeLabel(text).x.v, VerschiebeLabel(text).y.v +Pos2.y.v ,Depth.v, Pos1.x.Kind, Pos1.y.Kind, Depth.Kind);
      YAxisKind:
        pos:=koor3(VerschiebeLabel(text).x.v+Pos2.x.v, aPos1Value+i*PrettyIncre +VerschiebeLabel(text).y.v,Depth.v, Pos1.x.Kind, Pos1.y.Kind, Depth.Kind);
    end;

    tex.Enable;
    glPushMatrix;
    //OGLBox.OGLTranslate3f(pos.x,pos.y,Koor1(Depth.v+1, Depth.Kind));
    OGLBox.OGLTranslate3f(pos);
    OGLBox.glWrite(text);
    glPopMatrix;
    tex.Disable;
  end;


begin
  if DeepRecursion<0 then exit;

  if aPos1Value>aPos2Value then
    vorzeichen:=-1
  else
    vorzeichen:=1;
    

  i:=0;
  while Proceed do
    begin
    if (i<>0) or  (i=0) and ShowFirstValue then
      DrawLabel;

    temp:= aPos1Value+(i+vorzeichen)*PrettyIncre;
    temp:=MakeInRange(temp, aPos1Value, aPos2Value);
    DrawTicksBasic(Pos1,Pos2,aPos1Value+i*PrettyIncre, temp , LengthTick , ColorTicks, ShowFirstValue, PrettyIncre/CountTicks, DeepRecursion-1);    // Rekursion !!!!!

    //Ticks and Cross
    glBegin(GL_LINES);
      OGLBox.OGLColor(acolor);

      case AxisKind of
        XAxisKind:
          begin
          temp:=aPos1Value+i*PrettyIncre;
          OGLBox.OGLVertex3f(temp,Pos2.y.v+GetVerschiebenTP,Depth.v, Pos1.x.Kind, Pos1.y.Kind, Depth.Kind);
          OGLBox.OGLVertex3f(temp,-GetRealLengthTickY+Pos2.y.v+GetVerschiebenTP,Depth.v, Pos1.x.Kind, Pos1.y.Kind, Depth.Kind);

          if DeepRecursion=1 then
            BigTickPositions.add(temp);
          end;
        YAxisKind:
          begin
          temp:=aPos1Value+i*PrettyIncre;
          OGLBox.OGLVertex3f(Pos2.x.v +GetVerschiebenTP, temp,Depth.v, Pos1.x.Kind, Pos1.y.Kind, Depth.Kind);
          OGLBox.OGLVertex3f(-GetRealLengthTickX +Pos2.x.v+GetVerschiebenTP, temp ,Depth.v, Pos1.x.Kind, Pos1.y.Kind, Depth.Kind);

          if DeepRecursion=1 then
            BigTickPositions.add(temp);
          end;
      end;
    glEnd;

    i:=i+vorzeichen;
    end;
end;




procedure TAxis.DrawTicks(Pos1,Pos2:TKoor3; aPos1Value,aPos2Value, aLengthTick:real; aCountTicks:integer;  acolor:Tcolor; CenterTicks:boolean=true);
var Center:TKoor3;
    c, incre:real;
begin
  BigTickPositions.clear;


  incre:= PrettyIncrement(aPos1Value,aPos2Value,aCountTicks);
  c:= round( (aPos1Value+aPos2Value) /(2*incre)  )*incre;

  case AxisKind of
    XAxisKind: Center:=Koor3( c ,Pos2.y.v, 0, Pos1.x.Kind, Pos2.y.Kind, Depth.Kind);
    YAxisKind: Center:=Koor3(Pos2.x.v, c, 0, Pos2.x.Kind, Pos1.y.Kind, Depth.Kind);
  end;
  DrawTicksBasic(Center, Pos1, c, aPos1Value, aLengthTick,  acolor, true, incre);
  DrawTicksBasic(Center,Pos2, c,aPos2Value, aLengthTick,  acolor, false, incre);
end;





procedure TAxis.DrawTitle(Pos1,Pos2:TKoor3);


  function VerschiebeLabel:TKoor3;
  const CenterFaktor=1.7;
        XAdditionalDistancetoAxis=30;
        YAdditionalDistancetoAxis=0;
        AdditionalDistancetoWall=10;
  var  len,heig:real;
  begin
    result:=Koor3Pixel(0,0,0);
    len:=OGLBox.TransDelta2Koor(Koor1(Title.TextLenght, kkOGLRealityx), kkPixelx).v;
    heig:=OGLBox.TransDelta2Koor(Koor1(Title.TextHeight, kkOGLRealityy), kkPixely).v;

    //ecke setzten, sodass der Eckpunkt nach ganz außen gesetzt wird
    case AxisKind of
      XAxisKind:
        case TitlePosition.MainPosition of
          lpMin:    Title.PosXIs:=akLeft;
          lpMax:    Title.PosXIs:=akRight;
          lp0:      Title.PosXIs:=akLeft;
          lpCenter: Title.PosXIs:=akLeft;
        end;
      YAxisKind:
        case TitlePosition.MainPosition of
          lpMin:    Title.PosYIs:=akBottom;
          lpMax:    Title.PosYIs:=akTop;
          lp0:      Title.PosYIs:=akBottom;
          lpCenter: Title.PosYIs:=akBottom;
        end;
    end;


    //ecke setzten, sodass der Eckpunkt nach innen gesetzt wird
    case AxisKind of
      XAxisKind:
        case TitlePosition.SidePosition of
          lpMin:    Title.PosYIs:=akTop;
          lpMax:    Title.PosYIs:=akBottom;
          lp0:      Title.PosYIs:=akBottom;
          lpCenter: Title.PosYIs:=akBottom;
        end;
      YAxisKind:
        case TitlePosition.SidePosition of
          lpMin:    Title.PosXIs:=akRight;
          lpMax:    Title.PosXIs:=akLeft;
          lp0:      Title.PosXIs:=akLeft;
          lpCenter: Title.PosXIs:=akLeft;
        end;
    end;
    
    

    // abstand zur achse
    case AxisKind of
      XAxisKind:
        case TitlePosition.SidePosition of
          lpMin:      result.y.v:=result.y.v-XAdditionalDistancetoAxis;
          lpMax, lp0: result.y.v:=result.y.v+XAdditionalDistancetoAxis;
        end;
      YAxisKind:
        case TitlePosition.SidePosition of
          lpMin:      result.x.v:=result.x.v-YAdditionalDistancetoAxis;
          lpMax, lp0: result.x.v:=result.x.v+YAdditionalDistancetoAxis;
          lpCenter:;
        end;
    end;


    // abstand zur wand
    case AxisKind of
      XAxisKind:
        case TitlePosition.MainPosition of
          lpMin:   result.x.v:=result.x.v+AdditionalDistancetoWall;
          lpMax:   result.x.v:=result.x.v-AdditionalDistancetoWall;
          lpCenter, lp0: result.x.v:=result.x.v -len/CenterFaktor;
        end;
      YAxisKind:
        case TitlePosition.MainPosition of
          lpMin:   result.y.v:=result.y.v+AdditionalDistancetoWall;
          lpMax:   result.y.v:=result.y.v-AdditionalDistancetoWall;
          lpCenter, lp0: result.y.v:=result.y.v -heig/CenterFaktor;
        end;
    end;

    //transformieren
    Result:=OGLBox.TransAll(Result, @OGLBox.TransDelta2OGLReality);
  end;
  

begin
  case TitlePosition.MainPosition of
    lpMin:    Title.pos:=OGLBox.TransAll(koor3(Pos1.x, Pos1.y, Depth), @OGLBox.Trans2OGLReality);
    lpMax:    Title.pos:=OGLBox.TransAll(koor3(Pos2.x, Pos2.y, Depth), @OGLBox.Trans2OGLReality);
    lpCenter: Title.pos:=OGLBox.TransAll(koor3(Pos1.x.v+(Pos2.x.v-Pos1.x.v)/2, Pos1.y.v+(pos2.y.v-Pos1.y.v)/2, Depth.v, Pos1.x.Kind, Pos1.y.Kind, Depth.Kind), @OGLBox.Trans2OGLReality);
    lp0:
      case AxisKind of
        XAxisKind: Title.pos:=OGLBox.TransAll(koor3(MakeInRange(0,Pos1.x.v,pos2.x.v), pos2.y.v, Depth.v, Pos1.x.Kind, Pos2.y.Kind, Depth.Kind), @OGLBox.Trans2OGLReality);
        YAxisKind: Title.pos:=OGLBox.TransAll(koor3(pos1.x.v, MakeInRange(0,Pos1.y.v,pos2.y.v), Depth.v, Pos1.x.Kind, Pos1.y.Kind, Depth.Kind), @OGLBox.Trans2OGLReality);
      end;
  end;

  if TitlePosition.AutoSidePosition then
    case TempAxisPosition of
      apMin: TitlePosition.SidePosition:=lpMax;
      apMax: TitlePosition.SidePosition:=lpMin;
      ap0:   TitlePosition.SidePosition:=lpMin;
    end;
  
  Title.pos:=koor3(Title.pos.x.v+VerschiebeLabel.x.v, Title.pos.y.v+VerschiebeLabel.y.v, Title.pos.z.v, Title.pos.x.Kind, Title.pos.y.Kind, Title.pos.z.Kind);
  
  Title.Draw;
end;

function TAxis.KoorSize: real;
begin
  Result:=Koor.Max-Koor.Min;
end;

procedure TAxis.ResetKoor;
begin
  Koor:=DefaultKoor;
end;



procedure TAxis.Draw(Pos1,Pos2:TKoor3;  bold:real; ArrowSize:real);
var temp:real;
begin
  case AxisKind of
    XAxisKind:
      begin
      VisibleKoor.Min:=Pos1.x.v;
      VisibleKoor.Max:=Pos2.x.v;

      LabelSpace:=OGLBox.TransDelta2Koor(Koor1(30, kkOGLRealityy), LabelSpace.Kind);

      case TempAxisPosition of
        apMin: RInc(Pos1.y.v, Pos2.y.v, LabelSpace.v);
        apMax: RInc(Pos1.y.v, Pos2.y.v, -LabelSpace.v);
      end;
      end;
    YAxisKind:
      begin
      VisibleKoor.Min:=Pos1.y.v;
      VisibleKoor.Max:=Pos2.y.v;

      temp:=20+6*length(PrettyFormatFloatWithMinMax(VisibleKoor.Min+(VisibleKoor.Max-VisibleKoor.Min)/2, 3, VisibleKoor.Min, VisibleKoor.Max));
      LabelSpace:=OGLBox.TransDelta2Koor(Koor1(temp, kkOGLRealityx), LabelSpace.Kind);

      case TempAxisPosition of
        apMin: RInc(Pos1.x.v, Pos2.x.v, LabelSpace.v);
        apMax: RInc(Pos1.x.v, Pos2.x.v, -LabelSpace.v);
      end;
      end;
  end;


  LengthAxis:=sqrt(sqr(Pos1.x.v-Pos2.x.v)+sqr(Pos1.y.v-Pos2.y.v));

  if not Visible then  // darf nicht weiter nach ober, da die konstanten von anderen achsen gebraucht werden
    begin
    LabelSpace.v:=0;
    exit;
    end;

    
  DrawArrows(Pos1, Pos2, bold, ArrowSize,   false);
  DrawTicks(Pos1, Pos2, VisibleKoor.Min, VisibleKoor.Max, LengthBigTick , CountBigTicks, ColorBigTicks);
  DrawTitle(Pos1, Pos2);
end;



procedure TAxis.DrawMainGrid(Pos1, Pos2: TKoor3;  OtherAxis: TAxis; bold: real);
var i:integer;
begin
  OGLBox.OGLColor(ColorMainGrid);
  for i := 0 to OtherAxis.BigTickPositions.count-1 do
    begin
    case AxisKind of
      XAxisKind:
        begin
        Pos1.y:=Koor1(OtherAxis.BigTickPositions[i], OtherAxis.KoorKind);
        Pos2.y:=Koor1(OtherAxis.BigTickPositions[i], OtherAxis.KoorKind);
        end;
      YAxisKind:
        begin
        Pos1.x:=Koor1(OtherAxis.BigTickPositions[i], OtherAxis.KoorKind);
        Pos2.x:=Koor1(OtherAxis.BigTickPositions[i], OtherAxis.KoorKind);
        end;
    end;
    
    glBegin(GL_LINES);
      OGLBox.OGLVertex3f(Pos1.x, Pos1.y, Depth);
      OGLBox.OGLVertex3f(Pos2.x, Pos2.y, Depth);
    glEnd;
    end;
end;




constructor TAxis.Create(aAxisKind: TAxisKind);
begin
  inherited create;

  BigTickPositions:=TRealArray.Create;
  Visible:=true;
  Depth:=Koor1(0,kkz);
  AxisKind:=aAxisKind;
  case aAxisKind of
    YAxisKind:
      begin
      KoorKind:=kkLS;
      LabelSpace:=Koor1(0, kkx);
      end;
    XAxisKind:
      begin
      KoorKind:=kkx;
      LabelSpace:=Koor1(0, kkLS);
      end;
  end;
  TickPosition:=tpMin;
  LabelPosition:=lp0;
  TitlePosition.MainPosition:=lpMax;
  TitlePosition.SidePosition:=lpMin;
  TitlePosition.AutoSidePosition:=true;
  CountBigTicks:=14;
  CountTicks:=10;
  LengthBigTick:=1;
  LengthTick:=0.3;
  LengthAxis:=100;
  AxisPosition:=apMin;
  AxisAlwaysVisible:=true;
  ColorAxis:=clWhite;
  ColorTicks:=IntensityColor(ColorAxis, 0.4);
  ColorBigTicks:=IntensityColor(ColorAxis, 0.8);
  ColorMainGrid:=IntensityColor(ColorAxis, 0.5);
  ShowMainGrid:=false;

  Title:=TOGlLabelBackground.Create;
  Title.Color:=ColorAxis;
  Title.BackgroundColor:=GegenFarbe(ColorAxis);
  Title.PosXIs:=akRight;
  Title.PosYIs:=akTop;

  case AxisKind of
    XAxisKind:
      begin
      VisibleKoor.Min:=-90;
      VisibleKoor.Max:=90;
      end;
    YAxisKind:
      begin
      VisibleKoor.Min:=-0.4;
      VisibleKoor.Max:=1.2;
      end;
  end;

  Koor:=VisibleKoor;
  DefaultKoor:=VisibleKoor;
end;


destructor TAxis.Destroy;
begin
  Title.Free;
  BigTickPositions.Free;

  inherited Destroy;
end;



{ TOGlLabel }

function TOGlLabel.TextLenght: real;
var i,len:integer;
begin
  len:=0;
  for i:=0 to DividedStrings.Count-1 do
    len:=max(len,Length(DividedStrings[i]));

  result:=OGLBox.TransDelta2OGLReality(Koor1(OGLBox.Font.Size*len/1.3 , kkPixelx)).v;
end;

procedure TOGlLabel.setFText(const AValue: string);
var sep:TStringList;
begin
  FText:=AValue;

  sep:=TStringList.Create;
  sep.Add(#13);

  DividedStrings.Clear;
  DivideString(AValue, Sep, DividedStrings);

  sep.Free;
end;

function TOGlLabel.TextHeight: real;
begin
  result:=OGLBox.TransDelta2OGLReality(Koor1( OGLBox.Font.Size*0.4, kkPixely)).v;
end;







procedure TOGlLabel.Draw;
var dx,dy:real;
  i:integer;
begin
  if not Enabled then
    exit;

  glPushMatrix;

    glColor3f(Red(Color),Green(Color),Blue(Color));
    dx:=0;
    dy:=0;
    if  PosXIs=akRight then
      dx:=-TextLenght;
    if  PosYIs=akTop then
      dy:=-TextHeight;

    glTranslatef(pos.x.v+dx, pos.y.v+dy, pos.z.v);
    for i := 0 to DividedStrings.Count-1 do
      begin
      glTranslatef(0, -TextHeight*i*2, 0);
  //    glScalef(Font.Size/10,Font.Size/10, 1);
      OGLBox.glWrite(DividedStrings[i]);
      end;

  glPopMatrix;
end;

constructor TOGlLabel.Create;
begin
  inherited;
  
  Enabled:=true;
  pos:=koor3(0,0,0, kkx, kkLS, kkz);
  DividedStrings:=TStringList.Create;
  FText:='';

  PosXIs:=akLeft;
  PosYIs:=akBottom;
end;


destructor TOGlLabel.Destroy;
begin
  DividedStrings.Free;

  inherited Destroy;
end;



{ TOGLRect }

procedure TOGLRect.Draw(Depth: TKoor1);
begin
  Draw(r, Depth);
end;

procedure TOGLRect.Draw(Position: TR2RectSimple; Depth: TKoor1);
begin
  if not Visible then
    exit;

  //linie
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

  glBegin(GL_LINE_LOOP);
    glColor4f(red(Pen.Color),Green(Pen.Color),Blue(Pen.Color),PenAlpha);
    glLineWidth(Pen.Width);
    
    glVertex3f(Position.Left,Position.Bottom,Depth.v);
    glVertex3f(Position.Right,Position.Bottom,Depth.v);
    glVertex3f(Position.Right,Position.Top,Depth.v);
    glVertex3f(Position.Left,Position.Top,Depth.v);

  glEnd;

  glDisable(GL_BLEND);


  if Filled then
    begin
    //linie
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE);

    glBegin(GL_QUADS);
      glColor4f(red(Pen.Color),Green(Pen.Color),Blue(Pen.Color),BrushAlpha);

      glVertex3f(Position.Left,Position.Bottom,Depth.v);
      glVertex3f(Position.Right,Position.Bottom,Depth.v);
      glVertex3f(Position.Right,Position.Top,Depth.v);
      glVertex3f(Position.Left,Position.Top,Depth.v);
      
    glEnd;

    glDisable(GL_BLEND);
    end;
end;

constructor TOGLRect.Create;
begin
  inherited;
  
  pen:=TPen.Create;
  pen.Color:=clBlue;

  BrushColor:=clBlue;
  BrushAlpha:=50;
  PenAlpha:=1;
  BrushAlpha:=0.2;
  Filled:=true;
  Visible:=false;
end;

destructor TOGLRect.Destroy;
begin
  pen.Free;

  inherited Destroy;
end;



{ TOGlLabelBackground }

procedure TOGlLabelBackground.Draw;
const VerschX=-2;
      VerschY=3;
      Zeilenabstandsfaktor=1.3;
var d: TR2Vec;
    rand:TR2Vec;
begin
  inherited;

  if not Enabled then
    exit;

  rand:=R2Vec(5,5);

  glPushMatrix;
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


    d:=R2Vec(0,0);
    if  PosXIs=akRight then
      d.x:=-TextLenght;
    if  PosYIs=akTop then
      d.y:=-TextHeight;

    glColor4f(Red(BackgroundColor),Green(BackgroundColor),Blue(BackgroundColor), BackgroundAlpha);
    glTranslatef(pos.x.v+d.x+VerschX, pos.y.v+d.y+VerschY, pos.z.v-0.001);


    glBegin(GL_QUADS);

      glVertex3f(-rand.x,TextHeight+rand.y,0);
      glVertex3f(-rand.x,-rand.y-TextHeight*Zeilenabstandsfaktor*DividedStrings.Count,0);
      glVertex3f(TextLenght+rand.x,-rand.y-TextHeight*Zeilenabstandsfaktor*DividedStrings.Count,0);
      glVertex3f(TextLenght+rand.x,TextHeight+rand.y,0);

    glEnd;


    glDisable(GL_BLEND);
  glPopMatrix;
end;

constructor TOGlLabelBackground.Create;
begin
  inherited;
  
  BackgroundColor:=clBlack;
  BackgroundAlpha:=0.5;
end;

destructor TOGlLabelBackground.Destroy;
begin
  inherited;
end;




{ TBorderdBackgroundChart }

procedure TBorderdBackgroundChart.DrawOGL;
var i:integer;
begin
  inherited DrawOGL;

  if not Visible then
    exit;

  glPushMatrix;
  //linie
  glDisable(GL_DEPTH_TEST);
  glEnable(GL_BLEND);
  glBlendFunc(GL_ONE, GL_ONE);

  //glBegin(GL_LINE_STRIP);

    //Box.OGLColor(IntensityColor(Color, 0.2*IntensityColorFactor));
    //for i := 0 to ValuePointer.count-1 do
      //Box.OGLVertex3f(ValuePointer[i].Pos.x.v, ValuePointer[i].Pos.y.v-aperture.LaserHeight/2, Depth.v, ValuePointer[i].Pos.x.Kind, ValuePointer[i].Pos.y.Kind, Depth.Kind);
  //glEnd;
  //glBegin(GL_LINE_STRIP);

    //for i := 0 to ValuePointer.count-1 do
      //Box.OGLVertex3f(ValuePointer[i].Pos.x.v, ValuePointer[i].Pos.y.v+aperture.LaserHeight/2, Depth.v, ValuePointer[i].Pos.x.Kind, ValuePointer[i].Pos.y.Kind, Depth.Kind);
  //glEnd;
  glBegin(GL_LINE_STRIP);

    Box.OGLColor(IntensityColor(Color, IntensityColorFactor));
    for i := 0 to ValuePointer.count-1 do
      Box.OGLVertex3f(ValuePointer.GetRightValue(i, WhatIsXValue), ValuePointer.GetRightValue(i, WhatIsYValue), Depth.v, ValuePointer.GetRightKoor(i, WhatIsXValue).Kind, ValuePointer.GetRightKoor(i, WhatIsYValue).Kind, Depth.Kind);
  glEnd;

  glDisable(GL_BLEND);
  glEnable(GL_DEPTH_TEST);
  glPopMatrix;
end;


{ TOGL3DNSlit }

procedure TOGL3DNSlit.DrawOGL;
const gridcount=11;
var r,g,b:byte;
    q:PGLUquadric;
    i:integer;
    LaserPunkt:TVec;
begin
  if not Visible
    or(AutoVisible and (beta=0) and (theta=0)) then
    exit;

  gluPerspective(90, 1{OGLBox.OGLReality.width/OGLBox.OGLReality.height}, znear, zfar);  	// Perspektive den neuen Maßen anpassen.


  glPushMatrix;
    glTranslatef(Pos.x.v+SpaceToBorder.x.v, Pos.y.v+SpaceToBorder.y.v, -1+SpaceToBorder.z.v);
    glScalef(Sizes.x.v, Sizes.y.v, Sizes.z.v);  // das macht das Gitter flach


    //zeichne LaserStrahl
    glPushMatrix;
      if SaS.count>0 then
        LaserPunkt:=1/2*SaS.Screen[0].SingleSlit.CalcGzVec; // denn gz liegt ja in der x-Mitte des gezeichneten Gitters
                                                                                      //x ist im Koordinatensystem on OpenGL jetzt gemeint
      glTranslatef(LaserPunkt.x2,LaserPunkt.x3, LaserPunkt.x1);

      ColorValues(clRed, r,g,b);
      glColor3f(r/255,g/255,b/255);

      q:=gluNewQuadric();
      gluCylinder(q, 0.02, 0.02, 2, 12, 1);
      gluDeleteQuadric(q);
    glPopMatrix;



    glRotatef(-90, 1,0,0);  //damit die z-Achse nach oben und nicht nach vorne geht
    glRotatef(-90, 0,0,1);  //damit die z-Achse nach oben und nicht nach vorne geht

    glRotatef(BogtoRad(beta), 0,0,1);  // in der Reihenfolge, da er die z- Achse mitdreht!!!

    //zeichne beta
    glPushMatrix;
      glScalef(0.8,0.8,0.8);
      ColorValues(clBlue, r,g,b);
      glColor3f(r/255,g/255,b/255);

      q:=gluNewQuadric();
      gluPartialDisk(q, 0, 1, 10, 1, 0, BogtoRad(beta));
      gluDeleteQuadric(q);
    glPopMatrix;


    glRotatef(BogtoRad(theta), 0,1,0);  // führe die 2. Rotation aus

    glTranslatef(0,-0.5,0);  //gehe in die mitte der y -Achse

    //zeichne theta
    glPushMatrix;
      glRotatef((90), 1,0,0);  //rotiere wieder zurück
      glScalef(0.8,0.8,0.8);      // das macht das Gitter flach
      ColorValues(clGreen, r,g,b);
      glColor3f(r/255,g/255,b/255);

      q:=gluNewQuadric();
      gluPartialDisk(q, 0, 1, 10, 1, 0, -BogtoRad(theta));
      gluDeleteQuadric(q);
    glPopMatrix;


    glScalef(0.1,1,1);      // das macht das Gitter flach


//    q:=gluNewQuadric();
//    gluCylinder(q, 0.1, 0.1, 5, 12, 1);
//    gluDeleteQuadric(q);


    ColorValues(ColorGrid, r,g,b);
    glColor3f(r/255,g/255,b/255);
    glBegin(GL_LINES);
      for i := 0 to gridcount do
        begin
        glVertex3f(0,i/gridcount,0);
        glVertex3f(0,i/gridcount,1);
        end;
    glEnd;



    //ColorValues(ColorTop, r,g,b);
    //glColor3f(r/255,g/255,b/255);
    //glBegin(GL_QUADS);
      //glVertex3f(0,0,1);
      //glVertex3f(0,1,1);
      //glVertex3f(1,1,1);
      //glVertex3f(1,0,1);
    //glEnd;

    //ColorValues(ColorBottom, r,g,b);
    //glColor3f(r/255,g/255,b/255);
    //glBegin(GL_QUADS);
      //glVertex3f(0,0,0);
      //glVertex3f(0,1,0);
      //glVertex3f(1,1,0);
      //glVertex3f(1,0,0);
    //glEnd;
  glPopMatrix;

  //glOrtho(OGLBox.OGLReality.Left, OGLBox.OGLReality.Right, OGLBox.OGLReality.Bottom, OGLBox.OGLReality.Top,  znear,  zfar);
end;

constructor TOGL3DNSlit.Create(aPos, aSpaceToBorder, aSizes: TKoor3);
begin
  inherited create;

  Sizes:=aSizes;
  Pos:=aPos;
  SpaceToBorder:=aSpaceToBorder;
  Visible:=true;
  AutoVisible:=true;
  ColorGrid:=clWhite;
  Colorbeta:=clBlue;
  Colortheta:=clGreen;
  beta:=0;
  theta:=0;
end;


end.

