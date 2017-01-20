{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie können es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    veröffentlicht, weitergeben und/oder modifizieren, gemäß Version 2 der Lizenz.
 Description:
	Unit um in eine Txt oder INI Datei zu schreiben
              Beispielsweise um daten zu speichern      }
unit Utxt;

interface
uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,strutils,ExpandPanels,
  Dialogs,IniFiles,   ExtCtrls, StdCtrls, ComCtrls, Menus, spin;



procedure DelDubbleExtension(var path:string; const extension:string);
procedure intxtschreiben(text:ansistring;  pfad:string='';  const endung:string='.txt'; vorherloschen:boolean=true);
function readtxt(path:string):string;
procedure schreibeini(pfad:string);
procedure leseini(pfad:string);



implementation
uses unit1,Uapparatus, unit4, UChart;





{-----------------------------------------------------------------------------
  Description:
  Procedure:    DelDubbleExtension
  Arguments:    var path:string; const extension:string
  Result:       None
  Detailed description:          extension is '.txt' or '.bmp'
-----------------------------------------------------------------------------}
procedure DelDubbleExtension(var path:string; const extension:string);
var    index:integer;
begin
  index:=pos(  extension  , path  );
  while index>0  do
    begin
    delete(path,index,4);
    index:=pos(  extension  , path  );
    end;
  path:=path+extension;
end;




{-----------------------------------------------------------------------------
  Description:  Schreibt in eine TXT rein
  Procedure:    intxtschreiben
  Arguments:    text:string; pfad:string=''; vorherloschen:boolean=true
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure intxtschreiben(text:AnsiString;  pfad:string='';  const endung:string='.txt'; vorherloschen:boolean=true);
var txt:textfile;
    h,m,s,ms:word;
begin
  DecodeTime(now,h,m,s,ms);
  if  pfad='' then
    pfad:=ExtractFilePath(Application.ExeName)+dateToStr(now)+'  '+inttostr(h)+' Uhr und '+inttostr(m)+' Minuten'+endung
  else
    DelDubbleExtension(pfad,endung);

  try
    if not DirectoryExists(ExtractFilePath(pfad)) then
      mkdir(ExtractFilePath(pfad));
    assignfile(txt,pfad);
    if (fileexists(pfad))and(not vorherloschen) then append(txt) else rewrite(txt);
    writeln(txt,text);
    closefile(txt);
  except
    showmessage('Es konnte keine Datei erstellt werden!'+chr(13)+
          'Falls Sie das Programm von CD Starten kopieren Sie bitte die *.exe auf ihre Festplatte und starten Sie erneut!');
  end;
end;




{==============================================================================
  Procedure:    readtxt	
  Belongs to:   None
  Result:       string
  Parameters:   
                  path : string  =   
                    
  Description:  
==============================================================================}
function readtxt(path:string):string;
var txt:textfile;
    s:string;
    stop:boolean;
begin
  result:='';
  stop:=false;
  if fileexists(path) then
    try
      assignfile(txt,path);
      reset(txt);
      repeat

        readln(txt,s);
        result:=result+s;

        if eof(txt) then
          stop:=true
        else
          result:=result+#13+#10;
      until stop;
    finally
      closefile(txt);
    end;
end;




{-----------------------------------------------------------------------------
  Description:  Schreibt in eine INI
  Procedure:    schreibeini
  Arguments:    pfad:string
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure schreibeini(pfad:string);

    function Transform2Eng(s:string):string;
    var p:integer;
    begin
      p:=pos(DecimalSeparator, s);
      if p<>0 then
        s[p]:='.';
      Result:=s;
    end;

    function Transform2Local(s:string):string;
    var p:integer;
    begin
      p:=pos('.', s);
      if p<>0 then
        s[p]:=DecimalSeparator;
      Result:=s;
    end;

const endung='.ini';
var ini:TInifile;
  tempDecimalSeperator,  tempThousandSeparator:Char;
    h,m,s,ms:word;


    procedure writeValues(comp:Tcomponent);
    var     i:integer;
    begin
      with comp do
        for i:=0 to ComponentCount -1 do
          begin
          if Components[i] is TListBox then
            begin
            ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'Items.count',TListBox(Components[i]).Items.Count);
            ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'ItemIndex',TListBox(Components[i]).ItemIndex);
            end;
          if Components[i] is TComboBox then
            ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TComboBox(Components[i]).ItemIndex);
          if Components[i] is TTrackBar then
            ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TTrackBar(Components[i]).Position);
          //if Components[i] is TSpinEdit then
            //ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TSpinEdit(Components[i]).Value);
          if (Components[i] is TCustomEdit) and not (Components[i] is TMemo)  then
            ini.WriteString(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,Transform2Eng(TCustomEdit(Components[i]).Text));
          //if Components[i] is TJVSpinEdit then
            //ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TJVSpinEdit(Components[i]).Value);
          //if Components[i] is TJvValidateEdit then
            //ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TJvValidateEdit(Components[i]).Value);
          if Components[i] is TCheckBox then
            ini.WriteBool(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TCheckBox(Components[i]).Checked);
          if Components[i] is TRadioGroup then
            ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TRadioGroup(Components[i]).ItemIndex);
          if Components[i] is TALED then
            ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TALED(Components[i]).ColorOn);
          //if Components[i] is TJVLED then
            //ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TJVLED(Components[i]).ColorOn);
          if Components[i] is TMyRollOut then
            ini.WriteBool(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TMyRollOut(Components[i]).Collapsed);
          if Components[i] is TExpandPanels then
            begin
