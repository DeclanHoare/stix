(* prepares language string to include file or binary file              *)
(* this code is only used during the build process                      *)

(* V.K. 04.10.1996                                                      *)
(* 23.10.1996 signature                                                 *)
(* 01.12.1996 support for ^array[...]                                   *)
(* 12.06.1998 VP20 Frame-, USES NONE, S-                                *)
(* 1999.11.20 more languages, prepated for use of environment variables *)
(*            like SET LANG=DE_DE                                       *)
(* 2000.01.06 avoid "'"                                                 *)
(* 2001.03.17 output to binary file possible                            *)
(* 2006.05.02 reworked, english identifiers                             *)
(* 2006.06.05 fixed array mode                                          *)


{&Use32+}
unit spr2_ein;

interface


(* new function names *)
procedure LanguageTableHeader(const Languages: String);
procedure LanguageTableHeaderExtended(const Languages: String; const OnlyOneField: Boolean);
procedure LanguageStringEntry04(const Identifier, str_l01, str_l02, str_l03, str_l04: String);
procedure LanguageStringEntry08(const Identifier, str_l01, str_l02, str_l03, str_l04,
                                                  str_l05, str_l06, str_l07, str_l08: String);
procedure LanguageStringEntry12(const Identifier, str_l01, str_l02, str_l03, str_l04,
                                                  str_l05, str_l06, str_l07, str_l08,
                                                  str_l09, str_l10, str_l11, str_l12: String);
procedure WriteLanguageStringToFile(FileName_dat, FileName_pas, ObjectIdentifier, StartIdenitier, TypeIdentifier: String);


(* old function names *)
procedure sprachtabellenkopf(const abkuerzungen: String);
procedure sprachtabellenkopf_erweitert(const abkuerzungen: String; const nur_ein_feld: Boolean);
procedure sprach_eintrag04(const bezeichner, zk_l01, zk_l02, zk_l03, zk_l04: String);
procedure sprach_eintrag08(const bezeichner, zk_l01, zk_l02, zk_l03, zk_l04,
                                             zk_l05, zk_l06, zk_l07, zk_l08: String);
procedure sprach_eintrag12(const bezeichner, zk_l01, zk_l02, zk_l03, zk_l04,
                                             zk_l05, zk_l06, zk_l07, zk_l08,
                                             zk_l09, zk_l10, zk_l11, zk_l12: String);
procedure schreibe_sprach_datei(name_dat, name_pas, objekt_bezeichner, start_bezeichner, typ_bezeichner: String);


implementation

uses
  spr2_aus;

const
  null                          : Byte = 0;
  max_pascal_zeilenlaenge       = 75;
  pStringIDPrefix               = 'textz_';

var
  sprachen_vorhanden            :string;
  anzahl_sprachen_vorhanden     :word;
  sprach_elemente               :word;
  zeichenketten_tabelle         :TTranslatedStringTable;
  eine_variable                 :boolean;
  textz_praefix                 :string;

procedure LanguageTableHeader(const Languages: String);
  begin
    LanguageTableHeaderExtended(Languages, false);
  end;

procedure LanguageTableHeaderExtended(const Languages: String; const OnlyOneField: Boolean);
  begin
    sprach_elemente := 0;
    sprachen_vorhanden := Languages;
    if (Length(sprachen_vorhanden) mod Length('DE')) <> 0 then
      RunError(1);
    anzahl_sprachen_vorhanden := Length(sprachen_vorhanden) div Length('DE');

    if anzahl_sprachen_vorhanden > High(LanguagesSupported) then
      RunError(1);

    eine_variable := OnlyOneField;
    if OnlyOneField then
      textz_praefix := ''
    else
      textz_praefix:= pStringIDPrefix
  end;

procedure sprach_eintrag_nn(const zk:string;const nn:word);
  begin
    GetMem(zeichenketten_tabelle[sprach_elemente,nn],1+Length(zk));
    zeichenketten_tabelle[sprach_elemente,nn]^:=zk;
  end;

procedure sprach_eintrag_bz(const bezeichner:string);
  begin
    if (Pos(' ',bezeichner)>0)
    or (Pos('„',bezeichner)>0)
    or (Pos('”',bezeichner)>0)
    or (Pos('',bezeichner)>0)
    or (Pos('Ž',bezeichner)>0)
    or (Pos('™',bezeichner)>0)
    or (Pos('š',bezeichner)>0)
    or (Pos('á',bezeichner)>0)
      then
        begin
          WriteLn('Fehler:',bezeichner);
          ReadLn;
          Halt;
        end;

    Inc(sprach_elemente);
    if sprach_elemente>High(zeichenketten_tabelle) then
      begin
        WriteLn('zu viele Spracheintr„ge!');
        Halt(1);
      end;

    sprach_eintrag_nn(bezeichner,00);
  end;

