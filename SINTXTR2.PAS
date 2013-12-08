uses crt,saveload,ktools;

type screent=array[0..199,0..319] of byte;
var i,j:word;
    rotx,roty:integer;
    rsin,rcos:array[0..359] of real;
    bx,by:boolean;
    screen:^screent;
procedure init;
var gd,gm:integer;
begin
  asm
  mov ax,13h
  int 10h
 end;
 loadpcx256(0,0,'c:\konrad\bp\buch\phint.pcx');
 getmem(screen,64000);
 move(mem[$a000:0],screen^,64000);
 fillchar(mem[$a000:0],64000,0);
 randomize;

 for i:=0 to 359 do rcos[i]:=cos(i*pi/180);
 for i:=0 to 359 do rsin[i]:=sin(i*pi/180);

end;

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

procedure mainprog;
begin

 repeat
   if rotx>359 then bx:=false;
   if roty>359 then by:=false;

   if rotx<1 then bx:=true;
   if roty<1 then by:=true;

  if bx= true then inc(rotx,2) else dec(rotx);
  if by= true then inc(roty) else dec(roty);





 for i:=0 to 319 do for j:=0 to 199 do
 putpixel(abs(trunc(screen^[0,i]*rcos[rotx]-rsin[roty])),
 320*(abs(trunc(screen^[i,0]*rsin[roty]-rcos[rotx]))),screen^[j,i]);






 waitvret;



 until keypressed;
end;


begin
 init;
 mainprog;
 textmode(3);
end.