{$A+,B-,D-,E-,F-,G-,I-,L-,N-,O-,R-,S-,V-,X-}
(*===================================================================*)
(*                             MOUSE.PAS                             *)
(*            Copyright (C) 1993 te-wi Verlag, MÅnchen               *)
(*    Unit mit den wichtigsten Interface-Routinen zum Maustreiber    *)
(*===================================================================*)
UNIT Mouse;

INTERFACE

USES Graph;

TYPE
  tButton = (None, Left, Right, Middle);        (* Namen der Buttons *)

PROCEDURE InitMouse;            (* Initialisierung der Maus          *)
FUNCTION  ButtonNum: BYTE;      (* Liefert die Anzahl der Mausknîpfe *)
PROCEDURE DisplayCursor;        (* Schaltet den Mauscursor ein       *)
PROCEDURE HideCursor;           (* Schaltet den Mauscursor ab        *)
FUNCTION  WhereX: INTEGER;      (* Liefert die aktuelle X-Koordinate *)
FUNCTION  WhereY: INTEGER;      (* Liefert die aktuelle Y-Koordinate *)
PROCEDURE SetPos(x, y: INTEGER); (* Setzt den Mauscursor nach X/Y    *)
PROCEDURE SetMickeys(x, y: INTEGER); (* Setzen der Mausgeschwindigk. *)
PROCEDURE GetMickeys(VAR x, y: INTEGER); (* Lesen der M.-Geschwind.  *)
FUNCTION  Pressed: tButton;     (* Liefert beliebigen Tastendruck    *)
PROCEDURE LeftXY(VAR x, y: INTEGER); (* Position bei Druck der li-Ta *)
PROCEDURE RightXY(VAR x, y: INTEGER);(* Position bei Druck der re-Ta *)
PROCEDURE MiddleXY(VAR x, y: INTEGER);(*Position bei Druck beider Ta *)
FUNCTION  ButtonUsed(Button: tButton): WORD; (* liefert die Zahl der *)
                (* TastendrÅcke seit dem letzten Aufruf der Funktion *)
FUNCTION  ButtonReleased(Button: tButton): WORD; (* wie oft wurde    *)
       (* seit dem letzten Aufruf der Funktion die Taste losgelassen *)

PROCEDURE GraphCursor(DivX, DivY: WORD; VAR BitMap); (* Softcursor   *)
                                       (* fÅr den Grafikmodus setzen *)
PROCEDURE GetMouseInfo(VAR MouseType, IRQ: BYTE; VAR Version: WORD);
                                (* liefert, welche Maus wo aktiv ist *)
PROCEDURE SetMouseWindow(x1, y1, x2, y2: INTEGER);
     (* setzt die Koordinaten fÅr ein Mausfenster auf dem Bildschirm *)
PROCEDURE GetMouseWindow(VAR x1, y1, x2, y2: INTEGER);
         (* liefert die Daten des akt. Mausfensters auf dem B-schirm *)
FUNCTION  MouseActivated: BOOLEAN; { liefert ob die Maus aktiv ist }
FUNCTION  MouseVisible: BOOLEAN; { liefert ob die Maus sichtbar ist }
PROCEDURE MouseINI;

TYPE
  tCursorShape = ARRAY[0..1] OF ARRAY [1..4] OF ARRAY[1..4] OF WORD;

CONST
ArrowCursor: tCursorShape =
{AND}    ((($3FFF, $1FFF, $0FFF, $07FF),               (* ... und diese *)
           ($03FF, $01FF, $00FF, $007F),               (* implementiert *)
           ($003F, $003F, $01FF, $30FF),               (* softwaremÑ·ig *)
           ($F0FF, $F87F, $FFFF, $FFFF)),              (* einen Pfeil   *)
{XOR}     (($0000, $4000, $6000, $7000),
           ($7800, $7C00, $7E00, $7F00),
           ($7F80, $7C00, $4C00, $0600),
           ($0600, $0000, $0000, $0000)));

