{$M 4000,0,150000}
uses Dos,Crt,Graph,Graphbo;

var
  Malta                     : Pointer;
  f                         : Text;
  Gd, Gm, T, X1, Y1, X2, Y2 : Integer;
  X, Y, Lang, XFld, YFld    : Integer;
  Code, A, N, xZiel, xKiste : Integer;
  xCar, WoX, WoY, NoMOVE    : Integer;
  Posi, Liv                 : Integer;
  Ch                        : Char;
  N1, N2, N3, N4, N5, Live  : String;
  Text, Name, Level, Grose  : String;
  Zeile, Field, NextL       : String;
  Xdim, YDim, Command       : String[79];
  Zulu                      : Array [1..25, 1..15] of String[1];

const

  Up  = #72;
  Dwn = #80;
  Rig = #77;
  Lft = #75;
  F01 = #59;
  F02 = #60;
  F03 = #61;
  Esc = #27;
  Stx = Black;
  Bbx = 17;
  Brd = 3;
  Lit = White;
  Nrm = LightGray;
  Drk = DarkGray;
  Pre = LightRed;

  Label 1; Label 2; Label 3; Label 4; Label 5; Label 6; Label 7; Label 8;
  Label 9; Label 10; Label 11; Label 12; Label 13; Label 14; Label 15;



{****************************************************************************}
PROCEDURE MAUER;
Begin;
 SetFillStyle (1, Red);
 Bar (x+1, y+1, x+20, y+20);
 For N:=1 to 40 do PutPixel (x+Random(20)+1, y+Random(20)+1, 5);
 For N:=1 to 7 do PutPixel (x+Random(20)+1, y+Random(20)+1, 3);
 SetColor (3);
 Line (x+1, y+4, x+20, y+4);
 Line (x+1, y+8, x+20, y+8);
 Line (x+1, y+12, x+20, y+12);
 Line (x+1, y+16, x+20, y+16);
 Line (x+1, y+20, x+20, y+20);
 Line (x+10, y+1, x+10, y+3);
 Line (x+10, y+9, x+10, y+11);
 Line (x+20, y+1, x+20, y+3);
 Line (x+20, y+9, x+20, y+11);
 Line (x+4, y+5, x+4, y+7);
 Line (x+14, y+5, x+14, y+7);
 Line (x+4, y+13, x+4, y+15);
 Line (x+14, y+13, x+14, y+15);
 Line (x+6, y+17, x+6, y+19);
 Line (x+17, y+17, x+17, y+19);
End;

{****************************************************************************}
PROCEDURE ZIEL;
Begin;
 SetFillStyle (1, LightGreen);
 Bar  (x+1, y+1, x+20, y+20);

 SetColor (White);
 Line (x+1, y+20, x+20, y+20);
 Line (x+20, y+1, x+20, y+20);
 Circle (x+10, y+10, 5);

 SetColor (Green);
 Line (x+1, y+1, x+20, y+1);
 Line (x+1, y+1, x+1, y+20);
 Circle (x+11, y+11, 5);
End;


{****************************************************************************}
PROCEDURE ZCAR;
Begin;
 SetFillStyle (1, LightGreen);
 Bar  (x+1, y+1, x+20, y+20);
 SetColor (White);
 Line (x+1, y+20, x+20, y+20);
 Line (x+20, y+1, x+20, y+20);
 Circle (x+10, y+10, 5);
 SetColor (Green);
 Line (x+1, y+1, x+20, y+1);
 Line (x+1, y+1, x+1, y+20);
 Circle (x+11, y+11, 5);

 SetFillStyle (1, Red);
 Bar  (x+3, y+9, x+18, y+10);
 Bar  (x+9, y+3, x+10, y+18);
 SetFillStyle (1, 3);
 Bar  (x+3, y+11, x+18, y+12);
 Bar  (x+11, y+3, x+12, y+18);
 PutPixel (x+13, y+14, 3);
 PutPixel (x+7, y+13, 4);
 PutPixel (x+13, y+7, 4);
 PutPixel (x+8, y+7, 4);
 PutPixel (x+9, y+9, 15);
 PutPixel (x+12, y+9, 1);
 PutPixel (x+11, y+11, 1);
 PutPixel (x+12, y+12, 1);
 PutPixel (x+9, y+12, 1);
 SetColor (x+3);
 Line (x+13, y+13, x+14, y+13);
 Line (x+13, y+8, x+14, y+8);
 Line (x+8, y+13, x+8, y+14);
 Line (x+11, y+1, x+11, y+2);
 Line (x+11, y+19, x+11, y+20);
 Line (x+19, y+11, x+20, y+11);
 Line (x+1, y+11, x+2, y+11);
 SetColor (4);
 Line (x+10, y+1, x+10, y+2);
 Line (x+1, y+10, x+2, y+10);
 Line (x+19, y+10, x+20, y+10);
 Line (x+10, y+19, x+10, y+20);
 Line (x+7, y+8, x+8, y+8);
 SetColor (15);
 Line (x+10, y+8, x+11, y+8);
 Line (x+8, y+10, x+8, y+11);
 SetFillStyle (1, 9);
 Bar  (x+9, y+10, x+10, y+11);
 Bar  (x+10, y+9, x+11, y+10);
 SetFillStyle (1, 1);
 Bar  (x+12, y+10, x+13, y+11);
 Bar  (x+10, y+12, x+11, y+13);
End;


{****************************************************************************}
PROCEDURE FLOOR;
Begin;
 SetFillStyle (1, 7);
 Bar  (x+1, y+1, x+20, y+20);

 SetColor (15);
 Line (x+1, y+20, x+20, y+20);
 Line (x+20, y+1, x+20, y+20);
 
 SetColor (8);
 Line (x+1, y+1, x+20, y+1);
 Line (x+1, y+2, x+1, y+20);
