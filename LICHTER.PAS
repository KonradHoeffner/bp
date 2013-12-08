uses crt,graph,ktools;
const maxkugeln=10;
var i:word;
    kugeln:array[1..maxkugeln] of record
                            index:boolean;
                            x,y:longint;

                            speedx,speedy:integer;
                           end;
    winkel:byte;
    zaehl:byte;
procedure init;
begin
 svga3(0);
 setrgbpalette(1,255,255,255);
 winkel:=90;
 zaehl:=0;
 randomize;
 for i:=1 to maxkugeln do
 begin
  kugeln[i].index:=true;
  kugeln[i].x:=random(10000)+22000;
  kugeln[i].y:=random(10000)+22000;
  kugeln[i].speedx:=random(512)-256;
  kugeln[i].speedy:=random(512)-256;

 end;
end;


procedure mainprog;
var taste:char;

    s:string;
begin

 repeat
 if keypressed then taste:=readkey;

 for i:=1 to maxkugeln do
 begin
  if kugeln[i].x <0 then kugeln[i].x:=319;
  if kugeln[i].x >319 then kugeln[i].x:=0;
  if (kugeln[i].x shr 8 <320) and (kugeln[i].y shr 8 <200) then  putpixel(kugeln[i].x shr 8,kugeln[i].y shr 8,0);

  dec(kugeln[i].x,kugeln[i].speedx);
  dec(kugeln[i].y,kugeln[i].speedy);
  if (kugeln[i].x shr 8 <320) and (kugeln[i].y shr 8 <200) then  putpixel(kugeln[i].x shr 8,kugeln[i].y shr 8,1);
 end;

 waitvret;
 until taste=#27;
end;


begin
init;
mainprog;
closegraph;
end.