StopCursor: tCursorShape =
{AND}    ((($FFFF, $F81F, $E007, $C003),               (* ... und diese *)
           ($C003, $8001, $8001, $8001),               (* implementiert *)
           ($8001, $8001, $8001, $C003),               (* softwaremÑ·ig *)
           ($C003, $E007, $F81F, $FFFF)),              (* einen Pfeil   *)
{XOR}     (($0000, $0000, $03C0, $0FF0),
           ($1E78, $1E78, $3E7C, $3E7C),
           ($3E7C, $3FFC, $1E78, $1E78),
           ($0FF0, $03C0, $0000, $0000)));

HandCursor: tCursorShape =
{AND}    ((($9FFF, $0FFF, $0787, $8203),               (* ... und diese *)
           ($C001, $C001, $E000, $F000),               (* implementiert *)
           ($C000, $8000, $0000, $0000),               (* softwaremÑ·ig *)
           ($8001, $F803, $FE07, $FFFF)),              (* eine Hand   *)
{XOR}     (($0000, $6000, $7000, $3878),
           ($1DFC, $1FFC, $0FFE, $07FE),
           ($07FE, $33FE, $7FFE, $7FFE),
           ($07FC, $01F8, $0000, $0000)));

PaintCursor: tCursorShape =
{AND}    ((($FFFF, $FFFF, $FFFF, $FFFF),               (* ... und diese *)
           ($FF7F, $FF7F, $FF7F, $FEBF),               (* implementiert *)
           ($F1C7, $FEBF, $FF7F, $FF7F),               (* softwaremÑ·ig *)
           ($FF7F, $FFFF, $FFFF, $FFFF)),              (* einen GrafikC.*)
{XOR}     (($0000, $0000, $0000, $0000),
           ($0080, $0080, $0080, $0080),
           ($0F78, $0080, $0080, $0080),
           ($0080, $0000, $0000, $0000)));

IMPLEMENTATION

VAR VisibleStatus,MStatus : Boolean;

CONST
  Buttons: WORD = 0;

FUNCTION MouseActivated;
BEGIN
  MouseActivated := false;
  MouseActivated := MStatus;
END;

FUNCTION MouseVisible;
BEGIN
  MouseVisible := false;
  MouseVisible := VisibleStatus;
END;

PROCEDURE DisplayCursor;
BEGIN
  ASM
  MOV AX, 0001h
  INT 33h
  END;
  VisibleStatus := true;
END;

PROCEDURE HideCursor;
BEGIN
  ASM
  MOV AX, 0002h
  INT 33h
  END;
  VisibleStatus := false;
END;

PROCEDURE InitMouse;
BEGIN
ASM
  XOR  AX, AX                                               { AX := 0 }
  INT  33h                                                  { AX = 0? }
  OR   AX, AX
  JZ   @out
  MOV Buttons, BX
 @out:
END;
  MStatus := true;
END;
FUNCTION ButtonNum: BYTE;
BEGIN
  ButtonNum := Lo(Buttons);
END;

FUNCTION WhereX: INTEGER; ASSEMBLER;
ASM
  MOV AX, 0003h
  INT 33h
  MOV AX, CX
END;

FUNCTION WhereY: INTEGER; ASSEMBLER;
ASM
  MOV AX, 0003h
  INT 33h
  MOV AX, DX;
END;

PROCEDURE SetPos(x, y: INTEGER); ASSEMBLER;
ASM
  MOV  AX, 0004h
  MOV  CX, x
  MOV  DX, y
  INT  33h
END;

FUNCTION Pressed: tButton; ASSEMBLER;
ASM
  MOV AX, 0003h
  INT 33h
  MOV AX, BX
END;

PROCEDURE LeftXY(VAR x, y: INTEGER);
VAR
  xt, yt: INTEGER;
BEGIN
  ASM
    MOV AX, 0005h
    XOR BX, BX
    INT 33h
    MOV xt, CX
    MOV yt, DX
  END;
  x := xt;
  y := yt;
