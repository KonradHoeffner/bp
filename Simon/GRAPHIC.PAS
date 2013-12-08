unit graphic;

interface

 const
       numt=12+1;

  var textnum:word;
      screennum:byte;

  procedure putimage_s(x1,y1:word;var off); {setzt ein Bild an die Position (x1,y1)}
  procedure getimage_s(x1,y1,x2,y2:word;var off;var source); {liest ein Bild aus (vitueller) Bildspeicheradresse in Off ein}
  procedure getimage(x1,y1,x2,y2:word;var off,source); {wie Getimage_s}
  procedure putimage(x1,y1:word;var off,source); {wie Putimage nur Bildsetzen auch an virtuelle Bildseiten}
  procedure SetDAC_s (var dac);  {Palette setzten (nicht alle Farben)}
  function notusedcolor(var source):byte; {ermittelt eine Farbennummer, die nicht genutzt wird}
  {gibt Text aus an x,y mit Farbe Color in (virtuellen) Bildschirm}
  procedure outtextxy2(x,y:word;texte:string;color:byte;var source);
  procedure glatt(var source;count:word); {Interpolationsroutine (Feuereffekt)}
  procedure copy2screen(var source,dest); {kopiert Source in Test (mischt die Bilder)}
  function getpixel_s(x,y:word):byte; {nimmt Pixelfarbe von x,y auf}
  procedure fullcircle_s(x,y,r,col:word;var ziel); {zeichnet einen ausfgefllten Kreis}
  procedure SetDAC (var dac); {setzt komplette Palette}
  procedure GetDAC (var dac); {liest komplette Palette}
  procedure scrollin(var von,zu;dicke:byte); {Rollt von in zu ein}
  procedure intro(bild:pointer;menu_dac:array of byte);


implementation

uses crt,speedvga;

const dac_pel_read        = $3c7;
      dac_pel_write       = $3c8;
      dac_pel_data        = $3c9;

procedure moveline(y,w:word;var von,zu); assembler;

asm
push ds
push cx
les di, von
lds si, zu

xor ax, ax
mov ax, 320
mul y
sub ax, 320
add di, ax

xor ax, ax
mov ax, 320
mul w
sub ax, 320
add si, ax

mov cx, 320
@neu: mov al, es:[di]
      mov ds:[si], al
      inc di
      inc si
      dec cx
jnz @neu

pop cx
pop ds
end;

procedure moveline_v(p:word;var von,zu);
var d:word;
begin
  for d:=100 to 150 do mem[seg(zu):ofs(zu)+(d*320)+p]:=mem[seg(von):ofs(von)+(d*320)+p];
end;

procedure intro(bild:pointer;menu_dac:array of byte);

var d,d2,d3,d4:word;
    dac:array[0..768] of byte;

begin
cls(0);
setdac(ptr($a000,0)^);
for d:=10 to 40 do moveline(d,70+d,bild^,ptr($a000,0)^);
fillchar(dac,768,0);
for d:=0 to 63 do   {blendet Entwickler ein}
 begin
 for d2:=0 to 768 do if menu_dac[d2]>d then inc(dac[d2]);
 setdac(dac);
 waitretrace;
 end;

d4:=0;
for d2:=1 to 14 do {Zieht Name und presents nach oben}
 begin
 if d2<7 then d3:=d2;
 waitretrace;
 if d2>6 then
   begin
     d4:=3;
     for d:=1 to 10 do line(1, 70+40+d3*5-5-d4-d2*5+d,320, 70+40+d3*5-5-d4-d2*5+d,0);
   end;
 for d:=10 to 40+d3*5-5-d4 do moveline(d, 70+d-d2*5, bild^, ptr($a000,0)^);
 waitretrace;
 delay(20);
 end;
scrollin(bild^,ptr($a000,0)^,30); {rollt Mastermind herein}
for d:=150 downto 80 do
  begin
    moveline_v(d,bild^,ptr($a000,0)^);
    moveline_v(300-d,bild^,ptr($a000,0)^);
    delay(20);
  end;
delay(1000);
end;

procedure scrollin(var von,zu;dicke:byte);

var d,d2:word;
    rolle:byte;

procedure moveline(v,z:word;var von,zu);
var dummy:word;
begin
  for dummy:=70 to 120 do mem[seg(zu):ofs(zu)+(dummy-1)*320+z]:=mem[seg(von):ofs(von)+(dummy-1)*320+v]
end;

procedure waitretrace;
 assembler;
  asm
   mov dx,3dah
   @x: in al,dx
   test al,08h
   jnz @x
   @y: in al,dx
   test al,08h
   jz @y
  end;

