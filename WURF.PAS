uses crt;
var taste:char;
    b,c:byte;
begin
randomize;
repeat
taste:=readkey;
clrscr;
b:=random(5)+1;
c:=random(5)+1;
writeln(b+c);
until taste=#27;
end.