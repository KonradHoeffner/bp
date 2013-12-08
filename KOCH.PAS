
program Fraktal;
uses crt, graph;
var s,f,x,y,l     :real;
    gd,gm,t,xr,yr :integer;
    anzahl        :longint;
    wort          :string[10];
    eingabe       :char;
    bereits       :boolean;

PROCEDURE rueck (s1:real);
begin
     f:=f-pi;
     x:=x+s1*cos(f); y:=y-s1*sin(f);
     xr:=round(x); yr:=round(y);
     moveto(xr,yr);
     f:=f+pi;
end;

PROCEDURE vor (s1:real);
begin
     x:=x+s1*cos(f); y:=y-s1*sin(f);
     xr:=round(x); yr:=round(y);
if bereits=false then lineto(xr,yr) else moveto(xr,yr);
bereits:=false;
end;

PROCEDURE figur (s2:real; t1:integer);
var i: integer;
begin
     bereits:=false;
     if t1=0 then exit
     else                    begin
if t1<7 then setcolor(t1+9) else setcolor(t1+2);
          vor(s2);
          f:=f+pi/3;
          figur(s2/3,t1-1);
          vor(s2);
          f:=f-2*pi/3;
          figur(s2/3,t1-1);
          vor(s2);
          f:=f+pi/3;
          figur(s2/3,t1-1);
          vor(s2);
          rueck(3*s2);
      bereits:=true;
                             end;
end;

                                  BEGIN
write('Seitenl„nge (z.B. 210): ');read(s);
gd:=detect; initgraph(gd,gm,'c:\bp\bgi');
{Anfangswerte}
f:=0; anzahl:=1; t:=1; l:=1;
if s>213 then x:=640-3*s-1 else x:=(640-3*s)/2;
y:=400;
{setcolor(lightgreen);}
{alte Werte l”schen}
figur(s,1);

REPEAT
    cleardevice;
    outtextxy(410,20,'Polygonl„nge (Pixel):');
    str(round(s), wort);
    outtextxy(580,20,wort);
    outtextxy(410,40,'Schachtlungstiefe:');
    str(t, wort);
    outtextxy(580,40,wort);
    outtextxy(410,60,'Anzahl der Polygone: ');
    anzahl:=anzahl*3+1;
    str(anzahl,wort);
    outtextxy(580,60,wort);
    outtextxy(410,80,'rel. L„nge der Figur: ');
    l:=l+1/3;
    str(l,wort);
    outtextxy(574,80,wort);
    moveto(xr,yr); figur(s,t);

    sound(1000); delay(50);nosound;
    outtextxy(430,100,'(Enter oder ESC)');

    eingabe:=readkey;
       case eingabe of
       #13:  t:=t+1;
       #27:  begin closegraph;exit;end;
       end;
until t<0;
END.