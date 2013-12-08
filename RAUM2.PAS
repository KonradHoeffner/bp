{$r-}
uses crt,modexlib,dos,init2;
const
 maxstern=500;  {Anzahl der Sterne}
 raus=true;    {aus dem Bild raus moeglich?}
 ra_an=true;   {Raketen m”glich}
 range=70;      {Reichweite der Raketen}
 raspeed=6;     {Geschwindigkeit der R.}
 live1=255;     {Startleben Spieler1}
 live2=255;                {     ..2}
 power=70;      {Durchschlagskraft der Raketen}

 brems=5;       {je kleiner, desto mehr Bremskraft}
 gesch1=3;      {Geschwindigkeit}
 gesch2=3;
 spieler1x=20;  {Startposition}
 spieler1y=20;
 spieler2x=200;
 spieler2y=50;
 mx=10;         {Spritegr”áe}
 my=10;
 mspieler:array[0..mx*my-1]of byte=
  (00,00,01,00,01,01,00,01,00,00,
  00,00,01,01,01,01,01,01,00,00,
  00,00,01,00,01,01,00,01,00,00,
  00,01,00,00,01,01,00,00,01,00,
  01,00,00,00,01,01,00,00,00,01,
  01,00,00,00,01,01,00,00,00,01,
  01,00,00,00,01,01,00,00,00,01,
  01,00,00,00,01,01,00,00,00,01,
  01,01,01,01,01,01,01,01,01,01,
  01,00,00,00,00,00,00,00,00,01);




type screentype=array[0..199,0..319] of byte;

{ÄÄÄÄÄÄÄÄÄÄÄSterneÄÄÄÄÄÄÄ}
var sterne:array[0..maxstern] of record
                              x,y,ebene:integer;
                            end;
    st_nr:Word;
{ÄÄÄÄÄÄÄÄInterruptÄÄÄÄÄÄÄ}
    saveint8:pointer;
    mode:byte absolute $0000:$0449;
    {Videomodus}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
    s:longint;
    mgegner:array[0..mx*my-1]of byte;
    screen:^screentype;
    taste:char;
    i,j,k,x,x2:word;
    r,r2,b,feuer,feuer2:byte;
    en:boolean; {ist TRUE wenn e(S/G) =255}
    spieler,gegner:record
                    x,y:word;
                    e,live:byte;
                    speedx,speedy:shortint;
                    name:string;
                   end;
     ra:record
            an:boolean;
            oldx,x:word;
            count,oldy,y:byte;
            end;

Function ShiftState:Byte;

Var Regs:Registers;

begin
 Regs.Ah:=2;
 Intr($16,Regs);
 ShiftState:=Regs.Al;
end;

Function Control:Boolean;

begin
 Control:=(ShiftState and 4) <> 0;
end;



procedure checkscreen; interrupt;
   var i: Word;
begin
  inline($9C/$FF/$1E/saveint8);



  if feuer>0 then
  begin
{   fillchar(screen2^[r,x],200,0);
   fillchar(screen2^[r+2,x],200,0);}
   r:=random(6)+3+spieler.y;
   x:=spieler.x+15;
   if (gegner.y<r+5) and (gegner.y>r-5) then if gegner.live>2 then dec(gegner.live,3) else gegner.live:=0;
  end;

  if feuer2>0 then
  begin
{   fillchar(screen2^[r2,x2-200],200,0);
   fillchar(screen2^[r2+2,x2-200],200,0);}
   r2:=random(6)+3+gegner.y;
   x2:=gegner.x+15;
   if (spieler.y<r2+5) and (spieler.y>r2-5) then if spieler.live>2 then dec(spieler.live,3) else spieler.live:=0;
  end;

  if feuer>1 then
  begin

{   fillchar(screen2^[r,x],200,191);
   fillchar(screen2^[r+2,x],200,191);}
  end;
  if feuer2>1 then
  begin

{   fillchar(screen2^[r2,x2-200],200,191);
   fillchar(screen2^[r2+2,x2-200],200,191);}
  end;
  if spieler.e<255 then inc(spieler.e);
  if gegner.e<255 then inc(gegner.e);
