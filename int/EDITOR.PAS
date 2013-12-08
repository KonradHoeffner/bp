uses Dos,Crt,Graph,Graphbo;

var
  f                         : Text;
  Gd, Gm, T, X1, Y1, X2, Y2 : Integer;
  X, Y, Lang, XFld, YFld    : Integer;
  Code, A, N, xZiel, xKiste : Integer;
  xCar, WoX, WoY, NoMOVE    : Integer;
  Posi                      : Integer;
  Ch                        : Char;
  Liv, LName, FName, AName  : String;
  Text, Name, Level, Grose  : String;
  Zeile, Field, NextL       : String;
  Xdim, YDim                : String;
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

  Label 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15;

{****************************************************************************}
PROCEDURE MAUER;
Begin;
 SetFillStyle (1, Red);
 Bar (x+1, y+1, x+20, y+20);
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
PROCEDURE FADENMAUER;
Begin;
 SetFillStyle (1, Red);
 Bar (x+1, y+1, x+20, y+20);
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
 SetColor (1);
 Line (x+2, y+2, x+19, y+19);
 Line (x+19, y+2, x+2, y+19);
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
PROCEDURE FADENZIEL;
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
 SetColor (1);
 Line (x+2, y+2, x+19, y+19);
 Line (x+19, y+2, x+2, y+19);
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
PROCEDURE FADENCAR;
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
 SetColor (1);
 Line (x+2, y+2, x+19, y+19);
 Line (x+19, y+2, x+2, y+19);
End;


{****************************************************************************}
PROCEDURE FADEN;
Begin;
 SetFillStyle (1, 7);
 Bar  (x+1, y+1, x+20, y+20);
 SetColor (15);
 Line (x+1, y+20, x+20, y+20);
 Line (x+20, y+1, x+20, y+20);
 SetColor (8);
 Line (x+1, y+1, x+20, y+1);
 Line (x+1, y+2, x+1, y+20);
 SetColor (1);
 Line (x+2, y+2, x+19, y+19);
 Line (x+19, y+2, x+2, y+19);
End;

{****************************************************************************}
PROCEDURE FADENKISTE;
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
 SetColor (1);
 Line (x+2, y+2, x+19, y+19);
 Line (x+19, y+2, x+2, y+19);
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
 INIS256 (2,'D:\INFO\TP7\BGI');
 Randomize;

{-------------------------------------EDIT-----------------------------------}
 8:
 begin;
  ClearDevice;

 SetTextStyle (0, 0, 2);
 SetFillStyle (1, 1);
 Bar (199, 99, 440, 180);

 SetColor (Black);
 Rectangle (200, 100, 439, 139);
 Rectangle (200, 140, 439, 179);
 
 SetColor (LightBlue);
 Rectangle (200, 140, 440, 180);
 
 SetColor (Yellow);
 Rectangle (200, 100, 440, 140);

 SetColor (Black);
 OutTextXY (219, 112, 'EDIT LEVEL');
 OutTextXY (219, 152, 'EXIT');
 SetColor (LightRed);
 OutTextXY (220, 113, 'EDIT LEVEL');
 OutTextXY (220, 153, 'EXIT');

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
   if Posi = 1 then Goto 12;
   if Posi = 2 then
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
     if Posi = 2 then
     begin;
     SetColor (LightBlue);
     Rectangle (200, 140, 440, 180);
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
     Rectangle (200, 140, 440, 180);
     Posi := 3;
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

  12:
  ClearDevice;
  SetFillStyle (6, 1);
  Bar (0, 0, 640, 480);
  SetTextStyle (0, 0, 1);
  Text := 'Leveleditor';
  X1:=150;
  Y1:=150;
  X2:=490;
  Y2:=250;
  WIN;

   SetColor (Black);
   OutTextXY (X1+Brd+10, Y1+Brd+Bbx+50, 'Height  :');
   OutTextXY (X1+Brd+10, Y1+Brd+Bbx+10, 'The dimensions of the level (max.25x15):');
   SetFillStyle (1, Nrm);
   SetColor (1);
   OutTextXY (X1+Brd+10, Y1+Brd+Bbx+30, 'Width   :');
   SetColor (Black);
   XDim := '';
   YDim := '';
   Posi:=0;
   T:=0;
   10:
    repeat
     ch:=ReadKey
    until Ch <> '';

   if Ch= Chr(13) then T:=1;
   if Ch= Chr(27) then
    begin;
     Goto 10;
    end;
   if Ch= Chr(8) then
    begin;
     Posi:=Posi-1;
     if Posi < 0 then Posi := 0;
     Bar(X1+Brd+80+Posi*8+8, Y1+Brd+Bbx+38, X1+Brd+80+Posi*8+16, Y1+Brd+Bbx+30);
     Lang := Length (XDim);
     Delete (XDim, Lang, 1);
     T:=2;
    end;

   if T=2 then
    begin;
     T:=0;
     Goto 10;
    end;

   if T=0 then
    begin;
     Posi:=Posi+1;
     if Posi > 2 then
      begin;
       Posi := 2;
       Bar(X1+Brd+80+Posi*8, Y1+Brd+Bbx+38, X1+Brd+80+Posi*8+8, Y1+Brd+Bbx+30);
       OutTextXY (X1+Brd+80+Posi*8, Y1+Brd+Bbx+30, Ch);
       Lang := Length (XDim);
       Delete (XDim, Lang, 1);
       XDim := Concat (XDim, Ch);
       Goto 10;
      end
     else
      begin;
       OutTextXY (X1+Brd+80+Posi*8, Y1+Brd+Bbx+30, Ch);
       Xdim := Concat (Xdim, Ch);
       Goto 10;
      end;
    end;

    if Xdim = '' then Xdim := '?';
    SetColor (DarkGray);
    OutTextXY (X1+Brd+88, Y1+Brd+Bbx+30, Xdim);
    SetColor (Black);
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+30, 'Width   :');

