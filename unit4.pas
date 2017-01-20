unit Unit4; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  ButtonPanel, ExtCtrls, StdCtrls, Buttons;

type

  { TFormSiedeBarOptions }

  TFormSiedeBarOptions = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormSiedeBarOptions: TFormSiedeBarOptions;

implementation
uses unit1, ExpandPanels;

{ TFormSiedeBarOptions }


procedure TFormSiedeBarOptions.Button1Click(Sender: TObject);
begin
//  Form1.ExpandPanelsMainOption.UseClientHeight:=false;
  case RadioGroup1.ItemIndex of
    0: Form1.ExpandPanelsMainOption.Behaviour:=EPMultipanel;
    1: Form1.ExpandPanelsMainOption.Behaviour:=EPSinglePanel;
    2: Form1.ExpandPanelsMainOption.Behaviour:=EPHotMouse;
  end;


  //Form1.OptioAperture.Button.Height:=Form1.OptioAperture.OriginalExpandedHeight;
  //Form1.PProgrammerInfo.Button.Height:=Form1.PProgrammerInfo.OriginalExpandedHeight;
  //Form1.OptioExtended.Button.Height:=Form1.OptioExtended.OriginalExpandedHeight;
  //Form1.OptioScreen.Button.Height:=Form1.OptioScreen.OriginalExpandedHeight;
  //
  Close;
end;

procedure TFormSiedeBarOptions.Button2Click(Sender: TObject);
begin
  Close;
end;

initialization
  {$I unit4.lrs}

end.

