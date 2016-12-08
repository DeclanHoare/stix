var
  archivinformation     :
    packed record
      archiv_anfang     :longint;
      anzahl_dateien    :longint;
      u08               :array[0.. 11] of byte;
      u14               :array[0.. 39] of char;
      exe               :array[0..127] of char;
      titel             :array[0.. 79] of char;
      pfad              :array[0..127] of char;
    end;

procedure entschluessele_installshield_dateiname_oder_myresource1024(var p_;const anfang,laenge:word);
  var
    p:TByteArray absolute p_;
  const
    schluessel:array[0..7] of byte=($b3,$f2,$ea,$1f,$aa,$27,$66,$13);

  var
    zaehler             :word;
    a7                  :byte;

  function ror8(const by:byte;const r:byte):byte;
    begin
      (*$IFDEF VIRTUALPASCAL*)
      asm (*$Alters EAX,ECX*)
        mov al,by
        mov cl,r
        ror al,cl
        mov @result,al
      end;
      (*$ELSE*)
      (* r and $7 weil ror8(x,z+8)=ror8(x,z) *)
      ror8:=((word(by) shr (r and $7)) or (word(by shl 8) shr (r and $7))) and $ff;
      (*$ENDIF*)
    end;

  begin
    for zaehler:=anfang to anfang+laenge-1 do
      begin
        a7:=(zaehler-anfang) and 7;
        p[zaehler]:=ror8(p[zaehler] xor schluessel[7-a7],7-a7) xor schluessel[a7];
      end;
  end;

procedure entpacke_sfx(const o:longint);
  var
    dateiname_laenge,
    ausgabedatum,
    laenge_eingepackt   :longint;
    dateiname           :array[0..255] of char;
    ausgabename         :string;

    jetzt               :longint;
    kopier_puffer       :array[0..16*1024-1] of byte;

    zaehler             :longint;

  begin
    quelle^.Seek(o);
    quelle^.Read(archivinformation,SizeOf(archivinformation));
    entschluessele_installshield_dateiname_oder_myresource1024(archivinformation.u14,0,SizeOf(archivinformation)-$14);
    with archivinformation do
      begin
        if archiv_anfang>quelle^.GetPos then
          quelle^.Seek(archiv_anfang);
        WriteLn(' "',exe,'"');
        WriteLn(' "',titel,'"');
        WriteLn(' "',pfad,'"');
        WriteLn;
      end;

    for zaehler:=1 to archivinformation.anzahl_dateien do
      begin
        quelle^.Read(dateiname_laenge,SizeOf(dateiname_laenge));
        if dateiname_laenge>SizeOf(dateiname) then RunError(0);
        FillChar(dateiname,SizeOf(dateiname),0);
        quelle^.Read(dateiname,dateiname_laenge);
        entschluessele_installshield_dateiname_oder_myresource1024(dateiname,0,dateiname_laenge);
        quelle^.Read(ausgabedatum     ,SizeOf(ausgabedatum     ));
        quelle^.Read(laenge_eingepackt,SizeOf(laenge_eingepackt));

        ausgabename:=StrPas(dateiname);
        Delete(ausgabename,1,StrLen(archivinformation.Pfad));
        if Pos('\',ausgabename)<>0 then
          mkdir_verschachtelt(zielverzeichnis+'\'+Copy(ausgabename,1,Pos('\',ausgabename)-1));

        ausgabename:=zielverzeichnis+'\'+ausgabename;
        Write('þ ',ausgabename);
        ausgabedatei:=New(pBufStream,Init(ausgabename,stCreate,16*1024));
        while laenge_eingepackt>0 do
          begin
            jetzt:=SizeOf(kopier_puffer);
            if jetzt>laenge_eingepackt then
              jetzt:=laenge_eingepackt;
            quelle^.Read(kopier_puffer,jetzt);
            ausgabedatei^.Write(kopier_puffer,jetzt);
            Dec(laenge_eingepackt,jetzt);
          end;
        ausgabedatei^.Done;
        setze_datum(ausgabename,(ausgabedatum shl 16) or (ausgabedatum shr 16));
        WriteLn;

      end;

  end;

