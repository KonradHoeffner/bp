{$R-}
unit fonts;

interface
const font_color:byte=255;
type TChar= array[0..5,0..5] of byte;
     Tchars=array[{ord('-')}0..{ord('Z')}255] of TChar;
var  screen:array[0..199,0..319] of byte absolute $a000:0;
     cursor:record
            x,y:word;
           end;
     Myfonts:array[1..3] of ^TChars;
     FInf:array[1..5] of record
                               Width,Height:Byte;
                               Size:Word;
                              end;
     act_Font:Byte;
     MyChar:TChar;
Procedure InitFont(Nr,StartPos,FWidth,FHeight:Byte;var Src;SrcSize:Word);
Procedure InitBiosFont(nr,w,h:byte);{3=8*8 6=8*16}
{Procedure ExtractFont;}
Procedure StandardFont;
Procedure ClearFont(Nr:byte);
Procedure MyWriteln(S:String;font_nr:byte;var dest);
Procedure Outtext(x,y:word;S:String;var dest);
Procedure GetFontPointer (var p : pointer; font : byte);

implementation

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

Procedure InitFont(Nr,StartPos,FWidth,FHeight:Byte;var Src;SrcSize:Word);
Begin
 With FInf[Nr] do
 Begin
  Width:=FWidth;
  Height:=FHeight;
  Size:=SrcSize;
  GetMem(MyFonts[nr],SrcSize);
  Move(Src,MyFonts[nr]^[StartPos],SrcSize);
 End;
 act_Font:=Nr;
End;

Procedure ClearFont(Nr:byte);
Begin
FreeMem(MyFonts[Nr],FInf[Nr].Size);
End;

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
{   mov al,font_color}
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



Procedure MyWriteln(S:String;font_nr:byte;var dest);
var t:byte;
procedure MYwrite2(ch:char);
var x,y:word;

begin
{ PutFont(Myfonts[font_nr]^[ord(ch)],Point,FInf[Font_Nr].width,FInf[Font_Nr].height,cursor.x,cursor.y,dest);}
end;
Begin
 for t:=1 to length(s) do
 begin
  MYwrite2(Upcase(s[t]));
 end;
{ for t:=1 to 40-length(s) do write(' ');}
 cursor.x:=0;
 inc(cursor.y,8);
End;

Procedure Outtext(x,y:word;S:String;var dest);
var t:word;
procedure OutChar(ch:char);
{var x,y:word;}
begin
 MyChar:=MyFonts[act_Font]^[ord(ch)];
 PutFont(MyChar,FInf[act_font].width,FInf[act_font].height,
  x+(t-1)*FInf[act_font].Width,y,dest);
end;
Begin
 for t:=1 to length(s) do
 begin
  OutChar({Upcase(}s[t]{)});
 end;
End;

Procedure InitBiosFont(nr,w,h:byte);
var x,y,nr_char:word;
    p:Pointer;
    b:byte;
Begin
 with FInf[1] do
 Begin
  width:=w;
  height:=h;
  Size:=w*h*256;
 End;
 GetMem(MyFonts[1],FInf[1].size);
 GetFontPointer(p,nr);
 for nr_char:=0 to 255 do
 for y:=0 to h-1 do
 Begin
  b:=mem[seg(p^):ofs(p^)+nr_char*h+y];
  for x:=7 downto 0 do
   if (b shr x) and 1 = 1 then MyFonts[1]^[nr_char][y,7-x]:=1
                          else MyFonts[1]^[nr_char][y,7-x]:=0;
 End;
 Act_Font:=1;
End;

Procedure StandardFont;
Begin
 InitBiosFont(3,8,8);
End;
end.