uses crt,saveload,ktools;

const punktanz=64000;
      maxx=319;
      maxy=199;

type screent=array[0..199,0..319] of byte;

var i,j:word;
    rsin,rcos:array[0..359] of real;
    bx,by:boolean;
    screen:^screent;

procedure init;
var gd,gm:integer;
begin

 asm
  mov ax,13h
  int 10h
 end;
 loadpcx256(0,0,'c:\konrad\bp\buch\phint.pcx');
 getmem(screen,64000);
 move(mem[$a000:0],screen^,64000);
 fillchar(mem[$a000:0],64000,0);
 randomize;

end;

procedure mainprog;
var rotx,roty:integer;


begin
 for i:=0 to 359 do rcos[i]:=cos(i*pi/180);
 for i:=0 to 359 do rsin[i]:=sin(i*pi/180);


{ for i:=0 to punktanz do
 with punkte[i] do
 begin
  x:=random(getmaxx+1*2);
  y:=random(getmaxy+1*2);
  z:=random(255)+1;
 end;}

 repeat
   if rotx>359 then bx:=false;
   if roty>359 then by:=false;

   if rotx<1 then bx:=true;
   if roty<1 then by:=true;

  if bx= true then inc(rotx,2) else dec(rotx,2);
  if by= true then inc(roty) else dec(roty);




{ for i:=1 to punktanz do
 if punkte[i].x>1 then dec(punkte[i].x,2)
 else punkte[i].x:=799;}


 for i:=0 to maxx do
 for j:=0 to maxy do
 mem[$a000:abs(trunc(j*rsin[roty]+rcos[rotx]{*z+z}))
 +320*(abs(trunc(i*rcos[rotx]-rsin[roty]{*z+z shr 5})))]:=screen^[j,i];
 waitvret;


 until keypressed;
end;


begin
 init;
 mainprog;
 textmode(3);
end.