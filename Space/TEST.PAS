uses crt,uspace;
var p:boolean;
    pal:byte;
begin
clrscr;
pal:=1;
p:=true;

textcolor(1);
repeat

 if p then
 begin
  if pal<255 then inc(pal) else p:=false;
 end
      else
 begin
  if pal>1 then dec(pal) else p:=true;
 end;
gotoxy(1,1);
write(pal);
delay(10);
gotoxy(1,1);
write('     ');
palette[0]:=pal shr 2;
palette[3]:=(255-pal) shr 2;
setpal;
until keypressed;
textmode(3);
end.