{-----------------------------------------------}

   SetColor (1);
   OutTextXY (X1+Brd+10, Y1+Brd+Bbx+50, 'Height  :');
   SetColor (Black);
   Posi:=0;
   T:=0;
   11:
    repeat
     ch:=ReadKey
    until Ch <> '';

   if Ch= Chr(13) then T:=1;
   if Ch= Chr(27) then
    begin;
     Goto 11;
    end;
   if Ch= Chr(8) then
    begin;
     Posi:=Posi-1;
     if Posi < 0 then Posi := 0;
     Bar(X1+Brd+80+Posi*8+8, Y1+Brd+Bbx+58, X1+Brd+80+Posi*8+16, Y1+Brd+Bbx+50);
     Lang := Length (Ydim);
     Delete (Ydim, Lang, 1);
     T:=2;
    end;

   if T=2 then
    begin;
     T:=0;
     Goto 11;
    end;

   if T=0 then
    begin;
     Posi:=Posi+1;
     if Posi > 2 then
      begin;
       Posi := 2;
       Bar(X1+Brd+80+Posi*8, Y1+Brd+Bbx+58, X1+Brd+80+Posi*8+8, Y1+Brd+Bbx+50);
       OutTextXY (X1+Brd+80+Posi*8, Y1+Brd+Bbx+50, Ch);
       Lang := Length (Ydim);
       Delete (Ydim, Lang, 1);
       Ydim := Concat (Ydim, Ch);
       Goto 11;
      end
     else
      begin;
       OutTextXY (X1+Brd+80+Posi*8, Y1+Brd+Bbx+50, Ch);
       Ydim := Concat (Ydim, Ch);
       Goto 11;
      end;
    end;

    if Ydim = '' then Ydim := '?';
    SetColor (DarkGray);
    OutTextXY (X1+Brd+88, Y1+Brd+Bbx+50, Ydim);
    SetColor (Black);
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+50, 'Height  :');

  SetFillStyle (1, 0);
  Bar (0, 0, 640, 480);

  Text:= 'H U M P 1.0  by  C I R E `95';
  X1 := 0;
  Y1 := 0;
  X2 := GetMaxX;
  Y2 := 2*Bbx+2*Brd+2;
  WIN;
  SetColor (Blue);
  OutTextXY (X1+Brd+10, Y1+Brd+Bbx+6, '   Speichern          Neu            Exit');
  SetColor (Black);
  OutTextXY (X1+Brd+10, Y1+Brd+Bbx+6, 'F1                 F3            Esc');

  Val (XDim, XFld, Code);
  Val (YDim, YFld, Code);

  if XFld > 25 then XFld := 25;
  if YFld > 15 then YFld := 15;
  if XFld < 5 then XFld := 5;
  if YFld < 5 then YFld := 5;

  For T:=1 to YFld do
   For A:=1 to XFld do Zulu[A, T]:='f';

  Text := 'Leveleditor';
  X1 := 20-Brd-1;
  Y1 := 81-Bbx-Brd-3;
  X2 := 20-Brd-1+(20*XFld)+Brd+6;
  Y2 := (99-Brd-Bbx)+3+(20*YFld)+Brd;
  WIN;

 For T:=1 to YFld do
  For A:=1 to XFld do
    begin;
     x:=A*20;
     y:=60+T*20;
     FLOOR;
    end;

  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=80;
  MAUER;
  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=120;
  KISTE;
  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=160;
  ZIEL;
  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=200;
  CAR;
  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=240;
  FLOOR;

  SetColor (LightBlue);
  Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 75, 20-Brd-1+(20*XFld)+Brd+6+45, 106);
  Posi:= 1;
  Liv := 'm';

  Posi:=1;
  WoX:=1;
  WoY:=1;
  X:=X1+Brd+1+20*WoX-20;
  Y:=Y1+Brd+Bbx+2+20*WoY-20;
  FADEN;
 end;

