uses crt,graph,ktools;
var i,j,k:longint;
    v:byte;
    b:boolean;
procedure mainprog;

 procedure aufbau;
 begin
  for i:=1 to 200000 do
  begin
   if not keypressed then putpixel(trunc(cos(i*pi/180)*i/360)+getmaxx div 2,trunc (sin (i*pi/180)*i/360) +getmaxy div 2,i);
  end;
 end;

 procedure palrot;
 begin
  waitvret;
  for i:=1 to 255 do setrgbpalette(i,0,0,i+v);
 end;

 procedure verschmier(n:byte);
 begin
  for i:=1 to n do
  begin
   for j:=getmaxx downto 0 do
   begin
    if keypressed then break;
    for k:=getmaxy downto 0 do putpixel(j,k,(getpixel(j,k-1)+getpixel(j,k+1)+getpixel(j-1,k)+getpixel(j+1,k+1)) shr 2);
   end;
  end;
 end;

begin
 aufbau;
 verschmier(3);
 v:=0;
 b:=false;
 repeat
  if (v+1>255) or (v-1<0) then b:=not b;
  if b= true then inc(v)
             else dec(v);
  palrot;
 until keypressed;
end;


begin
  svga3(1);
  for i:=1 to 255 do setrgbpalette(i,0,0,i);

 mainprog;
 closegraph;
end.