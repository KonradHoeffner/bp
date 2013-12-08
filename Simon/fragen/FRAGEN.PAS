uses crt;

const maxchars = 20;
      maxworte = 20;
      pfad     = 'c:\eigene~1\bp\Simon\fragen\';

var chars : array[1..maxchars] of char;
    worte : array[1..maxworte] of string;
    t     : integer;
    key   : char;
    Fragewort :  string;

function FileExists : boolean;
var wort : text;
 begin
  {$i-}
  assign(wort,pfad+fragewort);
  reset(wort);
  if ioresult <> 0 then FileExists:=false else Fileexists:=true;
  close(wort);
  {$i+}
 end;

procedure Lesen;
 begin
  repeat
   key:=readkey;
   chars[t]:=key;
   if chars[t] = #27 then halt;
   inc(t);
   write(key);
  until key = ' ';
   move(chars,worte[1][1],t);
   move(t,worte[1][0],1);
 end;

procedure Init;
 begin
  t:=1;
 end;


begin
clrscr;
{ repeat}
Init;

writeln('Sag mal was !');
write;
readln(fragewort);

Lesen;

if Fileexists = false then
 begin
  writeln('Was ist ',fragewort);
  readln;
 end;

{ until key = #27;}
end.