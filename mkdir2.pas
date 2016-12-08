(* 27.01.1998 unxlink test.exe x\ -> runtime error 3 *)
(* 01.04.1998 '/' '\'- Fehler *)
(* 2003.11.06 SysPathSep, SetLength *)

unit MkDir2;

interface

procedure mkdir_verschachtelt(pfad:string);

implementation

{$IfDef VirtualPascal}
uses
  VpSysLow;
{$EndIf}

procedure mkdir_verschachtelt(pfad:string);
  var
    fehler      :word;
    pfad0,
    pfad1,
    pfad2       :string;
    posp1,
    posp2       :word;
  begin
    (* Laufwerk anlegen ??? *)
    if Copy(pfad,2,255)=':\' then
      Exit;

    (* Pfadstrich am Ende beseitigen *)
    if Length(pfad)>=Length('X\') then
      if pfad[Length(pfad)] in ['/','\'] then
        {$IfDef VirtualPascal}
        SetLength(pfad,Length(pfad)-1);
        {$Else}
        Dec(pfad[0]);
        {$EndIf}

    (* Erstmal versuchen .. *)
    {$I-}
    MkDir(pfad);
    {$I+}
    fehler:=IOResult;

    (* bei Fehler schrittweise .. *)
    (* 5=Zugriff verweigert .. existiert schon *)
    if fehler=3 then
      begin
        pfad0:='';    (* schon geschafft      *)
        pfad1:='';    (* wird sofort angelegt *)
        pfad2:=pfad;  (* noch uebrig          *)

        if  (not (pfad2[Length(pfad2)] in ['/','\']))
        and (Length(pfad2)>0)
         then
          {$IfDef VirtualPascal}
          pfad2:=pfad2+SysPathSep;
          {$Else}
          pfad2:=pfad2+'\';
          {$EndIf}

        repeat
          posp1:=Pos('/',pfad2);
          posp2:=Pos('\',pfad2);
          if (0<posp1) and (posp1<posp2) then
            pfad1:=Copy(pfad2,1,posp1)
          else
            pfad1:=Copy(pfad2,1,posp2);
          Delete(pfad2,1,Length(pfad1));
          pfad1:=pfad0+pfad1;

          if (* Length(pfad1)>Length('Y:\')
          or *) Length(pfad1)>=Length('X\')
           then
            begin
              {$IfDef VirtualPascal}
              SetLength(pfad1,Length(pfad1)-1);
              {$Else}
              Dec(pfad1[0]);
              {$EndIf}
              {$I-}
              MkDir(pfad1);
              {$I+}
              fehler:=IOResult;
              {$IfDef VirtualPascal}
              pfad1:=pfad1+SysPathSep;
              {$Else}
              pfad1:=pfad1+'\';
              {$EndIf}
            end;
          pfad0:=pfad1;
        until pfad2='';
      end;
  end;

end.
