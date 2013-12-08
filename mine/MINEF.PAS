uses crt,konrad,_32bit,graphic;
var palette:array[0..767] of byte;
    t,w,u,anz:word;
    b,y:byte;
    screen1:^screen_type;
{    feld:array}
    s:string;
   f:text;
  anfang:array[1..100] of record
                           x,y:byte;
                          end;
type tstein=array[0..99] of byte;
const
anzx=5;
anzy=5;
anzx2=8;
anzy2=8;
maus1:array[0..4,0..4] of byte=
                        ((0,0,4,0,0),
                         (0,0,4,0,0),
                         (4,4,0,4,4),
                         (0,0,4,0,0),
                         (0,0,4,0,0));

maus2:array[0..7,0..7] of byte=
                        ((0,0,0,0,0,0,0,0),
                         (0,0,0,0,0,0,0,0),
                         (0,0,0,0,0,0,0,0),
                         (0,0,0,0,0,0,0,0),
                         (0,0,0,0,0,0,0,0),
                         (0,0,0,0,0,0,0,0),
                         (0,0,0,0,0,0,0,0),
                         (0,0,0,0,0,0,0,0));


stein1:tstein=
(1,1,1,1,1,1,1,1,1,1,
 1,2,2,2,2,2,2,2,2,3,
 1,2,2,2,2,2,2,2,2,3,
 1,2,2,2,2,2,2,2,2,3,
 1,2,2,2,2,2,2,2,2,3,
 1,2,2,2,2,2,2,2,2,3,
 1,2,2,2,2,2,2,2,2,3,
 1,2,2,2,2,2,2,2,2,3,
 1,2,2,2,2,2,2,2,2,3,
 1,3,3,3,3,3,3,3,3,3);

stein2:tstein=
(2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2,
 2,2,2,2,2,2,2,2,2,2);

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

 procedure savescreen(x1,y1,x2,y2:word);
 var y:word;
 begin
    for y:=y1 to y2 do move(screen[y,x1],screen1^[y,x1],x2-x1);
 end;

 procedure loadscreen(x1,y1,x2,y2:word);
 var y:word;
 begin
  for y:=y1 to y2 do move(screen1^[y,x1],screen[y,x1],x2-x1);
 end;

 procedure putmaus;
 var x,y:word;
 begin
  savescreen(maus.x-2,maus.y-2,maus.x-2+anzx,maus.y-2+anzy);
  for x:=0 to anzx-1 do
   for y:=0 to anzy-1 do
    if maus1[x,y]>0 then screen[y+maus.y-2,x+maus.x-2]:=maus1[x,y];
 end;

  procedure putmaus2;
 var x,y:word;
 begin
  for y:=maus.y-2 to maus.y+anzy2-2 do move(screen[y,maus.x-2],screen1^[y,maus.x-2],anzx2);
  for x:=0 to anzx2-1 do
   for y:=0 to anzy2-1 do
    if maus2[x,y]>0 then screen[y+maus.y-2,x+maus.x-2]:=maus2[y,x];
 end;

 procedure loeschmaus;
 var x,y:word;
 begin
  loadscreen(maus.x-2,maus.y-2,maus.x-2+anzx,maus.y-2+anzy);
 end;

  procedure loeschmaus2;
 var x,y:word;
 begin
  for y:=maus.y-2 to maus.y+anzy2-2 do move(screen1^[y,maus.x-2],screen[y,maus.x-2],anzx2);
 end;

procedure putblock(x,y:word;source:array of byte;var dest:screen_type);
var t:word;
begin
 for t:=0 to 9 do move(source[t*10],dest[y+t,x],10);
end;

procedure pmaus;
var x,y:word;
    s,s2:string;
procedure writecoords;
begin
  x:=maus.x div 11+1;
  y:=maus.y div 10+1;
  str(x,s);
  str(y,s2);
  s:=s+' '+s2;
  outtextxy2(1,0,s,4,screen);
end;

begin
  maus_abfrage;
  maus.x:=maus.x shr 1;
  savescreen(0,0,60,10);
  putmaus;
  waitretrace;
  loeschmaus;
  loadscreen(0,0,60,10);
end;

procedure init;
var r:word;
begin
assign(f,'anfang.blk');
reset(f);
getmem(screen1,64000);
randomize;
asm
 mov ax,13h
 int 10h
end;
 fillchar(palette,768,0);
 palette[1*3]:=63;
 palette[1*3+1]:=63;
 palette[1*3+2]:=63;

 palette[2*3]  :=33;
 palette[2*3+1]:=33;
 palette[2*3+2]:=33;

 palette[3*3]  :=23;
 palette[3*3+1]:=23;
 palette[3*3+2]:=23;

 palette[4*3]  :=63;
 palette[4*3+1]:=0;
 palette[4*3+2]:=0;
 setpal;
 t:=0;
 filllongint(screen1^,16000,0);
for b:=1 to 190 do
 begin
  for y:= 1 to 20 do for t:=0 to 28 do
   if (y*10+b-200>0) and (y*10+b-200<191) then putblock(t*11,y*10+b-200,stein1,screen1^);
{  waitretrace;}
  movelongint(screen1^,screen,16000);
  fillchar(screen1^,16000,0);
 end;
 for t:=0 to 28 do putblock(t*11,0,stein1,screen);
 maus_init;
end;

procedure final;
begin
 freemem(screen1,64000);
 textmode(3);
 close(f);
end;

procedure lade;
begin
 assign(f,'anfang.blk');
 reset(f);

end;

begin
 init;
 lade;
 repeat
  pmaus;
 until keypressed;
 final;
end.