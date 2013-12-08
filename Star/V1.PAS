uses konrad,crt,_13h;
const speed=5;
var x,y:word;
    f:real;
begin
 init13h;
 r:=0;
 f:=3;
 fillchar(palette,768,0);
 for t:=1 to 255 do palette[(t*3)+1]:=(255-t) div 4;
 fillchar(palette[214*3+1],100,0);
 for t:=1 to 20 do palette[t*3+2]:=64-t*2;
 fillchar(palette[255*3+1],3,63);
{ fillchar(palette[32*3+1],3,0);}
 setpal;
 for t:=1 to 360 do put13h(round(150+rcos[t]*11*f),round(90+rsin[t]*10*f),255);

 for t:=1 to 360 do put13h(round(150+rcos[t]*10*f),round(90+rsin[t]*09*f),19);
 for t:=1 to 360 do put13h(round(150+rcos[t]*09*f),round(90+rsin[t]*08*f),19);
 for t:=1 to 360 do put13h(round(150+rcos[t]*09.5*f),round(90+rsin[t]*08.5*f),19);
 for t:=1 to 360 do put13h(round(150+rcos[t]*07*f),round(90+rsin[t]*06*f),19);
 for t:=1 to 360 do put13h(round(150+rcos[t]*06*f),round(90+rsin[t]*05*f),19);
 for t:=1 to 360 do put13h(round(150+rcos[t]*05*f),round(90+rsin[t]*04*f),19);


 repeat
  {f:=f+0.001;}
  if r<359 then inc(r) else r:=0;
  with sterne[1] do
  begin
   x:=round(150+rcos[r]*23*f);
   y:=round(90+rsin[r]*20*f);
  end;
  for t:=1 to 254 do with sterne[t] do
  put13h(x,y,t);
  put13h(sterne[255].x,sterne[255].y,0);
  move(sterne[1],sterne[2],256*5);
  if r mod speed = 0 then waitretrace;
  put13h(x,y,0);
 until keypressed;
 textmode(3);
end.