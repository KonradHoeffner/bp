{BY ERIC ESINS}
unit GRAPHBO;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}
INTERFACE
uses Graph, Crt;

PROCEDURE INIS256 (Mode: Byte; Text: String);
PROCEDURE INI16   (Mode: Byte; Text: String);
PROCEDURE SETPALBLACK;
PROCEDURE SCRON;
PROCEDURE SCROFF;
FUNCTION  WAIT : CHAR;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}
IMPLEMENTATION
var
 Text           : String;
 gd, gm, I, T   : Integer;
 result, Heat   : Byte;
 {SVGADriverPtr  : Pointer;}

{****************************************************************************}
PROCEDURE SETPALBLACK;
 Begin;
  I := GetMaxColor;
  For T := 1 to I do SetRGBPalette (T-1, 0, 0, 0);
 End;

{****************************************************************************}
PROCEDURE INI16 (Mode: Byte; Text: String);
 Begin;
  gd := InstallUserDriver('SVGA16M', Nil);
  gm := Mode;

  InitGraph(gd, gm, Text);
  result := GraphResult;
  IF result < 0 then
   begin;
    WriteLn(^G, GraphErrorMsg(result));
    Delay (2000);
    halt;
   end;
 end;

{****************************************************************************}
PROCEDURE INIS256 (Mode: Byte; Text: String);
 Begin;
  gd := InstallUserDriver('SVGA256M', Nil);
  gm := Mode;

  InitGraph(gd, gm, Text);
  result := GraphResult;
  IF result < 0 then
   begin;
    WriteLn(^G, GraphErrorMsg(result));
    Delay(2000);
    halt;
   end;
 end;


{****************************************************************************}
PROCEDURE SCROFF;
 Begin;
  Port[$3c4]:=1;                {Register 1 des TS (TS Mode) selektieren}
  Port[$3c5]:=Port[$3c5] or 32; {Bit 5 (Screen Off) setzen}
 end;

{****************************************************************************}
PROCEDURE SCRON;
 Begin;
  Port[$3c4]:=1;                      {Register 1 des TS (TS Mode) selektieren}
  Port[$3c5]:=Port[$3c5] and not 32;  {Bit 5 (Screen Off l”schen}
 end;

{****************************************************************************}
FUNCTION WAIT : CHAR;
BEGIN
  REPEAT UNTIL Keypressed;
  WAIT := ReadKey;
END;

end.