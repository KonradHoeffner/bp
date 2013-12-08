unit loop;
interface
{-----Prozeduren-------}
 Procedure L_Loop;
{----------------------}
implementation
uses crt,konrad,sprites,_32bit,show,vars,movement;
{-----Prozeduren-------
Procedure Abfrage;
Procedure SH_Show(var d:tscreen); <- in show.pas
}
Procedure Abfrage;
Begin
 maus_abfrage;maus.x:=maus.x shr 1;
 if keypressed then taste:=readkey;
{  case taste of
  end;}
End;

Procedure L_Loop;
Begin
 repeat
  abfrage;
  M_DoMove;
  SH_show(screen1^);
  waitretrace;
  movelongint(screen1^,screen,16000);
 until taste=#27;
End;

end.