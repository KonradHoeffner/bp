uses crt;
 Function Distance(x1,y1,x2,y2:integer):integer;
 Begin
  Distance:=trunc(sqrt((sqr(x2-x1)+sqr(y2-y1))));
 End;

begin
 writeln(Distance(0,0,319,0));
 readln;
end.