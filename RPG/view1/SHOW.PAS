unit show;
interface
uses vars,sprites,_13h,konrad,_32bit;
{----Prozeduren-----}
 Procedure SH_Show(var d:tscreen);
{-------------------}
implementation
const width=16;
      height=16;

procedure Myputrect(var image;x,y:word;var dest);assembler;
 asm
  push ds
  push si
  lds si,image {image}
  les di,dest
  mov ax,320
  mul y
  add ax,x
  add di,ax
  mov dx,height
 @loop_y:
  mov cx,width
  shr cx,2
  db 66h;rep movsw{d}
  add di,320
  sub di,width
  dec dx
  jne @loop_y
  pop si
  pop ds
end;

procedure Myputsprite(var image;x,y:word;var dest);assembler;
asm
 push ds
 push si
 lds si,image {image}
 les di,dest
 mov ax,320
 mul y
 add ax,x
 add di,ax
 mov cx,height
 @loop_y:
 mov dx,width
 @loop_x:
 mov al,ds:[si]
 or al,al
 jz @weiter1
 mov es:[di],al
 @weiter1:
 inc si
 inc di
 dec dx
 jne @loop_x
 add di,320
 sub di,width
 loop @loop_y
 pop si
 pop ds
end;


Procedure SH_Show(var d:tscreen);
var t,x,y:integer;
    t1,t2:string;
Begin
 for y:=0 to 11 do
  for x:=0 to 19 do
   if map^[y,x]<>0 then
   myputrect(images^[map^[vp.y+y,vp.x+x]],x*16,y*16,d);
 if maus.y<=199-5+1 then pfeil.height:=5 else pfeil.height:=200-maus.y;
 putsprite(pfeil,maus.x,maus.y,screen1^);
 filllongint(screen1^[16*12,0],8*80,0);
 MyPutSprite(sp^[1],(s.x-vp.x)*16,(s.y-vp.y)*16,screen1^);
 str(s.x,t1);
 str(s.y,t2);
 outtextxy2(1,0,t1+';'+t2,255,screen1^);
End;

end.