{-----------------------------------------------}

 Begin;
  1:
  repeat;
   Ch:=UpCase(ReadKey);
  until Ch<>'';

  if Ch = #13 then
   begin;
    if Liv='m' then
     begin;
      X:=X1+Brd+1+20*WoX-20;
      Y:=Y1+Brd+Bbx+2+20*WoY-20;
      FadenMauer;
      Zulu [Wox, WoY] := 'm';
     end;

    if Liv='c' then
     begin;
      X:=X1+Brd+1+20*WoX-20;
      Y:=Y1+Brd+Bbx+2+20*WoY-20;
      FadenCar;
      Zulu [Wox, WoY] := 'c';
     end;

    if Liv='f' then
     begin;
      X:=X1+Brd+1+20*WoX-20;
      Y:=Y1+Brd+Bbx+2+20*WoY-20;
      Faden;
      Zulu [Wox, WoY] := 'f';
     end;

    if Liv='k' then
     begin;
      X:=X1+Brd+1+20*WoX-20;
      Y:=Y1+Brd+Bbx+2+20*WoY-20;
      FadenKiste;
      Zulu [Wox, WoY] := 'k';
     end;

    if Liv='z' then
     begin;
      X:=X1+Brd+1+20*WoX-20;
      Y:=Y1+Brd+Bbx+2+20*WoY-20;
      FadenZiel;
      Zulu [Wox, WoY] := 'z';
     end;
   end;

  if Ch = Esc then Goto 8;


  if Ch = #9 then
   begin;
    if Posi = 1 then
     begin;
      SetColor (Black);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 75, 20-Brd-1+(20*XFld)+Brd+6+45, 106);
      SetColor (LightBlue);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 115, 20-Brd-1+(20*XFld)+Brd+6+45, 146);
      Posi:= 2;
      Liv := 'k';
      goto 4;
     end;

    if Posi = 2 then
     begin;
      SetColor (Black);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 115, 20-Brd-1+(20*XFld)+Brd+6+45, 146);
      SetColor (LightBlue);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 155, 20-Brd-1+(20*XFld)+Brd+6+45, 186);
      Posi:= 3;
      Liv := 'z';
      goto 4;
     end;

    if Posi = 3 then
     begin;
      SetColor (Black);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 155, 20-Brd-1+(20*XFld)+Brd+6+45, 186);
      SetColor (LightBlue);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 195, 20-Brd-1+(20*XFld)+Brd+6+45, 226);
      Posi:= 4;
      Liv := 'c';
      goto 4;
     end;

    if Posi = 4 then
     begin;
      SetColor (Black);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 195, 20-Brd-1+(20*XFld)+Brd+6+45, 226);
      SetColor (LightBlue);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 235, 20-Brd-1+(20*XFld)+Brd+6+45, 266);
      Posi:= 5;
      Liv := 'f';
      goto 4;
     end;

    if Posi = 5 then
     begin;
      SetColor (Black);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 235, 20-Brd-1+(20*XFld)+Brd+6+45, 266);
      SetColor (LightBlue);
      Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 75, 20-Brd-1+(20*XFld)+Brd+6+45, 106);
      Posi:= 1;
      Liv := 'm';
     end;
    4:
   end;


  if Ch=#0 then Ch:=ReadKey;
  if Ch = Rig then
    begin;
     if WoX+1 > XFld then
      begin;
       Sound (3000);
       delay (50);
       NoSound;
       NoMOVE:=0;
      end
      else
      begin;
       X:=X1+Brd+1+20*WoX;
       Y:=Y1+Brd+Bbx+2+20*WoY-20;
       if Zulu[WoX+1,WoY]='m' then FADENMAUER;
       if Zulu[WoX+1,WoY]='k' then FADENKISTE;
       if Zulu[WoX+1,WoY]='f' then FADEN;
       if Zulu[WoX+1,WoY]='c' then FADENCAR;
       if Zulu[WoX+1,WoY]='z' then FADENZIEL;

       X:=X1+Brd+1+20*WoX-20;
       Y:=Y1+Brd+Bbx+2+20*WoY-20;
       if Zulu[WoX,WoY]='m' then MAUER;
       if Zulu[WoX,WoY]='k' then KISTE;
       if Zulu[WoX,WoY]='f' then FLOOR;
       if Zulu[WoX,WoY]='c' then CAR;
       if Zulu[WoX,WoY]='z' then ZIEL;
       WoX:=WoX+1;
      end;
    end;

  if Ch = Lft then
    begin;
     if WoX-1 < 1 then
      begin;
       Sound (3000);
       delay (50);
       NoSound;
       NoMOVE:=0;
      end
      else
      begin;
       X:=X1+Brd+1+20*WoX-40;
       Y:=Y1+Brd+Bbx+2+20*WoY-20;
       if Zulu[WoX-1,WoY]='m' then FADENMAUER;
       if Zulu[WoX-1,WoY]='k' then FADENKISTE;
       if Zulu[WoX-1,WoY]='f' then FADEN;
       if Zulu[WoX-1,WoY]='c' then FADENCAR;
       if Zulu[WoX-1,WoY]='z' then FADENZIEL;

       X:=X1+Brd+1+20*WoX-20;
       Y:=Y1+Brd+Bbx+2+20*WoY-20;
       if Zulu[WoX,WoY]='m' then MAUER;
       if Zulu[WoX,WoY]='k' then KISTE;
       if Zulu[WoX,WoY]='f' then FLOOR;
       if Zulu[WoX,WoY]='c' then CAR;
       if Zulu[WoX,WoY]='z' then ZIEL;
       WoX:=WoX-1;
      end;
    end;

  if Ch = Up then
    begin;
     if WoY-1 < 1 then
      begin;
       Sound (3000);
       delay (50);
       NoSound;
       NoMOVE:=0;
      end
      else
      begin;
       X:=X1+Brd+1+20*WoX-20;
       Y:=Y1+Brd+Bbx+2+20*WoY-40;
       if Zulu[WoX,WoY-1]='m' then FADENMAUER;
       if Zulu[WoX,WoY-1]='k' then FADENKISTE;
       if Zulu[WoX,WoY-1]='f' then FADEN;
       if Zulu[WoX,WoY-1]='c' then FADENCAR;
       if Zulu[WoX,WoY-1]='z' then FADENZIEL;

       X:=X1+Brd+1+20*WoX-20;
       Y:=Y1+Brd+Bbx+2+20*WoY-20;
       if Zulu[WoX,WoY]='m' then MAUER;
       if Zulu[WoX,WoY]='k' then KISTE;
       if Zulu[WoX,WoY]='f' then FLOOR;
       if Zulu[WoX,WoY]='c' then CAR;
       if Zulu[WoX,WoY]='z' then ZIEL;
       WoY:=WoY-1;
      end;
    end;

  if Ch = Dwn then
    begin;
     if WoY+1 > YFld then
      begin;
       Sound (3000);
       delay (50);
       NoSound;
       NoMOVE:=0;
      end
      else
      begin;
       X:=X1+Brd+1+20*WoX-20;
       Y:=Y1+Brd+Bbx+2+20*WoY;
       if Zulu[WoX,WoY+1]='m' then FADENMAUER;
       if Zulu[WoX,WoY+1]='k' then FADENKISTE;
       if Zulu[WoX,WoY+1]='f' then FADEN;
       if Zulu[WoX,WoY+1]='c' then FADENCAR;
       if Zulu[WoX,WoY+1]='z' then FADENZIEL;

       X:=X1+Brd+1+20*WoX-20;
       Y:=Y1+Brd+Bbx+2+20*WoY-20;
       if Zulu[WoX,WoY]='m' then MAUER;
       if Zulu[WoX,WoY]='k' then KISTE;
       if Zulu[WoX,WoY]='f' then FLOOR;
       if Zulu[WoX,WoY]='c' then CAR;
       if Zulu[WoX,WoY]='z' then ZIEL;
       WoY:=WoY+1;
      end;
    end;
  end;

 IF Ch = F03 then
  begin;
   For T:=1 to YFld do
    For A:=1 to XFld do Zulu[A, T]:='f';

   For T:=1 to YFld do
    For A:=1 to XFld do
     begin;
      x:=A*20;
      y:=60+T*20;
      FLOOR;
     end;

   X:=X1+Brd+1+20*WoX-20;
   Y:=Y1+Brd+Bbx+2+20*WoY-20;
   FADEN;
  end;

 if Ch = F01 then
  begin;
   ClearDevice;
   SetFillStyle (6, 1);
   Bar (0, 0, 640, 480);
   Text := 'Save Level';
   X1 := 100;
   Y1 := 190;
   X2 := 540;
   Y2 := 310;
   WIN;

   xZiel:=0;
   xKiste:=0;
   xCar:=0;
   For T:=1 to YFld do
    begin;
     For A:=1 to XFld do
      begin;
       if Zulu[A,T]= 'z' then xZiel := xZiel+1;
       if Zulu[A,T]= 'k' then xKiste := xKiste+1;
       if Zulu[A,T]= 'c' then xCar := xCar+1;
      end;
    end;

  SetColor (Black);
  if xZiel <> xKiste then
   begin;
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+14,  'FATAL ERROR...');
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+34, 'boxes <> finishes in this level !!!');
    repeat
     Ch := ReadKey;
    Until Ch <> '';
    Goto 15;
   end;

  if xCar <>1 then
   begin;
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+14,  'FATAL ERROR...');
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+34, 'There are more than 1,');
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+54, 'or there is no car in this level !!!');
    repeat
     Ch := ReadKey;
    Until Ch <> '';
    Goto 15;
   end;

  if xZiel <1 then
   begin;
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+14,  'FATAL ERROR...');
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+34, 'There are no finishes in this level !!!');
    repeat
     Ch := ReadKey;
    Until Ch <> '';
    Goto 15;
   end;

   SetColor (Black);
   OutTextXY (X1+Brd+10, Y1+Brd+Bbx+34, 'Filename of this level?       :');
   OutTextXY (X1+Brd+10, Y1+Brd+Bbx+54, 'Which level start after this? :');

   SetColor (Blue);
   OutTextXY (X1+Brd+10, Y1+Brd+Bbx+14, 'Levelname                     :');
   SetFillStyle (1, Nrm);
   SetColor (Black);
   LName := '';
   FName := '';
   AName := '';
   Posi:=0;
   T:=0;

   3:
   repeat
    ch:=ReadKey
   until Ch <> '';

   if Ch= Chr(13) then T:=1;
   if Ch= Chr(27) then
    begin;
     Goto 5;
    end;

   if Ch= Chr(8) then
    begin;
     Posi:=Posi-1;
     if Posi < 0 then Posi := 0;
     Bar(X1+Brd+260+Posi*8+8, Y1+Brd+Bbx+14, X1+Brd+260+Posi*8+16, Y1+Brd+Bbx+24);
     Lang := Length (LName);
     Delete (LName, Lang, 1);
     T:=2;
    end;

   if T=2 then
    begin;
     T:=0;
     Goto 3;
    end;

   if T=0 then
    begin;
     Posi:=Posi+1;
     if Posi > 10 then
      begin;
       Posi := 10;
       Bar(X1+Brd+260+Posi*8, Y1+Brd+Bbx+14, X1+Brd+260+Posi*8+8, Y1+Brd+Bbx+24);
       OutTextXY (X1+Brd+260+Posi*8, Y1+Brd+Bbx+14, Ch);
       Lang := Length (LName);
       Delete (LName, Lang, 1);
       LName := Concat (LName, Ch);
       Goto 3;
      end
     else
      begin;
       OutTextXY (X1+Brd+260+Posi*8, Y1+Brd+Bbx+14, Ch);
       LName := Concat (LName, Ch);
       Goto 3;
      end;
    end;

    if LName = '' then LName := '?';
    SetColor (DarkGray);
    OutTextXY (X1+Brd+268, Y1+Brd+Bbx+14, LName);
    SetColor (Blue);
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+34, 'Filename of this level?       :');
    SetColor (Black);
    OutTextXY (X1+Brd+260, Y1+Brd+Bbx+34, '         .DAT');


