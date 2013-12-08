uses crt,_32bit,konrad;

type tsprite = array[1..10,1..10] of byte;
const
     bildspeicher=$a000;
     Max  = 12;
     breite=10;
     hoehe=10;
     speedx=4;
var punkte : array[0..Max] of record
                              x,y : integer;
                              end;
    speed  : array[0..Max] of integer;
    t      : integer;
    bild1,bild2:^screen_type;
    p:pointer;
{const sprite : tsprite = ((0 ,0 ,0 ,1 ,1 ,1 ,1 ,0 ,0 ,0 ),
                          (0 ,1 ,1 ,0 ,0 ,0 ,0 ,1 ,1 ,0 ),
                          (0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,0 ),
                          (1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ),
                          (1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ),
                          (1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ),
                          (1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ),
                          (0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,0 ),
                          (0 ,1 ,1 ,0 ,0 ,0 ,0 ,1 ,1 ,0 ),
                          (0 ,0 ,0 ,1 ,1 ,1 ,1 ,0 ,0 ,0 ));}

const katze1 : tsprite = ((0 ,0 ,0 ,0 ,0 ,0 ,0 ,6 ,0 ,0 ),
                          (0 ,6 ,0 ,0 ,0 ,0 ,6 ,6 ,0 ,0 ),
                          (0 ,6 ,0 ,0 ,0 ,0 ,6 ,6 ,6 ,0 ),
                          (6 ,0 ,0 ,6 ,6 ,6 ,6 ,1 ,6 ,6 ),
                          (6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ),
                          (6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,0 ),
                          (6 ,6 ,6 ,6 ,6 ,6 ,6 ,0 ,0 ,0 ),
                          (6 ,6 ,0 ,0 ,0 ,6 ,6 ,0 ,0 ,0 ),
                          (0 ,6 ,0 ,0 ,0 ,0 ,6 ,0 ,0 ,0 ),
                          (0 ,6 ,6 ,0 ,0 ,0 ,6 ,6 ,0 ,0 ));

procedure Init13h;assembler;
 asm
  mov ax,13h
  int 10h
 end;


procedure putpixel(x,y:word; farbe:byte);
 begin
  {mem[$a000:320*y+x]:=farbe;}
  bild1^[y,x]:=farbe;
 end;


procedure brocken(sp: tsprite; x,y :integer);
var ix, iy : integer;
begin
  for ix:=1 to 10 do
    for iy:=1 to 10 do
      putpixel(x+ix, y+iy, sp[iy,ix]);
end;

procedure zeichnekatze(sp: tsprite; x,y :integer);
var ix, iy : integer;
begin
{  for ix:=1 to 10 do}
    for iy:=1 to 10 do
    move(sp[iy,1],bild1^[y+iy,x],breite)
{      putpixel(x+ix, y+iy, sp[iy,ix]);}
end;




procedure waitretrace;
 begin
  repeat until (port[$3da] and $08) <> 0;
  repeat until (port[$3da] and $08)  = 0;
 end;


begin
randomize;
getmem(bild1,64000);
{getmem(bild2,64000);}
bild2:=ptr(bildspeicher,0);
for t:=1 to Max do
 begin
  punkte[t].y:=199;
  speed[t]:=5;
  punkte[t].y:=random(200)+1;
 end;
for t:=1 to Max do punkte[t].x:=random(320)+1;
Init13h;
 repeat
  for t:=1 to Max do
   begin
    {putpixel(punkte[t].x,punkte[t].y,15);}
{    brocken(katze1,punkte[t].x,punkte[t].y);}
     zeichnekatze(katze1,punkte[t].x,punkte[t].y);
    if punkte[t].y > 180 then
     begin
      speed[t]:=10+t;
     end;
    if punkte[t].x > 319 then
     begin
      punkte[t].x:=1;
     end;
   end;

    for t:=1 to Max do
     begin
      dec(speed[t],1);
      dec(punkte[t].y,speed[t] shr 1);
      inc(punkte[t].x,speedx);
     end;



{  waitretrace;}
  waitretrace;
  movelongint(bild1^,bild2^,16000);
  filllongint(bild1^,16000,0);
 {  waitretrace;}
 until keypressed;
 freemem(bild1,64000);
{ freemem(bild2,64000);}

end.
