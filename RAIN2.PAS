program x;
uses konrad,crt,graph13,_32bit;
const maxline=3;

var i,j,k,t:word;
    dummy:array[0..319] of byte;

procedure init;
var gd,gm:integer;
begin

{     gd:=installuserdriver('svga386',nil);
     gm:=0;
     initgraph(gd,gm,'C:\bp\bgi');}
     asm
      mov ax,13h
      int 10h
     end;
     for i:=1 to 255 do setrgbpalette(i,i shr 2,0,0);
     setpal;
     randomize;
end;

procedure mainprog;
var x,y:array[1..maxline] of word;
    p,p1:pointer;
   taste:char;
begin
t:=0;
getmem(p,320*198+4);
getmem(p1,320*2+4);
setcolor(90);
outtextxy(80,0,'Dies ist ein');
outtextxy(92,10,'-Test-');
outtextxy(42,30,'... ja, ein -Test-');
outtextxy(42,40,'Er wurde programmiert von :');
outtextxy(43,50,'K O N R A D  H ™ F F N E R');
outtextxy(90,60,'17. Juli 1997');
outtextxy(42,70,'...in der bekannten Stadt');
outtextxy(95,80,'-LEIPZIG-');
outtextxy(50,90,'in der ');
outtextxy(50,100,'Steinstraáe');



repeat
inc(t);
for k:=1 to maxline do
for i:=1 to 20 do begin
x[k]:=random(getmaxx);
y[k]:=random(getmaxy);
for j:=10 downto 1 do
if j+getpixel(x[k],y[k]-j)<255 then putpixel(x[k],y[k]-j,j+getpixel(x[k],y[k]-j)) else putpixel(x[k],y[k]-j,255)
end;

movelongint(screen[198,0],p1^,80*2);
movelongint(screen,p^,80*198);
movelongint(p1^,screen,80*2);
movelongint(p^,screen[2,0],80*198);

{getimage(0,2,319,199,p^);
getimage(0,0,319,1,p1^);

putimage(0,0,p^,0);
putimage(0,197,p1^,0);}


until (keypressed) {or (t=500)};

freemem(p,320*199+4);
freemem(p1,324);

end;


begin
     init;
     mainprog;
     {closegraph;}
end.