end;


procedure init;


begin
 clrscr;
{ textcolor(15);
 write('                      Raumschiffschlacht 1.0 - ');
 textcolor(14);
 writeln('Konrad H”ffner');
 writeln;
 textcolor(7);
 writeln('Bei diesem Spiel mssen sie ihren Gegner ausl”schen,');
 writeln('indem sie ihn mit dem Laser beschieáen.');
 writeln('Ihre Feuerkraft wird von den zwei Balken am unteren');
 writeln('Bildschirmrand bestimmt:');
 writeln('Linker Balken =Spieler 1 (Rot)');
 writeln('Rechter Balken=Spieler 2 (Blau)');
 writeln('Je heller der Balken ist, um so mehr Lebensenergie besitzen');
 writeln('sie.');
 writeln;
 writeln('Steuerung:');
 writeln;
 writeln('        Spieler1      Spieler2');
 writeln;
 writeln('Oben:   Cusor         "E"');
 writeln('Unten     -           "D"');
 writeln('Links     -           "S"');
 writeln('Rechts    -           "F"');
 writeln('Feuer    LEER         STRG');
 writeln;
 textcolor(13);
 write('Spielername1: ');textcolor(15);readln(spieler.name);
 textcolor(13);
 write('Spielername2: ');textcolor(15);readln(gegner.name);}
 getintvec(8,saveint8);
 setintvec(8,addr(checkscreen));
 {Interrupt verbiegen}
 initvesa($115);
 for i:=0 to 9 do
 for j:=1 to 15 do mgegner[i*mx+j]:=mspieler[i*mx+14-j] shr 1;
 spieler.e:=255;
 gegner.e:=255;
 spieler.live:=live1;
 gegner.live:=live2;
 screen:=ptr($a000,0);
 randomize;
 spieler.x:=spieler1x;
 spieler.y:=spieler1y;
 spieler.speedx:=0;
 spieler.speedy:=0;
 gegner.x:=spieler2x;
 gegner.y:=spieler2y;
 en:=false;

end;

begin
 init;
 {Anfang der Schleife}
  for s:=0 to 800 do puttruepixel(s,s,(254 shl 8)+254,254);
 repeat    {gbr}

{  for i:=1 to 800 do puttruepixel(i,49,(254 shl 8)+254,254);}
{  for i:=1 to 100 do puttruepixel(0,i,(254 shl 8)+254,254);
  for i:=1 to 100 do puttruepixel(100,i,(254 shl 8)+254,254);}
                        waitretrace;

 {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄSterneÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
      For St_nr:=0 to maxstern do Begin
      With Sterne[st_nr] do Begin
{        screen2^[y,x]:=0;}
{         puttruepixel(x,y,0,0);}
        Dec(x,Ebene shr 5 + 1);
        if x <= 0 Then Begin
          x:=799;
          y:=Random(599);
          Ebene:=Random(256);
        End;
        {screen2^[y,x]:=Ebene shr 4 ;}
{        puttruepixel(x+y*800,0,$ffff,$ff);}
      End;
    End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}


{    72
  75    77
     80    }
 if ra.an then
  begin
{   screen2^[ra.oldy,ra.oldx]:=0;
   screen2^[ra.y,ra.x]:=191;}
   if b mod 5 = 0 then
   begin
    if ra.count=0 then ra.an:=false else
    begin
     dec(ra.count);
     ra.oldx:=ra.x;
     ra.oldy:=ra.y;
     if ra.x>spieler.x then dec(ra.x,raspeed) else inc(ra.x,raspeed);
     if ra.y>spieler.y then dec(ra.y,raspeed) else inc(ra.y,raspeed);
    end;
   end;
     if ((ra.y<spieler.y+5) and (ra.y>spieler.y-5)) and
     ((ra.x<spieler.x+5) and (ra.x>spieler.x-5))
    then begin ra.an:=false; if spieler.live>power then dec(spieler.live,power) else spieler.live:=0; end;
  end;
{ if en=false then
 begin}
{ fillchar(screen2^[199,0],320,0);
 fillchar(screen2^[199,0],trunc(spieler.e / 255*160),128+spieler.live shr 2);
 fillchar(screen2^[199,160],trunc(gegner.e / 255*160),192+gegner.live shr 2);}
{ end;  }

