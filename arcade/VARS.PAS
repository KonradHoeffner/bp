unit vars;
interface
uses sprites,konrad;
const
{---Cheats---}
godmode:boolean=false;
{---Paths---}
path='c:\eigene~1\bp\arcade\';
imgpath=path+'images\';
img_a_1='a_1.pcx';
img_b_1='b_1.pcx';
{---Game---}
gameover:boolean=false;
level:integer=1;
{----------}
max=20;
anz:word=0;
{---Kollision---}
damage_s1=5;
{----Testkonstanten-}
guy_start_x=270;
{----Gun------------}
g_laenge=30;
g_col=20;
g_wspeed=3;
g_start_x=160;
g_start_e=319;
g_start_w=90;
g_minw=10;
g_maxw=170;
{----Plane----------}
p_timer=35;
p_abwurftimer=10;
p_hoehe=10;
p_l_xstart=10;
p_l_xend=310;
p_r_xstart=310;
p_r_xend=10;
p_startspeed=3;
p_fspeed=7;
{----Guys-----------}
guy_fspeed=1;
guy_lspeed=2;
{-------------------}
{----Koordinaten----}
boden_y=199;
{----Graphics-------}
doBG=false;
{---Frames---}
{Guys}
{l=lauf;s=schlag;d=explo}
guy_l_frames=2;
guy_l_start_frame=1;
guy_l_framedelay=10;
guy_s_frames=2;
guy_s_start_frame=1;
guy_s_framedelay=20;
guy_e_frames=2;
guy_e_startframe=1;
guy_e_framedelay=40;
{Plane}
{e=explo}
p_f_frames=2;
p_f_startframe=1;
p_f_framedelay=10;
{------------}
h=6;b=6;
ph=5;pb=10;
gh=4;gb=4;
cplane_l:
array[1..p_f_frames] of
array[1..ph*pb] of byte=(
(
1,0,0,0,0,1,0,0,0,0,
1,1,1,0,0,0,1,0,0,0,
1,1,1,1,1,1,1,1,1,1,
0,0,0,0,0,1,0,0,0,0,
0,0,0,0,1,0,0,0,0,0
),
(
1,0,0,0,0,1,1,0,0,0,
1,1,1,0,0,0,1,1,0,0,
1,1,1,1,1,1,1,1,1,1,
0,0,0,0,0,1,1,0,0,0,
0,0,0,0,1,0,0,0,0,0
));
cguy_l:array[1..guy_l_frames] of
array[1..h*b] of byte=(
(
0,0,1,1,0,0,
0,0,1,1,0,0,
1,1,1,1,1,1,
0,0,1,1,0,0,
0,1,0,0,1,0,
1,0,0,0,1,1
),(
0,0,1,1,0,0,
0,0,1,1,0,0,
1,1,1,1,1,1,
0,0,1,1,0,0,
0,0,1,1,0,0,
0,1,0,1,1,0
));

cguy_s:array[1..guy_s_frames] of
array[1..h*b] of byte=(
(
0,0,1,1,0,1,
0,0,1,1,0,1,
1,1,1,1,1,1,
1,0,1,1,0,0,
0,1,0,0,1,0,
1,0,0,0,1,1
),(
0,0,1,1,0,0,
1,0,1,1,0,0,
1,1,1,1,1,1,
0,0,1,1,0,1,
0,1,0,0,1,1,
1,0,0,0,1,1
));

cguy_e:array[1..guy_e_frames] of
array[1..h*b] of byte=(
(
1,0,0,0,0,1,
0,1,0,0,1,0,
0,0,1,1,0,0,
0,0,1,1,0,0,
0,1,0,0,1,0,
1,0,0,0,0,1
),(
0,0,0,0,0,0,
0,1,0,0,1,0,
0,0,1,1,0,0,
0,0,1,1,0,0,
0,1,0,0,1,0,
0,0,0,0,0,0
));

cguy_f:array[1..h*b] of byte=(
0,0,1,1,0,0,
1,1,1,1,1,1,
1,0,1,1,0,1,
0,0,1,0,0,0,
0,0,1,0,0,0,
0,1,0,1,0,0
);

cgun:array[1..gh*gb] of byte=(
0,0,0,0,
0,1,1,0,
1,1,1,1,
1,1,1,1
);
{-------------}
type

 tstat=(fall,lauf,schlag,explo,death);
 tpstat=(out,links,rechts,l_absturz,r_absturz,l_explo,r_explo);
 tplane=record
         x,y,speed:integer;
         stat:tpstat;
         frame,fcount:byte;
         unused,abwurf:integer;
        end;
 tguy=record
       x,y:integer;
       stat:tstat;
       frame,fcount:byte;
      end;
 tgun=record
       x:integer;
       e:integer;
       w:integer;
      end;
{ tscreen=array[0..199,0..319] of byte;}
var screen1,backgr:^tscreen;
    t:integer;
    img_p_r:array[1..p_f_frames] of array[1..ph*pb] of byte;
    sp_f,sp_g:tsprite;
    sp_l:array[1..guy_l_frames] of tsprite;
    sp_s:array[1..guy_l_frames] of tsprite;
    sp_e:array[1..guy_e_frames] of tsprite;
    sp_p_l,sp_p_r:array[1..p_f_frames] of tsprite;
    guys:array[1..max] of tguy;
    plane:tplane;
    gun:tgun;
    taste:char;

implementation
end.