uses crt,graph,ktools;
const maxkugeln=50;
      var i:word;
    kugeln:array[1..maxkugeln] of record
                            index:boolean;
                            x:longint;
                            y:word;
                            speedx,speedy:integer;
                           end;
    winkel:byte;
    zaehl:byte;
procedure init;
begin
 svga3(0);
 setrgbpalette(1,255,255,255);
 winkel:=90;
 zaehl:=0;
 for i:=1 to maxkugeln do
  kugeln[i].index:=false;
end;

procedure feuer;
begin
for i:=maxkugeln-1 downto 1 do
 begin
  kugeln[i+1].index:=true;
  kugeln[i+1].x:=       kugeln[i].x;
  kugeln[i+1].y:=       kugeln[i].y;
  kugeln[i+1].speedx:=  kugeln[i].speedx;
  kugeln[i+1].speedy:=  kugeln[i].speedy;
 end;
 kugeln[1].index:=true;
 kugeln[1].x:=(159+trunc(cos(winkel*pi/180)*10))shl 8;
 kugeln[1].y:=(199-trunc(sin(winkel*pi/180)*10)) shl 8;
 kugeln[1].speedx:=trunc(-cos(winkel*pi/180)*255);
 kugeln[1].speedy:=trunc(sin(winkel*pi/180)*255);

end;

procedure mainprog;
var taste:char;

    s:string;
begin

 repeat
 taste:=#1;
 inc(zaehl);
 if keypressed then
 begin
  taste:=readkey;
  setcolor(0);
  outtextxy(0,0,'ллл');
  line(159,199,159+trunc(cos(winkel*pi/180)*10),199-trunc(sin(winkel*pi/180)*10));
  case taste of
   #75:if winkel <180   then inc(winkel);
   #77:if winkel >0 then dec(winkel);
   #32:feuer;
  end;
  setcolor(1);
  line(159,199,159+trunc(cos(winkel*pi/180)*10),199-trunc(sin(winkel*pi/180)*10));
  str(winkel,s);
  outtextxy(0,0,s);
 end;

 for i:=1 to maxkugeln do
 begin

  if (kugeln[i].x shr 8 <320) and (kugeln[i].y shr 8 <200) then  putpixel(kugeln[i].x shr 8,kugeln[i].y shr 8,0);
  if kugeln[i].index=false then break;

  if kugeln[i].speedx >0 then dec(kugeln[i].speedx) else if kugeln[i].speedx <0 then inc(kugeln[i].speedx);

  if kugeln[i].speedy-abs(kugeln[i].speedx div 128) >=-255
  then dec(kugeln[i].speedy,abs(kugeln[i].speedx div 128)) {Schwerkraft von grav Pixel/Bildaufbau}
  else kugeln[i].speedy:=-255;

  dec(kugeln[i].x,kugeln[i].speedx);
  dec(kugeln[i].y,kugeln[i].speedy);
  if (kugeln[i].x shr 8 <320) and (kugeln[i].y shr 8 <200) then  putpixel(kugeln[i].x shr 8,kugeln[i].y shr 8,1);
 end;

 if zaehl mod 2 =0 then waitvret;
 until taste=#27;
end;


begin
init;
mainprog;
closegraph;
end.