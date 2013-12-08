uses crt,konrad,_32bit,flames,graphic;

const startx=150;
      starty=30;
      ZielX=100;
      ZielY=50;
type Karte=array[0..199,0..159] of word;
var w:word;
    i:Integer;
    Quelle,Ziel:^Karte;

procedure init;
begin
 Getmem(Quelle,64000);
 Getmem(Ziel,64000);
 Filllongint(Quelle^,16000,0);
 Filllongint(Ziel^,16000,0);

 Init13h;
 Fillchar(Palette,3,0);
 for t:=1 to 254 do
  fillchar(palette[t*3],3,t shr 2);
 palette[255*3]:=63;
 palette[255*3+1]:=0;
 palette[255*3+2]:=0;
 setpal;
end;

Procedure Show_Screen;          {kopiert fertigen Bilschirm auf VGA}
Var temp:Pointer;               {zum Tauschen der Zeiger}
Begin
asm
  push ds
  lds si,Ziel             {fertiges Bild als Quelle}
  mov ax,0a000h
  mov es,ax
  xor di,di
  mov cx,160*200
  @Loop1:
  mov ax,[si]
  shr ax,8
  mov ah,al
{  mov al,155}
  stosw
  add si,2
  dec cx
  jnz @Loop1
  pop ds
End;
  temp:=Ziel;             {Zeiger auf Quell- und Zielbild tauschen}
  Ziel:=Quelle;
  Quelle:=temp;
End;


Procedure Soft2;assembler;
asm
  push ds
  les di,Ziel             {Zeiger auf Zielbild laden}
  lds si,Quelle              {Zeiger auf Quellbild}
  mov cx,160*198
  add si,321
  add di,321
  xor bx,bx
@lp1:
  xor ax,ax
  xor bx,bx
  mov ax,[si]
  mov bx,[si-321]
  add ax,bx
  mov bx,[si-320]
  adc ax,bx
  mov bx,[si-319]
  adc ax,bx
  mov bx,[si-1]
  adc ax,bx
  mov bx,[si+1]
  adc ax,bx
  mov bx,[si+319]
  adc ax,bx
  mov bx,[si+320]
  adc ax,bx
  mov bx,[si+321]
  add ax,bx
  or ax,ax                      {bereits 0 ?}
  je @null
  mov dx,9
  div dl
  dec al                        {wenn nein, dann verringern}
@null:
  stosw                         {Wert ins Ziel}
  add si,2                        {n„chsten Punkt}
  dec cx                        {weitere Punkte ?}
  jne @lp1
  pop ds
End;

Procedure Soft_Feld;assembler;
asm
  push ds
  les di,Ziel             {Zeiger auf Zielbild laden}
  lds si,Quelle              {Zeiger auf Quellbild}
  mov cx,160*198
  add si,640
  add di,640
  xor bx,bx
@lp1:
  xor ax,ax
  xor bx,bx
  mov ax,[si]
  mov bx,[si-322]
  add ax,bx
  mov bx,[si-320]
  adc ax,bx
  mov bx,[si-318]
  adc ax,bx
  mov bx,[si-2]
  adc ax,bx
  mov bx,[si+2]
  adc ax,bx
  mov bx,[si+318]
  adc ax,bx
  mov bx,[si+320]
  adc ax,bx
  mov bx,[si+322]
  add ax,bx
  or ax,ax                      {bereits 0 ?}
  je @null
  xor dx,dx
  mov bx,9
  div bx
  dec al                        {wenn nein, dann verringern}
@null:
  stosw                         {Wert ins Ziel}
  add si,2                        {n„chsten Punkt}
  dec cx                        {weitere Punkte ?}
  jne @lp1
  pop ds
End;

Procedure Soft_Feld;assembler;
asm
  push ds
  les di,Ziel             {Zeiger auf Zielbild laden}
  lds si,Quelle              {Zeiger auf Quellbild}
  mov cx,160*198
  add si,640
  add di,640
  xor bx,bx
@lp1:
  xor ax,ax
  xor bx,bx
  mov ax,[si]
  mov bx,[si-322]
  add ax,bx
  mov bx,[si-320]
  adc ax,bx
  mov bx,[si-318]
  adc ax,bx
  mov bx,[si-2]
  adc ax,bx
  mov bx,[si+2]
  adc ax,bx
  mov bx,[si+318]
  adc ax,bx
  mov bx,[si+320]
  adc ax,bx
  mov bx,[si+322]
  add ax,bx
  or ax,ax                      {bereits 0 ?}
  je @null
  xor dx,dx
  mov bx,9
  div bx
  dec al                        {wenn nein, dann verringern}
@null:
  stosw                         {Wert ins Ziel}
  add si,2                        {n„chsten Punkt}
  dec cx                        {weitere Punkte ?}
  jne @lp1
  pop ds
End;



Procedure CreateEnv;
Begin
{ for i:=-5 to 5 do fillchar(Ziel^[ZielY+i,ZielX-20],40,254);}
fillchar(Ziel^,64000,254);
End;

procedure Final;
begin
 Textmode(3);
{ Freemem(Src_Frame,64000);
 Freemem(Dest_Frame,64000);
 Freemem(Quelle,64000);
 Freemem(Ziel,64000);}

end;

begin
 InitFlames;
 Init;
 CreateEnv;
 repeat
  CreateEnv;
  soft_Feld;
  show_screen;
  waitretrace;
 until keypressed;
 Final;
end.