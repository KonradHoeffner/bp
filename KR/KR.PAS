uses konrad,crt,pcx,_32bit,sprites,_13h;
const filename='monster.pcx';
      breite=96;
      hoehe=96;
      speed=4;
      mauson=false;
      sp1_knarre=53;
      sp2_halt=#13;
      sp2_knarre=48;
      sp1_schuss='q';
      sp2_schuss=' ';
      maxstern=100;  {Anzahl der Sterne}
      dRot=64;
      Rot=65;
      dGruen=66;
      Gruen=67;
      Schuss_Speed=30;
      norml=100;
var screen1:^TScreen;
    Puffer:^TPuffer;
    monster_img:array[1..2] of array[0..hoehe-1,0..breite-1] of byte;
    monster:array[1..2] of TSprite;
    spieler:array[1..2] of
    record
     x,y:integer;
     leben,muni:byte;
     fire:boolean;
    end;
    taste1,taste2:char;
    sterne:array[0..maxstern] of record
                              x,y,ebene:integer;
                            end;
    st_nr:Word;
    schuesse:array[1..2] of
    Record
     x,y:integer;
     laenge:byte;
    End;

const w=5;
 h=5;
 blood1:array[0..w*h-1] of byte =
(0,1,1,1,0,
 1,1,2,1,1,
 1,2,2,2,1,
 1,1,2,1,1,
 0,1,1,1,0
 );

Procedure PutBlood(var src;x:word;y:word;var dest);assembler;
asm
 push ds
 lds si,src
 les di,dest
 mov ax,320
 mul y
 add ax,x
 add di,ax
 mov dx,h
@Loop_y:
 mov cx,w
 @Loop_x:
 mov al,ds:[si]
{ mov al,255}
 mov bl,254
 cmp es:[di],bl
 jae @weiter
 add es:[di],al
 @weiter:
 inc di
 inc si
 dec cx
 jne @Loop_x
 add di,320
 sub di,w
 dec dx
 jne @Loop_y
 pop ds
End;

Procedure Init;
Begin
 Init13h;
 For t:=0 to 63 do
  fillchar(palette[t*3],3,t);
 Palette[dRot*3]:=30; Palette[dRot*3+1]:=0; Palette[dRot*3+2]:=0;
 Palette[Rot*3]:=63; Palette[Rot*3+1]:=0; Palette[Rot*3+2]:=0;
 Palette[dGruen*3]:=0; Palette[dGruen*3+1]:=30; Palette[dGruen*3+2]:=0;
 Palette[Gruen*3]:=0; Palette[Gruen*3+1]:=63; Palette[Gruen*3+2]:=0;
   setpal;
 Getmem(screen1,64000);
 randomize;
 getmem(puffer,sizeof(tpuffer));
 LoadPcx(filename,puffer^,palette);
{ MoveLongint(puffer^,screen,16000);}
 MoveLongint(puffer^,screen1^,16000);
 asm
  push ds
  lds si,screen1
  mov cx,64000
  @loop:
  mov al,ds:[si]
  shr al,2
  mov ds:[si],al
  inc si
  dec cx
  jne @Loop
  pop ds
 End;
 for t:=0 to 95 do Move(screen1^[t,1],monster_img[1][t,0],96);
 for t:=0 to 95 do Move(screen1^[t,97],monster_img[2][t,0],96);
 Monster[1].width:=breite;Monster[2].width:=breite;
 Monster[1].height:=hoehe;Monster[2].height:=hoehe;
 Monster[1].image:=@Monster_img[1]; Monster[2].image:=@Monster_img[2];
 freemem(puffer,sizeof(tpuffer));
 Spieler[1].X:=10;
 Spieler[1].Y:=30;
 Spieler[2].X:=200;
 Spieler[2].Y:=30;
 if mauson then
 Begin
  Maus_Init;
  SetMaus(Spieler[1].X,Spieler[1].Y);
 End;
End;

Procedure ShowPlayers;
Begin
 PutSprite(Monster[1],spieler[1].x,spieler[1].y,screen1^);
 PutSprite(Monster[2],spieler[2].x,spieler[2].y,screen1^);
End;
Procedure Stars;
Begin
      For St_nr:=0 to maxstern do Begin
      With Sterne[st_nr] do Begin
        screen1^[y,x]:=0;
        Dec(x,Ebene shr 5 + 1);
        if x <= 0 Then Begin
          x:=319;
          y:=Random(199);
          Ebene:=Random(256);
        End;
        screen1^[y,x]:=Ebene shr 2 ;
      End;
    End;
