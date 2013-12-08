uses crt;
var pro:byte;
    t:word;
label 1;
begin
 1:
 pro:=1;
 clrscr;
 repeat
 clrscr;
 write('Kopieren zu ',pro,'% beendet ');
 for t:=1 to pro do write('.');
 delay(2000);
 inc(pro);
 until pro=100;
 goto 1;
end.