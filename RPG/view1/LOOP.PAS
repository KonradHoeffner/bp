unit loop;
interface
{-----Prozeduren-------}
 Procedure L_Loop;
{----------------------}
implementation
uses crt,konrad,sprites,_32bit,show,vars{,movement};
{-----Prozeduren-------
Procedure Abfrage;
Procedure SH_Show(var d:tscreen); <- in show.pas
Procedure LoadMap;
}

Procedure Abfrage;
var oldx,oldy:word;
Begin
 maus_abfrage;maus.x:=maus.x shr 1;
 if keypressed then taste:=readkey else taste:='n';
  oldx:=s.x;oldy:=s.y;
  with s do case taste of
   TLeft,'4','7','1':if x>0 then dec(x);
   TRight,'6','9','3':if x<felder_x-1 then inc(x);
   TUp,'8':if y>0 then dec(y);
   TDown,'2':if y<felder_y-1 then inc(y);
  end;
  with s do case taste of
   '7','9':if y>0 then dec(y);
   '1','3':if y<felder_y-1 then inc(y);
  end;
{ if feld_status[map^[y,x]]=nowalk then begin x:=oldx; y:=oldy; end;}
 with s do
 begin
  inc(vp.x,x-vp.x-10);
  inc(vp.y,y-vp.y-6);
  if vp.x<0 then vp.x:=0;
  if vp.y<0 then vp.y:=0;
  if vp.x>felder_x-20 then vp.x:=felder_x-20;
  if vp.y>felder_y-12 then vp.y:=felder_y-12;
 end;
End;

Procedure L_Loop;
Begin
 repeat
  abfrage;
{  M_DoMove;}
  SH_show(screen1^);
  waitretrace;
  movelongint(screen1^,screen,16000);
 until taste=#27;
End;

end.