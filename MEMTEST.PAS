uses crt,konrad,_13h,_32bit;
type tfeld=array[1..64000] of byte;
var felder:array[1..840] of ^tfeld;
    t:word;
    l:longint;
begin
 clrscr;
 l:=memavail;
 write(l div 1024 div 1024);
 readkey;
{ for t:=1 to 840 do getmem(felder[t],64000);
 for t:=1 to 840 do freemem(felder[t],64000);}
end.