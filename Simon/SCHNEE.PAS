uses crt;

var Schnee : array[0..4] of record
                             x,y : word;
                             end;
     t:word;
procedure init13h; assembler;
 asm
  mov ax,13h
  int 10h
 end;

procedure Putpixel(x,y:word;farbe:byte);
 begin
  mem[$a000:320*y+x]:=farbe;
 end;

begin
 init13h;
 for t:=1 to 4 do Schnee[t].y:=random(200)+1;
 repeat
  for t:=1 to 4 do putpixel(Schnee[t].x,Schnee[t].y,6);



  for t:=1 to 4 do inc(Schnee[t].x,1);
  delay(10);

 until keypressed;
end.
