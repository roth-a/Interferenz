{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie können es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    veröffentlicht, weitergeben und/oder modifizieren, gemäß Version 2 der Lizenz.
 Description:
-----------------------------------------------------------------------------}


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

