uses konrad,crt,graph,_32bit,mausu;
label l_start;
const zufall:boolean=false;
      blocksselbst=true;
      c_anz_x=50;
      c_anz_y=50;
      c_scal_x=8;
      c_scal_y=8;
      anz_blocks=(c_anz_x*c_anz_y) div 3;
      leer=$ffff;
type tfeldb=array[0..c_anz_x+1,0..c_anz_y+1] of byte;
     tfeldw=array[0..c_anz_x+1,0..c_anz_y+1] of word;
     tpos=record
           x,y:word;
          end;

var feld:tfeldb;
    feld_h:tfeldw;
    t,r,w,xd,yd:word;
    start,ziel:tpos;

    fertig:boolean;
    s:string;
    gd,gm:integer;

procedure putf;
begin
 setfillstyle(1,red);
 for t:=1 to c_anz_x do for r:=1 to c_anz_y do if feld[t,r]=0
 then
 begin
 setcolor(blue);
 rectangle(t*c_scal_x,r*c_scal_y,(t+1)*c_scal_x,(r+1)*c_scal_y);
 end
 else
 begin

 bar(t*c_scal_x,r*c_scal_y,(t+1)*c_scal_x,(r+1)*c_scal_y);
 end;
if not blocksselbst then
begin
 setcolor(yellow);
 with start do rectangle(x*c_scal_x,y*c_scal_y,(x+1)*c_scal_x,(y+1)*c_scal_y);
 setcolor(white);
 with ziel do rectangle(x*c_scal_x,y*c_scal_y,(x+1)*c_scal_x,(y+1)*c_scal_y);
  outtextxy(start.x*c_scal_x,start.y*c_scal_y,'S');
 outtextxy(ziel.x*c_scal_x,ziel.y*c_scal_y,'Z');
end;

end;

procedure putz;
var c,x,y,xx,yy:word;b:byte;
    dummy:tpos;
    feld_dummy:tfeldw;
begin
{ if feld[t,r]=0 then}
 fertig:=true;
 feld_dummy:=feld_h;
 for x:=1 to c_anz_x do for y:=1 to c_anz_y do
 begin
  if (feld_h[x,y]<>leer) and (feld[x,y]=0) then
  begin
   {컴Zahlen schreiben컴컴컴컴컴}
{  waitretrace;}
{   str(feld_h[x,y],s);
   outtextxy((x*c_scal_x) shr 1+1,y*c_scal_y,s);}
   {컴컴컴컴컴컴컴컴컴}
   for xx:=x-1 to x+1 do for yy:=y-1 to y+1 do if feld[xx,yy]=0
    then if feld_h[xx,yy]>(feld_h[x,y]+1) then
    begin
     feld_dummy[xx,yy]:=feld_h[x,y]+1;
     fertig:=false;
    end;
  end;
  feld_h:=feld_dummy;
  {-> DIE TOTALE OPTIMIERUNG: hoffentlich....)}
   if feld[start.x,start.y]<>0 then fertig:=true;
 end;

 {else
 rectangle(t*c_scal_x,r*c_scal_y,(t+1)*c_scal_x,(r+1)*c_scal_y,red);}


 {with start do rectangle(x*c_scal_x,y*c_scal_y,(x+1)*c_scal_x,(y+1)*c_scal_y);
 with ziel do rectangle(x*c_scal_x,y*c_scal_y,(x+1)*c_scal_x,(y+1)*c_scal_y);}
end;

procedure backreck(x,y:word);
var xx,yy:word;
begin
 while feld_h[x,y]>0 do
 begin
 for xx:=x-1 to x+1 do for yy:=y-1 to y+1 do
   if feld_h[xx,yy]<(feld_h[x,y]) then if feld[xx,yy]=0 then
    if ((xx>0) and (yy>0)) and ((xx<c_anz_x) and (yy<c_anz_y)) then
    begin
     line(x*c_scal_x+c_scal_x shr 1,y*c_scal_y+c_scal_y shr 1,
     xx*c_scal_x+c_scal_x shr 1,yy*c_scal_y+c_scal_y shr 1);
     x:=xx;
     y:=yy;
    end;
 end;
end;


