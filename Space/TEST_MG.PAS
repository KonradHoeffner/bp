uses uspace,crt,mausu,_32bit;
const clangsam=128;
      cmaxanz=500;
      cnachlad_mg=5;
      cgesch={clangsam+}20;

type k_type=array[1..cmaxanz]  of record
                                    x,y:integer;
                                    farbe:boolean;
                                   end;

var palette:array[0..767] of byte;
    t:word;
    mg:record
        anz:byte;
       end;
    grau:boolean;
    kugeln,dummy:k_type;
    nachlad,langsam:byte;
    farb:boolean;

procedure feuer;
begin
 nachlad:=cnachlad_mg;
 inc(mg.anz);
 with kugeln[mg.anz] do
 begin
  farb:=not farb;
  x:=maus.x shr 1;
  y:=maus.y-3;
 if farb then farbe:=true else farbe:=false;
 end;
end;

procedure schuss;
begin
 if nachlad>1 then dec(nachlad);

 for t:=1 to mg.anz do with kugeln[t] do
 begin
  if y>cgesch then
  begin
  dec(y,cgesch+random(4));

  if farbe then
  begin
   bild^[y,x-3]:=15;
   bild^[y,x+1-3]:=8;
   bild^[y+1,x-3]:=15;
   bild^[y+1,x+1-3]:=8;

   bild^[y,x+3]:=8;
   bild^[y,x+1+3]:=15;
   bild^[y+1,x+3]:=8;
   bild^[y+1,x+1+3]:=15;
  end else
  begin
   bild^[y,x-3]:=8;
   bild^[y,x+1-3]:=15;
   bild^[y+1,x-3]:=15;
   bild^[y+1,x+1-3]:=8;

   bild^[y,x+3]:=15;
   bild^[y,x+1+3]:=8;
   bild^[y+1,x+3]:=8;
   bild^[y+1,x+1+3]:=15;

  end;

  end
         else begin
               {bild^[y,x]:=0;}
               {if t=1 then
               begin}
                move(kugeln,dummy,cmaxanz);
                move(dummy[2],kugeln[1],mg.anz-1);
               {end;}
               dec(mg.anz);
              end;
 end;
 waitretrace;
 {for t:=1 to mg.anz do with kugeln[t] do bild^[y,x]:=0;}
 filllongint(bild^,16000,0);
end;

begin
 mg.anz:=1;
 asm
  mov ax,13h
  int 10h
 end;
 init;
 nachlad:=1;
 repeat
  bild^[maus.y,maus.x shr 1]:=0;
  abfrage;
  bild^[maus.y,maus.x shr 1]:=15;
  if ((maus.taste=1) and (mg.anz+1<cmaxanz)) and (nachlad=1) then feuer;
  schuss;
 until maus.taste=3;
end.
