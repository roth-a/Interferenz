unit Unit3; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TFormSplash }

  TFormSplash = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormSplash: TFormSplash;

implementation



{ TFormSplash }

procedure TFormSplash.FormCreate(Sender: TObject);
begin

end;

initialization
  {$I unit3.lrs}

end.