End;

{****************************************************************************}
PROCEDURE CAR;
Begin;
 SetFillStyle (1, 7);
 Bar  (x+1, y+1, x+20, y+20);
 SetColor (15);
 Line (x+1, y+20, x+20, y+20);
 Line (x+20, y+1, x+20, y+20);
 SetColor (8);
 Line (x+1, y+1, x+20, y+1);
 Line (x+1, y+2, x+1, y+20);

 SetFillStyle (1, Red);
 Bar  (x+3, y+9, x+18, y+10);
 Bar  (x+9, y+3, x+10, y+18);
 SetFillStyle (1, 3);
 Bar  (x+3, y+11, x+18, y+12);
 Bar  (x+11, y+3, x+12, y+18);
 PutPixel (x+13, y+14, 3);
 PutPixel (x+7, y+13, 4);
 PutPixel (x+13, y+7, 4);
 PutPixel (x+8, y+7, 4);
 PutPixel (x+9, y+9, 15);
 PutPixel (x+12, y+9, 1);
 PutPixel (x+11, y+11, 1);
 PutPixel (x+12, y+12, 1);
 PutPixel (x+9, y+12, 1);
 SetColor (x+3);
 Line (x+13, y+13, x+14, y+13);
 Line (x+13, y+8, x+14, y+8);
 Line (x+8, y+13, x+8, y+14);
 Line (x+11, y+1, x+11, y+2);
 Line (x+11, y+19, x+11, y+20);
 Line (x+19, y+11, x+20, y+11);
 Line (x+1, y+11, x+2, y+11);
 SetColor (4);
 Line (x+10, y+1, x+10, y+2);
 Line (x+1, y+10, x+2, y+10);
 Line (x+19, y+10, x+20, y+10);
 Line (x+10, y+19, x+10, y+20);
 Line (x+7, y+8, x+8, y+8);
 SetColor (15);
 Line (x+10, y+8, x+11, y+8);
 Line (x+8, y+10, x+8, y+11);
 SetFillStyle (1, 9);
 Bar  (x+9, y+10, x+10, y+11);
 Bar  (x+10, y+9, x+11, y+10);
 SetFillStyle (1, 1);
 Bar  (x+12, y+10, x+13, y+11);
 Bar  (x+10, y+12, x+11, y+13);
End;


{****************************************************************************}
PROCEDURE KISTE;
Begin;
 SetFillStyle (1, 2);
 Bar  (x+1, y+1, x+20, y+20);

 SetColor (10);
 Line (x+1, y+1, x+1, y+20);
 Line (x+2, y+4, x+20, y+4);
 Line (x+2, y+14, x+20, y+14);
 Line (x+2, y+1, x+4, y+1);
 Line (x+7, y+1, x+9, y+1);
 Line (x+12, y+1, x+13, y+1);
 Line (x+16, y+1, x+19, y+1);
 Line (x+7, y+2, x+7, y+3);
 Line (x+12, y+2, x+12, y+3);
 Line (x+16, y+2, x+16, y+3);
 Line (x+16, y+2, x+16, y+3);
 Line (x+7, y+8, x+7, y+13);
 Line (x+12, y+8, x+12, y+13);
 Line (x+16, y+8, x+16, y+13);
 Line (x+16, y+8, x+16, y+13);
 Line (x+7, y+18, x+7, y+20);
 Line (x+12, y+18, x+12, y+20);
 Line (x+16, y+18, x+16, y+20);
 Line (x+16, y+18, x+16, y+20);

 SetColor (8);
 Line (x+2, y+7, x+20, y+7);
 Line (x+2, y+17, x+20, y+17);
 Line (x+5, y+1, x+5, y+3);
 Line (x+10, y+1, x+10, y+3);
 Line (x+14, y+1, x+14, y+3);
 Line (x+20, y+1, x+20, y+3);
 Line (x+5, y+8, x+5, y+13);
 Line (x+10, y+8, x+10, y+13);
 Line (x+14, y+8, x+14, y+13);
 Line (x+20, y+8, x+20, y+13);
 Line (x+5, y+18, x+5, y+20);
 Line (x+10, y+18, x+10, y+20);
 Line (x+14, y+18, x+14, y+20);
 Line (x+20, y+18, x+20, y+20);
 Line (x+2, y+20, x+4, y+20);
 Line (x+8, y+20, x+9, y+20);
 Line (x+17, y+20, x+19, y+20);
 PutPixel (x+13, y+20, 8);

 SetColor (0);
 Line (x+6, y+1, x+6, y+3);
 Line (x+11, y+1, x+11, y+3);
 Line (x+15, y+1, x+15, y+3);
 Line (x+6, y+8, x+6, y+13);
 Line (x+11, y+8, x+11, y+13);
 Line (x+15, y+8, x+15, y+13);
 Line (x+6, y+18, x+6, y+20);
 Line (x+11, y+18, x+11, y+20);
 Line (x+15, y+18, x+15, y+20);
 PutPixel (x+3, y+3, 0);
 PutPixel (x+9, y+3, 0);
 PutPixel (x+13, y+3, 0);
 PutPixel (x+18, y+3, 0);
 PutPixel (x+3, y+6, 0);
 PutPixel (x+18, y+5, 0);
 PutPixel (x+3, y+16, 0);
 PutPixel (x+18, y+15, 0);
 PutPixel (x+3, y+18, 0);
 PutPixel (x+8, y+18, 0);
 PutPixel (x+13, y+18, 0);
 PutPixel (x+18, y+18, 0);
