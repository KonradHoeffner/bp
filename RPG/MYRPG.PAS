unit MyRPG;

interface
 procedure Myputsprite(var image:pointer;x,y:word;var dest);
 procedure Myputrect(image:pointer;x,y:word;var dest);
implementation
const width=16;
      height=16;


 procedure Myputsprite(var image:pointer;x,y:word;var dest);
 begin
  asm
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
  end;
 end;

 procedure Myputrect(image:pointer;x,y:word;var dest);
 begin
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
 end;
end.