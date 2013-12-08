unit superwurm1_feuerunit;

interface

uses graph;

procedure feuer(waffe:waffen);

implementation

procedure feuer(waffe:waffen);
begin

if waffe=laser1 then
for i:=1 to 400 do begin
wr:=yellow;{random(getmaxcolor)+1;}
if s.f=true then begin
case taste1 of
char(75): putpixel(s.x-i,s.y,wr);
char(77): putpixel(s.x+i,s.y,wr);
char(72): putpixel8(s.x,s.y-i,wr);
char(80): putpixel(s.x,s.y+i,wr);

end;
sound(i+100);
if i mod 3=0 then delay(1);
nosound;
end;

end;
for i:=1 to 400 do begin
case taste1 of
char(75): putpixel(s.x-i,s.y,0);
char(77): putpixel(s.x+i,s.y,0);
char(72): putpixel(s.x,s.y-i,0);
char(80): putpixel(s.x,s.y+i,0);
end;
end;

end;


end.