End;

{****************************************************************************}
PROCEDURE BLUEBOX;
Begin;
 SetFillStyle (1, 9);
 Bar  (x+1, y+1, x+20, y+20);

 SetColor (11);
 Line (x+1, y+1, x+1, y+20);
 Line (x+2, y+4, x+20, y+4);
 Line (x+2, y+14, x+20, y+14);
 Line (x+2, y+1, x+4, y+1);
 Line (x+7, y+1, x+9, y+1);
 Line (x+12, y+1, x+13, y+1);
 Line (x+16, y+1, x+19, y+1);
 Line (x+7, y+2, x+7, y+3);
 Line (x+12, y+2, x+12, y+3);
 Line (x+16, y+2, x+16, y+3);
 Line (x+16, y+2, x+16, y+3);
 Line (x+7, y+8, x+7, y+13);
 Line (x+12, y+8, x+12, y+13);
 Line (x+16, y+8, x+16, y+13);
 Line (x+16, y+8, x+16, y+13);
 Line (x+7, y+18, x+7, y+20);
 Line (x+12, y+18, x+12, y+20);
 Line (x+16, y+18, x+16, y+20);
 Line (x+16, y+18, x+16, y+20);

 SetColor (1);
 Line (x+2, y+7, x+20, y+7);
 Line (x+2, y+17, x+20, y+17);
 Line (x+5, y+1, x+5, y+3);
 Line (x+10, y+1, x+10, y+3);
 Line (x+14, y+1, x+14, y+3);
 Line (x+20, y+1, x+20, y+3);
 Line (x+5, y+8, x+5, y+13);
 Line (x+10, y+8, x+10, y+13);
 Line (x+14, y+8, x+14, y+13);
 Line (x+20, y+8, x+20, y+13);
 Line (x+5, y+18, x+5, y+20);
 Line (x+10, y+18, x+10, y+20);
 Line (x+14, y+18, x+14, y+20);
 Line (x+20, y+18, x+20, y+20);
 Line (x+2, y+20, x+4, y+20);
 Line (x+8, y+20, x+9, y+20);
 Line (x+17, y+20, x+19, y+20);
 PutPixel (x+13, y+20, 8);

 SetColor (0);
 Line (x+6, y+1, x+6, y+3);
 Line (x+11, y+1, x+11, y+3);
 Line (x+15, y+1, x+15, y+3);
 Line (x+6, y+8, x+6, y+13);
 Line (x+11, y+8, x+11, y+13);
 Line (x+15, y+8, x+15, y+13);
 Line (x+6, y+18, x+6, y+20);
 Line (x+11, y+18, x+11, y+20);
 Line (x+15, y+18, x+15, y+20);
 PutPixel (x+3, y+3, 0);
 PutPixel (x+9, y+3, 0);
 PutPixel (x+13, y+3, 0);
 PutPixel (x+18, y+3, 0);
 PutPixel (x+3, y+6, 0);
 PutPixel (x+18, y+5, 0);
 PutPixel (x+3, y+16, 0);
 PutPixel (x+18, y+15, 0);
 PutPixel (x+3, y+18, 0);
 PutPixel (x+8, y+18, 0);
 PutPixel (x+13, y+18, 0);
 PutPixel (x+18, y+18, 0);
End;

PROCEDURE NOWIN;
{****************************************************************************}
 Begin;
  SetFillStyle (8, Blue);
  Bar (x1, y1, x2, y2);
 End;


PROCEDURE WIN;
{****************************************************************************}
 Begin;
  SetFillStyle (1, Nrm);
  Bar (x1, y1, x2, y2);

  SetColor (Lit);
  Line (x1, y1, x2, y1);
  Line (x1, y1+1, x2, y1+1);
  Line (x1, y1, x1, y2);
  Line (x1+1, y1, x1+1, y2);

  SetColor (Drk);
  Line (x2, y1+1, x2, y2);
  Line (x2-1, y1+2, x2-1, y2);
  Line (x1, y2, x2, y2);
  Line (x1+1, y2-1, x2, y2-1);

  Line (x1+Brd, y1+Brd, x2-Brd, y1+Brd);
  Line (x1+Brd, y1+Brd, x1+Brd, y2-Brd-1);

  SetColor (Lit);
  Line (x2-Brd, y1+Brd, x2-Brd, y2-Brd);
  Line (x1+Brd, y2-Brd, x2-Brd, y2-Brd);
  SetFillStyle (1, LightBlue);
  Bar (X1+Brd+1, Y1+Brd+1, X2-Brd-1, Y1+Brd+Bbx);
  SetColor (Lit);
  Line (X1+Brd, Y1+Brd+Bbx, X2-Brd-1, Y1+Brd+Bbx);
  SetColor (Drk);
  Line (X1+Brd+1, Y1+Brd+Bbx+1, X2-Brd, Y1+Brd+Bbx+1);

  Lang := Length (Text);
  Lang := Trunc ((X2-X1-(Lang*8))/2);


  SetFillStyle (1, Blue);
  Bar (X1+Lang-8, Y1+Brd, X2-Lang+5, Y1+Bbx+Brd-2);
  SetColor (White);
  Line (X1+Lang-8, Y1+Brd, X1+Lang-8, Y1+Bbx+Brd-2);
  Line (X2-Lang+5, Y1+Brd, X2-Lang+5, Y1+Bbx+Brd-2);
  SetColor (Yellow);
  OutTextXY (X1+Lang, Y1+Brd+5, Text);
 End;

