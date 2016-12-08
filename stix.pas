(*$IFDEF VirtualPascal*)
(*$M 80000*)
(*$Use32+*)
(*$DEFINE MEMORYSTREAM*)
(*$ELSE*)
(*$M 16384,120000,120000*)
(*$ENDIF*)

(* 10.08.1997 fr BMIDEOS2 *)
(* 06.10.1997 IOResult->Abbruch beim ”ffnen *)
(* 14.10.1997 Beachtung von unterverzeichnissen
              Test auf richtigen Dateityp,
              Verzeichnisanlegen *)
(* 26.11.1997 MKDIR2 -> TPU *)
(* 16.12.1997 Multi-Archiv-Dateien und SFX *)
(* 18.12.1997 Sprache und OS/2 Start .CMD *)
(* 27.01.1998 mkdir2-Verbesserung *)
(* 17.02.1998 DATA.9 -> DATA.10 und nicht DATA.: *)
(* 11.03.1998 spra_aus neu *)
(* 01.04.1998 mkdir2 neu *)
(* 2000.12.05 Probleme mit PATH>255, TTDECOMP ersetzt, Dateidatum, )
(*            Typ-Definitionen *)
(* 2001.06.12 EXE-Dateien mit verschluesselten Einzeldateinamen werden entpackt *)


program stix;

uses
  Dos,
  MkDir2,
  SucheDat,
  stix_spr,
  Strings,
  Objects;

const
  datum                 ='1997.08.10..2001.06.13';
  stirling_signatur     =#$13']e'#$8c; (* "]eŒ" *)

  neue_datei            :boolean=true;

type
  (*$IFNDEF VirtualPascal*)
  smallword             =word;
  (*$ENDIF*)

  dateikopf_typ         =
    packed record
      sig               :array[$00..$03] of char;
      u_04              :array[$04..$0b] of byte;
      datei_anzahl      :smallword;                     (* 0c 0d *)
      u_0e              :array[$0e..$11] of byte;
      archiv_laenge     :longint;                       (* 12 15 *)
      u_16              :array[$16..$28] of byte;
      namenanfang       :longint;                       (* 29 2c *)
      u_2d              :array[$2d..$30] of byte;
      verzeichnisse     :smallword;                     (* 31 32 *)
      u_33              :array[$33..$fe] of byte;
    end;


var
  archiv_anfang,
  archiv_laenge,
  archiv_ende           :longint;

  quelle                :PBufStream;
  verzeichnisse,
  datei_anzahl          :word;
  dateikopf             :dateikopf_typ;
  o,o_verzeichnisse,
  verzeichnis_anzahl    :longint;
  verzeichnis_name      :string;
  logischer_anfang_dieser_datei:longint; (* Diese Datei beginnt bei 1,4 MB *)
  logische_laenge_dieser_datei :longint; (* 0,3 KB Daten in dieser Datei *)
  logische_leseposition        :longint; (* Die n„chsten Daten kommen bei 1,5 MB *)
  datei2_dateiname      :string;
  zielverzeichnis       :string;
  tempname              :string;
  tempdatei             :PStream;
  ausgabedatei          :PBufStream;

  exe_kopf_kennung      :smallword;


procedure setze_datum(const name_:string;const datumzeit:longint);
  var
    d:file;
  begin
    Assign(d,name_);
    FileMode:=$11; (* open_share_DenyReadWrite+open_access_WriteOnly *)
    Reset(d);
    SetFTime(d,datumzeit);
    Close(d);
  end;

(*$I stsfx.pas *)

procedure fehlerpruefung(const s:PStream;const abbrechen:boolean);
  var
    r:integer;
  begin
    r:=s^.Status;
    case r of
      stOK:
        Exit;
      stError:
        WriteLn(textz_stError^);
      stInitError:
        WriteLn(textz_stInitError^);
      stReadError:
        WriteLn(textz_stReadError^);
      stWriteError:
        WriteLn(textz_stWriteError^);
      stGetError:
        WriteLn(textz_stGetError^);
      stPutError:
        WriteLn(textz_stPutError^);
    else
        WriteLn('<',r,'>');
    end;

    if abbrechen then Halt(255);

  end;

(*&CDecl+*)
type
  BuffType = packed array [1..35256] of char;
  IntFunc = function(var Buff:BuffType; var bSize:Word
              (*$IFDEF VirtualPascal*);const param:word(*$ENDIF*)): Word;


