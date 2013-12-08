var taste:char;

begin
 repeat
  if keypressed then
  begin
   intr($60);
  end;
 until taste=#27;
end.