uses crt,graph,ktools;
var i,j,k:word;

procedure init;
var gd,gm:integer;
begin
 gd:=installuserdriver('svga386',nil);
 gm:=1;
 initgraph(gd,gm,'C:\bp\bgi');
 for i:=1 to 255 do setrgbpalette(i,i,0,0);
end;

procedure mainprog;
var f:byte;
    richtung:boolean;


begin
 f:=0;
 richtung:=true;

 for i:=1 to getmaxx do for j:=1 to getmaxy do
 begin
  setcolor(i);
  rectangle(getmaxx div 2-j,getmaxy div 2-j,getmaxx div 2+j,getmaxy div 2+j );
 end;

 repeat
  inc(f);
  waitvonly;
  for i:=0 to 255 do setrgbpalette(i,i+f,0,0);
 until keypressed;
end;


begin
init;
mainprog;
closegraph;
end.