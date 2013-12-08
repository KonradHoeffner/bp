{$r-}
uses konrad,_32bit,crt;
const
 gras=green;
 fuchs=red;
 reh=brown;
 mensch=blue;
 domensch:boolean=false;
var x,y:word;
    screen1:^tscreen;

function gefunden(x:integer;y,was:byte):boolean;
var mx,my:integer;
begin
 for mx:=x-1 to x+1 do
  for my:=y-1 to y+1 do
   if screen[my,mx]=was then
   begin
    gefunden:=true;
    exit;
   end else gefunden:=false;
end;
{var dummy:boolean;
begin
dummy:=false;
 asm
  mov ax,0a000h
  mov ds,ax
  mov ax,320
  mul y
  add ax,x
  mov si,ax
  jmp @istnichtda
@istda:
  not dummy
@istnichtda:
 end;
end;}

procedure loop;
var x,y,x2,y2,i:integer;
    doit:boolean;
    drin,schon:boolean;
begin
drin:=false;
schon:=false;
doit:=false;
repeat
 repeat
  for i:=1 to 10 do
  begin
   x:=random(320);
   y:=random(200);
   case screen1^[y,x] of
    reh:if not gefunden(x,y,gras) then screen1^[y,x]:=gras else
     for x2:=x-1 to x+1 do for y2:=y-1 to y+1 do if screen1^[y2,x2]=gras then screen1^[y2,x2]:=reh;
    fuchs:if not gefunden(x,y,reh) then screen1^[y,x]:=gras else
     for x2:=x-1 to x+1 do for y2:=y-1 to y+1 do if screen1^[y2,x2]=reh then screen1^[y2,x2]:=fuchs;
    mensch:if not gefunden(x,y,reh) then screen1^[y,x]:=gras else
     if domensch then
     for x2:=x-1 to x+1 do for y2:=y-1 to y+1 do if screen1^[y2,x2]=reh then screen1^[y2,x2]:=mensch
      else if screen1^[y2,x2]=fuchs then screen1^[y2,x2]:=gras;
   end;
  end;
  if keypressed then
  begin
   taste:=upcase(readkey);
   if taste='M' then
   begin
    domensch:=not domensch;
    if domensch then
    begin
     for i:=1 to 50 do
      screen1^[random(200),random(320)]:=mensch;
    end;
   end;
  end;
  if (port[$3da] and $08)=0 then drin:=true else schon:=false;
  if not(schon) then doit:=true else doit:=false;
 until doit;
 schon:=true;
 movelongint(screen1^,screen,16000);
until taste=#27;

end;

begin
 init13h;
 new(screen1);
 setmypalette(red,63,0,0);
 setmypalette(green,0,30,0);
 setmypalette(brown,60,60,0);{gelb}
 randomize;
 for y:=0 to 199
  do for x:=0 to 319 do
  case random(3) of
   0:screen1^[y,x]:=gras;
   1:screen1^[y,x]:=reh;
   2:screen1^[y,x]:=fuchs;
  end;
 loop;
end.