//            ini.WriteBool(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+' UseClientHeight',TExpandPanels(Components[i]).UseClientHeight);
            ini.WriteInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,ord(TExpandPanels(Components[i]).Behaviour));
            end;
          if Components[i] is TOGlBox then
            begin
            tempDecimalSeperator:=DecimalSeparator;
            tempThousandSeparator:=ThousandSeparator;
            DecimalSeparator:='.';  // scheint man in linux nicht zu brauchen
            ThousandSeparator:=',';  // scheint man in linux nicht zu brauchen

            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.xAxis.Koor.Min',TOGlBox(Components[i]).xAxis.Koor.Min);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.xAxis.Koor.Max',TOGlBox(Components[i]).xAxis.Koor.Max);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.LSAxis.Koor.Min',TOGlBox(Components[i]).LSAxis.Koor.Min);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.LSAxis.Koor.Max',TOGlBox(Components[i]).LSAxis.Koor.Max);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.ImageAxis.Koor.Min',TOGlBox(Components[i]).ImageAxis.Koor.Min);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.ImageAxis.Koor.Max',TOGlBox(Components[i]).ImageAxis.Koor.Max);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.QuotientLS2Image',TOGlBox(Components[i]).QuotientLS2Image);

            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.xAxis.DefaultKoor.Min',TOGlBox(Components[i]).xAxis.DefaultKoor.Min);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.xAxis.DefaultKoor.Max',TOGlBox(Components[i]).xAxis.DefaultKoor.Max);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.LSAxis.DefaultKoor.Min',TOGlBox(Components[i]).LSAxis.DefaultKoor.Min);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.LSAxis.DefaultKoor.Max',TOGlBox(Components[i]).LSAxis.DefaultKoor.Max);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.ImageAxis.DefaultKoor.Min',TOGlBox(Components[i]).ImageAxis.DefaultKoor.Min);
            ini.WriteFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.ImageAxis.DefaultKoor.Max',TOGlBox(Components[i]).ImageAxis.DefaultKoor.Max);

            DecimalSeparator := tempDecimalSeperator;
            ThousandSeparator:=tempThousandSeparator;
            end;
          end;
    end;
begin
  DecodeTime(now,h,m,s,ms);
  try
    if  pfad='' then
      pfad:=ExtractFilePath(Application.ExeName)+dateToStr(now)+'  '+inttostr(h)+' Uhr und '+inttostr(m)+' Minuten'+endung
    else //macht doppelte endungen weg
      DelDubbleExtension(pfad,endung);

  //hier schreibt er alle Einstellungen in die Ini Datei,
  // egal ob die Datei vorher schon Existiert hat, es wird einfach überschrieben
  //hier in der ersten zeile wird die Ini datei mit create kreiert
    if not DirectoryExists(ExtractFilePath(pfad)) then
      mkdir(ExtractFilePath(pfad));
    ini:=tinifile.Create(pfad);

    //hier läuft er alle Komponenten von Form1 durch und speichert die Werte
    writeValues(form1);
    //with form1 do
      //for i:=0 to ComponentCount -1 do
        //if Components[i] is TGroupbox then
          //writeValues(Components[i]);
    writeValues(FormSiedeBarOptions);

    //ini.WriteInteger('Form1','PScaleAxisY',Form1.PScaleAxisY.Height);
    //ini.WriteInteger('Form1','PScaleAxisYTop',Form1.PScaleAxisY.Top);

    ini.WriteInteger('Form1','WindowState',ord(form1.windowstate));
    //ini.WriteBool('Form1','TChartAxisValuex',Form1.RegisterInfo.WasStarted);

    ini.WriteInteger('Form1','FormWidth',form1.Width);
    ini.WriteInteger('Form1','FormHeight',form1.Height);

  except
    showmessage('Es konnte keine Einstellungs-Datei erstellt werden!'+chr(13)+
          'Anscheinend habe ich keine Schreib-Rechte in dem gewählten Ordner');
  end;
  ini.Free;
