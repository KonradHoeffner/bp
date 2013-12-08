{$R-}
uses _13h,_32bit,konrad,crt;
var screen1:^tscreen;
    t:integer;
Procedure Init;
Begin
 Getmem(screen1,64000);
 Init13h;
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

{Procedure Circle(x,y,r:integer;col:byte;var d:tscreen);
var f,mx,my,t:integer;
    ofs:word;
Begin
 f:=-2*r+1;
 mx:=0;
 my:=r;
 for t:=1 to r shr 1 do
 begin
  d[y+my,x+mx]:=col;
  d[y+my,x-mx]:=col;
  d[y-my,x+mx]:=col;
  d[y-my,x-mx]:=col;
  d[y+mx,x+my]:=col;
  d[y+mx,x-my]:=col;
  d[y-mx,x+my]:=col;
  d[y-mx,x-my]:=col;

  if f<0 then inc(f,(mx shl 2)+2) else
  begin
   dec(f,my shl 2+4);
   dec(my);
  end;
 end;
End;}

Procedure Circle(x,y,r:integer;col:byte;var d:tscreen);
var f,mx,my,t:integer;
    ofs:word;
Begin
 mx:=0;
 my:=r;
 for t:=1 to r shr 1 do
 begin
  d[y+my,x+mx]:=col;
  d[y+my,x-mx]:=col;
  d[y-my,x+mx]:=col;
  d[y-my,x-mx]:=col;
  d[y+mx,x+my]:=col;
  d[y+mx,x-my]:=col;
  d[y-mx,x+my]:=col;
  d[y-mx,x-my]:=col;

{round(sin(t*45/(r)*pi/180)*r);}
  mx:=round(cos(t*45/(r)*pi/180)*r);
  dec(my);
 end;
End;


Procedure Main;
const anz=10;
var r:integer;
    p:array[1..anz] of
     record
      x,y:integer;
      c:byte;
     end;
Begin
 randomize;
 for t:=1 to anz do with p[t] do
 begin
  x:=random(320);
  y:=random(200);
  c:=random(256);
 end;
 repeat
  abfrage;
{  for t:=1 to 100 do circle(160,100,t,15,screen1^);}
  for t:=1 to anz do with p[t] do
   begin
     inc(x,random(5)-2);
     inc(y,random(5)-2);
     for r:=1 to 50 do circle(x,y,r,c,screen1^);
   end;
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