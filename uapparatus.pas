{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie können es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    veröffentlicht, weitergeben und/oder modifizieren, gemäß Version 2 der Lizenz.
 Description:

  alpha is the horizontal angle of the laser light
    alpha= 0° (or 0) means that the laser light has 90° to the screen, where you can see the laser point
    alpha=90° (or pi/2) means that this will never hit a wall. It is parralel to the screen
    BUT: Alpha is not the angle which you see at the screen.
      Alpha ist the angle that is inside of the Grid. Alpha is that transformed with Refraction (is wanted)
        and with the x-Deflection (when theta<>0)
    
  beta is the horizontal angle of the slit
    beta=0° (or 0) means that the horizontal axis of the slit('s) are parralel to the screen (or wall)
    beta =90° (or pi/2) means that the laser light doesn't go though the slit, beacause the horizontal axis
                        of the slit('s) are  identical (parallel and same koordinates)

  gamma is the vertical angle of the laser light
    gamma= 0° (or 0) means that the laser light has 90° to the screen, where you can see the laser point
    gamma=90° (or pi/2) means that this will never hit a wall. It is parralel to the screen

  theta is the vertical angle of the slit
    theta=0° (or 0) means that the vertical axis of the slit('s) are parralel to the screen (or wall)
    theta =90° (or pi/2) means that the laser light doesn't go though the slit, beacause the vertical axis
                        of the slit('s) are  identical (parallel and same koordinates)
-----------------------------------------------------------------------------}

//{$DEFINE ExtraInfos}
//{$DEFINE CalcTimes}

unit Uapparatus;


interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Math,unit1,comCtrls,uanderes, UChart, LResources, spin, UMathe, UVector;

  
  

type


  TLSAxisType=(LSAmplitude,LSIntensity);
  TxAxisType=(xAngle,xMeter,xlambda);
  TImageAxisType=(ImageAngle,ImageMeter);
  TMySlitType=(MySingle,MyN,MyCombi,MyImage);
  TMinMaxStaus=(mmsMin, mmsMainMax, mmsMinorMax, mmsNoMinMax, mmsEnd);
  TInterestingFunctionType= function(n:integer):extended   of object ;
  TMinMaxFunctionType= function (z:integer; var Value:extended):TMinMaxStaus of object;



  {-----------------------------------------------------------------------------
   Class:   TSingleSlit
   Description:   Dies ist die klasse mit der alles beginnt
                  Hier sind die wichtigen Methoden, Felder für den einfach/n-fach Spalt
                    integriert
                  Ich hätte auch eine TSlit klasse schreiben können, die die
                    abstrakten Methoden deklarationen enthält und damit das Interface schafft,
                    aber es ist absolut gleichertig, ob ich eine Vorfahrklasse mit abstrakten Methoden
                    deklariere und dann TSingleSlit=class(TSlit)  mache, oder gleich alles hier
  -----------------------------------------------------------------------------}

  { TSingleSlit }

  TSingleSlit=class(TComponent)
  private
    SlitType:TMySlitType;
    UseMaxMin,
    CalcMaxima,
    CalcMinima:boolean;
    Fnumber:byte;
    Factive:boolean;
    dialog:TColorDialog;
    ChartMinMax:TPointChart;
    box:TOGlBox;
    FForm:TForm;
    CheckSTRGOnMouseDown,
    CheckSTRGMaxMinOnMouseDown,
    WasRealKlick,
    FVisible:boolean;
    
    ShowMaxLabels,
    ShowMinLabels:boolean;

    procedure WriteFForm(Form:TForm);
    procedure setactive(value:boolean);  virtual;
    procedure setVisible(value:boolean);

    procedure OnColorChange(Sender: TObject);
    procedure ColorOnClick(Sender: TObject);
    procedure CheckChange(Sender: TObject);
    procedure CheckOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure CheckMaxMinClick(Sender: TObject);
    procedure CheckMaxMinOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure writeCaption(var checkbox:TCheckbox);         virtual;

    function AngleOfVec(s:TVec; angleKind:TAngleKind):extended;
    function KoorStrechtedOfVec(s:TVec; XYZKind:TXYZKind):extended;

    function XAngleOfVec(s:TVec):extended;
    function PathDifferenceOfVec(s:TVec):extended; virtual;
    function YAngleOfVec(s:TVec):extended;
    function XKoorStrechtedOfVec(s:TVec):extended;
    function YKoorStrechtedOfVec(s:TVec):extended;

    function CalcAngleDeflectionVec(alpha:extended):TVec;  overload;

    function MaxFunc(z:integer; var s:TVec):TMinMaxStaus;  //nicht belegt! // geteilt, damit ich die leerstellen mitzählen kann
    function MinFunc(z:integer; var s:TVec):TMinMaxStaus;  // geteilt, damit ich die leerstellen mitzählen kann
    function MaxFunc(z:integer; var alpha:Extended):TMinMaxStaus; virtual; //nicht belegt! // geteilt, damit ich die leerstellen mitzählen kann
    function MinFunc(z:integer; var alpha:Extended):TMinMaxStaus; virtual;  // geteilt, damit ich die leerstellen mitzählen kann

    
//    function  getInterestingPointInfo(var CountPoints:word):TInterestingFunctionType;  virtual;

    function  getLSFunc(LSAxisType:TLSAxisType):TFunctionVecType; virtual;
    function  getXFunc(xAxisType:TxAxisType):TFunctionVecType;
//    function  getAntiXFunc(xAxisType:TxAxisType):TFunctionVecType;
    function  getImageFunc(ImageAxisType:TImageAxisType):TFunctionVecType;

    procedure DelUnVisibleValues;
    procedure CalcMinMax(xAxisType:TxAxisType; LSAxisType:TLSAxisType; ImageAxisType:TImageAxisType;  percision:word=0); virtual;
  public
    Values,
    ValuesMaxMin:TChartValueArray;
    Chart:TChart;
    NewCalculatedPoints:integer;
    check:TCheckbox;
    checkMaxMin:TCheckbox;
    LED:TALED;
    CalcGamma:boolean;

                              //alle alphas im bogenmaß; alpha ist der winkel zur optischen achse
    function OneSlitAmplitude(s:TVec):extended;   // Formel die Für 1 Spalte Stimmt
    function OneSlitIntensity(s:TVec):extended;   // Formel die Für 1 Spalte Stimmt
                              //alle alphas im bogenmaß; alpha ist der winkel zur optischen achse

    function CalcGyVec:TVec;
    function CalcGzVec:TVec;
    function CalcMinMaxAlpha(TheSign:shortint):extended;
    function CalcMinAlpha:extended;
    function CalcMaxAlpha:extended;


    function GammaAngleBog(s:TVec):extended;
    function GammaAngleDeg(s:TVec):extended;
    function GammaMeter(s:TVec):extended;

    procedure getspecifications;
    procedure Calc(xAxisType:TxAxisType; LSAxisType:TLSAxisType; ImageAxisType:TImageAxisType; Quality:real=5.5); virtual;
    procedure DrawOGL; virtual;
    procedure RefreshChecked; virtual;

    procedure MakeRightColor;

    property active:boolean	 read Factive write  setactive;           //das greift im hintergrund eigentlich nur auf lambda zu
    property Visible:boolean read FVisible write setVisible;
    property number:byte read Fnumber;
    property Form:TForm read FForm write WriteFForm;

    constructor create(AOwner: TComponent; aForm:TForm1; abox:TOGlBox; anumber:byte; aCreateMaxMin:boolean); virtual;
    destructor Destroy;   override;
  end;


  {-----------------------------------------------------------------------------
   Class:   TRSNSlit
   Description: Abgleitete Klasse von TSingleSlit
                Hat nur wenige erweiterungen, doch die sind absolut nötig. Oft werden die
                Methoden von TSingleSlit benutzt
  -----------------------------------------------------------------------------}

  { TRSNSlit }

  TRSNSlit=class(TSingleSlit)
  private                  //alle alphas im bogenmaß; alpha ist der winkel zur optischen achse
    procedure writeCaption(var checkbox:TCheckbox);         override;

    //function alpha2lambda(alpha:extended):extended; override;
    //function lambda2alpha(lambda:extended):extended;   override;

    function PathDifferenceOfVec(s: TVec): extended; override;

    function MaxFunc(z:integer; var alpha:Extended):TMinMaxStaus; override;
    function MinFunc(z:integer; var alpha:Extended):TMinMaxStaus; override;  //nicht belegt!

    //function  getInterestingPointInfo(var CountPoints:word):TInterestingFunctionType;  override;
    function  getLSFunc(LSAxisType:TLSAxisType):TFunctionVecType;  override;
  public
    function NSlitAmplitude(s:TVec):extended;
    function NSlitIntensity(s:TVec):extended;

    constructor create(AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte; aCreateMaxMin:boolean); override;
  end;
                       {-----------------------------------------------------------------------------
   Class:   TCombiSlit
   Description:  Hier wäre es pratisch wenn man die Methoden von 2 Klassen ableiten könnte,
                 doch da das nicht geht muss ich irgendwie auf die Methoden von  TRSNSlit zugreifen
                 das mache ich so:
                 Die Methodennamen so wählen, dass ich auf TSingleSlit Methoden und auf
                   TRSNSlit Methoden zugreifen kann.
   -----------------------------------------------------------------------------}
  TCombiSlit=class(TRSNSlit)
  private                   //alle alphas im bogenmaß; alpha ist der winkel zur optischen achse
    procedure writeCaption(var checkbox:TCheckbox);         override;

    function  getLSFunc(LSAxisType:TLSAxisType):TFunctionVecType;  override;

    function ApproxCombiSlitAmplitude(s:TVec):extended;
    function HuygensCombiSlitAmplitude(s:TVec):extended;
  public
    function CombiSlitAmplitude(s:TVec):extended;
    function CombiSlitIntensity(s:TVec):extended;

    constructor create(AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte; aCreateMaxMin:boolean);   override;
  end;

  {-----------------------------------------------------------------------------
   Class:   TImageIntensity
   Description:   Nutzt TCombiSlit  und die hauptsache, ist das hier kein Graph
                    dargestellt wird, sondern ein bmp und dies als Hintergrund des Diagramms genommen wird
                    deshalb ist die Hauptsache hier die ersetzte Calc Methode
  -----------------------------------------------------------------------------}

  { TImageIntensity }

  TImageIntensity=class(TCombiSlit)
  private
    //procedure Draw2ColorLine(xPos1,xPos2:word; Col1,Col2:TColor; Intensity1,Intensity2:real);
    //procedure DrawColorLine(xPos1,xPos2:word; Col:TColor; Intensity:real);
    //procedure DrawPixel(xPos:word; Col:TColor; Intensity:real);
    procedure writeCaption(var checkbox:TCheckbox);         override;
  public
    procedure DrawOGL; override;

    constructor create(AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte; aCreateMaxMin:boolean);  override;
    destructor Destroy; override;
  end;



  {-----------------------------------------------------------------------------
   Class:   TArrayItem
   Description:    Die Klasse kapselt ein paar Sachen, die wichtig sind für ein Array Item später.
                      Also z.B. ob es jetzt aktiv ist, oder welche Nummer bzw. Index es hat.
  -----------------------------------------------------------------------------}

  { TArrayItem }

  TArrayItem=class(TComponent)
  private
    FForm:TForm1;
    Factive:boolean;
    Fnumber:byte;

    procedure WriteFForm(Form:TForm1);
    procedure setactive(value:boolean); virtual;
  public
    property active:boolean	 read Factive write  setactive;           //das greift im hintergrund eigentlich nur auf lambda zu
    property number:byte read Fnumber;
    property Form:TForm1 read FForm write WriteFForm;

    constructor create(AOwner: TComponent; aForm:TForm1;  anumber:byte);  virtual;
  end;


  TUsedFormula=(UFApprox, UFHuygens);

  {-----------------------------------------------------------------------------
   Class:   TScreem
   Description: Kapselt den gesamten Bildschirm und was dazu gehört:
                  SingleSlit,  NSlit, CombiSlit, ImageIntensity
                So ist TScreem der Bildschirm und zeichnet auch selbstständig die Kurven auf
                Gleichrangig zu Tsource und Taperture
  -----------------------------------------------------------------------------}

  { TScreem }

  TScreem=class(TArrayItem)
  private
    FColor:TColor;
    FBox:TOGlBox;

    procedure LabelChart(xAxis:TxAxisType; LSaxis:TLSAxisType; ImageAxis:TImageAxisType);   overload;
    procedure LabelChart;                                       overload;
    procedure Calc(bSingleSlit,bNSlit,bCombiSlit,bImage:boolean; Quality:real=5.5);
    procedure DrawOGL(bSingleSlit,bNSlit,bCombiSlit,bImage:boolean);
    procedure setactive(value:boolean);  override;
  public
    CalcReflection:boolean;

    SingleSlit:TSingleSlit;
    NSlit:TRSNSlit;
    CombiSlit:TCombiSlit;
    ImageIntensity:TImageIntensity;

    xAxisType:TxAxisType;
    LSAxisType:TLSAxisType;
    ImageAxisType:TImageAxisType;
    ColorNumber,
    CheckNumber :byte;

    property Color:Tcolor read FColor write FColor;
    property Box:TOGlBox read FBox;

    procedure CalcAll(Quality:real=5.5);
    procedure CalcOnlyVisible(Quality:real=5.5);
    procedure DrawOGLOnlyVisible;
    procedure deleteAllValues;

    procedure getspecifications;

    procedure MakeAllRightColor;

    constructor create(AOwner: TComponent; aForm:TForm1; abox:TOGlBox; anumber:byte);
    destructor Destroy; override;
  end;

  {-----------------------------------------------------------------------------
   Class:   Taperture  = öffnung
   Description:   Gibt die Spezifikationen des Spaltes (der zwischen Schirm und Laser steht) an
                  Ist nicht sehr umfachngreich, trotzdem aber gleichrangig wie Tsource und  TScreem
  -----------------------------------------------------------------------------}

  { Taperture }

  Taperture=class(TComponent)
  private
    FScreenDistance:real;  //screen-aperture
    Form:TForm1;
    procedure writeScreenDistance(value:real);
  public
    slit:record
      count:integer;
      distance:extended;   //=g=Gitterkonstante
      width:extended;
      beta,
      theta:real;
    end;
    LaserHeight:real; // 1 ist standart

    property ScreenDistance:real read FScreenDistance write writeScreenDistance;
    
{    procedure reset;}
    constructor create(AOwner: TComponent; aForm:TForm1);
  end;

  {-----------------------------------------------------------------------------
   Class:   Tsource
   Description:   Hier ist drin:
                    Was für Licht/Teilchen kommen aus dem Laser?
                    Umrechnung zwischen lambda, frequency, energy der Photonen
                  Gleichrangig zu Taperture und  TScreem
  -----------------------------------------------------------------------------}

  { Tsource }

  Tsource=class(TArrayItem)
  private
    Flambda:real;

    function getfrequency:Double	;
    procedure setfrequency(value:Double);
    function getenergy:Double	;
    procedure setenergy(value:Double);
    procedure setlambda(value:Double);
    procedure setactive(value:boolean);  override;
    function getactive:boolean;  virtual;

    procedure OnKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure TrackBarChange(Sender: TObject);

    procedure WriteEdits;
    procedure WriteEditsAndTrackbar;
    procedure getspecifications;
  public
    TrackBar:TTrackBar;
    lambdaMin,
    lambdaMax:integer;
    EditLambda,
    EditFrequency:TEdit;
    GroupBox:TGroupBox;

    procedure CalcOtherEdits(Source:TCustomEdit);

    property lambda:Double	 read Flambda write  setlambda;  //das greift im hintergrund eigentlich nur auf lambda zu
    property frequency:Double	 read getfrequency write  setfrequency;  //das greift im hintergrund eigentlich nur auf lambda zu
    property energy:Double	 read getenergy write  setenergy;           //das greift im hintergrund eigentlich nur auf lambda zu
    property active:boolean	 read getactive write  setactive;           //das greift im hintergrund eigentlich nur auf lambda zu

    constructor create(AOwner: TComponent;  aForm:TForm1; anumber:byte);  override;
    destructor Destroy;  override;
  end;


  {-----------------------------------------------------------------------------
   Class:   TSaSArray  //SaS=Source and Screen
   Description:  Kapselt die Mehreren Schirme und Quellen in einer Klasse
                    Es ist fast eine Art erweitertes Array
  -----------------------------------------------------------------------------}

  { TSaSArray }

  TSaSArray=class
  private
    FOnDrawingEnabledChange:TNotifyEvent;
    FOnQualityChange:TNotifyEvent;
    FOnIntensityColorFactorChange:TNotifyEvent;

    Form:TForm1;

    FQuality:real;
    FIntensityColorFactor:real;
    FActiveNumber:byte;
    FDrawingEnabled:boolean;

    procedure setActiveNumber(value:byte);
    procedure OnResize(sender:TObject);

    procedure writeDrawingEnabled(value:boolean);
    procedure writeQuality(value:real);
    procedure writeIntensityColorFactor(value:real);

    procedure BeginCalc;
    procedure EndCalc;
    procedure Calc(OneSlit,NSlit,CombiSlit,Image:boolean);
    procedure DrawOGL(OneSlit,NSlit,CombiSlit,Image:boolean);
  public
    box:TOGlBox;
    OldChart:record
      ZoomMin,
      ZoomMax,
      OldQuality:real;
    end;
    UsedFormula:TUsedFormula;
    gradient:TGradientBackgroundChart;

    //Masterbmp:Tbitmap;
    Source:array of TSource;
    Screen:array of TScreem;
    starttime:longword;

    CalculationTime:integer;


    function count:word;
//    procedure delete(idx:word);
    procedure deleteLastItem;
    procedure add(AOwner: TComponent);
    procedure addActive(AOwner: TComponent);

    procedure SetAllCalcReflection(value:boolean);
    procedure ShowCorScreen;
    procedure ChangeAllColor(acolor,agridcolor:Tcolor);
    procedure ChangeAllChecked(SlitType:TMySlitType; IsMaxMin,bool:boolean);
    function  MinOneChecked(SlitType:TMySlitType):boolean;
    procedure RefreshAllChecked;
    procedure deleteAllValues;
    procedure getAllspecifications;
    procedure CalcAll;
    procedure CalcImageIntensity;
    procedure CalcOnlyVisible;
    procedure DrawOGLOnlyVisible;
    procedure CalcAndDrawBox;

    property  ActiveNumber:byte read FActiveNumber write setActiveNumber;

    procedure ExportAllValues(FileName:string);

    constructor Create(aForm:TForm1);  virtual;
    destructor Destroy;    override;
    
  published
    property OnDrawingEnabledChange:TNotifyEvent read FOnDrawingEnabledChange write FOnDrawingEnabledChange;
    property OnQualityChange:TNotifyEvent read FOnQualityChange write FOnQualityChange;
    property OnIntensityColorFactorChange:TNotifyEvent read FOnIntensityColorFactorChange write FOnIntensityColorFactorChange;

    property DrawingEnabled:boolean read FDrawingEnabled write writeDrawingEnabled;
    property Quality:real read FQuality write writeQuality;
    property IntensityColorFactor:real read FIntensityColorFactor write writeIntensityColorFactor;
  end;


procedure getAllspecifications;  //ruft von jedem die getspecifications auf


const c=299792458; //m/s
      h=4.13566743E-15; //eVs

var
    SaS:TSaSArray;
    aperture:Taperture;


implementation
uses utxt,LCLIntf;





{-----------------------------------------------------------------------------
  Description:  ruft von jedem die getspecifications auf
  Procedure:    getAllspecifications
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure getAllspecifications;
begin
  SaS.getAllspecifications;
end;








{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray    
TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray
TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray  TSaSArray 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}



{-----------------------------------------------------------------------------
  Description:
  Procedure:    deleteLastItem
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.deleteLastItem;
var len:byte;
begin
  if SaS.count<=1 then
    exit;

  self.ActiveNumber:=SaS.count-2;

  len:=high(source);

  source[len].Free;
  screen[len].Free;

  setlength(source,len);
  setlength(screen,len);
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    add
  Arguments:    (AOwner: TComponent;  thisparent:Twincontrol)
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.add(AOwner: TComponent);
var len:byte;
begin
  len:=count;
  if source=nil then
    begin
    setlength(source,1);
    setlength(screen,1);
    end
  else
    begin
    setlength(source,len+1);
    setlength(screen,len+1);
    end;
  source[len]:=Tsource.create(AOwner,Form,len);
  screen[len]:=TScreem.create(AOwner,Form,box,len);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    addActive
  Arguments:    AOwner: TComponent
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.addActive(AOwner: TComponent);
begin
  self.add(AOwner);
  SaS.ActiveNumber:=SaS.count-1;
end;

procedure TSaSArray.SetAllCalcReflection(value: boolean);
begin
  for i:=0 to count-1 do
    self.Screen[i].CalcReflection:=value;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    count
  Arguments:    None
  Result:       word
  Detailed description:
-----------------------------------------------------------------------------}
function TSaSArray.count:word;
begin
  result:=length(Source);


  if length(Source)<>length(Screen) then
    showmessage('Fehler!!! Bitte schreibe an roth-a@gmx.de dass Arrays unterschiedlich lang sind'+#13+
                'length(Source)= '+IntToStr(length(Source))+#13+
                'length(Screen)= '+IntToStr(length(Screen)));
end;










{-----------------------------------------------------------------------------
  Description:
  Procedure:    getAllspecifications
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.getAllspecifications;
var i:integer;
begin
  for i:=0 to count-1 do
    begin
    source[i].getspecifications;
//    Screen[i].MakeAllRightColor;
    screen[i].getspecifications;
    end;
end;


{==============================================================================
  Procedure:    Create
  Belongs to:   TSaSArray
  Result:       None
  Parameters:
                  CForm : TForm1  =   
                    
  Description:  
==============================================================================}
constructor TSaSArray.Create(AForm:TForm1);
begin
  inherited create;

  self.Form:=aForm;
  self.box:=OGLBox;

  FQuality:=5.5;
  FDrawingEnabled:=true;
  FIntensityColorFactor:=1;
  CalculationTime:=100;


  gradient:=TGradientBackgroundChart.Create(box);

  //box.OnResize:=@self.Onresize;

  OldChart.ZoomMin:=self.box.LSAxis.Koor.Min;
  OldChart.ZoomMax:=self.box.LSaxis.Koor.Max;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    destroy
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
destructor TSaSArray.destroy;
var i:integer;
begin
  for i:=0 to count-1 do
    begin
    source[i].Free;
    screen[i].Free;
    end;
  source:=nil;
  screen:=nil;
  
  gradient.Free;

  inherited destroy;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    BeginDraw
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.BeginCalc;
begin
  stop:=false;
  starttime:=GetTickCount;
  //self.Masterbmp.Canvas.FillRect(self.Masterbmp.Canvas.ClipRect);

  Form1.AddLog('');
  Form1.AddLog('');
  Form1.AddLog('|==================|');
  Form1.AddLog('|     Neue Zeichnung    |');
  Form1.AddLog('|==================|');

  {$IFDEF CalcTimes}
    writeln('--------------------------------------');
    writeln('Begin Calc All Values');
  {$ENDIF}
  {$IFDEF ExtraInfos}
    writeln('--------------------------------------');
    writeln('Begin Calc All Values');
  {$ENDIF}

  form1.ProgressDraw.Position:=0;
  form1.ProgressDraw.Visible:=true;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    EndCalc
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.EndCalc;
var i:integer;
begin
//  box.BackGround.Image.Bitmap:=SaS.Masterbmp;  //damit überhaupt das neue Bild angezeigt wird
  OldChart.ZoomMin:=self.box.xAxis.Koor.Min;
  OldChart.ZoomMax:=self.box.xAxis.Koor.Max;
  OldChart.OldQuality:=Quality;
  //SaS.box.Update;

  if Form1.ProgrammerInfo then
    begin
    with  Form1.ListCountPoints do
      begin
      Clear;
      for I := 0 to self.Count - 1 do
        begin
        Items.Add('Screen '+inttostr(i)+' SingleSlit = '+inttostr(self.Screen[i].SingleSlit.Values.Count)+'     Neu Berechnet = '+inttostr(self.Screen[i].SingleSlit.NewCalculatedPoints));
        Items.Add('Screen '+inttostr(i)+' NSlit = '+inttostr(self.Screen[i].NSlit.Values.Count)+'     Neu Berechnet = '+inttostr(self.Screen[i].NSlit.NewCalculatedPoints));
        Items.Add('Screen '+inttostr(i)+' CombiSlit = '+inttostr(self.Screen[i].CombiSlit.Values.Count)+'     Neu Berechnet = '+inttostr(self.Screen[i].CombiSlit.NewCalculatedPoints));
        Items.Add('Screen '+inttostr(i)+' Image Intensity = '+inttostr(self.Screen[i].ImageIntensity.Values.Count)+'     Neu Berechnet = '+inttostr(self.Screen[i].ImageIntensity.NewCalculatedPoints));
        //Items.Add(HTMLColorString('Screen '+inttostr(i)+' OneSlit = '+inttostr(screen[i].SingleSlit.Values.Count)+'     Neu Berechnet = '+inttostr(screen[i].SingleSlit.NewCalculatedPoints),screen[i].Color));
        //Items.Add(HTMLColorString('Screen '+inttostr(i)+' NSlit = '+inttostr(screen[i].NSlit.Values.Count)+'     Neu Berechnet = '+inttostr(screen[i].NSlit.NewCalculatedPoints),screen[i].Color));
        //Items.Add(HTMLColorString('Screen '+inttostr(i)+' CombiSlit = '+inttostr(screen[i].CombiSlit.Values.Count)+'     Neu Berechnet = '+inttostr(screen[i].CombiSlit.NewCalculatedPoints),screen[i].Color));
        //Items.Add(HTMLColorString('Screen '+inttostr(i)+' Image Intensity = '+inttostr(screen[i].ImageIntensity.Values.Count)+'     Neu Berechnet = '+inttostr(screen[i].ImageIntensity.NewCalculatedPoints),screen[i].Color));
        Items.Add('');
        end;
      end;
    CalculationTime:=GetTickCount-starttime;
    Form1.AddLog('Gesamte Zeichenoperation hat '+IntToStr(CalculationTime)+' ms gedauert');
    Form1.AddLog('');
    end;
  Form1.AddLog('|=======================|');
  Form1.AddLog('|     Ende Zeichnung    |');
  Form1.AddLog('|=======================|');
  Form1.AddLog('');

  {$IFDEF CalcTimes}
    writeln('Sas.EndCalc   Time= '+IntToStr(CalculationTime)+' ms');
    writeln('--------------------------------------');
  {$ENDIF}
  {$IFDEF ExtraInfos}
    writeln('Sas.EndCalc');
    writeln('--------------------------------------');
  {$ENDIF}

  //  form1.ProgressDraw.Visible:=false;
  form1.ProgressDraw.Position:=0;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    drawAll
  Arguments:    none
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.CalcAll;
var i:integer;
begin
  if not DrawingEnabled then    exit;

  BeginCalc;
  for i:=0 to count-1 do
    begin
    self.Screen[i].CalcAll(Quality);
    form1.ProgressDraw.Position:=round(i/count*100);

    if stop then exit;
    end;
  EndCalc;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    CalcImageIntensity
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.CalcImageIntensity;
var i:integer;
begin
  if not DrawingEnabled then    exit;

  BeginCalc;
  for i:=0 to count-1 do
    begin
    self.Screen[i].Calc(false,false,false,self.Screen[i].ImageIntensity.Visible,Quality);

    if stop then exit;
    end;
  EndCalc;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    CalcOnlyVisible
  Arguments:    UpdatingType:TUpdatingType
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.CalcOnlyVisible;
var i:integer;
begin
  if not DrawingEnabled then    exit;

  BeginCalc;
  for i:=0 to count-1 do
    begin
    self.Screen[i].CalcOnlyVisible(Quality);
    form1.ProgressDraw.Position:=round(i/count*100);

    //Application.ProcessMessages;
    if stop then exit;
    end;
  EndCalc;

//  self.Masterbmp.SaveToFile('C:\'+self.ClassName+'.bmp');
end;

procedure TSaSArray.DrawOGLOnlyVisible;
var i:integer;
begin
  if not DrawingEnabled then    exit;

  for i:=0 to count-1 do
    begin
    self.Screen[i].DrawOGLOnlyVisible;

    if stop then exit;
    end;
  gradient.DrawOGL;
end;

procedure TSaSArray.CalcAndDrawBox;
begin
  CalcOnlyVisible;
  box.DrawOGL;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    Calc
  Arguments:    OneSlit,NSlit,CombiSlit,Image:boolean; UpdatingType:TUpdatingType
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.Calc(OneSlit,NSlit,CombiSlit,Image:boolean);
var i:integer;
begin
  if not DrawingEnabled then    exit;

  BeginCalc;
  for i:=0 to count-1 do
    begin
    self.Screen[i].Calc(OneSlit,NSlit,CombiSlit,Image,Quality);

    if stop then exit;
    end;
  EndCalc;
end;

procedure TSaSArray.DrawOGL(OneSlit, NSlit, CombiSlit, Image: boolean);
var i:integer;
begin
  if not DrawingEnabled then    exit;

  for i:=0 to count-1 do
    begin
    self.Screen[i].DrawOGL(OneSlit,NSlit,CombiSlit,Image);

    if stop then exit;
    end;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    setActiveNumber
  Arguments:    value:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.setActiveNumber(value:byte);
//var s:string;
begin
  if (value>=self.count)or
      (ActiveNumber>=self.count) then
    exit;

  source[ActiveNumber].active:=false;
  self.Screen[ActiveNumber].active:=false;

  self.Screen[value].active:=true;
  Source[value].active:=true;

  FActiveNumber:=value;

{  s:='';
  for I := 0 to Count - 1 do
    begin
    s:=s+#13+inttostr(i);
    if source[i].active then
      s:=s+' sichtbar';
    end;
  showmessage(s);}
end;







{-----------------------------------------------------------------------------
  Description:
  Procedure:    OnResize
  Arguments:    sender:TObject
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.OnResize(sender:TObject);
begin
  //SaS.Masterbmp.width:=box.Width;
  //for i:=0 to count-1 do
    //self.Screen[i].ImageIntensity.Resize;

//  Self.CalcOnlyVisible;
end;







procedure TSaSArray.writeDrawingEnabled(value: boolean);
begin
  if FDrawingEnabled=value then
    exit;
    
  FDrawingEnabled:=value;
  
  if DrawingEnabled then
    CalcOnlyVisible;

  if Assigned(FOnDrawingEnabledChange) then
    FOnDrawingEnabledChange(self);
end;

procedure TSaSArray.writeQuality(value: real);
begin
  if FQuality=value then
    exit;
    
  FQuality:=value;

  if Assigned(FOnQualityChange) then
    FOnQualityChange(self);
end;

procedure TSaSArray.writeIntensityColorFactor(value: real);
begin
  FIntensityColorFactor:=value;

  for i := 0 to SaS.count-1 do
    SaS.Screen[i].ImageIntensity.Chart.IntensityColorFactor:=IntensityColorFactor;

  if Assigned(FOnIntensityColorFactorChange) then
    FOnIntensityColorFactorChange(self);
end;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    ShowCorScreen
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.ShowCorScreen;
var i:integer;
    countactiveImage,CountActiveOther:integer;
begin
  {$IFDEF ExtraInfos}
    writeln('ShowCorScreen');
  {$ENDIF}
  countactiveImage:=0;
  CountActiveOther:=0;
  for i:=0 to count-1 do
    begin
    if Screen[i].ImageIntensity.Visible then
      inc(countactiveImage);

    if self.Screen[i].SingleSlit.Visible
      or self.Screen[i].NSlit.Visible
      or self.Screen[i].CombiSlit.Visible then
      inc(CountActiveOther);
    end;


  //if (countactiveImage>0) then
    ChangeAllColor(clwhite,IntensityColor(clWhite, 0.5));
  //else
    //ChangeAllColor(clblack,IntensityColor(clWhite, 0.5));


  box.LSaxis.Visible:=(CountActiveOther>0);
  box.LSaxis.ShowMainGrid:=(CountActiveOther>0) and Form.CheckShowLSGitternetz.Checked;
  
  box.ImageAxis.Visible:=(countactiveImage>0);
  box.ImageAxis.ShowMainGrid:=(countactiveImage>0) and (CountActiveOther=0) and Form.CheckShowLSGitternetz.Checked;
  
//  gradient.Visible:=(countactiveImage=0);
  gradient.Visible:=false;

  box.DrawOGL;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    ChangeAllColor
  Arguments:    color,gridcolor:Tcolor
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.ChangeAllColor(acolor,agridcolor:Tcolor);
begin
  //box.Color:=acolor;
  with box do
    begin
    header.Color:=acolor;
    Header.BackgroundColor:=GegenFarbe(aColor);
    with xAxis do
      begin
      ColorAxis:=acolor;
      ColorBigTicks:=acolor;
      ColorMainGrid:=agridcolor;
      ColorTicks:=agridcolor;
      Title.Color:=aColor;
      Title.BackgroundColor:=GegenFarbe(aColor);
      end;
    with LSAxis do
      begin
      ColorAxis:=acolor;
      ColorBigTicks:=acolor;
      ColorMainGrid:=agridcolor;
      ColorTicks:=agridcolor;
      Title.Color:=aColor;
      Title.BackgroundColor:=GegenFarbe(aColor);
      end;
    with ImageAxis do
      begin
      ColorAxis:=acolor;
      ColorBigTicks:=acolor;
      ColorMainGrid:=agridcolor;
      ColorTicks:=agridcolor;
      Title.Color:=aColor;
      Title.BackgroundColor:=GegenFarbe(aColor);
      end;
    end;
end;





{==============================================================================
  Procedure:    ChangeAllChecked	
  Belongs to:   TSaSArray
  Result:       None
  Parameters:   
                  SlitType : TMySlitType  =   
                  IsMaxMin : boolean  =   
                  bool : boolean  =   
                    
  Description:  
==============================================================================}
procedure TSaSArray.ChangeAllChecked(SlitType:TMySlitType; IsMaxMin,bool:boolean);
var i:integer;
begin
  {$IFDEF ExtraInfos}
    writeln('ChangeAllChecked');
  {$ENDIF}
  if not IsMaxMin then
    case SlitType of
      MySingle:
        for i:=0 to count-1 do
          self.Screen[i].SingleSlit.Visible:=bool;
      MyN:
        for i:=0 to count-1 do
          self.Screen[i].NSlit.Visible:=bool;
      MyCombi:
        for i:=0 to count-1 do
          self.Screen[i].CombiSlit.Visible:=bool;
      MyImage:
        for i:=0 to count-1 do
          self.Screen[i].ImageIntensity.Visible:=bool;
    end;
  
  
 // für maxmin
  if IsMaxMin then
    case SlitType of
      MySingle:
        for i:=0 to count-1 do
          with self.Screen[i].SingleSlit do
              if UseMaxMin then
                begin
                checkMaxMin.Checked:=bool;
                RefreshChecked;
                end;
      MyN:
        for i:=0 to count-1 do
          with self.Screen[i].NSlit do
              if UseMaxMin then
                begin
                checkMaxMin.Checked:=bool;
                RefreshChecked;
                end;
      MyCombi:
        for i:=0 to count-1 do
          with self.Screen[i].CombiSlit do
              if UseMaxMin then
                begin
                checkMaxMin.Checked:=bool;
                RefreshChecked;
                end;
      MyImage:
        for i:=0 to count-1 do
          with self.Screen[i].ImageIntensity do
              if UseMaxMin then
                begin
                checkMaxMin.Checked:=bool;
                RefreshChecked;
                end;
    end;

  ShowCorScreen;
end;




{==============================================================================
  Procedure:    MinOneChecked	
  Belongs to:   TSaSArray
  Result:       boolean
  Parameters:   
                  SlitType : TMySlitType  =   
                    
  Description:  
==============================================================================}
function  TSaSArray.MinOneChecked(SlitType:TMySlitType):boolean;
var i:integer;
begin
  result:=false;
  case SlitType of
    MySingle:
      for i := 0 to count-1 do
        if self.Screen[i].SingleSlit.Visible then
          begin
          Result:=true;
          break;
          end;
    MyN:
      for i := 0 to count-1 do
        if self.Screen[i].NSlit.Visible then
          begin
          Result:=true;
          break;
          end;
    MyCombi:
      for i := 0 to count-1 do
        if self.Screen[i].CombiSlit.Visible then
          begin
          Result:=true;
          break;
          end;
    MyImage:
      for i := 0 to count-1 do
        if self.Screen[i].ImageIntensity.Visible then
          begin
          Result:=true;
          break;
          end;
  end;
end;



{==============================================================================
  Procedure:    RefreshAllChecked	
  Belongs to:   TSaSArray
  Result:       None
  Parameters:   
                    
  Description:  
==============================================================================}
procedure TSaSArray.RefreshAllChecked;
var i:integer;
begin
    for i:=0 to count-1 do
      begin
      with self.Screen[i].SingleSlit do
        RefreshChecked;
      with self.Screen[i].NSlit do
        RefreshChecked;
      with self.Screen[i].CombiSlit do
        RefreshChecked;
      with self.Screen[i].ImageIntensity do
        RefreshChecked;
      end;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    deleteAllValues
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSaSArray.deleteAllValues;
var i:integer;
begin
  for i:=0 to count-1 do
    self.Screen[i].deleteAllValues;
end;





{==============================================================================
  Procedure:    ExportAllValues	
  Belongs to:   TSaSArray
  Result:       None
  Parameters:   
                  FileName : string  =   
                    
  Description:  
==============================================================================}
procedure TSaSArray.ExportAllValues(FileName:string);


  procedure AddIf(add:boolean; substring:string; var s:string); overload;
  begin
    if add then
      s:=s+substring+';'
    else
      s:=s+';';
  end;

  procedure AddIf(add:boolean; value:extended; var s:string); overload;
  begin
    AddIf(add, FloatToStr(value), s);
  end;

  procedure AddIf(add:boolean; arPointer:TChartValueArray; idx:integer; WhatValue:TXYZKind; var s:string); overload;
  begin
    if add then
      begin
      case WhatValue of
        xyzkX:  s:=s+FloatToStr(arPointer[idx].pos.x.v)+';';
        xyzkY:  s:=s+FloatToStr(arPointer[idx].pos.y.v)+';';
        xyzkZ:  s:=s+FloatToStr(arPointer[idx].pos.z.v)+';';
      end
      end
    else
      s:=s+';';
  end;

  
  function XTitle:string;
  begin
    result:=OGLBox.xAxis.Title.Text;
  end;

  function LSTitle:string;
  begin
    result:=OGLBox.LSAxis.Title.Text;
  end;

  function ImageTitle:string;
  begin
    result:=OGLBox.ImageAxis.Title.Text;
  end;


const CountColPerSlit=2;
      CountColPerMinMax=3;
var i,j,Scr,
    maxi,countCol:integer;
    s:string;
begin
  s:='Export aller Werte aus dem Programm Interferenz '+version+'   am '+datetostr(now)+'  '+timetostr(now)+#13+#13;
  s:=s+'Wenn Sie dieses Programm oft benutzen, wäre es sehr freundlich wenn Sie mir eine Spende zukommen lassen würden.  Ich würde mich schon über eine bescheidene Spende freuen.'+#13;
  s:=s+'Schließlich muss das Programm gewartet, überprüft und verbessert werden, ebenso die Homepage und der Webspace...'+#13;
  s:=s+'Wie gesagt, es muss nicht viel sein.  - Einfach mir eine Mail schreiben an: roth-a@gmx.de'+#13;
  s:=s+'Mit freundlichen Grüßen vom Programmierer:  Alexander Roth'+#13+#13;
  case UsedFormula of
//    UFApprox: s:=s+'Brechnet mit der Näherungsformel (Fraunhofer''schen Beugungsmuster)';
    UFHuygens: s:=s+'Brechnet u.a. mit der genauen Formel  (Fresnel''sches Beugungsmuster). Nun gilt nicht mehr e>>g';
  end;
  s:=s+#13+#13;

  // Kopf Schreiben
  for i := 0 to self.count - 1 do
    begin
    // Spalten Zählen
    countcol:=0;
    with  self.Screen[i] do
      begin
      if SingleSlit.Visible then
        inc(countcol, CountColPerSlit+CountColPerMinMax);
      if NSlit.Visible then
        inc(countcol, CountColPerSlit+CountColPerMinMax);
      if CombiSlit.Visible then
        inc(countcol, CountColPerSlit+CountColPerMinMax);
      if ImageIntensity.Visible then
        inc(countcol, CountColPerMinMax+CountColPerMinMax);
      end;

      s:=s+ReplikeString('Wellenlänge '+inttostr(i)+'  (lambda='+inttostr(round(self.Source[i].lambda*1E9))+'nm);', CountCol);
    end;

  s:=s+#13;

  // Kopf Schreiben
  for i := 0 to self.count - 1 do
    with  self.Screen[i] do
      begin
      if SingleSlit.Visible then
        s:=s+ReplikeString('Einfachspalt;',CountColPerSlit)+ReplikeString('Minima des Einfachspalts;',CountColPerMinMax);
      if NSlit.Visible then
        s:=s+ReplikeString('N-fach Spalt;',CountColPerSlit)+ReplikeString('Minima und Maxima des N-fach Spalt;',CountColPerMinMax);
      if CombiSlit.Visible then
        s:=s+ReplikeString('Wirklicher N-fach Spalt;',CountColPerSlit)+ReplikeString('Maxima des Wirklichen N-fach Spalts;',CountColPerMinMax);
      if ImageIntensity.Visible then
        s:=s+ReplikeString('Farbbild;',CountColPerMinMax)+ReplikeString('Minima und Maxima des Farbbilds;',CountColPerMinMax);
      end;
  s:=s+#13;
  // Kopf Schreiben
  for i := 0 to self.count - 1 do
    with  self.Screen[i] do
      begin
      if SingleSlit.Visible then
        s:=s+XTitle+';'+LSTitle+';'  +  XTitle+';'+LSTitle+';'+ImageTitle+';';
      if NSlit.Visible then
        s:=s+XTitle+';'+LSTitle+';'  +  XTitle+';'+LSTitle+';'+ImageTitle+';';
      if CombiSlit.Visible then
        s:=s+XTitle+';'+LSTitle+';'  +  XTitle+';'+LSTitle+';'+ImageTitle+';';
      if ImageIntensity.Visible then
        s:=s+XTitle+';'+LSTitle+';'+ImageTitle+';'  +  XTitle+';'+LSTitle+';'+ImageTitle+';';
      end;
  s:=s+#13;

  //max Count feststellen
  maxi:=0;
  for i := 0 to self.count - 1 do
    with  self.Screen[i] do
      begin
      maxi:=max(SingleSlit.Values.Count, NSlit.Values.Count);
      maxi:=max(maxi, CombiSlit.Values.Count);
      maxi:=max(maxi, ImageIntensity.Values.Count);


      SingleSlit.CalcMinMax(xAxisType,LSAxisType, ImageAxisType);
      NSlit.CalcMinMax(xAxisType,LSAxisType, ImageAxisType);
      CombiSlit.CalcMinMax(xAxisType,LSAxisType, ImageAxisType);
      ImageIntensity.CalcMinMax(xAxisType,LSAxisType, ImageAxisType);
      end;


  for i := 0 to maxi - 1 do
    begin
    for Scr := 0 to self.count - 1 do
      with  self.Screen[Scr] do
        begin
        with SingleSlit do
          if Visible then
            begin
            AddIf(i<Values.Count, Values, i , xyzkX, s);
            AddIf(i<Values.Count, Values, i , xyzkZ, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkX, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkZ, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkY, s);
            end;
        with NSlit do
          if Visible then
            begin
            AddIf(i<Values.Count, Values, i , xyzkX, s);
            AddIf(i<Values.Count, Values, i , xyzkZ, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkX, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkZ, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkY, s);
            end;
        with CombiSlit do
          if Visible then
            begin
            AddIf(i<Values.Count, Values, i , xyzkX, s);
            AddIf(i<Values.Count, Values, i , xyzkZ, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkX, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkZ, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkY, s);
            end;
        with ImageIntensity do
          if Visible then
            begin
            AddIf(i<Values.Count, Values, i , xyzkX, s);
            AddIf(i<Values.Count, Values, i , xyzkZ, s);
            AddIf(i<Values.Count, Values, i , xyzkY, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkX, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkZ, s);
            AddIf(i<ValuesMaxMin.Count, ValuesMaxMin, i , xyzkY, s);
            end;
        end;
    s:=s+#13;
    end;

  //schriebe in csv datei
  utxt.intxtschreiben(s,FileName,'.csv',true);
end;



{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit
TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit
TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit  TSingleSlit
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}




{-----------------------------------------------------------------------------
  Description:
  Procedure:    create
  Arguments:    AOwner: TComponent; box:TOGlBox; number:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
constructor TSingleSlit.create(AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte; aCreateMaxMin:boolean);
begin
  inherited create(AOwner);

  box:=abox;
  SlitType:=MySingle;
  FForm:=aForm;
  Fnumber:=anumber;
  UseMaxMin:=aCreateMaxMin;
  CalcMaxima:=true;
  CalcMinima:=true;
  CheckSTRGOnMouseDown:=false;
  CheckSTRGMaxMinOnMouseDown:=false;
  WasRealKlick:=false;
  CalcGamma:=false;
  FVisible:=true;
  ShowMaxLabels:=true;
  ShowMinLabels:=true;

  Values:=TChartValueArray.Create;
  Values.Clear;

  Chart:=TLineChart.Create(abox, Values);
  Chart.Depth:=Koor1(number+1, kkz);
  Chart.WhatIsYValue:=xyzkZ;

//  parent.LeftAxis.Options := [axAutomaticMinimum, axShowLabels, axShowGrid, axShowTitle, axAutomaticMaximum];
  if UseMaxMin then
    begin
    ValuesMaxMin:=TChartValueArray.Create;
    ValuesMaxMin.clear;
    ChartMinMax:=TPointChart.Create(abox, ValuesMaxMin);
    with ChartMinMax do
      begin
      Depth:=Koor1(self.Chart.Depth.v+0.1,kkz);
      Visible:=false;
      UseIntensityColor:=false;
      WhatIsYValue:=xyzkZ;
      end;
    end;

  //Options := [coLabelEachPoint];
  Chart.pen.Width:=0;

  dialog:=TColorDialog.Create(self);
  inc(TScreem(AOwner).ColorNumber);

  //Komonenten Createn
  with Form1 do
    begin
    inc(TScreem(AOwner).CheckNumber);
    // hauptcheckbox
    check:=TCheckbox.Create(FForm);
    with check do
      begin
      parent:=GroupShowChart;
      name:=self.ClassName+'_Check_'+inttostr(number);
      left:=16;
      width:=180;
      top:=24*TScreem(AOwner).CheckNumber;
      writeCaption(TCheckbox(check));
      end;
    check.OnMouseDown:=@self.CheckOnMouseDown;//muss am schluss ausgeführt werden damit er nicht vorher zeichnet
    check.OnChange:=@self.CheckChange;//muss am schluss ausgeführt werden damit er nicht vorher zeichnet


    // für farbeinstellungen
    LED:=TALED.Create(FForm);
    with LED do
      begin
      parent:=GroupColors;
      name:=self.ClassName+'_LED_'+inttostr(number);
      left:=16;
      top:=24*TScreem(AOwner).ColorNumber;
      Status:=true;
      colorON:=self.Chart.Color;
      onclick:=@self.ColorOnClick;
      OnColorChange:=@self.OnColorChange;
      end;
    // für farbeinstellungen
    with TLabel.Create(self) do
      begin
      parent:=GroupColors;
      name:=self.ClassName+'_TLabel_'+inttostr(number);
      left:=42;
      top:=24*TScreem(AOwner).ColorNumber;
      Caption:=check.Caption;
      onclick:=@self.ColorOnClick;
      end;

    if UseMaxMin then
      begin
      checkMaxMin:=TCheckbox.Create(FForm);
      with checkMaxMin do
        begin
        parent:=GroupShowMaxMin;
        name:=self.ClassName+'_CheckMaxMin_'+inttostr(number);
        left:=16;
        width:=160;
        top:=24*TScreem(AOwner).CheckNumber-22;
        checked:=false;
        writeCaption(checkMaxMin);
        end;
      checkMaxMin.OnMouseDown:=@CheckMaxMinOnMouseDown;//muss am schluss ausgeführt werden damit er nicht vorher zeichnet
      checkMaxMin.OnClick:=@CheckMaxMinClick;//muss am schluss ausgeführt werden damit er nicht vorher zeichnet
      end;
    end;

  self.active:=false;
  self.MakeRightColor;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    destroy
  Arguments:    None
  Result:       None
  Detailed description:  brauche ich nicht, da led,check,checkmaxmin zu self.Owner.Owner.groupbox gehören,
                        und deswegen anscheinend von Tform1 zerstört werden
-----------------------------------------------------------------------------}
destructor TSingleSlit.destroy;
begin
  if assigned(Chart) then
    Chart.Free;
  if assigned(LED) then
    LED.Free;
  if assigned(check) then
    check.Free;
  if UseMaxMin and assigned(checkMaxMin) then
    checkMaxMin.Free;
  if assigned(Values) then
    Values.free;
  if UseMaxMin and assigned(ValuesMaxMin) then
    ValuesMaxMin.Free;

  inherited destroy;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeCaption
  Arguments:    (var checkbox:TCheckbox)
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSingleSlit.writeCaption(var checkbox:TCheckbox);
begin
  checkbox.Caption:='Einfachspalt';//+inttostr(number);
  CalcMaxima:=true;
  CalcMinima:=true;
  Visible:=true;
end;



procedure TSingleSlit.WriteFForm(Form: TForm);
begin
  FForm:=Form;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    setactive
  Arguments:    value:boolean
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSingleSlit.setactive(value:boolean);
begin
  Factive:=value;

  self.check.Visible:=value;
  if UseMaxMin then
    self.checkMaxMin.Visible:=value;
  if UseMaxMin then
    self.ChartMinMax.Visible:=self.checkMaxMin.Checked and self.Visible;
  self.LED.Visible:=value;

{  showmessage( inttostr(number)+#13+
               self.ClassName+'.check.Visible= '+booltostr(self.check.Visible,true)+#13+
               self.ClassName+'.ChartMinMax.Visible= '+booltostr(self.ChartMinMax.Visible,true)+#13+
               self.ClassName+'.LED.Visible= '+booltostr(self.LED.Visible,true)
                );}
end;


procedure TSingleSlit.setVisible(value: boolean);
begin
  FVisible:=value;
  check.Checked:=value;
end;


procedure TSingleSlit.OnColorChange(Sender: TObject);
begin
  self.Chart.Color:=LED.ColorOn;
end;



{==============================================================================
  Procedure:    RefreshChecked
  Belongs to:   TSingleSlit
  Result:       None
  Parameters:   
                    
  Description:
==============================================================================}
procedure TSingleSlit.RefreshChecked;
begin
  Chart.Visible:=Visible;

  if UseMaxMin then
    ChartMinMax.Visible:=self.checkMaxMin.Checked and Visible;
end;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    ColorOnClick
  Arguments:    Sender: TObject
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSingleSlit.ColorOnClick(Sender: TObject);
begin
  if dialog.Execute then
    LED.ColorOn:=dialog.Color;
  box.DrawOGL;  // das muss hier rein, denn wenn es in oncolorchange ist dann versucht es auch n und multislit zuzugreifen, die noch garnicht created sind
end;



procedure TSingleSlit.CheckChange(Sender: TObject);
begin
  {$IFDEF ExtraInfos}
    writeln(ClassName+'.CheckChange');
  {$ENDIF}

  Visible:=check.Checked;
  self.RefreshChecked;

  if CheckSTRGOnMouseDown then
    SaS.ChangeAllChecked(SlitType,false, self.Visible)  // es muss hier überall not visible, weil visible ja noch nicht abnders gesetzt wurde
  else
    begin
    if Visible then
      Calc(TScreem(Owner).xAxisType,TScreem(Owner).LSAxisType, TScreem(Owner).ImageAxisType);

    if WasRealKlick then
      SaS.ShowCorScreen
    else
      box.DrawOGL;
    end;

  WasRealKlick:=false;
  CheckSTRGOnMouseDown:=false;
end;




procedure TSingleSlit.CheckOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$IFDEF ExtraInfos}
    writeln(ClassName+'.CheckOnMouseDown');
  {$ENDIF}

  CheckSTRGOnMouseDown:=  Shift=[ssCtrl, ssLeft];
  WasRealKlick:=true;
end;



procedure TSingleSlit.CheckMaxMinClick(Sender: TObject);
begin
  if CheckSTRGMaxMinOnMouseDown then
    begin
    SaS.ChangeAllChecked(SlitType,true,checkMaxMin.Checked);
    exit;
    end
  else
    self.RefreshChecked;

  CheckSTRGMaxMinOnMouseDown:=false;
  if self.checkMaxMin.Checked then
    self.CalcMinMax(TScreem(owner).xAxisType,TScreem(owner).LSAxisType, TScreem(Owner).ImageAxisType);
  box.DrawOGL;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    CheckcheckMaxMinOnClick
  Arguments:    Sender: TObject
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSingleSlit.CheckMaxMinOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CheckSTRGMaxMinOnMouseDown:=shift=[ssCtrl, ssLeft];
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    getspecifications
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSingleSlit.getspecifications;
begin
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    OneSlitAmplitude
  Arguments:    alpha:extended
  Result:       extended
  Detailed description:

      Herleitung durch vereifachjung der N-fach Spalt Intensitätsformel
      Da delta phi -->0 und N --> unendlich
      qhi = N* delta phi
      sin(delta phi /2) = delta phi /2

      Einsetzen und man bekomnt es heraus


      Dreh-Gitter:
      Die Erweiterung ist nun dass wenn man das Gitter dreht
      es leider nicht schön delta s = g*sin(alpha)
      sondern das recht kompliziert sich mal Wege addieren bzw. subtrahieren.
      Das wird allerdings wunderschön durch die Vorzeichen kompensiert
      delta s = g*abs(sin(beta)+sin(alpha-beta))
      Wenn alpha=0 dann delta s = 0

      Aufpassen mit Vorzeichen von Winkeln!!!
      Nur so klappt es
-----------------------------------------------------------------------------}
function TSingleSlit.OneSlitAmplitude(s:TVec):extended;   // Formel die Für 2 Spalten Stimmt
const delta=0.000001;
var phi,cosalpha1,cosalpha2, Gangunterschied, beta:extended;
  l0:Tvec;
begin
  beta:=aperture.slit.beta;
  l0:=Vec(-1,0,0);

  cosalpha1:= -l0 * CalcGyVec ;
  cosalpha2:=s * CalcGyVec ;

  Gangunterschied:=aperture.slit.width * ( cosalpha1 + cosalpha2 );
  phi:= 2*pi*Gangunterschied / SaS.Source[number].lambda;

  if abs(phi)>delta then   //sonst dividiert er durch 0      //Hauptmaximum
    result:=1* 2*sin(phi/2)/phi
  else
    result:=1 * cos(phi/2);
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    OneSlitIntensity
  Arguments:    alpha:extended
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function TSingleSlit.OneSlitIntensity(s:TVec):extended;   // Formel die Für 1 Spalte Stimmt
begin
  result:=sqr(self.OneSlitAmplitude(s));
end;




function TSingleSlit.GammaAngleBog(s:TVec): extended;
var x:extended;
begin
//  Result:=0;
  //ablenkung durch gitterverdrehung wenn sowohl beta, als auch theta gekippt sind
  // dadurch wird das Gitter i bezug auf den Laser leicht gedreht, wodurch die Interferensachse
  // nicht mehr horizontal ist sondern schief

  //Gitterachsenvektor ist: vec Gittervektor  = left ( stack{sin %THETA cos %beta # sin %THETA sin %beta  # cos %THETA }   right )
  //relevanter Gitterachsenvektor ist: vec Gittervektor  = left ( stack{0 # sin %THETA sin %beta  # cos %THETA }   right )
  //senkrecht dazu ist die Interferenzachse: vec Interferenzvektor  = left ( stack{0 # -cos %THETA # sin %THETA sin %beta }   right )
  //senkrecht dazu ist die Interferenzachse mit länge 1: vec Interferenzvektor  = left ( stack{0 # -cos %THETA # sin %THETA sin %beta }   right ) over left lline left ( stack{0 # -cos %THETA # sin %THETA sin %beta }   right ) right rline
  //Vereinfacht: senkrecht dazu ist die Interferenzachse mit länge 1: vec Interferenzvektor  = left ( stack{0 # -cos %THETA # sin %THETA sin %beta }   right ) over sqrt{(cos %THETA)^2 + (sin %THETA)^2 (sin %beta)^2 }
  // ohne vektoren sondern nur mit koordinaten: y(x) = {cos(%THETA)} over {sin(%THETA) cdot sin(%beta)}cdot x

  //mit alpha einberechnung:
  //x:=aperture.ScreenDistance*tan(alpha);
  //if (aperture.slit.theta<2*pi) then
    //Result:=-sin(aperture.slit.theta)*sin(aperture.slit.beta)/cos(aperture.slit.theta) *x;


  // hier die krümmung durch verticales kippen des gitters (drehen um horizontale achse)
  // Gebe in Openoffice Formel: c_{neu 3} = tan(%beta)  cdot e cdot left (1-sqrt{tan^2(%alpha_1)+1} right )
//  Result:=Result+tan(aperture.slit.theta)*aperture.ScreenDistance * (1-sqrt(   sqr(tan(alpha))+1  ));

  // in winkel umrechnen
//  Result:=arctan(Result/aperture.ScreenDistance);

//  Result:=alpha+CalcX2RotationDeflection(alpha, xyzkY);
  //brechung miteinberechnen
//  Result:=alpha;
  Result:=AngleOfVec(s, akgamma);
end;

function TSingleSlit.GammaAngleDeg(s:TVec): extended;
begin
  result:=BogtoRad( GammaAngleBog(s));
end;



function TSingleSlit.GammaMeter(s:TVec): extended;
begin
  Result:=aperture.ScreenDistance*tan(GammaAngleBog(s));
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    alpha2X
  Arguments:    alpha:extended
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
//function TSingleSlit.alpha2X(alpha:extended):extended;
//begin
  //result:=aperture.ScreenDistance*tan(alpha);
//end;
//{-----------------------------------------------------------------------------
  //Description:
  //Procedure:    X2alpha
  //Arguments:    x:extended
  //Result:       extended
  //Detailed description:
//-----------------------------------------------------------------------------}
//function TSingleSlit.X2alpha(x:extended):extended;
//begin
  //result:=arctan(x/aperture.ScreenDistance);
//end;


//{-----------------------------------------------------------------------------
  //Description:
  //Procedure:    alpha2lambda
  //Arguments:    alpha:extended
  //Result:       extended
  //Detailed description:
//-----------------------------------------------------------------------------}
//function TSingleSlit.alpha2lambda(alpha:extended):extended;
//begin
  //result:=aperture.slit.width * sin(alpha) / SaS.Source[number].lambda;
//end;
//{-----------------------------------------------------------------------------
  //Description:  lambda bedeutet hier Gangunterschied, da lambda die einheit ist
  //Procedure:    lambda2alpha
  //Arguments:    lambda:extended
  //Result:       extended
  //Detailed description:
//-----------------------------------------------------------------------------}
//function TSingleSlit.lambda2alpha(lambda:extended):extended;
//var temp:extended;
//begin
  //temp:=lambda*SaS.Source[number].lambda/aperture.slit.width;
  //korrigiere(temp,-1,1);
  //result:=arcsin(temp);
//end;

//{-----------------------------------------------------------------------------
  //Description:
  //Procedure:    AlphaBog2AlphaDeg
  //Arguments:    alpha:extended
  //Result:       extended
  //Detailed description:
//-----------------------------------------------------------------------------}
//function  TSingleSlit.AlphaBog2AlphaDeg(alpha:extended):extended;
//begin
  //result:=RadtoDeg(alpha);
//end;

//{-----------------------------------------------------------------------------
  //Description:
  //Procedure:    AlphaDeg2AlphaBog
  //Arguments:    alpha:extended
  //Result:       extended
  //Detailed description:
//-----------------------------------------------------------------------------}
//function  TSingleSlit.AlphaDeg2AlphaBog(alpha:extended):extended;
//begin
  //result:=DegtoRad(alpha);
//end;


//{==============================================================================
  //Procedure:    returnValue
  //Belongs to:   TSingleSlit
  //Result:       extended
  //Parameters:
                  //Value : extended  =

  //Description:
//==============================================================================}
//function TSingleSlit.returnValue(Value:extended):extended;
//begin
  //result:=Value;
//end;






function TSingleSlit.CalcGyVec: TVec;
var beta:extended;
begin
  beta:=aperture.slit.beta;

  Result.x1:=sin(beta);
  Result.x2:=-cos(beta);
  Result.x3:=0;
end;

function TSingleSlit.CalcGzVec: TVec;
var beta,theta:extended;
begin
  theta:=aperture.slit.theta;
  beta:=aperture.slit.beta;

  Result.x1:=sin(theta)*cos(beta);
  Result.x2:=sin(beta)*sin(theta);
  Result.x3:=cos(theta);
end;


 {
 alte berechnung mit s brutal ausrechnen
var k1,k2,k3,a,b,c,s3,s1:extended;
   beta,theta,cosalphax,cosalphay0,sinalpha:extended;
   gx,gy,l0:TVec;
begin
  theta:=aperture.slit.theta;
  beta:=aperture.slit.beta;
  gx:=CalcGyVec;
  gy:=CalcGzVec;
  l0:=vec(-1,0,0);
  cosalphay0:=gy*l0;

  k3:=tan(beta);
  k1:=tan(theta)*sin(beta)*tan(beta) + cos(beta) * tan(theta);
  k2:=1/cos(beta);

  s3:=1/(-k1-k2);

  a:=1+1/sqr(k3);
  b:=-2*k1*s3 /sqr(k3);
  c:=sqr(k1*s3/k3)-1+sqr(s3);

  s1:=ABC(a,b,c,+1);

  cosalphax:=1/gy.x2*(   cosalphay0*gx.x2  - s3*(gy.x3*gx.x2-gx.x3*gy.x2)  -  s1*(gy.x1*gx.x2-gx.x1*gy.x2)  )  ;

  sinalpha:=ABC(1, 2*cosalphax*cos(beta), -sqr(sin(beta)) + sqr(cosalphax), +1);
  Result:=arcsin(sinalpha);
}

// mit kreisberechnung


function TSingleSlit.CalcMinMaxAlpha(TheSign: shortint): extended;

  function secureArccos(value:extended):extended;
  begin
    korrigiere(value,-1,1);
    Result:=arccos(value);
  end;

var alphaz:extended;
   gz,gy,l0,s:TVec;
    temp:extended;
begin
  gy:=CalcGyVec;
  gz:=CalcGzVec;

  l0:=vec(-1,0,0);


  alphaz:=arccos(l0*gz);

  s:=TheSign* sin(alphaz) *gy + cos(alphaz)* gz;

  result:=secureArccos(gy*l0)-secureArccos(gy*s);     //ohne secure gibt er hier einen fehler aus
  korrigiere(Result, -pi/2,pi/2);
end;



function TSingleSlit.CalcMinAlpha: extended;
begin
  result:=CalcMinMaxAlpha(-1)+0.001;
end;

function TSingleSlit.CalcMaxAlpha: extended;
begin
  result:=CalcMinMaxAlpha(+1)-0.001;
end;


// du musst de losptalk anwenden ansonten entstehen polstellen
function TSingleSlit.CalcAngleDeflectionVec(alpha: extended): TVec;
var cosalphaz0, cosalphay, s3WothoutSinBy, davor, davor2:extended;
  s,gz,gy,l1,l0:TVec;
  reflectionsign:shortint;
begin
  gy:=CalcGyVec;
  gz:=CalcGzVec;
  l0:=vec(-1, 0,0);
  l1:=vec(-cos(alpha), -sin(alpha),0);

  cosalphay:=l1*gy;

  cosalphaz0:=l0*gz;

  if  TScreem(Owner).CalcReflection then
    reflectionsign:=1
  else
    reflectionsign:=-1;

  s.x1:=ABC(
            sqr(gz.x3*gy.x2)+sqr(gz.x3 *gy.x1) + sqr( gz.x1*gy.x2-gz.x2*gy.x1  ),
            -2*(  cosalphay*sqr(gz.x3)*gy.x1 + ( cosalphaz0*gy.x2 - cosalphay*gz.x2 )*( gz.x1*gy.x2-gz.x2*gy.x1  )     ),
            sqr(cosalphay * gz.x3) + sqr(  cosalphaz0*gy.x2 - cosalphay*gz.x2   )  - sqr(gz.x3 * gy.x2 )
            , reflectionsign);


  s.x2:=(cosalphay - s.x1*gy.x1)/gy.x2;
  s.x3:=( gy.x2* cosalphaz0 - gz.x2*cosalphay - s.x1*( gz.x1*gy.x2-gy.x1*gz.x2 )  ) / (gy.x2*gz.x3);



  //intxtschreiben('-----------------------------', ExtractFilePath(ParamStr(0))+'s1.txt', '.txt', false);
  //intxtschreiben('alpha '+ FloatToStr(alpha) , ExtractFilePath(ParamStr(0))+'s1.txt', '.txt', false);
  //intxtschreiben('a '+ FloatToStr(sqr(gz.x3*gy.x2)+sqr(gz.x3 *gy.x1) + sqr( gz.x1*gy.x2-gz.x2*gy.x1  )) , ExtractFilePath(ParamStr(0))+'s1.txt', '.txt', false);
  //intxtschreiben('b '+ FloatToStr(-2*(  cosalphay*sqr(gz.x3)*gy.x1 + ( cosalphaz0*gy.x2 - cosalphay*gz.x2 )*( gz.x1*gy.x2-gz.x2*gy.x1  )     )) , ExtractFilePath(ParamStr(0))+'s1.txt', '.txt', false);
  //intxtschreiben('c '+ FloatToStr(sqr(cosalphay * gz.x3) + sqr(  cosalphaz0*gy.x2 - cosalphay*gz.x2   )  -1) , ExtractFilePath(ParamStr(0))+'s1.txt', '.txt', false);
  //intxtschreiben('s1 '+ FloatToStr(s.x1) , ExtractFilePath(ParamStr(0))+'s1.txt', '.txt', false);

  result:=s;
end;



function TSingleSlit.AngleOfVec(s:TVec; angleKind: TAngleKind): extended;
begin
  //now we calculate the angle we need
  case angleKind of
    akalpha:   Result:=pi-RecreateRealAngle(s.x1, s.x2) ;   //pi- da ich nicht von der positiven y-Achse den Winkel messe, sondern von der negativen x-Achse (im Koordinatensystem von meiner Arbeit)
    akgamma:   Result:=pi-RecreateRealAngle(s.x1, s.x3) ;
  end;
end;


function TSingleSlit.KoorStrechtedOfVec(s: TVec; XYZKind: TXYZKind): extended;
begin
  if s.x1=0 then
    case XYZKind of
      xyzkX: Result:=s.x2*aperture.ScreenDistance * 1E10;
      xyzkY: Result:=s.x3*aperture.ScreenDistance * 1E10;
    end;

  case XYZKind of
    xyzkX: Result:=s.x2/s.x1*aperture.ScreenDistance;
    xyzkY: Result:=s.x3/s.x1*aperture.ScreenDistance;
    xyzkZ: Result:=s.x1;
  end;
end;


function TSingleSlit.XAngleOfVec(s: TVec): extended;
begin
  result:=BogtoRad(AngleOfVec(s, akalpha));
end;


function TSingleSlit.PathDifferenceOfVec(s: TVec): extended;
var cosalpha1,cosalpha2,beta:extended;
  l0:Tvec;
begin
  beta:=aperture.slit.beta;
  l0:=Vec(-1,0,0);

  cosalpha1:= -l0 * CalcGyVec ;
  cosalpha2:=s * CalcGyVec ;

  result:=aperture.slit.width * ( cosalpha1 + cosalpha2 ) / SaS.Source[number].lambda;
end;



function TSingleSlit.YAngleOfVec(s: TVec): extended;
begin
  result:=BogtoRad(AngleOfVec(s, akgamma));
end;

function TSingleSlit.XKoorStrechtedOfVec(s: TVec): extended;
begin
  result:=KoorStrechtedOfVec(s, xyzkX);
end;

function TSingleSlit.YKoorStrechtedOfVec(s: TVec): extended;
begin
  result:=KoorStrechtedOfVec(s, xyzkY);
end;



function TSingleSlit.MaxFunc(z: integer; var alpha: Extended): TMinMaxStaus;
begin
  alpha:=0;
  if z=0 then
    begin
    alpha:=0;
    Result:=mmsMainMax;

    if not IsInRange(alpha, CalcMinAlpha, CalcMaxAlpha) then
      Result:=mmsEnd;
    end
  else
    Result:=mmsEnd;
end;


function TSingleSlit.MinFunc(z: integer; var alpha: Extended): TMinMaxStaus;
var l0MalGx:extended;
begin
  alpha:=0;
  l0MalGx:=Vec(-1,0,0) * CalcGyVec;

  alpha:=z*SaS.Source[number].lambda/aperture.slit.width +l0MalGx;

  if IsInRange(alpha, -1,1) then
    begin
    Result:=mmsMin;
    alpha:=aperture.slit.beta + arcsin(alpha);

    if not IsInRange(alpha, CalcMinAlpha, CalcMaxAlpha) then
      Result:=mmsEnd;
    end
  else
    Result:=mmsEnd;
end;




function TSingleSlit.MaxFunc(z:integer; var s:TVec):TMinMaxStaus;
var alpha:extended;
  str:string;
begin
  Result:=MaxFunc(z, alpha);

  if not (Result in [mmsEnd, mmsNoMinMax]) then
    s:=CalcAngleDeflectionVec(alpha);
end;


function TSingleSlit.MinFunc(z:integer; var s:TVec):TMinMaxStaus;
var alpha:extended;
begin
  Result:=MinFunc(z, alpha);

  if not (Result in [mmsEnd, mmsNoMinMax]) then
    s:=CalcAngleDeflectionVec(alpha);
end;








{-----------------------------------------------------------------------------
  Description:
  Procedure:    getImageFunc
  Arguments:    LSAxisType:TLSAxisType
  Result:       TFunctionVecType
  Detailed description:            //  TLSAxisType=(Amplitude,Intensity,BrigthDark);
-----------------------------------------------------------------------------}
function  TSingleSlit.getLSFunc(LSAxisType:TLSAxisType):TFunctionVecType;
begin
  case LSAxisType of
    LSAmplitude: result:=@OneSlitAmplitude;
    LSIntensity: result:=@OneSlitIntensity;
  end;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    getXFunc
  Arguments:    xAxisType:TxAxisType
  Result:       TFunctionVecType
  Detailed description:
-----------------------------------------------------------------------------}
function  TSingleSlit.getXFunc(xAxisType:TxAxisType):TFunctionVecType;
begin
  case xAxisType of
    xangle:  result:=@self.XAngleOfVec;
    xmeter:  result:=@self.XKoorStrechtedOfVec;
    xlambda: result:=@self.PathDifferenceOfVec;
  end;
end;
//{-----------------------------------------------------------------------------
  //Description:  Umkehrfunktion!!!
  //Procedure:    getAntiXFunc
  //Arguments:    xAxisType:TxAxisType
  //Result:       TFunctionVecType
  //Detailed description:
//-----------------------------------------------------------------------------}
//function  TSingleSlit.getAntiXFunc(xAxisType:TxAxisType):TFunctionVecType;
//begin
  //case xAxisType of
    //xangle:  result:=@self.AlphaDeg2AlphaBog;
    //xmeter:  result:=@self.X2alpha;
    //xlambda: result:=@self.lambda2alpha;
  //end;
//end;



function TSingleSlit.getImageFunc(ImageAxisType: TImageAxisType): TFunctionVecType;
begin
  case ImageAxisType of
    ImageAngle:  result:=@self.GammaAngleDeg;
    ImageMeter:  result:=@self.GammaMeter;
  end;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    DelUnVisibleValues
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSingleSlit.DelUnVisibleValues;
var
  i: Integer;
  min,max:real;
begin
  i:=0;
  min:=self.Chart.Box.xAxis.Koor.Min;
  max:=self.Chart.Box.xAxis.Koor.Max;

  while i< Values.Count do
    if not IsInRange(Values[i].Pos.X.v, min, max) then
      Values.Delete(i)
    else
      inc(i);
end;


{-----------------------------------------------------------------------------
  Description:  Wer zeichnet da die blauen Punkte?
  Procedure:    CalcMinMax
  Arguments:    xAxisType:TxAxisType; LSAxisType:TLSAxisType; percision:word=0
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSingleSlit.CalcMinMax(xAxisType:TxAxisType; LSAxisType:TLSAxisType; ImageAxisType:TImageAxisType;  percision:word=0);
const IntensityColor_Minimum=0.3;
var funcLS,funcx, FuncImage:TFunctionVecType;
    i, j, leerstellen:integer;
    alpha:extended;
    stopped:boolean;
    s:TVec;
    str:string;
begin
  if not UseMaxMin then
    exit;
    
  funcLS:=getLSFunc(LSAxisType);
  funcx:=getXFunc(xAxisType);
  FuncImage:=getImageFunc(ImageAxisType);

  ValuesMaxMin.Clear;
  //ChartMinMax.Font.Color:= self.Chart.Color;
  
  if CalcMaxima then
    begin
    //max+
    i:=0;
    leerstellen:=0;
    stopped:=false;
    repeat
      case MaxFunc(i +leerstellen, s) of
        mmsMainMax:
          begin
          ValuesMaxMin.Add(ChartValue(Koor3(funcx(s), FuncImage(s) , funcLS(s), kkx, kkImage, kkLS),
                          inttostr(i+leerstellen)+'.Max', ShowMaxLabels, ChartMinMax.Color,
                          ord(mmsMainMax), i +leerstellen));
          end;
        mmsNoMinMax, mmsMin:
          begin
          dec(i);
          inc(leerstellen);
          end;
        mmsEnd:
          begin
          stopped:=true;
          break;
          end;
      end;
      inc(i);
    until stopped;

    //max-
    i:=-1;
    leerstellen:=0;
    stopped:=false;
    repeat
      case MaxFunc(i -leerstellen, s) of
        mmsMainMax:
          begin
          ValuesMaxMin.Add(ChartValue(Koor3(funcx(s), FuncImage(s) , funcLS(s), kkx, kkImage, kkLS),
                          inttostr(i-leerstellen)+'.Max', ShowMaxLabels,  ChartMinMax.Color,
                          ord(mmsMainMax), i -leerstellen));
          end;
        mmsNoMinMax, mmsMin:
          begin
          inc(i);
          inc(leerstellen);
          end;
        mmsEnd:
          begin
          stopped:=true;
          break;
          end;
      end;
      dec(i);
    until stopped;
  end;

  if CalcMinima then
    begin
    //min+
    i:=1;
    leerstellen:=0;
    stopped:=false;
    repeat
      case MinFunc(i +leerstellen, s) of
        mmsMin:
          begin
          ValuesMaxMin.Add(ChartValue(Koor3(funcx(s), FuncImage(s) , funcLS(s), kkx, kkImage, kkLS),
                          inttostr(i)+'.Min', ShowMinLabels, IntensityColor(ChartMinMax.Color, IntensityColor_Minimum),
                          ord(mmsMin), i +leerstellen));
          end;
        mmsNoMinMax, mmsMainMax, mmsMinorMax:
          begin
          dec(i);
          inc(leerstellen);
          end;
        mmsEnd:
          begin
          stopped:=true;
          break;
          end;
      end;
      inc(i);
    until stopped;

    //min-
    i:=-1;
    leerstellen:=0;
    stopped:=false;
    repeat
      case MinFunc(i -leerstellen, s) of
        mmsMin:
          begin
          ValuesMaxMin.Add(ChartValue(Koor3(funcx(s), FuncImage(s) , funcLS(s), kkx, kkImage, kkLS),
                          inttostr(i)+'.Min', ShowMinLabels, IntensityColor(ChartMinMax.Color, IntensityColor_Minimum),
                          ord(mmsMainMax), i -leerstellen));
          end;
        mmsNoMinMax, mmsMainMax, mmsMinorMax:
          begin
          inc(i);
          inc(leerstellen);
          end;
        mmsEnd:
          begin
          stopped:=true;
          break;
          end;
      end;
      dec(i);
    until stopped;
  end;

  ValuesMaxMin.sort(xyzkX);
end;






{==============================================================================
  Procedure:    Calc
  Belongs to:   TSingleSlit
==============================================================================}
procedure  TSingleSlit.Calc(xAxisType:TxAxisType; LSAxisType:TLSAxisType;  ImageAxisType:TImageAxisType; Quality:real=5.5);
var funcLS,funcx,{funcAntiX,}funcImage:TFunctionVecType;
    mini,maxi:real;  //grenzen fürs zeichnen
    Verhaeltnis: Real;//  neur Ausschnitt / altem ausschnitt
    MaxStep,MinStep:real;





    {==============================================================================
      Procedure:    DelUnVisibleValues
    ==============================================================================}
    //procedure DelUnVisibleValues;
    //var
      //i: Integer;
      //MyfuncX:TFunctionType;
      //min,max:real;
    //begin
      //i:=0;
      //if StretchX then
        //MyfuncX:=returnValue
      //else
        //MyfuncX:=getXFunc(xAxisType);

      //min:=box.xAxis.Minimum;
      //max:=box.xAxis.Maximum;

      //while i< Values.Count do
        //if not IsInRange(MyfuncX(Values.Items[i].X), min,max) then
          //Values.Delete(i)
        //else
          //inc(i);
    //end;

    {==============================================================================
      Procedure:    CalcPointsNearMax
      Parameters:
                      xMax : real  =
    ==============================================================================}
    procedure CalcPointsNearMax(xMax,MinRange,MaxRange:real);
    var r,area:real;
        count,countPoints:integer;
        s:TVec;
    begin
      area:=1/aperture.slit.count;
      s:=CalcAngleDeflectionVec(xMax);

      r:=funcLS(s);
      values.Add(Koor3(funcx(s),funcImage(s),r, kkx,kkImage, kkLS), Chart.Color);
      countPoints:=round(100*r); // bestimme Anzahl der Punkte nach der Helligkeit
      korrigiere(countPoints,5,100);

      r:=Max(xMax-area/2,mini);
      s:=CalcAngleDeflectionVec(r);
      values.Add(Koor3(funcx(s),funcImage(s),funcLS(s), kkx, kkImage, kkLS), Chart.Color);

      count:=0;
      repeat
        r:=r+area/countPoints;
        if not IsInRange(r, MinRange, MaxRange) then continue;
        s:=CalcAngleDeflectionVec(r);
        Values.Add(Koor3(funcx(s),funcImage(s),funcLS(s), kkx, kkImage, kkLS), Chart.Color);
        inc(NewCalculatedPoints);
        inc(count);
      until r>=Min(xMax+area/2,maxi);
      //log

      if Form1.CheckExMaximaDraw.Checked then
        begin
        form1.AddLog('CalcPointsNearMax bei x= '+FormatFloat('0.0000',funcX(CalcAngleDeflectionVec(xMax)))+'  mit count= '+inttostr(count));
        form1.AddLog('Von xMin= '+FormatFloat('0.0000',funcX(CalcAngleDeflectionVec(xMax-area/2)))+'  bis xMax= '+FormatFloat('0.0000',funcX(CalcAngleDeflectionVec(xMax+area/2))));
        form1.AddLog('');
        Form1.CheckLog;
        end;
    end;


    {==============================================================================
      Procedure:    CalcInterestingPoints
    ==============================================================================}
    procedure CalcInterestingPoints(MinRange,MaxRange:real);
    var i:Integer;
        count:word;
        alpha:extended;
    begin
      if not UseMaxMin then
        exit;

      if MinRange>=MaxRange then
        exit;

      for I := 0 to ValuesMaxMin.count-1  do
        begin
        if TMinMaxStaus(ValuesMaxMin.arr[i].Tag) in [mmsMainMax, mmsMinorMax] then
          begin
          if  MaxFunc(ValuesMaxMin.arr[i].Tag2, alpha) in [mmsNoMinMax, mmsEnd] then
            continue;
          end
        else  if TMinMaxStaus(ValuesMaxMin.arr[i].Tag) in [mmsMin] then
          if  MinFunc(ValuesMaxMin.arr[i].Tag2, alpha) in [mmsNoMinMax, mmsEnd] then
            continue;

        if IsInRange( alpha ,MinRange,MaxRange) then
          CalcPointsNearMax(alpha,MinRange,MaxRange);
        end;
    end;

    {==============================================================================
      Function:    GetStep
    ==============================================================================}
    function GetStep(oldx,oldy,newx,newy:real):real;
    const MaxSteigungThenMinStep=5;
    var Steigung:real;
    begin
      if newx-oldx=0 then
        begin
        result:=(MaxStep+MinStep)/2;
        exit;
        end;

      Steigung:=abs((newy-oldy)/(newx-oldx));
      result:=MinStep+(MaxStep-MinStep)*(1-Steigung/MaxSteigungThenMinStep);
      korrigiere(result,MinStep,MaxStep);
    end;


    {==============================================================================
      Procedure:    DelRange
    ==============================================================================}
    procedure DelRange(Minidx,Maxidx:integer);
    var r,abstand:real;
    begin
      //zu viele Werte löschen
      r:=0;
      abstand:=Verhaeltnis/(Verhaeltnis-1)*3; // abstand von den Indexen der einzelnen Werten
      while round(r)<=Values.Count-1 do
        begin
        if True then

        Values.Delete(round(r));
        r:=r+abstand-1;  // minus 1 da die Werte 1 vorrücken
        end;
    end;


    {==============================================================================
      Procedure:    CalcImportant
    ==============================================================================}
    procedure CalcRange(MinRange,MaxRange:real);
    var oldx,oldLS,newx,newLS,newImage,Step, r:real;
        s:TVec;
    begin
      if MinRange>=MaxRange then
        exit;

      CalcInterestingPoints(MinRange, MaxRange);

      r:=MinRange;

      s:=CalcAngleDeflectionVec(r);
      oldx:=funcx(s);
      oldLS:=funcLS(s);
      repeat
        s:=CalcAngleDeflectionVec(r);
        newx:=funcx(s);
        newLS:=funcLS(s);
        
        if CalcGamma then
          newImage:=funcImage(s)
        else
          newImage:=0;
          
        Values.Add(Koor3(newx,newImage,newLS, kkx, kkImage, kkLS), Chart.Color);
        Step:=GetStep(oldx,oldLS,newx,newLS);
        r:=r+Step;
        inc(NewCalculatedPoints);

        oldx:=newx;
        oldLS:=newLS;
      until r>=MaxRange;

     Values.sort(xyzkX);
    end;


    {==============================================================================
      Procedure:    ReCalc
    ==============================================================================}
    //procedure ReCalc;
    //begin

    //end;

    //{==============================================================================
      //Procedure:    CalcMove
    //==============================================================================}
    //procedure CalcMove;
    //begin
      //DelUnVisibleValues;

      ////links
      //CalcRange(mini,funcAntiX(SaS.OldChart.ZoomMin));
      ////rechts
      //CalcRange(funcAntiX(SaS.OldChart.ZoomMax),maxi);
    //end;
    {==============================================================================
      Procedure:    CalcZoom
    ==============================================================================}
    //procedure CalcZoom;
    //begin
      //Values.Clear;

      //CalcRange(Mini,maxi);
      //DelUnVisibleValues;

      //with Parent.BottomAxis do
        //if anzpixel<>0 then
          //abstand:=(maxi-r)/anzpixel/(1-Verhaeltnis)
        //else
          //abstand:=(maxi-r)/2000;  //  zeichnet die restlichen punkte

      //repeat
        //Values.Add(funcx(r),funcLS(r));
        //inc(NewCalculatedPoints);
        //r:=r+abstand;
      //until r>=maxi;
    //end;

    //{==============================================================================
      //Procedure:    CalcUnZoom
    //==============================================================================}
    //procedure CalcUnZoom;
    //begin
      //// wenn (nix passiert, bzw er zoomt) dann nix machen
      //if Verhaeltnis<=1 then
        //begin
        //ReCalc;
        //exit;
        //end;

      ////zu viele Werte löschen
      //DelRange(0,Values.Count-1);


      ////drum herum zeichnen

      ////links
      //CalcRange(mini,funcAntiX(SaS.OldChart.ZoomMin));
      ////rechts
      //CalcRange(funcAntiX(SaS.OldChart.ZoomMax),maxi);
    //end;

    {==============================================================================
      Procedure:    CalcImportant
    ==============================================================================}
    procedure CalcImportant;
    begin
      Values.Clear;

      CalcRange(mini,maxi);
    end;

begin
  DeleteFile(ExtractFilePath(ParamStr(0))+'s1.txt');
  {$IFDEF CalcTimes}
    tick:=GetTickCount;
  {$ENDIF}

  if UseMaxMin then
    if (checkMaxMin.Checked) then
      CalcMinMax(xAxisType,LSAxisType,ImageAxisType);

//  getAllspecifications;
  //BeginUpdate;
  NewCalculatedPoints:=0;

  funcx:=getXFunc(xAxisType);

  funcLS:=getLSFunc(LSAxisType);

//  funcAntiX:=getAntiXFunc(xAxisType);
  funcImage:=getImageFunc(ImageAxisType);

  //maxi:=Min(funcAntiX(Chart.Box.VisibleRect.Right),pi/2+aperture.slit.beta);   // nichts zeichnen was beim gedrehten über 90° wäre
  //Mini:=Max(funcAntiX(Chart.Box.VisibleRect.Left),-pi/2+aperture.slit.beta);  // nichts zeichnen was beim gedrehten über 90° wäre

  maxi:=CalcMaxAlpha;   // nichts zeichnen was beim gedrehten über 90° wäre
  Mini:=CalcMinAlpha;  // nichts zeichnen was beim gedrehten über 90° wäre

  if Quality=0 then
    Quality:=1;

  MaxStep:=(maxi-Mini)/1200/Quality*5.5;
  MinStep:=(maxi-Mini)/3000/Quality*5.5;

{  with self.Parent.BottomAxis do
    anzpixel:=(AxisToPixel(funcx(maxi))-AxisToPixel(funcx(r)))/Quality;}

    Verhaeltnis:=1;

  //if (funcAntiX(SaS.OldChart.ZoomMax)-funcAntiX(SaS.OldChart.ZoomMin))=0 then
    //Verhaeltnis:=1
  //else
    //Verhaeltnis:=(maxi-mini)/(funcAntiX(SaS.OldChart.ZoomMax)-funcAntiX(SaS.OldChart.ZoomMin));

  //if (Verhaeltnis=1)and(UpdatingType<>UCalcAndDraw)and(UpdatingType<>UDraw)  then  //d.h. wenn der ausschnitt nicht verändert wird sondern nur neu gezeichnet werden soll
    //begin
    //ReCalc;    // dann verlasst er diese procedure
    ////EndUpdate;
    //exit;
    //end;


  ///////////////////////////////////////////////////////////////////
  ///   wichtig                                                  ////
  ///////////////////////////////////////////////////////////////////
  //case UpdatingType of
    ////UMove: CalcMove;
    ////UZoom: CalcZoom;
    ////UUnZoom: CalcUnZoom;
    ////Uimportant: CalcImportant;
  //end;
  CalcImportant;

//  Values.Sort;

  //log
  form1.AddLog(self.ClassName+inttostr(number)+' wurde berechnet',self.Chart.Color);
  
  {$IFDEF CalcTimes}
    WriteLn(ClassName+' Nr.'+IntToStr(number)+'  Time per Value ='+floattostr((GetTickCount-tick)/Values.count*1000)+' microseconds');
  {$ENDIF}
end;



procedure TSingleSlit.DrawOGL;
begin
  TLineChart(Chart).DrawOGL;
  if UseMaxMin then
    ChartMinMax.DrawOGL;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    MakeRightColor
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TSingleSlit.MakeRightColor;
begin
  self.LED.ColorOn:=WavelengthToRGB(SaS.Source[number].lambda{*1E9});   //das ruft nämlich die property auf und ich kann mir pen.color sparen
  dialog.Color:=self.LED.ColorOn;
  Chart.Color:=self.LED.ColorOn;
  if UseMaxMin then
    ChartMinMax.Color:=self.LED.ColorOn;
end;






{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit
TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit
TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit  TRSNSlit
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}




{==============================================================================
  Procedure:    create	
  Belongs to:   TRSNSlit
  Result:       None
  Parameters:   
                  AOwner : TComponent  =   
                  thisparent : TRSCustomChartPanel  =   
                  anumber : byte  =
                    
  Description:  
==============================================================================}
constructor TRSNSlit.create(AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte; aCreateMaxMin:boolean);
begin
  inherited;

  SlitType:=MyN;
  ShowMinLabels:=false;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeCaption
  Arguments:    (var checkbox:TCheckbox)
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TRSNSlit.writeCaption(var checkbox:TCheckbox);
begin
  checkbox.Caption:='(Gitter ohne Einzelspaltüberlagerung)';
  checkbox.Font.Size:=8;
  CalcMaxima:=true;
  CalcMinima:=false;
  Visible:=false;
end;

function TRSNSlit.PathDifferenceOfVec(s: TVec): extended;
var cosalpha1,cosalpha2,beta:extended;
  l0:Tvec;
begin
  beta:=aperture.slit.beta;
  l0:=Vec(-1,0,0);

  cosalpha1:= -l0 * CalcGyVec ;
  cosalpha2:=s * CalcGyVec ;

  result:=aperture.slit.distance * ( cosalpha1 + cosalpha2 ) / SaS.Source[number].lambda;
end;



//{-----------------------------------------------------------------------------
  //Description:
  //Procedure:    CalcMinMax
  //Arguments:    xAxisType:TxAxisType; LSAxisType:TLSAxisType; percision:word=0
  //Result:       None
  //Detailed description:
//-----------------------------------------------------------------------------}
//procedure TRSNSlit.CalcMinMax(xAxisType:TxAxisType; LSAxisType:TLSAxisType;   ImageAxisType:TImageAxisType; percision:word=0);
//var funcLS,funcx, funcImage:TFunctionVecType;
    //i:integer;

    //arMin,arMax:TRealArray;
//begin
  //if not UseMaxMin then
    //exit;

  //funcLS:=getLSFunc(LSAxisType);
  //funcx:=getXFunc(xAxisType);
  //FuncImage:=getImageFunc(ImageAxisType);

  //arMin:=TRealArray.Create;
  //arMax:=TRealArray.Create;
  //try
    ////ins array schreiben
    //for i:=0 to NSlitCountMax do
      //arMax.insert(i,NSlitMaxtoAlpha(i));
    //for i:=0 to NSlitCountMin do
      //arMin.insert(i,NSlitMintoAlpha(i));

    //arMin.delete(0);
    ////überschneidungen rauswerfen
    //arMin.DelDubbleValues(arMax,[0]);

    ////ins diagramm zeichnen
    //with self.ChartMinMax do
      //begin
      //ValuesMaxMin.Clear;
      //Font.Color:=self.Chart.Color;
      //for i:=0 to arMin.count-1 do
        //begin
        //ValuesMaxMin.Add(Koor3(funcx(arMin[i]), funcImage(arMin[i]), funcLS(arMin[i]), kkx, kkImage, kkLS),inttostr(i)+'. Min');
        //ValuesMaxMin.Add(Koor3(funcx(-arMin[i]), funcImage(-arMin[i]), funcLS(-arMin[i]), kkx, kkImage, kkLS),inttostr(i)+'. Min');
        //end;
      //for i:=0 to arMax.count-1 do
        //begin
        //arMax[i]:=findnextMaxMin(funcLS,arMax[i],-pi/2,pi/2,true);
        //ValuesMaxMin.Add(Koor3(funcx(arMax[i]),funcImage(arMin[i]), funcLS(arMax[i]), kkx, kkImage, kkLS),inttostr(i)+'. Max');
        //ValuesMaxMin.Add(Koor3(funcx(-arMax[i]), funcImage(-arMin[i]), funcLS(-arMax[i]), kkx, kkImage, kkLS),inttostr(i)+'. Max');
        //end;

      //end;
  //finally
    //arMin.Free;
    //arMax.Free;
  //end;
//end;




//{==============================================================================
  //Procedure:    alpha2lambda
  //Belongs to:   TRSNSlit
  //Result:       extended
  //Parameters:
                  //alpha : extended  =

  //Description:
//==============================================================================}
//function TRSNSlit.alpha2lambda(alpha:extended):extended;
//begin
  //result:=aperture.slit.distance * sin(alpha) / SaS.Source[number].lambda;
//end;


//{==============================================================================
  //Procedure:    lambda2alpha
  //Belongs to:   TRSNSlit
  //Result:       extended
  //Parameters:
                  //lambda : extended  =

  //Description:
//==============================================================================}
//function TRSNSlit.lambda2alpha(lambda:extended):extended;
//var temp:extended;
//begin
  //temp:=lambda*SaS.Source[number].lambda/aperture.slit.distance;
  //korrigiere(temp,-1,1);
  //result:=arcsin(temp);
//end;

function TRSNSlit.MaxFunc(z:integer; var alpha:Extended):TMinMaxStaus;
var l0MalGx:extended;
begin
  l0MalGx:=Vec(-1,0,0) * CalcGyVec;

  alpha:=z*SaS.Source[number].lambda/aperture.slit.distance +l0MalGx;

  if IsInRange(alpha, -1,1) then
    begin
    Result:=mmsMainMax;
    alpha:=aperture.slit.beta + arcsin(alpha );

    if not IsInRange(alpha, CalcMinAlpha, CalcMaxAlpha) then
      Result:=mmsEnd;
    end
  else
    Result:=mmsEnd;
end;


function TRSNSlit.MinFunc(z:integer; var alpha:Extended):TMinMaxStaus;
begin
  Result:=mmsEnd;
  alpha:=0;

  //if not IsInRange(alpha, CalcMinAlpha, CalcMaxAlpha) then
    //Result:=mmsEnd;
end;



//{-----------------------------------------------------------------------------
  //Description:
  //Procedure:    NSlitCountMax
  //Arguments:    None
  //Result:       word
  //Detailed description:
//-----------------------------------------------------------------------------}
//function  TRSNSlit.NSlitCountMax:word;
//begin
  //result:=trunc(aperture.slit.distance/SaS.Source[number].lambda);
//end;


//{-----------------------------------------------------------------------------
  //Description:
  //Procedure:    NSlitCountMin
  //Arguments:    None
  //Result:       word
  //Detailed description:
//-----------------------------------------------------------------------------}
//function  TRSNSlit.NSlitCountMin:word;
//begin
  //result:= trunc(aperture.slit.count*aperture.slit.width/SaS.Source[number].lambda);
//end;



//{-----------------------------------------------------------------------------
  //Description:  gibt den winkel der Maxima nter ordnung an
  //Procedure:    NSlitMaxtoAlpha
  //Arguments:    N:integer
  //Result:       extended
  //Detailed description:
//-----------------------------------------------------------------------------}
//function TRSNSlit.NSlitMaxtoAlpha(N:integer):extended;
//var pre:real;
//begin
  //// Open Formel Maximum: %alpha = arcsin left (n cdot %lambda over g - sin(%beta)right )+%beta        newline                 newline                  %alpha = arcsin left (- n cdot %lambda over g - sin(%beta)right )+%beta

  //result:=0;

  //pre:=abs(n)*SaS.Source[number].lambda/aperture.slit.distance;
//{  if pre>1 then
    //showmessage('hilfw');}
  //if (abs(n)<=NSlitCountMax)and(pre<=1) then
    //result:=arcsin( pre );

  //result:=sign(n)*result;
//end;



//{-----------------------------------------------------------------------------
  //Description:  gibt den winkel der Minima nter ordnung an
  //Procedure:    NSlitMintoAlpha
  //Arguments:    N:integer
  //Result:       extended
  //Detailed description:
//-----------------------------------------------------------------------------}
//function TRSNSlit.NSlitMintoAlpha(N:integer):extended;
//begin
  //// Open Formel Minimum: %alpha = arcsin left (n cdot %lambda over {N cdot g} - sin(%beta)right )+%beta        newline                 newline                  %alpha = arcsin left (- n cdot %lambda over {N cdot g} - sin(%beta)right )+%beta

  //result:=0;
  //if (abs(n)>0)and(abs(n)<=NSlitCountMin-1) then
    //result:=arcsin( abs(n)*SaS.Source[number].lambda/aperture.slit.distance/aperture.slit.count );

  //result:=sign(n)*result;
//end;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    NSlitAmplitude
  Arguments:    alpha:extended
  Result:       extended
  Detailed description:

      Formel über Zeigerdarstellung herleiten
      Zwei Sinus Beziehungen suchen und durcheinanderer Dividiren und nach A(alpha) auflösen
-----------------------------------------------------------------------------}
function TRSNSlit.NSlitAmplitude(s:TVec):extended;   // Formel die Für 2 Spalten Stimmt
const delta=0.000001;
var phi,cosalpha1,cosalpha2, Gangunterschied, beta:extended;
  l0:Tvec;
begin
  beta:=aperture.slit.beta;
  l0:=Vec(-1,0,0);

  cosalpha1:= -l0 * CalcGyVec  ;
  cosalpha2:= s * CalcGyVec ;

  Gangunterschied:=aperture.slit.distance * ( cosalpha1 + cosalpha2 );
  phi:= 2*pi*Gangunterschied / SaS.Source[number].lambda;

  if abs(sin(phi/2))>delta then
    result:=1* sin(aperture.slit.count*phi/2)/(aperture.slit.count*sin(phi/2))
  else
    result:=1* cos(aperture.slit.count*phi/2)/(cos(phi/2));
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    NSlitIntensity
  Arguments:    alpha:extended
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function TRSNSlit.NSlitIntensity(s:TVec):extended;
begin
  result:=sqr(self.NSlitAmplitude(s));
end;




//{==============================================================================
  //Procedure:    getInterestingPointInfo
  //Belongs to:   TSingleSlit
  //Result:       TInterestingFunctionType
  //Parameters:
                  //CountPoints : word  =

  //Description:
//==============================================================================}
//function  TRSNSlit.getInterestingPointInfo(var CountPoints:word):TInterestingFunctionType;
//begin
  //CountPoints:=NSlitCountMax;
  //result:=@NSlitMaxtoAlpha;
//end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    getImageFunc
  Arguments:    LSAxisType:TLSAxisType
  Result:       TFunctionVecType
  Detailed description:                  //  TLSAxisType=(Amplitude,Intensity,BrigthDark);
-----------------------------------------------------------------------------}
function  TRSNSlit.getLSFunc(LSAxisType:TLSAxisType):TFunctionVecType;
begin
  case LSAxisType of
    LSAmplitude: result:=@NSlitAmplitude;
    LSIntensity: result:=@NSlitIntensity;
  end;
end;




{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit
TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit
TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit  TCombiSlit
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}





{==============================================================================
  Procedure:    create	
  Belongs to:   TCombiSlit
  Result:       None
  Parameters:   
                  AOwner : TComponent  =   
                  thisparent : TRSCustomChartPanel  =   
                  anumber : byte  =
                    
  Description:
==============================================================================}
constructor TCombiSlit.create(AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte; aCreateMaxMin:boolean);
begin
  inherited;

  SlitType:=MyCombi;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeCaption
  Arguments:    (var checkbox:TCheckbox)
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TCombiSlit.writeCaption(var checkbox:TCheckbox);
begin
  checkbox.Caption:='reales Gitter';
  CalcMaxima:=true;
  CalcMinima:=false;
  Visible:=true;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    CombiSlitAmplitude
  Arguments:    alpha:extended
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function TCombiSlit.ApproxCombiSlitAmplitude(s:TVec):extended;   // Formel die Für 2 Spalten Stimmt
begin
  result:=self.NSlitAmplitude(s) *  self.OneSlitAmplitude(s);
end;


{==============================================================================
  Procedure:    HuygensCombiSlitAmplitude	
  Belongs to:   TCombiSlit
  Result:       extended
  Parameters:   
                  alpha : extended  =   
                    
  Description:  
==============================================================================}
function TCombiSlit.HuygensCombiSlitAmplitude(s:TVec):extended;   // Formel die Für 2 Spalten Stimmt
var i:integer;
    temp:real;

    const1,e2,a,g,
    x,y:real;
begin
  const1:=2*pi/SaS.source[number].lambda;
  e2:=sqr(aperture.ScreenDistance);
  a:=XKoorStrechtedOfVec(s);
//  a:=aperture.ScreenDistance*tan(alpha);
  g:=aperture.slit.distance;

  x:=0;
  y:=0;
  a:=a- aperture.slit.count/2 *g;

  for I := 0 to aperture.slit.count-1 do
    begin
    temp:=const1* sqrt( e2 + sqr(a + i*g) );

    x:=x+cos(temp);
    y:=y+sin(temp);
    end;

  x:=x* OneSlitAmplitude(s)/aperture.slit.count;
  y:=y* OneSlitAmplitude(s)/aperture.slit.count;

  result:=sqrt(sqr(x)+sqr(y));
end;




{==============================================================================
  Procedure:    CombiSlitAmplitude
  Belongs to:   TCombiSlit
  Result:       extended
  Parameters:
                  alpha : extended  =

  Description:
==============================================================================}
function TCombiSlit.CombiSlitAmplitude(s:TVec):extended;   // Formel die Für 2 Spalten Stimmt
begin
  case SaS.UsedFormula of
    UFApprox:   Result:=ApproxCombiSlitAmplitude(s);
    UFHuygens:  Result:=HuygensCombiSlitAmplitude(s);
  end;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    CombiSlitIntensity
  Arguments:    alpha:extended
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function TCombiSlit.CombiSlitIntensity(s:TVec):extended;
begin
  result:=sqr(CombiSlitAmplitude(s));
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    getImageFunc
  Arguments:    LSAxisType:TLSAxisType
  Result:       TFunctionVecType
  Detailed description:                  //  TLSAxisType=(Amplitude,Intensity,BrigthDark);
    ich muss trotz gleichem Inhalt in TCombiSlit.getImageFunc und TRSNSlit.getImageFunc
    aufführen damit TCombiSlit.NSlitIntensity ausgeführt wird und nicht die geerbte Funktion die inherited getImageFunc
    Auch result:=inheritet getImageFunc(LSAxisType) kann ich nicht schreiben, da es das selbe ist
    Auch override von der getImageFunc kann ich nicht machen da sonst ich das
         result:=OneSlitIntensity(alpha) *  inherited NSlitIntensity(alpha);
    nicht ausführen künnte
-----------------------------------------------------------------------------}
function  TCombiSlit.getLSFunc(LSAxisType:TLSAxisType):TFunctionVecType;
begin
  case LSAxisType of
    LSAmplitude: result:=@CombiSlitAmplitude;
    LSIntensity: result:=@CombiSlitIntensity;
  end;
end;




//{-----------------------------------------------------------------------------
  //Description:
  //Procedure:    CalcMinMax
  //Arguments:    xAxisType:TxAxisType; LSAxisType:TLSAxisType; percision:word=0
  //Result:       None
  //Detailed description:
//-----------------------------------------------------------------------------}
//procedure TCombiSlit.CalcMinMax(xAxisType:TxAxisType; LSAxisType:TLSAxisType; ImageAxisType:TImageAxisType;  percision:word=0);
//var funcLS,funcx, funcImage:TFunctionVecType;
    //i:integer;

    //arMin,arSingleMin,arMax:TRealArray;
//begin
  //if not UseMaxMin then
    //exit;

  //funcLS:=getLSFunc(LSAxisType);
  //funcx:=getXFunc(xAxisType);
  //FuncImage:=getImageFunc(ImageAxisType);

  //arMin:=TRealArray.Create;
  //arMax:=TRealArray.Create;
  //arSingleMin:=TRealArray.Create;
  //try
    ////ins array schreiben
    //for i:=0 to NSlitCountMax do
      //arMax.insert(i,NSlitMaxtoAlpha(i));
    //for i:=0 to NSlitCountMin do
      //arMin.insert(i,NSlitMintoAlpha(i));
    //for i:=0 to SingleSlitCountMin do
      //arSingleMin.insert(i,SingleSlitMintoAlpha(i));


    //arMin.delete(0);
    //arSingleMin.delete(0);
    ////überschneidungen rauswerfen
    //arMax.DelDubbleValues(arSingleMin,[0]);
    //arMin.DelDubbleValues(arMax,[0]);

    ////ins diagramm zeichnen
    //with self.ChartMinMax do
      //begin
      //ValuesMaxMin.Clear;
      //Font.Color:=self.Chart.Color;
      //for i:=0 to arMin.count-1 do
        //begin
//{        Values.Add(funcx(arMin[i]),funcLS(arMin[i]),inttostr(i)+'. Minimum',self.Color);
        //Values.Add(funcx(-arMin[i]),funcLS(-arMin[i]),inttostr(i)+'. Minimum',self.Color);}
        //end;
      //for i:=0 to arMax.count-1 do
        //begin
        //arMax[i]:=findnextMaxMin(funcLS,arMax[i],-pi/2,pi/2,true);
        //ValuesMaxMin.Add(Koor3(funcx(arMax[i]), funcImage(arMin[i]), funcLS(arMax[i]), kkx, kkImage, kkLS),inttostr(i)+'. Max',self.Chart.Color);
        //ValuesMaxMin.Add(Koor3(funcx(-arMax[i]), funcImage(-arMin[i]), funcLS(-arMax[i]), kkx, kkImage, kkLS),inttostr(i)+'. Max',self.Chart.Color);
        //end;
      //end;
  //finally
    //arMin.Free;
    //arMax.Free;
    //arSingleMin.Free;
  //end;
//end;



{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity
TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity
TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity  TImageIntensity
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}



{-----------------------------------------------------------------------------
  Description:
  Procedure:    create
  Arguments:    AOwner: TComponent; thisparent:TRSCustomChartPanel; number:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
constructor TImageIntensity.create(AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte; aCreateMaxMin:boolean);
begin
  inherited;

  Chart.Free;
  Chart:=TBorderdBackgroundChart.Create(abox, Values);
  Chart.Depth:=Koor1(-255+number,kkz);
  Chart.IntensityColorFactor:=SaS.IntensityColorFactor;
  Chart.WhatIsYValue:=xyzkY;
  
  if UseMaxMin then
    ChartMinMax.WhatIsYValue:=xyzkY;

  SlitType:=MyImage;
  CalcGamma:=true;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    destroy
  Arguments:    None
  Result:       None
  Detailed description:    wichtig, da bmp zu garnix gehört und unbedingt hier weider zerstört werden muss
-----------------------------------------------------------------------------}
destructor TImageIntensity.destroy;
begin
  inherited;
end;



{==============================================================================
  Procedure:    Draw2ColorLine
  Belongs to:   TImageIntensity
  Result:       None
  Parameters:
                  xPos1 : word  =
                  xPos2 : word  =
                  Col1 : TColor  =
                  Col2 : TColor  =
                  Intensity1 : real  =
                  Intensity2 : real  =

  Description:
==============================================================================}
//procedure TImageIntensity.Draw2ColorLine(xPos1,xPos2:word; Col1,Col2:TColor; Intensity1,Intensity2:real);
//var I:integer;
    //col:Tcolor;
    //perc:real;
//begin
  //for I := xPos1 to xPos2 do
    //begin
    //if xPos1=xPos2 then
      //perc:=0.5
    //else
      //perc:=(i-xPos1)/(xPos2-xPos1);

    //col:=AddColors(col1,col2,(1-perc)*Intensity1,perc*Intensity2);

    //self.bmp.Canvas.Pixels[i,0]:=col;
    //end;
//end;





{==============================================================================
  Procedure:    DrawColorLine	
  Belongs to:   TImageIntensity
  Result:       None
  Parameters:   
                  xPos1 : word  =   
                  xPos2 : word  =   
                  Col : TColor  =   
                  Intensity : real  =   
                    
  Description:  
==============================================================================}
//procedure TImageIntensity.DrawColorLine(xPos1,xPos2:word; Col:TColor; Intensity:real);
//begin
  //with bmp.Canvas do
    //begin
    //Pen.Color:= IntensityColor(col,Intensity);
    //MoveTo(xPos1,0);
    //LineTo(xPos2,0);
    //end;
//end;



{==============================================================================
  Procedure:    DrawPixel	
  Belongs to:   TImageIntensity
  Result:       None
  Parameters:   
                  xPos : word  =   
                  Col : TColor  =   
                  Intensity : real  =   
                    
  Description:
==============================================================================}
//procedure TImageIntensity.DrawPixel(xPos:word; Col:TColor; Intensity:real);
//begin
  //with bmp.Canvas do
    //Pixels[xPos,0]:=IntensityColor(col,Intensity);
//end;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeCaption
  Arguments:    (var checkbox:TCheckbox)
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TImageIntensity.writeCaption(var checkbox:TCheckbox);
begin
  checkbox.Caption:='Schirmbild';
  if assigned(self.checkMaxMin) then
    self.checkMaxMin.Checked:=true;
  CalcMaxima:=true;
  CalcMinima:=false;
  Visible:=true;
end;










procedure TImageIntensity.DrawOGL;
begin
  TBackgroundChart(Chart).DrawOGL;
  if UseMaxMin then
    ChartMinMax.DrawOGL;
end;









{==============================================================================
  Procedure:    Calc
  Belongs to:   TImageIntensity
  Result:       None
  Parameters:
                  xAxisType : TxAxisType  =
                  LSAxisType : TLSAxisType  =
                  UpdatingType : TUpdatingType  =
                  Quality : real  = 2

  Description:  Hier wird die Zusammenfassende Arebit gemacht, nämlich das zeichnen
==============================================================================}
//procedure TImageIntensity.Calc(xAxisType:TxAxisType; LSAxisType:TLSAxisType; UpdatingType:TUpdatingType;  Quality:real=5.5);
//var funcx,funcAntiX:TFunctionVecType;
    //lcut,rcut:integer;
    //ZMin,constFak:real;



    //{==============================================================================
      //Procedure:    XtoPixel
      //Parameters:
                      //r : real  =
    //==============================================================================}
    ////function XtoPixel(r:real):integer;
    ////begin
      ////result:=trunc(  (  funcx(r) - Zmin )/constFak   +lcut );
    ////end;



    //{==============================================================================
      //Procedure:    XtoPixel
      //Parameters:
                      //r : real  =
    //==============================================================================}
    ////function DistanceInPixel(r1,r2:real):integer; overload;
    ////begin
      ////result:=abs(XtoPixel(r2)-XtoPixel(r1));
    ////end;
    ////function DistanceInPixel(Pixel1:integer; r1:real):integer; overload;
    ////begin
      ////result:=abs(Pixel1-XtoPixel(r1));
    ////end;
    ////function DistanceInPixel(Pixel1,Pixel2:integer):integer; overload;
    ////begin
      ////result:=abs(Pixel1-Pixel2);
    ////end;



    //{==============================================================================
      //Procedure:    MaxValue
      //Belongs to:   None
      //Result:       real
      //Parameters:
                      //OnPointI : integer  =
                      //SearchFirstIdx : boolean  =
                      //FirstIdx : integer  =
                      //slitobject : TRSChart  =
                      //funcAntiX : TFunctionVecType  =
                      //NextFirstIdx : integer  =

      //Description:    Sucht den Maximalwert auf einem Bildpunkt (=OnPointI) und gibt den Wert zurück
                      //Damit man wenn, was der nächste Index außerhalb dieses Bildpunktes ist, gibt er
                        //auch NextFirstIdx zurück
    //==============================================================================}
    ////function MaxValue(OnPointI:integer; SearchFirstIdx:boolean; FirstIdx:integer;  slitobject:TChart; funcAntiX:TFunctionVecType; var NextFirstIdx:integer):real;
    ////var i:word;
        ////temp:real;
    ////begin
      ////if SearchFirstIdx or
        ////(FirstIdx<slitobject.Values.Count)and(XtoPixel(funcAntiX(slitobject.Values[FirstIdx].X))<>OnPointI) then    // suche ersten idx der auf den Bildpunkt  OnPointI füllt
        ////for I := 0 to slitobject.Values.Count - 1 do                                  // wenn es gefordert wird, oder wenn die angegebenen Werte nicht stimmen
          ////if XtoPixel(funcAntiX(slitobject.Values[i].Pos.X))=OnPointI then
            ////begin
            ////FirstIdx:=i;
            ////break;
            ////end;

      ////result:=0;
      ////for I := FirstIdx to slitobject.Values.Count-1 do    // laufe die idx weiter durch bis es den bildpunkt verlässt
        ////begin
        ////if XtoPixel(funcAntiX(slitobject.Values[i].Pos.x))<>OnPointI then
          ////begin
          ////NextFirstIdx:=i;
          ////break;
          ////end;

        ////temp:=slitobject.Values[i].Pos.LS;
        ////if abs(Result)<abs(temp) then
          ////Result:=abs(temp);
        ////end;
    ////end;



    //{==============================================================================
      //Procedure:    SumValue
      //Belongs to:   None
      //Result:       real
      //Parameters:
                      //OnPointI : integer  =
                      //SearchFirstIdx : boolean  =
                      //FirstIdx : integer  =
                      //slitobject : TRSChart  =
                      //funcAntiX : TFunctionVecType  =
                      //NextFirstIdx : integer  =

      //Description:  Schlechter Versucht!!! Wird nicht benutzt!!!
    //==============================================================================}
//{    function SumValue(OnPointI:integer; SearchFirstIdx:boolean; FirstIdx:integer;  slitobject:TRSChart; funcAntiX:TFunctionVecType; var NextFirstIdx:integer):real;
    //var i:word;
        //temp:real;
    //begin
      //if SearchFirstIdx or
        //(FirstIdx<slitobject.Values.Count)and(XtoPixel(funcAntiX(slitobject.Values.Items[FirstIdx].X))<>OnPointI) then    // suche ersten idx der auf den Bildpunkt  OnPointI füllt
        //for I := 0 to slitobject.Values.Count - 1 do                                  // wenn es gefordert wird, oder wenn die angegebenen Werte nicht stimmen
          //if XtoPixel(funcAntiX(slitobject.Values.Items[i].X))=OnPointI then
            //begin
            //FirstIdx:=i;
            //break;
            //end;

      //result:=0;
      //for I := FirstIdx to slitobject.Values.Count-1 do    // laufe die idx weiter durch bis es den bildpunkt verlässt
        //begin
        //if XtoPixel(funcAntiX(slitobject.Values.Items[i].x))<>OnPointI then
          //begin
          //NextFirstIdx:=i;
          //break;
          //end;

        //temp:=slitobject.Values.Items[i].LS;
        //Result:=Result+temp;
        //end;
      //korrigiere(Result,0,1);
    //end;}


   //{==============================================================================
      //Procedure:    CalcAllCases
      //Description:  Hier zeichnet er es, egal ob neue Werte berechnet werden müssen, oder ob sie aus dem
                    //CombiArray genommen werden.
                    //Falls noch keine Werte da sind und kein CombiArray da ist, dann berechnet er die
                    //Werte erst in das eigene ValueArray und zeichnet dann

                    //Da die Werte nicht regelmäßig verteilt sind, sind manchmal mehrere Werte
                    //auf einem Bildpunkt, und manchmal weniger. Damit aber alle Punkte gezeichnet werden
                    //aber auch nicht mehrfach, ist es nötig zu unterschieden, ob die Punkte mehr oder weniger als
                    //einen Bildpunkt auseinanderliegen.
    //==============================================================================}
    ////procedure CalcAllCases(WithCombiValues:boolean);
    ////var i,j{,FirstIdx},NextFirstIdx:integer;
        ////slitobject:TChart;
        ////funcAntiX:TFunctionVecType;
        ////oldy,newy:real;
        ////oldx,newx:integer;
        ////LastDrawedWithSpecialSum,
        ////ExtendedLog:boolean;
    ////begin
      ////ExtendedLog:=form1.CheckPixelExtendedImageIntesity.Checked;
      ////// Dieser Abschnitt regelt, ob Werte übernommen, oder neu berechnet werden
      ////// und in welchem array diese dann landen
      ////if WithCombiValues then   //selbst berechnen oder auslesen aus combivalues?
        ////begin
        ////slitobject:=TScreem(self.Owner).CombiSlit;
        ////funcAntiX:=getAntiXFunc(xAxisType);
        ////end
      ////else
        ////begin
        ////slitobject:=self;
        ////funcAntiX:=@returnValue;
        ////Calc(xAxisType, LSAxisType, UpdatingType, false,true, Quality);


        ////if (slitobject.Values.Count<=0)and(UpdatingType<>UCalcAndDraw) then   // falls er keine Ergebnisse hat, weil flaser Update Typ
          ////Calc(xAxisType, LSAxisType, UCalcAndDraw, false,true, Quality);
        ////if (slitobject.Values.Count<=0) then   // falls er immer noch keine Ergebnisse hat, dann muss er raus gehen
          ////exit;
        ////end;


      ////with slitobject do
        ////begin
////{        FirstIdx:=0;   }
        ////NextFirstIdx:=0;
        ////LastDrawedWithSpecialSum:=false;

        ////oldx:=XtoPixel(funcAntiX(Values[0].X));
        ////oldy:=abs(Values[0].LS);
        ////for I := 1 to Values.Count-1 do    // er zählt die werte im Array durch
          ////begin
          ////newx:=XtoPixel(funcAntiX(Values[i].Pos.X)); // den x wert berechnen


          ////if (oldx=newx){and(i<=Values.Count-2)and(DistanceInPixel(newx,funcAntiX(Values.Items[i+1].X))<1)} then      // wenn der neue x-Wert = dem nächsten, bedeutet das sie liegen auf dem selben Bildpunkt,
                                                                  ////// was zur folge hat, dass er das Maximum suchen muss
            ////begin
            ////if LastDrawedWithSpecialSum  then    // er darf nicht immer wieder das Maxiumum suchen und zeichnen
              ////begin           // er muss hier sobald er es einmal gezeichnet hat weiter bis zum nächsten Punkt
              ////if ExtendedLog then form1.AddLog('Continue bei '+inttostr(newx));
              ////continue;
              ////end;


            ////newy:=MaxValue(newx,false,i,slitobject,funcAntiX,NextFirstIdx);   // das Maximum suchen und zeichnen

            ////CalcPixel(newx,self.Pen.Color,newy);                  // Jetzt zeichnet er den einen Pixel

            ////LastDrawedWithSpecialSum:=true;
            ////if ExtendedLog then form1.AddLog('Pixel '+inttostr(newx)+ HTMLColorString('    Farbe',IntensityColor(self.Color,newy)));
            ////end
          ////else
            ////begin
            ////newy:=abs(Values[i].Pos.LS);
            ////Draw2ColorLine(oldx+1,newx,self.Pen.Color,self.Pen.Color,oldy,newy);  // Linie zwischen den "weit" entfernten Wertepaaren zeichnen

            ////LastDrawedWithSpecialSum:=false;
            ////if ExtendedLog then form1.AddLog('Line '+inttostr(oldx+1)+' bis '+inttostr(newx)+ HTMLColorString('    Farbe',IntensityColor(self.Color,newy)));
            ////end;

          ////if ExtendedLog and (newx-(oldx+1)>1)and LastDrawedWithSpecialSum then
            ////for j := oldx+1 to newx do
              ////form1.AddLog('Pixel Ausgelssen !!! i= '+inttostr(j)+  ColorString('    Farbe',IntensityColor(self.Color,newy)));


          ////oldy:=newy;
          ////oldx:=newx;
          ////end;
        ////end;



//{      oldx:=lcut;
      //oldy:=MaxValue(oldx,true,0,slitobject,funcAntiX,NextFirstIdx);
      //FirstIdx:=NextFirstIdx;

      //for i := lcut+1 to bmp.Width-rcut do
        //begin
        //newy:=MaxValue(i,false,FirstIdx,slitobject,funcAntiX,NextFirstIdx);
        //Draw2ColorLine(oldx,                 i,
                       //Self.Color,           Self.Color,
                       //oldy,                 newy);

        //FirstIdx:=NextFirstIdx;
        //oldx:=i;
        //oldy:=newy;
        //end;}
    ////end;

    //{==============================================================================
      //Procedure:    CalcNormal
    //==============================================================================}
//{    procedure CalcNormal;
    //var i,xold,xnew:integer;
        //ynew:real;
    //begiTR3Vecn
      //Calc(Values,xAxisType, LSAxisType, UpdatingType, false,true, Quality);

      //xold:=XtoPixel(Values.Items[0].X);
      //for I := 1 to Values.Count-1 do
        //begin
        //xnew:=XtoPixel(Values.Items[i].X);
        //ynew:=abs(Values.Items[i].LS);


////        DrawColorLine(trunc(i-step+lcut),trunc(i+lcut),self.Pen.Color,ynew);
        //DrawColorLine(xold,
                       //xnew,
                       //self.Pen.Color,
                       //YNew
                       //);
        //xold:=xnew;
        //end;
    //end;}


    //{==============================================================================
      //Procedure:    drawWithCombiValues
    //==============================================================================}
//{    procedure drawWithCombiValues;
    //var ynew:real;
        //i,xold,xnew:integer;
    //begin
      //with TScreem(self.Owner).CombiSlit do
        //begin
        //xold:=XtoPixel(funcAntiX(Values.Items[0].X));
        //for i:= 1 to Values.Count-1 do
          //begin
          //xnew:=XtoPixel(funcAntiX(Values.Items[i].X));

          //ynew:=abs(Values.Items[i].LS);

          //DrawColorLine(xold,xNew,self.Pen.Color,ynew);

          //xOld:=xNew;
          //end;
        //end;
    //end;}

//begin
  ////Self.BeginUpdate;
////  getAllspecifications;
  ////self.bmp.Canvas.FillRect(self.bmp.Canvas.ClipRect);

  ////lcut:=self.Parent.xAxis.AxisToPixel(self.Parent.xAxis.Minimum)-0;
  ////rcut:=self.Parent.Width- self.Parent.xAxis.AxisToPixel(self.Parent.xAxis.Maximum)-11 ;

  //funcx:=getXFunc(xAxisType);
  //funcAntiX:=getAntiXFunc(xAxisType);


  //if Quality=0 then
    //Quality:=1;


  //BackgroundChart.DrawOGL;
  ////Zmin:=self.Parent.xAxis.Minimum;
  ////constFak:=(self.Parent.xAxis.Maximum-self.Parent.xAxis.Minimum) / (self.bmp.Width-(lcut+rcut));


  ////welches zeichnen soll ermachen
  ////with TScreem(self.Owner).CombiSlit do
    ////if Visible and (Values.Count>=20) then
      ////DrawAllCases(true)
    ////else
      ////CalcAllCases(false);
//{  with TScreem(self.Owner).CombiSlit do
    //if Visible and (Values.Count>=1) then
      //CalcWithCombiValues
    //else
      //CalcNormal;}



  ////mitte markieren
////  self.bmp.Canvas.Pixels[self.Parent.BottomAxis.AxisToPixel(0),0]:=cllime;

  ////MergeBmp(SaS.Masterbmp,bmp,SaS.Masterbmp);

////  self.bmp.SaveToFile('C:\'+self.ClassName+inttostr(number)+'.bmp');


  //if Form1.CheckExImageIntensity.Checked then
    //begin
    //form1.AddLog(self.ClassName+inttostr(number)+':',self.Color);
//{    form1.AddLog('  anzpixel '+FormatFloat('#.00',anzpixel),self.Color);
    //form1.AddLog('  step '+floattostr(step),self.Color);}
    ////form1.AddLog('  lcut '+floattostr(lcut),self.Color);
    ////form1.AddLog('  rcut '+inttostr(rcut),self.Color);
    ////form1.AddLog('  max '+inttostr(self.Parent.xAxis.AxisToPixel(self.Parent.BottomAxis.ZoomMaximum)),self.Color);
    //form1.AddLog('');
    //end
  //else
    //form1.AddLog(self.ClassName+inttostr(number)+' wurde gezeichnet',self.Color);

  ////self.EndUpdate;
//end;




{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem    
TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  
TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem  TArrayItem 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}



{-----------------------------------------------------------------------------
  Description:
  Procedure:    create
  Arguments:    AOwner: TComponent;aForm:TForm1;  number:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
constructor TArrayItem.create(AOwner: TComponent; aForm:TForm1; anumber:byte);
begin
  inherited create(AOwner);

  FForm:=aForm;
  Fnumber:=anumber;
end;




procedure TArrayItem.WriteFForm(Form: TForm1);
begin
  FForm:=Form;
end;

{-----------------------------------------------------------------------------
  Description:     für property active
  Procedure:    setactive
  Arguments:    value:boolean
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TArrayItem.setactive(value:boolean);
begin
  Factive:=value;
end;


{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem
TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem
TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem  TScreem
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}


{-----------------------------------------------------------------------------
  Description:
  Procedure:    create
  Arguments:    AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
constructor TScreem.create(AOwner: TComponent;  aForm:TForm1; abox:TOGlBox; anumber:byte);
begin
  inherited create(AOwner, aForm, anumber);

  FBox:=abox;

  CalcReflection:=false;
  ColorNumber:=0;
  CheckNumber:=0;
  
  //diagramme
  SingleSlit:=TSingleSlit.Create(self,aForm, abox,number, true);

  NSlit:=TRSNSlit.Create(self,aForm, abox,number, true);

  CombiSlit:=TCombiSlit.Create(self,aForm, abox,number, true);
  //image
  ImageIntensity:=TImageIntensity.Create(self,aForm, abox,number, true);

  self.active:=false;

  self.Color:= WavelengthToRGB(SaS.Source[number].lambda{*1E9});   //das ruft nämlich die property auf und ich kann mir pen.color sparen
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    Destroy
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
destructor TScreem.Destroy;
begin
  SingleSlit.Free;
  NSlit.Free;
  CombiSlit.Free;
  ImageIntensity.Free;

  inherited destroy;
end;


{-----------------------------------------------------------------------------
  Description:     für property active
  Procedure:    setactive
  Arguments:    value:boolean
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TScreem.setactive(value:boolean);
begin
  inherited setactive(value);

  self.SingleSlit.active:=value;
  self.NSlit.active:=value;
  self.CombiSlit.active:=value;
  self.ImageIntensity.active:=value;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    getspecifications
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TScreem.getspecifications;
begin
  self.SingleSlit.getspecifications;
  self.NSlit.getspecifications;
  self.CombiSlit.getspecifications;
  self.ImageIntensity.getspecifications;

  case form.RadioXAxis.ItemIndex of
    0: xAxisType:=  xmeter;
    1: xAxisType:=  xangle;
    2: xAxisType:=  xlambda;
  end;
  case form.RadioLSAxis.ItemIndex of
    0:
      if LSAxisType<>LSAmplitude then
        LSAxisType:=  LSAmplitude;
    1:
      if LSAxisType<>LSIntensity then
        LSAxisType:=  LSIntensity;
  end;
  
  case form.RadioImageAxis.ItemIndex of
    0: ImageAxisType:=  ImageMeter;
    1: ImageAxisType:=  ImageAngle;
  end;
end;




{==============================================================================
  Procedure:    CalcAll
  Belongs to:   TScreem
  Result:       None
  Parameters:   
                  Quality : real  = 5.5  
                    
  Description:  
==============================================================================}
procedure TScreem.CalcAll(Quality:real=5.5);
begin
  Calc(true,true,true,true,Quality);
end;




{==============================================================================
  Procedure:    CalcOnlyVisible
  Belongs to:   TScreem
  Result:       None
  Parameters:   
                  UpdatingType : TUpdatingType  =   
                  Quality : real  = 5.5  
                    
  Description:  
==============================================================================}
procedure TScreem.CalcOnlyVisible(Quality:real=5.5);
begin
  Calc(self.SingleSlit.Visible,self.NSlit.Visible,self.CombiSlit.Visible,self.ImageIntensity.Visible, Quality);
end;




{==============================================================================
  Procedure:    Calc
  Belongs to:   TScreem
  Result:       None
  Parameters:   
                  OneSlit : boolean  =   
                  NSlit : boolean  =   
                  CombiSlit : boolean  =   
                  Image : boolean  =   
                  UpdatingType : TUpdatingType  =   
                  Quality : real  = 5.5  
                    
  Description:  
==============================================================================}
procedure TScreem.Calc(bSingleSlit,bNSlit,bCombiSlit,bImage:boolean; Quality:real=5.5);
begin
  getAllspecifications;
//  mrs;
  LabelChart;

  if bSingleSlit then
    SingleSlit.Calc(self.xAxisType,LSAxisType,ImageAxisType, Quality);
  if bNSlit then
    NSlit.Calc(self.xAxisType,LSAxisType,ImageAxisType, Quality);
  if bCombiSlit then
    CombiSlit.Calc(self.xAxisType,LSAxisType,ImageAxisType, Quality);
  if bImage then
    ImageIntensity.Calc(self.xAxisType,self.LSAxisType,ImageAxisType, Quality);
end;


procedure TScreem.DrawOGL(bSingleSlit, bNSlit, bCombiSlit, bImage: boolean);
begin
  getAllspecifications;
//  mrs;
  LabelChart;

  if bSingleSlit then
    SingleSlit.DrawOGL;
  if bNSlit then
    NSlit.DrawOGL;
  if bCombiSlit then
    CombiSlit.DrawOGL;
  if bImage then
    ImageIntensity.DrawOGL;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    deleteAllValues
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TScreem.deleteAllValues;
begin
  SingleSlit.Values.Clear;
  NSlit.Values.Clear;
  CombiSlit.Values.Clear;
  ImageIntensity.Values.Clear;
end;

procedure TScreem.DrawOGLOnlyVisible;
begin
  DrawOGL(self.SingleSlit.Visible,self.NSlit.Visible,self.CombiSlit.Visible,self.ImageIntensity.Visible);
end;








{-----------------------------------------------------------------------------
  Description:
  Procedure:    LabelChart
  Arguments:    xAxis:TxAxisType; LSaxis:TLSAxisType;  ImageAxis:TImageAxisType
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TScreem.LabelChart(xAxis:TxAxisType; LSaxis:TLSAxisType; ImageAxis:TImageAxisType);
var  s:string;
begin
  Box.xAxis.MainDescription:='Horizontale Ablenkung';
  Box.LSAxis.MainDescription:='Licht-Intensität/Amplitude';
  Box.ImageAxis.MainDescription:='Vertikale Ablenkung';

  with Box.xAxis do
    case xAxis of
      xangle:
        begin
        Dimension:=(*KorrectUmlaut*)('°');
        DimensionDescription:='Horizontaler Winkel';
        end;
      xmeter:
        begin
        Dimension:='m';
        DimensionDescription:='Horizontale Koordinaten';
        end;
      xlambda:
        begin
        Dimension:='lambda';
        DimensionDescription:='Gangunterschied';
        end;
    end;
  with Box.xAxis do
    if Dimension<>'' then
      Title.Text:=DimensionDescription+' in '+Dimension
    else
      Title.Text:=DimensionDescription;



  with Box.LSAxis do
    case LSaxis of
      LSAmplitude:
        begin
        Dimension:='';
        DimensionDescription:='Amplitude';
        end;
      LSIntensity:
        begin
        Dimension:='';
        DimensionDescription:='Intensit'+(*KorrectUmlaut*)('ä')+'t';
        end;
    end;
  with Box.LSAxis do
    if Dimension<>'' then
      Title.Text:=DimensionDescription+' in '+Dimension
    else
      Title.Text:=DimensionDescription;



  with Box.ImageAxis do
    case ImageAxis of
      ImageAngle:
        begin
        Dimension:=(*(*KorrectUmlaut*)*)('°');
        DimensionDescription:='Vertikaler Winkel';
        end;
      ImageMeter:
        begin
        Dimension:='m';
        DimensionDescription:='Vertikale Koordinaten';
        end;
    end;
  with Box.ImageAxis do
    if Dimension<>'' then
      Title.Text:=DimensionDescription+' in '+Dimension
    else
      Title.Text:=DimensionDescription;


  s:=Box.LSAxis.DimensionDescription;
  case xAxis of
    xangle:  s:=s+' '+(*(*KorrectUmlaut*)*)('ü')+'ber dem Winkel';
    xmeter:  s:=s+' '+(*(*KorrectUmlaut*)*)('ü')+'ber der x-Koordinate';
    xlambda:  s:=s+' '+(*(*KorrectUmlaut*)*)('ü')+'ber dem Gangunterschied';
  end;

  box.Header.Text:=s;
end;
{-----------------------------------------------------------------------------
  Description:  mache automatisch was gesucht ist
  Arguments:
-----------------------------------------------------------------------------}
procedure TScreem.LabelChart;
begin
  LabelChart(self.xAxisType,self.LSAxisType, self.ImageAxisType);
end;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    MakeAllRightColor
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TScreem.MakeAllRightColor;
begin
  self.Color:= WavelengthToRGB(SaS.Source[number].lambda);   //das ruft nämlich die property auf und ich kann mir pen.color sparen

  self.SingleSlit.MakeRightColor;
  self.NSlit.MakeRightColor;
  self.CombiSlit.MakeRightColor;
  self.ImageIntensity.MakeRightColor;
end;





{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture
Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture
Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture   Taperture
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}





constructor Taperture.create(AOwner: TComponent; aForm:TForm1);
begin
  inherited create(AOwner);

  Form:=aForm;
  
  LaserHeight:=90;
  ScreenDistance:=100;
  with self.slit do
    begin
    beta:=0;
    theta:=0;
    count:=1;
    distance:=6E-6;
    width:=1E-5;
    end;
end;


procedure Taperture.writeScreenDistance(value: real);
begin
  if value<1E-10 then
    value:=1E-10;
  FScreenDistance:=value;
end;





{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource
Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource
Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource   Tsource
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}




{-----------------------------------------------------------------------------
  Description:
  Procedure:    create
  Arguments:    AOwner: TComponent;  thisparent:Twincontrol; number:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
constructor Tsource.create(AOwner: TComponent; aForm:TForm1;  anumber:byte);
const lamNM=633;
var n:byte;

    procedure SetSettings(ed:TEdit; title,Einheit:string);
    begin
      //was ist es
      with Tlabel.Create(self) do
        begin
        Parent:=GroupBox;
        Left := 14;
        Top := n*24+4;
        Width := 77;
        caption:=title;
        end;

      //edit feld
      with ed do
        begin
        Parent:=GroupBox;
        //DisplayFormat := dfScientific;
        //DecimalPlaces := 3;
        //value := '0';
        Text:='0';
        Left := 96;
        Top := n*24+4;
        Width := 77;
        OnKeyDown:=@self.OnKeyDown;
        ShowHint:=true;
        end;
      //Einheit
      with Tlabel.Create(FForm) do
        begin
        Parent:=GroupBox;
        Left := ed.Left+ed.Width+1;
        Top := n*24+8;
        caption:=Einheit;
        end;
      inc(n);
    end;
begin
  inherited;

  n:=1;
  lambdaMin:=380;
  lambdaMax:=779;
  Fnumber:=anumber;


  //groupbox
  GroupBox := TGroupBox.Create(FForm);
  with GroupBox do
    begin
    Parent := Form.PanelLambda;
    name:='GroupBoxSource_'+inttostr(anumber);
    Width := 276;
    Height := Form.GroupShowChart.Height;
    Left := 292;
    Top := Form.GroupShowChart.Top ;
    Anchors := [akLeft, akBottom];
    Caption := 'Wellenlänge verändern';
    end;

  EditLambda:=TEdit.Create(AOwner);
  SetSettings(EditLambda,'Wellenlänge','nm');
  //EditLambda.DisplayFormat:=dfInteger;
  EditLambda.Hint:='Die Wellenlänge des Lichts';
  EditLambda.Text:='630';
  EditLambda.Name:='EditLambda_'+inttostr(anumber);
  EditLambda.OnChange:=@form.AllEditChange;

  EditFrequency:=TEdit.Create(AOwner);
  SetSettings(EditFrequency,'Frequenz','Hz');
  EditFrequency.Hint:='Die Frequenz des Lichts';
  EditFrequency.Text:='1E-14';
  EditFrequency.Name:='EditFrequency_'+inttostr(anumber);
  EditFrequency.OnChange:=@form.AllEditChange;

  //Trackbar
  TrackBar := TTrackBar.Create(AOwner);
  with TrackBar do
  begin
    Name := self.ClassName+'TrackBar_'+inttostr(anumber);
    Parent := GroupBox;
    Left := 6;
    Top := 91;
    Width := GroupBox.Width-12;
    Height := 28;
    Max := lambdaMax;
    Min := lambdaMin;
    Frequency := 20;
    TickStyle:=tsNone;
    ScalePos:=trRight;
    position:=lamNM;
    OnChange := @TrackBarChange;
  end;
  with TLabel.Create(Self) do
  begin
    Parent := GroupBox;
    Left := 6;
    Top := 79;
    Width := 111;
    Height := 20;
    Caption := 'Wellenlänge';
  end;


  Flambda:=lamNM *1E-9; //startwert    property schreibt die anderen werte

  self.active:=false;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    destroy
  Arguments:    None
  Result:       None
  Detailed description:   brauche ich nicht, da EditLambda,EditFrequency,EditEnergy zu thisparent gehören,
                        und deswegen anscheinend von Tform1 zerstört werden
-----------------------------------------------------------------------------}
destructor Tsource.destroy;
begin
  GroupBox.Free;
  EditLambda.free;
  EditFrequency.free;
  TrackBar.Free;
//  EditEnergy.free;

  inherited destroy;
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    getactive
  Arguments:    None
  Result:       boolean
  Detailed description:
-----------------------------------------------------------------------------}
function Tsource.getactive:boolean;
begin
  result:=Factive;
//  result:= self.GroupBox.Visible;
  if uanderes.boolUngleich(Factive,self.GroupBox.Visible) then
    ShowMessage('ungleich');
end;


{-----------------------------------------------------------------------------
  Description:     für property active
  Procedure:    setactive
  Arguments:    value:boolean
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure Tsource.setactive(value:boolean);
begin
  inherited setactive(value);

  self.GroupBox.Visible:=value;
//  self.GroupBox.BringToFront;
end;





{-----------------------------------------------------------------------------
  Procedure:    OnKeyDown
  Arguments:    Sender: TObject; var Key: Word; Shift: TShiftState
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure Tsource.OnKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Self.EditLambda = sender then
    Form.OnChangeMakeAll(EditLambda, Key)
  else  if Self.EditFrequency = sender then
    Form.OnChangeMakeAll(EditFrequency, Key);
  //if BeginEditKeyDown(TCustomEdit(sender), Key) then
    //exit;

  //if key = 13 then
    //begin
    //if BeginInputChange then
      //exit;

    //CalcOtherEdits(TEdit(sender));

    //self.TrackBar.Position:=round(lambdaMax+lambdaMin-strtofloat(self.EditLambda.Text));

    //EndInputChange;
    //end;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    TrackBarChange
  Arguments:    Sender: TObject
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure Tsource.TrackBarChange(Sender: TObject);
begin
  Form.OnChangeMakeAll(TrackBar);
  //Flambda:=self.TrackBar.position*1E-9;
  //WriteEdits;

  //with SaS.Screen[number] do
    //begin
    //MakeAllRightColor;
    //Form1.RelistSources;

    //with  SaS.Screen[self.number] do
      //begin
      //Calc(SingleSlit.Visible, NSlit.Visible, CombiSlit.Visible, false);
      //if ImageIntensity.Visible then
        //SaS.CalcImageIntensity;
      //SaS.box.Update;
      //end;
////    if ImageIntensity.Visible then
////      SaS.Calc(false,false,false,true,Uimportant);
////    Calc(SingleSlit.Visible,NSlit.Visible,CombiSlit.Visible,false,Uimportant);
    //end;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    CalcOtherEdits
  Arguments:    Source:TJvValidateEdit
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure Tsource.CalcOtherEdits(Source:TCustomEdit);
begin
  if Source= self.EditLambda then
    Flambda:=strtofloat(source.Text)*1E-9
  else if Source= self.EditFrequency then
    frequency:=strtofloat(Source.Text)*1E-9;

  WriteEdits;
end;


{==============================================================================
  Procedure:    WriteEdits	
  Belongs to:   Tsource
  Result:       None
  Parameters:   
                    
  Description:  
==============================================================================}
procedure Tsource.WriteEdits;
begin
  EditLambda.Text:= Formatfloat('###',lambda*1E9);
  EditFrequency.Text:= Formatfloat('###E-0',frequency);
end;

procedure Tsource.WriteEditsAndTrackbar;
var bvorher:boolean;
begin
  bvorher:=IsChangingInput;
  IsChangingInput:=true; // damit er nicht in onchynge make all geht

  WriteEdits;
  self.TrackBar.Position:=round(lambda*1E9);

  IsChangingInput:=bvorher; // damit er nicht in onchange make all geht
end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    getspecifications
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure Tsource.getspecifications;
begin
{  frequency:=strtofloat(form1.EditFrequency.text);
  energy:=strtofloat(form1.Editenergy.text);}
  Flambda:=strtofloat(self.EditLambda.Text)*1E-9;
end;





{-----------------------------------------------------------------------------
  Description:  Hier das wird ausgeführt wenn irgendeine set-Property aufgerufen wird, wegen bezug
  Procedure:    setlambda
  Arguments:    value:Double
  Result:       None
  Detailed description:  Hier aktualisiert er auch die sichtabren edits
-----------------------------------------------------------------------------}
procedure Tsource.setlambda(value:Double);
begin
  Flambda:=value;

  WriteEditsAndTrackbar;

  with SaS.Screen[number] do
    begin
    MakeAllRightColor;
    Form1.RelistSources;

    //with  SaS.Screen[self.number] do
////      if SaS.DrawingEnabled then
        //Calc(SingleSlit.Visible, NSlit.Visible, CombiSlit.Visible, ImageIntensity.Visible);
    end;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    getfrequency
  Arguments:    None
  Result:       Double
  Detailed description:    lambda=c/f        http://de.wikipedia.org/wiki/Wellenl%C3%A4nge
                            also f=c/lambda
-----------------------------------------------------------------------------}
function Tsource.getfrequency:Double;
begin
  result:=c/lambda;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    setfrequency
  Arguments:    value:Double
  Result:       None
  Detailed description:    lambda=c/f         http://de.wikipedia.org/wiki/Wellenl%C3%A4nge
-----------------------------------------------------------------------------}
procedure Tsource.setfrequency(value:Double);
begin
  lambda:=c/value;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    getenergy
  Arguments:    None
  Result:       Double
  Detailed description:        Da E=hf   http://de.wikipedia.org/wiki/Plancksches_Wirkungsquantum
-----------------------------------------------------------------------------}
function Tsource.getenergy:Double;
begin
  result:=h*frequency;
end;

{-----------------------------------------------------------------------------
  Description:
  Procedure:    setenergy
  Arguments:    value:Double
  Result:       None
  Detailed description:        Da E=hf   http://de.wikipedia.org/wiki/Plancksches_Wirkungsquantum
                              also f=E/h
-----------------------------------------------------------------------------}
procedure Tsource.setenergy(value:Double);
begin
  frequency:=value/h;
end;


end.
