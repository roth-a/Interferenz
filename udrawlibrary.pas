unit UDrawLibrary;

{$mode objfpc}{$H+}

interface

uses
  Classes,SysUtils,graphics;


procedure Color2RGB(const color: Tcolor; var R,G,B:byte);

var
    i: integer;


implementation


procedure Color2RGB(const color: Tcolor; var R,G,B:byte);
begin
  R := Graphics.Red(color); // ROT
  G := Graphics.Green(color); // GRÜN
  B := Graphics.Blue(color); // BLAU
end;


end.

