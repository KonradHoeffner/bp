uses vesa,crt;
begin
 initvesa($112);
 fillchar(mem[$a000:0],64000,15);
  readkey;
 initvesa(3);
end.