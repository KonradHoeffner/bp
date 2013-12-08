uses graph,crt,konrad,_32bit,picture;
const maxanz=10;
      radius=65;
var p:array[1..maxanz] of record
                           x,y,entf:word;
                           winkel:real;
                          end;

    gd,gm:integer;
    t,w:word;
    mx,my:word;
    q:array[1..2] of record x,y:word; u:record a:record t:word; end; end; end;
    screen:tscreen absolute $a000:0;
const anz:byte=4;

function mitentf(x,y:word):word;
begin
 mitentf:=round(sqrt(sqr(abs(x-mx)+sqr(abs(y-my)))));
end;

procedure berech;
begin
  for t:=1 to anz do with p[t] do
  begin
   x:=mx+round(cos(winkel*pi/180)*entf);
   y:=my+round(sin(winkel*pi/180)*entf);
  end;
end;

procedure zeich;
begin
 for t:=1 to anz-1 do with p[t] do
 begin
{  putpixel(mx+x,my+y,15);}
  setcolor(15);
  line(x,y,p[t+1].x,p[t+1].y);
 end;
 line(p[anz].x,p[anz].y,p[1].x,p[1].y);
{ setfillstyle(1,blue);
 floodfill(mx,my,15);}
end;

procedure loesch;
begin
 for t:=1 to anz-1 do with p[t] do
 begin
  putpixel(x,y,0);
  setcolor(0);
  line(x,y,p[t+1].x,p[t+1].y);
 end;
 line(p[anz].x,p[anz].y,p[1].x,p[1].y);
{ setfillstyle(1,0);
 floodfill(mx,my,15);}
{ cleardevice;}
 {filllongint(mem[$a000:0],16000,0);}
end;
 procedure winkinit;
 begin
  for t:=1 to anz do p[t].winkel:=(360/anz)*t;
 end;

begin
 gd:=installuserdriver('svga256',nil);
 gm:=0;
 initgraph(gd,gm,'c:\bp\bgi');
 mx:=getmaxx shr 1;
 my:=getmaxy shr 1;
 { p[1].winkel:=0;
 p[2].winkel:=90;
 p[3].winkel:=180;
 p[4].winkel:=270;}
 winkinit;
 for t:=1 to maxanz do with p[t] do entf:=radius{+random(40)};
 repeat
  for t:=1 to anz do p[t].winkel:=p[t].winkel+1;
  berech;
  zeich;
  screen[100,160]:=15;
  waitretrace;
  loesch;
 if keypressed then taste:=readkey else taste:='n';
 if (taste='+') and (anz<maxanz) then begin inc(anz); winkinit; end;

 if taste='-' then begin dec(anz); winkinit; end;
 until taste=#27;
end.