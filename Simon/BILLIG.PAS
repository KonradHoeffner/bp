{Hallo Simon! Hier ein Listing, dass dir hoffentlich bei deinem virtuellen Scrolling hilft.
Um das ganze zu vereinfachen habe ich das ganze noch einmal berarbeitet und
eine billig-Version entwickelt, die ohne virtuelle Seiten arbeitet. Allerdings rate ich dir,
IMMER screen[y,x]:=z zu verwenden, da es schneller ist als Putpixel!
}
uses _13h,_32bit,konrad,crt;
type wie_zeichnen=(zeichnen,loeschen);
const max=500;
      anz:word=max;
      virtmaxX=1000;
      virtmaxY=1000;

var t:integer;
    sprite:array[1..max] of record
                             x,y:integer;
                             farbe:byte;
                            end;
    ich:TPos;

Procedure Init;
Begin
 Ich.X:=0;
 Ich.y:=0;
 Init13h;
 Randomize;
 maus_init;
 for t:=1 to anz do with sprite[t] do
 begin
  x:=random(virtmaxX);
  y:=random(virtmaxY);
  farbe:=random(255)+1;
 end;
End;

Procedure Final;
Begin
 Textmode(3);
End;

Procedure Abfrage;
Begin
 maus_abfrage;maus.x:=maus.x shr 1;
 inc(ich.x,maus.x-160);
 inc(ich.y,maus.y-100);
 setmaus(320,100);
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

Function Sichtbar(x,y:integer):boolean;
Begin
 if (x>=0) and (x<320) and (y>=0) and (y<200) then
  sichtbar:=true else
   sichtbar:=false;
End;

Procedure ShowThings(zeichenart:wie_zeichnen);
var t,vx,vy:integer; {vx=virtuelles X auf dem Bildschirm, vy...}
Begin
 for t:=1 to anz do with sprite[t] do
 begin
  vx:=x-ich.x;
  vy:=y-ich.y;
  if sichtbar(vx,vy) then if zeichenart=zeichnen then screen[vy,vx]:=farbe
                                                 else screen[vy,vx]:=0;
 end;
End;

Procedure Main;
var s1,s2:string;
Begin
 repeat
  abfrage;
  str(ich.x,s1);str(ich.y,s2);
  outtextxy2(5,0,s1+','+s2,red,screen);
  showthings(zeichnen);
  waitretrace;
  outtextxy2(5,0,s1+','+s2,black,screen);
  showthings(loeschen);
 until taste=#27;
End;

begin
 Init;
 Main;
 Final;
end.