procedure LanguageStringEntry04(const Identifier, str_l01, str_l02, str_l03, str_l04: String);
  begin
    sprach_eintrag_bz(Identifier);
    sprach_eintrag_nn(str_l01,01);
    sprach_eintrag_nn(str_l02,02);
    sprach_eintrag_nn(str_l03,03);
    sprach_eintrag_nn(str_l04,04);
  end;

procedure LanguageStringEntry08(const Identifier, str_l01, str_l02, str_l03, str_l04,
                                                  str_l05, str_l06, str_l07, str_l08: String);
  begin
    sprach_eintrag_bz(Identifier);
    sprach_eintrag_nn(str_l01,01);
    sprach_eintrag_nn(str_l02,02);
    sprach_eintrag_nn(str_l03,03);
    sprach_eintrag_nn(str_l04,04);
    sprach_eintrag_nn(str_l05,05);
    sprach_eintrag_nn(str_l06,06);
    sprach_eintrag_nn(str_l07,07);
    sprach_eintrag_nn(str_l08,08);
  end;

procedure LanguageStringEntry12(const Identifier, str_l01, str_l02, str_l03, str_l04,
                                                  str_l05, str_l06, str_l07, str_l08,
                                                  str_l09, str_l10, str_l11, str_l12: String);
  begin
    sprach_eintrag_bz(Identifier);
    sprach_eintrag_nn(str_l01,01);
    sprach_eintrag_nn(str_l02,02);
    sprach_eintrag_nn(str_l03,03);
    sprach_eintrag_nn(str_l04,04);
    sprach_eintrag_nn(str_l05,05);
    sprach_eintrag_nn(str_l06,06);
    sprach_eintrag_nn(str_l07,07);
    sprach_eintrag_nn(str_l08,08);
    sprach_eintrag_nn(str_l09,09);
    sprach_eintrag_nn(str_l10,10);
    sprach_eintrag_nn(str_l11,11);
    sprach_eintrag_nn(str_l12,12);
  end;

