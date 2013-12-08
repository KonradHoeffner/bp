uses konrad;
{
const maxs=1000;
var schnee:array[1..maxs] of tpos3d;
    schneevis:array[1..maxs] of tpos;
    i:integer;
procedure InitS(p:tpos3d);
begin
 with p do begin
  z:=100+random(1000);
  x:=100-random(200);
  y:=400;
 end;
end;

procedure move;
var i:integer;
begin
 for i:=1 to maxs do with schnee[i] do
 begin
  x:=x+random(3)-1;
  y:=y-1;
  z:=z+random(3)-1;
 end;
end;

procedure display;
var i:integer;
begin
 makevis(schnee,schneevis,maxs,100,100);
 waitretrace;
 for i:=1 to maxs do with schneevis[i] do screen[y,x]:=15;
end;
}
begin
{ Init13h;}
{ Randomize;}
{ for i:=1 to maxs do InitS(schnee[i]);}
{ repeat}
{  move;}
{  display;}
{  taste:=readkey;
 until taste=#27;}
end.