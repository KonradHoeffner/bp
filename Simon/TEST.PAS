const a=10;
type tfeld=array[1..a] of byte;
var feld:tfeld;
    feld2:^tfeld;
    nummer:byte;
begin
 getmem(feld2,sizeof(tfeld));
 fillchar(feld2^,sizeof(tfeld),0);
 feld2^:=feld;
 move(feld,feld2^,sizeof(tfeld));
end.