{-----------------------------------------------}

   Posi:=0;
   T:=0;
   6:
   repeat
    ch:=UpCase(ReadKey);
   until Ch <> '';

   if Ch= Chr(13) then T:=1;
   if Ch= Chr(27) then
    begin;
     Goto 6;
    end;
   if Ch= Chr(8) then
    begin;
     Posi:=Posi-1;
     if Posi < 0 then Posi := 0;
     Bar(X1+Brd+260+Posi*8+8, Y1+Brd+Bbx+34, X1+Brd+260+Posi*8+16, Y1+Brd+Bbx+44);
     Lang := Length (FName);
     Delete (FName, Lang, 1);
     T:=2;
    end;

   if T=2 then
    begin;
     T:=0;
     Goto 6;
    end;

   if T=0 then
    begin;
     Posi:=Posi+1;
     if Posi > 8 then
      begin;
       Posi := 8;
       Bar(X1+Brd+260+Posi*8, Y1+Brd+Bbx+34, X1+Brd+260+Posi*8+8, Y1+Brd+Bbx+44);
       OutTextXY (X1+Brd+260+Posi*8, Y1+Brd+Bbx+34, Ch);
       Lang := Length (FName);
       Delete (FName, Lang, 1);
       FName := Concat (FName, Ch);
       Goto 6;
      end
     else
      begin;
       OutTextXY (X1+Brd+260+Posi*8, Y1+Brd+Bbx+34, Ch);
       FName := Concat (FName, Ch);
       Goto 6;
      end;
    end;

    if FName = '' then FName := '?';
    SetColor (DarkGray);
    OutTextXY (X1+Brd+268, Y1+Brd+Bbx+34, FName);
    OutTextXY (X1+Brd+260, Y1+Brd+Bbx+34, '         .DAT');
    SetColor (Blue);
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+54, 'Which level start after this? :');
    SetColor (Black);
    OutTextXY (X1+Brd+260, Y1+Brd+Bbx+54, '         .DAT');
    OutTextXY (X1+Brd+10, Y1+Brd+Bbx+74, 'When no level press ENTER...');
    SetColor (Black);


