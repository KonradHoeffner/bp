uses _13h,_32bit,konrad,crt,sprites;

const
id_string:string='das Katzen - Game wurde programmiert von Konrad Hîffner und Simon TrÅmpler';
{---Debug----}
show_anz=true;
show_fps=false;
unendlich_muni=true;
{------------}
el_anz=3;
{Spezialeffekte}
 stuecke_bleiben=true;
 stuecke_time=100;
 blood_amount=300;
{Waffen}
 WP_anz=3;
 gun=1;
 shotgun=2;
 mp=3;
 WP_schaden:array[1..wp_anz] of byte = (100,255,50);
 WP_loadtime:array[1..wp_anz] of byte = (25,50,5);
 WP_Blast:array[1..wp_anz] of byte = (0,10,0);
 WP_Timer:byte=0;
 maxmuni=50;

{------------------Konstantenarrays--------------}
fade : array[1..10,1..10] of byte =
(
(0 ,0 ,0 ,0 ,40,40,40,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,41,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,42,0 ,0 ,0 ,0 ),
(0 ,40,0 ,0 ,0 ,43,0 ,0 ,0 ,40),
(0 ,40,41,42,43,44,43,42,41,40),
(0 ,40,0 ,0 ,0 ,43,0 ,0 ,0 ,40),
(0 ,0 ,0 ,0 ,0 ,42,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,41,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,40,40,40,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ));


katze : array[1..3] of array[1..10,1..10] of byte =
((
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,6 ,0 ,0 ),
(0 ,6 ,0 ,0 ,0 ,0 ,6 ,6 ,0 ,0 ),
(0 ,6 ,0 ,0 ,0 ,0 ,6 ,6 ,6 ,0 ),
(6 ,0 ,0 ,6 ,6 ,6 ,6 ,1 ,6 ,6 ),
(6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ),
(6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,0 ),
(6 ,6 ,6 ,6 ,6 ,6 ,6 ,0 ,0 ,0 ),
(6 ,6 ,0 ,0 ,0 ,6 ,6 ,0 ,0 ,0 ),
(0 ,6 ,0 ,0 ,0 ,0 ,6 ,0 ,0 ,0 ),
(0 ,6 ,6 ,0 ,0 ,0 ,6 ,6 ,0 ,0 )
),(
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,6 ,0 ,0 ),
(0 ,6 ,0 ,0 ,0 ,0 ,6 ,6 ,0 ,0 ),
(0 ,6 ,0 ,0 ,0 ,0 ,6 ,6 ,6 ,0 ),
(6 ,0 ,0 ,6 ,4 ,6 ,6 ,1 ,6 ,6 ),
(6 ,4 ,6 ,4 ,6 ,4 ,6 ,6 ,6 ,6 ),
(6 ,6 ,6 ,4 ,4 ,6 ,6 ,6 ,6 ,0 ),
(6 ,4 ,6 ,0 ,0 ,6 ,6 ,0 ,0 ,0 ),
(6 ,6 ,0 ,0 ,0 ,6 ,4 ,0 ,0 ,0 ),
(0 ,6 ,0 ,0 ,0 ,0 ,4 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,4 ,4 ,0 ,0 )
),(
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,4 ,0 ,0 ),
(0 ,4 ,0 ,0 ,0 ,0 ,4 ,0 ,0 ,0 ),
(0 ,4 ,0 ,0 ,0 ,0 ,6 ,6 ,4 ,0 ),
(4 ,0 ,0 ,6 ,4 ,6 ,6 ,1 ,6 ,6 ),
(4 ,4 ,6 ,4 ,6 ,4 ,6 ,6 ,6 ,6 ),
(6 ,6 ,6 ,4 ,4 ,6 ,6 ,6 ,6 ,0 ),
(6 ,4 ,6 ,0 ,0 ,6 ,6 ,0 ,0 ,0 ),
(6 ,6 ,0 ,0 ,0 ,6 ,4 ,0 ,0 ,0 ),
(0 ,6 ,0 ,0 ,0 ,0 ,4 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,4 ,4 ,0 ,0 )
));

