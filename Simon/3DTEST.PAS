uses crt,konrad,_32bit;

type TPos3d=record
             x,y,z:real;
            end;
     TPos=record
           x,y:integer;
          end;

const dist = 200;
      zoom=256;
     anz=100;
     speed=10;
     weite=1000;
var p  :array[1..anz] of  TPos3d;
    vp :array[1..anz] of TPos;

procedure Init;
 var t:integer;
 begin
  Init13h;
  randomize;
  for t:=1 to 255 do setmypalette(t,t shr 2,t shr 2,t shr 2);
  for t:=1 to anz do
  begin
  p[t].x:=random*200-100;
  p[t].y:=random*200-100;
  p[t].z:=random*200-100;
  end;
 end;

procedure Make;
begin
  for t:=1 to anz do
  begin
 vp[t].x:=160+round(zoom*p[t].x/(p[t].z+dist));
 vp[t].y:=100+round(zoom*p[t].y/(p[t].z+dist));
 end;
end;

procedure Show;
var t:word;
 begin
  for t:=1 to anz do with vp[t] do
   if p[t].z>0 then
    if ((x>0) and ((x<319) and (y>0)) and (y<200)) then
       screen[y,x]:=-round(p[t].z/4)+250 else begin end
 else
   begin
    p[t].z:=random*weite;
    p[t].x:=random*200-100;
    p[t].y:=random*200-100;
   end;
 end;

Procedure Flieg;
var t:integer;
Begin
 for t:=1 to anz do
  p[t].z:=p[t].z-speed;
End;

begin
 Init;
 repeat
  Make;
  Show;
  waitretrace;
  filllongint(screen,16000,0);
  Flieg;
 until keypressed;

end.