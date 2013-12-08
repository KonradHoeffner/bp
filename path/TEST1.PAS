uses roboter,crt;
var c:char;

begin
 clrscr;
 repeat
  if keypressed then
  begin
   c:=readkey;
   case c of
    #8:r_reset;
    #72:sendb(vor);
    #80:sendb(rueck);
    #75:sendb(links);
    #77:sendb(rechts);
   end;
  end;
 until c=#27;
 readkey;
 r_reset;
end.