katze_tot:array[1..3] of array[1..7,1..7] of byte =
((
(0,0,0,0,4,0,0),
(0,0,0,6,6,0,0),
(0,0,0,6,6,6,0),
(4,6,4,4,1,6,6),
(6,4,6,6,6,6,6),
(0,4,0,6,6,6,0),
(0,0,0,6,0,0,0)),
(
(0,0,0,0,0,0,0),
(0,6,0,0,0,0,0),
(0,6,0,0,0,0,0),
(4,0,0,6,6,0,0),
(4,6,6,6,6,6,6),
(4,6,0,6,6,4,4),
(4,6,0,0,4,0,0)),
(
(0,0,0,0,0,0,0),
(0,0,0,0,0,0,0),
(0,4,4,0,0,0,0),
(4,4,4,4,0,0,0),
(6,6,0,0,0,0,0),
(0,6,0,0,0,0,0),
(0,6,6,0,0,0,0)));

einschlag_loch : array[1..el_anz] of array[1..8,1..8] of byte =
((
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,24,22,0 ,0 ,0 ),
(0 ,0 ,26,0 ,0 ,20,0 ,0 ),
(0 ,0 ,26,0 ,0 ,20,0 ,0 ),
(0 ,0 ,0 ,24,22,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 )
),
(
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,24,0 ),
(0 ,0 ,0 ,0 ,0 ,26,0 ,22),
(0 ,24,22,0 ,0 ,0 ,24,0 ),
(26,0 ,0 ,20,0 ,0 ,0 ,0 ),
(26,0 ,0 ,20,0 ,0 ,0 ,0 ),
(0 ,24,22,0 ,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 )
),(
(0 ,0 ,00,0 ,0 ,0 ,0 ,0 ),
(0 ,00,0 ,00,0 ,0 ,00,0 ),
(0 ,0 ,00,0 ,24,00,0 ,00),
(0 ,00,00,26,0 ,22,00,0 ),
(00,0 ,0 ,00,24,0 ,0 ,0 ),
(00,0 ,00,00,00,0 ,0 ,0 ),
(0 ,00,00,00,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 )
));

ic_waffen:array[1..wp_anz] of array[1..8,1..8] of byte=
((
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ),
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ),
(8 ,8 ,8 ,8 ,8, 8 ,8 ,8 ),
(0 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ),
(0 ,0 ,15,0 ,0 ,8 ,8 ,8 ),
(0 ,15,15,0 ,0, 8 ,8 ,8 ),
(0 ,0 ,15,0 ,0 ,0 ,8 ,8 ),
(0 ,0 ,15,0 ,0 ,0 ,8 ,8 )
),
(
(6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ),
(6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ),
(0 ,0 ,0 ,6 ,6, 0 ,6 ,6 ),
(0 ,15,0 ,0 ,0 ,0 ,0 ,6 ),
(15,0 ,15,0 ,0 ,0 ,0 ,0 ),
(0 ,15,0 ,0 ,0, 0 ,0 ,0 ),
(15,0 ,0 ,0 ,0 ,0 ,0 ,0 ),
(15,15,15,0 ,0 ,0 ,0 ,0 )
),(
(0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ),
(7 ,7 ,7 ,7 ,7, 7 ,7 ,0 ),
(0 ,0 ,0 ,7 ,7 ,0 ,7 ,7 ),
(15,15,0 ,7 ,7 ,0 ,7 ,7 ),
(0 ,15,0 ,0 ,0 ,0 ,7 ,7 ),
(15,15,0 ,0 ,0, 0 ,0 ,0 ),
(0 ,15,0 ,0 ,0 ,0 ,0 ,0 ),
(15,15,0 ,0 ,0 ,0 ,0 ,0 )
));
{----------------------Sprites------------------------}
 sp_katze:array[1..3] of tsprite=((width:10;height:10;image:@katze[1]),
                                  (width:10;height:10;image:@katze[2]),
                                  (width:10;height:10;image:@katze[3]));
 sp_fade:tsprite=(width:10;height:10;image:@fade);
 sp_stueck:array[1..3] of tsprite=(
 (width:7;height:7;image:@katze_tot[1]),
 (width:7;height:7;image:@katze_tot[2]),
 (width:7;height:7;image:@katze_tot[3]));