{****************************************************************************}

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}
BEGIN;
 INIS256(2,'D:\INFO\TP7\BGI');
 Randomize;
 4:
 ClearDevice;
 SetTextStyle (0, 0, 2);
 SetFillStyle (1, 1);
 Bar (199, 99, 440, 300);

 SetColor (Black);
 Rectangle (200, 100, 439, 139);
 Rectangle (200, 140, 439, 179);
 Rectangle (200, 180, 439, 219);
 Rectangle (200, 220, 439, 259);
 Rectangle (200, 260, 439, 299);

 SetColor (LightBlue);
 Rectangle (200, 140, 440, 180);
 Rectangle (200, 180, 440, 220);
 Rectangle (200, 220, 440, 260);
 Rectangle (200, 260, 440, 300);

 SetColor (Yellow);
 Rectangle (200, 100, 440, 140);

 SetColor (Black);
 OutTextXY (219, 112, 'NEW GAME');
 OutTextXY (219, 152, 'LOAD GAME');
 OutTextXY (219, 192, 'INFO');
 OutTextXY (219, 232, 'EDITOR');
 OutTextXY (219, 272, 'EXIT');
 SetColor (LightRed);
 OutTextXY (220, 113, 'NEW GAME');
 OutTextXY (220, 153, 'LOAD GAME');
 OutTextXY (220, 193, 'INFO');
 OutTextXY (220, 233, 'EDITOR');
 OutTextXY (220, 273, 'EXIT');

 Posi := 1;
 5:
 repeat;
  ch:=ReadKey;
 until Ch<>'';

 if Ch = Esc then
  begin;
   ClearDevice;
   CloseGraph;
   EXIT;
  end;

 if Ch =#13 then
  begin;
   Liv := 3;
   if Posi = 3 then Goto 7;
   if Posi = 1 then Goto 6;
   if Posi = 4 then
    begin;
     Command := 'D:\GAMES\HUMP\EDITOR.EXE';
      SwapVectors;
       Exec(Command, '');
      SwapVectors;
     if DosError <> 0 then
      begin;
       CloseGraph;
       ClrScr;
       WriteLn('ERROR >>> Could not open ',Command,' !!!');
       WriteLn;
       ReadLn;
       EXIT;
      end;
    end;
   if Posi = 5 then
    begin;
     CloseGraph;
     EXIT;
    end;
  end;

 if Ch=#0 then
  begin;
   Ch := ReadKey;

   if Ch =Rig then Ch := Dwn;
   if Ch =Lft then Ch := Up;

   if Ch =Dwn then
    begin;
     if Posi = 5 then
     begin;
     SetColor (LightBlue);
     Rectangle (200, 260, 440, 300);
     SetColor (Yellow);
     Rectangle (200, 100, 440, 140);
     Posi := 0;
     end
     else
     begin;
     SetColor (LightBlue);
     Rectangle (200, 100+((Posi-1)*40), 440, 100+(Posi*40));
     SetColor (Yellow);
     Rectangle (200, 100+((Posi)*40), 440, 100+((Posi+1)*40));
     end;
     Posi := Posi+1;
     Goto 5;
    end;

   if Ch =Up then
    begin;
     if Posi = 1 then
     begin;
     SetColor (LightBlue);
     Rectangle (200, 100, 440, 140);
     SetColor (Yellow);
     Rectangle (200, 260, 440, 300);
     Posi := 6;
     end
     else
     begin;
     SetColor (LightBlue);
     Rectangle (200, 100+((Posi-1)*40), 440, 100+(Posi*40));
     SetColor (Yellow);
     Rectangle (200, 100+((Posi-2)*40), 440, 100+((Posi-1)*40));
     end;

     Posi := Posi-1;
     Goto 5;
    end;
  end;

