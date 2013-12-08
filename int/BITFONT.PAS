{BY ERIC ESINS}

unit BitFont;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}
INTERFACE
uses Graph, Crt;

PROCEDURE OutFont(X,Y,Col,BCol: Integer; Text: String);
PROCEDURE PaintLetter (X,Y,Col,BCol : Integer);
PROCEDURE FindBits (Ch : String);
PROCEDURE ClBits;

var malen : Byte;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}
IMPLEMENTATION
var
 Text,Ch        : String;
 A,T,X,Y,Col    : Integer;
 B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14 : Byte;

{****************************************************************************}
PROCEDURE ClBits;
 Begin;
  B1:=0; B2:=0; B3:=0; B4:=0; B5:=0; B6:=0; B7:=0; B8:=0;
  B9:=0; B10:=0; B11:=0; B12:=0; B13:=0; B14:=0; B0:=0;
 End;

{****************************************************************************}
PROCEDURE PaintLetter;
 Begin;
  if BCol<>(-1) then begin
  SetColor (BCol);
  if B0=0  then PutPixel(X+4, Y+8, BCol);
  if B1=0  then Line(X,Y+1,X,Y+3);
  if B2=0  then Line(X,Y+5,X,Y+7);
  if B3=0  then Line(X+1,Y+8,X+7,Y+8);
  if B4=0  then Line(X+8,Y+5,X+8,Y+7);
  if B5=0  then Line(X+8,Y+1,X+8,Y+3);
  if B6=0  then Line(X+1,Y,X+7,Y);
  if B7=0  then Line(X+1,Y+1,X+4,Y+4);
  if B8=0  then Line(X+4,Y+1,X+4,Y+3);
  if B9=0  then Line(X+4,Y+4,X+7,Y+1);
  if B10=0 then Line(X+1,Y+7,X+4,Y+4);
  if B11=0 then Line(X+4,Y+5,X+4,Y+7);
  if B12=0 then Line(X+5,Y+5,X+7,Y+7);
  if B13=0 then Line(X+1,Y+4,X+4,Y+4);
  if B14=0 then Line(X+5,Y+4,X+7,Y+4);
  end;

  SetColor (Col);
  if B0=1  then PutPixel(X+4, Y+8, Col);
  if B1=1  then Line(X,Y+1,X,Y+3);
  if B2=1  then Line(X,Y+5,X,Y+7);
  if B3=1  then Line(X+1,Y+8,X+7,Y+8);
  if B4=1  then Line(X+8,Y+5,X+8,Y+7);
  if B5=1  then Line(X+8,Y+1,X+8,Y+3);
  if B6=1  then Line(X+1,Y,X+7,Y);
  if B7=1  then Line(X+1,Y+1,X+4,Y+4);
  if B8=1  then Line(X+4,Y+1,X+4,Y+3);
  if B9=1  then Line(X+4,Y+4,X+7,Y+1);
  if B10=1 then Line(X+1,Y+7,X+4,Y+4);
  if B11=1 then Line(X+4,Y+5,X+4,Y+7);
  if B12=1 then Line(X+5,Y+5,X+7,Y+7);
  if B13=1 then Line(X+1,Y+4,X+4,Y+4);
  if B14=1 then Line(X+5,Y+4,X+7,Y+4);
 End;

{****************************************************************************}
PROCEDURE OutFont;
 Begin;
  X:=X-10;
  T:=Length(Text);
  For A:=1 to T do Text[A] := UpCase(Text[A]);
  For A:=1 to T do
   begin
    Ch:= Copy(Text,A,1);
    FindBits(Ch);
    if malen=1 then PaintLetter(A*10+X, Y, Col, BCol);
   end;
 end;

