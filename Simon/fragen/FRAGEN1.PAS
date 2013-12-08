uses crt;

const maxchars = 20;
      maxworte = 20;

var chars : array[1..maxchars] of char;
    worte : array[1..maxworte] of string;
    t     : integer;
    key   : char;

begin
clrscr;
{ repeat}
t:=1;
  repeat
   key:=readkey;
   chars[t]:=key;
   if chars[t] = #27 then halt;
   inc(t);
   write(key);
  until key = ' ';

  move(chars,worte[1][1],t);
  move(t,worte[1][0],1);

  gotoxy(1,2);
  write(worte[1]);

  readln;
{ until key = #27;}
end.