Goto 5;

 6:
 SetTextStyle (0, 0, 0);
 ClearDevice;
 SetFillStyle (8, Blue);
 Bar (0, 0, GetMaxX, GetMaxY);

 Text:= 'H U M P 1.0  by  C I R E `95';
 X1 := 0;
 Y1 := 0;
 X2 := GetMaxX;
 Y2 := 2*Bbx+2*Brd+2;
 WIN;
 Name := 'C:\CIRE\GAMES\HUMP\LEV2.DAT';
 Liv := 3;
 if Liv > 9 then Liv := 9;

 SetColor (Yellow);
 OutTextXY (287, Y1+Bbx+Brd+5, '   Leben');
 SetColor (Black);
 OutTextXY (288, Y1+Bbx+Brd+6, '   Leben');
 Str(Liv, Live);
 Live := Concat ('0', Live);
 SetColor (LightBlue);
 OutTextXY (287, Y1+Bbx+Brd+5, Live);
 SetColor (Black);
 OutTextXY (288, Y1+Bbx+Brd+6, Live);

 3:
 Assign (f,name);
 {$I-}
 Reset (f);
 {$I+}
 if IOResult <> 0 then
  Begin;
   ClearDevice;
   CloseGraph;
   ClrScr;
   WriteLn ('FATAL ERROR ... ');
   WriteLn ('Could not find Level file !!!');
   repeat
    Ch := ReadKey;
   until Ch<>'';
   EXIT;
  End;

 ReadLn (f, Level);
 Text := Concat ('HUMP ',Level);
 Readln (f, Grose);
 Val(Grose, XFld, code);
 Readln (f, Grose);
 Val(Grose, YFld, code);
 X1 := 100-Brd;
 Y1 := 99-Brd-Bbx;
 X2 := 100-Brd+(20*XFld)+Brd+6;
 Y2 := 99-Brd-Bbx+(20*YFld)+Brd+25;
 WIN;
 xZiel:=0;
 xKiste:=0;
 xCar:=0;
 For T:=1 to YFld do
  Begin;
   ReadLn (f, Zeile);
   For A:=1 to XFld do
    begin;
     Field := Copy (Zeile, A, 1);
     if Field = 'z' then xZiel := xZiel+1;
     if Field = 'k' then xKiste := xKiste+1;
     if Field = 'c' then
      begin;
       xCar := xCar+1;
       WoX := A;
       WoY := T;
      end;
     Zulu [A,T]:=Field;
    end;
  End;

 ReadLn (f, NextL);
 if xZiel <> xKiste then
  begin;
   CloseGraph;
   ClrScr;
   WriteLn ('FATAL ERROR...');
   WriteLn ('boxes <> finishes in this level !!!');
   repeat
    Ch := ReadKey;
   Until Ch <> '';
   EXIT;
  end;

 if xCar <>1 then
  begin;
   CloseGraph;
   ClrScr;
   WriteLn ('FATAL ERROR...');
   WriteLn ('There are more than 1, or there is no car in this level !!!');
   repeat
    Ch := ReadKey;
   Until Ch <> '';
   EXIT;
  end;

 if xZiel <1 then
  begin;
   CloseGraph;
   ClrScr;
   WriteLn ('FATAL ERROR...');
   WriteLn ('There are no Boxes and no Finishes in this level !!!');
   repeat
    Ch := ReadKey;
   Until Ch <> '';
   EXIT;
  end;

 For T:=1 to YFld do
  For A:=1 to XFld do
    begin;
     x:=81+A*20;
     y:=81+T*20;
     Field := Zulu [A,T];
     if Field ='m' then MAUER;
     if Field ='f' then FLOOR;
     if Field ='k' then KISTE;
     if Field ='z' then ZIEL;
     if Field ='c' then CAR;
     if Field ='o' then ZCAR;
    end;
 Close (f);
 NoMOVE := 0;
 xZiel:=0;

 1:
 if xKiste = xZiel then Goto 2;
 repeat
  Ch := Upcase(ReadKey);
 Until Ch <> '';

 if Ch = ' ' then Goto 4;

 if Ch = Esc then
  begin;
   if Liv=0 then Goto 4;
   SetFillStyle (1,7);
   Bar (287, Brd+Bbx+5, 304, Brd+Bbx+15);
   Liv := Liv-1;
   SetColor (Blue);
   if Liv = 2 then Live := '02';
   if Liv = 1 then Live := '01';
   if Liv = 0 then Live := '00';
   if Liv = 3 then Live := '03';
   if Liv = 4 then Live := '04';
   if Liv = 5 then Live := '05';
   if Liv = 6 then Live := '06';
   if Liv = 7 then Live := '07';
   if Liv = 8 then Live := '08';
   if Liv = 9 then Live := '09';
   if Liv = 10 then Live := '10';
   SetColor (LightBlue);
   OutTextXY (287, Bbx+Brd+5, Live);
   SetColor (Black);
   OutTextXY (288, Bbx+Brd+6, Live);
   Goto 3;
  end;

 if Ch = #0 then
  begin;
   Ch:=ReadKey;
{----------------------------------------------------------------------------}
   if Ch = Rig then
    begin;
     if Zulu[WoX+1,WoY]='m' then NoMOVE:=1;
     if Zulu[WoX+1,WoY]='k' then
      begin;
       if WoX+2 > XFld then NoMOVE:=1;
       if Zulu[WoX+2,WoY]='m' then NoMOVE:=1;
       if Zulu[WoX+2,WoY]='k' then NoMOVE:=1;
       if Zulu[WoX+2,WoY]='b' then NoMOVE:=1;
      end;

     if Zulu[WoX+1,WoY]='b' then
      begin;
       if WoX+2 > XFld then NoMOVE:=1;
       if Zulu[WoX+2,WoY]='m' then NoMOVE:=1;
       if Zulu[WoX+2,WoY]='k' then NoMOVE:=1;
       if Zulu[WoX+2,WoY]='b' then NoMOVE:=1;
      end;

     if NoMOVE=0 then
      begin;
       if Zulu[WoX+1,WoY]='f' then
        begin;
         x:=81+WoX*20+20;
         Y:=81+WoY*20;
         CAR;
         x:=81+WoX*20;
         if Zulu[WoX,WoY]='o' then
         begin;
          ZIEL;
          Zulu[WoX,WoY]:='z';
         end;
         if Zulu[WoX,WoY]='c' then
         begin;
          FLOOR;
          Zulu[WoX,WoY]:='f';
         end;
         Zulu[WoX+1,WoY]:='c';
         WoX := WoX+1;
         Goto 1;
        end;

       if Zulu[WoX+1,WoY]='z' then
        begin;
         x:=81+WoX*20+20;
         Y:=81+WoY*20;
         ZCAR;
         x:=81+WoX*20;
         if Zulu[WoX,WoY]='o' then
          begin;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX+1,WoY]:='o';
         WoX := WoX+1;
         Goto 1;
        end;

       if Zulu[WoX+1,WoY]='k' then
       if Zulu[WoX+2,WoY]='z' then
        begin;
         x:=81+WoX*20+40;
         Y:=81+WoY*20;
         BLUEBOX;
         x:=81+WoX*20+20;
         CAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           x:=81+WoX*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           x:=81+WoX*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX+2,WoY]:='b';
         Zulu[WoX+1,WoY]:='c';
         WoX := WoX+1;
         xZiel := xZiel+1;
         Goto 1;
        end

        else
        begin;
         x:=81+WoX*20+40;
         Y:=81+WoY*20;
         KISTE;
         x:=81+WoX*20+20;
         CAR;
         x:=81+WoX*20;
         if Zulu[WoX,Woy]='c' then
          begin;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         if Zulu[WoX,Woy]='o' then
          begin;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;

         Zulu[WoX+1,WoY]:='c';
         Zulu[WoX+2,WoY]:='k';
         WoX := WoX+1;
         Goto 1;
        end;

       if Zulu[WoX+1,WoY]='b' then
       if Zulu[WoX+2,WoY]='f' then
        begin;
         x:=81+WoX*20+40;
         Y:=81+WoY*20;
         KISTE;
         x:=81+WoX*20+20;
         ZCAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           x:=81+WoX*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           x:=81+WoX*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX+2,WoY]:='k';
         Zulu[WoX+1,WoY]:='o';
         WoX := WoX+1;
         xZiel := xZiel-1;
         Goto 1;
        end;

       if Zulu[WoX+1,WoY]='b' then
       if Zulu[WoX+2,WoY]='z' then
        begin;
         x:=81+WoX*20+40;
         Y:=81+WoY*20;
         BLUEBOX;
         x:=81+WoX*20+20;
         ZCAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           x:=81+WoX*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           x:=81+WoX*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX+2,WoY]:='b';
         Zulu[WoX+1,WoY]:='o';
         WoX := WoX+1;
         Goto 1;
        end;

        
       end;
      end;

