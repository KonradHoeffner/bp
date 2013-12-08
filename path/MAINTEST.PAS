uses crt,navigate,hardware,drive,konrad;
const lowmem:boolean=false;
      filename='std.bar';
procedure init;
begin
 clrscr;
 writeln('Robotersoftware wird initialisiert:');
 writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
 writeln('Freier Speicher: ',memavail shr 10,'kb');
 if (memavail shr 10)<200 then
 begin
  writeln('Achtung: Speichermangel - Lowmem-Modus');
  lowmem:=true;
 end;
 write('R_Reset wird durchgef갿rt...'); r_reset;writeln('bereit');
 write('Initialisierung des Navigationssystems NS_Init...');NS_Init;writeln('bereit');
 write('Laden der Objekte aus ',filename,'...');NS_LoadMap(filename);writeln(count,' Objekte geladen');
 writeln('Freier Speicher: ',memavail shr 10,'kb');
 write('v = Objekte anzeigen, andere Taste: weiter');
 if readkey='v' then
 begin
  init13h;
  setmypalette(0,255,255,255);
  NS_showscreen(objekte^,screen);
  readkey;
  textmode(3);
 end;

end;

procedure show_weg(var dest:tscreen);
begin
 for t:=1 to count do with wp[t] do
 begin
  dest[y,x shl 1]:=255;
  dest[y,x shl 1+1]:=255;
 end;
end;


Procedure Main;
begin
 NS_Wave;
 NS_Findroute;
 init13h;
 NS_showscreen(ziel^,screen);
 show_weg(screen);
{ readln;}
 DR_PktetoScript;
 DR_DriveScript;

end;

begin
 init;
 main;
 close(f);
end.