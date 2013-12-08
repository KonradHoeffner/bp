uses _32bit,_13h,_3d,crt,pcx,konrad;
const hoehe=50;
      breite=50;
      zoom=256;
      dist:integer=600;
      StartC:array[1..4] of array[1..3] of real=
      ((-200,100,0),
      (-200,-100,0),
      (200,100,0),
      (200,-100,0));

type
TTexture= record
           width,height:word;
           img:Pointer;
          end;
TImage1=array[0..49,0..49] of byte;
TWall=
     record
      p:array[1..4] of TPos3d;
      vp:array[1..4] of TPos;
      img:pointer;
     end;

var img1:^TImage1;
    screen1:^TScreen;
    wall1:TWall;
    l:word;
procedure line(var source;x1,y1,x2,y2:word;farbe:byte);
var dummy,t,x,y:word;
    steigx,steigy:real;
    dx,dy:integer;
    dir:shortint;
begin
 if x1>x2 then
  begin
   dummy:=x1;
   x1:=x2;
   x2:=dummy;
   dummy:=y1;
   y1:=y2;
   y2:=dummy;
  end;

 dx:=x2-x1+1;
 dy:=y2-y1;
   if dy<0 then
  begin
   dy:=-dy;
   dir:=-1;
  end else dir:=1;
 begin
  if dy<>0 then steigx:=dx/abs(dy);
  steigy:=dy/dx;
  if (steigy<1) and (steigy>-1) then
   for x:=0 to dx-1 do put13h(source,x1+x,y1+dir*trunc(steigy*x),farbe)
    else
   for y:=0 to dy-1 do put13h(source,x1+round(steigx*y),y1+y*dir,farbe)
 end;
end;


 Procedure InitTextures;
 var y,x:word;
 Begin
  Getmem(img1,sizeof(TImage1));
  LoadPCX('ziegel1.pcx',img1^,palette);
  palette[255*3]:=63;palette[255*3+1]:=63;palette[255*3+2]:=63;
  setpal;
  for y:=0 to 49 do move(img1^[y,0],screen[y,0],50);
  readkey;
  waitretrace;
  Wall1.img:=Img1;
 End;

Procedure Init1;
var nr:word;
Begin
 getmem(screen1,64000);
 init13h;
 InitTextures;
 for nr:=1 to 4 do
 begin
  wall1.p[nr].x:=StartC[nr][1];
  wall1.p[nr].y:=StartC[nr][2];
  wall1.p[nr].z:=StartC[nr][3];
 end;
End;

Procedure MakeCoords;
var help:real;
    t:word;
Begin
 for t:=1 to 4 do with wall1.p[t] do
 begin
  help:=(z+dist)/zoom;
  if help=0 then help:=0.0001;
  wall1.vp[t].x:=trunc((x)/help)+160;
  wall1.vp[t].y:=-trunc((y)/help)+100;
 end;
End;

Procedure ShowPoints(w:TWall;var dest:TScreen);
var t:word;
Begin
 for t:=1 to 4 do with w.vp[t] do dest[y,x]:=255;
End;

Procedure ShowTexture(w:TWall;var dest:TScreen);
var t,x,y:word;
    vbreite,vhoehe1,vhoehe2,vhoehe:integer;
Begin
 vbreite:=w.vp[1].x-w.vp[3].x;
 vhoehe1:=w.vp[2].y-w.vp[1].y;if VHoehe1=0 then VHoehe1:=1;
 vhoehe2:=w.vp[4].y-w.vp[2].y;if VHoehe2=0 then VHoehe2:=1;
 if vhoehe1>vhoehe2 then
 begin
  for y:=w.vp[1].y to w.vp[2].y do line(dest,w.vp[1].x,y,w.vp[3].x,w.vp[3
  ].y+round((y-w.vp[3].y)),10);
 end;
End;

Procedure RotateWall;
var t:word;
Begin
 for t:=1 to 4 do rotatey(wall1.p[t],{sin(l/20)*2}1);
End;

Procedure Swap(var src,dest:TScreen);
Begin
 movelongint(src,dest,16000);
 filllongint(src,16000,0);
End;

Procedure Main;
Begin
 repeat
  RotateWall;
  MakeCoords;
  ShowTexture(wall1,screen1^);
  ShowPoints(wall1,screen1^);
  waitretrace;
  Swap(screen1^,screen);
  if keypressed then taste:=readkey;
  inc(l);
 until taste=#27;
End;

Procedure Final;
Begin
 Textmode(3);
 Freemem(screen1,64000);
{ Freemem(img1,sizeof(TImage1));}
End;

begin
 Init1;
 Main;
 Final;
end.