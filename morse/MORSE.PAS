uses crt;
type tzeichen=string[5];
const
dosound=true;
f=1000;
stime=100;
ltime=250;
notime=100;
buchstaben:array[ord('A')..ord('Z')] of tzeichen=
('.-','-...','-.-.','-..','.','..-.',{abcdef}
'--.','....','..','.---','-.-','.-..',{ghijkl}
'--','-.','---','.--.','--.-','.-.',{mnopqr}
'...','-','..-','...-','.--','-..-',{stuvwx}
'-.--','--..');{y,z}
ae:tzeichen='.-.-';
oe:tzeichen='---.';
ue:tzeichen='..--';
zahlen:array[1..10] of tzeichen=
('.----','..---','...--','....-','.....','-....','--...','---..','----.','-----');
var codes:array[0..255] of Tzeichen;
    eingabe:char;
    t:integer;
Procedure init;
Begin
 move(buchstaben,codes[ord('A')],sizeof(buchstaben));
 move(buchstaben,codes[ord('a')],sizeof(buchstaben));
 codes[ord('')]:=ae;codes[ord('„')]:=ae;
 codes[ord('™')]:=oe;codes[ord('”')]:=oe;
 codes[ord('š')]:=ue;codes[ord('')]:=ue;
 move(zahlen,codes[ord('1')],sizeof(zahlen));
End;

procedure sbeep;
begin
 sound(f);
 delay(stime);
 nosound;
 delay(notime);
end;

procedure lbeep;
begin
 sound(f);
 delay(ltime);
 nosound;
 delay(notime);
end;

procedure beep(s:tzeichen);
var t:integer;
begin
 for t:=1 to length(s) do
 case s[t] of
  '.':sbeep;
  '-':lbeep;
  else writeln('Fehler in Zeichenkonstante!');
 end;
end;

begin
  Init;
  Clrscr;
  writeln('Satz eingeben:');
  write('> ');

 repeat
  eingabe:=readkey;
  case eingabe of
   ' ':write('  ');
   #13:write('  ');
   else
   begin
    if dosound then beep(codes[ord(eingabe)]);
    write('',codes[ord(eingabe)],' ');
   end;
  end;

 until eingabe=#27;
end.