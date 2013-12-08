{$R-}
uses _13h,_32bit,konrad,crt,raw;
const maxx=319;
      maxy=199;
      p:TPos=(x:160;y:100);
      shifter:byte=2;
var screen1,vimg:^tscreen;
    t:integer;
Procedure Init;
Begin
 maus_init;
 setmaus(0,199);
 Getmem(screen1,65535);
 filllongint(screen1^,65535,0);
 Getmem(vimg,64000);
 Init13h;
 for t:=1 to 255 do setmypalette(t,t shr 2,t shr 2,t shr 2);
 LoadRaw('voxel1.raw',vimg^);
End;

Procedure VLine(var dest;x,y:word;hoehe,col:byte);assembler;
asm
 push ds
 mov al,hoehe
 or al,al
 je @nix
 cmp al,100
 jg @nix
 les di,dest
 mov ax,320
 mul y
 add ax,x
 add di,ax
 mov al,col
 mov cx,word ptr hoehe
 @loop:
 mov es:[di],al
 sub di,320
 dec cx
 jne @loop
 @nix:
 pop ds
End;
Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
End;

Procedure Abfrage;
Begin
 maus_abfrage;maus.x:=maus.x shr 1;
 p.x:=maus.x;
 p.y:=maus.y;
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

Procedure Show;
const mul:word=5;
var x,y,h:integer;
    col:byte;
Begin
 if p.y>0 then
 for y:={p.y-150}0 to p.y do
 for x:=p.x to 319+p.x do
{  screen1^[,x]:=vimg^[y,p.x+x];}
{ if (x>=0) and (x<320) and (y>=0) and (y<200) then  }
 Begin
  if y=0 then y:=1;
  col:=vimg^[y mod 200,p.x+x];
  h:=round(col*(((100+y)/(p.y+100))));
  if h>190 then h:=190;
  VLine(screen1^,x,199,h,col);
 End;

End;

Procedure Main;
Begin
 repeat
  abfrage;
  show;
  waitretrace;
  movelongint(screen1^,screen,16000);
  filllongint(screen1^,16000,0);
 until taste=#27;
End;

begin
 Init;
 Main;
 Final;
end.