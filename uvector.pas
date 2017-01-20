{-----------------------------------------------------------------------------
 Unit Name: UVector
 Author:    Alexander Roth
 This unit is licensed unter the GPL3
 This license note and the original author (Alexander Roth) must not be altered.
-----------------------------------------------------------------------------}

unit UVector;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math;
type

  TVec=record
    x1,x2,x3:extended;
  end;
  TFunctionVecType= function(s:TVec):extended   of object ;

    operator + (z1, z2 : TVec) z : TVec;             inline;
    operator - (z1, z2 : TVec) z : TVec;             inline;
    operator * (z1, z2 : TVec) z : extended;         inline;
    operator * (z1 : TVec; z2:extended) z : TVec;    inline;
    operator * (z1 : TVec; z2:real) z : TVec;        inline;
    operator * (z1 : TVec; z2:TValueSign) z : TVec;  inline;
    operator * (z1 : extended; z2:TVec) z : TVec;    inline;
    operator * (z1 : real; z2:TVec) z : TVec;        inline;
    operator * (z1:TValueSign; z2 : TVec) z : TVec;  inline;
    operator / (z1 : TVec; z2:extended) z : TVec;    inline;
    operator / (z1 : TVec; z2:real) z : TVec;        inline;
    { ** is the vectorprodukt/crossproduct operator }
    operator ** (z1, z2 : TVec) z : TVec;            inline;
    operator - (z1 : TVec) z : TVec;                 inline;

    function vabs (z : TVec) : extended;             inline;
    function vsqr (z : TVec) : extended;             inline;
    function vstr(z : TVec) : string;                inline;
    function vectostr(z : TVec) : string;            inline;
    function vNorm(z : TVec) : TVec;                 inline;


  function Vec(x1,x2,x3:extended):TVec;              inline;
  function Vector(x1,x2,x3:extended):TVec;           inline;


  function RotateVector(RotationAxisVec, aVec:TVec; angleBog:real):TVec;  overload;  inline;

  function AngleBetweenVektors(a, b:TVec):extended;    inline;
  function AngleBetweenVektorsStandardized(a, b:TVec):extended;  inline;


implementation






function RotateVector(RotationAxisVec, aVec: TVec; angleBog: real): TVec;
var v,a:TVec;

  function IsLength1(aVec:TVec):boolean;
  begin
    result:=  sqrt(sqr(aVec.x1)+sqr(aVec.x2)+sqr(aVec.x3)) =1;
  end;

  function MakeLength1(aVec:TVec):TVec;
  var len:extended;
  begin
    len:=sqrt(sqr(aVec.x1)+sqr(aVec.x2)+sqr(aVec.x3));
    result.x1:=aVec.x1/len;
    result.x2:=aVec.x2/len;
    result.x3:=aVec.x3/len;
  end;
begin
  v:=RotationAxisVec;
  a:=aVec;

  if not IsLength1(v) then
    v:= MakeLength1(v);

  Result.x1:=(cos(angleBog) +sqr(v.x1)*(1-cos(angleBog)))* a.x1
              + (v.x1 * v.x2 *(1-cos(angleBog))-v.x3 * sin(angleBog))* a.x2
              + (v.x1 * v.x3 *(1-cos(angleBog))+v.x2 * sin(angleBog))* a.x3;
  Result.x2:=(v.x2 * v.x1 *(1-cos(angleBog))+v.x3 * sin(angleBog))* a.x1
              + (cos(angleBog) +sqr(v.x2)*(1-cos(angleBog)))* a.x2
              + (v.x2 * v.x3 *(1-cos(angleBog))-v.x1 * sin(angleBog))* a.x3;
  Result.x3:=(v.x3 * v.x1 *(1-cos(angleBog))-v.x2 * sin(angleBog))* a.x1
              + (v.x3 * v.x2 *(1-cos(angleBog))+v.x1 * sin(angleBog))* a.x2
              + (cos(angleBog) +sqr(v.x3)*(1-cos(angleBog)))* a.x3;
