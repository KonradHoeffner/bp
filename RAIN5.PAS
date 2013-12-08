uses crt,graph,modexlib,dos;
const maxline=3;
      t_anz=283;
type screentype=array[0..199,0..319] of byte;

var i,j,k,t:integer;
    screen:screentype absolute $a000:0;

function a(x:word):byte;
begin
if x>255 then a:=255 else a:=x;
end;


function b(y:integer):byte;
begin
if y in[0..255] then b:=y
else if y<0 then b:=0
else b:=255;

end;


procedure init;
var gd,gm:integer;
begin

     gd:=installuserdriver('svga386',nil);
     gm:=0;
     initgraph(gd,gm,'C:\bp\bgi');
     for i:=1 to 255 do setrgbpalette(i,i,0,0);
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
setcolor(60);
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
for j:=22 downto 1 do
if j+getpixel(x[k],y[k]-j)<255 then putpixel(x[k],y[k]-j,j+getpixel(x[k],y[k]-j)) else putpixel(x[k],y[k]-j,255)
end;

getimage(0,2,319,199,p^);
getimage(0,0,319,1,p1^);

putimage(0,0,p^,0);
putimage(0,197,p1^,0);


until (keypressed) or (t=t_anz);

waitretrace;
for k :=1 to 7 do for j:=0 to 198 do for i:=0 to 319 do
 screen[j,i]:=a((screen[j+1,i-1]+screen[j+1,i]+screen[j+1,i+1]+screen[j,i]) div 3);


for j:=0 to 128 do begin
                  for i:=0 to 255 do setrgbpalette(i,a(i+j shl 2),0,0);
                  waitretrace;
                  end;
{for i:=0 to 319 do for j:=0 to 199 do if getpixel(i,j)=0 then putpixel(i,j,2);
for i:=0 to 319 do for j:=0 to 199 do if getpixel(i,j)=1 then putpixel(i,j,2); }
for i:=0 to getmaxx do for j:=0 to getmaxy do putpixel(i,j,0);
setcolor(1);
settextstyle(10,0,9);
outtextxy(5,0,'Test!');
setfillstyle(1,2);
floodfill(30,70,1);
floodfill(129,93,1);
floodfill(229,93,1);
floodfill(305,100,1);

 for k :=1 to 2 do  for j:=0 to 198 do for i:=0 to 319 do
 screen[j,i]:=a((screen[j+1,i-1]+screen[j+1,i]+
 screen[j+1,i+1]) div 3+((screen[j,i] shr 1)));



 for i:=127 downto 0 do begin setrgbpalette(0,a(i shl 2),0,0); waitretrace; end;

for j:=255 downto 0 do begin
                  for i:=255 downto 1 do setrgbpalette(i,a(i+j),0,0);
                  waitretrace;
                  end;

for j:=255 downto 0 do begin
                  for i:=j downto 0 do setrgbpalette(j,i,0,0);
                  waitretrace;
                  end;




freemem(p,320*199+4);
freemem(p1,324);
closegraph;

end;


begin
     init;
     mainprog;
end.