{-----------------------------------------------}

   Posi:=0;
   T:=0;
   7:
   repeat
    ch:=UpCase(ReadKey);
   until Ch <> '';

   if Ch= Chr(13) then T:=1;
   if Ch= Chr(27) then
    begin;
     Goto 7;
    end;
   if Ch= Chr(8) then
    begin;
     Posi:=Posi-1;
     if Posi < 0 then Posi := 0;
     Bar(X1+Brd+260+Posi*8+8, Y1+Brd+Bbx+54, X1+Brd+260+Posi*8+16, Y1+Brd+Bbx+64);
     Lang := Length (AName);
     Delete (AName, Lang, 1);
     T:=2;
    end;

   if T=2 then
    begin;
     T:=0;
     Goto 7;
    end;

   if T=0 then
    begin;
     Posi:=Posi+1;
     if Posi > 8 then
      begin;
       Posi := 8;
       Bar(X1+Brd+260+Posi*8, Y1+Brd+Bbx+54, X1+Brd+260+Posi*8+8, Y1+Brd+Bbx+64);
       OutTextXY (X1+Brd+260+Posi*8, Y1+Brd+Bbx+54, Ch);
       Lang := Length (AName);
       Delete (AName, Lang, 1);
       AName := Concat (AName, Ch);
       Goto 7;
      end
     else
      begin;
       OutTextXY (X1+Brd+260+Posi*8, Y1+Brd+Bbx+54, Ch);
       AName := Concat (AName, Ch);
       Goto 7;
      end;
    end;

    if AName = '' then AName := 'end';
    SetColor (DarkGray);
    OutTextXY (X1+Brd+268, Y1+Brd+Bbx+54, AName);
    OutTextXY (X1+Brd+260, Y1+Brd+Bbx+54, '        .DAT');


 if FName = '?' then Goto 9;
 FName := Concat (FName, '.DAT');

 Assign (f,FName);
 {$I-}
 Rewrite (f);
 {$I+}
 if IOResult <> 0 then
  Begin;
   ClearDevice;
   CloseGraph;
   ClrScr;
   WriteLn ('FATAL ERROR ... ');
   WriteLn ('Could not make Level file !!!');
   repeat
    Ch := ReadKey;
   until Ch<>'';
   EXIT;
  End;

 WriteLn (f, LName);
 Str (XFld, Xdim);
 Str (YFld, Ydim);
 WriteLn (f, XDim);
 WriteLn (f, YDim);

 For T:=1 to YFld do
  begin;
   For A:=1 to XFld-1 do Write (f, Zulu [A, T]);
   WriteLn (f, Zulu [A+1, T]);
  end;

 if AName <> 'end' then AName := Concat (AName,'.DAT');
 Write (f, AName);
 Close (f);


   9:
   NoWIN;
   Goto 8;
  end;
 Goto 1;

 15:
 Begin;
  SetFillStyle (1, 0);
  Bar (0, 0, 640, 480);

  Text:= 'H U M P  1.0  b y  C I R E `95';
  X1 := 0;
  Y1 := 0;
  X2 := GetMaxX;
  Y2 := 2*Bbx+2*Brd+2;
  WIN;
  SetColor (Blue);
  OutTextXY (X1+Brd+10, Y1+Brd+Bbx+6, '   Speichern          Exit');
  SetColor (Black);
  OutTextXY (X1+Brd+10, Y1+Brd+Bbx+6, 'F1                Esc');

  Text := 'Leveleditor';
  X1 := 20-Brd-1;
  Y1 := 81-Bbx-Brd-3;
  X2 := 20-Brd-1+(20*XFld)+Brd+6;
  Y2 := (99-Brd-Bbx)+3+(20*YFld)+Brd;
  WIN;

  For T:=1 to YFld do
  For A:=1 to XFld do
    begin;
     x:=A*20;
     y:=60+T*20;
     Field := Zulu [A,T];
     if Field ='m' then MAUER;
     if Field ='f' then FLOOR;
     if Field ='k' then KISTE;
     if Field ='z' then ZIEL;
     if Field ='c' then CAR;
    end;

  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=80;
  MAUER;
  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=120;
  KISTE;
  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=160;
  ZIEL;
  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=200;
  CAR;
  X:= 20-Brd-1+(20*XFld)+Brd+6+20;
  Y:=240;
  FLOOR;

  SetColor (LightBlue);
  Rectangle (20-Brd-1+(20*XFld)+Brd+6+17, 75, 20-Brd-1+(20*XFld)+Brd+6+45, 106);
  Posi:= 1;
  Liv := 'm';

  Posi:=1;
  WoX:=1;
  WoY:=1;
  X:=X1+Brd+1+20*WoX-20;
  Y:=Y1+Brd+Bbx+2+20*WoY-20;
  if Zulu [WoX,WoY] = 'm' then FADENMAUER;
  if Zulu [WoX,WoY] = 'f' then FADEN;
  if Zulu [WoX,WoY] = 'z' then FADENZIEL;
  if Zulu [WoX,WoY] = 'c' then FADENCAR;
  if Zulu [WoX,WoY] = 'k' then FADENKISTE;

  Goto 1;
 End;
END.