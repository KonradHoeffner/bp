{$N+,E+}
{
 ----------------------------------------------------
 Dieses Programm wurde von Eric Esins programmiert...
 ----------------------------------------------------
 Wer es in irgendeiner Weise benutzen m”chte, hat die
 Erlaubnis dazu, wenn er meinen Namen erw„hnt.
 Danke...

 Die Unit Mouse ist nicht von mir.

}

PROGRAM Engine3D;

USES CRT, GRAPHBO, GRAPH;

CONST
    C       = 524;
    Up      = #72;
    Dwn     = #80;
    Rig     = #77;
    Lft     = #75;
    Esc     = #27;
    PolyCnt = 256;

TYPE
    DATA3D    = record
                X,Y,Z : REAL;
                end;

    WINKEL3D    = record
                Roll,
                Kipp,
                Dreh  : REAL;
                end;

    DATA2D    = record
                X,Y   : REAL;
                end;

    VECTOR3D  = record
                X,Y,Z : REAL;
                end;

VAR Vektor          : VECTOR3D;
    MitteX,MitteY,T : WORD;
    Mx,My,OMx,OMy,
    V,H,N,
    ActivePage      : BYTE;
    P               : REAL;
    Move            : INTEGER;
    POLY            : array [1..5, 1..2] of INTEGER;
    SDATA           : array [1..PolyCnt, 1..4] of DATA3D;
    Old2D,DATA_2D   : array [1..PolyCnt, 1..4] of DATA2D;
    Welle           : array [1..17, 1..17] of Real;
    CH              : CHAR;

{****************************************************************************}
PROCEDURE DRAW2D (INF,SUP,COL : WORD);
VAR G,P       : WORD;
    NCol,NCal : REAL;
BEGIN
  if (INF>0) and (SUP <(PolyCnt+1)) then
  For G:=INF to SUP do
      Begin

      If Col>0 Then
          For P:=1 to 4 do
          Begin
          if P=1 then
                 begin
                 POLY[1,1] := Round (DATA_2D[G,P].X);
                 POLY[1,2] := Round (DATA_2D[G,P].Y);
                 POLY[5,1] := Round (DATA_2D[G,P].X);
                 POLY[5,2] := Round (DATA_2D[G,P].Y);
                 end
            else begin
                 POLY[P,1] := Round (DATA_2D[G,P].X);
                 POLY[P,2] := Round (DATA_2D[G,P].Y);
                 end;
          End;
      If Col=0 then For P:=1 to 4 do
          Begin
          if P=1 then
                 begin
                 POLY[1,1] := Round (Old2D[G,P].X);
                 POLY[1,2] := Round (Old2D[G,P].Y);
                 POLY[5,1] := Round (Old2D[G,P].X);
                 POLY[5,2] := Round (Old2D[G,P].Y);
                 end
            else begin
                 POLY[P,1] := Round (Old2D[G,P].X);
                 POLY[P,2] := Round (Old2D[G,P].Y);
                 end;
          Old2D[G,P].X := DATA_2D[G,P].X;
          Old2D[G,P].Y := DATA_2D[G,P].Y;
          End;


     if Col<>0 then
                begin
                NCol := (SDATA[G,1].Y * SDATA[G,4].Y) / 2;
                NCol := NCol/((SDATA[G,2].Y * SDATA[G,3].Y) / 2);

                NCal := (SDATA[G,1].Y * SDATA[G,2].Y) / 2;
                NCal := NCal/((SDATA[G,3].Y * SDATA[G,4].Y) / 2);

                NCol := 50+(NCol*40)+(NCal*40);


                end
                else NCol := 0;


      SetfillStyle(1,Round(NCol));
      Setcolor(0);

      FillPOLY (SizeOF(POLY) div SizeOF(PointTYPE), POLY);
      End;
END;

{****************************************************************************}
PROCEDURE D3DTO2D (INF,SUP,COL : WORD);
VAR G,P : WORD;
BEGIN
  DRAW2D (1,PolyCnt,0);

  if (INF>0) and (SUP <(PolyCnt+1)) then
  For G:=INF to SUP do
  Begin
    For P:=1 to 4 do
    if SDATA [G,P].Z > 0 then
    Begin

      if SDATA [G,P].X < MitteX then
           DATA_2D [G,P].X := (MitteX - ((0-SDATA[G,P].X) / (SDATA[G,P].Z/C)))
      else DATA_2D [G,P].X := (MitteX + ( SDATA[G,P].X    / (SDATA[G,P].Z/C)));

      if SDATA [G,P].Y < MitteY then
           DATA_2D [G,P].Y := (MitteY + ((0-SDATA[G,P].Y) / (SDATA[G,P].Z/C)))
      else DATA_2D [G,P].Y := (MitteY - ( SDATA[G,P].Y    / (SDATA[G,P].Z/C)));
    End;
  End;

  DRAW2D (1,PolyCnt,Col);

  if ActivePage=0 then begin
                       SetActivePage(1);
                       SetVisualPage(0);
                       ActivePage:=1;
                       end
                  else begin
                       SetActivePage(0);
                       SetVisualPage(1);
                       ActivePage:=0;
                       end;
  Delay(7);
END;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}
BEGIN
 Randomize;
 INIS256 (1, 'D:\INFO\TP7\BGI');
 MitteX := GetMaxX div 2;
 MitteY := GetMaxY div 2;

 For T:=100 to 163 do SetRGBPalette (T,Round((T-100)*0.8),Round((T-100)*0.8),Round((T-100)*1));

 ActivePage:=0;
 SetActivePage(0);
 SetVisualPage(1);

 REPEAT
 if P<=(2*Pi-0.1) then P:=P+0.1
                  else P:=0;

 FOR V:=1 to 17 do
 FOR H:=1 to 17 do Welle [H,V] := (Sin((V/2)+p)*3)+(Sin((H/2)+P)*4);

 T:=0;
 FOR V:=1 to 16 do
 FOR H:=1 to 16 do
     Begin
     T:=T+1;
     SDATA [T,1].X := (10*H - 90 + Vektor.X);
     SDATA [T,1].Y := (Welle [H,V] - 35);
     SDATA [T,1].Z := (310 - (10*V) + Vektor.Z);

     SDATA [T,2].X := (10*H - 90 + Vektor.X);
     SDATA [T,2].Y := (Welle [H,V+1] - 35);
     SDATA [T,2].Z := (300 - (10*V) + Vektor.Z);

     SDATA [T,3].X := (10*H - 80 + Vektor.X);
     SDATA [T,3].Y := (Welle [H+1,V+1] - 35);
     SDATA [T,3].Z := (300 - (10*V) + Vektor.Z);

     SDATA [T,4].X := (10*H - 80 + Vektor.X);
     SDATA [T,4].Y := (Welle [H+1,V]- 35);
     SDATA [T,4].Z := (310 - (10*V) + Vektor.Z);
     End;

  if Keypressed then
  begin
  Ch := ReadKey;

  if (Ch=Up) or (Ch=Dwn) then
           begin
           if CH=Up  then Move :=  10;
           if CH=Dwn then Move := -10;
           Vektor.Z := Vektor.Z+Move;
           end;

  if (CH=Rig) or (CH=Lft) then
           begin
           if CH=Rig then Move :=  10;
           if CH=Lft then Move := -10;
           Vektor.X := Vektor.X+Move;
           end;
  end;
 D3DTO2D (1,PolyCnt,7);

 UNTIL Ch = Esc;

 CloseGraph;

END.