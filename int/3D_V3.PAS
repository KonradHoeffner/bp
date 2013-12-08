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

PROGRAM 3D_V3;

USES CRT, GRAPHBO, GRAPH, BITFONT;

CONST
    PolyCnt = 289;
    Step    = 5;
    C       = 524;

    black   = false;
    default = true;
    Up      = #72;
    Dwn     = #80;
    Rig     = #77;
    Lft     = #75;
    Pup     = #73;
    Pdn     = #81;
    Esc     = #27;


TYPE
    Pointer3D  = ^DATA3D;
    Pointer2D  = ^DATA2D;
    PointerCol = ^WORD;

    DATA3D     = record
                 X,Y,Z : INTEGER;
                 end;

    DATA2D     = record
                 X,Y   : REAL;
                 end;

    WINKEL3D   = record
                 Roll,
                 Kipp,
                 Dreh  : REAL;
                 end;

    VECTOR3D   = record
                 X,Y,Z : REAL;
                 end;

VAR MitteX,MitteY,T,
    V,H,PolyCnt2D     : WORD;
    ActivePage        : BYTE;
    Ch                : CHAR;
    Standort,
    Bewegung,
    OldStdOrt         : VECTOR3D;
    Winkel            : WINKEL3D;
    Text              : STRING;
    POLY              : array [1..5, 1..2]       of INTEGER;
    D3D               : array [1..PolyCnt, 1..4] of POINTER3D;
    Old2D,D2D         : array [1..PolyCnt, 1..4] of POINTER2D;
    COLOR             : array [1..PolyCnt]       of POINTERCOL;

{****************************************************************************}
PROCEDURE DREH(X,Y,Fi : Real; VAR XRes,YRes : INTEGER);
CONST Pic = 180 / Pi;
VAR   R   : Real;
BEGIN
 R    :=  SQRT(SQR(X)+SQR(Y));
 if (Y<>0) then Fi :=  270 + Fi + (ArcTan(X/Y))*Pic
           else if X<0 then Fi :=  Fi + 180;

 XRes := Round (R*Cos(Fi/Pic));
 YRes := Round (R*Sin(Fi/Pic));
END;

{****************************************************************************}
PROCEDURE DRAW2D (COL : BOOLEAN);
VAR G,P,Cal : WORD;
BEGIN
  Str (PolyCnt2d,Text);
  OutFont(0,0 ,3,0,'berechnete Polygone.'+Text+'  ');
  Str (Round(Standort.X),Text);
  OutFont(0,10,9,0,'Standort x         .'+Text+'    ');
  Str (Round(Standort.Y),Text);
  OutFont(0,20,9,0,'         y         .'+Text+'    ');
  Str (Round(Standort.Z),Text);
  OutFont(0,30,9,0,'         z         .'+Text+'    ');

  if PolyCnt2D > 0 then
  For G:=1 to PolyCnt2D do
      Begin
      If Col=true Then
          For P:=1 to 4 do
          Begin
          if P=1 then
                 begin
                 POLY[1,1] := Round (D2D[G,P]^.X);
                 POLY[1,2] := Round (D2D[G,P]^.Y);
                 POLY[5,1] := Round (D2D[G,P]^.X);
                 POLY[5,2] := Round (D2D[G,P]^.Y);
                 end
            else begin
                 POLY[P,1] := Round (D2D[G,P]^.X);
                 POLY[P,2] := Round (D2D[G,P]^.Y);
                 end;
          End;
      If Col=false then For P:=1 to 4 do
          Begin
          if P=1 then
                 begin
                 POLY[1,1] := Round (Old2D[G,P]^.X);
                 POLY[1,2] := Round (Old2D[G,P]^.Y);
                 POLY[5,1] := Round (Old2D[G,P]^.X);
                 POLY[5,2] := Round (Old2D[G,P]^.Y);
                 end
            else begin
                 POLY[P,1] := Round (Old2D[G,P]^.X);
                 POLY[P,2] := Round (Old2D[G,P]^.Y);
                 end;
          Old2D[G,P]^.X := D2D[G,P]^.X;
          Old2D[G,P]^.Y := D2D[G,P]^.Y;
          End;

      if Col=black then SetfillStyle(1,0)
                   else if D3D[G,2]^.Z <> 0 then
                        begin
                        Cal := Round (((COLOR[G]^/100)-Int(COLOR[G]^/100))*100);
                        Cal := Round (Cal / (D3D[G,2]^.Z/50));
                        if Cal <= 2 then Cal := 0;
                        Cal := Round (Cal + (((COLOR[G]^/100)-Frac(COLOR[G]^/100))*100));
                        SetfillStyle(1,Cal);
                        end;

      SetColor(0);
      FillPOLY (SizeOF(POLY) div SizeOF(PointTYPE), POLY);
      End;
END;

{****************************************************************************}
PROCEDURE CHANGE3D;
VAR G,P : WORD;
    OK  : Boolean;
BEGIN
  DRAW2D (black);
  PolyCnt2D := 0;
  OK := true;

  For G:=1 to PolyCnt do
  Begin
    if (D3D [G,1]^.Z > 0) and
       (D3D [G,2]^.Z > 0) and
       (D3D [G,3]^.Z > 0) and
       (D3D [G,4]^.Z > 0) then
       Begin
       PolyCnt2D := PolyCnt2D + 1;
       For P:=1 to 4 do
           Begin
           if D3D [G,P]^.X < MitteX
           then D2D [PolyCnt2D,P]^.X := (MitteX - ((0-D3D[G,P]^.X) / (D3D[G,P]^.Z/C)))
           else D2D [PolyCnt2D,P]^.X := (MitteX + ( D3D[G,P]^.X    / (D3D[G,P]^.Z/C)));

           if D3D [G,P]^.Y < MitteY
           then D2D [PolyCnt2D,P]^.Y := (MitteY + ((0-D3D[G,P]^.Y) / (D3D[G,P]^.Z/C)))
           else D2D [PolyCnt2D,P]^.Y := (MitteY - ( D3D[G,P]^.Y    / (D3D[G,P]^.Z/C)));
           End;
       End;
  End;

  Setcolor(0);
  if PolyCnt2D > 0 then
     begin
     DRAW2D (default);
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
     end;
