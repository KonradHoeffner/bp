uses crt,dos,konrad,_32bit{};
const k  = 1000;
      hk = 100*k;
      name ='Putpixel fÅr Modus 13h';
      schaetz=1000;
      mhz  =266;
      anz  =round(10*hk*mhz/schaetz);

var time:array[1..3] of record
          s,m,sec,sec100:word;
          end;
    t,prosec,dauer:longint;
    x,y:word;farbe:byte;

procedure put13h(x,y:word;farbe:byte);assembler;
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

procedure rectangle(x1,y1,x2,y2:word;farbe:byte);
begin
 filllongint(screen[y1,x1],(x2-x1) shr 2,farbe);
 filllongint(screen[y2,x1],(x2-x1) shr 2,farbe);
 asm

  mov ax,0a000h
  mov es,ax
  mov ax,320
  mul y1
  add ax,x1
{--sinnlos--}
  mov cx,10
  @loop3:
  dec cx
  jne @loop3
{-----------}
  mov di,ax
  mov cx,y2
  sub cx,y1
  mov al,farbe
  mov bx,x2
  sub bx,x1
  @loop1:
   mov es:[di],al
   add di,bx
   mov es:[di],al
   sub di,bx
   add di,320
   dec cx
  jne @loop1
 end;{}
end;


begin
 clrscr;
 gettime(time[1].s,time[1].m,time[1].sec,time[1].sec100);
 writeln(name);
 asm
  mov ax,13h
  int 10h
 end;
 settime(0,0,0,0);
 for t:=1 to (anz div 10) do
 begin
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  {put13h(1,1,1);{}{put13h{(1,1,1){};
  rectangle(0,0,100,100,15);
 end;

 gettime(time[2].s,time[2].m,time[2].sec,time[2].sec100);
 textmode(3);
 writeln(anz,' DurchlÑufe:');
 writeln('Zeit: ',time[2].s,':',time[2].m,':',time[2].sec,':',time[2].sec100:2);

 if (time[2].sec<>0) or (time[2].sec100<>0)
  then prosec:=round(anz/(time[2].sec+(time[2].sec100/100)))
  else prosec:=0;
 writeln('->',prosec,' mal pro Sekunde: ',prosec div (10*hk),'Mbyte/Sekunde');
 Dauer:=round(mhz*1000000/prosec);
 writeln(dauer,' Takte');
 settime(time[1].s,time[1].m,time[1].sec,time[1].sec100);
 readln;
end.