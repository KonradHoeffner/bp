uses crt,konrad;
const canz=70;
      zeit=500;
var t:word;
    feld:array[1..canz] of byte;
    anz:integer;

procedure los;
begin
 if anz<canz then
 begin
  inc(anz);
  feld[anz]:=random(15)+1;
 end;
end;

procedure raus;
var t:word;
    r:byte;
    dummy:integer;
begin
 r:=random(anz)+1;
 gotoxy(r,3);
 textcolor(feld[r]+blink);
 write(#178);
 delay(zeit);
 move(feld[r+1],feld[r],canz-r);
 dec(anz);
end;

begin
 anz:=0;
 randomize;
 repeat
  if keypressed then taste:=readkey else taste:='n';
   case taste of
    ' ': los;
    #13:if anz>0 then raus;
   end;
  waitretrace;
  clrscr;
  textcolor(lightgray);
  writeln('Programm zum Verwalten eines arrays');
  writeln;
  for t:=1 to anz do
  begin
   textcolor(feld[t]);
   write(#178);
  end;
 until taste=#27;
end.