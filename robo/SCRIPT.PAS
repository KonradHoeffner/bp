uses crt;
const anz=6;
       standardname='script.txt';
Type Tscript=record
              name:string;
              p:Pointer;{der Pointer der auf die Prozedur zeigt}
             end;
var befehle:array[1..anz] of TScript;
    t:word;
    wort:string;
    namen:array[1..anz] of string;

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
 Writeln('Es wird gestoppt');
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
  End;

  Assign(datei,filename);
  Reset(datei);
  count:=0;
  while not eof(datei) do
  begin
   inc(count);
   readln(datei,befehle[count].name);
  end;
  Close(datei);
End;
Procedure Init;
var buchstb:byte;
Begin
 LadeBefehle;
 befehle[1].p:=@FahreGeradeaus;
 befehle[2].p:=@stop;
 befehle[3].p:=@LenkeLinks45;
 befehle[4].p:=@LenkeLinks90;
 befehle[5].p:=@LenkeRechts45;
 befehle[6].p:=@LenkeRechts90;
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