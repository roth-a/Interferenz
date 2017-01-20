program Interferenz;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  clocale,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, Unit1, unit2, Unit3, Unit4, UVector,
  LResources;


//{$IFDEF WINDOWS}{$R Interferenz.rc}{$ENDIF}
{$R *.res}

begin
  //{$I Interferenz.lrs}
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TFormSplash, FormSplash);
  Application.CreateForm(TFormSiedeBarOptions, FormSiedeBarOptions);
  Application.Run;
end.