end;








function AngleBetweenVektorsStandardized(a, b: TVec): extended;
begin
  Result:=arccos(a*b);
end;


function AngleBetweenVektors(a, b: TVec): extended;
begin
  Result:=AngleBetweenVektorsStandardized(  vNorm(a) , vNorm(b) );
end;






function Vec(x1, x2, x3: extended): TVec;
begin
  Result.x1:=x1;
  Result.x2:=x2;
  Result.x3:=x3;
end;

function Vector(x1, x2, x3: extended): TVec;
begin
  result:=Vec(x1,x2,x3);
end;




operator + (z1, z2 : TVec) z : TVec;
begin
  z.x1:=z1.x1 + z2.x1;
  z.x2:=z1.x2 + z2.x2;
  z.x3:=z1.x3 + z2.x3;
end;

operator - (z1, z2 : TVec) z : TVec;
begin
  z.x1:=z1.x1 - z2.x1;
  z.x2:=z1.x2 - z2.x2;
  z.x3:=z1.x3 - z2.x3;
end;

operator * (z1, z2 : TVec) z : extended;
begin
  z:= z1.x1*z2.x1 +z1.x2*z2.x2 +z1.x3*z2.x3 ;
end;

operator * (z1 : TVec; z2:extended) z : TVec;
begin
  z.x1:=z1.x1 *z2;
  z.x2:=z1.x2 *z2;
  z.x3:=z1.x3 *z2;
end;

operator * (z1 : TVec; z2:real) z : TVec;
begin
  z.x1:=z1.x1 *z2;
  z.x2:=z1.x2 *z2;
  z.x3:=z1.x3 *z2;
end;

operator *(z1: TVec; z2: TValueSign)z: TVec;
begin
  case z2 of
    -1:   z:=-z1;
    0:    z:=vec(0,0,0); // maybe faster that 0*z1
    1:    z:=z1;
  end;
end;

operator * (z1 : extended; z2:TVec) z : TVec;
begin
  result:=z2*z1;
end;

operator * (z1 : real; z2:TVec) z : TVec;
begin
  result:=z2*z1;
end;

operator * (z1: TValueSign; z2: TVec)z: TVec;
begin
  z:=z2*z1;
end;

operator / (z1 : TVec; z2:extended) z : TVec;
begin
  z.x1:=z1.x1 / z2;
  z.x2:=z1.x2 / z2;
  z.x3:=z1.x3 / z2;
end;

operator / (z1 : TVec; z2:real) z : TVec;
begin
  z.x1:=z1.x1 / z2;
  z.x2:=z1.x2 / z2;
  z.x3:=z1.x3 / z2;
end;

{ ** is the vectorprodukt/crossproduct operator }
operator ** (z1, z2 : TVec) z : TVec;
begin
  z.x1:=z1.x2*z2.x3 - z1.x3*z2.x2;
  z.x2:=z1.x3*z2.x1 - z1.x1*z2.x3;
  z.x3:=z1.x1*z2.x2 - z1.x2*z2.x1;
end;


operator - (z1 : TVec) z : TVec;
begin
  z.x1:=-z1.x1;
  z.x2:=-z1.x2;
  z.x3:=-z1.x3;
end;


function vabs(z: TVec): extended;
begin
  Result:=sqrt( vsqr(z) );
end;

function vsqr(z: TVec): extended;
begin
  Result:=sqr(z.x1)+ sqr(z.x2)+ sqr(z.x3);
end;

function vstr(z: TVec): string;
begin
  result:='z1 = '+floattostr(z.x1) +'  z2 = '+floattostr(z.x2) +'  z3 = '+floattostr(z.x3);
end;

function vectostr(z: TVec): string;
begin
  result:=vstr(z);
end;

function vNorm(z: TVec): TVec;
begin
  Result:=z/vabs(z);
end;


end.

