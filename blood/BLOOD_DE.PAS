uses konrad,crt,_32bit,_13h;
const
 w=5;
 h=5;
 blood1:array[0..w*h-1] of byte =
(0,1,1,1,0,
 1,1,2,1,1,
 1,2,2,2,1,
 1,1,2,1,1,
 0,1,1,1,0
 );
maxblood=400;
blood_anz:word=0;
var screen1,screen2:^tscreen;
    blood:array[1..maxblood] of TPos;
    dummy_line:array[0..319] of byte;
Procedure PutBlood(var src;x:word;y:word;var dest);assembler;
asm
 push ds
 lds si,src
 les di,dest
 mov ax,320
 mul y
 add ax,x
 add di,ax
 mov dx,h
@Loop_y:
 mov cx,w
 @Loop_x:
 mov al,ds:[si]
{ mov al,255}
 mov bl,230
 cmp es:[di],bl
 jae @weiter
 add es:[di],al
 @weiter:
 inc di
 inc si
 dec cx
 jne @Loop_x
 add di,320
 sub di,w
 dec dx
 jne @Loop_y
 pop ds
End;

Procedure Init;
var t:word;
Begin
 Init13h;
 fillchar(palette,768,0);
 for t:=0 to 255 do
 begin
  palette[t*3]:=(255-(t shr 2)) shr 2;
  palette[t*3+1]:=(255-t) shr 2;
  palette[t*3+2]:=(255-t) shr 2;
 end;
 Palette[255*3]:=63;
 Palette[255*3+1]:=63;
 Palette[255*3+2]:=63;
 setpal;
 getmem(screen1,64000);
 getmem(screen2,64000);
 filllongint(screen1^,16000,0);
 randomize;
 Maus_Init;
End;

Procedure NewBlood(x,y:word);
Begin
 If Blood_Anz<MaxBlood then
 Begin
  Inc(Blood_anz);
  Blood[Blood_anz].X:=x;
  Blood[Blood_anz].Y:=y;
  PutBlood(blood1,x,y,screen1^);
 End;
End;

Procedure MakeBlood;
var t:word;
Begin
 if blood_anz>0 then
 for t:=1 to blood_anz do with Blood[t] do
 Begin
  PutBlood(blood1,x,y,screen1^);
  Inc(y,1+Random(2));
  Inc(x,Random(3)-1);
{  if y>199-h+4 then
  Begin
   if t<>blood_anz then Move(Blood[t+1],Blood[t],(blood_anz-t)*sizeof(TPos));
   if blood_anz >0 then dec(blood_anz);
  End;}
 End;
End;

Procedure MoveLongintB(var src,dest;count:word);assembler;
asm
 push ds
 std
 mov ax,count
 shl ax,2
 lds si, src
 add si,ax
 les di, dest
 add di,ax
 mov cx, count
db 66h; rep movsw
 cld
 pop ds
end;


Procedure Main;
var t,w,i:word;count:longint;
Begin
 count:=0;
 repeat
 inc(i);inc(count);
 if count mod 3500=0 then
 Begin
  filllongint(screen1^,16000,0);
 End;
{ if b mod 3 = 0 then} inc(w,2);
  Maus_Abfrage;Maus.X:=Maus.X shr 1;
{  for t:=1 to 500 do PutBlood(blood1,random(300)+10,random(180)+10,screen1^);}
{  if maus.taste=1 then}
{  for t:=1 to 2 do NewBlood(maus.x+random(6)-3,maus.y+random(6)-3);}
  for t:=1 to 2 do NewBlood(random(310)+5,{random(50)}0);
{  if taste='b' then }
  MakeBlood;
  Movelongint(screen1^[199,0],dummy_line,80);
  MovelongintB(screen1^,screen1^[1,0],80*199);
  Movelongint(dummy_line,screen1^,80);
  Setmypalette(254,63,32+trunc(30*sin(w*pi/180)),0);
  Setmypalette(255,63,41+trunc(22*sin(w*pi/180)),0);

  Movelongint(screen1^,screen2^,16000);
  Outtextxy2(20,40+trunc(40*sin(w*pi/180)),'...-> Blood-Demo KH 1999 <-...',254,screen2^);
  Outtextxy2(0,100+trunc(80*sin(w*pi/180)),'...->  featuring Borland Pascal 7.0<-...',255,screen2^);
  waitretrace;
  movelongint(screen2^,screen,16000);
{  screen[maus.y,maus.x]:=255;}
   if keypressed then taste:=readkey;

 until taste=#27;
End;
Begin
 Init;
 Main;
 Textmode(3);
End.