(*&OrgName+*)
function Explode(Read:IntFunc;
                 Write:IntFunc;
                 var Buf:BuffType
                 (*$IFDEF VirtualPascal*);const param:word(*$ENDIF*)
                                ): Integer;
(*$IFDEF VirtualPascal*)
  external; (*$L EXP_32/EXP32.OBJ*)
(*$ELSE*)
  far;
  external; (*$L EXP_16\IMPLODE.OBJ*)
(*$ENDIF*)
(*&OrgName-*)


function exp_lies(var Buff:BuffType; var bSize:Word
  (*$IFDEF VirtualPascal*);const param:word(*$ENDIF*)): Word; far;
  var
    jetzt               :word;
  begin
    exp_lies:=0;
    with tempdatei^ do
      begin
        jetzt:=GetSize-GetPos;
        if jetzt>bSize then
          jetzt:=bSize;
        if jetzt<=0 then
          Exit;
        Read(Buff,jetzt);
        if Status=stOK then
           exp_lies:=jetzt;
      end;
  end;

function exp_schreibe(var Buff:BuffType; var bSize:Word
  (*$IFDEF VirtualPascal*);const param:word(*$ENDIF*)): Word; far;
  begin
    with ausgabedatei^ do
      begin
        Write(Buff,bSize);
        if Status=stOK then
          exp_schreibe:=bSize
        else
          exp_schreibe:=0;
      end;
  end;
(*&Cdecl-*)


procedure entpacke(const name_:string);
  var
    pz                  :^BuffType;
    d                   :file;
    e                   :word;
  begin
    tempdatei^.seek(0);

    ausgabedatei:=New(pBufStream,Init(name_,stCreate,16*1024));
    fehlerpruefung(ausgabedatei,true);

    New(pz);

    e:=Explode(exp_lies,exp_schreibe,pz^(*$IFDEF VirtualPascal*),0(*$ENDIF*));
    if (e=3) and (tempdatei^.GetSize=4) then (* leere Datei *)
      e:=0;
    if e<>0 then
      begin
        WriteLn(textz_Fehler_beim_Entpacken_^,e,')');
        Halt(e);
      end;

    DisPose(pz);

    ausgabedatei^.Done;
    tempdatei^.Done;

    if tempname<>'' then
      begin
        Assign(d,tempname);
        Erase(d);
      end;

  end;

function generiere_einmaligen_dateinamen:string;
  var
    tmp:string;
  begin
    (*$IFDEF OS2*)
    Str(Random( 9999999),tmp);
    (*$ELSE*)
    Str(Random(   65535),tmp);
    (*$ENDIF*)
    while Length(tmp)<7 do
      tmp:='0'+tmp;
    generiere_einmaligen_dateinamen:='~'+tmp+'.TMP';
  end;

