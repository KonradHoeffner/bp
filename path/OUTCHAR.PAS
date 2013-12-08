uses crt;
var taste:char;
begin
 repeat
  taste:=readkey;
  clrscr;
  write(ord(taste));
 until taste=#27;
end.