unit movement;
interface
{-----Prozeduren-----}
 Procedure M_DoMove;
{--------------------}
implementation
uses vars;

Procedure M_DoMove;
var g_links,g_rechts:integer;
Begin
 if anz>0 then for t:=1 to anz do with guys[t] do
  case stat of
   fall:
    if y<boden_y-h then inc(y,guy_fspeed)
     else begin stat:=lauf; y:=boden_y-h;end;
   lauf:
   begin
    g_links:=gun.x-gb-b;
    g_rechts:=gun.x+gb+b;
    if x<g_links then
    begin
     inc(x,guy_lspeed);
     if x>=g_links then
     begin
      x:=g_links;
      stat:=schlag;
     end;
    end;
    if x>g_rechts then
    begin
     dec(x,guy_lspeed);
     if x<=g_rechts then
     begin
      x:=g_rechts;
      stat:=schlag;
     end;
    end;
   end;
  end;
 with plane do
 case stat of
  links:inc(x,speed);
  rechts:dec(x,speed);
  l_absturz:begin inc(x,speed);if y<boden_y then dec(y,p_fspeed);end;
  r_absturz:begin dec(x,speed);if y<boden_y then dec(y,p_fspeed);end;
 end;
End;

end.