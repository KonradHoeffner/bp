uses _13h,_32bit,konrad,crt;
const anz=200;
      banz=10;
      l=10;
      verhungern:boolean=true;
type tviech= record
              x,y:integer;
              p:array[1..l] of tpos;
              leben:byte;
             end;
     tbrot= record
              x,y:integer;

             end;
var screen1:^tscreen;
    t:integer;
    viecher:array[1..anz] of tviech;
    brote:array[1..banz] of tbrot;
    dummypos:array[1..l] of tpos;
Procedure Init;
var i:integer;
Begin
 Getmem(screen1,64000);
 Init13h;
 randomize;
 for i:=1 to 254 do setmypalette(i,i shr 2,i shr 2,i shr 2);
 setmypalette(255,63,0,0);
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
End;

Procedure Abfrage;
Begin
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

Function Nearest(nr:integer):integer;
var current,vx,vy,i:integer;
 Function Distance(x1,y1,x2,y2:longint):integer;
 Begin
  Distance:=trunc(sqrt((sqr(x2-x1)+sqr(y2-y1))));
 End;
begin
 current:=1000;
 vx:=viecher[nr].x;
 vy:=viecher[nr].y;
 for i:=1 to banz do with brote[i] do
 begin
  if distance(vx,vy,x,y)<current then
   begin
    current:=distance(vx,vy,x,y);
    Nearest:=i;
   end;
 end;
end;

Procedure Show;
var i,n:integer;
Begin
 for i:=1 to anz do with viecher[i] do
 begin
  screen1^[y+1,x]:=254;
  screen1^[y-1,x]:=254;
  screen1^[y,x+1]:=254;
  screen1^[y,x-1]:=254;
  for n:=1 to l do with viecher[i].p[n] do screen1^[y,x]:=leben;
 end;

 for i:=1 to banz do with brote[i] do
 begin
  screen1^[y,x]:=255;
 end;

End;

Function Sign(i:integer):integer;
begin
 sign:=0;
 if i>0 then sign:=1 else if i<0 then sign:=-1;
end;

Procedure MoveIt;
var i,ibrot,bx,by,dx,dy,c:integer;
begin
 for i:=1 to anz do with viecher[i] do if leben>0 then
 begin
  if verhungern then dec(leben);
  move(p[1],dummypos[2],(l-1)*sizeof(tpos));
  move(dummypos,p,l*sizeof(tpos));
  p[1].x:=x;p[1].y:=y;

  ibrot:=Nearest(i);
  bx:=brote[ibrot].x;by:=brote[ibrot].y;
  dx:=bx-x;dy:=by-y;
  {prozentualer Anteil von x an Gesamtdistanz:}
  if (abs(dx)+abs(dy))<>0 then c:=(100*abs(dx)) div (abs(dx)+abs(dy)) else c:=50;
    if random(100)<=c then
   inc(x,sign(dx)) else inc(y,sign(dy));

  if (x=bx) and (y=by) then
  begin
   brote[ibrot].x:=random(320);
   brote[ibrot].y:=random(200);
   leben:=254;
  end;
  if leben<20 then
   begin
{    leben:=254;
    x:=random(320);
    y:=random(200);} leben:=0;
   end;
 end;
end;

Procedure Main;
var i:integer;
Begin
 for i:=1 to anz do with viecher[i] do
 begin
  x:=random(320);
  y:=random(200);
  leben:=254;
 end;
 for i:=1 to banz do with brote[i] do
 begin
  x:=random(320);
  y:=random(200);
 end;

 repeat
  abfrage;
  moveit;
  show;
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