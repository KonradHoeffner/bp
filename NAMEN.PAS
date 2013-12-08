uses crt;
const
ivokale=5;
ikonsos=21;
iM=5;
iW=7;
vokale:array[1..ivokale] of char=('a','e','i','o','u');
konsos:array[1..ikonsos] of char=('b','c','d','f','g','h','j','k','l','m','n','p','q','r',
's','t','v','w','x','y','z');
endm:array[1..iM] of string=('d','ar','el','cht','in');
endw:array[1..iW] of string=('ine','a','e','ie','ia','an','ana');
var name:string;
    taste:char;
    i:integer;
    gender:boolean;
    laenge:integer;

Function Namegen:string;
var i:integer;
    s:string;
Begin
 s:='';
 for i:=1 to (laenge shr 1) do
 begin
  s:=s+konsos[random(ikonsos)+1];
  s:=s+vokale[random(ivokale)+1];
 end;
 if gender then s:=s+endM[random(iM)+1] else
 s:=s+endW[random(iW)+1];
 Namegen:=s;
End;

begin
 randomize;
 clrscr;
 writeln('Namensgenerator:');
 writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
 writeln;
 write('"M"꼗nlich oder "W"eiblich? ');
 if upcase(readkey)='M' then gender:=true else gender:=false;writeln;
{ write('Namensl꼗ge (gerade): ');readln(laenge);}
 writeln('Namen:');
 writeln('컴컴컴');
 for i:=1 to 10 do
 begin
  laenge:=2+random(5);
  writeln(Namegen);
 end;
 readln;
end.