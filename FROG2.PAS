uses crt,graph,init;
const f_anz=200;
      highfile=dbmpath+'frog.hi';
type highscore=record
                platz:array[0..8]of char;
                name:array[0..8]of string;
                punkte:array[0..8]of word;
               end;
var i:integer;farbe,rot:byte;high:highscore;sf:file of highscore;
    tsin,tcos:array[0..360]of byte;

procedure sorthigh;
var s:char;f:string;t,l1,l2:word;
begin
 with high do
 begin
  for l1:= 0 to 7 do for l2:= 0 to 7 do
  begin
   if punkte[l2] < punkte[l2+1] then
   begin
    s:=platz[l2];platz[l2]:=platz[l2+1];platz[l2+1]:=s;
    f:=name[l2];name[l2]:=name[l2+1];name[l2+1]:=f;
    t:=punkte[l2];punkte[l2]:=punkte[l2+1];punkte[l2+1]:=t;
   end;
  end;
 end;
end;

procedure openhi;
var s:byte;s2:string;
begin
 assign(sf,highfile);
{rewrite(sf);
 for s:= 0 to 8 do
 begin
  high.punkte[s]:=0;
  str(s+1,s2);
  high.platz[s]:=s2[1];
  high.name[s]:='Mr. x';
 end;
 sorthigh;
 write(sf,high);{}
 reset(sf);
 read(sf,high);{}
 sorthigh;
 close(sf);
end;

procedure newhi;
begin
 assign(sf,highfile);
 rewrite(sf);
 write(sf,high);
 sorthigh;
 close(sf);
end;

procedure showhigh;
var s:byte;s2:string;
begin
 sorthigh;
 with high do
 begin
  for s:= 0 to 8 do
  begin
   str(punkte[s],s2);
   outtextxy(260,s*50+20,platz[s]+'. '+name[s]+' '+s2);
  end;
 end;
end;

function betrag(x:integer):integer;
begin
betrag:=x;
if x<0 then betrag:=-x;
end;

procedure init2;
var gd,gm:integer;
begin
 gd:=installuserdriver('svga386',nil);
 gm:=1;
 initgraph(gd,gm,'C:\bp\bgi');
 randomize;
end;

procedure start;

var p:pointer;taste:char;x,y,jump:word;b:boolean;
    fx,fy:array[1..f_anz] of word;f_live:array[1..f_anz] of boolean;
    allefliegentot:boolean;bl,br,punkte:integer;pk:string;winkel:word;f2:byte;

procedure weiter;
var s,s3:byte;s2:string;
begin
 setcolor(rot);
 settextstyle(triplexfont,0,6);
 if punkte>-1000 then outtextxy(0,10,'Mission erfÅllt') else outtextxy(0,10,'Sie sind Verhungert !');
 delay(2500);
 cleardevice;
 settextjustify(1,1);
 for s:= 0 to 8 do
 begin
  if high.punkte[s] < punkte then
  begin
   if s < 8 then
   str(s+1,s2);
   for s3:= s+1 to 8 do
   begin
    high.platz[s3+1]:=high.platz[s3];
    high.name[s3+1]:=high.name[s3];
    high.punkte[s3+1]:=high.punkte[s3];
   end;
   high.punkte[s]:=punkte;
   s3:=s;
   break;
  end;
 end;
 outtextxy(getmaxx div 2,getmaxy div 2-100,'Name: ('+s2+'. Platz)');
 graareade(getmaxx div 2,getmaxy div 2,high.name[s3]);
{sorthigh;}
 newhi;
 cleardevice;
 showhigh;
 readkey;
 closegraph;
 halt;
end;

procedure froginit;
var f:file;dac:tdacblock;x,y,b:byte;s:word;
begin
 assign(f,dbmpath+'frosch.dbm');
 reset(f,1);
 blockread(f,dac,768);
 for y:= 101 to 255 do
 begin
  dac[y][0]:=y;
  dac[y][1]:=0;
  dac[y][2]:=0;
 end;
 rot:=255;
 setdacblock(0,256,dac);
 for y:= 0 to 39 do for x:= 0 to 39 do
 begin
  blockread(f,b,1);
  putpixel(x,y,b);
  if (x = 13) and (y = 3) then farbe:=b;
  if (x = 1) and (y = 0) then putpixel(0,0,b);
 end;
 getmem(p,imagesize(0,0,39,39));
 getimage(0,0,39,39,p^);
 for s:= 0 to 360 do
 begin
  tsin[s]:=round(sin(s*pi/180)*80);
  tcos[s]:=round(cos(s*pi/180)*80);
 end;
end;

procedure feuer(x,y,winkel:word);
var w:integer;
begin
 for w:= winkel-15 to winkel+15 do
 begin
  setcolor(255-w+1);
  line(x,y,x+tcos[w],y+tsin[w]);
 end;
end;

procedure fweg(x,y,winkel:word);
var w:integer;
begin
 for w:= winkel-15 to winkel+15 do
 begin
  setcolor(0);
  line(x,y,x+tcos[w],y+tsin[w]);
 end;
end;

begin
 setgraphmode(3);
 froginit;
 x:=0;
 y:=0;
 jump:=0;
 bl:=0;
 br:=0;
 b:=true;
 winkel:=15;
 punkte:=1000;
 for i:=1 to f_anz do f_live[i]:=true;
 for i:=1 to f_anz do fx[i]:=random(getmaxx);
 for i:=1 to f_anz do fy[i]:=random(getmaxy);
 settextstyle(defaultfont,0,1);
 repeat
  {                     FLIEGENsteuerung }
  allefliegentot:=true;
  for i:=1 to f_anz do if f_live[i]=true then allefliegentot:=false;
  if allefliegentot=true then weiter;
  for i:=1 to f_anz do if f_live[i]=true then
   begin
    putpixel(fx[i],fy[i],black);
    putpixel(fx[i]+1,fy[i]+1,black);
    putpixel(fx[i]+1,fy[i],black);
    putpixel(fx[i],fy[i]+1,black);
    fx[i]:=fx[i]+random(7)-3;
    fy[i]:=fy[i]+random(7)-3;
    if fx[i] > getmaxx then fx[i]:=getmaxx;
    if fy[i] > getmaxy then fy[i]:=getmaxy;
    if fx[i] < 0 then fx[i]:=0;
    if fy[i] < 0 then fy[i]:=0;
    putpixel(fx[i],fy[i],farbe);
    putpixel(fx[i]+1,fy[i]+1,farbe);
    putpixel(fx[i]+1,fy[i],farbe);
    putpixel(fx[i],fy[i]+1,farbe);
    if ((f_live[i]=true) and (betrag(x-fx[i])<40) and (betrag(y-fy[i])<40)) then
    begin
     setcolor(rot);
     line(x+17,y+18,fx[i],fy[i]);
     delay(100);
     setcolor(black);
     line(x+17,y+18,fx[i],fy[i]);
     putpixel(fx[i],fy[i],black);
     putpixel(fx[i]+1,fy[i]+1,black);
     putpixel(fx[i]+1,fy[i],black);
     putpixel(fx[i],fy[i]+1,black);
     f_live[i]:=false;
     punkte:=punkte+35;
     setcolor(farbe);
     outtextxy(0,0,'Punkte:');
    end;
   end;
{       ENDE der FLIEGENsteuerung        }
  delay(5);
  if f2 > 0 then dec(f2) else fweg(x,y,winkel);
  if b=true then dec(punkte);
  str(punkte,pk);
  setcolor(black);
  outtextxy(64,0,'€€€€€€');
  setcolor(farbe);
  outtextxy(64,0,pk);
  if punkte<-999 then weiter;
  if b=true then b:=false;
  if b=false then b:=true;
  if y<430 then inc(y);
  if jump>0 then dec(jump);
  if jump>0 then y:=y-3;
  if (bl>0) and (b=true)  then dec(bl);
  if (br>0) and (b=true) then dec(br);
  taste:=#0;
  if keypressed then taste:=readkey;
  case taste of
   #75:bl:=27;
   #77:br:=27;
   #72:if y=430 then jump:=200;
   #32:begin
        feuer(x,y,winkel);
        f2:=5;
       end;
  end;
  if ((br>0) and (b=true)) and (x < getmaxx-40) then x:=x+1;
  if ((bl>0) and (b=true)) and (x>0) then x:=x-1;
  putimage(x,y,p^,normalput);
 until taste=#27;
 freemem(p,imagesize(0,0,39,39));
end;

procedure mainprog;
begin
 init2;
 openhi;
 start;
 closegraph;
end;

begin
 mainprog;
end.