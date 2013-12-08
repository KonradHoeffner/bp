unit loop;
interface
{-----Prozeduren-------}
 Procedure L_Loop;
{----------------------}
implementation
uses crt,konrad,sprites,_32bit,show,vars,movement,events;
{-----Prozeduren-------
Procedure NewGuy(nx,ny:integer);
Procedure Abfrage;
Procedure Logic;
Procedure SH_Show(var d:tscreen); <- in show.pas
}

Procedure KillGuy(nr:integer);
Begin
 with guys[nr] do
 begin
  stat:=explo;
  fcount:=0;
  frame:=1;
 end;
End;

Procedure Abfrage;
Begin
 maus_abfrage;maus.x:=maus.x shr 1;
 with gun do
 begin
  dec(w,maus.x-160);
  if w>g_maxw then w:=g_maxw;
  if w<g_minw then w:=g_minw;
 end;
 setmaus(320,100);
 if keypressed then taste:=readkey;
  case taste of
{   '+':with plane do if (stat=links) or (stat=rechts) then begin newguy(x,y+ph); taste:='n';end;}
   '-':if anz>0 then for t:=1 to anz do begin if guys[t].stat<>explo then killguy(t); taste:='n';end;
 {  TLeft:with gun do if w<180-g_wspeed then inc(w,g_wspeed);
   TRight:with gun do if w>g_wspeed then dec(w,g_wspeed);}
  end;
End;

Procedure L_Loop;
Begin
 repeat
  abfrage;
  M_DoMove;
  E_Kollision;
  E_Events;
  SH_Animate;
  SH_show(screen1^);
  waitretrace;
  movelongint(screen1^,screen,16000);
  if doBG then movelongint(backgr^,screen1^,16000)
          else filllongint(screen1^,16000,0);
 until (taste=#27) or gameover;
End;

end.