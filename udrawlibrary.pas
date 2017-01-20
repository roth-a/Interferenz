{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    ver�ffentlicht, weitergeben und/oder modifizieren, gem�� Version 2 der Lizenz.
 Description:
-----------------------------------------------------------------------------}


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
  G := Graphics.Green(color); // GR�N
  B := Graphics.Blue(color); // BLAU
end;


end.

