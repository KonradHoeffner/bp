uses {graph,}crt,konrad,_32bit,picture,_13h;
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
    screen:tscreen absolute $a000:0;
    {quell,}ziel:^tscreen;
    frame:^tscreen;
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


 procedure winkinit;
 begin
  for t:=1 to anz do p[t].winkel:=(360/anz)*t;
 end;

procedure put;
var steig:single;
    xa,ya,dx,dy:INTEGER;
    rea:real;

begin
dx:=p[1].x-p[2].x;
dy:=p[1].y-p[2].y;
if dx=0 then dx:=1;
if dy=0 then dy:=1;


{texline(p[1].x,p[1].y,p[2].x,p[2].y,frame^[0,0]);
texline(p[3].x,p[3].y,p[4].x,p[4].y,frame^[199,0]);}


 for t:=1 to abs(dy) do
 texline(p[1].x,p[1].y-round(dx*abs(dy)/t)
 ,p[2].x-round(dx*abs(dy)/t),p[2].y,frame^[t,0]);


end;

procedure putasm;assembler;
asm
 pusha
 lds si,frame
{ mov ax,seg frame
 mov ds,ax}
 xor si,si
{ mov ax,0a000h
 mov es,ax
 xor di,di}
 les di,ziel
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


procedure zeich;
begin
 for t:=1 to anz-1 do line(p[t].x,p[t].y,p[t+1].x,p[t+1].y,15);
 line(p[anz].x,p[anz].y,p[1].x,p[1].y,15);
end;

begin

 getmem(frame,64000);
{ getmem(quell,64000);}
 getmem(ziel,64000);
 getmem(puffer,64767);
{ gd:=installuserdriver('svga256',nil);
 gm:=0;
 initgraph(gd,gm,'c:\bp\bgi');}
 init13h;
 loadpcx(verzeichnis+bild,puffer^);
 movelongint(puffer^,frame^,16000);
 move(puffer^[64000],palette,256*3);

 setpal;
{ put;}
 mx:=160;
 my:=100;
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
  zeich;
  put;

  waitretrace;
  movelongint(ziel^,screen,16000);
  filllongint(ziel^,16000,0);

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
  {loesch;}

 if keypressed then taste:=readkey else taste:='n';
 until taste=#27;
  freemem(frame,64000);
  freemem(puffer,64767);
{  freemem(quell,64000);}
  freemem(ziel,64000);


end.