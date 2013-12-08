uses crt;
var konrad,anton:integer;
taste:char;
satz,satz1,satz2:string;
begin
 clrscr;
 satz2:='reh';
 writeln('Wie ist der Vorname vom ',satz2,'?');
 readln(satz1);
 satz:=satz1+satz2;
 writeln('Das Viech nennt sich ',satz);
 readkey;
end.