END;

PROCEDURE RightXY(VAR x, y: INTEGER);
VAR
  xt, yt: INTEGER;
BEGIN
  ASM
    MOV AX, 0005h
    MOV BX, 0001h
    INT 33h
    MOV xt, CX
    MOV yt, DX
  END;
  x := xt;
  y := yt;
END;

PROCEDURE MiddleXY(VAR x, y: INTEGER);
VAR
  xt, yt: INTEGER;
BEGIN
  ASM
    MOV AX, 0005h
    MOV BX, 0002h
    INT 33h
    MOV xt, CX
    MOV yt, DX
  END;
  x := xt;
  y := yt;
END;

FUNCTION ButtonUsed(Button: tButton): WORD; ASSEMBLER;
ASM
  MOV AX, 0005h
  XOR BH, BH
  MOV BL, Button
  ADD BL, 0001h
  INT 33h
  MOV AX, BX
END;

FUNCTION ButtonReleased(Button: tButton): WORD; ASSEMBLER;
ASM
  MOV AX, 0006h
  XOR BH, BH
  MOV BL, Button
  ADD BL, 0001h
  INT 33h
  MOV AX, BX
END;

PROCEDURE MoveTo(x, y: WORD); ASSEMBLER;
ASM
  MOV  AX, 0004h
  MOV  CX, x
  MOV  DX, y
  INT  33h
END;

PROCEDURE GetMickeys(VAR x, y: INTEGER);
VAR
  xt, yt: INTEGER;
BEGIN
  ASM
    MOV AX, 001Bh
    INT 33h
    MOV xt, CX
    MOV yt, DX
  END;
  x := xt;
  y := yt;
END;

PROCEDURE SetMickeys(x, y: INTEGER); ASSEMBLER;
ASM
  MOV  AX, 000Fh
  MOV  CX, x
  MOV  DX, y
  INT  33h
END;

PROCEDURE GraphCursor(DivX, DivY: WORD; VAR BitMap);
VAR
  o, s: WORD;
BEGIN
  o := Ofs(BitMap);
  s := Seg(BitMap);
  ASM
    MOV AX, 0009h
    MOV BX, s
    MOV ES, BX
    MOV BX, DivX
    MOV CX, DivY
    MOV DX, o
    INT 33h
  END;
END;

PROCEDURE GetMouseInfo(VAR MouseType, IRQ: BYTE;
                       VAR Version:        WORD);
VAR
 m, i: BYTE;
 v   : WORD;
BEGIN
  ASM
    MOV AX, 0024h
    INT 33h
    MOV v, BX
    mov m, CH                     { 1 = Bus, 2 = seriell, 3 = InPort, }
                                  { 4 = PS/2, 5 = HP-Maus             }
    MOV i, CL;                    { 0 = PS/2, 2..7 = Nummer des IRQ   }
  END;
  MouseType := m;
  IRQ       := i;
  Version   := v;
END;

PROCEDURE SetMouseWindow(x1, y1, x2, y2: INTEGER); ASSEMBLER;
ASM
  MOV  AX, 0007h
  MOV  CX, x1
  MOV  DX, x2
  INT  33h
  MOV  AX, 0008h
  MOV  CX, y1
  MOV  DX, y2
  INT  33h
END;

PROCEDURE GetMouseWindow(VAR x1, y1, x2, y2: INTEGER);
VAR
  x1t, x2t, y1t, y2t: INTEGER;
BEGIN
  ASM
    MOV  AX,  31h
    INT  33h
    MOV  x1t, AX
    MOV  x2t, CX
    MOV  y1t, BX
    MOV  y2t, DX
  END;
  x1 := x1t; x2 := x2t;
  y1 := y1t; y2 := y2t;
END;

PROCEDURE MouseINI;
BEGIN
  InitMouse;
  DisplayCursor;
END;

{BEGIN
  InitMouse;}
END.

(*===================================================================*)
