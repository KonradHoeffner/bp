uses graph,crt;
const VMAX=10;
      D=5;
      BREMS=false;
      REIBUNG=1;
      UNGENAU=TRUE;
var gd,gm:integer;
    kugel:record
           x,y,vx,vy:integer;
          end;

procedure zeichne_tisch;
begin
 setcolor(white);
 line(0,0,getmaxx,0);{Horizontal oben}
 line(0,getmaxy,getmaxx,getmaxy);{unten}
 line(0,0,0,getmaxy);
 line(getmaxx,0,getmaxx,getmaxy);
end;

procedure setze_kugel;
begin
 with kugel do
 begin
  x:=random(getmaxx-2*D)+D;
  y:=random(getmaxy-2*D)+D;
  vx:=random(VMAX)+1;
  vy:=random(VMAX)+1;
 end;
end;

function vorzeichen(zahl:integer):integer;
begin
 if zahl>0 then vorzeichen:=1 else vorzeichen:=-1;
end;

procedure bewege_kugel;

 procedure reflektiere(var v:integer);
 begin
  v:=-v;
  if UNGENAU then
   inc(v,random(3)-1);
  if v=0 then if random(2)=1 then v:=1 else v:=-1;
 end;

begin
 with kugel do repeat
  setcolor(black);
  circle(x,y,D);
  if vx<0 then
   if x+vx<D+1 then reflektiere(vx)
               else inc(x,vx)
          else
   if x+vx>getmaxx-D-2 then reflektiere(vx)
                       else inc(x,vx);
  if vy<0 then
   if y+vy<D+1 then reflektiere(vy)
              else inc(y,vy)
          else
   if y+vy>getmaxy-D-2 then reflektiere(vy)
            else inc(y,vy);

  if BREMS then
  begin
   if abs(vx)>0 then dec(vx,vorzeichen(vx)*REIBUNG);
   if abs(vy)>0 then dec(vy,vorzeichen(vy)*REIBUNG);
  end;
  setcolor(red);
  circle(x,y,D);
  delay(20);
 until keypressed;
end;

begin
 randomize;
 gd:=detect;
 initgraph(gd,gm,'c:\bp\bgi');
 zeichne_tisch;
 setze_kugel;
 bewege_kugel;
 closegraph;
end.