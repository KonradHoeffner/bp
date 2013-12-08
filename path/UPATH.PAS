unit upath;
{konrad}
interface
type TPalette=array[0..767] of byte;
     tscreen=array[0..199,0..319] of byte;
     TPuffer=array[0..64767] of byte;{320*200+palette}
     TPos=record
           x,y:integer;
          end;
     TMaus=record
          x,y:integer;
          taste:byte;
         end;
var palette:TPalette;
    taste:char;
    screen:tscreen absolute $a000:0;
    maus:TMaus;

procedure outtextxy2(x,y:word;texte:string;color:byte;var source);
Procedure Line(seg:word;x1,y1,x2,y2:integer;col:byte);
procedure setpal;
procedure waitretrace;
procedure maus_init;
procedure maus_abfrage;
procedure init13h;
Procedure SetmyPalette(nr,r,g,b:byte);
implementation

Procedure SetmyPalette(nr,r,g,b:byte);assembler;
asm
 mov dx,03c8h
 mov al,nr
 out dx,al
 inc dx
 mov al,r
 out dx,al
 mov al,g
 out dx,al
 mov al,b
 out dx,al
End;

procedure init13h;assembler;
asm
 mov ax,13h
 int 10h
end;

procedure waitretrace;
begin
repeat until (port[$3da] and $08)<>0;
repeat until (port[$3da] and $08)=0;
end;


procedure maus_init;assembler;
asm
 mov ax,0
 mov bx,0
 int 33h
end;

procedure maus_abfrage;assembler;
asm
 mov ax,3
 int 33h
 mov maus.taste,bl
 mov maus.x,cx
 mov maus.y,dx
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

Procedure Line(seg:word;x1,y1,x2,y2:integer;col:byte);assembler;
const fehler:integer=0;
var t,
    dx,dy,
    inc_x,inc_y:integer;
    ofs:word;
asm
 push ds
{1. Offsets und Deltas vorberechnen}
{ÄÄÄÄÄÄdx = x2-x1ÄÄÄÄÄÄ}
 mov ax,x2
 sub ax,x1 {}
 mov &dx,ax {}
{ÄÄÄÄÄÄdy = y2-y1ÄÄÄÄÄÄÄÄÄ}
 mov ax,y2 {}
 sub ax,y1 {}
 mov dy,ax {}
{}
{ÄÄÄÄÄÄofs = 320*y1+x1}
 mov ax,320
 mul y1
 add ax,x1
 mov ofs,ax
{ÄÄÄÄÄÄES:[DI] setzen}
 mov di,ofs
 mov es,&seg
{Richtung bestimmen}
{ÄÄÄÄÄÄDX>0?ÄÄÄÄÄÄ}
 cmp &dx,0
 jg @dx_groesser_0
@dx_kleiner_0:
 mov inc_x,-1
 xor ax,ax{dx= -dx}
 sub ax,&dx{..}
 mov &dx,ax{..}
 jmp @weiter
@dx_groesser_0:
 mov inc_x,1
@weiter:
{ÄÄÄÄÄÄDY>0?ÄÄÄ}
 cmp dy,0
 jg @dy_groesser_0
@dy_kleiner_0:
 mov inc_y,-320
 xor ax,ax{dx= -dx}
 sub ax,dy{..}
 mov dy,ax{..}
 jmp @weiter2
@dy_groesser_0:
 mov inc_y,320
@weiter2:
{ÄÄÄÄÄÄÄÄÄÄÄÄLinie zeichnenÄÄÄÄÄÄÄÄÄÄÄÄ}
 mov ax,&dx
 cmp dy,ax
 jg @dy_groesser_dx
{ÄÄÄÄDX>DY-LinieÄÄÄÄ}
 mov cx,&dx
@loop_x_line:{LOOP X START}
 mov al,col
 mov es:[di],al {PUNKT SETZEN}
 mov ax,dy      {FEHLER + DY}
 add fehler,ax  {..}
 mov ax,&dy
 cmp fehler,ax
 jng @fehler_kleiner_dx
 {FEHLER > DX}
 mov ax,&dx
 sub fehler,ax
 mov ax,inc_y
 add di,ax
 {ÄÄÄÄÄÄÄÄÄÄÄ}
 @fehler_kleiner_dx:
 mov ax,inc_x
 add di,ax

 dec cx
 jne @loop_x_line{LOOP X ENDE}
 jmp @ende
{///////////////}
{DY>DX-Linie}
@dy_groesser_dx:
 mov cx,&dy
@loop_y_line:{LOOP Y START}
 mov al,col
 mov es:[di],al {PUNKT SETZEN}
 mov ax,&dx      {FEHLER + DX}
 add fehler,ax  {..}
 mov ax,&dy
 cmp fehler,ax
 jng @fehler_kleiner_dy
 {FEHLER > DY}
 mov ax,&dy    {diese Zeile ist unn”tig, aber zur Sicherheit}
 sub fehler,ax
 mov ax,inc_x
 add di,ax
 {ÄÄÄÄÄÄÄÄÄÄÄ}
 @fehler_kleiner_dy:
 mov ax,inc_y
 add di,ax
 dec cx
 jne @loop_y_line{LOOP X ENDE}
 @ende:
 pop ds
end;

procedure outtextxy2(x,y:word;texte:string;color:byte;var source);

var point:pointer;
    d,d2,x2,y2,d3,num:word;
    st:string;
    d21,len:byte;

procedure GetFontPointer (var p : pointer; font : byte); assembler;

asm
  push ds
  push bp
  mov  ax, 1130h
  mov  bh, font
  int  10h
  mov  ax, bp
  pop  bp
  lds  si, p
  mov  ds:[si], ax
  mov  ds:[si+02], es
  pop  ds
end;

procedure putpixel(x_1,y_1:integer ;col:byte;var source);

  ASSEMBLER;
  asm
  dec y_1
  dec x_1
  les di,source
  mov ax,320
  mul y_1
  add ax,x_1
  add di,ax
  mov al,col
  mov es:[di],al
  end;

begin
  getfontpointer(point,6);

  x2:=0;
  y2:=0;

  for len:=0 to length(texte)-1 do
  begin
    y2:=0;
    x2:=x+8*len;
    num:=ord(texte[len+1]);
    for d3:=0 to 15 do
     begin
       d21:=mem[seg(point^):ofs(point^)+num*16+d3];
       for d:=7 downto 0 do
           if (d21 shr d) mod 2 = 1 then putpixel(x+x2+7-d,y+y2,color,source);
       inc(y2);
     end;
    end;
  end;

begin
end.