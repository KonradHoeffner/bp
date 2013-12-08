uses konrad,crt,roboter;
const      count:byte=1;
      anz=100;
type  tposs=(rv,rrv,rrrv,r,lv,llv,lllv,v);
{pos=POSition poss=POSSibility !}
var wp:array[1..anz] of tpos;{Wegpunkte}
    script:array[1..anz] of tposs;
    p,p2:tpos;
    poss:tposs;
    Rf:shortint;{Richtung, -4 bis 4, 0=vor -4=4}
    f:text;

procedure pktetoscript;
var t:word;
    pp:tpos;
    s:tposs;
begin
 pp:=wp[1];
 for t:=2 to count do with wp[t] do
 begin
  if x-pp.x=1 then
  begin
   if y-pp.y=1 then s:=rrrv else
    if y-pp.y=-1 then s:=rv else
     s:=rrv;
  end
   else if x-pp.x=-1 then
  begin
    if y-pp.y=1 then s:=lllv else
    if y-pp.y=-1 then s:=lv else
     s:=llv;
  end else
  begin
   if y-pp.y=-1 then s:=v else
     s:=r;
  end;
  pp:=wp[t];
  script[t-1]:=s;
 end;
end;

procedure drivescript;
begin
 for t:=1 to count do
 begin
  case script[t] of
   v:dreh(0);
   r:dreh(4);
   lv:dreh(-1);
   llv:dreh(-2);
   lllv:dreh(-3);
   rv:dreh(1);
   rrv:dreh(2);
   rrrv:dreh(3);
  end;
{  sendb(vor);}
  writeln(f,'Vorw„rts fahren');
  delay(dvor);
 end;
 r_reset;
end;

procedure main;
var t:word;
begin
 inc(windmax,256);
 wp[1].x:=40;
 wp[1].y:=12;
 p2:=wp[1];
 repeat
  if keypressed then taste:=readkey;
  maus_abfrage;p.x:=maus.x shr 3+1;p.y:=maus.y shr 3+1;
  if (maus.taste=1) then if((p.x<>p2.x) or (p.y<>p2.y)) then
   if (abs(p.x-p2.x)<2) and (abs(p.y-p2.y)<2) then
   begin
    inc(count);
    wp[count]:=p;
    p2:=p;
   end;
  waitretrace;
  clrscr;
  for t:=1 to count do with wp[t] do
  begin
   gotoxy(x,y);
   write('x');
  end;
  gotoxy(p.x,p.y);write('²');
  gotoxy(1,26);
  if taste=#27 then halt;
 until taste=#13;
 pktetoscript;
 dec(count);
 drivescript;
end;

begin
 assign(f,'log.txt');
 rewrite(f);
 maus_init;
 main;
 close(f);
end.