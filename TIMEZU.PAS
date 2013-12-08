(*$M 1024,0,0 *)
uses dos;
var  saveint8: pointer;
     tickcount,st,m,s,hs,z,z2: word;


procedure checkscreen; interrupt;
   var i: Word;
begin
  inline($9C/$FF/$1E/saveint8);
  inc(tickcount);
  if i mod 18=0 then
  begin
   if trunc(tickcount / 18.2) >= z then settime(st,m,s,hs);
  end;
end;

begin
  gettime(st,m,s,hs);
  val(paramstr(1),z,z2);
  if (paramstr(1)='') or (z2<>0) then
  begin
  writeln('Aufrufparameter (Sekunden) erwartet!');
  halt;
  end;
  tickcount:=0;
  getintvec(8,saveint8);
  setintvec(8,addr(checkscreen));
  keep(0);
end.
