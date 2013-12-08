uses konrad,crt,graphic,_32bit;
const c_anz_x=30;
      c_anz_y=30;
      c_scal_x=5;
      c_scal_y=5;
      anz_blocks=(c_anz_x*c_anz_y) div 10;
type tfeld=array[1..c_anz_x,1..c_anz_y] of byte;
     tpos=record
           x,y:word;
          end;
var feld,feld_h:tfeld;
    t,r,w,xd,yd:word;
    start,ziel:tpos;
    frame:^screen_type;
procedure rectangle_opt(x1,y1,x2,y2:word;farbe:byte);
begin
 filllongint(screen[y1,x1],(x2-x1) shr 2,farbe);
 filllongint(screen[y2,x1],(x2-x1) shr 2,farbe);
 asm
  mov ax,0a000h
  mov es,ax
  mov ax,320
  mul y1
  add ax,x1
  mov di,ax
  mov al,farbe
  mov ah,al
  mov cx,y2
  mov bx,x2
{Ecken}
  add di,bx
  sub di,3
  stosw
  stosb
  sub di,bx
{-----}
  sub cx,y1
  sub bx,x1
  @loop1:
   mov es:[di],al
   add di,bx
   mov es:[di],al
   sub di,bx
   add di,320
   dec cx
  jne @loop1
 end;
end;

procedure rectangle(x1,y1,x2,y2:word;farbe:byte);
begin
 fillchar(screen[y1,x1],x2-x1,farbe);
 fillchar(screen[y2,x1],x2-x1,farbe);
 asm
  mov ax,0a000h
  mov es,ax
  mov ax,320
  mul y1
  add ax,x1
  mov di,ax
  mov al,farbe
  mov ah,al
  mov cx,y2
  mov bx,x2
  sub cx,y1
  sub bx,x1
  @loop1:
   mov es:[di],al
   add di,bx
   mov es:[di],al
   sub di,bx
   add di,320
   dec cx
  jne @loop1
 end;
end;

procedure fillrect(x1,y1,x2,y2:word;farbe:byte);
var q:word;
begin
 for q:=y1 to y2 do fillchar(screen[q,x1],abs(x2-x1),farbe);
end;

procedure putf;
begin


 for t:=1 to c_anz_x do for r:=1 to c_anz_y do if feld[t,r]=0 then
 fillrect(t*c_scal_x,r*c_scal_y,(t+1)*c_scal_x,(r+1)*c_scal_y,darkgray)
 else
 fillrect(t*c_scal_x,r*c_scal_y,(t+1)*c_scal_x,(r+1)*c_scal_y,red);

 fillrect(1,1,300,30,15);
 with start do fillrect(x*c_scal_x,y*c_scal_y,(x+1)*c_scal_x,(y+1)*c_scal_y,yellow);
 with ziel do fillrect(x*c_scal_x,y*c_scal_y,(x+1)*c_scal_x,(y+1)*c_scal_y,15);

end;

procedure eingabe;
begin
 write('Start.x: ');readln(start.x);
 write('Start.x: ');readln(start.y);
 write('Ziel.x: ');readln(ziel.x);
 write('Ziel.x: ');readln(ziel.y);
end;

procedure prep_feld;
begin
 fillchar(feld,c_anz_x*c_anz_y,0);
 for t:=1 to anz_blocks do
 begin
  xd:=random(c_anz_x)+1;
  yd:=random(c_anz_y)+1;
  while
  feld[xd,yd]=1 do
  begin
  xd:=random(c_anz_x)+1;
  yd:=random(c_anz_y)+1;
  end;
  feld[xd,yd]:=1;
 end;
 feld[start.x,start.y]:=0;
 feld[ziel.x,ziel.y]:=0;
end;

begin
 getmem(frame,64000);
 randomize;
 eingabe;
 prep_feld;
 init13h;
 repeat
  waitretrace;
  putf;

 until keypressed;
 freemem(frame,64000);
 textmode(3);
end.