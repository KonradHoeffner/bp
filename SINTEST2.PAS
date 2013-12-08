uses crt,graph,ktools;
const punktanz=700;
var i:word;
    punkte,punkte2:array[1..punktanz] of record
                                 x,y:integer;
                                 z:byte;
                                 end;
    rotx,roty:integer;
    rsin,rcos:array[0..359] of real;
    bx,by:boolean;
procedure init;
var gd,gm:integer;
begin
 gd:=installuserdriver('svga386',nil);
 gm:=4;
 initgraph(gd,gm,'C:\bp\bgi');
 randomize;
 for i:=1 to 255 do setrgbpalette(i,i,i,i);
 for i:=0 to 359 do rcos[i]:=cos(i*pi/180);
 for i:=0 to 359 do rsin[i]:=sin(i*pi/180);

end;

procedure mainprog;
begin
 for i:=1 to punktanz do
 with punkte[i] do
 begin
  x:=random(getmaxx+1*2);
  y:=random(getmaxy+1*2);
  z:=random(255)+1;
 end;

 repeat
   if rotx>359 then bx:=false;
   if roty>359 then by:=false;

   if rotx<1 then bx:=true;
   if roty<1 then by:=true;

  if bx= true then inc(rotx,2) else dec(rotx,2);
  if by= true then inc(roty) else dec(roty);





 for i:=1 to punktanz do
 putpixel(abs(trunc(punkte[i].x*rcos[rotx]-rsin[roty]+punkte[i].z shr 5)),
 abs(trunc(punkte[i].y*rsin[roty]-rcos[rotx]+punkte[i].z)),punkte[i].z);






 waitvret;
 for i:=1 to punktanz do
 putpixel(abs(trunc(punkte[i].x*rcos[rotx]-rsin[roty]+punkte[i].z shr 5)),
 abs(trunc(punkte[i].y*rsin[roty]-rcos[rotx]+punkte[i].z)),0);



 until keypressed;
end;


begin
 init;
 mainprog;
 closegraph;
end.