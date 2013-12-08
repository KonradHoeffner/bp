uses crt,_32bit,konrad;
const s:array[0..9] of byte=(1,15,1,1,15,15,1,15,1,15);
var b:byte;y:byte;
begin
 init13h;
 randomize;
 repeat
   for y:=1 to 200 do for t:=1 to 31 do movelongint(s,screen[y,t*10+random(20)],10);
 until keypressed;
 textmode(3);
end.