procedure schreibe_datei(const name_:string;laenge:longint;const datumzeit:longint);
  var
    puffer                      :array[0..512*10-1] of byte;
    diff                        :word;
    diff_longint                :longint;

    begin_verzeichnis_bereich   :longint;

    datenquelle                 :pBufStream;

  begin
    (* Zieldatei ”ffnen *)

    (*$IFDEF MEMORYSTREAM*)
    if laenge<MaxAvail shr 1 then
      begin
        tempname:='';
        tempdatei:=New(pMemoryStream,Init(laenge,0));
      end
    else
    (*$ENDIF*)
      begin
        tempname:=GetEnv('TMP');
        if tempname='' then
          tempname:=GetEnv('TEMP');
        if tempname[Length(tempname)]<>'/' then
          tempname:=tempname+'/';
        tempname:=tempname+generiere_einmaligen_dateinamen;
        tempdatei:=New(pBufStream,Init(tempname,stCreate,16*1024));
      end;

    fehlerpruefung(tempdatei,true);

    WriteLn('ú ',name_);

    repeat

      if neue_datei then
        WriteLn('þ ',datei2_dateiname);

      (* Quelle ”ffnen *)
      datenquelle:=New(pBufStream,Init(datei2_dateiname,stOpenRead,16*1024));
      (*fehlerpruefung(datenquelle,true);*)
      if datenquelle^.ErrorInfo<>stOK then
        begin
          WriteLn(textz_Datei_nicht_gefunden^);
          Halt(2);
        end;

      if neue_datei then
        with datenquelle^ do
          begin

            archiv_ende:=0;
            archiv_anfang:=suche_zeichenkette_in_datei(datei2_dateiname,archiv_ende,stirling_signatur);

            if archiv_anfang=nicht_gefunden then
              begin
                WriteLn(textz_kein^,stirling_signatur,textz_gefunden^);
                Halt(1);
              end;

            Seek(archiv_anfang);
            fehlerpruefung(datenquelle,true);

            Read(dateikopf,SizeOf(dateikopf));
            fehlerpruefung(datenquelle,true);

            datei_anzahl:=dateikopf.datei_anzahl;
            archiv_laenge:=dateikopf.archiv_laenge;
            archiv_ende:=archiv_anfang+archiv_laenge;
            logische_laenge_dieser_datei:=dateikopf.namenanfang-SizeOf(dateikopf);
            neue_datei:=false;
          end;

      repeat
        datenquelle^.Seek(archiv_anfang+SizeOf(dateikopf)+logische_leseposition-logischer_anfang_dieser_datei);
        fehlerpruefung(datenquelle,true);

        diff_longint:=(logischer_anfang_dieser_datei+logische_laenge_dieser_datei)-logische_leseposition;
        if diff_longint<=0 then
          begin
            Inc(logischer_anfang_dieser_datei,logische_laenge_dieser_datei);
            (* beim n„chsten ™ffnen eine neue Datei *)

            if datei2_dateiname[Length(datei2_dateiname)]=Succ('9') then
              begin
                if datei2_dateiname[Length(datei2_dateiname)-1]='.' then
                  (* XXX.9 -> XXX.10 *)
                  datei2_dateiname:=Copy(datei2_dateiname,1,Length(datei2_dateiname)-Length('.9'))+'.10'
                else
                 begin
                   (* XXX.39 -> XXX.40 *)
                   Dec(datei2_dateiname[Length(datei2_dateiname)-0],9);
                   Inc(datei2_dateiname[Length(datei2_dateiname)-1],1);
                 end;
              end
            else
              (* XXX.2 -> XXX.3 *)
              (* DATA.A -> DATA.B *)
              Inc(datei2_dateiname[Length(datei2_dateiname)]);

            neue_datei:=true;
            Break;
          end;

        if diff_longint>SizeOf(puffer) then
          diff_longint:=SizeOf(puffer);

        diff:=diff_longint;

        if diff>laenge then
          diff:=laenge;

        datenquelle^.Read(puffer,diff);
        fehlerpruefung(datenquelle,true);

        tempdatei^.Write(puffer,diff);
        fehlerpruefung(tempdatei,true);

        Dec(laenge,diff);
        Inc(logische_leseposition,diff);
      until laenge=0; (* keine H„ppchen mehr *)

      datenquelle^.Done;
      fehlerpruefung(datenquelle,true);

    until laenge=0;

    entpacke(name_);

    setze_datum(name_,datumzeit);
  end;


procedure entpacke_dateien;
  var
    verzeichnis_kopf    :
      packed record
        anzahl          :smallword;
        blocklaenge     :smallword;
      end;
    verzeichnis_block   :
      packed record
        namenlaenge     :smallword;
        name_           :array[0..260] of char;
      end;

    datei_kopf          :
      packed record
        u_00            :array[$00..$06] of byte;
        laenge          :longint;                 (* 07 0a *)
        u_0b            :array[$0b..$0e] of byte;
        datum           :smallword;               (* 0f 10 *)
        zeit            :smallword;               (* 11 12 *)
        u_13            :array[$13..$16] of byte;
        blocklaenge     :smallword;               (* 17 1a *)
        u_19            :array[$19..$1c] of byte;
        dateiname       :string;                  (* 1d    *)
      end;

    zaehler             :word;

  const
    pos_dateikopf_blocklaenge=$17;

  begin
    o_verzeichnisse:=o;
    verzeichnis_anzahl:=0;

    (* Verzeichnisnamen *)
    quelle^.Seek(archiv_anfang+o);
    fehlerpruefung(quelle,true);
    for zaehler:=1 to verzeichnisse do
      begin
        quelle^.Read(verzeichnis_kopf,SizeOf(verzeichnis_kopf));
        fehlerpruefung(quelle,true);

        quelle^.Read(verzeichnis_block,verzeichnis_kopf.blocklaenge-4);
        fehlerpruefung(quelle,true);

        verzeichnis_name:=zielverzeichnis+'/'+StrPas(verzeichnis_block.name_);
        WriteLn('+ mkdir ',verzeichnis_name);
        mkdir_verschachtelt(verzeichnis_name);
        Inc(o,verzeichnis_kopf.blocklaenge);
      end;

    for zaehler:=1 to datei_anzahl do
      begin
        if verzeichnis_anzahl=0 then
          begin
            quelle^.Seek(archiv_anfang+o_verzeichnisse);
            fehlerpruefung(quelle,true);

            quelle^.Read(verzeichnis_kopf,SizeOf(verzeichnis_kopf));
            fehlerpruefung(quelle,true);

            quelle^.Read(verzeichnis_block,verzeichnis_kopf.blocklaenge-4);
            fehlerpruefung(quelle,true);

            verzeichnis_name:=StrPas(verzeichnis_block.name_);
            if verzeichnis_name<>'' then
              verzeichnis_name:=verzeichnis_name+'/';

            verzeichnis_anzahl:=verzeichnis_kopf.anzahl;
            Inc(o_verzeichnisse,verzeichnis_kopf.blocklaenge);
          end;

        Dec(verzeichnis_anzahl);

        quelle^.Seek(archiv_anfang+o);
        fehlerpruefung(quelle,true);

        with datei_kopf do
          begin
            quelle^.Read(u_00,pos_dateikopf_blocklaenge+SizeOf(blocklaenge));
            fehlerpruefung(quelle,true);

            quelle^.Read(u_19,blocklaenge-(pos_dateikopf_blocklaenge+SizeOf(blocklaenge)));
            fehlerpruefung(quelle,true);

            schreibe_datei(zielverzeichnis+'/'+verzeichnis_name+dateiname,
                       laenge,
                       datum shl 16+zeit);
            Inc(o,blocklaenge);
          end;

      end;

  end;