End;

Procedure Input;
Begin
 if mauson then
 Begin
  Maus_Abfrage;
  Spieler[1].x:=maus.X shr 1;
  Spieler[1].y:=maus.y;
 End;
  if keypressed then
  Begin
   taste:=readkey;
   if (taste in [#72..#82]) or (taste=Sp2_halt)  then taste2:=taste;
   if taste in ['e','s','d','f','a'] then taste1:=taste;
  End else taste:=#255;
   if not mauson then
   case taste1 of
    's':Dec(Spieler[1].X,speed);
    'f':Inc(Spieler[1].X,speed);
    'e':Dec(Spieler[1].y,speed);
    'd':Inc(Spieler[1].y,speed);
   End;
  case taste2 of
    TLeft:Dec(Spieler[2].X,speed);
    TRight:Inc(Spieler[2].X,speed);
    TUp:Dec(Spieler[2].y,speed);
    TDown:Inc(Spieler[2].y,speed);
   End;
 If (taste=Sp1_schuss) and (not Spieler[1].fire) then
 Begin
  Spieler[1].fire:=true;
  Schuesse[1].x:=spieler[1].x+breite;
  Schuesse[1].y:=spieler[1].y+sp1_knarre;
  Schuesse[1].laenge:=Norml;
 End;
 If (taste=Sp2_schuss) and (not Spieler[2].fire) then
 Begin
  Spieler[2].fire:=true;
  Schuesse[2].x:=spieler[2].x-97;
  Schuesse[2].y:=spieler[2].y+sp2_knarre;
  Schuesse[2].laenge:=Norml;
  if spieler[2].x<Norml then Schuesse[2].laenge:=Spieler[2].x;
 End;
{(Taste=Sp2_schuss)}
End;

Procedure Schuss;
var starty:word;
Begin

 if Spieler[1].fire then with schuesse[1] do
 Begin
  if x>319-laenge then laenge:=319-x;
  fillchar(screen1^[schuesse[1].y-1,schuesse[1].x],laenge,dRot);
  fillchar(screen1^[schuesse[1].y,schuesse[1].x],laenge,Rot);
  fillchar(screen1^[schuesse[1].y+1,schuesse[1].x],laenge,dRot);
  Screen1^[schuesse[1].y,schuesse[1].x+laenge]:=dRot;
  Screen1^[schuesse[1].y,schuesse[1].x-1]:=dRot;
  Inc(schuesse[1].x,schuss_speed);

  if Schuesse[1].x>319 then Spieler[1].fire:=False;
 End;
 if Spieler[2].fire then with schuesse[2] do
 Begin
   if x<1 then begin dec(laenge,schuss_speed); x:=1;end;
  fillchar(screen1^[schuesse[2].y-1,Schuesse[2].x],laenge,dGruen);
  fillchar(screen1^[schuesse[2].y,Schuesse[2].x],laenge,Gruen);
  fillchar(screen1^[schuesse[2].y+1,Schuesse[2].x],laenge,dGruen);
  screen1^[schuesse[2].y,Schuesse[2].x+laenge]:=dGruen;
  screen1^[schuesse[2].y,Schuesse[2].x-1]:=dGruen;
  Dec(schuesse[2].x,schuss_speed);

 if laenge<schuss_speed then Spieler[2].fire:=False;
 End;
End;

Procedure Main;
var s,s1,s2,s3,s4:string;
   b:byte;
Begin
 repeat
{  for t:=1 to 500 do PutBlood(blood1,random(300)+10,random(180)+10,screen2^);}
  Stars;
  InPut;
  ShowPlayers;
  Schuss;
  str(spieler[1].x:5,s1);str(spieler[1].y:5,s2);
  str(spieler[2].x:5,s3);str(spieler[2].y:5,s4);
  s:='('+s1+';'+s2+')            ('+s3+';'+s4+')';
{  Outtextxy2(0,0,s,rot,screen1^);}
  waitretrace;
  Movelongint(screen1^,screen,16000);
  Filllongint(screen1^,16000,0);
 until taste=#27;
 TextMode(3);
 Write('ÉÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ»');
 Write('³                         Kent&Robert-Engine Demo                              ³');
 Write('ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´');
 Write('³                               PK-crew 1999                                   ³');
 Write('ÈÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼');
 readkey;
End;
Begin
 Init;
 Main;
End.