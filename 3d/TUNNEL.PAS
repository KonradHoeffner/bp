uses _32bit,crt,konrad,_13h,_3d,ublood,flames;
const zoom:integer=256;
      dist:integer=100;
      max=2000;
      anz=max;
      maxz=3000;
      minz=30;
      speed=75;
      count:word=0;
      dosoft:boolean=true;
var p:array[1..max] of TPos3d;
    vp:array[1..max] of TPos;
    screen1:^tscreen;
    t:integer;
Procedure PutBlood(var src;x,y:integer;var dest);assembler;
asm
 push ds
 push es
 lds si,src
 les di,dest
 mov ax,320
 mul y
 add ax,x
 add di,ax
 mov dx,blh
@Loop_y:
 mov cx,blw
 @Loop_x:
 mov al,ds:[si]
{ mov al,255}
 mov bl,225
 cmp es:[di],bl
 jae @weiter
 add es:[di],al
 @weiter:
 inc di
 inc si
 dec cx
 jne @Loop_x
 add di,320
 sub di,blw
 dec dx
 jne @Loop_y
 pop es
 pop ds
End;


Procedure InitPositions;
var t:longint;
Begin
 for t:=1 to anz do with p[t] do
 begin
  z:=minz+maxz/anz*t;
  x:=round(cos(2*pi*t/anz)*100);
  y:=round(sin(2*pi*t/anz)*100);
 end;
End;

Procedure Init;
var t:word;
Begin
 Randomize;
 Getmem(screen1,64000);
 Init13h;
 for t:=1 to 230 do setmypalette(t,(t) shr 2,(t) shr 2,0);
 InitTables;
 InitPositions;
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
End;

Procedure Abfrage;
Begin
 if keypressed then
 begin
  taste:=readkey;
  case taste of
   's':dosoft:=not dosoft;
  end;
 end else taste:='n';
End;

Procedure InitP(nr:word);
Begin
 inc(count);
 with p[nr] do
 begin
  x:=round(cos(count+random*0.3)*100);
  y:=round(sin(count+random*0.3)*100);
  z:=maxz-random(100);
 end;
End;

Procedure Move;
var t:integer;
Begin
 for t:=1 to max do with p[t] do if z>minz then
 begin
  z:=z-speed;
  rotatez(p[t],3);
 end else initp(t);


End;

Procedure Show(var dest:tscreen);
var t:word;
Begin
 for t:=1 to anz-1 do with vp[t] do
 if (x>0) and (x<320) and (y>0) and (y<200)
 and (vp[t+1].x>0) and (vp[t+1].x<320) and (vp[t+1].y>0) and (vp[t+1].y<200)
 then
  if (x<>vp[t+1].x) and (y<>vp[t+1].y) and (p[t+1].z<maxz-100) and (p[t].z<maxz-100)
  and (p[t+1].z>minz) and (p[t].z>minz) then
  line(dest,x,y,vp[t+1].x,vp[t+1].y,15+round((210)*p[t+1].z/maxz));

 if dosoft then
 for t:=1 to anz do with vp[t] do
  if (x>10) and (x<310) and (y>10) and (y<190)
   then putblood(blood1,x,y,dest){ else initp(t)};

End;

Procedure Main;
Begin
  filllongint(screen1^,16000,0);
 repeat
  abfrage;
  move;
  makevis(p,vp,anz,dist,zoom);
  show(screen1^);
  scroll_up(screen1^,screen1^);
  waitretrace;
  filllongint(screen1^[199,0],80,0);
  movelongint(screen1^,screen,16000);
{  filllongint(screen1^,16000,0);}
 until taste=#27;
End;

begin
 Init;
 Main;
 Final;
end.
begin

end.