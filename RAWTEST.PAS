unit raw;
interface
Procedure LoadRaw(filename:string;var dest);
implementation

Procedure LoadRaw(filename:string;var dest);
var f:file;
Begin
 assign(f,filename);
 reset(f,1);
 blockread(f,dest,filesize(f));
 close(f);
End;

end.