uses crt;
var zeichen:char;

begin
 clrscr;
 repeat
  zeichen:=readkey;
  gotoxy(1,1);
  write('Nummer: ',ord(zeichen),'       ');
 until zeichen=#27;
end.