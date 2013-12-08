uses crt;
{es gibt 2 Schiessvarianten, ich beschreibe dir mal die einfachere:
1 einziger Schuss ist da, erst wenn dieser weg ist, geht ein neuer}
var  s:record
        x,y:word;
        an:boolean;
       end;
     {also s.x=Spalte vom Schuss s.y=Zeile vom Schuss s.an: true -> schon da}
    taste:char;  {Taste                                     false-> nicht}
    spieler:record
            x,y:word;
            end;

procedure feuereinfach;
begin
 if not s.an then
 begin
 s.an:=true;{wenn keiner schon da ist}
 s.x:=spieler.x;
 s.y:=spieler.y-1;
 end;
end;

begin
clrscr;
spieler.x:=37;
spieler.y:=24;

repeat

 if keypressed then taste:=readkey else taste:='n'; {sonst geht x immer weiter}
 with spieler do {with spieler heisst: statt spieler.x reicht x aus}
 case taste of {das uebliche}
  #75:if x>1  then x:=x-1;
  #77:if x<80 then x:=x+1;
  #72:if y>1  then y:=y-1;
  #80:if y<25 then y:=y+1;
  ' ':feuereinfach;
 end;
 textcolor(15);

 if s.y>1 then s.y:=s.y-1 else {Hochbewegung des Schusses}
 begin
  s.an:=false;
  gotoxy(s.x,s.y);
  write(' ');
 end;
 {Wenn Schuss ist da:}
 if s.an then
 begin
 gotoxy(s.x,s.y+1); {letzte Position,}
 write(' ');         { l”schen}
 textcolor(yellow);
 gotoxy(s.x,s.y);   {neue P}
 write(#179);       {schreiben vom Strich}
 textcolor(white);
 end;
 {damit's nicht unten rechts hin kommt, nimms doch mal raus}
 if (spieler.x=80) and (spieler.y=25) then spieler.x:=79;

 gotoxy(spieler.x,spieler.y); {Position einstellen}

 write('x');                  {x schreiben}
 textcolor(black);            {Verstecken des Cursors}
 gotoxy(80,25);
 delay(17);                   {kurz warten,Position ist wichtig,da nun die
                              meisste Programmzeit waehrend des wartens
                              das x dasteht, danach wird es gel”scht.}
 gotoxy(spieler.x,spieler.y); {Position einstellen}
 write(' ');                  {x loeschen}

until taste=#27;   {bis Esc}

end.