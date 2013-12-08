uses crt,konrad;
type atype=array[1..1] of byte;
var t:word;
    a:^atype;
begin
 getmem(a,5);
 clrscr;
 for t:=1 to 5 do
 begin
  writeln('Zahl: ');readln(a^[t]);
 end;
 writeln;
 for t:=1 to 5 do writeln(a^[t]);
 readkey;
end.