uses graph,crt,konrad,_32bit,picture;
const anz=4;
      radius=70;
      verzeichnis='c:\eigene~1\bp\3d\';
      bild='space.pcx';
      farbe=255;
      zoom=320 div (radius*2);
type  ptype=array[0..64767] of byte;
      stype=array[0..63999] of byte;
var p:array[1..anz] of record
                           x,y,entf:word;
                           winkel:real;
                          end;

    pasmx:array[1..anz] of word;
    pasmy:array[1..anz] of word;
    gd,gm:integer;
    t,w:word;
    mx,my,moffs:word;
    screen:screen_type absolute $a000:0;
    {quell,}ziel:^screen_type;
    frame:^stype;
    puffer:^ptype;


function mitentf(x,y:word):word;
begin
 mitentf:=round(sqrt(sqr(abs(x-mx)+sqr(abs(y-my)))));
end;

procedure berech;
begin
  for t:=1 to anz do with p[t] do
  begin
   x:=mx+round(cos(winkel*pi/180)*entf);
   y:=my+round(sin(winkel*pi/180)*entf);
  end;
end;

procedure zeich;
begin
 for t:=1 to anz-1 do with p[t] do
 begin
{  putpixel(mx+x,my+y,15);}
  setcolor(farbe);
  line(x,y,p[t+1].x,p[t+1].y);
 end;
 line(p[anz].x,p[anz].y,p[1].x,p[1].y);
{ setfillstyle(1,blue);
 floodfill(mx,my,15);}
end;

procedure loesch;
begin
 for t:=1 to anz-1 do with p[t] do
 begin
  putpixel(x,y,0);
  setcolor(0);
  line(x,y,p[t+1].x,p[t+1].y);
 end;
 line(p[anz].x,p[anz].y,p[1].x,p[1].y);
{ setfillstyle(1,0);
 floodfill(mx,my,15);}
{ cleardevice;}
 {filllongint(mem[$a000:0],16000,0);}
end;
 procedure winkinit;
 begin
  for t:=1 to anz do p[t].winkel:=(360/anz)*t;
 end;

procedure put;
var steig:single;
    xa,ya,dx,dy:word;
    rea:real;
begin

if dx>0 then dx:={abs}(p[1].x-p[2].x) else dx:={abs}-(p[1].x-p[2].x);
if dy>0 then dy:={abs}(p[1].y-p[2].y) else dy:=-(p[1].y-p[2].y);
 if (dy<>0) and (dx<>0) then steig:=(dy/dx) else steig:=0;

{ if (dx>0) and (dy>0) then}
{ for t:=1 to 319 do for w:=1 to 199 do
 begin
  if dx<>0 then xa:={trunc(t*dx/320)}{t *dx div 320+p[1].x;{}
{  if dy<>0 then ya:=dy*t div 320+{trunc(w+dy*t/320)+}{w+p[1].y;{}
{  Screen[ya,xa]:=frame^[w*320+t];{}
{ end;{}{ else}
{
 for t:=0 to 319 do for w:=1 to 199 do
 begin
  if dx<>0 then xa:=trunc(t*dx/320)+p[1].x;
  if dy<>0 then ya:=trunc(w shr 1+dy*t/320)+p[1].y;
  Screen[ya,xa]:=frame^[w*320+t];
 end}

 for t:=0 to 319 do for w:=1 to 199 do
 begin
  if dx<>0 then xa:=p[1].x+t*dx div 320 ;
  if dy<>0 then ya:=p[1].y+w*dy div 320 ;
  Screen[ya,xa]:=frame^[w*320+t];
 end


end;

procedure putasm;assembler;
asm
 pusha
 lds si,frame
{ mov ax,seg frame
 mov ds,ax}
 xor si,si
 mov ax,0a000h
 mov es,ax
 xor di,di
 mov cx,64000
@loopa:
 mov ax,320
 mov bx,word ptr pasmy[1]
 mul bx
 add ax,word ptr pasmx[1]
 mov di,ax
 {movsb}
 mov ax,0ffffh
 stosb
 dec cx
 jne @loopa

 popa
end;

begin

 getmem(frame,64000);
{ getmem(quell,64000);}
 getmem(ziel,64000);
 getmem(puffer,64767);
 gd:=installuserdriver('svga256',nil);
 gm:=0;
 initgraph(gd,gm,'c:\bp\bgi');
 loadpcx(verzeichnis+bild,puffer^);
 movelongint(puffer^,frame^,16000);
 move(puffer^[64000],palette,256*3);

 setpal;
{ put;}
 mx:=getmaxx shr 1;
 my:=getmaxy shr 1;
 moffs:=320*my+mx;
 { p[1].winkel:=0;
 p[2].winkel:=90;
 p[3].winkel:=180;
 p[4].winkel:=270;}
 winkinit;
 for t:=1 to anz do with p[t] do entf:=radius{+random(40)};

 for t:=1 to anz do
 begin
  pasmx[t]:=p[t].x;
  pasmy[t]:=p[t].y;
 end;

 repeat
  for t:=1 to anz do if p[t].winkel<359 then p[t].winkel:=p[t].winkel+2
  else p[t].winkel:=1;
  berech;

  for t:=1 to anz do
  begin
   pasmx[t]:=p[t].x;
   pasmy[t]:=p[t].y;
  end;

  put;
  zeich;
  {waitretrace;}
{  asm
   pusha
   mov cx,64000
   lds si,ziel
   mov ax,0a000h
   mov es,ax
   xor di,di
   stosb
   popa
  end;}
  waitretrace;
{  filllongint(screen,16000,0);}
  {loesch;}

 if keypressed then taste:=readkey else taste:='n';
 until taste=#27;
  freemem(frame,64000);
  freemem(puffer,64767);
{  freemem(quell,64000);}
  freemem(ziel,64000);


end.