uses crt;
var f:text;
    filename,name:string;
    t:word;
    anzahl,anzx,anzy:byte;
begin
 writeln('Maperstellungsprogramm');
 writeln;
 write('Name der Map: ');readln(filename);
 assign(f,filename);
 rewrite(f);
 write('Anzahl der Maps: ');readln(anzahl);
 writeln(f,anzahl);
 writeln;
 write('Anzahl der Maps in x-Richtung: ');readln(anzx);
 writeln(f,anzx);
 write('Anzahl der Maps in y-Richtung: ');readln(anzy);
 writeln(f,anzy);
 for t:=1 to anzahl do
 begin
  write('Name der ',t,'. Map: ');readln(name);
  writeln(f,name);
 end;
 close(f);
end.