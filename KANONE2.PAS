uses crt,graph;
const maxkugeln=100;
      minpower=2;
var i,j,k:word;
    kugeln:array[1..maxkugeln] of record
                            index:boolean;
                            x,y:longint;

                            power:byte;
                            speedx,speedy:integer;
                           end;
    winkel,zaehl:byte;
    b:boolean;


procedure mainprog;
var taste:char;
    s:string;

procedure init;
var gd,gm:integer;
begin
 gd:=installuserdriver('svga386',nil);
 gm:=0;
 initgraph(gd,gm,'C:\bp\bgi');
 setrgbpalette(1,255,255,255);
 for i:=minpower to 64 do setrgbpalette(i,i,0,255-i);
 for i:=65 to 255 do setrgbpalette(i,255-i+i shr 3,i shr 3,i);
 winkel:=90;
 zaehl:=0;
 for i:=1 to maxkugeln do
  kugeln[i].index:=false;
end;

procedure feuer;
begin

 for i:=1 to maxkugeln-1 do kugeln[i]:=kugeln[i+1];
   kugeln[maxkugeln].index:=true;
   kugeln[maxkugeln].power:=255;
   kugeln[maxkugeln].x:=(159-trunc(cos(winkel*pi/180)*10))shl 8;
   kugeln[maxkugeln].y:=(199-trunc(sin(winkel*pi/180)*10)) shl 8;
   kugeln[maxkugeln].speedx:=trunc(cos(winkel*pi/180)*255);
   kugeln[maxkugeln].speedy:=trunc(sin(winkel*pi/180)*255);

end;

procedure kugelweg(kugel:word);
begin
  for j:=i to maxkugeln-1 do kugeln[j]:=kugeln[j+1];
  kugeln[maxkugeln].index:=false;
end;


begin
 init;
 repeat
  for i:=1 to maxkugeln do if zaehl mod 3=0 then
  if kugeln[i].power >0 then dec(kugeln[i].power)
                       else kugelweg(i);
  taste:=#1;
  inc(zaehl);
  if keypressed then
  begin
   taste:=readkey;
   setcolor(0);

   case taste of
    #75:if winkel >0   then
    begin
     outtextxy(0,0,'ллл');
     line(159,199,159-trunc(cos(winkel*pi/180)*10),199-trunc(sin(winkel*pi/180)*10));
     dec(winkel,2);
     setcolor(1);
     line(159,199,159-trunc(cos(winkel*pi/180)*10),199-trunc(sin(winkel*pi/180)*10));
     str(winkel,s);
     outtextxy(0,0,s);

    end;

    #77:if winkel <180 then
    begin
     outtextxy(0,0,'ллл');
     line(159,199,159-trunc(cos(winkel*pi/180)*10),199-trunc(sin(winkel*pi/180)*10));
     inc(winkel,2);
     setcolor(1);
     line(159,199,159-trunc(cos(winkel*pi/180)*10),199-trunc(sin(winkel*pi/180)*10));
     str(winkel,s);
     outtextxy(0,0,s);
    end;

    #32:
    begin
     b:=false;
     for i:=1 to maxkugeln do if kugeln[i].index=false then begin b:=true; break; end;
     if b=true then feuer;
    end;

   end;
  end;

  for i:=1 to maxkugeln do
  begin
   if (kugeln[i].x shr 8 <320) and (kugeln[i].y shr 8 <200) then  putpixel(kugeln[i].x shr 8,kugeln[i].y shr 8,0)
    else kugelweg(i);



   dec(kugeln[i].x,kugeln[i].speedx);
   dec(kugeln[i].y,kugeln[i].speedy);
   if (kugeln[i].x shr 8 <320) and (kugeln[i].y shr 8 <200)
   then  putpixel(kugeln[i].x shr 8,kugeln[i].y shr 8,kugeln[i].power);

  end;

  repeat until (port[$3da] and 8) =0;
  repeat until (port[$3da] and 8) >0;
  until taste=#27;
 closegraph;
end;


begin
mainprog;
end.