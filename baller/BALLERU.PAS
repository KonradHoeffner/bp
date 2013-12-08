unit balleru;
interface
procedure test;
procedure zeichne(x,y,xpos,ypos,hoehe,breite:word);
procedure zeichne2not(x,y,xpos,ypos,hoehe,breite:word);
procedure setpal;assembler;
procedure waitretrace;
implementation

procedure test;
begin
 asm
  mov ax,0a000h
  mov es,ax
  xor di,di
  mov cx,64000
  mov ax,seg s_figuren
  mov ds,ax
  xor si,si
  {add si,offset s_figuren{}
  {add si,56*320+300{}
  mov cx,10000
  @loop:
  mov al,ds:[si]
  {add al,64}
  {mov ds:[si],al}
  movsw
  {stosb}
  {inc si}

  dec cx
  jnz @loop
 end;
 end;

procedure zeichne(x,y,xpos,ypos,hoehe,breite:word);
 begin
   for t:=0 to hoehe-1 do move(s_figuren^[320*(ypos+t)+xpos],
   mem[$a000:320*(y+t)+x],breite);
 end;

procedure zeichne2not(x,y,xpos,ypos,hoehe,breite:word);
 begin
   for t:=0 to hoehe-1 do for u:=0 to breite-1 do if
   s_figuren^[320*(ypos+t)+xpos+u]>0 then
   mem[$a000:320*(y+t)+x+u]:=
   s_figuren^[320*(ypos+t)+xpos+u];
 end;

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

procedure waitretrace;
begin
repeat until (port[$3da] and $08)<>0;
repeat until (port[$3da] and $08)=0;
end;



begin
end.