begin
rolle:=dicke;
for d:=1 to 320 do
   begin
     waitretrace;
     for d2:=rolle*2 downto rolle do
        if (d+1+rolle*2-d2<319)and(d+d2<319) then
               moveline(d+d2,d+1+rolle*2-d2,ptr(seg(von),ofs(von))^,ptr(seg(zu),ofs(zu))^) else
        if d+1+rolle*2-d2<319 then
               moveline(d+rolle*2-d2,d+rolle*2-d2,ptr(seg(von),ofs(von))^,ptr(seg(zu),ofs(zu))^);
     moveline(d,d,ptr(seg(von),ofs(von))^,ptr(seg(zu),ofs(zu))^);
     if keypressed then
         begin
           move(von,zu,64000);
           while keypressed do readkey;
           exit;
         end;
     end;
end;

procedure GetDAC (var dac); assembler;

asm
   mov  dx, dac_pel_read      	                     { dx = Pel Read Adress }
   xor  al, al                                        { Anfangsregister = 0 }
   out  dx, al
   inc  dx			       	           { dx = Pel Data Register }
   inc  dx

   les  di, dac                                            { es:di --> Ziel }
   mov  cx, 768                                          { 768 DAC-Eintr„ge }
   cld                                 { bei Stringbefehlen aufw„rts z„hlen }
   rep  insb            { DAC-Werte von Videokarte lesen und in DAC sichern }
end;                                                               { GetDAC }


procedure SetDAC (var dac); assembler;

asm
   push ds                                 { ds darf nicht ver„ndert werden }

   mov  dx, dac_pel_write                           { dx = Pel Write Adress }
   xor  al, al                                        { Anfangsregister = 0 }
   out  dx, al
   inc  dx			       	           { dx = Pel Data Register }

   lds  si, dac                                          { ds:si --> Quelle }
   mov  cx, 768                                          { 768 DAC-Eintr„ge }
   cld                                 { bei Stringbefehlen aufw„rts z„hlen }
   rep outsb               { DAC-Werte laden und an Videokarte weiterleiten }

   pop  ds
end;                                                               { SetDAC }



procedure h_line(x1,x2,y:word;col:byte; var ziel);assembler;

asm
 les di,ziel
 mov ax,320
 mul y
 add ax, x1
 add di,ax
 mov ax,x2
 sub ax,x1
 mov bx,ax
 mov al,col
 inc bx
 @new: mov es:[di],al
       inc di
       dec bx
 jnz @new
end;


procedure fullcircle_s(x,y,r,col:word;var ziel);

var phi,x1,y1,x2,x1s,x2s,y1s,d:word;

Begin
   y1s:=Trunc(Round(Cos(1/180*pi)*r*200/240 +y));
   x1s:=Trunc(Round(Sin(1/180*pi)*r*320/320+x));
   x2s:=Trunc(Round(Sin((360-1)/180*pi)*r*320/320+x));
   For phi:=1 to 179 do Begin
      x1:=Trunc(Round(Sin(phi/180*pi)*r*320/320+x));  {x-Koordinate berechnen}
      y1:=Trunc(Round(Cos(phi/180*pi)*r*200/240 +y)); {y-Koordinate berechnen}
      x2:=Trunc(Round(Sin((360-phi)/180*pi)*r*320/320+x));  {x-Koordinate berechnen}
      if y1<y1s-1 then for d:=y1s-1 downto y1+1 do if (d<201)and(d>0) then h_line(x2s,x1s,d,col,ziel);
      if x2>320 then x2:=320;
      if (y1<200)and(y1>0) then h_line(x2,x1,y1,col,ziel);
      x1s:=x1;
      x2s:=x2;
      y1s:=y1;
   end;
end;


function getpixel_s(x,y:word):byte;
assembler;
asm
  mov ax, 0a000h
  mov es,ax
  xor di,di
  mov ax, y
  dec ax
  mov bx, 320
  mul bx
  add ax,x
  dec ax
  mov di,ax
  mov al,es:[di]
end;

procedure getimage(x1,y1,x2,y2:word;var off,source);
var d:word;
begin
 mem[seg(off):ofs(off)]   := x2-x1+1;
 mem[seg(off):ofs(off)+1] := y2-y1+1;
 for d:=y1 to y2+1 do
    move(ptr(seg(source),ofs(source)+(d-1)*320+x1-1)^,ptr(seg(off),ofs(off)+(d-y1)*(x2-x1+1)+2)^,x2-x1+1);
end;

procedure putimage(x1,y1:word;var off,source);
var maxx,maxy,d:word;
begin
maxx:=mem[seg(off):ofs(off)];
maxy:=mem[seg(off):ofs(off)+1];

for d:=0 to maxy-1 do
      move(ptr(seg(off),ofs(off)+d*maxx+2)^,ptr(seg(source),ofs(source)+(y1+d-1)*320+x1-1)^,maxx);
