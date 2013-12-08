uses crt,dos;
TYPE eShift = (ShiftR, ShiftL, Ctrl, Alt, Scroll, Num, Caps);
     tshift = SET OF eShift;

VAR Shift: tShift ABSOLUTE $0040:$0017;
    taste:char;
const warte=150;
      setshift:tShift=[];
      clearshift:tShift=[];

      lauf0=[];
      lauf1=[num];
      lauf2=[num,caps];
      lauf3=[caps,scroll];
      lauf4=[scroll];
      lauf6=[];

      ein=[num,caps,scroll];
      aus=[];

var   b:byte;
      t,w:word;

PROCEDURE shift_set;
BEGIN
 Shift:= Shift- ClearShift+ SetShift;
END;

begin
 repeat
  inc(b);
  case b mod 6 of
  0:shift:=lauf0;
  1:shift:=lauf1;
  2:shift:=lauf2;
  3:shift:=lauf3;
  4:shift:=lauf4;
  5:shift:=lauf4;
  end;
  delay(warte);
  if keypressed then taste:=readkey;
  until taste=#27;
  shift:=[];
end.