procedure eingabe;
begin
 if not zufall then
 begin
 writeln('x=',w,' y=',r);
 textcolor(15);
 write('Konrads ');
 textcolor(blue);
 write('Pathfinding');
 textcolor(white);
 writeln('-Programm');
 writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');;
 textcolor(lightgray);
 write('Start.x: ');readln(start.x);
 write('Start.x: ');readln(start.y);
 write('Ziel.x: ');readln(ziel.x);
 write('Ziel.x: ');readln(ziel.y);
 end else
 begin
  start.x:=random(c_anz_x)+1;
  start.y:=random(c_anz_y)+1;
  ziel.x:=random(c_anz_x)+1;
  ziel.y:=random(c_anz_y)+1;
 end;
end;

 procedure drawblocks;
 var dummy:byte;c:byte;
 begin
  initmaus;
  setmaus(320,240);
  c:=0;
  with maus do
   repeat
    dummy:=getpixel(x,y);
    putpixel(x,y,15);
    waitretrace;
    putpixel(x,y,dummy);
    abfrage;
    if taste=1 then case c of
     0:begin
      start.x:=x div c_scal_x; start.y:=y div c_scal_y; inc(c);
      setcolor(yellow);
      with start do rectangle(x*c_scal_x,y*c_scal_y,(x+1)*c_scal_x,(y+1)*c_scal_y);
      outtextxy(start.x*c_scal_x,start.y*c_scal_y,'S');
      delay(200);
     end;
     1:begin
      ziel.x:=x div c_scal_x; ziel.y:=y div c_scal_y; inc(c);
      setcolor(white);
      with ziel do rectangle(x*c_scal_x,y*c_scal_y,(x+1)*c_scal_x,(y+1)*c_scal_y);
      outtextxy(ziel.x*c_scal_x,ziel.y*c_scal_y,'Z');
      delay(200);
     end;
    end;

  until c=2;
{  delay(100);}
  feld_h[start.x,start.y]:=0;

  abfrage;

   with maus do
   repeat
    dummy:=getpixel(x,y);
    putpixel(x,y,15);
    waitretrace;
    putpixel(x,y,dummy);
    abfrage;
    if taste=1 then
    begin
     feld[x div c_scal_x,y div c_scal_y]:=1;
     setfillstyle(1,red);
     bar(x-(x mod c_scal_x),y-(y mod c_scal_y),x-(x mod c_scal_x)+c_scal_x,y-(y mod c_scal_y)+c_scal_x);

    end;
   until maus.taste=3;
 end;


procedure prep_feld;
begin
 fillchar(feld,(c_anz_x+2)*(c_anz_y+2),0);
 fillchar(feld_h,(c_anz_x+2)*(c_anz_y+2)*2,$ff);
 feld_h[start.x,start.y]:=0;

 if not blocksselbst then
 begin
 for t:=1 to anz_blocks do
 begin
  xd:=random(c_anz_x)+1;
  yd:=random(c_anz_y)+1;
  while
  feld[xd,yd]=1 do
  begin
  xd:=random(c_anz_x)+1;
  yd:=random(c_anz_y)+1;
  end;
  feld[xd,yd]:=1;
 end;
 feld[start.x,start.y]:=0;
 feld[ziel.x,ziel.y]:=0;
end;

end;

begin
 l_start:
 fertig:=false;
 randomize;
 w:=getmaxx;
 r:=getmaxy;
 {eingabe;}
 prep_feld;
 gd:=installuserdriver('svga256',nil);
 gm:=2;
 initgraph(gd,gm,'C:\bp\bgi');
 putf;
 if blocksselbst then drawblocks;
 feld[start.x,start.y]:=0;
 repeat
{  waitretrace;
  cleardevice;}

  putz;
{  readkey;}
 until {(keypressed) or (}fertig=true{)};
 str(feld_h[ziel.x,ziel.y],s);
 if feld_h[ziel.x,ziel.y]<leer then
 begin
 s:=s+' Schritte waren n봳ig.';
 outtextxy(0,getmaxy-20,s);
 backreck(ziel.x,ziel.y);
 end
  else s:='Weg nicht m봥lich.';
 outtextxy(1,getmaxy-20,s);
 outtextxy(1,getmaxy-8,'Nochmal (J/N)?');
 repeat taste:=readkey until (upcase(taste)='J') or (upcase(taste)='N');
 if upcase(taste)='J' then goto l_start;
 textmode(3);
end.