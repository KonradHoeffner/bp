uses konrad,_13h,_32bit,crt;
const fzoom:single=1.01;
      getmaxx=319;
      getmaxy=199;
      anz=1;
      anzp=5000;
var t,n:integer;
    x,y,fx,fy:single;
    vx,vy:integer;
    screens:array[1..anz] of ^tscreen;
    screen1:pointer;

procedure flip(var src,dest);assembler;
asm
 push ds
 lds si,src
 les di,dest
 mov cx,64000
 rep movsb

 pop ds
end;

begin
 screen1:=@screen;
 asm mov ax,13h; int 10h end;
 x:=random;
 y:=random;
 fx:=getmaxx;
 fy:=2*getmaxy;
 for t:=1 to anz do begin
  getmem(screens[t],64000);
  filllongint(screens[t]^,16000,0);
 end;
 for t:=1 to anz do
 begin
  for n:=1 to anzp do
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
   screens[t]^[vy,vx]:=15; {else begin   x:=x/2; y:=y/2; end};
   if keypressed then halt;
  end;
  fx:=fx*fzoom;
  fy:=fy*fzoom;
 end;
 for t:=1 to anz do
 begin
  delay(300);
  waitretrace;
{  movelongint(screens[t]^,screen,16000);}
  flip(screens[t]^,screen);
 end;
 for t:=1 to anz do freemem(screens[t],64000);
 readln;
end.