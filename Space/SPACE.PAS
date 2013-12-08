uses uspace,crt,_32Bit,pcx;{,vesa12,vesagif}

procedure scroll;
begin
if z<199 then inc(z) else z:=0;
movelongint(bild2^,bild3^[z,0],16000-z*80);
movelongint(bild2^[199-z,0],bild3^,z*80+80);
end;

Procedure Scroll_Up(src_frame,dest_frame:bild_type);assembler;
{scrollt das Bild um eine Zeile nach oben und interpoliert}
asm
  push ds
  les di,Dest_Frame             {Zeiger auf Zielbild laden}
  lds si,Src_Frame              {Zeiger auf Quellbild}

  mov cx,320*200                 {200 Zeilen scrollen}
  xor bl,bl                     {wird als Dummy fr High-Byte ben”tigt}
@lp1:
  xor ax,ax
  xor bx,bx
  mov al,[si+319]
  mov bl,[si]
  add ax,bx
  mov bl,[si]
  adc ax,bx
  mov bl,[si+320]
  adc ax,bx
  shr ax,2


  or ax,ax                      {bereits 0 ?}
  je @null
  dec al                        {wenn nein, dann verringern}
@null:
  stosb                         {Wert ins Ziel}
  inc si                        {n„chsten Punkt}
  dec cx                        {weitere Punkte ?}
  jne @lp1
  pop ds
End;


begin
 randomize;
  asm
  mov ax,13h
  int 10h
 end;
 prep_startbild;{}

 show;

{ prep_untergrund;{}

 prep_wasser;
 display;
 {filllongint(bild3^,16000,0);}
 move(bild^,mem[$a000:0],64000);

 {readkey;{}
 for t:=1 to 10 do begin scroll_up(bild3^,bild2^); movelongint(bild2^,bild3^,64000); end;
 for t:=1 to 50 do scroll;
 for t:=1 to 10 do begin scroll_up(bild3^,bild2^); movelongint(bild2^,bild3^,64000); end;

 movelongint(bild3^,bild^,16000);
 movelongint(bild3^,bild2^,16000);
 feuer:=0;
 fillchar(palette[254*3],3,20);
 fillchar(palette[255*3],3,63);
 setpal;

 repeat
  if keypressed then taste:=readkey;
  palrot;{}
  if feuer>0 then dec(feuer);

  if (taste=' ') and (feuer=0) then
  begin
  feuer:=20;
  inc(mg_anz,1);
  kugeln[mg_anz].x:=160; kugeln[mg_anz].y:=190;

  end;

  feuer:=0;
  mg;
  waitv;
  display;{}
  scroll;{}

 until taste=#27;
 asm
  mov ax,3
  int 10h
 end;
 freemem(bild2,64000);
 freemem(bild3,64000);
 freemem(puffer,64768);
end.