uses crt,konrad,_32bit;
const maxants=3000;
      maxTargets=40;
Type TAnt=Record
           x:word;
           y,target,col:byte;
          End;
    TAnts=array[1..maxants] of TAnt;
var ants:^TAnts;
    Targets:array[1..maxtargets] of TPos;
    Bau:TPos;
    screen1:^tscreen;
    anz_ants,anz_targets:word;

Procedure Init;
Begin
 Init13h;
 for t:=0 to 255 do fillchar(palette[t*3],3,t shr 2);
 setpal;
 Randomize;
 getmem(screen1,64000);
 getmem(ants,sizeof(TAnts));
 Filllongint(screen1^,16000,0);
 Filllongint(screen,16000,0);
 Bau.x:=160;
 Bau.y:=100;
 Targets[1]:=Bau;
 anz_ants:=maxants;
 anz_targets:=maxtargets;
{ targets[2].x:=20;
 targets[2].y:=20;
 targets[3].x:=290;
 targets[3].y:=170;}
  for t:=2 to anz_targets do with targets[t] do
 begin
  x:=random(320);
  y:=random(200);
 end;


 for t:=1 to anz_ants do with Ants^[t] do
 Begin
  target:=random(anz_targets-1)+2;
  x:=Bau.x;
  y:=Bau.y;
  col:={random(200)+55}200;
 End;
End;
Procedure Go;
var nr:word;
    tx,ty:word;
Begin
 for nr:=1 to anz_ants do with ants^[nr] do
 Begin
  tx:=targets[target].x;
  ty:=targets[target].y;
  If x<tx then inc(x,random(2)) else If x>tx then dec(x,random(2));
  If y<ty then inc(y,random(2)) else If y>ty then dec(y,random(2));
  Inc(X,Random(3)-1);
  Inc(Y,Random(3)-1);

  If X=tx then if y=ty then
   Begin
    if target=1 then target:=random(anz_targets-1)+2
                else target:=1;
    if col<255 then inc(col) else
    Begin
     if t<> maxants then move(ants^[t+1],ants^[t],maxants-t);
     dec(anz_ants);
    End;
   End;
 End;
End;

Procedure Loop;
 Procedure PaintAnts;
  function entf(A:TAnt):byte;
  var dx,dy:integer;
  Begin{  dx
    ------
    \    I dy     entf=sqrt(dx*dx+dy*dy)
      \  I
        \160,100}
   dx:=160-A.X;
   dy:=100-A.Y;
   entf:=abs(round(sqrt(abs(sqr(dx)+sqr(dy)))));
  End;
 var t:word;
 Begin
  for t:=1 to anz_ants do with ants^[t] do screen1^[y,x]:={col}entf(ants^[t]);
 End;
 Procedure DeleteAnts;
 var t:word;
 Begin
  for t:=1 to maxants do with ants^[t] do screen1^[y,x]:=0;
 End;
 Procedure PTargets;
 var t:word;
 Begin
 for t:=2 to maxtargets do with targets[t] do
  Begin
   Inc(x,random(3)-1);
   Inc(y,random(3)-1);
    if x<3 then x:=3;
  if y<3 then y:=3;
  if x>315 then x:=315;
  if y>195 then y:=195;

  End;
 End;
Begin
 repeat
  Go;
  PTargets;
  PaintAnts;
{  waitretrace;}
  MoveLongInt(screen1^,screen,16000);
  if maxants>4500 then Filllongint(screen1^,16000,0)
                  else DeleteAnts;
 until (keypressed) or (anz_ants=0);
End;

begin
 Init;
 Loop;
 freemem(ants,sizeof(TAnts));
 freemem(screen1,64000);
end.