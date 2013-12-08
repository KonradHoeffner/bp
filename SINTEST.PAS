uses crt,modexlib,ktools;
const punktanz=1000;
      getmaxx=319;
      getmaxy=199;
var i:word;
    punkte,punkte2:array[1..punktanz] of record
                                 x,y:integer;
                                 z:byte;
                                 end;
    rotx,roty:integer;
    rsin,rcos:array[0..359] of real;
    fx,fy:boolean;


Procedure PutPixel(x,y,col:word);assembler;
{setzt Punkt (x/y) auf Farbe col (Mode 13h)}
asm
  mov ax,0a000h                 {Segment laden}
  mov es,ax
  mov ax,320                    {Offset = Y*320 + X}
  mul y
  add ax,x
  mov di,ax                     {Offset laden}
  mov al,byte ptr col           {Farbe laden}
  mov es:[di],al                {und Punkt setzen}
End;

procedure init;
var gd,gm:integer;
begin
 randomize;
 asm
  mov ax,13h
  int 10h
 end;
 for i:=0 to 255 do
 begin
  palette[i*3]:=i;
  palette[i*3+1]:=i;
  palette[i*3+2]:=i;
 end;
 setpal;
 for i:=0 to 359 do rcos[i]:=cos(i*pi/180);
 for i:=0 to 359 do rsin[i]:=sin(i*pi/180);

end;

procedure mainprog;
begin
 for i:=1 to punktanz do
 with punkte[i] do
 begin
  x:=random(getmaxx+1);
  y:=random(getmaxy+1);
  z:=random(255)+1;
 end;

 repeat
 asm
  cmp rotx,358          {>359? ->Richtung umkehren (fx/y->0)}
  jle @l1
  mov fx,0
  @l1:
  cmp roty,359
  jle @l2
  mov fy,0
  @l2:

  cmp rotx,1           {<1? ->Richtung umkehren (fx/y->1)}
  jnl @l3
  mov fx,1
  @l3:
  cmp roty,1
  jnl @l4
  mov fy,1
  @l4:

  cmp fx,0
  jz @l5
  add rotx,4
  @l5:
  sub rotx,2
  cmp fy,0
  jz @l6
  add roty,2
  @l6:
  sub roty,1
 end;


 for i:=1 to punktanz do
 putpixel(abs(trunc(punkte[i].x*rcos[rotx]-rsin[roty]*punkte[i].z+punkte[i].z shr 5)),
 abs(trunc(punkte[i].y*rsin[roty]+rcos[rotx]*punkte[i].z+punkte[i].z)),punkte[i].z);

 waitvonly;

 for i:=1 to punktanz do
 putpixel(abs(trunc(punkte[i].x*rcos[rotx]-rsin[roty]*punkte[i].z+punkte[i].z shr 5)),
 abs(trunc(punkte[i].y*rsin[roty]+rcos[rotx]*punkte[i].z+punkte[i].z)),0);



 until keypressed;
end;


begin
 init;
 mainprog;
 textmode(3);
end.