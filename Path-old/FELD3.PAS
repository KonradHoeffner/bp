uses crt,konrad,_32bit,dos;

const startx=150;
      starty=30;
      ZielX=80;
      ZielY=100;
      Verstaerkung=2;
{Maximum=1000 -> /4 =250}
      ShiftRight=0;
      Obj_Intensity=20;{shl Verstaerkung}
      o1x1=30;
      o1y1=40;
      o1x2=60;
      o1y2=60;
      o2x1=120;
      o2y1=120;
      o2x2=140;
      o2y2=150;

type Karte=array[-1..200,0..159] of word;
var w:word;
    i:Integer;
    Objekte,Ziel:^Karte;
    t,h,h2,m,m2,s,s2,hs,hs2:word;
    diff:real;
   count:word;
procedure init;
begin
 Getmem(Objekte,sizeof(Karte));
 Getmem(Ziel,sizeof(Karte));
 Filllongint(Objekte^,sizeof(Karte) shr 2,0);
 Filllongint(Ziel^,sizeof(Karte) shr 2,0);

 Init13h;
 Fillchar(Palette,3,0);
 for t:=1 to 254 do
  fillchar(palette[t*3],3,t shr 2);
 palette[255*3]:=63;
 palette[255*3+1]:=0;
 palette[255*3+2]:=0;
 setpal;
end;

Procedure Show_Screen(var target);          {kopiert fertigen Bilschirm auf VGA}
{Var temp:Pointer;}               {zum Tauschen der Zeiger}
Begin
asm
  push ds
  lds si,target             {fertiges Bild als Objekte}
  add si,320
  mov ax,0a000h
  mov es,ax
  xor di,di
  mov cx,160*200
  @Loop1:
  mov ax,[si]
  shr ax,ShiftRight
  mov ah,al
  stosw
  add si,2
  dec cx
  jnz @Loop1
  pop ds
End;
{  temp:=Ziel;
  Ziel:=Objekte;
  Objekte:=temp;}
End;

Procedure Soft_Feld_Down(var target);assembler;
asm
  cli
  push ds
  lds si,target             {Zeiger auf Zielbild laden}
  mov cx,160*200
  add si,320
  add di,320
  xor bx,bx
@lp1:
  mov ax,[si]
  or ax,ax
  jz @Null
  dec ax
{  mov bx,[si-320]
  cmp bx,ax
  jge @weiter1
  mov [si-320],ax
  @weiter1:}
  mov bx,[si+320]
  cmp bx,ax
  jge @weiter2
  mov [si+320],ax
  @weiter2:
{  mov bx,[si-2]
  cmp bx,ax
  jge @weiter3
  mov [si-2],ax
  @weiter3:}
  mov bx,[si+2]
  cmp bx,ax
  jge @weiter4
  mov [si+2],ax
  @weiter4:
  @Null:
  add si,2
  dec cx
  jne @lp1
  pop ds
  sti
End;

Procedure Soft_Feld_Up(var target);assembler;
asm
  cli
  push ds
  lds si,Target             {Zeiger auf Zielbild laden}
  mov cx,160*200
  add si,320*201
@lp1:
  mov ax,[si]
  or ax,ax
  jz @Null
  dec ax
  mov bx,[si-320]
  cmp bx,ax
  jge @weiter1
  mov [si-320],ax
  @weiter1:
{  mov bx,[si+320]
  cmp bx,ax
  jge @weiter2
  mov [si+320],ax
  @weiter2:}
  mov bx,[si-2]
  cmp bx,ax
  jge @weiter3
  mov [si-2],ax
  @weiter3:
{  mov bx,[si+2]
  cmp bx,ax
  jge @weiter4
  mov [si+2],ax
  @weiter4:}
  @Null:
  sub si,2
  dec cx
  jne @lp1
  pop ds
  sti
End;



Procedure CreateEnv;
Procedure Paintobject(x1,y1,x2,y2:Integer);
var t:word;
begin
 for t:=y1 to y2 do fillword(Objekte^[t,x1],x2-x1+1,obj_intensity);
End;
Begin
 Ziel^[zielY,ZielX]:=255;
 PaintObject(O1x1,O1y1,O1x2,O1y2);
 PaintObject(O2x1,O2y1,O2x2,O2y2);
End;

procedure Final;
begin
 Textmode(3);
 Freemem(Objekte,sizeof(Karte));
 Freemem(Ziel,sizeof(Karte));
end;

procedure verknuepf(var source,target);assembler;
asm
 push ds
 mov cx,160*200
 lds si,source
 les di,target
 add si,320
 add di,320
@VLoop:
 mov ax,[si] {AX=Objekte}
 or ax,ax
 je @weiter  {AX=0? -> @WEITER}
{jmp @weiter} {FEHLER}
 cmp ax,Obj_Intensity {AX=Obj_Intensity?}
 je @Ziel_Null       {JA -> @ZIEL_NULL}
@Rand:
 mov bx,es:[di]
 shl ax,verstaerkung               {Verst„rkungseffekt}
 sub bx,ax
 jns @Put_Ergebnis {Positiv?}
@Ziel_Null: {Zielfeld wird null gesetzt}
 xor bx,bx
@Put_Ergebnis:
 mov es:[di],bx
@weiter:
 add si,2
 add di,2
 dec cx
jnz @VLoop
 pop ds
end;

begin
  Init;
 count:=0;
 CreateEnv;
 Soft_Feld_Down(ziel^);
 Soft_Feld_Up(ziel^);
 show_screen(Ziel^);
 readln;
 Soft_Feld_Down(Objekte^);
 Soft_Feld_Up(Objekte^);
 show_screen(Objekte^);
 readln;
{ Verknuepf(Objekte^,Ziel^);}
 show_screen(Ziel^);
 readln;
 Final;
end.