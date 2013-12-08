uses crt{,dos,strings,},graphic;
TYPE eShift = (ShiftR, ShiftL, Ctrl, Alt, Scroll, Num, Caps);
     tshift = SET OF eShift;
     tscreen=array[0..199,0..319] of byte;
     tchar=char;

const verzeichnis='c:\eigene~1\bp\simon\';
      textfile='text.txt';
      anz=10;
      text_nr:byte=1;
      text_farbe:byte=0;
      text1:array[1..anz] of string=(
      'Hi Simon!',
      'Wie gehts?',
      'Anbei:',
      'Neueste Version vom Duell !',
      'Nur Neucompilierung der Dateien',
      'ist erforderlich.',
      'Und du musst in Zeile 16',
      'von Baller.pas',
      'das Verzeichnis anpassen.',
      'Ciao, Konrad');


      verz=10; {Verz”gerung LED}
      setshift:tShift=[];
      clearshift:tShift=[];

      lauf0=[];
      lauf1=[num];
      lauf2=[num,caps];
      lauf3=[caps,scroll];
      lauf4=[scroll];
      lauf6=[];

      ein=[num,caps,scroll];
      aus=[];

var   b,c:byte;
      t,w:word;

      palette:array[0..767] of byte;
      s:string;
      Shift: tShift ABSOLUTE $0040:$0017;
      taste:char;
      screen:^tscreen;
      text2:array[1..100] of string[40];
      f:text;

procedure textread;
begin
 assign(f,verzeichnis+textfile);
 reset(f);
 w:=1;
 b:=1;
 while not eof do
  begin
  read(f,taste);
  if taste=#13 then inc(w) else text2[w][b]:=taste;
  inc(b);
  end;

end;

PROCEDURE shift_set;
BEGIN
 Shift:= Shift- ClearShift+ SetShift;
END;

procedure setpal;assembler;
asm
 push si
 mov si,offset palette
 mov cx,256*3
 xor al,al
 mov dx,03c8h
 out dx,al
 inc dx
 rep outsb
 pop si
end;

procedure key;
begin
asm
 mov ah,1
 int 16h
 jnz @nix
 mov ah,0
 int 16h
 mov taste,al

 jmp @weiter
 @nix:
 @weiter:
end;
end;

function keypr:boolean;
var r:byte;
begin
asm

 mov ah,1
 int 16h
 mov r,al
end;
 if r=0 then keypr:=false else keypr:=true;
end;


begin
 asm
  mov ax,13h
  int 10h
 end;
 getmem(screen,64000);
 screen:=ptr($a000,0);
 fillchar(palette,768,0);
 for t:=1 to 63 do palette[t*3]:=t;
 for t:=1 to 63 do palette[t*3+2]:=t;
 palette[64*3]:=63;
 palette[64*3+1]:=63;
 palette[64*3+2]:=63;


 for t:=10 to 310 do
 begin
 for w:=1 to 10 do begin screen^[10+w,t]:=t mod 63+1;
                         screen^[180+w,t]:=63-(t mod 63);
                         end;
 end;
 for t:=21 to 180 do
 begin
 for w:=1 to 10 do begin screen^[t,9+w]:=63-(t mod 63);
                         screen^[t,300+w]:=t mod 63+1;
                         end;
 end;


 outtextxy2(20,13+16*text_nr,text1[text_nr],65,screen^);
repeat
 repeat until (port[$3da] and $08)=0;
 repeat until (port[$3da] and $08)<>0;

 if c mod 2 = 1 then inc(text_farbe);

 if text_nr<anz then
 if text_farbe>=63 then
 begin
  text_farbe:=0;
  palette[65*3]:=text_farbe;
  palette[65*3+1]:=text_farbe;
  palette[65*3+2]:=text_farbe;
  outtextxy2(20,13+16*text_nr,text1[text_nr],64,screen^);
  inc(text_nr);
  outtextxy2(20,13+16*text_nr,text1[text_nr],65,screen^);
 end else
 begin
  palette[65*3]:=text_farbe;
  palette[65*3+1]:=text_farbe;
  palette[65*3+2]:=text_farbe;
 end;

 for t:=1 to 63 do
 begin
  inc(palette[t*3]);
  dec(palette[t*3+2]);
 end;
 setpal;


  inc(c);
  if c mod verz = 0 then
  begin
   inc(b);
   case b mod 6 of
   0:shift:=lauf0;
   1:shift:=lauf1;
   2:shift:=lauf2;
   3:shift:=lauf3;
   4:shift:=lauf4;
   5:shift:=lauf4;
   end;
  end;
  {key;}
  if keypressed then taste:=readkey;
  until taste=#27;
  shift:=[];
  textmode(3);
end.