{ if (spieler.e=255) and (gegner.e=255) then en:=true else en:=false;}



 if keypressed then
 begin

  taste:=readkey;
  case taste of
   #72:if spieler.speedy>-122 then dec(spieler.speedy,gesch1);
   #80:if spieler.speedy<122 then inc(spieler.speedy,gesch1);
   #75:if spieler.speedx>-122 then dec(spieler.speedx,gesch1);
   #77:if spieler.speedx<122 then inc(spieler.speedx,gesch1);
   ' ':if spieler.e>10 then begin dec(spieler.e,10); if feuer<240 then inc(feuer,15); end;

   'r':if ra_an=true then if ra.an=false then begin ra.count:=range;ra.an:=true; ra.x:=gegner.x+10;ra.y:=gegner.y+5; end;
   'e':if gegner.speedy>-122 then dec(gegner.speedy,gesch2);
   'd':if gegner.speedy<122 then inc(gegner.speedy,gesch2);
   's':if gegner.speedx>-122 then dec(gegner.speedx,gesch2);
   'f':if gegner.speedx<122 then inc(gegner.speedx,gesch2);
  end;
 end;
 if b mod 8=0 then if control then if gegner.e>10 then begin dec(gegner.e,10); if feuer2<240 then inc(feuer2,15); end;

 inc(b);


 if feuer>0 then dec(feuer);
 if feuer2>0 then dec(feuer2);
{   for i:=0 to 9 do fillchar(screen2^[spieler.y+i,spieler.x],15,0);
   for i:=0 to 9 do fillchar(screen2^[gegner.y+i,gegner.x],15,0);}
   if spieler.speedx<>0 then
   begin inc(spieler.x,spieler.speedx);
    if b mod brems=0 then if spieler.speedx>0 then dec(spieler.speedx) else inc(spieler.speedx);
   end;

   if gegner.speedx<>0 then
   begin
    inc(gegner.x,gegner.speedx);
    if b mod brems=0 then if gegner.speedx>0 then dec(gegner.speedx) else inc(gegner.speedx);
   end;


   if spieler.speedy<>0 then
   begin
    inc(spieler.y,spieler.speedy);
    if b mod brems=0 then if spieler.speedy>0 then dec(spieler.speedy) else inc(spieler.speedy);
   end;

   if gegner.speedy<>0 then
   begin
    inc(gegner.y,gegner.speedy);
    if b mod brems=0 then if gegner.speedy>0 then dec(gegner.speedy) else inc(gegner.speedy);
   end;


{  for i:=0 to 9 do move(mspieler[i*15],screen2^[spieler.y+i,spieler.x],15);
  for i:=0 to 9 do move(mgegner[i*15],screen2^[gegner.y+i,gegner.x],15);}

 if raus then
 begin
  if (spieler.x>310) or (spieler.x<10) then spieler.speedx:=-spieler.speedx;
  if (spieler.y>200) or (spieler.y<10) then spieler.speedy:=-spieler.speedy;
 end;

 until ((taste=#27) or (gegner.live=0)) or (spieler.live=0);
 {Ende der Schleife}
 textmode(3);
 {Wenn nicht Esc gedrckt:}
 if taste<>#27 then
 begin
  textcolor(15);
  write('Gewonnen hat: ');
  textcolor(14+blink);
  if spieler.live>0 then begin write(spieler.name); writeln(' ',trunc((spieler.live/live1*100)),'%'); end
                    else begin write(gegner.name); writeln(' ',trunc((gegner.live/live2*100)),'%'); end;

  textcolor(white);
  write('Verloren hat: ');
  textcolor(14+blink);
  if spieler.live>0 then writeln(gegner.name)
                    else writeln(spieler.name);
  end;
  textcolor(white);
  writeln('Raumschiffschlacht 1.0 - 1997 KONRAD H™FFNER.');
  writeln;
  textcolor(7+blink);
  write('ENTER drcken...');
  readln;


 end.