sp_einschlag:array[1..el_anz] of tsprite=(
(width:8;height:8;image:@einschlag_loch[2]),
(width:8;height:8;image:@einschlag_loch),
(width:8;height:8;image:@einschlag_loch[3]));
sp_waffen:array[1..wp_anz] of tsprite=(
(width:8;height:8;image:@ic_waffen[1]),
(width:8;height:8;image:@ic_waffen[2]),
(width:8;height:8;image:@ic_waffen[3]));

{------------------------------------------------------}
 speedx=2;
{---Anzahlen---}
 anz_katzen:word=0;
 max_katzen=3000;
 anz_stuecke:word=0;
 max_stuecke=100;
 max_einschlag = 100;
 anz_einschlag : byte = 0;
 anz_blut:word=0;
 max_blut=1000;
{---------------}
s_startweapon=shotgun;

{------------------Typen--------------------------------}type
 tkatze = record
           x,y:integer;
           speed:shortint;
           fall:boolean;
           energie:integer;
           b:boolean;
          end;
 tstueck = record
           x,y:integer;
           speed_x,speed_y:shortint;
           nr:byte;
           timer:integer;
           end;
 teinschlag = record
               x,y : integer;
               nr  : byte;
              end;
 twaffe= record
          besitz:boolean;
          muni:byte;
         end;
 tblut= record
         x,y:integer;
         vx,vy:shortint;
        end;
{-----------------Variablen------------------------------}var
 screen1:^tscreen;
 t:integer;
 spieler:record
          waffe:byte;
          kx,ky:integer;
         end;
 Waffen:array[1..wp_anz] of TWaffe;
 {---Figuren - Arrays----}
 katzen:array[1..max_katzen] of tkatze;
 stuecke:array[1..max_stuecke] of tstueck;
 einschlag : array[1..max_einschlag] of teinschlag;
 blut:array[1..max_blut] of tblut;
{-Prozeduren-----------------------------}
Procedure Schuss;Forward;
{-New Prozeduren-------------------------}
Procedure NewCat(mx,my:word);Forward;
Procedure NewStuecke(mx,my:word);Forward;
Procedure NewBlood(mx,my:word);Forward;
procedure CreateEinschlag(x,y:word;nr:byte);Forward;
{-Behandlungsprozeduren------------------}
Procedure Move_Stuecke;Forward;
Procedure Move_Blood;Forward;
procedure doMove;Forward;
{-Delete Prozeduren----------------------}
Procedure DelStueck(nr:word);Forward;
Procedure DelBlood(nr:word);Forward;
Procedure DelCat(nr:word);Forward;
{----------------------------------------}

{---------------NewCat--------------------}
Procedure NewCat(mx,my:word);
Begin
 with katzen[anz_katzen+1] do
 begin
  inc(anz_katzen);
  x:=mx;y:=my;
  fall:=true;
  speed:=speedx;
  energie:=255;
 end;
End;
{---------------NewStuecke--------------------}
Procedure NewStuecke(mx,my:word);
var t:integer;
Begin
 if anz_stuecke+2<max_stuecke then
 begin
  for t:=anz_stuecke+1 to anz_stuecke+3 do
   with stuecke[t] do
   begin
    x:=mx+random(5);
    y:=my+random(5);
    nr:=t-anz_stuecke;
    speed_x:=random(7)-3;
    speed_y:=-random(3)-2;
    timer:=stuecke_time;
   end;
  inc(anz_stuecke,3);
 end;
End;
{---------------MoveStuecke--------------------}
Procedure Move_Stuecke;
var t:word;
Begin
 for t:=anz_stuecke downto 1 do with stuecke[t] do
 begin
  inc(x,speed_x);
  inc(y,speed_y);
  if random(3) =0 then inc(speed_y);
  if y>190 then if stuecke_bleiben then
  begin
   speed_x:=0;speed_y:=0;y:=190;
   dec(Timer);
   if timer<1 then delstueck(t);
  end else delstueck(t);
 end;
