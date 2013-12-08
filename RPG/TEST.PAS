uses konrad,{sprites,}crt,_32bit,_13h,fonts,picture;
const font_width=6;
      font_height=6;
      range=6;
var p:Pointer;
    puffer:^TPuffer;
    LittleChars:array [Ord('-')..Ord('Z')] of array[0..5,0..5] of byte;
    y:word;
 procedure putfont(var image;PWidth,PHeight,x,y:word;var dest);
 begin
  asm
   pusha
   lds si,image
{   mov ax,0a000h
   mov ds,ax
   xor si,si}
   les di,dest
   mov ax,320
   mul y
   add ax,x
   add di,ax
   mov cx,word ptr PHeight
  @loop_y:
   mov dx,word ptr PWidth
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
   sub di,word ptr Pwidth
   loop @loop_y
   popa
  end;
 end;

begin
 Init13h;
 Palette[255*3]:=255;
 Palette[255*3+1]:=255;
 Palette[255*3+2]:=255;
 InitBiosFont(3,8,8);
 Outtext(1,1,'Bios-Font 3: 8*8',screen);
 InitBiosFont(6,8,16);
 Outtext(1,16,'Bios-Font 6: 8*16',screen);
 Fillchar(Littlechars,Sizeof(LittleChars),0);
   getmem(puffer,320*200+256*3);
 LoadPcx('Font2.pcx',puffer^);
 movelongint(puffer^,screen,16000);
 move(puffer^[64000],palette,768);
  setpal;
 for t:=Ord('-') to Ord('Z') do
  for y:=0 to 5 do
  Move(Screen[y,(t-Ord('-'))*6],LittleChars[t][y,0],6);
 InitFont(2,Ord('-'),6,6,littlechars,8*8*Ord('Z')-Ord('-'));
 Act_Font:=2;
  Outtext(100,100,'TEST-FONT',screen);

 repeat
  for t:=3 to 767 do inc(palette[t]);
  filllongint(screen,16000,0);
   Outtext(50-palette[3],50,'123-ABC;HTTP://WWW.GERMANY.NET',screen);
  waitretrace;  waitretrace;  waitretrace;  waitretrace;
  setpal;
 until keypressed;

 freemem(puffer,320*200+256*3);
end.