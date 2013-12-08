uses pcx,konrad,crt;
var ziegel:array[0..49,0..49] of byte;
    x,y:word;
begin
 Init13h;
 LoadPCX('ziegel1.pcx',ziegel,palette);
 setpal;
 for y:=0 to 49 do move(ziegel[y,0],screen[y,0],50);
 readkey;
end.