End;
{----------------Delstueck-------------------}
Procedure DelStueck(nr:word);
Begin
 if nr<anz_stuecke then move(stuecke[nr+1],stuecke[nr],(anz_stuecke-nr)*sizeof(tstueck));
 dec(anz_stuecke);
End;
{------------NewBlood-------------------------}
Procedure NewBlood(mx,my:word);
var t:integer;
Begin
 if anz_blut+blood_amount-1<max_blut then
 begin
  for t:=anz_blut+1 to anz_blut+blood_amount do
   with blut[t] do
   begin
    x:=mx+random(5);
    y:=my+random(5);
    vx:=random(7)-3;
    vy:=-random(3)-2;
{    timer:=stuecke_time;}
   end;
  inc(anz_blut,blood_amount);
 end;
End;
{------------MoveBlood-------------------------}
Procedure Move_Blood;
var t:word;
Begin
 for t:=anz_blut downto 1 do with blut[t] do
 begin
  inc(x,vx);
  inc(y,vy);
  if random(3) =0 then inc(vy);
  if y>190 then{ if stuecke_bleiben then
  begin
   speed_x:=0;speed_y:=0;y:=190;
   dec(Timer);
   if timer<1 then delstueck(t);
  end else }delblood(t);
 end;
End;
{----------------DelBlood-------------------}
Procedure DelBlood(nr:word);
Begin
 if nr<anz_blut then move(blut[nr+1],blut[nr],(anz_blut-nr)*sizeof(tblut));
 dec(anz_blut);
End;
{--------------------------------------------}

Procedure DelCat(nr:word);
Begin
 if nr<anz_katzen then move(katzen[nr+1],katzen[nr],(anz_katzen-nr)*sizeof(tkatze));
 dec(anz_katzen);
End;

procedure CreateEinschlag(x,y:word;nr:byte);
begin
  if anz_einschlag<max_einschlag then inc(anz_einschlag,1)
   else move(einschlag[2],einschlag[1],(max_einschlag-1)*sizeof(teinschlag));
    begin
     einschlag[anz_einschlag].x:=x;
     einschlag[anz_einschlag].y:=y;
     einschlag[anz_einschlag].nr:=nr;
    end;
end;


Procedure Init;
var t:word;
Begin
 Getmem(screen1,64000);
 Maus_Init;
 Init13h;
 randomize;
 fillchar(waffen,sizeof(waffen),0);
 spieler.waffe:=s_startweapon;
 for t:=1 to wp_anz do with waffen[t] do
 begin
  besitz:=true;
  muni:=50;
 end;
{ initcount;}
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
{ endcount;}
End;

function c2b(c:char):byte;
var code:integer;dummy:byte;
begin
 val(c,dummy,code);
 c2b:=dummy;
 if code<>0 then c2b:=0;
end;

