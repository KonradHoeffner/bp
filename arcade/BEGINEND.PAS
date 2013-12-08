unit beginend;
interface
{------Prozeduren------}
 Procedure BE_Init;
 Procedure BE_Final;
{-----------------------}
implementation
uses vars,konrad,pcx,crt;
{------Prozeduren------}
 Procedure Sprite_Init;Forward;
 Procedure Pos_Init;Forward;
 Procedure PCX_Init;Forward;
{----------------------}
Procedure BE_Init;
begin
 asm
  mov ax,13h
  int 10h
 end;
 Maus_Init;
 Getmem(screen1,64000);
 Getmem(backgr,64000);
 PCX_Init;
 Sprite_Init;
 Pos_Init;
End;

Procedure Add(var dest;anz:byte);assembler;
asm
 push ds
 mov cx,64000
 lds si,dest
 @loop:
 mov al,[si]
 add al,anz
 mov ds:[si],al
 inc si
 dec cx
 jne @loop
 pop ds
End;

Procedure PCX_Init;
var img_pal:tpalette;
Begin
 if doBG then
 begin
  loadpcx(imgpath+img_b_1,backgr^,img_pal);
  add(backgr^,192);
  for t:=0 to 63 do setmypalette(t+192,img_pal[t*3],img_pal[t*3+1],img_pal[t*3+2]);
 end;
End;

 Procedure Pos_Init;
 begin
  with gun do
  begin
   x:=g_start_x;
   e:=g_start_e;
   w:=g_start_w;
  end;
  with plane do
  begin
   stat:=out;
   unused:=0;
   abwurf:=0;
  end;
 end;

 Procedure Sprite_Init;
 var t,i,x,y:integer;
 Begin
  for t:=1 to h*b do
  begin
   cguy_f[t]:=15*cguy_f[t];
   for i:=1 to guy_l_frames do
   cguy_l[i][t]:=15*cguy_l[i][t];
   for i:=1 to guy_s_frames do
   cguy_s[i][t]:=15*cguy_s[i][t];
  end;
  for t:=1 to gh*gb do cgun[t]:=15*cgun[t];

  for i:=1 to p_f_frames do
   for y:=0 to ph-1 do
    for x:=0 to pb-1 do
   begin
    cplane_l[i][pb*y+x+1]:=15*cplane_l[i][pb*y+x+1];
    img_p_r[i][pb*y+(pb-x-1)+1]:=cplane_l[i][pb*y+x+1];
   end;
  for i:=1 to guy_l_frames do
  with sp_l[i] do
  begin
   height:=h;
   width:=b;
   image:=@cguy_l[i];
  end;
  for i:=1 to guy_s_frames do
  with sp_s[i] do
  begin
   height:=h;
   width:=b;
   image:=@cguy_s[i];
  end;
  for i:=1 to guy_e_frames do
  with sp_e[i] do
  begin
   height:=h;
   width:=b;
   image:=@cguy_e[i];
  end;
  for i:=1 to p_f_frames do
  begin
  with sp_p_l[i] do
   begin
    height:=ph;
    width:=pb;
    image:=@cplane_l[i];
   end;
  with sp_p_r[i] do
   begin
    height:=ph;
    width:=pb;
    image:=@img_p_r[i];
   end;
  end;
  with sp_f do
  begin
   height:=h;
   width:=b;
   image:=@cguy_f;
  end;
  with sp_g do
  begin
   height:=gh;
   width:=gb;
   image:=@cgun
  end;
 end;

Procedure BE_Final;
Begin
 Freemem(screen1,64000);
 asm
  mov ax,3
  int 10h
 end;
 Freemem(backgr,64000);
End;

end.