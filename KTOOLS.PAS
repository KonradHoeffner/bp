unit ktools;

interface
uses graph;

procedure svga3(m:integer);
{SVGA386 (Modus=m) }
procedure waitvonly;

procedure waitvret;
{WaitVertikalRetrace}
procedure waitdisplay;

implementation

procedure svga3(m:integer);
var d:integer;
    treiberF: file;
    treiberP: Pointer;
begin
 Assign(treiberF, 'c:\bp\units\svga386.obj');
 Reset(treiberF, 1);
 GetMem(treiberP, FileSize(treiberF));
 BlockRead(treiberF, treiberP^, FileSize(treiberF));
{ d:=installuserdriver('svga386',nil);}
{ d:=treiberP;}
  write(RegisterBGIdriver(treiberP));
  readln;
{  d:=svga386;}

 initgraph(d,m,'c:\bp\bgi');
end;

procedure waitdisplay;
begin
repeat until (port[$3da] and 8) <>0;
repeat until (port[$3da] and 8) =0;
end;


procedure waitvret;
begin
repeat until (port[$3da] and 8) =0;
repeat until (port[$3da] and 8) <>0;
end;

procedure waitvonly;
begin
repeat until (port[$3da] and 8) <>0;
end;

end.