{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie können es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    veröffentlicht, weitergeben und/oder modifizieren, gemäß Version 2 der Lizenz.
 Description:
-----------------------------------------------------------------------------}


unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Uanderes,UChart, StdCtrls,
  ExtCtrls, Menus, ActnList,ExpandPanels, Spin, ComCtrls, Buttons,   USimpleWebViewer,
  UGroupHeader, StdActns,UColoredBox, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    ActionDelLastLambda: TAction;
    ActionAddLambda: TAction;
    ActionESC: TAction;
    ActionFullscreen: TAction;
    ActionResetView: TAction;
    ActionUpdate: TAction;
    ActionMaximize: TAction;
    ActionResetSettings: TAction;
    ActionExportAllValues: TAction;
    ActionHelp: TAction;
    ActionAbout: TAction;
    ActionChartSettings: TAction;
    ActionVersion: TAction;
    ActionSaveSettings: TAction;
    ActionCalcAndDraw: TAction;
    ActionOpenSettings: TAction;
    ActionShowProgrammerInfo: TAction;
    ActionList1: TActionList;
    BAddLambda: TButton;
    BDelLambda: TButton;
    BHelpRotate: TSpeedButton;
    BOK: TButton;
    BSlitWidth: TSpeedButton;
    CheckAskConfirmationreflection: TCheckBox;
    CheckDrawChart: TCheckBox;
    CheckShowLSGitternetz: TCheckBox;
    CheckShowXGitternetz: TCheckBox;
    CheckViewLittleHelp: TCheckBox;
    CheckExImageIntensity: TCheckBox;
    CheckExMaximaDraw: TCheckBox;
    CheckPixelexpandedImageIntesity: TCheckBox;
    CheckPixelExtendedImageIntesity: TCheckBox;
    CheckViewLittleHelp2: TCheckBox;
    ComboSource: TColoredListBox;
    EditDistScreenSlit: TEdit;
    EditHorizontalAngle: TEdit;
    EditSlitCount: TEdit;
    EditSlitDistance: TEdit;
    EditSlitWidth: TEdit;
    EditAngle2: TEdit;
    EditVerticalAngle: TEdit;
    GroupBox2: TGroupBox;
    GroupBoxIntensityFactor: TGroupBox;
    GroupBoxQuality: TGroupBox;
    GroupColors: TGroupBox;
    GroupHorizontalAngle: TGroupBox;
    GroupLaserHeight: TGroupBox;
    GroupShowMaxMin: TGroupBox;
    GroupBox10: TGroupBox;
    GroupVerticalAngle: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelMaxCount: TLabel;
    GroupHeader1: TGroupHeader;
    GroupHeader2: TGroupHeader;
    GroupMultiSource: TGroupBox;
    GroupShowChart: TGroupBox;
    LabelPos: TLabel;
    ListCountPoints: TColoredListBox;
    ListLog: TColoredListBox;
    LMinus: TLabel;
    LPlus: TLabel;
    LSlitWidth: TLabel;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuHelpLittle: TMenuItem;
    ShowProgrammerInfo: TMenuItem;
    MenuItem8: TMenuItem;
    MyRollOutCountPoints: TPanel;
    MyRollOutHelpLittle: TMyRollOut;
    MyRollOutLog: TPanel;
    OptioAperture: TMyRollOut;
    OptioExtended: TMyRollOut;
    OptioRotate: TMyRollOut;
    OptioChart: TMyRollOut;
    OptioScreen: TMyRollOut;
    Panel1: TPanel;
    PanelOGLBox: TPanel;
    PBOK: TPanel;
    PanelLambda: TPanel;
    RadioGroupFormel: TRadioGroup;
    RadioImageAxis: TRadioGroup;
    RadioLSAxis: TRadioGroup;
    RadioReflection: TRadioGroup;
    RadioXAxis: TRadioGroup;
    SimpleWebViewerHelpLittle: TSimpleWebViewer;
    PProgrammerInfo: TMyRollOut;
    ProgressDraw: TProgressBar;
    PHelpRotateExpand: TPanel;
    PScrollBox1: TScrollBox;
    OptioScrollBox: TScrollBox;
    ScrollBox1: TScrollBox;
    SpinEditIntensityFactor: TSpinEdit;
    Timer1: TTimer;
    TrackBarCountSlit: TTrackBar;
    TrackBarDistScreenSlit: TTrackBar;
    TrackBarIntensityFactor: TTrackBar;
    TrackHorizontalAngle: TTrackBar;
    TrackLaserHeight: TTrackBar;
    TrackQuality: TTrackBar;
    HelpAction: THelpAction;
    PopupMenuOGLBox: TPopupMenu;
    ExpandPanelsMainOption: TExpandPanels;
    Label8: TLabel;
    MainMenu1: TMainMenu;
    ResetSettings: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuIChartSettings: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PSlitWidthExpand: TPanel;
    SaveDialog1: TSaveDialog;
    DialogExportAllValues: TSaveDialog;
    Splitter1: TSplitter;
    TrackSlitDistance: TTrackBar;
    TrackSlitWidth: TTrackBar;
    TrackVerticalAngle: TTrackBar;
    XAxisPosGroup: TRadioGroup;
    YAxisPosGroup: TRadioGroup;
    procedure ActionAboutExecute(Sender: TObject);
    procedure ActionAddLambdaExecute(Sender: TObject);
    procedure ActionCalcAndDrawExecute(Sender: TObject);
    procedure ActionChartSettingsExecute(Sender: TObject);
    procedure ActionDelLastLambdaExecute(Sender: TObject);
    procedure ActionESCExecute(Sender: TObject);
    procedure ActionExportAllValuesExecute(Sender: TObject);
    procedure ActionFullscreenExecute(Sender: TObject);
    procedure ActionHelpExecute(Sender: TObject);
    procedure ActionMaximizeExecute(Sender: TObject);
    procedure ActionOpenSettingsExecute(Sender: TObject);
    procedure ActionResetSettingsExecute(Sender: TObject);
    procedure ActionResetViewExecute(Sender: TObject);
    procedure ActionSaveSettingsExecute(Sender: TObject);
    procedure ActionShowProgrammerInfoExecute(Sender: TObject);
    procedure ActionUpdateExecute(Sender: TObject);
    procedure ActionVersionExecute(Sender: TObject);
    procedure BAddLambdaClick(Sender: TObject);
    procedure BDelLambdaClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure BHelpRotateClick(Sender: TObject);
    procedure BSlitWidthClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckDrawChartChange(Sender: TObject);
    procedure CheckShowXGitternetzChange(Sender: TObject);
    procedure CheckShowLSGitternetzChange(Sender: TObject);
    procedure CheckViewLittleHelp2Change(Sender: TObject);
    procedure CheckViewLittleHelpChange(Sender: TObject);
    procedure ComboSourceChange(Sender: TObject);
    procedure EditDistScreenSlitKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditHorizontalAngleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSlitCountChange(Sender: TObject);
    procedure EditSlitCountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSlitDistanceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AllEditChange(Sender: TObject);
    procedure EditSlitWidthKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditVerticalAngleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ExpandPanelsMainOptionArrangePanels(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure IdleFunc(Sender: TObject; var Done: Boolean);
    procedure Label10Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure MenuHelpLittleClick(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure OptioScreenClick(Sender: TObject);
    procedure ShowProgrammerInfoClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure OptioApertureCollapse(Sender: TObject);
    procedure OptioChartCollapse(Sender: TObject);
    procedure OptioChartExpand(Sender: TObject);
    procedure OptioChartPreExpand(Sender: TObject);
    procedure OptioChartResize(Sender: TObject);
    procedure OptioRotateCollapse(Sender: TObject);
    procedure OptioRotatePreCollapse(Sender: TObject);
    procedure PanelOGLBoxClick(Sender: TObject);
    procedure PanelOGLBoxEnter(Sender: TObject);
    procedure PanelOGLBoxExit(Sender: TObject);
    procedure PanelOptioApertureResize(Sender: TObject);
    procedure PProgrammerInfoResize(Sender: TObject);
    procedure RadioReflectionClick(Sender: TObject);
    procedure RadioGroupFormelClick(Sender: TObject);
    procedure RadioImageAxisClick(Sender: TObject);
    procedure RadioXAxisClick(Sender: TObject);
    procedure RadioLSAxisClick(Sender: TObject);
    procedure RadioXAxisMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1Click(Sender: TObject);
    procedure SpinEditIntensityFactorChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AllTrackChange(Sender: TObject);
    procedure TrackSlitWidthMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackSlitWidthMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure XAxisPosGroupClick(Sender: TObject);
    procedure YAxisPosGroupClick(Sender: TObject);
  private
    AreaInitialized: boolean;
    FProgrammerInfo:boolean;
    FFullScreen:boolean;
    WasPan,
    WasZoom:boolean;

    procedure setProgrammerInfo(value:boolean);
    procedure setFullScreen(value:boolean);
  public
    { Public-Deklarationen }
    PanelVisible:boolean;
    ScaleAxis:record
      ScalingY:boolean;
      DeltaY:integer;
    end;
    RegisterInfo:record
      Activated,WasStarted:boolean;
      Starts:byte;
    end;
    EnableIdleDraw:boolean;
    MouseOverBox:boolean;
    RatioSlitWidthDist:real;

    procedure OGLBoxMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
    procedure OGLBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OGLBoxMouseWheel(Sender: TObject; Shift: TShiftState;  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

    procedure SetDefaultKoors;

    procedure LabelGroupHeader;
    procedure ChangeItem(idx:byte);
    procedure AddItem(lambda:real=0);
    procedure AddItemSilent(lambda:real=0);
    procedure DelLastItem;
    procedure DelLastItemSilent;
    
    procedure CalcAndDrawOGL;

    procedure writeHints;
    
    procedure RelistSources;
    procedure PExpandVisible(sender:TObject;b:boolean);

    function OnChangeMakeAll(comp:TComponent; key:word=0):word;

    procedure AddLog(s:string; acolor:Tcolor); overload;
    procedure AddLog(s:string); overload;
    procedure CheckLog;




    property ProgrammerInfo:boolean read FProgrammerInfo write setProgrammerInfo;
    property FullScreen:boolean read FFullScreen write setFullScreen;
  end;
  
  

  { TALED }

  TALED = class(TShape)
  private
    FStatus:boolean;
    FColorOn,
    FColorOff:TColor;
    FOnColorChange:TNotifyEvent;

    procedure WriteFColorOn(ColorOn:TColor);
    procedure WriteFColorOff(ColorOff:TColor);

    procedure WriteFStatus(Status:boolean);
  public

    property Status:boolean read FStatus write WriteFStatus;
    property ColorOn:TColor read FColorOn write WriteFColorOn;
    property ColorOff:TColor read FColorOff write WriteFColorOff;
    property OnColorChange:TNotifyEvent read FOnColorChange write FOnColorChange;

    constructor Create(TheOwner: TComponent); override;
  end;
  

  procedure ShowOKButton(edit:TCustomEdit);
  procedure AceptValues;

  function BeginInputChange:boolean;
  procedure EndInputChange(BCalc:boolean=true);

  function BeginEditKeyDown(sender: TCustomEdit; var key:word):boolean;
  
  function StandartIniFile:string;


var  Form1:TForm1;

    tick: longint;
    i: integer;
    stop:boolean;

  SelectedEdit:TCustomEdit;

  IsChangingInput:boolean;
  ReadTxtInputMode:boolean;
  version:string;
  NowVisible:boolean;

  MustIdleReCalc:boolean;
  

implementation
uses unit2,uapparatus, utxt, unit4, unit3, umathe;








procedure OGLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

end;

procedure OGLMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

{==============================================================================
  Procedure:    ShowOKButton
  Belongs to:   None
  Result:       None
  Parameters:
                  edit : TCustomEdit  =

  Description:
==============================================================================}
procedure ShowOKButton(edit:TCustomEdit);
var p,endP:TPoint;
begin
  SelectedEdit:=edit;
  p:=AbsolutePosition(edit);

  with form1.PBOK do
    begin
    endP.x:=p.X+edit.Width+25;
    endP.y:=p.Y;
    
    if endP.x+Form1.PBOK.Width >Form1.Width then
      begin
      endP.x:=p.X-Form1.PBOK.Width-25;
      end;
      
    if endP.y+Form1.PBOK.Height >Form1.Height then
      begin
      endP.y:=Form1.Height-Form1.PBOK.Height;
      end;
      
    Left:=endP.x;
    Top:=endP.y;

    Show;
    BringToFront;
    end;
end;



{==============================================================================
  Procedure:    AceptValues
  Belongs to:   None
  Result:       None
  Parameters:

  Description:
==============================================================================}
procedure AceptValues;
var w:word;
begin
  form1.PBOK.Hide;
  OGLBox.DrawOGL;


  w:=13;

  if SelectedEdit is TEdit then
    TCustomEdit(SelectedEdit).OnKeyDown(SelectedEdit, w ,[])
  //if SelectedEdit.ClassName='TJvValidateEdit' then
    //TJvValidateEdit(SelectedEdit).OnKeyDown(SelectedEdit, w ,[])
  else  if SelectedEdit is TSpinEdit then
    TSpinEdit(SelectedEdit).OnKeyDown(SelectedEdit, w ,[]);
end;






function BeginInputChange: boolean;
begin
  Result:=IsChangingInput;

  if not Result then
    IsChangingInput:=true;
end;


procedure EndInputChange(BCalc:boolean);
var i,
    max:integer;
begin
  IsChangingInput:=false;

  getAllspecifications;

  if NowVisible then
    if BCalc then
      SaS.CalcAndDrawBox
    else
      OGLBox.DrawOGL;
      

  max:=0;
  for i:=0 to SaS.count-1 do
    begin
    if SaS.Screen[i].SingleSlit.Values.count>max then
      max:=SaS.Screen[i].SingleSlit.Values.count;
    if SaS.Screen[i].NSlit.Values.count>max then
      max:=SaS.Screen[i].NSlit.Values.count;
    if SaS.Screen[i].CombiSlit.Values.count>max then
      max:=SaS.Screen[i].CombiSlit.Values.count;
    if SaS.Screen[i].ImageIntensity.Values.count>max then
      max:=SaS.Screen[i].ImageIntensity.Values.count;
    end;

  form1.LabelMaxCount.Caption:='Punktzahl pro Graph: '+IntToStr(max);
end;




{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1
TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1
TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1  TForm1
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}



{-----------------------------------------------------------------------------
  Description:
  Procedure:    ChangeItem
  Arguments:    idx:byte
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TForm1.ChangeItem(idx:byte);
begin
  self.ComboSource.ItemIndex:=idx;

  SaS.ActiveNumber:=idx;
  self.GroupMultiSource.Caption:='Mehrere Wellenlängen   Aktuelle Anzahl: '+inttostr(SaS.count);

  LabelGroupHeader;
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    AddItem
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TForm1.AddItem(lambda:real=0);
begin
  self.AddItemSilent(lambda);

  self.ChangeItem(SaS.count-1);

  if (SaS.count>1) and (self.RadioXAxis.ItemIndex=2)  then
    self.RadioXAxis.ItemIndex:=1;


  if NowVisible then
    CalcAndDrawOGL;

  RelistSources;
end;



{==============================================================================
  Procedure:    RelistSources
  Belongs to:   TForm1
  Result:       None
  Parameters:

  Description:
==============================================================================}
procedure TForm1.RelistSources;
var I:integer;
begin
  if ComboSource.Items.Count > SaS.Count then
    for i:= 0 to  ComboSource.Items.Count -SaS.Count -1    do
        ComboSource.Items.Delete(ComboSource.Items.Count -1-i)    ;

  for I := 0 to SaS.Count - 1 do
    begin
    if ComboSource.Items.Count<= i then
      ComboSource.AddItem('tmp');
    self.ComboSource.Items.Strings[i]:='Wellenlänge '+inttostr(i)+'     ('+inttostr(round(SaS.Source[i].lambda*1E9))+'nm) ';
    self.ComboSource.ItemColors.Strings[i]:=ColorToString(clWindowText);//+'  ('+inttostr(round(SaS.Source[i].lambda*1E9))+'nm) ');
    self.ComboSource.ItemBackgroundColors.Strings[i]:=ColorToString(SaS.Screen[i].color);//+'  ('+inttostr(round(SaS.Source[i].lambda*1E9))+'nm) ');
    end;
  ComboSource.ItemIndex:=SaS.ActiveNumber;
  ComboSource.Update;

  LabelGroupHeader;
end;



{==============================================================================
  Procedure:    PSlitWithVisible
  Belongs to:   TForm1
==============================================================================}
procedure TForm1.PExpandVisible(sender:TObject; b:boolean);
var p:Tpoint;
    speed:TSpeedButton;
    panel:TPanel;
begin
  if Sender=nil then exit;

  speed:=TSpeedButton(sender);
  if speed.Name='BSlitWidth' then
    panel:=PSlitWidthExpand
  else if speed.Name='BHelpRotate' then
    panel:=PHelpRotateExpand;


  p:=AbsolutePosition(speed);

  panel.Top:=p.Y;
  panel.Left:=p.x+speed.Width;

  panel.Visible:=b;

  if panel.Visible then
    begin
    speed.Glyph.LoadFromLazarusResource('PfeilEin');
    panel.BringToFront;
    end
  else
    speed.Glyph.LoadFromLazarusResource('PfeilAus');
end;






function TForm1.OnChangeMakeAll(comp: TComponent; key: word):word;

  procedure writeLSlitWidth;
  begin
    try
      RatioSlitWidthDist:=aperture.slit.width/aperture.slit.distance;
      LSlitWidth.Caption:=Formatfloat('0.##', (RatioSlitWidthDist))+' * g';
    except

    end;
  end;
  
  
  procedure correctTrackSlitWidth;
  begin
    exit;
    if (self.TrackSlitWidth.Position<self.TrackSlitDistance.Position)
        and(self.TrackSlitWidth.Position>round(self.TrackSlitDistance.Position/100)) then
      begin
      self.TrackSlitWidth.Min:=round(self.TrackSlitDistance.Position/100);
      self.TrackSlitWidth.Max:=self.TrackSlitDistance.Position;
      TrackSlitWidth.Update;
      end;
  end;


var strl, sep:TStringList;
    bcalc:boolean;
begin
  if  not(  (comp is TCustomEdit) or  (comp is TCustomTrackBar)  ) then
    exit;
  if BeginInputChange then
    exit;
    
  bcalc:=true;

  //edit
  if (comp is TCustomEdit) and (BeginEditKeyDown(TCustomEdit(comp), Key) or ReadTxtInputMode)  then
    begin
    Result:=key;
    if  (key = 13) and (TCustomEdit(comp).Text<>'') or ReadTxtInputMode  then
      begin
      
      //s:=TCustomEdit(comp).Text;
      //korrigiere(s, ['0'..'9','-','+',',','.','E','e']);
      //if TCustomEdit(comp).Text <> s then
        //TCustomEdit(comp).Text := s;

      PBOK.Hide;

      if comp.Name = 'EditSlitCount'  then
        begin
        if ( self.EditSlitCount.Text='') or ( self.EditSlitCount.Text='0') then
          self.EditSlitCount.Text := '1';
        aperture.slit.count:= abs(round(strtofloat(self.EditSlitCount.Text)));
        if not ReadTxtInputMode then
          self.TrackBarCountSlit.Position:=round(sqrt(aperture.slit.count)*10);

        if NowVisible then
          if not SaS.MinOneChecked(MyCombi) and  not SaS.MinOneChecked(MyImage)and  not SaS.MinOneChecked(MyN) then
            ShowMessage('Sie haben nur den '+SaS.Screen[0].SingleSlit.check.Caption+' ausgewählt.'+#13+#13+
                        'Bitte wähle den "'+SaS.Screen[0].CombiSlit.check.Caption+'" links unten aus,'+#13+
                        'damit das ändern von der Spaltanzahl eine Wirkung zeigt');
        end
      else if comp.Name = 'EditSlitDistance'  then
        begin
        RatioSlitWidthDist:=aperture.slit.width/aperture.slit.distance;

        aperture.slit.distance:=strtofloat(self.EditSlitDistance.Text)*1E-6;
        if aperture.slit.distance > 1000e-6 then
          ;  // here you can disable the min max chart.. its getting slow
        if not ReadTxtInputMode then
          begin
          self.TrackSlitDistance.Position:=round(aperture.slit.distance *1E7 {für track});

          aperture.slit.width:=RatioSlitWidthDist*aperture.slit.distance;
          self.EditSlitWidth.Text := Formatfloat('0.##', (aperture.slit.width*1E6));
          self.TrackSlitWidth.Position:=round(RatioSlitWidthDist *100);
          end;

        writeLSlitWidth;
        end
      else if comp.Name = 'EditSlitWidth'  then
        begin
        aperture.slit.width:=strtofloat(self.EditSlitWidth.Text)*1E-6;
        RatioSlitWidthDist:=aperture.slit.width/aperture.slit.distance;
        if not ReadTxtInputMode then
          self.TrackSlitWidth.Position:=round(RatioSlitWidthDist *100);
        if not ReadTxtInputMode then
          bcalc:=true;
        writeLSlitWidth;
        end
      else if comp.Name = 'EditHorizontalAngle'  then
        begin
        aperture.slit.beta:=radtoBog(strtofloat(EditHorizontalAngle.Text));
        if not ReadTxtInputMode then
          self.TrackHorizontalAngle.Position:=round(StrToFloat(EditHorizontalAngle.Text));
        OGLBox.MiniSlit.beta:=aperture.slit.beta;
        end
      else if comp.Name = 'EditVerticalAngle'  then
        begin
        aperture.slit.theta:=radtoBog(strtofloat(EditVerticalAngle.Text));
        if not ReadTxtInputMode then
          self.TrackVerticalAngle.Position:=round(StrToFloat(EditVerticalAngle.Text));
        OGLBox.ImageAxis.Visible:= aperture.slit.theta<>0;
        //if (aperture.LaserHeight >60) and (aperture.slit.theta<>0) then
          //begin
          //aperture.LaserHeight:=30;
          //if not ReadTxtInputMode then
            //TrackLaserHeight.Position:=round(aperture.LaserHeight);
          ////if NowVisible then
            ////if not SaS.MinOneChecked(MyImage) then
              ////ShowMessage('Einen Effekt können Sie hier nur sehen wenn Sie das'+#13+
                          ////'"'+SaS.Screen[0].ImageIntensity.check.Caption+'" links unten auswählen');
          //end;
        OGLBox.MiniSlit.theta:=aperture.slit.theta;
        end
      else if comp.Name = 'EditDistScreenSlit'  then
        begin
        aperture.ScreenDistance:=StrToFloat(EditDistScreenSlit.Text);
        if not ReadTxtInputMode then
          self.TrackBarDistScreenSlit.Position:=round(power(StrToFloat(EditDistScreenSlit.Text),1/7)*100000);
        end
      else if pos('EditLambda_',comp.Name)>0  then
        begin
        sep:=TStringList.Create;
        strl:=TStringList.Create;
        sep.Add('_');

        DivideString(comp.Name, sep, strl);
        if strl.Count=2 then
          with SaS.Source[StrToInt(strl[1])] do
            begin
            lambda:=strtofloat(EditLambda.Text)*1E-9;
            if not ReadTxtInputMode then
              SaS.Screen[StrToInt(strl[1])].CalcOnlyVisible;
            end;

        sep.Free;
        strl.Free;
        bcalc:=false;
        end
      else if pos('EditFrequency_',comp.Name)>0  then
        begin
        sep:=TStringList.Create;
        strl:=TStringList.Create;
        sep.Add('_');

        DivideString(comp.Name, sep, strl);
        if strl.Count=2 then
          with SaS.Source[StrToInt(strl[1])] do
            begin
            frequency:=strtofloat(EditFrequency.Text);
            if not ReadTxtInputMode then
              SaS.Screen[StrToInt(strl[1])].CalcOnlyVisible;
            end;

        sep.Free;
        strl.Free;
        bcalc:=false;
        end
      else if comp.Name = 'SpinEditIntensityFactor'  then
        begin
        if not ReadTxtInputMode then
          TrackBarIntensityFactor.Position:=round(SpinEditIntensityFactor.Value);
        SaS.IntensityColorFactor:=SpinEditIntensityFactor.Value;
        bcalc:=false;
        end;
      EndInputChange(bcalc);
      end;
    end;



  //track
  if (comp is TCustomTrackBar)  and  (not ReadTxtInputMode)  or (comp.Name = 'TrackLaserHeight') then
    begin
    if comp.Name = 'TrackBarCountSlit'  then
      begin
      aperture.slit.count:=round(sqr(TrackBarCountSlit.Position/10));
      if not ReadTxtInputMode then
        EditSlitCount.Text:=IntToStr(aperture.slit.count);

      if NowVisible then
        if not SaS.MinOneChecked(MyCombi) and  not SaS.MinOneChecked(MyImage)and  not SaS.MinOneChecked(MyN) then
          ShowMessage('Sie haben nur den '+SaS.Screen[0].SingleSlit.check.Caption+' ausgewählt.'+#13+#13+
                      'Bitte wähle den "'+SaS.Screen[0].CombiSlit.check.Caption+'" links unten aus,'+#13+
                      'damit das ändern von der Spaltanzahl eine Wirkung zeigt');
      end
    else if comp.Name = 'TrackSlitDistance'  then
      begin
      RatioSlitWidthDist:=aperture.slit.width/aperture.slit.distance;

      aperture.slit.distance:=self.TrackSlitDistance.Position*1E-7 {für track};
      if not ReadTxtInputMode then
        begin
        self.EditSlitDistance.Text:=PrettyFormatFloat(aperture.slit.distance *1E6 , 3);
        aperture.slit.width:=RatioSlitWidthDist*aperture.slit.distance;
        self.EditSlitWidth.Text := Formatfloat('0.##', (aperture.slit.width*1E6));
        self.TrackSlitWidth.Position:=round(RatioSlitWidthDist *100);
        end;

      writeLSlitWidth;
      end
    else if comp.Name = 'TrackSlitWidth'  then
      begin
      aperture.slit.width:=self.TrackSlitWidth.Position/100 *aperture.slit.distance;
      if not ReadTxtInputMode then
        self.EditSlitWidth.Text := Formatfloat('0.##', (aperture.slit.width*1E6));

      writeLSlitWidth;
      end
    else if comp.Name = 'TrackHorizontalAngle'  then
      begin
      aperture.slit.beta:=radtoBog(self.TrackHorizontalAngle.Position);
      if not ReadTxtInputMode then
        EditHorizontalAngle.Text:=inttostr(self.TrackHorizontalAngle.Position);
      OGLBox.MiniSlit.beta:=aperture.slit.beta;
      end
    else if comp.Name = 'TrackVerticalAngle'  then
      begin
      aperture.slit.theta:=radtoBog(self.TrackVerticalAngle.Position);
      if not ReadTxtInputMode then
        EditVerticalAngle.Text:=inttostr(self.TrackVerticalAngle.Position);
//      OGLBox.ImageAxis.Visible:= aperture.slit.theta<>0;
      //if not ReadTxtInputMode then
        //if (aperture.LaserHeight >60) and (aperture.slit.theta<>0) then
          //begin
          //aperture.LaserHeight:=30;
          //TrackLaserHeight.Position:=round(aperture.LaserHeight);
          //end;
      OGLBox.MiniSlit.theta:=aperture.slit.theta;
      //if NowVisible then
        //if not SaS.MinOneChecked(MyImage) then
          //ShowMessage('Einen Effekt können Sie hier nur sehen wenn Sie das'+#13+
                      //'"'+SaS.Screen[0].ImageIntensity.check.Caption+'" links unten auswählen');
      end
    else if comp.Name = 'TrackBarDistScreenSlit'  then
      begin
      aperture.ScreenDistance:=power(TrackBarDistScreenSlit.Position/100000,7);
      if not ReadTxtInputMode then
        EditDistScreenSlit.Text:=PrettyFormatFloat(aperture.ScreenDistance, 2);
      end
    else if pos('TrackBar_',comp.Name)>0  then
      begin
      sep:=TStringList.Create;
      strl:=TStringList.Create;
      sep.Add('_');

      DivideString(comp.Name, sep, strl);
      if strl.Count=2 then
        with SaS.Source[StrToInt(strl[1])] do
          begin
          lambda:=TrackBar.position*1E-9;
          SaS.Screen[StrToInt(strl[1])].CalcOnlyVisible;
          end;

      sep.Free;
      strl.Free;
      bcalc:=false;
      end
    else if comp.Name = 'TrackBarIntensityFactor'  then
      begin
      SpinEditIntensityFactor.Value:=TrackBarIntensityFactor.Position;
      SaS.IntensityColorFactor:=TrackBarIntensityFactor.Position;
      bcalc:=false;
      end
    else if comp.Name = 'TrackLaserHeight'  then
      begin
      aperture.LaserHeight:=TrackLaserHeight.Position;
      bcalc:=false;
      end
    else if comp.Name = 'TrackQuality'  then
      begin
      SaS.Quality:=TrackQuality.Position;
      end;
//    EndInputChange(bcalc);
    EndInputChange(false);
    MustIdleReCalc:=true;
    end;


  Result:=key;
  IsChangingInput:=false;

  if not ReadTxtInputMode and NowVisible then
    if (comp is TCustomEdit) then
      TCustomEdit(comp).SetFocus
    else if (comp is TCustomTrackBar) then
      TCustomTrackBar(comp).SetFocus
end;



{==============================================================================
  Procedure:    AddLog
  Belongs to:   TForm1
  Result:       None
  Parameters:
                  s : string  =
                  acolor : Tcolor  =

  Description:
==============================================================================}
procedure TForm1.AddLog(s:string; acolor:Tcolor);
const max=500;
begin
  if not ProgrammerInfo then
    exit;

  if ListLog.Count>max then
    ListLog.Items.Delete(0);

  ListLog.AddItem(s,aColor);
//  ListLog.ItemIndex:=ListLog.Count-1;
  ListLog.Selected[ListLog.Count-1]:=true;
end;


{==============================================================================
  Procedure:    AddLog
  Belongs to:   TForm1
  Result:       None
  Parameters:
                  s : string  =

  Description:
==============================================================================}
procedure TForm1.AddLog(s:string);
begin
  AddLog(s, clWindowText);
end;


{==============================================================================
  Procedure:    CheckLog
  Belongs to:   TForm1
  Result:       None
  Parameters:

  Description:
==============================================================================}
procedure TForm1.CheckLog;
const max=500;
var i:integer;
begin
  if ListLog.Count>max then
    for I := 0 to ListLog.Count - max-1 do
      ListLog.Items.Delete(0);
end;




procedure TForm1.OGLBoxMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if ssShift in Shift then
    begin
    if WheelDelta>0 then
      SpinEditIntensityFactor.Value:=SpinEditIntensityFactor.Value +3
    else
      SpinEditIntensityFactor.Value:=SpinEditIntensityFactor.Value -3;

    OnChangeMakeAll(SpinEditIntensityFactor, 13);
    end;
end;



procedure TForm1.SetDefaultKoors;
begin
  with OGLBox.xAxis do
    begin
    case RadioXAxis.ItemIndex of
      0:
        begin
        DefaultKoor.Min:=-2;
        DefaultKoor.Max:=2;
        end;
      1:
        if aperture.slit.beta=0 then
          begin
          DefaultKoor.Min:=-90;
          DefaultKoor.Max:=90;
          end
        else
          begin
          DefaultKoor.Min:=-180;
          DefaultKoor.Max:=180;
          end;
      2:
        begin
        DefaultKoor.Min:=-15;
        DefaultKoor.Max:=15;
        end;
    end;

    Koor:= DefaultKoor;
    end;


  with OGLBox.ImageAxis do
    begin
    case RadioImageAxis.ItemIndex of
      0:
        begin
        DefaultKoor.Min:=-2;
        DefaultKoor.Max:=2;
        end;
      1:
        begin
        DefaultKoor.Min:=-90;
        DefaultKoor.Max:=90;
        end;
    end;

    Koor:=DefaultKoor;
    end;

  with OGLBox.LSAxis do
    begin
    case RadioLSAxis.ItemIndex of
      0:
        begin
        DefaultKoor.Min:=-1.1;
        DefaultKoor.Max:=1.1;
        end;
      1:
        begin
        DefaultKoor.Min:=-1.1;
        DefaultKoor.Max:=1.1;
        end;
    end;

    Koor:=DefaultKoor;
    end;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    AddItemSilent
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TForm1.AddItemSilent(lambda:real=0);
begin
  SaS.add(self);
  if lambda<=0 then
    lambda:=RandomRRange(380,779)*1E-9;
  SaS.Source[SaS.count-1].lambda:=lambda;
  self.ComboSource.AddItem('Wellenlänge '+inttostr(SaS.count-1)+'     ('+inttostr(round(SaS.Source[SaS.count-1].lambda*1E9))+'nm) ', WavelengthToRGB(SaS.Source[SaS.count-1].lambda));//+'  ('+inttostr(round(SaS.Source[SaS.count-1].lambda*1E9))+'nm) ');

  self.GroupMultiSource.Caption:='Mehrere Wellenlängen   Aktuelle Anzahl: '+inttostr(SaS.count);

  RelistSources;


end;



{-----------------------------------------------------------------------------
  Description:
  Procedure:    DelLastItem
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TForm1.DelLastItem;
begin
  if SaS.count<=1 then
    exit;

  DelLastItemSilent;

  ChangeItem(SaS.count-1);
  
  if NowVisible then
    OGLBox.DrawOGL;
end;


{-----------------------------------------------------------------------------
  Description:
  Procedure:    DelLastItemSilent
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TForm1.DelLastItemSilent;
begin
  if SaS.count<=1 then
    exit;

  SaS.deleteLastItem;

  self.ComboSource.DeleteItem(SaS.count);  // SaS.count da ja schon gel�scht wurde
end;



procedure TForm1.CalcAndDrawOGL;
begin
  if not NowVisible then
    exit;
    

  SaS.CalcOnlyVisible;
  SaS.DrawOGLOnlyVisible;
end;





{==============================================================================
  Procedure:    setProgrammerInfo
  Belongs to:   TForm1
  Result:       None
  Parameters:
                  value : boolean  =

  Description:
==============================================================================}
procedure TForm1.setProgrammerInfo(value:boolean);
begin
  if not value<> PProgrammerInfo.Visible then
     exit;

  ListCountPoints.Clear;
  ListLog.Clear;

  self.FProgrammerInfo:=value;
  PProgrammerInfo.Visible:=value;

  PProgrammerInfo.Collapsed:= not value;

  if value then
    ExpandPanelsMainOption.InsertPanel(1, PProgrammerInfo)
  else
    ExpandPanelsMainOption.DeltePanel('PProgrammerInfo');
end;

procedure TForm1.setFullScreen(value: boolean);
begin
  FFullScreen:=value;

  if FFullScreen then
    begin
    OGLBox.Parent:=Self;
    OGLBox.Align:=alNone;

    OGLBox.Anchors:=[akTop, akBottom, akLeft, akRight];
    OGLBox.Left:=0;
    OGLBox.Top:=0;
    OGLBox.Width:=Width;
    OGLBox.Height:=Height-20;

    ActionFullscreen.Caption:='Kein Vollbild';
    end
  else
    begin
    OGLBox.Parent:=PanelOGLBox;
    OGLBox.Align:=alClient;

    ActionFullscreen.Caption:='Vollbild';
    end;
end;




procedure TForm1.OGLBoxMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
var r3:TKoor3;
begin
  r3:=OGLBox.TransAll(Koor3(X,y,0, kkPixelx, kkPixely, kkPixelz), kkX, kkLS, kkZ, @OGLBox.Trans2Koor);
  LabelPos.Caption:='x= '+PrettyFormatFloatWithMinMax(r3.x.v, 3, OGLBox.xAxis.Koor, 2)+'  y= '+PrettyFormatFloatWithMinMax(r3.y.v, 3, OGLBox.LSAxis.Koor, 2);
end;


procedure TForm1.OGLBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p:TPoint;
begin
  p:=AbsolutePosition(OGLBox);
  if Button=mbRight then
    PopupMenuOGLBox.PopUp(x+p.x,y+p.y+70);
end;




{-----------------------------------------------------------------------------
  Description:
  Procedure:    writeHints
  Arguments:    None
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure TForm1.writeHints;
begin
  with self.RadioLSAxis do
    begin
    hint:='Hier kannst du einstellen, ob die Intensitätskurve,'+#13'oder die Amplitude dargestellt werden sollen';
    ShowHint:=true;
    end;
  with self.OptioChart do
    begin
    hint:='Klicke und die Einstellungen Öffnen/schließen sich';
    ShowHint:=true;
    end;
  with self.GroupShowChart do
    begin
    hint:='Welcher Graph soll angezeigt werden?'+#13'Sie werden automatisch überlagert.';
    ShowHint:=true;
    end;
{  with self.RadioXAxis do
    begin
    hint:='Welche Art von x-Achse soll angezeigt werden?'+#13+#13'- auf eine flache Wand/Schirm'+#13'- Winkelabhängigkeit'+#13'- Gangunterschied';
    ShowHint:=true;
    end;}
  with self.EditSlitCount do
    begin
    hint:='Wie viele Spalten?';
    ShowHint:=true;
    end;
  with self.EditSlitWidth do
    begin
    hint:='Wie breit soll jede Spalte sein?';
    ShowHint:=true;
    end;
  with self.EditSlitDistance do
    begin
    hint:='Wie weit sollen sie auseinander sein?';
    ShowHint:=true;
    end;
end;


function BeginEditKeyDown(sender: TCustomEdit; var key:word): boolean; //true wenn alles ok
var ex:extended;
begin
  result:=true;
  
  if not (sender is tcustomedit) then
    begin
    result:=false;
    exit;
    end;
    
//  ShowMessage(IntToStr(ord(key)));
//  intxtschreiben(IntToStr(ord(key)), ExtractFilePath(ParamStr(0))+'textt','.txt', false);


//  if not (key in [13,48..57,16,69,8,17,18,67,86,88,96..105,107..109,187..190, 45,46,35,36,9, 37..40]) then
//    if chr(key) in [{'a'..'z','A'..'Z',}'!','"','''','§','$','%','&','/','(',')','=','?','ß','\','`','¸','*','#',';',':','<','>','|','^','°','@'] then
  if (ord(key) in [65..90]) then
    begin
    key:=0;
    result:=false;
    end;

  if not TryStrToFloat(TCustomEdit(sender).Text{+chr(key)}, ex) or (TCustomEdit(sender).Text='')
      or  not TryStrToFloat(chr(key), ex) and (key<>13)  then
    begin
//    ShowMessage('Sie haben ein ungültiges Zeichen im Feld. Bitte korrigieren!');
    result:=false;
    end;

  if Result then
    ShowOKButton(Sender)
  else
    form1.PBOK.Hide;
end;

function StandartIniFile: string;
begin

  result:=  ExtractFilePath(ParamStr(0))+DirectorySeparator+'Einstellungen.ini';
  //{$IFDEF WINDOWS}
  //{$ENDIF}
  {$IFDEF UNIX}
    result:=  GetEnvironmentVariable('HOME')+DirectorySeparator+'.Interferenz'+DirectorySeparator+'Einstellungen.ini';
  {$ENDIF}
end;



procedure TForm1.LabelGroupHeader;
begin
  with self.GroupHeader1.BoundLabel do
    if SaS.count>1 then
      begin
      Caption:='Jede Wellenlänge einzeln  --- Zurzeit Wellenlänge '+inttostr(SaS.ActiveNumber)+' gewählt';
      Font.Color:=SaS.screen[SaS.ActiveNumber].Color;
      Refresh;
      end
    else
      begin
      Caption:='Jede Wellenlänge einzeln';
      Font.Color:=clblack;
      Refresh;
      end;
end;


procedure TForm1.IdleFunc(Sender: TObject; var Done: Boolean);
begin
  if MustIdleReCalc then
    begin
    MustIdleReCalc:=false;
    CalcAndDrawOGL;
    exit;
    end;

  if not EnableIdleDraw  then
    exit;

  if amrechnen then
    exit;

  OGLBox.DrawOGL;
end;

procedure TForm1.Label10Click(Sender: TObject);
begin
  PExpandVisible(BHelpRotate, not PHelpRotateExpand.Visible);
end;


procedure TForm1.Label5Click(Sender: TObject);
begin
  PExpandVisible(BSlitWidth, not PSlitWidthExpand.Visible);
end;

procedure TForm1.MenuHelpLittleClick(Sender: TObject);
begin
  CheckViewLittleHelp.Checked:=True;
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
begin
  form2.Notebook.PageIndex:=2;
  Form2.Show;
end;

procedure TForm1.OptioScreenClick(Sender: TObject);
begin

end;

procedure TForm1.ShowProgrammerInfoClick(Sender: TObject);
begin
  ProgrammerInfo:=not ProgrammerInfo;
end;


procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  FormSiedeBarOptions.Show;
end;

procedure TForm1.OptioApertureCollapse(Sender: TObject);
begin
  PExpandVisible(BSlitWidth, false);
end;




procedure TForm1.OptioChartCollapse(Sender: TObject);
begin
//  PanelOGLBox.Width:=PanelOGLBox.Width+OptioChart.ExpandedWidth-OptioChart.Button.Width;
  OGLBox.DrawOGL;
end;

procedure TForm1.OptioChartExpand(Sender: TObject);
begin
  OGLBox.DrawOGL;
end;


procedure TForm1.OptioChartPreExpand(Sender: TObject);
begin
//  PanelOGLBox.Width:=PanelOGLBox.Width-OptioChart.ExpandedWidth+OptioChart.Button.Width;
end;

procedure TForm1.OptioChartResize(Sender: TObject);
begin
end;

procedure TForm1.OptioRotateCollapse(Sender: TObject);
begin
  PExpandVisible(BHelpRotate, false);
end;

procedure TForm1.OptioRotatePreCollapse(Sender: TObject);
begin
  OGLBox.DrawOGL;
end;

procedure TForm1.PanelOGLBoxClick(Sender: TObject);
begin

end;

procedure TForm1.PanelOGLBoxEnter(Sender: TObject);
begin
  MouseOverBox:=true;
end;

procedure TForm1.PanelOGLBoxExit(Sender: TObject);
begin
  MouseOverBox:=false;
end;



procedure TForm1.PanelOptioApertureResize(Sender: TObject);
begin
  ExpandPanelsMainOption.ArrangePanels;
end;


procedure TForm1.PProgrammerInfoResize(Sender: TObject);
var showit:boolean;
begin
  with TMyRollOut(Sender) do
    if not Collapsed then
      begin
      //showit:=Height<OriginalExpandedHeight-5;
      showit:=false;

      if showit then
        begin
        //VertScrollBar.Page:=OriginalExpandedHeight;
        //VertScrollBar.Range:=OriginalExpandedHeight-5;
        VertScrollBar.Position:=0;
        end
      else
        begin
        VertScrollBar.Page:=0;
        VertScrollBar.Range:=0;
        VertScrollBar.Position:=0;
        end;

      VertScrollBar.Visible:= showit;
      end;
end;



procedure TForm1.RadioReflectionClick(Sender: TObject);
begin
  case RadioReflection.ItemIndex of
    0: SaS.SetAllCalcReflection(false);
    1:
      if ReadTxtInputMode or not CheckAskConfirmationreflection.Checked then
          SaS.SetAllCalcReflection(true)
      else
        case MessageDlg ('Reflexion anzeigen?',
                        'Die Darstellung des reflektierten Beugungsbildes ist noch nicht ganz ausgereift.'+#13
                        +'Tipp: Drehen Sie den Spalt stark um die horizontale Achse um ein schönes Reflexions-Bild zu erhalten.'+#13
                        +#13
                        +'Wollen Sie das Reflexions-Bild darstellen lassen?  (Ignorieren klicken um diese Meldung nicht mehr zu bekommen)',
                    mtConfirmation,
                    [mbYes, mbNo, mbIgnore],0)  of
          mrYes:    SaS.SetAllCalcReflection(true);
          mrIgnore:
                    begin
                    SaS.SetAllCalcReflection(true);
                    CheckAskConfirmationreflection.Checked:=false;
                    end;
          mrNo:     RadioReflection.ItemIndex:=0;
        end;
  end;
  CalcAndDrawOGL;
end;




procedure TForm1.RadioGroupFormelClick(Sender: TObject);
begin
  case Self.RadioGroupFormel.ItemIndex of
    0:
      begin
      SaS.UsedFormula:=UFApprox;
      GroupVerticalAngle.Enabled:=true;
      GroupHorizontalAngle.Enabled:=true;
//      GroupBoxTurnAngle.Enabled:=true;
      end;
    1:
      begin
      SaS.UsedFormula:=UFHuygens;
      TrackVerticalAngle.Position:=0;
      TrackHorizontalAngle.Position:=0;
      aperture.slit.beta:=0;
      aperture.slit.theta:=0;
      GroupVerticalAngle.Enabled:=false;
      GroupHorizontalAngle.Enabled:=false;

      Self.RadioXAxis.ItemIndex:=1;
      Self.RadioImageAxis.ItemIndex:=1;

      SaS.ChangeAllChecked(MySingle, false, true);
      SaS.ChangeAllChecked(MyN, false, false);
      SaS.ChangeAllChecked(MyCombi, false, true);
      SaS.ChangeAllChecked(MyImage, false, false);
//      GroupBoxTurnAngle.Enabled:=false;
      end;
  end;

  EndInputChange;
end;

procedure TForm1.RadioImageAxisClick(Sender: TObject);
begin
  SetDefaultKoors;

  EndInputChange;
end;

procedure TForm1.RadioXAxisClick(Sender: TObject);
begin
  if ReadTxtInputMode then
    exit;

  SetDefaultKoors;

  EndInputChange;
end;

procedure TForm1.RadioLSAxisClick(Sender: TObject);
begin
  if ReadTxtInputMode then
    exit;

  SetDefaultKoors;

  EndInputChange;
end;

procedure TForm1.RadioXAxisMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TForm1.ScrollBox1Click(Sender: TObject);
begin

end;


procedure TForm1.SpinEditIntensityFactorChange(Sender: TObject);
begin
  OnChangeMakeAll(TComponent(Sender), 13);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var foo:boolean;
begin
  foo:=true;
  IdleFunc(self, foo);
end;


procedure TForm1.AllTrackChange(Sender: TObject);
begin
  OnChangeMakeAll(TComponent(Sender));
end;


procedure TForm1.TrackSlitWidthMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PExpandVisible(BSlitWidth, true);
end;


procedure TForm1.TrackSlitWidthMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PExpandVisible(BSlitWidth, false);
end;




procedure TForm1.XAxisPosGroupClick(Sender: TObject);
begin
  with OGLBox do
    begin
    case XAxisPosGroup.ItemIndex of
      0: XAxisPosition:= apMin;
      1: XAxisPosition:= ap0;
      2: XAxisPosition:= apMax;
    end;
    DrawOGL;
    end;
end;

procedure TForm1.YAxisPosGroupClick(Sender: TObject);
begin
  with OGLBox do
    begin
    case yAxisPosGroup.ItemIndex of
      0: LSAxisPosition:= apMin;
      1: LSAxisPosition:= ap0;
      2: LSAxisPosition:= apMax;
    end;
    DrawOGL;
    end;
end;



procedure TForm1.BAddLambdaClick(Sender: TObject);
var temp:real;
begin
  if SaS.Source[SaS.count-1].lambda>=770E-9 then
    temp:=0
  else
    temp:=SaS.Source[SaS.count-1].lambda*1.1;
  temp:=0;
  AddItem(temp)
end;


procedure TForm1.ActionShowProgrammerInfoExecute(Sender: TObject);
begin
  ProgrammerInfo:=not ProgrammerInfo;
end;

procedure TForm1.ActionUpdateExecute(Sender: TObject);
begin
  //form2.Show;
  //form2.Notebook.PageIndex := 4;
  //form2.BCheckUpdate.Click;
end;

procedure TForm1.ActionVersionExecute(Sender: TObject);
begin
  showmessage('Interferenz    Version '+version);
end;

procedure TForm1.ActionOpenSettingsExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    leseini(OpenDialog1.FileName);
  SaS.CalcAndDrawBox;
end;

procedure TForm1.ActionResetSettingsExecute(Sender: TObject);
begin
  Application.ProcessMessages;
  intxtschreiben(LazarusResources.Find('StandartEinstellungen').Value,
                  StandartIniFile,
                  '.ini',true);
  Application.ProcessMessages;
  leseini(StandartIniFile);
  SaS.ShowCorScreen;
  CalcAndDrawOGL;
end;

procedure TForm1.ActionResetViewExecute(Sender: TObject);
begin
  OGLBox.ResetView;
  OGLBox.DrawOGL;
end;

procedure TForm1.ActionAboutExecute(Sender: TObject);
begin
  form2.Notebook.PageIndex:=0;
  Form2.Show;
end;

procedure TForm1.ActionAddLambdaExecute(Sender: TObject);
begin
  BAddLambda.Click;
  Application.ProcessMessages;
end;

procedure TForm1.ActionCalcAndDrawExecute(Sender: TObject);
begin
  SaS.CalcAndDrawBox;
end;

procedure TForm1.ActionChartSettingsExecute(Sender: TObject);
begin
  self.OptioChart.Collapsed:=not self.OptioChart.Collapsed;
end;

procedure TForm1.ActionDelLastLambdaExecute(Sender: TObject);
begin
  BDelLambda.Click;
  Application.ProcessMessages;
end;

procedure TForm1.ActionESCExecute(Sender: TObject);
begin
  stop:=true;
  if FullScreen then
    FullScreen:=false;
end;

procedure TForm1.ActionExportAllValuesExecute(Sender: TObject);
begin
  DialogExportAllValues.FileName:='ExportierteWerte  '+datetostr(now)+'  '+timetostr(now)+'.csv';
  if DialogExportAllValues.Execute then
    SaS.ExportAllValues(self.DialogExportAllValues.FileName);
end;

procedure TForm1.ActionFullscreenExecute(Sender: TObject);
begin
  //FullScreen:=not FullScreen;
end;

procedure TForm1.ActionHelpExecute(Sender: TObject);
begin
  Form2.Show;
  form2.Notebook.PageIndex:=1;
end;

procedure TForm1.ActionMaximizeExecute(Sender: TObject);
begin
  if self.WindowState<>wsMaximized then
    self.WindowState:=wsMaximized
  else
    self.WindowState:=wsNormal;
end;

procedure TForm1.ActionSaveSettingsExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    schreibeini(SaveDialog1.FileName);
end;

procedure TForm1.BDelLambdaClick(Sender: TObject);
begin
  DelLastItem;
end;

procedure TForm1.BOKClick(Sender: TObject);
begin
  AceptValues;
end;

procedure TForm1.BHelpRotateClick(Sender: TObject);
begin
  PExpandVisible(sender, not PHelpRotateExpand.Visible);
end;

procedure TForm1.BSlitWidthClick(Sender: TObject);
begin
  PExpandVisible(sender, not PSlitWidthExpand.Visible);
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  SaS.CalcAndDrawBox;
end;



procedure TForm1.CheckDrawChartChange(Sender: TObject);
begin
  SaS.DrawingEnabled:=CheckDrawChart.Checked;
end;



procedure TForm1.CheckShowXGitternetzChange(Sender: TObject);
begin
  OGLBox.xAxis.ShowMainGrid:=CheckShowXGitternetz.Checked;
  OGLBox.DrawOGL;
end;

procedure TForm1.CheckShowLSGitternetzChange(Sender: TObject);
begin
  OGLBox.LSAxis.ShowMainGrid:=CheckShowLSGitternetz.Checked;
  SaS.ShowCorScreen;

  OGLBox.DrawOGL;
end;

procedure TForm1.CheckViewLittleHelp2Change(Sender: TObject);
begin
  CheckViewLittleHelp.Checked:=CheckViewLittleHelp2.Checked;
end;

procedure TForm1.CheckViewLittleHelpChange(Sender: TObject);
begin
  CheckViewLittleHelp2.Checked:=CheckViewLittleHelp.Checked;
  MyRollOutHelpLittle.Visible:=CheckViewLittleHelp.Checked;
  if (not CheckViewLittleHelp.Checked) then
    begin
    if (ExpandPanelsMainOption.IdxOfPanel(MyRollOutHelpLittle.Name)<>-1) then
    ExpandPanelsMainOption.DeltePanel(MyRollOutHelpLittle.Name)
    end
  else
    begin
    if (ExpandPanelsMainOption.IdxOfPanel(MyRollOutHelpLittle.Name)=-1) then
    ExpandPanelsMainOption.InsertPanel(0, MyRollOutHelpLittle);
    end;
end;



procedure TForm1.ComboSourceChange(Sender: TObject);
begin
  ChangeItem(ComboSource.ItemIndex);
end;





procedure TForm1.EditDistScreenSlitKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  key:=OnChangeMakeAll(TComponent(Sender), key);
end;



procedure TForm1.EditHorizontalAngleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key:=OnChangeMakeAll(TComponent(Sender), key);
end;

procedure TForm1.EditSlitCountChange(Sender: TObject);
begin
  //if BeginInputChange then
    //exit;

  //self.TrackBarCountSlit.Position:=round(sqrt(strtofloat(self.EditSlitCount.Text))*10);

  //if not SaS.MinOneChecked(MyCombi)and  not SaS.MinOneChecked(MyImage)and  not SaS.MinOneChecked(MyN) then
    //ShowMessage('Sie haben nur den Einzelspalt ausgewählt.'+#13+#13+
                //'Bitte wähle den "N-fach Spalt Real" links unten aus,'+#13+
                //'damit das ändern von der Spaltanzahl eine Wirkung zeigt');

  //EndInputChange;
  OnChangeMakeAll(TComponent(Sender), 13);
end;

procedure TForm1.EditSlitCountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key:=OnChangeMakeAll(TComponent(Sender), key);
end;



procedure TForm1.AllEditChange(Sender: TObject);
begin
  if ReadTxtInputMode then
    OnChangeMakeAll(TComponent(Sender));
end;


procedure TForm1.EditSlitDistanceKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  key:=OnChangeMakeAll(TComponent(Sender), Key);
end;



procedure TForm1.EditSlitWidthKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  key:=OnChangeMakeAll(TComponent(Sender), key);
end;




procedure TForm1.EditVerticalAngleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key:=OnChangeMakeAll(TComponent(Sender), key);
end;




procedure TForm1.ExpandPanelsMainOptionArrangePanels(Sender: TObject);
begin
  if not OptioAperture.Collapsed then
    PExpandVisible(BSlitWidth, PSlitWidthExpand.Visible)
  else
    PExpandVisible(BSlitWidth, false);

  if not OptioRotate.Collapsed then
    PExpandVisible(BHelpRotate, PHelpRotateExpand.Visible)
  else
    PExpandVisible(BHelpRotate, false);

  if PBOK.Visible then
    ShowOKButton(SelectedEdit)  ;
end;


procedure TForm1.FormActivate(Sender: TObject);
begin
  OGLBox.SetFocus;
  OGLBox.DrawOGL;
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  Application.OnIdle:=nil;
  schreibeini( StandartIniFile);
end;




procedure TForm1.FormCreate(Sender: TObject);
begin
  DecimalSeparator:=',';
  NowVisible:=false;



  Randomize;
  RatioSlitWidthDist:=4;
  MustIdleReCalc:=true;

  Icon.LoadFromLazarusResource('Icon');

  version:=LazarusResources.Find('Version').Value;
  version:=StringReplace(version, #10, '', [rfReplaceAll]);
  version:=StringReplace(version, #13, '', [rfReplaceAll]);
  Caption:='Interferenz     Version  '+version+'      von  Alexander  Roth';

  OGLBox:=TOGlBox.Create(Self);
  with OGLBox do
    begin
    Parent:=Self.PanelOGLBox;
    Name:='TheOGLBox';
    Align:=alClient;
    Initnx;
    Resize;
    //OnMouseMove:=@OGLBoxMouseMove;
    //OnMouseWheel:=@oglBoxMouseWheel;
    //OnMouseEnter:=@PanelOGLBoxEnter;
    //OnMouseLeave:=@PanelOGLBoxExit;
    end;
  EnableIdleDraw:=false;
  EnableIdleDraw:=true;
  {$IFDEF WINDOWS}
  Timer1.enabled:=true;
  {$ENDIF}
  MouseOverBox:=false;

  Application.OnIdle:=@IdleFunc;
  

  aperture:=Taperture.Create(self, self);
  SaS:=TSaSArray.Create(self);

  // HelpLittle
  form1.SimpleWebViewerHelpLittle.LoadFromString(LazarusResources.Find('HelpLittle').Value);

  OpenDialog1.InitialDir:=ExtractFilePath(ParamStr(0));
  OpenDialog1.FileName:='MeineEinstellungen.ini';
  SaveDialog1.InitialDir:=OpenDialog1.InitialDir;
  SaveDialog1.FileName:=OpenDialog1.FileName;
  DialogExportAllValues.InitialDir:=OpenDialog1.InitialDir;
  DialogExportAllValues.FileName:='Exportierte Werte.csv';


  ProgrammerInfo:=false;

  //größen und lage bestimmen
  OptioAperture.Left:=1;
  OptioScreen.Left:=1;

  OptioAperture.Width:=260;
  OptioScreen.Width:=OptioAperture.Width;
  OptioExtended.Width:=OptioAperture.Width;
  PProgrammerInfo.Width:=OptioAperture.Width;
  MyRollOutLog.Width:=PProgrammerInfo.Width;
  MyRollOutCountPoints.Width:=PProgrammerInfo.Width;
  MyRollOutHelpLittle.Width:=OptioAperture.Width;
  OptioRotate.Width:=OptioAperture.Width;

  //for i:=0 to ComponentCount -1 do
    //if Components[i] is TMyRollOut then
      //TMyRollOut(Components[i]).Animated:=false;

  OptioChart.Animated:=false;

  with MyRollOutHelpLittle do
    begin
    Top:=0;
    Left:=OptioAperture.Left;
    end;
    

//  OptioChart.Button.Caption:= AddLineEndingAfterChar('Diagramm Einstellungen');
  OptioChart.Button.Caption:= '';
  ReadTxtInputMode:=false;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  SaS.Free;
  OGLBox.Free;
  aperture.Free;
end;


procedure TForm1.FormPaint(Sender: TObject);
begin
  //CalcAndDrawOGL;
  OGLBox.DrawOGL;
end;


procedure TForm1.FormResize(Sender: TObject);
begin
  if FullScreen then
    FullScreen:=FullScreen;
  OGLBox.Resize;
  //OGLBox.SetFocus;
  //OGLBox.DrawOGL;
end;



procedure TForm1.FormShow(Sender: TObject);
begin
  //zusammenfassen

  OptioAperture.Top:=1;

  OptioScreen.Left:=0;
  OptioAperture.Left:=0;
  OptioExtended.Left:=0;
  OptioRotate.Left:=0;
  GroupHeader2.Left:=0;

  ExpandPanelsMainOption.AddPanel(OptioAperture);
  ExpandPanelsMainOption.AddPanel(OptioRotate);
  ExpandPanelsMainOption.AddPanel(OptioScreen);
  ExpandPanelsMainOption.AddPanel(OptioExtended);


  leseini( StandartIniFile);
  //AddItem();

  OGLBox.xAxis.ShowMainGrid:=CheckShowXGitternetz.Checked;
  OGLBox.LSAxis.ShowMainGrid:=CheckShowLSGitternetz.Checked;

  //for i:=0 to ComponentCount -1 do
    //if Components[i] is TMyRollOut then
      //TMyRollOut(Components[i]).Animated:=true;
//  OptioChart.Animated:=true;

  CheckViewLittleHelp.OnChange(self);

  OGLBox.SetFocus;
  SaS.ShowCorScreen;
  NowVisible:=true;
  
  CalcAndDrawOGL;
  
  OGLBox.OnMouseUp:=@OGLBoxMouseUp;
end;



procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  Self.FormResize(self);
end;




{ TALED }

procedure TALED.WriteFColorOn(ColorOn: TColor);
begin
  if (FColorOn=ColorOn)then
    exit;

  FColorOn:=ColorOn;
  
  if Status then
    begin
    Brush.Color:=FColorOn;
    
    if assigned(FOnColorChange) then
      FOnColorChange(self);
    end;
end;

procedure TALED.WriteFColorOff(ColorOff: TColor);
begin
  if (FColorOff=ColorOff)  then
    exit;

  FColorOff:=ColorOff;

  if not Status then
    begin
    Brush.Color:=FColorOff;

    if assigned(FOnColorChange) then
      FOnColorChange(self);
    end;
end;


procedure TALED.WriteFStatus(Status: boolean);
begin
  if (FStatus=Status) then
    exit;

  FStatus:=Status;

  if Status then
    Brush.Color:=ColorOn
  else
    Brush.Color:=ColorOff;


  if assigned(FOnColorChange) then
    FOnColorChange(self);
end;


constructor TALED.Create(TheOwner: TComponent);
begin
  inherited create(TheOwner);
  
  FStatus:=true;
  FColorOn:=clGreen;
  FColorOff:=clRed;
  Shape:=stCircle;
  Height:=20;
  Width:=20;
end;


initialization
  {$I unit1.lrs}
  {$I xyz.lrs}
end.

