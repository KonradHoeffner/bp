Uses Crt,dos;
type longrec = record l:word; h:byte; x:byte; end;
Var Sterne:Array[0..1000] of Record
                              x,y,Ebene:Integer;
                            End;
   i:integer;
   t:word;
   st_nr:Word;
   r:registers;
   palette:array[0..767] of byte;

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

procedure setbank(bank:byte);
begin
port[$3cd]:=bank or bank shl 4;
end;

procedure putpixel(x,y:word; farbe:byte);
var offset:longint;
begin
offset:=longint(1024)*y+x;
setbank(longrec(offset).h); {Bit 16..23}
mem[$a000:longrec(offset).l]:=farbe;
end;



{function a(x:word):word;
begin
if (x<50) or (x>255) then a:=255;
end;}


Begin

  r.ax:=$38;
  intr($10,r);

  for i:=1 to 255 do begin
  r.ah:=$10; r.ah:=$10;r.bx:=i; r.ch:=i; r.cl:=i; r.dh:=i;
  palette[i*3]:=i;
  palette[i*3+1]:=i;
  palette[i*3+2]:=i;
  end;
  setpal;
  Randomize;                    {Zufallszahlen initialisieren}

  Repeat                        {pro Bildaufbau einmal ausgefÅhrt}
    For St_nr:=0 to 1000 do Begin{fÅr jeden Stern neue Posit. berechnen}
      With Sterne[st_nr] do Begin
        PutPixel(x,y,0);        {alten Punkt lîschen}
        Dec(x,Ebene shr 5 + 1); {weiterbewegen}
        if x <= 0 Then Begin    {links raus ?}
          x:=1023;               {dann neu initialisieren}
          y:=Random(768);
          Ebene:=Random(256);
        End;
        PutPixel(x,y,Ebene);  {neuen Punkt setzen}
      End;
    End;
  inc(t);
  if t>1023 then t:=0;
  repeat until (port[$3da] and $08) =0;
  repeat until (port[$3da] and $08) <>0;


  Until KeyPressed;             {Lauf, bis Taste gedrÅckt}
  TextMode(3);
End.
