{Hallo Simon! Hier meine virtuelle Seiten - Version, énderungen sind
mit "!!" gekennzeichnet.}
uses _13h,_32bit,konrad,crt;
type wie_zeichnen=(zeichnen,loeschen);
const max=10000;
      anz:word=max;
      virtmaxX=1000;
      virtmaxY=1000;

var t:integer;
    sprite:array[1..max] of record
                             x,y:integer;
                             farbe:byte;
                            end;
    ich:TPos;
    screen1:^tscreen; {unsere virtuelle Seite, Pointer auf TScreen}
Procedure Init;
Begin
 Getmem(screen1,64000);
 Filllongint(screen1^,16000,0);
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
 Freemem(screen1,64000);
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

Procedure ShowThings(var ziel:tscreen;zeichenart:wie_zeichnen);
var t,vx,vy:integer; {vx=virtuelles X auf dem Bildschirm, vy...}
Begin
 for t:=1 to anz do with sprite[t] do
 begin
  vx:=x-ich.x;
  vy:=y-ich.y;
  if sichtbar(vx,vy) then if zeichenart=zeichnen then ziel[vy,vx]:=farbe
                                                 else ziel[vy,vx]:=0;
 end;
End;

Procedure MoveStars;
var t:integer;
Begin
 for t:=1 to anz do with sprite[t] do
 if x>0 then dec(x,farbe shr 7+1) else x:=VirtMaxX;

End;

Procedure Main;
var s1,s2:string;
Begin
 repeat
  abfrage;
  movestars;{!! auch neu, hat natÅrlich nichts mit virtuellen Seiten
  zu tun aber als kleiner Gag...}
  str(ich.x,s1);str(ich.y,s2);
  outtextxy2(5,0,s1+','+s2,red,screen1^{!!});
  showthings(screen1^{!!},zeichnen);{jetzt wird auf Screen1^ gezeichnet}
  waitretrace;{Waitretrace immer direkt vor dem Movelongint}
  movelongint(screen1^{!!},screen,16000);{!!}
  outtextxy2(5,0,s1+','+s2,black,screen1^{!!});
  showthings(screen1^,loeschen);
 until taste=#27;
End;

begin
 Init;
 Main;
 Final;
end.