{----------------------------------------------------------------------------}
   if Ch = Lft then
    begin;
     if Zulu[WoX-1,WoY]='m' then NoMOVE:=1;
     if Zulu[WoX-1,WoY]='k' then
      begin;
       if WoX-2 < 1 then NoMOVE:=1;
       if Zulu[WoX-2,WoY]='m' then NoMOVE:=1;
       if Zulu[WoX-2,WoY]='k' then NoMOVE:=1;
       if Zulu[WoX-2,WoY]='b' then NoMOVE:=1;
      end;
     if Zulu[WoX-1,WoY]='b' then
      begin;
       if WoX-2 < 1 then NoMOVE:=1;
       if Zulu[WoX-2,WoY]='m' then NoMOVE:=1;
       if Zulu[WoX-2,WoY]='k' then NoMOVE:=1;
       if Zulu[WoX-2,WoY]='b' then NoMOVE:=1;
      end;

     if NoMOVE=0 then
      begin;
       if Zulu[WoX-1,WoY]='f' then
        begin;
         x:=81+WoX*20-20;
         Y:=81+WoY*20;
         CAR;
         x:=81+WoX*20;
         if Zulu[WoX,WoY]='o' then
         begin;
          ZIEL;
          Zulu[WoX,WoY]:='z';
         end;
         if Zulu[WoX,WoY]='c' then
         begin;
          FLOOR;
          Zulu[WoX,WoY]:='f';
         end;
         Zulu[WoX-1,WoY]:='c';
         WoX := WoX-1;
         Goto 1;
        end;

       if Zulu[WoX-1,WoY]='k' then
       if Zulu[WoX-2,WoY]='z' then
        begin;
         x:=81+WoX*20-40;
         Y:=81+WoY*20;
         BLUEBOX;
         x:=81+WoX*20-20;
         CAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           x:=81+WoX*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           x:=81+WoX*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX-2,WoY]:='b';
         Zulu[WoX-1,WoY]:='c';
         WoX := WoX-1;
         xZiel := xZiel+1;
         Goto 1;
        end

        else
        begin;
         x:=81+WoX*20-40;
         Y:=81+WoY*20;
         KISTE;
         x:=81+WoX*20-20;
         CAR;
         x:=81+WoX*20;
         if Zulu[WoX,Woy]='c' then
          begin;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         if Zulu[WoX,Woy]='o' then
          begin;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;

         Zulu[WoX-1,WoY]:='c';
         Zulu[WoX-2,WoY]:='k';
         WoX := WoX-1;
         Goto 1;
        end;

       if Zulu[WoX-1,WoY]='z' then
        begin;
         x:=81+WoX*20-20;
         Y:=81+WoY*20;
         ZCAR;
         x:=81+WoX*20;
         if Zulu[WoX,WoY]='o' then
          begin;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX-1,WoY]:='o';
         WoX := WoX-1;
         Goto 1;
        end;

       if Zulu[WoX-1,WoY]='b' then
       if Zulu[WoX-2,WoY]='f' then
        begin;
         x:=81+WoX*20-40;
         Y:=81+WoY*20;
         KISTE;
         x:=81+WoX*20-20;
         ZCAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           x:=81+WoX*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           x:=81+WoX*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX-2,WoY]:='k';
         Zulu[WoX-1,WoY]:='o';
         WoX := WoX-1;
         xZiel := xZiel-1;
         Goto 1;
        end;

       if Zulu[WoX-1,WoY]='b' then
       if Zulu[WoX-2,WoY]='z' then
        begin;
         x:=81+WoX*20-40;
         Y:=81+WoY*20;
         BLUEBOX;
         x:=81+WoX*20-20;
         ZCAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           x:=81+WoX*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           x:=81+WoX*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX-2,WoY]:='b';
         Zulu[WoX-1,WoY]:='o';
         WoX := WoX-1;
         Goto 1;
        end;

      end;
    end;