end;

procedure getimage_s(x1,y1,x2,y2:word;var off;var source);
var d:word;
begin
 mem[seg(off):ofs(off)]   := x2-x1+1;
 mem[seg(off):ofs(off)+1] := y2-y1+1;
 for d:=y1 to y2+1 do
    move(ptr(seg(source),ofs(source)+(d-1)*320+x1-1)^,ptr(seg(off),ofs(off)+(d-1)*(x2-x1+1)+2)^,x2-x1+1);
end;


procedure putimage_s(x1,y1:word;var off);
var maxx,maxy,d,d2:word;
    dummy:byte;
begin
maxx:=mem[seg(off):ofs(off)];
maxy:=mem[seg(off):ofs(off)+1];

for d:=0 to maxy-1 do
   for d2:=0 to maxx-1 do
      if mem[seg(off):ofs(off)+d*maxx+2+d2]>0 then
          begin
            dummy:=mem[$a000:(d+y1)*320+x1-1+d2];
            mem[$a000:(d+y1)*320+x1-1+d2]:=mem[seg(off):ofs(off)+d*maxx+2+d2];
            mem[seg(off):ofs(off)+d*maxx+2+d2]:=dummy;
          end;
end;

procedure copy2screen(var source,dest);assembler;

 asm
  push ds
  les di,source
  lds si,dest
  xor si,si
  mov bx,64000
  @new:mov al,es:[di]
       cmp al,0
       jnz @writedata
       jmp @back
       @writedata: mov ds:[di],al
       @back:
       inc di
       dec bx
  jnz @new
  pop ds
 end;

procedure glatt(var source;count:word);assembler;

asm
xor di,di
les di,source
add di,count
sub di,320
push cx
mov cx,5

@new:
     xor bx,bx

     mov al,es:[di-321]   {Û Û}
     xor ah,ah            { Û }
     add bx,ax            {Û Û}

     mov al,es:[di-319]
     xor ah,ah
     add bx,ax

     mov al,es:[di]
     xor ah,ah
     add bx,ax

     mov al,es:[di+319]
     xor ah,ah
     add bx,ax

     mov al,es:[di+321]
     xor ah,ah
     add bx,ax

     mov ax,bx
     xor dx,dx
     div cx
     mov es:[di],al
     dec di
     cmp di,320
jnz @new
pop cx
end;

procedure outtextxy2(x,y:word;texte:string;color:byte;var source);

var point:pointer;
    d,d2,x2,y2,d3,num:word;
    st:string;
    d21,len:byte;

procedure GetFontPointer (var p : pointer; font : byte); assembler;

asm
  push ds
  push bp
  mov  ax, 1130h
  mov  bh, font
  int  10h
  mov  ax, bp
  pop  bp
  lds  si, p
  mov  ds:[si], ax
  mov  ds:[si+02], es
  pop  ds
end;

procedure putpixel(x_1,y_1:integer ;col:byte;var source);

  ASSEMBLER;
  asm
  dec y_1
  dec x_1
  les di,source
  mov ax,320
  mul y_1
  add ax,x_1
  add di,ax
  mov al,col
  mov es:[di],al
  end;

begin
  getfontpointer(point,6);

  x2:=0;
  y2:=0;

  for len:=0 to length(texte)-1 do
  begin
    y2:=0;
    x2:=x+8*len;
    num:=ord(texte[len+1]);
    for d3:=0 to 15 do
     begin
       d21:=mem[seg(point^):ofs(point^)+num*16+d3];
       for d:=7 downto 0 do
           if (d21 shr d) mod 2 = 1 then putpixel(x+x2+7-d,y+y2,color,source);
       inc(y2);
     end;
    end;

  end;

function notusedcolor(var source):byte;
var d,d2:word;
    found:boolean;

begin
  for d2:=0 to 255 do
   begin
    found:=false;
     for d:=0 to 63999 do if mem[ofs(source):seg(source)+d]=d2 then
       begin
         found:=true;
         break;
       end;
     if not found then break;
    end;
    notusedcolor:=d2;
end;

procedure SetDAC_s (var dac); assembler;
const dac_pel_write       = $3c8;
asm
   push ds                                 { ds darf nicht ver„ndert werden }

   mov  dx, dac_pel_write                           { dx = Pel Write Adress }
   xor  al, al                                        { Anfangsregister = 0 }
   out  dx, al
   inc  dx			       	           { dx = Pel Data Register }

   lds  si, dac                                          { ds:si --> Quelle }
   mov  cx, 70                                          { 60 DAC-Eintr„ge }
   cld                                 { bei Stringbefehlen aufw„rts z„hlen }
   rep outsb               { DAC-Werte laden und an Videokarte weiterleiten }

   pop  ds
end;                                                               { SetDAC }

end.