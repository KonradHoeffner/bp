uses _32bit,konrad,crt;
type tscreen=array[0..63999] of byte;
var t:word;
    bild1,bild2:^tscreen;

procedure init;
begin
 asm
  mov ax,13h
  int 10h
 end;
 readpal('flammen.pal');
 setpal;

end;

begin
 repeat

 until keypressed;
end.