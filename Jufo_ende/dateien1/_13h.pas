{$R-}{$Q-}{$G+}
unit _13h;
interface

procedure put13h(var source;x,y:word;farbe:byte);
{setzt einen Punkt der Farbe "farbe" an x,y im Graphikmodus $13}
Procedure Line(var d;x1,y1,x2,y2:integer;col:byte);
{Linienalgorithmus nach Bresenham,
Zum Verstehen der Funktionsweise: s. Line_old, da
Line von Line_old zur Geschwindigkeitssteigerung
in Assembler umgeschrieben wurde}
procedure HLine(var d;x1,y1,x2:integer;col:byte);
{zeichnet eine horizontale Linie}
procedure VLine(var d;x1,y1,y2:integer;col:byte);
{zeichnet eine vertikale Linie}
implementation

procedure HLine(var d;x1,y1,x2:integer;col:byte);assembler;
asm
 push es
 les di,d
 mov ax,320
 mul y1
 add ax,x1
 add di,ax
 mov ax,x2
 sub ax,x1
 inc ax
 shr ax,1
 mov cx,ax
 mov al,col
 mov ah,al
 jnc @weiter
 stosb
 @weiter:
 rep stosw
 pop es
End;

procedure VLine(var d;x1,y1,y2:integer;col:byte);assembler;
asm
 push es
 les di,d
 mov ax,320
 mul y1
 add ax,x1
 add di,ax
 mov cx,y2
 sub cx,y1
 inc cx
 mov al,col
 @loop_y:
 mov es:[di],al
 add di,320
 dec cx
 jne @loop_y
 pop es
end;

Procedure Line(var d;x1,y1,x2,y2:integer;col:byte);assembler;
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
 les di,d
 add di,ofs
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

Procedure Line_old(seg:word;x1,y1,x2,y2:integer;col:byte);
const fehler:integer=0;
var t,
    dx,dy,
    inc_x,inc_y:integer;
    ofs:word;

begin
{1. Offsets und Deltas vorberechnen}
 dx:=x2-x1;
 dy:=y2-y1;
 ofs:=320*y1+x1;
{Richtung bestimmen}
 if dx>=0 then inc_x:=1 else
 begin
  inc_x:=-1;
  dx:=-dx;
 end;
 if dy>=0 then inc_y:=320 else
 begin
  inc_y:=-320;
  dy:=-dy;
 end;
{Linie zeichnen}
 if dx>dy then
{DX>DY-Linie}
 for t:=0 to dx do
 begin
  mem[seg:ofs]:=col;
  inc(fehler,dy);
  if fehler>dx then
  begin
   dec(fehler,dx);
   inc(ofs,inc_y);
  end;
  inc(ofs,inc_x)
 end
  else
{DY>DX-Linie}
 for t:=0 to dy do
 begin
  mem[seg:ofs]:=col;
  inc(fehler,dx);
  if fehler>dy then
  begin
   dec(fehler,dy);
   inc(ofs,inc_x);
  end;
  inc(ofs,inc_y);
 end;
end;

procedure put13h(var source;x,y:word;farbe:byte);assembler;
asm
 les di,source
 mov ax,320
 mul y
 add ax,x
 add di,ax
 mov al,farbe
 mov es:[di],al;
end;

end.