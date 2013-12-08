uses crt;
const anz=6;
      namen:array[1..anz] of string=(
       'fahre gerade aus',
       'stop',
       'lenke links 45',
       'lenke links 90',
       'lenke rechts 45',
       'lenke rechts 90');


Type Tscript=record
              name:string;
              p:Pointer;{der Pointer der auf die Prozedur zeigt}
             end;
var befehle:array[1..anz] of TScript;
    t:word;
    wort:string;
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
End;

Procedure Stop;
Begin
 Writeln('Es wird gestopen');
End;

Procedure LenkeLinks45;
Begin
 writeln('Es wird nach links gelenkt (45ø)...');
End;

Procedure LenkeLinks90;
Begin
 writeln('Es wird nach links gelenkt (90ø)...');
 {}
End;
Procedure LenkeRechts45;
Begin
 writeln('Es wird nach rechts gelenkt (45ø)...');
End;

Procedure LenkeRechts90;
Begin
 writeln('Es wird nach rechts gelenkt (90ø)...');
 {}
End;

Procedure CallScript(p:pointer);assembler;
asm
 call p
End;

Procedure LadeBefehle;
const standardname='script.txt';
var anzahl:byte;
    datei:text;
    filename:string;
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
   if not FileExist(Filename) then halte;
  End;
  Assign(datei,filename);
  Reset(datei);
  Close(datei);
End;
Procedure Init;
var buchstb:byte;
Begin
 befehle[1].p:=@FahreGeradeaus;
 befehle[2].p:=@stop;
 befehle[3].p:=@LenkeLinks45;
 befehle[4].p:=@LenkeLinks90;
 befehle[5].p:=@LenkeRechts45;
 befehle[6].p:=@LenkeRechts90;
 LadeBefehle;
 for t:=1 to anz do
  for buchstb:=1 to length(namen[t]) do namen[t][buchstb]:=upcase(namen[t][buchstb]);
 for t:=1 to anz do befehle[t].name:=namen[t];
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