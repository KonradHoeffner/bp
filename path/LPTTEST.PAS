uses crt;
const base=$278;
var ch: string;
    i, code: integer;
begin
 port[base]:=0;
repeat
 port[base]:=0;
 readln(ch);
 Val(ch, i, Code);
 port[base]:=i;
 WriteLn(i,' und code ', code);
 delay (500);
until ch='ende';
 port[base]:=0;
end.