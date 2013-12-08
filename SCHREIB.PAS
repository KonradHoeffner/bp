uses konrad,crt;
type kontype= record
               x,y:word;              {...864 frei}
               pal:array[0..767] of byte;
               bild:array[0..199,0..319] of byte;
              end;
var f:file of kontype;
    name,text:string;
    x:byte;
    w:word;
    ch:char;

function exist(datei:string):byte;
begin
{$I-}
exist:=ioresult;
{$I+}
end;

procedure open;
begin
 Assign(F,name);
 Reset(F);
 Close(F);
end;

procedure neu;
begin
 Assign(F, 'test.kon');
 Rewrite(F);
 Close(F);
end;

begin
 clrscr;
 writeln('1: Neu');
 writeln('2: ™ffnen');
 readln(x);
 if x=1 then begin
 neu;
 end;
 if x=2 then begin
 {write('Dateiname:');readln(name);}
 name:='test.tst';
 open;
 end;
 readln;
{ init13h;}
end.