{----------------------------------------------------------------------------}
   if Ch = Up then
    begin;
     if Zulu[WoX,WoY-1]='m' then NoMOVE:=1;
     if Zulu[WoX,WoY-1]='k' then
      begin;
       if WoY-2 < 1 then NoMOVE:=1;
       if Zulu[WoX,WoY-2]='m' then NoMOVE:=1;
       if Zulu[WoX,WoY-2]='k' then NoMOVE:=1;
       if Zulu[WoX,WoY-2]='b' then NoMOVE:=1;
      end;
     if Zulu[WoX,WoY-1]='b' then
      begin;
       if WoY-2 < 1 then NoMOVE:=1;
       if Zulu[WoX,WoY-2]='m' then NoMOVE:=1;
       if Zulu[WoX,WoY-2]='k' then NoMOVE:=1;
       if Zulu[WoX,WoY-2]='b' then NoMOVE:=1;
      end;

     if NoMOVE=0 then
      begin;
       if Zulu[WoX,WoY-1]='f' then
        begin;
         x:=81+WoX*20;
         Y:=81+WoY*20-20;
         CAR;
         y:=81+Woy*20;
         if Zulu[WoX,WoY]='o' then
         begin;
          ZIEL;
          Zulu[WoX,WoY]:='z';
         end;
         if Zulu[WoX,WoY]='c' then
         begin;
          FLOOR;
          Zulu[WoX,WoY]:='f';
         end;
         Zulu[WoX,WoY-1]:='c';
         WoY := WoY-1;
         Goto 1;
        end;

       if Zulu[WoX,WoY-1]='k' then
       if Zulu[WoX,WoY-2]='z' then
        begin;
         x:=81+WoX*20;
         Y:=81+WoY*20-40;
         BLUEBOX;
         y:=81+WoY*20-20;
         CAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           y:=81+Woy*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           y:=81+Woy*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX,WoY-2]:='b';
         Zulu[WoX,WoY-1]:='c';
         WoY := WoY-1;
         xZiel := xZiel+1;
         Goto 1;
        end

        else
        begin;
         x:=81+WoX*20;
         Y:=81+WoY*20-40;
         KISTE;
         y:=81+WoY*20-20;
         CAR;
         y:=81+Woy*20;
         if Zulu[WoX,Woy]='c' then
          begin;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         if Zulu[WoX,Woy]='o' then
          begin;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;

         Zulu[WoX,WoY-1]:='c';
         Zulu[WoX,WoY-2]:='k';
         WoY := WoY-1;
         Goto 1;
        end;

       if Zulu[WoX,WoY-1]='z' then
        begin;
         x:=81+WoX*20;
         Y:=81+WoY*20-20;
         ZCAR;
         y:=81+Woy*20;
         if Zulu[WoX,WoY]='o' then
          begin;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX,WoY-1]:='o';
         WoY := WoY-1;
         Goto 1;
        end;

       if Zulu[WoX,WoY-1]='b' then
       if Zulu[WoX,WoY-2]='f' then
        begin;
         Y:=81+WoY*20-40;
         x:=81+Wox*20;
         KISTE;
         y:=81+Woy*20-20;
         ZCAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           y:=81+Woy*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           y:=81+Woy*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX,WoY-2]:='k';
         Zulu[WoX,WoY-1]:='o';
         WoY := WoY-1;
         xZiel := xZiel-1;
         Goto 1;
        end;

       if Zulu[WoX,WoY-1]='b' then
       if Zulu[WoX,WoY-2]='z' then
        begin;
         y:=81+Woy*20-40;
         x:=81+Wox*20;
         BLUEBOX;
         y:=81+Woy*20-20;
         ZCAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           y:=81+Woy*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           y:=81+Woy*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX,WoY-2]:='b';
         Zulu[WoX,WoY-1]:='o';
         WoY := WoY-1;
         Goto 1;
        end;
      end;
    end;