END;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}
BEGIN
 INIS256 (3, 'D:\INFO\TP7\BGI');
 MitteX := GetMaxX div 2;
 MitteY := GetMaxY div 2;

 For V:=1 to PolyCnt do
 begin
 For H:=1 to 4       do
     begin
     New( D3D   [V,H] );
     New( D2D   [V,H] );
     New( Old2D [V,H] );

     D2D   [V,H]^.X := 0;
     D2D   [V,H]^.Y := 0;
     Old2D [V,H]^.X := 0;
     Old2D [V,H]^.Y := 0;
     end;
 New(COLOR[V]);
 if ActivePage=0 then begin
                      COLOR[V]^:= 163;
                      ActivePage := 1;
                      end
                 else begin
                      COLOR[V]^:= 123;
                      ActivePage := 0;
                      end;
 end;

 For T:=100 to 163 do SetRGBPalette (T,Round((T-100) * 1.0),
                                       Round((T-100) * 1.0),
                                       Round((T-100) * 0.5));

 ActivePage:=0;
 SetActivePage(0);
 SetVisualPage(1);

 OldStdOrt.X := 1;

 T:=0;
 FOR V:=1 to 17 do
 FOR H:=1 to 17 do
     Begin
     T:=T+1;
     D3D [T,1]^.X := (10*H) - 95;
     D3D [T,1]^.Y := -35;
     D3D [T,1]^.Z := 310 - (10*V);
     D3D [T,2]^.X := (10*H) - 95;
     D3D [T,2]^.Y := -35;
     D3D [T,2]^.Z := 300 - (10*V);
     D3D [T,3]^.X := (10*H) - 85;
     D3D [T,3]^.Y := -35;
     D3D [T,3]^.Z := 300 - (10*V);
     D3D [T,4]^.X := (10*H) - 85;
     D3D [T,4]^.Y := -35;
     D3D [T,4]^.Z := 310 - (10*V);
     End;

 REPEAT
 T:=0;
 FOR V:=1 to 17 do
 FOR H:=1 to 17 do
     Begin
     T:=T+1;
    {DREH (D3D[T,1]^.X,D3D[T,1]^.Y,Winkel.Kipp,D3D[T,1]^.X,D3D[T,1]^.Y);
     DREH (D3D[T,2]^.X,D3D[T,2]^.Y,Winkel.Kipp,D3D[T,2]^.X,D3D[T,2]^.Y);
     DREH (D3D[T,3]^.X,D3D[T,3]^.Y,Winkel.Kipp,D3D[T,3]^.X,D3D[T,3]^.Y);
     DREH (D3D[T,4]^.X,D3D[T,4]^.Y,Winkel.Kipp,D3D[T,4]^.X,D3D[T,4]^.Y);}

     D3D [T,1]^.X := D3D [T,1]^.X + Round (Bewegung.X);
     D3D [T,1]^.Y := D3D [T,1]^.Y + Round (Bewegung.Y);
     D3D [T,1]^.Z := D3D [T,1]^.Z + Round (Bewegung.Z);

     D3D [T,2]^.X := D3D [T,2]^.X + Round (Bewegung.X);
     D3D [T,2]^.Y := D3D [T,2]^.Y + Round (Bewegung.Y);
     D3D [T,2]^.Z := D3D [T,2]^.Z + Round (Bewegung.Z);

     D3D [T,3]^.X := D3D [T,3]^.X + Round (Bewegung.X);
     D3D [T,3]^.Y := D3D [T,3]^.Y + Round (Bewegung.Y);
     D3D [T,3]^.Z := D3D [T,3]^.Z + Round (Bewegung.Z);

     D3D [T,4]^.X := D3D [T,4]^.X + Round (Bewegung.X);
     D3D [T,4]^.Y := D3D [T,4]^.Y + Round (Bewegung.Y);
     D3D [T,4]^.Z := D3D [T,4]^.Z + Round (Bewegung.Z);
     End;


 if (OldStdOrt.X <> Standort.X) or
    (OldStdOrt.Y <> Standort.Y) or
    (OldStdOrt.Z <> Standort.Z) then
    begin
    CHANGE3D;
    OldStdOrt.X := Standort.X;
    OldStdOrt.Y := Standort.Y;
    OldStdOrt.Z := Standort.Z;
    end;

    Bewegung.X := 0;
    Bewegung.Y := 0;
    Bewegung.Z := 0;

 if Keypressed then
    BEGIN
    Ch := ReadKey;
    if Ch=Rig then Bewegung.X := + Step;
    if Ch=Lft then Bewegung.X := - Step;
    if Ch=Pup then Bewegung.Y := + Step;
    if Ch=Pdn then Bewegung.Y := - Step;
    if Ch=Up  then Bewegung.Z := + Step;
    if Ch=Dwn then Bewegung.Z := - Step;

    Standort.X := Standort.X + Bewegung.X;
    Standort.Y := Standort.Y + Bewegung.Y;
    Standort.Z := Standort.Z + Bewegung.Z;
    END;

 UNTIL Ch = Esc;

 CloseGraph;

END.