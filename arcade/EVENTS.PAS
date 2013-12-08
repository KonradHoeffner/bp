unit events;
interface
{-----Prozeduren-----}
 Procedure E_Events;
 Procedure E_Kollision;
implementation
uses vars;
{--------------------}
 Procedure Plane_Handling;Forward;
 Procedure NewGuy(nx,ny:integer);Forward;
{--------------------}

Procedure Plane_Handling;
Begin
 with plane do
 begin
  case stat of
   out:
   begin
    inc(unused);
    if unused>P_timer then
    begin
     if random(2)=0 then begin stat:=links;x:=p_l_xstart;end else
                         begin stat:=rechts;x:=p_r_xstart;end;
     y:=p_hoehe;
     speed:=p_startspeed;
     fcount:=0;
     frame:=p_f_startframe;
    end;
   end;
   links:if x>p_l_xend then begin stat:=out; unused:=0; end;
   rechts:if x<p_r_xend then begin stat:=out; unused:=0; end;
  end;
  if (stat=links) or (stat=rechts) then
  begin
   inc(abwurf);
   if abwurf>p_abwurftimer then
   begin
    NewGuy(x,y+ph);
    abwurf:=0;
   end;
  end;
 End;
End;
Procedure E_Events;
Begin
 Plane_Handling;
End;

Procedure NewGuy(nx,ny:integer);
Begin
 if anz<max then
 begin
  inc(anz);
  with guys[anz] do
  begin
   x:=nx;
   y:=ny;
   stat:=fall;
   frame:=guy_l_start_frame;
  end;
 end;
End;

Procedure ClearGuy(nr:integer);
Begin
 guys[nr]:=guys[nr]; {Errorchecking}
 if (anz>1) and (nr<anz) then
 begin
  move(guys[nr+1],guys[nr],sizeof(tguy)*(anz-nr));
 end;
 dec(anz);
End;

Procedure E_Kollision;
var t:word;
Begin
 for t:=1 to anz do with guys[t] do
 begin
 if not godmode then
  if stat=schlag then
   if (fcount=0) and (frame=1) then dec(gun.e,damage_s1);
  if gun.e<=0 then
  begin
   gun.e:=0;
   gameover:=true;
  end;
 if stat=death then ClearGuy(t);
 end;
End;

end.