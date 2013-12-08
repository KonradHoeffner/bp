uses graph;
var gd,gm:integer;
begin
 gd:=detect;
 initgraph(gd,gm,'c:\bp\bgi');
 for gd:=1 to 640 do putpixel(gd,getmaxy shr 1-round(50*sin(gd*90/50*pi/180)),15);
 for gd:=1 to 640 do putpixel(gd,getmaxy shr 1-round(50*cos(gd*90/50*pi/180)),15);
 for gd:=1 to 640 do putpixel(gd,getmaxy shr 1,15);
 readln;
end.