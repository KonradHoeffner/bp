uses konrad,graph,crt;
const fzoom:single=1.1;
var t,n:integer;
    x,y,fx,fy:single;
    vx,vy:integer;

begin
 t:=detect;
 initgraph(t,n,'c:\bp\bgi');
 x:=random;
 y:=random;
 fx:=getmaxx;
 fy:=2*getmaxy;

 repeat
 begin
  case random(3) of
  0:begin
   x:=x/2;
   y:=y/2;
  end;
  1:begin
   x:=0.5*(0.5+x);
   y:=0.5*(0.5+y);
  end;
  2:begin
   x:=0.5*(1+x);
   y:=0.5*y;
  end;
 end;
  vx:=round(x*fx);
  vy:=getmaxy-round(y*fy);
  if (vx>0) and (vx<getmaxx) and (vy>0) and (vy<getmaxy) then
  putpixel(vx,vy,15) {else begin   x:=x/2; y:=y/2; end};
 end;
 if keypressed then
 begin
  taste:=readkey;
  case taste of
   tup:begin cleardevice; fx:=fx*fzoom; fy:=fy*fzoom; end;
   tdown: begin cleardevice; fx:=fx/fzoom; fy:=fy/fzoom; end;
  end;
 end;
 until taste=#27;
end.