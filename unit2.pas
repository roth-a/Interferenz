{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie können es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    veröffentlicht, weitergeben und/oder modifizieren, gemäß Version 2 der Lizenz.
 Description:
-----------------------------------------------------------------------------}



unit Unit2; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  USimpleWebViewer, ExpandPanels, StdCtrls, ComCtrls, httpsend;

type

  { TForm2 }

  TForm2 = class(TForm)
    BCheckUpdate: TButton;
    Label4: TLabel;
    Label5: TLabel;
    LHomepage: TLabel;
    LInternetState: TLabel;
    MyWebInformation: TSimpleWebViewer;
    MyWebLizenzbedingungen: TSimpleWebViewer;
    SimpleWebViewerHelp: TSimpleWebViewer;
    SimpleWebViewerHelpAperture: TSimpleWebViewer;
    SimpleWebViewerHelpChart: TSimpleWebViewer;
    SimpleWebViewerHelpExport: TSimpleWebViewer;
    SimpleWebViewerHelpLambda: TSimpleWebViewer;
    SimpleWebViewerHelpMultiLambda: TSimpleWebViewer;
    Notebook: TNotebook;
    PageControl1: TPageControl;
    PageHilfe: TPage;
    PageInformation: TPage;
    PageLizenzbedingungen: TPage;
    PageUpdates: TPage;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    procedure BCheckUpdateClick(Sender: TObject);
    procedure ExpandPanels1ArrangePanels(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LHomepageClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure MyWebSpendenClick(Sender: TObject);
    procedure SimpleWebViewerHelpChartClick(Sender: TObject);
    procedure NotebookChangeBounds(Sender: TObject);
    procedure PageHilfeBeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
  private
    { private declarations }
  public
    { public declarations }
    procedure StopClick(Sender: TObject);
    procedure ThreadTerminates(Sender: TObject);
  end;


//  ESMTP = class (Exception);
  THTTPThread=class(TThread)
  private
    fData: String;
    fURL: String;
    fHTTP: THTTPSend;
  protected
   procedure Execute; override;
  public
    procedure SoftAbort;
    property URL:String read fURL write fURL;
    property Data:String read fData write fData;
  end;
  
  

const
  Domain='www.roth.us.ms';
  Webspace='http://alexanderroth.eu';
  Programmname='Interferenz';

var
  Form2: TForm2; 
  MyThrd:THTTPThread;

implementation
uses unit1, uanderes;




{ THTTPThread }

procedure THTTPThread.Execute;
var Success:boolean;
begin
  fHTTP := THTTPSend.Create;
  try
    Success := fHTTP.HTTPMethod('GET', fURL);
    if Success then
    begin
     fHTTP.Document.Position := 0;
     SetString(fData, PChar(fHTTP.Document.Memory), fHTTP.Document.Size);
    end;
  finally
    fHTTP.Free;
  end;
end;


procedure THTTPThread.SoftAbort;
begin
  Terminate;
  fHTTP.Abort; //stop flag setzen
end;


{ TForm2 }


procedure TForm2.FormCreate(Sender: TObject);
begin
  form2.SimpleWebViewerHelp.LoadFromString(LazarusResources.Find('HelpAllgemein').Value);
  form2.SimpleWebViewerHelpChart.LoadFromString(LazarusResources.Find('HelpDiagramm').Value);
  form2.SimpleWebViewerHelpAperture.LoadFromString(LazarusResources.Find('HelplinkeEinstellungen').Value);
  form2.SimpleWebViewerHelpLambda.LoadFromString(LazarusResources.Find('HelpWellenlaenge').Value);
  form2.SimpleWebViewerHelpMultiLambda.LoadFromString(LazarusResources.Find('HelpMehrereWellenlaengen').Value);
  form2.SimpleWebViewerHelpExport.LoadFromString(LazarusResources.Find('HelpExport').Value);
  form2.MyWebLizenzbedingungen.LoadFromString(LazarusResources.Find('Lizenz').Value);
  form2.MyWebInformation.LoadFromString(LazarusResources.Find('Info').Value);



end;

procedure TForm2.FormShow(Sender: TObject);
begin

end;

procedure TForm2.LHomepageClick(Sender: TObject);
begin
  //ShellExecute(Application.Handle, 'open', ('http://'+Domain), nil, nil, SW_ShowNormal);
end;

procedure TForm2.Label5Click(Sender: TObject);
begin
  //ShellExecute(Application.Handle, 'open', ('http://www.delphipraxis.net'), nil, nil, SW_ShowNormal);
  //ShellExecute(GetDesktopWindow(), 'open', ('mailto:roth-a@gmx.de'), nil, nil, SW_SHOWNA);
end;

procedure TForm2.MyWebSpendenClick(Sender: TObject);
begin

end;

procedure TForm2.SimpleWebViewerHelpChartClick(Sender: TObject);
begin

end;

procedure TForm2.NotebookChangeBounds(Sender: TObject);
begin

end;

procedure TForm2.PageHilfeBeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin

end;


procedure TForm2.FormActivate(Sender: TObject);
begin
  self.Caption:=form1.Caption+'                 Infos zum Programm';
  self.LHomepage.Caption:=Domain;
end;





{==============================================================================
  Procedure:    VersionNewer
  Belongs to:   None
  Result:       boolean
  Parameters:
                  new : string  =
                  old : string  =

  Description:
==============================================================================}
function  VersionNewer(new,old:string):boolean;
begin
  korrigiere(old,['0'..'9']);
  korrigiere(new,['0'..'9']);

  result:= comparestr(old,new)<0;
end;




procedure TForm2.StopClick(Sender: TObject);
begin
  if assigned(MyThrd) then
    MyThrd.SoftAbort;
end;

procedure TForm2.ThreadTerminates(Sender: TObject);
var s:string;
begin
  if MyThrd.Data<>'' then
    begin
    s:=MyThrd.Data;

    //showmessage(s);
    korrigiere(s,['.','0'..'9']);
    If VersionNewer(s,version) then
      begin
      form2.LInternetState.Caption:='Es ist eine neue Version '+s+' verfügbar. Bitte downloade sie doch';
      form2.LHomepage.Visible:=true;
      end
    else
      begin
      form2.LInternetState.Caption:='Du hast bereits die neuste Version';
      form2.LHomepage.Visible:=false;
      end;
//    ShowMessage(t[0]);

    end
  else
    Application.MessageBox('Ein Fehler ist aufgetreten. Bitte die Verbidung zum Internet überprüfen.','Fehler', 0);

end;



{==============================================================================
  Procedure:    BCheckUpdateClick
  Belongs to:   TForm2
  Result:       None
  Parameters:
                  Sender : TObject  =

  Description:
==============================================================================}
procedure TForm2.BCheckUpdateClick(Sender: TObject);
begin
  form2.LInternetState.Caption:='Es wird auf ein Update geprüft!';
  Application.ProcessMessages;

  MyThrd := THTTPThread.Create(True);
  MyThrd.URL := 'http://alexanderroth.eu/MeineProgramme/VersionInterferenz.txt';
  MyThrd.FreeOnTerminate := true;
  MyThrd.OnTerminate := @ThreadTerminates;
  MyThrd.Data:='anfang data';
  MyThrd.Resume;

  //with THTTPSend.Create do
  //begin
    //try
      //if HTTPMethod('GET','http://alexanderroth.eu/MeineProgramme/VersionInterferenz.txt') then
        //begin
        //t:= TStringList.Create;
        //t.LoadFromStream(Document);
        //s:=t[0];

        //showmessage(s);
        //korrigiere(s,['.','0'..'9']);
        //If VersionNewer(s,version) then
          //begin
          //form2.LInternetState.Caption:='Es ist eine neue Version '+s+' verfügbar. Bitte downloade sie doch';
          //form2.LHomepage.Visible:=true;
          //end
        //else
          //begin
          //form2.LInternetState.Caption:='Du hast bereits die neuste Version';
          //form2.LHomepage.Visible:=false;
          //end;
        //ShowMessage(t[0]);


        //t.Free;
        //end;
    //except
      //Application.MessageBox('Ein Fehler ist aufgetreten. Bitte die Verbidung zum Internet überprüfen.','Fehler', 0);
    //end;
    //Free;
  //end;


  //If  InternetGetConnectedState(nil, 0) then
    //try
      //s:= IdHTTP1.Get('http://mitglied.lycos.de/rothalexander/MeineProgramme/VersionInterferenz.txt');
////      s:= IdHTTP1.Get(Webspace+'MeineProgramme/Version'+Programmname+'.txt');
      //showmessage(s);
      //korrigiere(s,['.','0'..'9']);
      //If VersionNewer(s,version) then
        //begin
        //form2.LInternetState.Caption:='Es ist eine neue Version '+s+' verfügbar. Bitte downloade sie doch';
        //form2.LHomepage.Visible:=true;
        //end
      //else
        //begin
        //form2.LInternetState.Caption:='Du hast bereits die neuste Version';
        //form2.LHomepage.Visible:=false;
        //end;
    //except
      //form2.LInternetState.Caption:='Ich habe wohl etwas an meiner Homepage geändert. Bitte besuche sie doch und lade das neuste Programm runter';
      //form2.LHomepage.Visible:=true;
    //end
  //else
    //form2.LInternetState.Caption:='Verbinde dich bitte mit dem Internet, damit diese Update Prüfung gemacht werden kann.';
end;

procedure TForm2.ExpandPanels1ArrangePanels(Sender: TObject);
begin

end;





initialization
  {$I unit2.lrs}

end.