end;





{-----------------------------------------------------------------------------
  Description:  Liest aus einer INI
  Procedure:    leseini
  Arguments:    pfad:string
  Result:       None
  Detailed description:
-----------------------------------------------------------------------------}
procedure leseini(pfad:string);

    function Transform2Eng(s:string):string;
    var p:integer;
    begin
      p:=pos(DecimalSeparator, s);
      if p<>0 then
        s[p]:='.';
      Result:=s;
    end;

    function Transform2Local(s:string):string;
    var p:integer;
    begin
      p:=pos('.', s);
      if p<>0 then
        s[p]:=DecimalSeparator;
      Result:=s;
    end;

var ini:TInifile;
  tempDecimalSeperator, tempThousandSeparator:Char;

    procedure init(comp:Tcomponent);      //such überall nach ComboSource und dann erstellt er was das Zeug hält
    var     i,j,
            count:integer;
    begin
      with comp do
        for i:=0 to ComponentCount -1 do
          if Components[i] is TListBox then
          // das ist zum erstellen des Arrays
          if Components[i].Name='ComboSource' then
            begin
            count:=ini.ReadInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'Items.count',TListBox(Components[i]).Items.Count);
            if count>=SaS.count then
              for j := SaS.count to  count-1 do
                form1.AddItemSilent
            else
              for j := SaS.count-1 downto  count do
                form1.DelLastItemSilent;

            form1.ChangeItem( ini.ReadInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'ItemIndex',TListBox(Components[i]).ItemIndex) );
            break;
            end;
    end;


    procedure readValues(comp:Tcomponent);
    var     i:integer;
    begin
      with comp do
        for i:=0 to ComponentCount -1 do
          begin
          if Components[i] is TTrackBar then
            TTrackBar(Components[i]).Position:=ini.readInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TTrackBar(Components[i]).Position);
          //if Components[i] is TSpinEdit then
            //TSpinEdit(Components[i]).Value:=ini.readInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TSpinEdit(Components[i]).Value);
          if (Components[i] is TCustomEdit) and not (Components[i] is TMemo)  then
            TCustomEdit(Components[i]).Text:=Transform2Local(ini.readString(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name, Transform2Eng(TCustomEdit(Components[i]).Text)));
          //if Components[i] is TJVSpinEdit then
            //TJVSpinEdit(Components[i]).Value:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TJVSpinEdit(Components[i]).Value);
          //if Components[i] is TJvValidateEdit then
            //TJvValidateEdit(Components[i]).Value:=ini.Readfloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TJvValidateEdit(Components[i]).Value);
          if Components[i] is TCheckBox then
            TCheckBox(Components[i]).Checked:=ini.readBool(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TCheckBox(Components[i]).Checked);
          if Components[i] is TRadioGroup then
            TRadioGroup(Components[i]).ItemIndex:=ini.readInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TRadioGroup(Components[i]).ItemIndex);
          //if Components[i] is TJVLED then
            //TJVLED(Components[i]).ColorOn:=ini.ReadInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TJVLED(Components[i]).ColorOn);
          if Components[i] is TALED then
            TALED(Components[i]).ColorOn:=ini.ReadInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TALED(Components[i]).ColorOn);

          if Components[i] is TMyRollOut then
            TMyRollOut(Components[i]).Collapsed:=ini.ReadBool(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,TMyRollOut(Components[i]).Collapsed);
          if Components[i] is TExpandPanels then
            begin
            TExpandPanels(Components[i]).Behaviour:=TExpandPanelsBehaviour(ini.ReadInteger(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name,ord(TExpandPanels(Components[i]).Behaviour)));
//            TExpandPanels(Components[i]).UseClientHeight:=ini.ReadBool(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+' UseClientHeight',TExpandPanels(Components[i]).UseClientHeight);
            end;
          if Components[i] is TOGlBox then
            begin
            tempDecimalSeperator:=DecimalSeparator;
            tempThousandSeparator:=ThousandSeparator;
