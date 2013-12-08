uses crt;
type ptype=array[1..768] of byte;
var taste:char;x:word;
    save:ptype;
    palette:ptype;


procedure waitretrace;
begin
repeat until (port[$3da] and $08)<>0;
repeat until (port[$3da] and $08)=0;
end;

begin
 x:=1;
{-------------------------------}
 repeat
  clrscr;
  writeln(x,'. Bitte Eingeben:');
  writeln;
  writeln('"W" = Weiter');
  writeln('"E" = Ende');
  taste:=readkey;
  inc(x);
 until upcase(taste)='E';
{-------------------------------}
 clrscr;
 for x:=0 to 100 do
 begin
 waitretrace;
 gotoxy(1,1);
 write('Hochz„hlen mit "to": ',x);
 if keypressed then halt;
 end;
{-------------------------------}
end.



