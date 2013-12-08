var taste:char;
begin
 write('Wirklich REBOOTen? (J/N) ');
 readln(taste);
 if upcase(taste)='J' then asm int 19h end;
end.