{****************************************************************************}
PROCEDURE FindBits;
 Begin;
  ClBits;
  malen:=0;
  if Ch='1' then begin B5:=1; B4:=1; B9:=1; malen:=1; end;
  if Ch='2' then begin B6:=1; B5:=1; B13:=1; B14:=1; B2:=1; B3:=1; malen:=1; end;
  if Ch='3' then begin B6:=1; B5:=1; B14:=1; B4:=1; B3:=1; malen:=1; end;
  if Ch='4' then begin B1:=1; B13:=1; B14:=1; B5:=1; B4:=1; malen:=1; end;
  if Ch='5' then begin B6:=1; B1:=1; B13:=1; B14:=1; B4:=1; B3:=1; malen:=1; end;
  if Ch='6' then begin B6:=1; B1:=1; B2:=1; B4:=1; B13:=1; B14:=1; B3:=1; malen:=1; end;
  if Ch='7' then begin B6:=1; B5:=1; B4:=1; malen:=1; end;
  if Ch='8' then begin B1:=1; B2:=1; B3:=1; B4:=1; B5:=1; B6:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='9' then begin B1:=1; B3:=1; B4:=1; B5:=1; B6:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='0' then begin B1:=1; B2:=1; B3:=1; B4:=1; B5:=1; B6:=1; malen:=1; end;

  if Ch='A' then begin B1:=1; B2:=1; B4:=1; B5:=1; B6:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='B' then begin B1:=1; B2:=1; B3:=1; B4:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='C' then begin B1:=1; B2:=1; B3:=1; B6:=1; malen:=1; end;
  if Ch='D' then begin B2:=1; B3:=1; B4:=1; B5:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='E' then begin B1:=1; B2:=1; B3:=1; B6:=1; B13:=1; malen:=1; end;
  if Ch='F' then begin B1:=1; B2:=1; B6:=1; B13:=1; malen:=1; end;
  if Ch='G' then begin B1:=1; B2:=1; B3:=1; B4:=1; B6:=1; B14:=1; malen:=1; end;
  if Ch='H' then begin B1:=1; B2:=1; B5:=1; B4:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='I' then begin B8:=1; B11:=1; malen:=1; end;
  if Ch='J' then begin B3:=1; B4:=1; B5:=1; B6:=1; B10:=1; malen:=1; end;
  if Ch='K' then begin B1:=1; B2:=1; B9:=1; B12:=1; B13:=1; malen:=1; end;
  if Ch='L' then begin B1:=1; B2:=1; B3:=1; malen:=1; end;
  if Ch='M' then begin B1:=1; B2:=1; B4:=1; B5:=1; B7:=1; B9:=1; malen:=1; end;
  if Ch='N' then begin B1:=1; B2:=1; B4:=1; B5:=1; B7:=1; B12:=1; malen:=1; end;
  if Ch='O' then begin B1:=1; B2:=1; B3:=1; B4:=1; B5:=1; B6:=1; malen:=1; end;
  if Ch='P' then begin B1:=1; B2:=1; B5:=1; B6:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='Q' then begin B1:=1; B2:=1; B3:=1; B4:=1; B5:=1; B6:=1; B12:=1; malen:=1; end;
  if Ch='R' then begin B1:=1; B2:=1; B5:=1; B6:=1; B13:=1; B14:=1; B12:=1; malen:=1; end;
  if Ch='S' then begin B1:=1; B3:=1; B4:=1; B6:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='T' then begin B6:=1; B8:=1; B11:=1; malen:=1; end;
  if Ch='U' then begin B1:=1; B2:=1; B3:=1; B4:=1; B5:=1; malen:=1; end;
  if Ch='V' then begin B1:=1; B2:=1; B9:=1; B10:=1; malen:=1; end;
  if Ch='W' then begin B1:=1; B2:=1; B4:=1; B5:=1; B10:=1; B12:=1; malen:=1; end;
  if Ch='X' then begin B7:=1; B9:=1; B10:=1; B12:=1; malen:=1; end;
  if Ch='Y' then begin B7:=1; B9:=1; B11:=1; malen:=1; end;
  if Ch='Z' then begin B3:=1; B6:=1; B9:=1; B10:=1; malen:=1; end;
  if Ch='\' then begin B7:=1; B12:=1; malen:=1; end;
  if Ch='/' then begin B9:=1; B10:=1; malen:=1; end;
  if Ch='+' then begin B8:=1; B11:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='-' then begin B13:=1; B14:=1; malen:=1; end;
  if Ch=',' then begin B10:=1;malen:=1; end;
  if Ch='>' then begin B7:=1; B10:=1; malen:=1; end;
  if Ch='<' then begin B9:=1; B12:=1; malen:=1; end;
  if Ch='*' then begin B7:=1; B8:=1; B9:=1; B10:=1; B11:=1; B12:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='.' then begin B0:=1; malen:=1; end;
  if Ch='!' then begin B0:=1; B8:=1; malen:=1; end;
  if Ch='?' then begin B0:=1; B6:=1; B5:=1; B14:=1; malen:=1; end;
  if Ch='[' then begin B6:=1; B1:=1; B2:=1; B3:=1; malen:=1; end;
  if Ch=']' then begin B6:=1; B5:=1; B4:=1; B3:=1; malen:=1; end;
  if Ch='`' then begin B6:=1; B5:=1; B1:=1; B13:=1; B14:=1; malen:=1; end;
  if Ch='_' then begin B3:=1; malen:=1; end;
  if Ch=' ' then begin malen:=1; end;
 End;
End.