begin
  Randomize;
  Write(^m);
  WriteLn('STIX * '+textz_entpacker_fuer^+' "The Stirling Compressor" / installSHIELD 3.x');
  WriteLn('Veit Kannegieser * '+datum);
  WriteLn;

  if ParamCount<>2 then
    begin
      WriteLn(textz_benutzung^,ParamStr(0),textz_Dateiname_Zielverzeichnis^);
      Halt(1);
    end;

  datei2_dateiname:=ParamStr(1);

  zielverzeichnis:=FExpand(ParamStr(2));
  if (Copy(zielverzeichnis,Length(zielverzeichnis),1)='\')
  or (Copy(zielverzeichnis,Length(zielverzeichnis),1)='/') then
    Dec(zielverzeichnis[0]);

  mkdir_verschachtelt(zielverzeichnis);

  quelle:=New(pBufStream,Init(datei2_dateiname,stOpenRead,16*1024));
  (*fehlerpruefung(quelle0,true);*)
  if quelle^.ErrorInfo<>stOK then
    begin
      WriteLn(textz_Datei_nicht_gefunden^);
      Halt(2);
    end;

  quelle^.Read(exe_kopf_kennung,SizeOf(exe_kopf_kennung));
  if (exe_kopf_kennung=Ord('M')+Ord('Z') shl 8)
  or (exe_kopf_kennung=Ord('Z')+Ord('M') shl 8) then
    begin
      archiv_anfang:=suche_zeichenkette_in_datei(datei2_dateiname,1000,#$ca#$da#$7a#$5b#$4a#$76#$3e);
      if archiv_anfang<>nicht_gefunden then
        begin
          entpacke_sfx(archiv_anfang-$14);
          Halt(0);
        end;
    end;


  archiv_anfang:=suche_zeichenkette_in_datei(datei2_dateiname,0,stirling_signatur);
  if archiv_anfang=nicht_gefunden then
    begin
      WriteLn(textz_kein^,stirling_signatur,textz_gefunden^);
      Halt(1);
    end;


  archiv_ende:=archiv_anfang;

  repeat
    archiv_anfang:=suche_zeichenkette_in_datei(datei2_dateiname,archiv_ende,stirling_signatur);
    if archiv_anfang=nicht_gefunden then break;

    if archiv_anfang<>0 then
      WriteLn('²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²',archiv_anfang:9,' ²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²');

    with quelle do
      begin
        Seek(archiv_anfang);
        fehlerpruefung(quelle,true);
        Read(dateikopf,SizeOf(dateikopf));
        fehlerpruefung(quelle,true);
      end;

    archiv_laenge:=dateikopf.archiv_laenge;
    archiv_ende:=archiv_anfang+archiv_laenge;

    datei_anzahl :=dateikopf.datei_anzahl;
    verzeichnisse:=dateikopf.verzeichnisse;

    logische_leseposition:=0;
    logischer_anfang_dieser_datei:=0;

    o:=dateikopf.namenanfang;

    entpacke_dateien;

    archiv_anfang:=archiv_ende;

  until false;


end.

