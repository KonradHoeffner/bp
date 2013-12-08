unit show;
interface
uses vars,sprites,_13h,konrad;
{----Prozeduren-----}
 Procedure SH_Animate;
 Procedure SH_Show(var d:tscreen);
{-------------------}
implementation

Procedure SH_Animate;
var t,i:integer;
Begin
 for t:=1 to anz do with guys[t] do
 begin
  if stat=lauf then
  begin
   inc(fcount);
   if fcount>guy_l_framedelay then
   begin
    inc(frame);
    fcount:=0;
   end;
   if frame>guy_l_frames then frame:=1;
  end;
  if stat=schlag then
  begin
   inc(fcount);
   if fcount>guy_s_framedelay then
   begin
    inc(frame);
    fcount:=0;
   end;
   if frame>guy_s_frames then frame:=1;
  end;
  if stat=explo then
  begin
   inc(fcount);
   if fcount>guy_e_framedelay then
   if frame<guy_e_frames then
   begin
    inc(frame);
    fcount:=0;
   end else stat:=death;
  end;
 end;
 with plane do
 case stat of
  links,rechts:
  begin
   inc(fcount);
   if fcount>p_f_framedelay then
   begin
    inc(frame);
    fcount:=0;
    if frame>p_f_frames then frame:=1;
   end;
  end;
 end;
End;

Procedure SH_Show(var d:tscreen);
var t:integer;
    rohr:TPos;
Begin
 if anz>0 then for t:=1 to anz do with guys[t] do
  case stat of
   fall:putsprite(sp_f,x,y,d);
   lauf:putsprite(sp_l[frame],x,y,d);
   schlag:putsprite(sp_s[frame],x,y,d);
   explo:putsprite(sp_e[frame],x,y,d);
  end;
 with gun do
 begin
  putsprite(sp_g,x,boden_y-gh,d);
  rohr.x:=x+gb shr 1+round(cos(w*pi/180)*g_laenge);
  rohr.y:=boden_y-round(sin(w*pi/180)*g_laenge);
  line(d,x+gb shr 1,boden_y,rohr.x,rohr.y,g_col);
 end;
 with plane do
  case stat of
   links,l_absturz:putsprite(sp_p_l[frame],x,y,d);
   rechts,r_absturz:putsprite(sp_p_r[frame],x,y,d);

  end;
 fillchar(d[199,0],gun.e,4);
End;

end.