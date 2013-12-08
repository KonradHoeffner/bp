(*$M 1024,0,0 *)

uses dos,crt;

var
    saveint1: pointer;
         { fr den ursprnglichen timer-interruptvektor }

procedure taste; interrupt;

begin
  if keypressed then
  begin
   sound(100); {Zum Test-sp„ter 4000 zur gr”áten nerv-Wirkung}
   delay(20);
   nosound;
  end;
  inline($9C/$FF/$1E/saveint1);

end;

begin
  getintvec(1,saveint1);
  setintvec(1,addr(taste));
  keep(0);
end.