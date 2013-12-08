uses crt,hardware,drive;
const anz=8;
      standardname='command.txt';
      maxlaenge=100;
Type Tscript=record
              name:string[30];
              p:Pointer;{der Pointer der auf die Prozedur zeigt}
             end;
var befehle:array[1..anz] of TScript;
    t:word;
    wort:string;
    script:array[1..maxlaenge] of string[30];
procedure Load_CFG;
var cfg:text;
begin
 assign(cfg,'config.txt');
 reset(cfg);
 readln(cfg,base);
 close(cfg);
end;

function FileExist(Filename:String):boolean;
var f:File;
begin
 assign(F,Filename);
{$I-}
 Reset(F);
 Close(F);
{$I+}
 If Ioresult=0 then Fileexist:=True else Fileexist:=False;
end;

Procedure FahreGeradeAus;
Begin
 Writeln('Es wird geradeaus gefahren');
 r_drive(vor);
 sendb(stop);
End;

Procedure Stop;
Begin
 Writeln('Es wird gestoppt');
 r_reset;
End;

Procedure LenkeLinks45;
Begin
 writeln('Es wird nach links gelenkt (45ø)...');
 sendb(links);
 delay(ddreh);
 sendb(0);
End;

Procedure LenkeLinks90;
Begin
 writeln('Es wird nach links gelenkt (90ø)...');
 sendb(links);
 delay(ddreh*2);
 sendb(0);
 {}
End;
Procedure LenkeRechts45;
Begin
 writeln('Es wird nach rechts gelenkt (45ø)...');
 sendb(rechts);
 delay(ddreh);
 sendb(0);
End;

Procedure LenkeRechts90;
Begin
 writeln('Es wird nach rechts gelenkt (90ø)...');
 sendb(rechts);
 delay(ddreh*2);
 sendb(0);
 {}
End;

Procedure CallScript(p:pointer);assembler;
asm
 call p
End;

Procedure LoadScript(filename:string);
Begin

End;

Procedure Hilfe;
Begin
 writeln('Befehle:');
 writeln('ÄÄÄÄÄÄÄÄÄÄ');
 for t:=1 to anz do with befehle[t] do
 writeln(name);
 writeln('"Ende" zum beenden');
 writeln('ÄÄÄÄÄÄÄÄÄÄ');
End;

Procedure LadeBefehle;
var anzahl:byte;
    datei:text;
    filename:string;
   count:word;
Procedure Halte;
Begin
 Writeln('Datei "',filename,'" nicht gefunden.');
 Halt;
End;
Begin
 if ParamCount=0 then
  Begin
   FileName:=standardname;
   if not FileExist(Filename) then halte;
  End else
  Begin
   FileName:=paramstr(1);
   if not FileExist(Filename) then
    if pos('.',FileName)=0 then
    Begin
     FileName:=Filename+'.txt';
     If not FileExist(Filename) then Halte;
    End;
   if paramcount=2 then Loadscript(paramstr(2));
  End;
  Assign(datei,filename);
  Reset(datei);
  count:=0;
  while not eof(datei) do
  begin
   inc(count);
   readln(datei,befehle[count].name);
  end;
  if count<>anz then write('Befehlsanzahl falsch!');
  Close(datei);
End;
Procedure Init;
var buchstb:byte;
Begin
 clrscr;
 writeln('Roboscript');
 for t:=1 to 80 do write('Ä');
 writeln;
 Load_Cfg;
 LadeBefehle;
 for t:=1 to anz do with befehle[t] do
  for buchstb:=1 to length(name) do name[buchstb]:=upcase(name[buchstb]);
 writeln('Befehle:');
 writeln('ÄÄÄÄÄÄÄÄÄÄ');
 for t:=1 to anz do with befehle[t] do
 writeln(name);
 writeln('"Ende" zum beenden');
 writeln('ÄÄÄÄÄÄÄÄÄÄ');
 befehle[1].p:=@FahreGeradeaus;
 befehle[2].p:=@stop;
 befehle[3].p:=@LenkeLinks45;
 befehle[4].p:=@LenkeLinks90;
 befehle[5].p:=@LenkeRechts45;
 befehle[6].p:=@LenkeRechts90;
 befehle[7].p:=@LoadScript;
 befehle[8].p:=@Hilfe;
End;
Procedure Main;
Begin
{ clrscr;}
 repeat
  write('>');readln(wort);
  for t:=1 to length(wort) do wort[t]:=upcase(wort[t]);
  for t:=1 to anz do if wort=befehle[t].name then CallScript(Befehle[t].p)
 until wort='ENDE';
End;

begin
 Init;
 main;
end.
{
fahre gerade aus (rasterangabe)
stop
lenke links (45ø oder 90ø)
lenke rechts (45ø oder 90ø)
wiederhole [...] bis ()
warte(Angabe in Sec)
}