Procedure Abfrage;
var nr:byte;
Begin
 if keypressed then
 begin
  taste:=readkey;
  nr:=c2b(taste);
  case taste of
  #13: if anz_katzen < max_katzen then newcat(0,0);
  end;
  if nr in [1..wp_anz] then
  with waffen[nr] do if besitz and (muni>0) then spieler.waffe:=nr;
 end else taste:='n';
 if WP_Timer>0 then dec(WP_Timer);
 if ((taste = #32) or (maus.taste=1)) and (WP_Timer=0) then
 begin
  schuss;
  WP_Timer:=WP_Loadtime[spieler.waffe];
 end;
   Maus_Abfrage;
   Maus.x:=maus.x shr 1;
end;

procedure Schuss;
var a:byte;i:integer;
begin
 if waffen[spieler.waffe].muni>0 then
 begin
  case spieler.waffe of
   gun:CreateEinschlag(maus.x-5,maus.y-5,random(2)+1);
   shotgun:for i:=1 to 6 do CreateEinschlag(maus.x-5+random(15)-7,maus.y-5+random(15)-7,3);
  end;
  for t:=anz_katzen downto 1 do
  begin
    with katzen[t] do
    begin
     if (maus.x+5<katzen[t].x+15) and
     (maus.y+5<katzen[t].y+15) and
     (maus.x+5>katzen[t].x-5) and
     (maus.y+5>katzen[t].y-5) then
      begin
       newblood(maus.x,maus.y);
       with katzen[t] do
       begin
        dec(energie,WP_schaden[spieler.waffe]);
         if energie < 1 then
          begin
           delcat(t);
           for a:=1 to 5 do newstuecke(maus.x,maus.y);
          end;
       end;
      end;
    end;
  end;
 if not unendlich_muni then dec(waffen[spieler.waffe].muni);
 end;
end;


procedure Show;
var I:integer;cat_nr:byte;s:string;
begin
{-EinschlÑge---------------------------------}
 for t:=1 to anz_einschlag do
  putsprite(sp_einschlag[einschlag[t].nr],einschlag[t].x,einschlag[t].y,screen1^);
{-Katzen-------------------------------------}
 for t:=1 to anz_katzen do with katzen[t] do
 begin
  if energie>=200 then cat_nr:=1 else
  if energie>100 then cat_nr:=2 else cat_nr:=3;
  putsprite(sp_katze[cat_nr],x,y,screen1^);
 end;
{-Zielkreuz----------------------------------}
 putsprite(sp_fade,maus.x-5,maus.y-5,screen1^);
{-Stuecke------------------------------------}
 for t:=1 to anz_stuecke do
  putsprite(sp_stueck[stuecke[t].nr],stuecke[t].x,stuecke[t].y,screen1^);
 if WP_Timer>0 then fillchar(screen1^[0,0],WP_Timer,red);
{-Muni---------------------------------------}
 for i:=1 to wp_anz do with waffen[i] do if besitz and (muni>0) then
  HLine(screen1^,319-maxmuni,(i-1)*2,319-maxmuni+muni,2);
 if waffen[spieler.waffe].muni>0 then with waffen[spieler.waffe] do
 HLine(screen1^,319-maxmuni,(spieler.waffe-1)*2,319-maxmuni+muni,14);
 VLine(screen1^,319-maxmuni-1,0,2*wp_anz,22);
 HLine(screen1^,319-maxmuni-1,2*wp_anz,319,23);
 putsprite(sp_waffen[spieler.waffe],0,1,screen1^);
{-Debug-Infos--------------------------------}
 if show_anz then
 begin
  str(anz_katzen,s);
  outtextxy2(50,0,s,red,screen1^);
 end;
{ if show_fps then
 begin
  str(act_frames,s);
  outtextxy2(70,0,'FPS: '+s,red,screen1^);
 end;}
{-Blut---------------------------------------}
 for t:=1 to anz_blut do with blut[t] do screen1^[y,x]:=red;
{--------------------------------------------}
end;

procedure doMove;
 begin
  if anz_katzen>0 then
  for t:=1 to anz_katzen do with katzen[t] do
  begin
   if fall then
   begin
    inc(y,7);
    inc(x,1);
    if y>180 then fall:=false;
   end else
   begin
    if y > 180 then
     begin
      speed:=3+random(13);
     end;
    if x > 309 then with katzen[t] do
     begin
      x:=0;
      y:=0;
      fall:=true;
      speed:=speedx;
     end else
     begin
      b:=not b;
      if b then dec(speed,1);
      dec(y,speed shr 1);
      if b then inc(x,speedx);
     end;
   end;
  end;
end;

Procedure Main;
Begin
 repeat
{  inc(fcount);}
  abfrage;
  domove;
  move_stuecke;
  move_blood;
{---Debug----}
{  if maus.taste = 1 then newblood(maus.x,maus.y);}
{------------}
  show;
  waitretrace;
  movelongint(screen1^,screen,16000);
  filllongint(screen1^,16000,0);
 until taste=#27;
End;

begin
 Init;
 setmypalette(6,63,63,63);
 Main;
 Final;
end.