//            {$IFDEF WINDOWS}
            DecimalSeparator:='.';  // scheint man in linux nicht zu brauchen
            ThousandSeparator:=',';  // scheint man in linux nicht zu brauchen
//            {$ENDIF}
            TOGlBox(Components[i]).xAxis.Koor.Min:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.xAxis.Koor.Min',TOGlBox(Components[i]).xAxis.Koor.Min);
            TOGlBox(Components[i]).xAxis.Koor.Max:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.xAxis.Koor.Max',TOGlBox(Components[i]).xAxis.Koor.Max);
            TOGlBox(Components[i]).LSAxis.Koor.Min:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.LSAxis.Koor.Min',TOGlBox(Components[i]).LSAxis.Koor.Min);
            TOGlBox(Components[i]).LSAxis.Koor.Max:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.LSAxis.Koor.Max',TOGlBox(Components[i]).LSAxis.Koor.Max);
            //TOGlBox(Components[i]).ImageAxis.Koor.Min:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.ImageAxis.Koor.Min',TOGlBox(Components[i]).ImageAxis.Koor.Min);
            //TOGlBox(Components[i]).ImageAxis.Koor.Max:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.ImageAxis.Koor.Max',TOGlBox(Components[i]).ImageAxis.Koor.Max);
            TOGlBox(Components[i]).QuotientLS2Image:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.QuotientLS2Image',TOGlBox(Components[i]).QuotientLS2Image);

            TOGlBox(Components[i]).xAxis.DefaultKoor.Min:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.xAxis.DefaultKoor.Min',TOGlBox(Components[i]).xAxis.DefaultKoor.Min);
            TOGlBox(Components[i]).xAxis.DefaultKoor.Max:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.xAxis.DefaultKoor.Max',TOGlBox(Components[i]).xAxis.DefaultKoor.Max);
            TOGlBox(Components[i]).LSAxis.DefaultKoor.Min:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.LSAxis.DefaultKoor.Min',TOGlBox(Components[i]).LSAxis.DefaultKoor.Min);
            TOGlBox(Components[i]).LSAxis.DefaultKoor.Max:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.LSAxis.DefaultKoor.Max',TOGlBox(Components[i]).LSAxis.DefaultKoor.Max);
            TOGlBox(Components[i]).ImageAxis.DefaultKoor.Min:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.ImageAxis.DefaultKoor.Min',TOGlBox(Components[i]).ImageAxis.DefaultKoor.Min);
            TOGlBox(Components[i]).ImageAxis.DefaultKoor.Max:=ini.ReadFloat(comp.Owner.Name+' '+comp.Name+' '+Components[i].ClassName,Components[i].Name+'.ImageAxis.DefaultKoor.Max',TOGlBox(Components[i]).ImageAxis.DefaultKoor.Max);

              DecimalSeparator := tempDecimalSeperator;
              ThousandSeparator := tempThousandSeparator;
            end;
          end;
    end;
begin
  ini:=tinifile.Create(pfad);
  try
    try
      if fileexists(pfad) then
        begin
        //erstmal muss initialisiert werden
        ReadTxtInputMode:=true;
        init(form1);


        //hier läuft er alle Komponenten durch und liest die Werte

        readValues(form1);
        //with form1 do
          //for i:=0 to ComponentCount -1 do
            //if (Components[i] is TGroupbox)
             //or(Components[i] is TPanel)
             //or(Components[i] is TScrollBox)then
              //readValues(Components[i]);
        readValues(FormSiedeBarOptions);

        ReadTxtInputMode:=false;
        //WindowState
        case ini.ReadInteger('Form1','WindowState', 1) of
          0:  begin
              Form1.WindowState:=wsNormal;
              form1.Width:=ini.readInteger('Form1','FormWidth',form1.Width);
              form1.Height:=ini.readInteger('Form1','FormHeight',form1.Height);
              Application.ProcessMessages;
              end;
          1,2: Form1.WindowState:=wsMaximized;
        end;
        Form1.RegisterInfo.WasStarted:=ini.readBool('Form1','TChartAxisValuex',Form1.RegisterInfo.WasStarted);
        end
      else
        begin
        form1.ResetSettings.Click;
        Form1.RegisterInfo.WasStarted:=false;
        end;
    except
      form1.AddItemSilent;  //muss sein damit wenigsten 1 da ist
      showmessage('Fehler: Das Lesen der Einstellungs-Datei war Fehlerhaft!');
    end;
  finally
    ini.Free;
  end;
end;



end.
