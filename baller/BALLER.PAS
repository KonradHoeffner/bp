{Konrad H봣fner 1999
esStruktur:

 init     - Laden der Bilder, Speicherreservierrung
 schleife - zeichen(2), beweg, taste


 ende     - Speicherfreigabe

}

uses crt,picture,_32bit;

const
{컴컴컴컴컴Verzeichnisse und Dateien컴컴컴컴컴컴�}
verzeichnis='c:\eigene~1\bp\baller\';
d_hintergr1='hint1.pcx';
d_figuren='figuren.pcx';
d_titel='titel.pcx';
d_titel2='titels.pcx';
{컴컴컴컴컴Positionen: figuren.pcx컴컴컴컴컴컴컴�}
figur1_x=0;
figur1_y=0;
figur1_hoehe=30;
figur1_breite=21;
figur1b1_x=21;
figur1b1_y=0;
figur1b1_hoehe=30;
figur1b1_breite=23;
figur2_x=0;
figur2_y=30;
figur2_hoehe=30;
figur2_breite=15;
alien1_x=0 ;
alien1_y=60;
alien1_hoehe=32;
alien1_breite=30;
sensemann1_x=0;
sensemann1_y=92;
sensemann1_hoehe=30;
sensemann1_breite=30;

{컴컴컴컴컴Farben컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
rot = 100;
gruen= 101;
blau=102;
{컴컴컴컴컴Allgemeine Konstanten컴컴컴컴컴컴컴컴컴}
anzframes=1;
gesch=10;
getmaxx=319;
getmaxy=199;
sprunghoehe1=50;
sprunghoehe2=50;
{컴컴컴컴컴Alte Bitmaparrays컴컴컴컴컴컴컴컴컴컴�}
figur1:array[0..99] of byte =
(0,0,0,1,1,1,0,0,0,0,
 0,0,1,1,1,1,1,0,0,0,
 0,0,0,1,0,1,0,0,0,0,
 1,0,0,0,1,0,0,1,0,0,
 1,1,1,1,1,1,1,1,0,0,
 0,0,0,1,1,0,0,0,0,0,
 0,0,0,1,1,1,0,0,0,0,
 0,0,1,0,0,1,0,0,0,0,
 0,0,1,0,0,0,1,0,0,0,
 0,1,0,0,0,0,0,1,0,0);

figur2:array[0..99] of byte =
(0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,
 0,0,2,2,2,0,0,0,0,0,
 0,0,2,2,2,0,0,0,0,0,
 0,0,0,2,0,0,0,0,0,0,
 0,2,2,2,2,2,0,0,0,0,
 0,0,0,2,0,0,0,0,0,0,
 0,0,0,2,0,0,0,0,0,0,
 0,0,2,0,2,0,0,0,0,0,
 2,2,2,0,2,2,2,0,0,0);

type ptype=array[0..63999+768] of byte;
     screentype1=array[0..63999] of byte;
     screentype2=array[0..199,0..319] of byte;

var
    puffer:^ptype;
    t,u,count:word;
    c:char;
    s1,s2:string;
    gd,gm:integer;
    spieler1,spieler2 : record
                        leben: byte;
                        x,y  : integer;
                        speed: shortint;
                        ducken:boolean;
                        end;
    screen:screentype2 absolute $a000:0;
    s_bild:^screentype1;
    s_figuren:^screentype1;
    frame:array[1..anzframes] of ^screentype1;
    palette:array[0..767] of byte;

procedure test;
begin
 asm
  mov ax,0a000h
  mov es,ax
  xor di,di
  mov cx,64000
  mov ax,seg s_figuren
  mov ds,ax
  xor si,si
  {add si,offset s_figuren{}
  {add si,56*320+300{}
  mov cx,10000
  @loop:
  mov al,ds:[si]
  {add al,64}
  {mov ds:[si],al}
  movsw
  {stosb}
  {inc si}

  dec cx
  jnz @loop
 end;
 end;

procedure zeichne(x,y,xpos,ypos,hoehe,breite:word);
 begin
   for t:=0 to hoehe-1 do move(s_figuren^[320*(ypos+t)+xpos],
   mem[$a000:320*(y+t)+x],breite);
 end;

 procedure zeichne2not(x,y,xpos,ypos,hoehe,breite:word);
 begin
   for t:=0 to hoehe-1 do for u:=0 to breite-1 do if
   s_figuren^[320*(ypos+t)+xpos+u]>0 then
   mem[$a000:320*(y+t)+x+u]:=
   s_figuren^[320*(ypos+t)+xpos+u];
 end;

procedure setpal;assembler;
asm
 push si
 mov si,offset palette
 mov cx,256*3
 xor al,al
 mov dx,03c8h
 out dx,al
 inc dx
 rep outsb
 pop si
end;

procedure waitretrace;
begin
repeat until (port[$3da] and $08)<>0;
repeat until (port[$3da] and $08)=0;
end;


procedure init;
 procedure start;
  procedure zeichnes(x,y,xpos,ypos,hoehe,breite:word);
 begin
   for t:=0 to hoehe-1 do move(frame[1]^[320*(ypos+t)+xpos],
   mem[$a000:320*(y+t)+x],breite);
 end;

 begin
  delay(700);

  zeichnes(137,44,0,0,41,72);
  readkey;
 end;

begin
 count:=0;
 for t:=1 to anzframes do getmem(frame[t],64000);
 getmem(puffer,64000+768);
 getmem(s_bild,64000);
 getmem(s_figuren,64000);

 spieler1.x:=getmaxx-figur1_breite-20; spieler1.y:=getmaxy-figur1_hoehe-5;
 spieler2.x:=50; spieler2.y:=spieler1.y;
 asm
  mov ax,13h
  int 10h
 end;
{컴훁tart컴컴컴컴컴컴컴컴컴컴컴컴컴}
 loadpcx(verzeichnis+d_titel,puffer^);
 movelongint(puffer^,mem[$a000:0],16000);
 move(puffer^[64000],palette,256*3);

 loadpcx(verzeichnis+d_titel2,puffer^);
 movelongint(puffer^,frame[1]^,16000);
 move(puffer^[64000],palette,256*3);
 setpal;
 start;
{컴컴Hintergrund컴컴컴컴컴컴컴컴컴컴컴컴컴}
 loadpcx(verzeichnis+d_hintergr1,puffer^);
 movelongint(puffer^,s_bild^,16000);
 move(puffer^[64000],palette,64*3);
{컴컴Figurenbild컴컴컴컴컴컴컴컴컴컴컴컴컴}
 loadpcx(verzeichnis+d_figuren,puffer^);
 movelongint(puffer^,s_figuren^,16000);
 move(puffer^[64000],palette[64*3],(256-64)*3);
 for t:=0 to 63999 do if s_figuren^[t]>0 then inc(s_figuren^[t],64);
 setpal;


end;


procedure schleife;
 procedure put(x,y:word;farbe:byte);assembler;
 asm
  mov ax,0a000h
  mov es,ax
  mov ax,320
  mul y
  add ax,x
  mov di,ax
  mov al,farbe
  mov es:[di],al
 end;

  function ende:boolean;
  begin
  ende:=false;
 end;

{ procedure zeichne(x,y,hoehe,breite:word;z:array of byte);
 begin
   for t:=0 to hoehe-1 do move(z[t*breite],
   mem[$a000:320*(y+t)+x],breite);
 end;}

{ procedure zeichne(x,y,hoehe,breite:word;z:array of byte);
 begin
   for t:=0 to hoehe-1 do move(z[t*breite],
   mem[$a000:320*(y+t)+x],breite);
 end;}



 procedure zeichne2(x,y,xpos,ypos,hoehe,breite:word);
 begin
 asm
  {Addressierung s_figuren}
  mov ax,seg s_figuren
  mov ds,ax
  mov ax,320
  mul ypos
  add ax,xpos
  add ax,offset s_figuren
  add ax,56*320
  mov si,ax
  {Addressierung $a000:0}
  mov ax,0a000h
  mov es,ax
  mov ax,320
  mul y
  add ax,x
  mov di,ax

  {Start}
  mov cx,hoehe
@loop_y:
  mov dx,breite
@loop_x:
 mov al,ds:[si]
 or al,al
 jz @schwarz
 add al,64
 mov es:[di],al
@schwarz:
 inc si
 inc di
 dec dx
 jnz @loop_x
 add si,320
 add di,320
 sub si,breite
 sub di,breite
 dec cx
 jnz @loop_y
 end;
 end;



 procedure loesche(x,y,hoehe,breite:word);
 begin
    {screen[y+t,x]}
   for t:=0 to hoehe-1 do fillchar(mem[$a000:320*(y+t)+x],breite,0);
 end;


 procedure taste;
 begin
   if keypressed then c:=readkey else c:='n';
   case c of
 {   #80:if spieler1.speedy<122 then inc(spieler.speedy,gesch1);}
    #72:if spieler1.y >getmaxy-figur1_hoehe-1 then dec(spieler1.y,sprunghoehe1);
    #75:if spieler1.x>10 then dec(spieler1.speed,gesch);
    #77:if spieler1.x<getmaxx-spieler1.speed then inc(spieler1.speed,gesch);
 {   ' ':line(spieler1.x,spieler1.y,spieler2.x-5,spieler2.y+5);}


 {   'd':if gegner.speedy<122 then inc(gegner.speedy,gesch2);}
     'e':if spieler2.y >getmaxy-figur1_hoehe-1 then dec(spieler2.y,20);
     's':if spieler2.x>10 then dec(spieler2.speed,gesch);
     'f':if spieler2.x<getmaxx-10 then inc(spieler2.speed,gesch);
   end;
 end;

 procedure beweg;
 begin
  inc(spieler1.x,spieler1.speed);
  inc(spieler2.x,spieler2.speed);

  if (spieler1.x<10) and (spieler1.speed<0) then spieler1.speed:=-spieler1.speed;
  if (spieler1.x>getmaxx-20) and (spieler1.speed>0) then spieler1.speed:=-spieler1.speed;

  if (spieler2.x<10) and (spieler2.speed<0) then spieler2.speed:=-spieler2.speed;
  if (spieler2.x>getmaxx-20) and (spieler2.speed>0) then spieler2.speed:=-spieler2.speed;

  if spieler1.y<getmaxy-figur1_hoehe then inc(spieler1.y);
  if spieler2.y<getmaxy-figur2_hoehe then inc(spieler2.y);

  if spieler1.speed>0 then dec(spieler1.speed);
  if spieler1.speed<0 then inc(spieler1.speed);

  if spieler2.speed>0 then dec(spieler2.speed);
  if spieler2.speed<0 then inc(spieler2.speed);
 end;

begin

 repeat
  movelongint(s_bild^,mem[$a000:0],16000);
  zeichne2not(spieler1.x,spieler1.y,figur1_x,figur1_y,figur1_hoehe,figur1_breite);
{  zeichne2not(spieler1.x,spieler1.y,figur1b1_x,figur1b1_y,figur1b1_hoehe,figur1b1_breite);}
  zeichne2not(spieler2.x,spieler2.y,figur2_x,figur2_y,figur2_hoehe,figur2_breite);
{  zeichne2not(spieler1.x,spieler1.y,alien1_x,alien1_y,alien1_hoehe,alien1_breite);
  zeichne2not(spieler2.x,spieler2.y,sensemann1_x,sensemann1_y,sensemann1_hoehe,sensemann1_breite);}
  waitretrace;

  {loesche(spieler1.x,spieler1.y,10,10);
  loesche(spieler2.x,spieler2.y,10,10);}
  taste;
  beweg;
 until (c=#27) or (ende);
end;

procedure ende;
begin
 freemem(puffer,64000+768);
 freemem(s_bild,64000);
 freemem(s_figuren,64000);
 for t:=1 to anzframes do freemem(frame[t],64000);
 textmode(3);
end;

begin
 init;

 schleife;
 ende;
end.

  {with spieler1 do for t:=0 to 9 do for u:=0 to 9 do put(x+t,y+u,figur1[u,t]);
  with spieler2 do for t:=0 to 9 do for u:=0 to 9 do put(x+t,y+u,figur2[u,t]);}
{ for t:=1 to 63 do
 begin
 setrgbpalette(0,t,0,0)
 end;
 for t:=63 downto 0 do
 begin
 setrgbpalette(0,t,0,0)
 end;}
{with spieler1 do for t:=0 to 9 do for u:=0 to 9 do put(x+t,y+u,0);
  with spieler2 do for t:=0 to 9 do for u:=0 to 9 do put(x+t,y+u,0); }