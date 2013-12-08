{
 ----------------------------------------------------
 Dieses Programm wurde von Eric Esins programmiert...
 ----------------------------------------------------
 Wer es in irgendeiner Weise benutzen mîchte, hat die
 Erlaubnis dazu, wenn er meinen Namen erwÑhnt.
 Danke...

 Die Unit Mouse ist nicht von mir.

}

uses Graphbo, Crt, Graph, Mouse ;

const
 Menge = 600;
 step  = 15;

var
 X, Y, T, C,
 Xx, Yx, Mx,
 My         : Integer;
 ZuluX      : array [1..Menge] of Integer;
 ZuluY      : array [1..Menge] of Integer;
 ZuluZ      : array [1..Menge] of Integer;
 Vec        : array [1..Menge, 1..3] of Byte;
 Old        : array [1..Menge, 1..2] of Word;

{****************************************************************************}
PROCEDURE D3D;
 Begin
  For T := 1 to menge do
   begin
    if ZuluX[T] <= 0 then X := Round(MX- ((0-ZuluX[T]) / SQRT(ZuluZ[T])));
    if ZuluX[T] >  0 then X := Round(MX+ (ZuluX[T] / SQRT(ZuluZ[T])));
    if ZuluY[T] <=  0 then Y := Round(MY+ (0-ZuluY[T]) / SQRT(ZuluZ[T]));
    if ZuluY[T] > 0 then Y := Round(MY- (ZuluY[T]  / SQRT(ZuluZ[T])));

    C:= Trunc(ZuluZ[T]/31.75);

    PutPixel (Old[T, 1], Old[T, 2], 0);
    PutPixel (X, Y, C);

    Old [T, 1] := X;
    Old [T, 2] := Y;

   end;
 End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}
BEGIN

 Randomize;

 {Das Verzeichnis mÅsst ihr natÅrlich anpassen}
 INIS256 (3, 'D:\INFO\TP7\BGI');
 For T:=1 to 63 do SETRGBPALETTE (T,63-T,63-T,63-T);

 InitMouse;
 Mx := 400;
 My := 300;

 For T := 1 to Menge do
  begin;
   ZuluX[T] := Random (30000)-15000;
   ZuluY[T] := Random (30000)-15000;
   ZuluZ[T] := Random (2000);
   Vec[T,1] := Random (11)-5;
   Vec[T,2] := Random (11)-5;
   Vec[T,3] := Random (11)-5;
  end;

 REPEAT;
  For T := 1 to menge do
   begin
    ZuluZ[T] := ZuluZ[T]-step;
    if ZuluZ[T] <= 0 then
     begin;
      ZuluZ[T] := 2000;
      ZuluX[T] := Random (20000)-10000;
      ZuluY[T] := Random (20000)-10000;
     end;
   end;
   MX := WhereX;
   MY := WhereY;

  D3D;
 UNTIL Keypressed;
 CloseGraph;
END.