procedure WriteLanguageStringToFile(FileName_dat, FileName_pas, ObjectIdentifier, StartIdenitier, TypeIdentifier: String);
  var
    datei_dat                   :text;
    datei_bin                   :file;
    datei_pas                   :text;
    zaehler                     :word;
    sprachzaehler               :LanguagesSupported;
    zk_z                        :pString;
    w1,w2                       :word;
    bin_modus                   :boolean;

  procedure block_asm(var p;anzahl:word);
    var
      zk                        :string;
      zeilenposition            :word;
      l1                        :word;

    procedure asm_ausgabe_neue_zeile;
      begin
        WriteLn(datei_dat);
        zeilenposition:=1;
      end;

    procedure asm_ausgabe_zk(const zk:string);
      var
        z:word;
      begin
        Write(datei_dat,zk);
        Inc(zeilenposition,Length(zk));
      end;

    procedure asm_ausgabe_b(const b,s:byte);
      var
        bs:string;
      begin
        Str(b:s,bs);
        asm_ausgabe_zk(bs);
      end;

    begin
      if bin_modus then
        begin
          BlockWrite(datei_bin,p,anzahl);
          Exit;
        end;

      if anzahl>255 then
        RunError(1);
      Move(p,zk[1],anzahl);
      zk[0]:=Chr(anzahl);


      zeilenposition:=1;

      while zk<>'' do
        begin

          if zeilenposition=1 then
            begin
              asm_ausgabe_zk('    db ');
              if length(zk)<>anzahl then
                asm_ausgabe_zk('    ');
            end;

          w1:=0;
          repeat
            Inc(w1);
            w2:=w1-1;
            if zeilenposition+Length(#39)+w1+Length(#39)>max_pascal_zeilenlaenge then
              break;
            if (zk[w1] in [#0..#31,#39]) or (Length(zk)=anzahl) then
              break;
          until w1>Length(zk);

          if w2>0 then
            begin
              asm_ausgabe_zk(#39+Copy(zk,1,w2)+#39);
              Delete(zk,1,w2);
            end
          else
            begin
              if (Length(zk)=anzahl) then
                asm_ausgabe_b(Ord(zk[1]),3)
              else
                asm_ausgabe_b(Ord(zk[1]),1);
              Delete(zk,1,1);
            end;

          if zk='' then
            asm_ausgabe_neue_zeile
          else
            if zeilenposition+Length(',')>max_pascal_zeilenlaenge then
              asm_ausgabe_neue_zeile
            else
              asm_ausgabe_zk(',');

        end;

      if zeilenposition<>1 then
        asm_ausgabe_neue_zeile
    end;


  begin
    bin_modus := Pos('.001', FileName_dat) = 0;

    if bin_modus then
      begin
        Assign(datei_bin, FileName_dat);
        Rewrite(datei_bin, 1);
        BlockWrite(datei_bin, spra2_signature, SizeOf(spra2_signature));
        BlockWrite(datei_bin, sprachen_vorhanden, 1 + Length(sprachen_vorhanden));
        BlockWrite(datei_bin, sprach_elemente, 2);
      end
    else
      begin
        Assign(datei_dat, FileName_dat);
        Rewrite(datei_dat);
        WriteLn(datei_dat, '(* automatically generated, do not edit.. *)');
        WriteLn(datei_dat, 'procedure ', ObjectIdentifier, '; assembler; {&Frame-} {&Uses None} {$S-}');
        WriteLn(datei_dat, '  asm');
        WriteLn(datei_dat, '    db ', Length(spra2_signature   ): 3, ',', #39, spra2_signature   , #39);
        WriteLn(datei_dat, '    db ', Length(sprachen_vorhanden): 3, ',', #39, sprachen_vorhanden, #39);
        WriteLn(datei_dat, '    dw ', sprach_elemente: 3);
      end;

    Assign(datei_pas, FileName_pas);
    Rewrite(datei_pas);
    WriteLn(datei_pas, '(* automatically generated, do not edit.. *)');
    WriteLn(datei_pas, 'var');
    WriteLn(datei_pas,'  ', StartIdenitier, ': Longint;');

    for zaehler:=1 to sprach_elemente do
      begin

        if (zaehler = 1) or (not eine_variable) then
          begin
            if zaehler > 1 then
              WriteLn(datei_pas, ',');
            Write  (datei_pas, '  ', textz_praefix, zeichenketten_tabelle[zaehler][00]^);
          end;

        for sprachzaehler := 1 to anzahl_sprachen_vorhanden do
          begin

            zk_z := zeichenketten_tabelle[zaehler,sprachzaehler];

            if zk_z = nil then
              block_asm(null,1)
            else
              begin
                block_asm(zk_z^, 1 + Length(zk_z^));
                FreeMem(  zk_z , 1 + Length(zk_z^));
              end;

          end;
      end;

    WriteLn(datei_pas, '  :', TypeIdentifier, ';');

    if bin_modus then
      Close(datei_bin)
    else
      begin
        WriteLn(datei_dat, '  end;');
        Close(datei_dat);
      end;

    Close(datei_pas);
  end;


(* map old to new function names *)
procedure sprachtabellenkopf(const abkuerzungen: String);
  begin
    LanguageTableHeader(abkuerzungen);
  end;
procedure sprachtabellenkopf_erweitert(const abkuerzungen: String; const nur_ein_feld: Boolean);
  begin
    LanguageTableHeaderExtended(abkuerzungen, nur_ein_feld);
  end;
procedure sprach_eintrag04(const bezeichner, zk_l01, zk_l02, zk_l03, zk_l04: String);
  begin
    LanguageStringEntry04(bezeichner, zk_l01, zk_l02, zk_l03, zk_l04);
  end;
procedure sprach_eintrag08(const bezeichner, zk_l01, zk_l02, zk_l03, zk_l04,
                                             zk_l05, zk_l06, zk_l07, zk_l08: String);
  begin
    LanguageStringEntry08(bezeichner, zk_l01, zk_l02, zk_l03, zk_l04,
                                      zk_l05, zk_l06, zk_l07, zk_l08);
  end;
procedure sprach_eintrag12(const bezeichner, zk_l01, zk_l02, zk_l03, zk_l04,
                                             zk_l05, zk_l06, zk_l07, zk_l08,
                                             zk_l09, zk_l10, zk_l11, zk_l12: String);
  begin
    LanguageStringEntry12(bezeichner, zk_l01, zk_l02, zk_l03, zk_l04,
                                      zk_l05, zk_l06, zk_l07, zk_l08,
                                      zk_l09, zk_l10, zk_l11, zk_l12);
  end;
procedure schreibe_sprach_datei(name_dat, name_pas, objekt_bezeichner, start_bezeichner, typ_bezeichner: String);
  begin
    WriteLanguageStringToFile(name_dat, name_pas, objekt_bezeichner, start_bezeichner, typ_bezeichner);
  end;

end.
