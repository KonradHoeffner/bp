unit GameData;

interface

uses Download,grafik,uni;
const muni_kosten:array[1..9] of byte=
(1,1,2,4,1,3,4,5,1);


procedure GetFire{šberprft ob noch genug Muni da ist um zu schieáen};
procedure ShowPlayer;
procedure DelPlayer;
procedure Tasten;
procedure SetSchuss;
procedure ShowSchuss;
procedure DelSchuss;
procedure Limits;
procedure SetStones;

implementation

procedure GetFire;
 begin
  if w[p1.act_weapon].wahr then if s2.muni>=muni_kosten[p1.act_weapon] then pressfire:=true else pressfire:=false;
end;

procedure ShowPlayer;
 begin
  if Splayer then
   begin
    if p1.richtung = 1 then begin paint15(p1.x,p1.y,p1o); end;
    if p1.richtung = 2 then begin paint15(p1.x,p1.y,p1w); end;
    if p1.richtung = 3 then begin paint15(p1.x,p1.y,p1n); end;
    if p1.richtung = 4 then begin paint15(p1.x,p1.y,p1s); end;
   end;
 end;

procedure DelPlayer;
 begin
  paint15(p1.x,p1.y,black15);
 end;

procedure Tasten;
var nr:byte;
    code:integer;
 begin
  key:='n';
  keys;
   case key of
   #77 : begin p1.richtung:=1; inc(p1.x,15); end;
   #75 : begin p1.richtung:=2; dec(p1.x,15); end;
   #72 : begin p1.richtung:=3; dec(p1.y,15); end;
   #80 : begin p1.richtung:=4; inc(p1.y,15); end;
   'x' : dec(p1.leben);
   end;
  val(key,nr,code);
  if key in ['1'..'9'] then if w[nr].wahr then p1.act_weapon:=nr;
  if PressFire then
   begin
    if key = #32 then
     begin
      inc(anz);
      s1[anz].richtung:=p1.richtung;
      s1[anz].x:=p1.x;
      s1[anz].y:=p1.y;
      s1[anz].wahr:=true;

      if (W[1].wahr) and (W[1].anz = 1) then dec(s2.muni,1);
      if (W[2].wahr) and (W[2].anz = 2) then dec(s2.muni,1);
      if (W[3].wahr) and (W[3].anz = 3) then dec(s2.muni,2);
      if (W[4].wahr) and (W[4].anz = 4) then dec(s2.muni,4);
      if (W[5].wahr) and (W[5].anz = 5) then dec(s2.muni,1);
      if (W[6].wahr) and (W[6].anz = 6) then dec(s2.muni,3);
      if (W[7].wahr) and (W[7].anz = 7) then dec(s2.muni,4);
      if (W[8].wahr) and (W[8].anz = 8) then dec(s2.muni,5);
      if (W[9].wahr) and (W[9].anz = 9) then dec(s2.muni,1);
     end;
   end;
 end;

procedure SetSchuss;
 begin
  for t:=0 to anz do
   begin
    if s1[t].wahr then
     begin
      if s1[t].richtung = 1 then inc(s1[t].x,15);
      if s1[t].richtung = 2 then dec(s1[t].x,15);
      if s1[t].richtung = 3 then dec(s1[t].y,15);
      if s1[t].richtung = 4 then inc(s1[t].y,15);
     end;
   end;
 end;

procedure ShowSchuss;
 begin
  for t:=0 to anz do
   begin
    if (s1[t].x>14) and (s1[t].x<200) and (s1[t].y>14) and (s1[t].y<170) then
     begin
      if (w[p1.act_weapon].wahr) then paint15(s1[t].x,s1[t].y,CWaffen[p1.act_weapon]);
     end;
   end;
 end;

procedure DelSchuss;
 begin
  for t:=0 to anz do
   begin
    if (s1[t].x>14) and (s1[t].x<200) and (s1[t].y>14) and (s1[t].y<170) then
    paint15(s1[t].x,s1[t].y,black15);
   end;
 end;

procedure Limits;
 begin
  for t:=0 to s2.muni do
   begin
    if (s1[t].x>-15) and (s1[t].x<304) and (s1[t].y>-15) and (s1[t].y<185) then
    Sshoot[t]:=true else Sshoot[t]:=false;
   end;

  If Sshoot[t]=false then S1[t].wahr:=false;

  if (p1.x>14) and (p1.x<200) and (p1.y>14) and (p1.y<174) then
   Splayer:=true else Splayer:=false;

  if Splayer = false then
   begin
    p1.x:=p1.oldx;
    p1.y:=p1.oldy;
   end;

  for t:=0 to MaxStones-1 do
   for t2:=0 to MaxStones-1 do
    begin
     if (p1.x=t*30) and (p1.y=t2*30) then
      begin
       p1.x:=p1.oldx;
       p1.y:=p1.oldy;
      end;

     for t3:=0 to s2.muni do
      begin
        if (s1[t3].x=t*30) and (s1[t3].y=t2*30) then
         begin
          s1[t3].wahr:=false;
          s1[t3].x:=0;
          s1[t3].x:=0;
          paint15(s1[t3].x,s1[t3].y,stone);
         end;
      end;
    end;
 end;

procedure SetStones;
 begin
  for t:=0 to MaxStones-1 do
   for t2:=0 to MaxStones-1 do
   begin
    paint15(t*30,t2*30,Stone);
   end;

  for t:=0 to 14-1 do paint15(t*15,0,stone);
  for t:=0 to 12-1 do paint15(0,t*15,stone);
  for t:=0 to 12-1 do paint15(210,t*15,stone);
  for t:=0 to 15-1 do paint15(t*15,180,stone);
 end;

begin
end.