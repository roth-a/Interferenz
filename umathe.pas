{-----------------------------------------------------------------------------
 Author:    Alexander Roth
 Date:      04-Nov-2006
    Dieses Programm ist freie Software. Sie können es unter den Bedingungen
    der GNU General Public License, wie von der Free Software Foundation
    veröffentlicht, weitergeben und/oder modifizieren, gemäß Version 2 der Lizenz.
 Description:
-----------------------------------------------------------------------------}
unit UMathe;

interface

uses  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Math,uanderes, UVector;


type
  TFunctionType= function(alpha:extended):extended   of object ;

//  function Ableitung(F:TFunctionType; x0:extended; Precision{größer ist genauer}:real=1000):extended;
  function RotateVector(RotationAxisVec, aVec:TR3Vec; angleBog:real):TR3Vec; overload;

  function Ableitung(F:TFunctionType; x0:extended; N:byte=1):extended;

  function findnextMaxMin(F:TFunctionType; x0:extended; MinX,MaxX:extended; Max:boolean):extended;

  function ABC(a,b,c:extended; UseSign:shortint):extended;

  function SaveDivisionWithDeLHospital(Dividend, Divisor, DerivativeDividend, DerivativeDivisor:extended):extended;
  function SDWDLH(Dividend, Divisor, DerivativeDividend, DerivativeDivisor:extended):extended;

  function RecreateRealAngle(x,y:real):real;

implementation










//x=^x2, y=^x3, z=^x1
function RotateVector(RotationAxisVec, aVec: TR3Vec; angleBog: real): TR3Vec;
var v:TVec;
begin
  v:=RotateVector(Vec(RotateVector.z, RotateVector.x, RotateVector.y), Vec(aVec.z, aVec.x, aVec.y), angleBog);

  Result.z:=v.x1;
  Result.x:=v.x2;
  Result.y:=v.x3;
end;


{-----------------------------------------------------------------------------
  Description:   Kann die n-te Ableitung berechnen, nur bei absoluten extremeingaben
                                                     können ungenauigkeiten auftreten
  Procedure:    Ableitung
  Arguments:    F:TFunctionType; x0:extended; N:byte=1
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function Ableitung(F:TFunctionType; x0:extended; N:byte=1):extended;
const h=0.1;  //scheint ein ganz guter wert zu sein
begin
  case N of
  0: result:=f(x0); //das ist nur falls der benutzer schrott angaben macht F 0Strich ist f
  1: result:= (  f(x0+h/2) - f(x0-h/2) )  / h;
  else
    result:= (  Ableitung(F, x0+h/2, n-1) - Ableitung(F, x0-h/2, N-1) )  / h;
  end;
end;




{-----------------------------------------------------------------------------
  Description:  Findet das Maximum, Minimum, das an die Stelle x0 angrenzt
  Procedure:    findnextMaxMin
  Arguments:    F:TFunctionType; x0:extended; MinX,MaxX:extended; Max:boolean
  Result:       extended
  Detailed description:
-----------------------------------------------------------------------------}
function findnextMaxMin(F:TFunctionType; x0:extended; MinX,MaxX:extended; Max:boolean):extended;
var tempy,oldy,oldx,newx,ab:extended;
    rechts,halt:boolean;
    plus:real;
begin
  plus:=1/10000;
  result:=x0;

  ab:=Ableitung(F,x0);
  if ab=0 then
    exit;

  rechts:=boolGleich(Max,ab>0);


  newx:=x0;
  tempy:=f(newx);

  halt:=false;
  repeat
    oldy:=tempy;
    oldx:=newx;

    newx:=newx+boolsign(rechts)*plus;
    tempy:=f(newx);


    halt:= (newx<=MinX)or(newx>=MaxX)   // wenn es die grenzen verlässt
           or  (max)and(tempy<oldy)     // wenn es wieder kleiner wird
           or  (not max)and(tempy>oldy);      // wenn es wirder größer wird
  until  halt;

  result:=oldx;
end;

function ABC(a, b, c: extended; UseSign: shortint): extended;
begin
  if UseSign=0 then
    UseSign:=+1;
  Result:=(-b+  sign(UseSign)* sqrt(sqr(b)-4*a*c)) / (2*a);
end;



function SaveDivisionWithDeLHospital(Dividend, Divisor, DerivativeDividend,  DerivativeDivisor: extended): extended;
begin
  if (Dividend=0) and (Divisor=0) then
    Result:=Dividend/Divisor
  else if (Dividend=0)and (Divisor<>0) then
    Result:=0
  else
    result:=Dividend/Divisor;  // I don't catch the if (Dividend<>0)and (Divisor=0) because it should be an math error
end;

function SDWDLH(Dividend, Divisor, DerivativeDividend, DerivativeDivisor: extended): extended;
begin
  result:=SaveDivisionWithDeLHospital(Dividend, Divisor, DerivativeDividend, DerivativeDivisor);
end;




function RecreateRealAngle(x, y: real): real;
begin
  result:=0;
  if x=0 then
    begin
    if y>0 then
      result:=pi/2
    else if y=0 then
      result:=0
    else if y<0 then
      result:=2*pi - pi/2;
    exit;
    end;

  if (x>0) and (y>=0) then
    result:=arctan(y/x)
  else if (x<0) and (y>=0) then
    result:=pi+arctan(y/x)
  else if (x<0) and (y<0) then
    result:=pi+arctan(y/x)
  else if (x>0) and (y<0) then
    result:=2*pi+arctan(y/x);
end;

//procedure TestOfRecreateRealAngle;
//const arr:array[0..7] of integer=(0,40,100,140,200,250,300,340);
//var i:integer;
  //s:string;
//begin
  //s:='';

  //for i := 0 to High(arr) do
    //begin
    //s:=s+IntToStr(arr[i]) + '°  ==>  '+FloatToStr( BogtoRad( RecreateRealAngle( cos(radtoBog(arr[i]+360)), sin(radtoBog(arr[i]+360)) )))+#13;
    //end;
  //ShowMessage(s);
//end;











end.










{//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  für Ableitung test
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////}

{function Tform1.probe(alpha:extended):extended;
begin
  result:=power(2.72,alpha);
//  result:=sin(alpha);
//  result:=cos(alpha);
//  result:=srt(alpha);
//  result:=sqrt(abs(alpha));
end;



procedure zeich;
const max=10;
var    r:real;
begin
  form1.RSChartPanel1.BottomAxis.Maximum:=max;
  form1.RSChartPanel1.BottomAxis.Minimum:=-max;
  form1.RSChartPanel1.LeftAxis.Maximum:=100;
  form1.RSChartPanel1.LeftAxis.Minimum:=0;

  with form1.rsprobe1 do
    begin
    parent:=form1.RSChartPanel1;
    Values.Clear;
    color:=clred;

    r:=-max;
    repeat
      Values.Add(r,form1.probe(r));
      r:=r+0.01;
    until r>=max;
  end;

  with form1.rsprobe2 do
    begin
    parent:=form1.RSChartPanel1;
    Values.Clear;
    color:=clblue;

    r:=-max;
    repeat
      Values.Add(r,ableitung(form1.probe,r,10));
      r:=r+0.01;
    until r>=max;
  end;
end;}