{----------------------------------------------------------------------------}
   if Ch = Dwn then
    begin;
     if Zulu[WoX,WoY+1]='m' then NoMOVE:=1;
     if Zulu[WoX,WoY+1]='k' then
      begin;
       if WoY+2 > YFld then NoMOVE:=1;
       if Zulu[WoX,WoY+2]='m' then NoMOVE:=1;
       if Zulu[WoX,WoY+2]='k' then NoMOVE:=1;
       if Zulu[WoX,WoY+2]='b' then NoMOVE:=1;
      end;
     if Zulu[WoX,WoY+1]='b' then
      begin;
       if WoY+2 > YFld then NoMOVE:=1;
       if Zulu[WoX,WoY+2]='m' then NoMOVE:=1;
       if Zulu[WoX,WoY+2]='k' then NoMOVE:=1;
       if Zulu[WoX,WoY+2]='b' then NoMOVE:=1;
      end;

     if NoMOVE=0 then
      begin;
       if Zulu[WoX,WoY+1]='f' then
        begin;
         x:=81+WoX*20;
         Y:=81+WoY*20+20;
         CAR;
         y:=81+Woy*20;
         if Zulu[WoX,WoY]='o' then
         begin;
          ZIEL;
          Zulu[WoX,WoY]:='z';
         end;
         if Zulu[WoX,WoY]='c' then
         begin;
          FLOOR;
          Zulu[WoX,WoY]:='f';
         end;
         Zulu[WoX,WoY+1]:='c';
         WoY := WoY+1;
         Goto 1;
        end;

       if Zulu[WoX,WoY+1]='z' then
        begin;
         x:=81+WoX*20;
         Y:=81+WoY*20+20;
         ZCAR;
         y:=81+Woy*20;
         if Zulu[WoX,WoY]='o' then
          begin;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX,WoY+1]:='o';
         WoY := WoY+1;
         Goto 1;
        end;

       if Zulu[WoX,WoY+1]='k' then
       if Zulu[WoX,WoY+2]='z' then
        begin;
         x:=81+WoX*20;
         Y:=81+WoY*20+40;
         BLUEBOX;
         y:=81+WoY*20+20;
         CAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           y:=81+Woy*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           y:=81+Woy*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX,WoY+2]:='b';
         Zulu[WoX,WoY+1]:='c';
         WoY := WoY+1;
         xZiel := xZiel+1;
         Goto 1;
        end

        else
        begin;
         x:=81+WoX*20;
         Y:=81+WoY*20+40;
         KISTE;
         y:=81+WoY*20+20;
         CAR;
         y:=81+Woy*20;
         if Zulu[WoX,Woy]='c' then
          begin;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         if Zulu[WoX,Woy]='o' then
          begin;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;

         Zulu[WoX,WoY+1]:='c';
         Zulu[WoX,WoY+2]:='k';
         WoY := WoY+1;
         Goto 1;
        end;

       if Zulu[WoX,WoY+1]='b' then
       if Zulu[WoX,WoY+2]='f' then
        begin;
         Y:=81+WoY*20+40;
         x:=81+Wox*20;
         KISTE;
         y:=81+Woy*20+20;
         ZCAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           y:=81+Woy*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           y:=81+Woy*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX,WoY+2]:='k';
         Zulu[WoX,WoY+1]:='o';
         WoY := WoY+1;
         xZiel := xZiel-1;
         Goto 1;
        end;

       if Zulu[WoX,WoY+1]='b' then
       if Zulu[WoX,WoY+2]='z' then
        begin;
         y:=81+Woy*20+40;
         x:=81+Wox*20;
         BLUEBOX;
         y:=81+Woy*20+20;
         ZCAR;
         if Zulu[WoX,WoY]='o' then
          begin;
           y:=81+Woy*20;
           ZIEL;
           Zulu[WoX,WoY]:='z';
          end;
         if Zulu[WoX,WoY]='c' then
          begin;
           y:=81+Woy*20;
           FLOOR;
           Zulu[WoX,WoY]:='f';
          end;
         Zulu[WoX,WoY+2]:='b';
         Zulu[WoX,WoY+1]:='o';
         WoY := WoY+1;
         Goto 1;
        end;
      end;
    end;
  end;
  NoMOVE:=0;
 Goto 1;
{****************************************************************************}

 2:
 if NextL = 'end' then
  begin;
   {CloseGraph;
   SwapVectors;
   Exec ('C:\TP\PLAY.EXE',' ');
   SwapVectors;
   INI;}
   Goto 4;
  end;

 Name := NextL;
 NoWIN;
 Text:= 'GET READY FOR THE NEXT LEVEL...';
 X1:= 150;
 Y1:= 200;
 X2:= 490;
 Y2:= 240;
 WIN;

 repeat;
  Ch:=ReadKey;
 until Ch<>'';
 NoWIN;
 Goto 3;

{-------------------------------------INFO-----------------------------------}
 7:
 begin;
  ClearDevice;
  SetTextStyle (0, 0, 1);
  Text := ' I N F O R M A T I O N ';
  X1:=100;
  Y1:=150;
  X2:=490;
  Y2:=380;
  WIN;

  N1 := 'HUMP 1.0 - programmed by CIRE...';
  N2 := '--------------------------------';
  N3 := '....... GRAPHICS by CIRE .......';
  N4 := '......... LEVEL by CIRE ........';
  N5 := '.... CIRE: BRD 03841/616250 ....';

  Lang := Length (N1);
  Posi := 1;
  SetColor (0);
  SetTextStyle (2, 0, 5);

  for T:=1 to Lang do
   begin;
    Live := Copy (N1, T, 1);
    SetColor (14);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+20, Live);
    delay (25);
    SetColor (7);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+20, Live);
    delay (25);
    SetColor (8);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+20, Live);
    delay (25);
    SetColor (0);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+20, Live);
    delay (25);
    if Keypressed then Goto 9;
   end;

  delay (100);

  for T:=1 to Lang do
   begin;
    Live := Copy (N2, T, 1);
    SetColor (14);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+40, Live);
    delay (15);
    SetColor (7);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+40, Live);
    delay (15);
    SetColor (8);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+40, Live);
    delay (15);
    SetColor (0);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+40, Live);
    if Keypressed then Goto 9;
    delay (15);
   end;

  delay (100);

  for T:=1 to Lang do
   begin;
    Live := Copy (N3, T, 1);
    SetColor (14);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+60, Live);
    delay (25);
    SetColor (7);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+60, Live);
    delay (25);
    SetColor (8);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+60, Live);
    delay (25);
    SetColor (0);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+60, Live);
    if Keypressed then Goto 9;
    delay (25);
   end;

  delay (100);

  for T:=1 to Lang do
   begin;
    Live := Copy (N4, T, 1);
    SetColor (LightGreen);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+80, Live);
    delay (25);
    SetColor (14);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+80, Live);
    delay (25);
    SetColor (8);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+80, Live);
    delay (25);
    SetColor (0);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+80, Live);
    if Keypressed then Goto 9;
    delay (25);
   end;

  delay (100);

  for T:=1 to Lang do
   begin;
    Live := Copy (N5, T, 1);
    SetColor (14);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+100, Live);
    delay (25);
    SetColor (7);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+100, Live);
    delay (25);
    SetColor (8);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+100, Live);
    delay (25);
    SetColor (0);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+100, Live);
    if Keypressed then Goto 9;
    delay (25);
   end;

  delay (100);

  for T:=1 to Lang do
   begin;
    Live := Copy (N2, T, 1);
    SetColor (14);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+120, Live);
    delay (15);
    SetColor (7);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+120, Live);
    delay (15);
    SetColor (8);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+120, Live);
    delay (15);
    SetColor (0);
    OutTextXY (X1+Brd+60+(T*8), Y1+Brd+Bbx+120, Live);
    if Keypressed then Goto 9;
    delay (15);
   end;

  9:
  repeat;
   Ch:=ReadKey;
  until Ch<>'';
  Goto 4;
 end;
END.
