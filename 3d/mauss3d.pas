uses _32bit,crt,konrad,_13h,_3d;
const
      s=70;
      anzt=6;
      timer:array[1..anzt] of longint=
      (s*10,s*15,s*25,s*50,s*52,s*54);

      zoom:integer=256;
      dist:integer=350;
      shifter=1;
      anz=256 shl shifter;
      minz=-100;
      maxz=100;
var p:array[1..anz] of TPos3d;
    vp:array[1..anz] of TPos;
    screen1:^tscreen;
    t:integer;
    count:word;
Procedure InitPos;
Begin
 for t:=1 to anz do with p[t] do
 begin
  x:=0;
  y:=0;
  z:=0;
 end;
End;

Procedure Init;
Begin
 Getmem(screen1,64000);
 InitTables;
 Init13h;
 for t:=1 to 255 do setmypalette(t,t shr 2,t shr 3,0);
 InitPos;
 Maus_Init;
 SetMaus(320,100);
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
End;

Procedure Abfrage;
Begin
 Maus_Abfrage;Maus.x:=Maus.x shr 1;
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

Procedure MoveP;
var t:integer;
    xrot,yrot,zrot:real;
Begin
 inc(count);
 xrot:=1*sin((count mod 360)*pi/180);
 yrot:=cos(((count div 3) mod 360)*pi/180);
 zrot:=2;

 for t:=1 to anz do with p[t] do
 begin
  x:=x+random(3)-1;
  y:=y+random(3)-1;
  rotatex(p[t],xrot);
  rotatey(p[t],yrot);
  rotatez(p[t],zrot);
 end;
End;

Procedure Show(var d:tscreen);
var t:integer;
Begin
 for t:=1 to anz-1 do with vp[t] do
 if (x>=0) and (x<320) and (y>=0) and (y<200)
 and (vp[t+1].x>=0) and (vp[t+1].x<320) and (vp[t+1].y>=0) and (vp[t+1].y<200)
 and not ((x=vp[t+1].x) and (y=vp[t+1].y))
 then line(d,x,y,vp[t+1].x,vp[t+1].y,t shr shifter);
End;

Procedure Main;
Begin
 repeat
  abfrage;
  move(p[2],p[1],(anz-1)*sizeof(tpos3d));
  p[anz].x:=maus.x-160;
  p[anz].y:=100-maus.y;
  {y=2x+1;}
  p[anz].z:=p[anz-1].z-10+random(21);
  if p[anz].z>maxz then p[anz].z:=maxz;
  if p[anz].z<minz then p[anz].z:=minz;
  moveP;
  makevis(p,vp,anz,dist,zoom);
  show(screen1^);
  waitretrace;
  movelongint(screen1^,screen,16000);
  filllongint(screen1^,16000,0);
 until taste=#27;
End;

begin
 Init;
 Main;
 Final;
end.
