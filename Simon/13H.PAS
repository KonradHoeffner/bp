uses crt;
var bild:array[0..199,0..319] of byte absolute $a000:0;

procedure initialisisiereden13hmodus;assembler;
asm
 mov ax,13h
 int 10h
end;
 {stosb  es:di  al}


procedure putpixelim13hmodus(x,y:word;farbe:byte);assembler;
asm
 mov ax,0a000h
 mov es,ax
 mov ax,320
 mul y
 add ax,x
 mov di,ax
 mov al,farbe
 mov es:[di],al
end;

procedure putpixelim13hmodusinpascal(x,y:word;farbe:byte);
begin
 mem[$a000:320*y+x]:=farbe;
end;

var a,b:integer;

begin
 initialisisiereden13hmodus;
 repeat
 {putpixelim13hmodusinpascal(a,b,a);}
 bild[b,a]:=a;
 inc(a,1);
  if a > 255 then
   begin
    a:=1;
    inc(b,1);
   end;
{ delay(10);}
 until keypressed;
 textmode(3);
end.