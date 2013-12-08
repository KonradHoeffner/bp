uses konrad,crt,_32bit,_13h;
const cx1=150;
      cy1=100;

Procedure MyLine(x1,y1,x2,y2:integer;farbe:byte);
var steigx,steigy:real;
    dummy:word;
    dx,dy:integer;
    x,y:word;
Begin
 dy:=y2-y1;
 dx:=x2-x1;

 if abs(dx)>abs(dy) then
 begin
 if x2<x1 then
 begin
  dummy:=x1;
  x1:=x2;
  x2:=dummy;
  dummy:=y1;
  y1:=y2;
  y2:=dummy;
  dx:=-dx;
  dy:=-dy;
 end;
  steigx:=dy/dx;
  for x:=0 to dx do screen[y1+round(steigx*x),x+x1]:=farbe;
 end else
 begin
 dx:=-dx;
 if y2<y1 then
 begin
  dummy:=x1;
  x1:=x2;
  x2:=dummy;
  dummy:=y1;
  y1:=y2;
  y2:=dummy;
  dy:=-dy;
  dx:=-dx;
 end;
  if dy<>0 then steigy:=dx/dy;
  for y:=0 to dy do screen[y+y1,x1-round(steigy*y)]:=farbe;
 end;
End;

begin
 Init13h;
 randomize;
{ for t:=1 to 200 do Myline(random(320),random(200),random(320),random(200),random(256));}
{ MyLine(0,0,319,199,15);}
 maus_init;
 repeat
  maus_abfrage;maus.x:=maus.x shr 1;
  myline(cx1,cy1,maus.x,maus.y,15);
  waitretrace;
  myline(cx1,cy1,maus.x,maus.y,0);

  if keypressed then taste:=readkey;
 until taste =  #27;

 readkey;
end.