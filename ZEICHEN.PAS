uses crt;
var d1,d2:string;
    ziffern:array[0..9] of integer;
    i,j:integer;
    s:array[1..200] of string;

procedure doit(var ein,aus:string);
var i:integer;
begin
 for i:=1 to length(ein) do inc(ziffern[ord(ein[i])-48]);
 aus:='';
 for i:=0 to 9 do
 begin
  if ziffern[i]>0 then
  begin
   str(ziffern[i],d1);
   str(i,d2);
   aus:=aus+d1;
   aus:=aus+d2;
  end;
 end;
end;

begin
 clrscr;
 readln(s[1]);
 fillchar(ziffern,sizeof(ziffern),0);
 for j:=1 to 10 do
 begin
  doit(s[j],s[j+1]);
  writeln(s[j+1]);
 end;
 readkey;
end.