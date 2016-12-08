(* setup pointers to translated strings                                 *)
(* this code is placed into the shipped application                     *)

(* V.K. 04.10.1996 *)
(* 23.10.1996 signature                                                 *)
(* 11.03.1998 SET COUNTRY=0??                                           *)
(* 03.11.1998 DPMI32                                                    *)
(* 09.12.1998 WIN32: country=1;                                         *)
(* 1999.11.20 data structure reworked 'Sprache 2'                       *)
(* 2000.01.06 DPMI(16)                                                  *)
(* 2000.01.06 DPMI(16): INT21/48->INT31/01                              *)
(* 2000.01.07 DPMI(16): Intr->INT31/03                                  *)
(* 2001.03.17 load from file                                            *)
(* 2001.03.17 signature is now typed constant                           *)
(* 2001.10.19 O+                                                        *)
(* 2004.09.01 added primitive string format functions                   *)
(* 2006.02.01 Win32: read LOCALE_IDEFAULTCOUNTRY                        *)
(* 2006.05.02 renamed DPMI16/DPMI32 types                               *)
(*            translated this source (mostly)                           *)
(*            translate strings from IBM850 to ISO Latin 1 for Linux    *)


{&Use32+}
{$O+}

{$IfDef Linux}
  {$Define Translate_IBM850_to_ISO8859_1}
{$EndIf}

unit spr2_aus;

interface

const
  spra2_signature               : String[Length('<SPRA2>')] = '<SPRA2>';
  maxstrings                    = 1000;

type
  pString                       = ^String;
  ppString                      = ^pString;
  LanguagesSupported            = 0..12;
  TTranslatedStringTable        = array[1..maxstrings, LanguagesSupported] of pString;


procedure SetLanguageStringPointers        (const DataBegin: Pointer; const FirstPointer: ppString);
procedure setze_sprachzeiger               (const DataBegin: Pointer; const FirstPointer: ppString);
procedure SetLanguageStringPointersFromFile(const FileName: String;   const FirstPointer: ppString);
procedure setze_sprachzeiger_aus_datei     (const FileName: String;   const FirstPointer: ppString);

(* open array does not work for StrFormat? *)
function StrFormat (const Format: String; const Args: Array of pString): String;
function StrFormat1(const Format: String; const Arg1: String): String;
function StrFormat2(const Format: String; const Arg1, Arg2: String): String;
function StrFormat3(const Format: String; const Arg1, Arg2, Arg3: String): String;
function StrFormat4(const Format: String; const Arg1, Arg2, Arg3, Arg4: String): String;
function StrFormat5(const Format: String; const Arg1, Arg2, Arg3, Arg4, Arg5: String): String;
function StrF(const l: Longint): String;

implementation

uses
  {$IfDef VirtualPascal}
  {$IfDef Os2}
  Os2Base, Os2Def,
  {$EndIf}
  {$IfDef DPMI32}
  dpmi32, dpmi32df,
  {$EndIf}
  {$IfDef Win32}
  Windows,
  {$EndIf}
  {$EndIf}
  Dos,
  Strings,
  WinDos;

var
  CountryCodeValue      : Word;

{$IfDef VirtualPascal}

{$IfDef DPMI32}
procedure DetermineCountryCode;assembler;{&Frame-}{&Uses eax,esi}
  var
    reg: real_mode_call_structure_type;
  asm
    lea esi,reg
    mov [esi+real_mode_call_structure_type.ax_],$3800 // get Country-specific info
    mov ax,segdossyslow16
    mov [esi+real_mode_call_structure_type.ds_],ax    // DS:DX
    mov [esi+real_mode_call_structure_type.dx_],0
    mov [esi+real_mode_call_structure_type.bx_],0
    push esi
    push $21
    call Intr_RealMode
    movzx eax,word [esi+real_mode_call_structure_type.bx_]
    mov CountryCodeValue,eax
  end;

{$EndIf}

{$IfDef Os2}
procedure DetermineCountryCode;
  var
    Country   : COUNTRYCODE; (* Country code info (0 = current country) *)
    CtryInfo  : COUNTRYINFO; (* Buffer for country-specIfic information *)
    ulInfoLen : ULONG;
    rc        : APIRET;      (* Return code                             *)
  begin
    ulInfoLen := 0;
    rc        := NO_ERROR;

    FillChar(Country, SizeOf(Country), 0);
    FillChar(CtryInfo, SizeOf(CtryInfo), 0);

    rc := DosQueryCtryInfo(SizeOf(CtryInfo), Country, CtryInfo, ulInfoLen);
    if (rc = 0) and (CtryInfo.country <= $ffff) then
      CountryCodeValue := CtryInfo.country+0
    else
      CountryCodeValue := 49;

  end;
{$EndIf}

{$IfDef Win32}
procedure DetermineCountryCode;
  var
    Locale              :LCID;
    Buffer              :array[0..260] of char;
    code                :integer;
  begin
    CountryCodeValue := 1; (* do not know -> use SET LANG=... *)

    Locale := GetThreadLocale;
    (*
    icountry: 49
    locale: 00000407
    slanguage: DEU *)

    if GetLocaleInfo(Locale, LOCALE_IDEFAULTCOUNTRY, Buffer, SizeOf(Buffer)) > 0 then
      Val(Buffer, CountryCodeValue, code);

  end;
{$EndIf}

{$IfDef Linux}
procedure DetermineCountryCode;
  begin
    CountryCodeValue := 1; (* do not know -> use SET LANG=... *)
  end;
{$EndIf}

{$Else}
procedure DetermineCountryCode;
  var
    {$IfDef DPMI}
    country_seg,
    country_sel: Word;
    {$Else}
    country_puffer: array[1..40] of Byte;
    {$EndIf}

  {$IfDef DPMI}
  type
    real_mode_call_structure_type=
      packed record
        case Longint of
          0:(edi_,esi_,ebp_,res1,ebx_,edx_,ecx_,eax_:Longint;
             flags_,es_,ds_,fs_,gs_,ip_,cs_,sp_,ss_:word;);
          1:(di_,hdi_,si_,hsi_,bp_,hbp_,res2,res3,bx_,hbx_,dx_,hdx_,cx_,hcx_,ax_,hax_:word);
          2:(res4:array[0..15] of byte;bl_,bh_:byte;res5:word;dl_,dh_:byte;res6:word;cl_,ch_:byte;res7:word;al_,ah_:byte);
      end;

  procedure Intr_RealMode(var reg: real_mode_call_structure_type; i_num: Byte);
    begin
      reg.res1:=0;
      asm
        mov ax,$0300 (* Simulate Real Mode Interrupt *)
        mov bl,i_num
        mov bh,0
        sub cx,cx    (* CX=0 (Stack push..) *)
        les di,reg
        int $31
      end;
    end;

  var
    r2: real_mode_call_structure_type;
  {$EndIf}

  begin
    {$IfDef DPMI}
    asm
      mov ax,$0100              (* DPMI: DOS Speicher anfordern *)
      mov bx,131                (* 2096>2048+40 Byte *)
      int $31
      jnc @l1
      sub bx,bx
    @l1:
      mov country_seg,ax
      mov country_sel,dx
    end;

    if country_sel = 0 then
      RunError(8);

    with r2 do
      begin
        FillChar(r2, SizeOf(r2), 0);
        ax_ := $3800;
        ds_ := country_seg;       (* -> DS:DX *)
        dx_ := 0;
        ss_ := country_seg;       (* SS:SP (1 KB) *)
        sp_ := 2096-16;
        Intr_RealMode(r2, $21);
        CountryCodeValue := bx_;
      end;

    asm
      mov ax,$0101              (* DPMI: DOS Speicher freigeben *)
      mov dx,country_sel
      int $31
    end;
    {$Else}
    asm
      push ds
        mov ax,$3800
        mov dx,offset country_puffer
        push ss
        pop ds
        int $21
      pop ds
      mov CountryCodeValue,bx
    end;
    {$EndIf}
  end;
{$EndIf}

const
  ConverterIBM850ISOLatin:array[#$80..#$ff] of Char=(
    #$c7,#$fc,#$e9,#$e2,#$e4,#$e0,#$e5,#$e7,#$ea,#$eb,#$e8,#$ef,#$ee,#$ec,#$c4,#$c5,
    #$c9,#$e6,#$c6,#$f4,#$f6,#$f2,#$fb,#$f9,#$ff,#$d6,#$dc,#$f8,#$a3,#$d8,#$d7,'?' ,
    #$e1,#$ed,#$f3,#$fa,#$f1,#$d1,#$aa,#$ba,#$bf,#$ae,#$ac,#$bd,#$bc,#$a1,#$ab,#$bb,
    '?' ,'?' ,'?' ,'|' ,'?' ,#$c1,#$c2,#$c0,#$a9,'?' ,'?' ,'?' ,'?' ,#$a2,#$a5,'?' ,
    '?' ,'?' ,'?' ,'?' ,'-' ,'?' ,#$e3,#$c3,'?' ,'?' ,'?' ,'?' ,'?' ,'=' ,'?' ,#$a4,
    #$f0,#$d0,#$ca,#$cb,#$c8,'?' ,#$cd,#$ce,#$cf,'?' ,'?' ,'?' ,'?' ,#$a6,#$cc,'?' ,
    #$d3,#$df,#$d4,#$d2,#$f5,#$d5,#$b5,#$fe,#$de,#$da,#$db,#$d9,#$fd,#$dd,#$af,#$b4,
    #$ad,#$b1,'_' ,#$be,#$b6,#$a7,#$f7,#$b8,#$b0,#$a8,#$b7,#$b9,#$b3,#$b2,'?' ,#$a0);

(* IBM codepage 850 -> ISO Latin 1 *)
function TranslateString(const Source: pString): pString;
  var
    ResultString: String;
    ResultStringP: pString;
    i: Word;
  begin
    ResultString := Source^;
    for i := 1 to Length(ResultString) do
      if ResultString[i] in [Low(ConverterIBM850ISOLatin)..High(ConverterIBM850ISOLatin)] then
        ResultString[i] := ConverterIBM850ISOLatin[ResultString[i]];

    if ResultString = Source^ then
      begin
        (* nothing changed, return input pointer *)
        TranslateString := Source;
      end
    else
      begin
        (* we always make a copy of the memory, even when the source *)
        (* is loaded from file, not from readonly procedure code *)
        GetMem(ResultStringP, 1 + Length(ResultString));
        ResultStringP^ := ResultString;
        TranslateString := ResultStringP;
      end;
  end;

procedure SetLanguageStringPointers(const DataBegin: Pointer; const FirstPointer: ppString);
  var
    LangEnv             :String;
    choice              :word;

    lese_zeiger         :pString;
    lese_zeiger_Longint :Longint absolute lese_zeiger;

    schreib_zeiger      :ppString;

    z1,z2               :word;

    sprache             :String[2];
    sprache_untervarinte:String[2];
    anzahl_sprachen     :word;
    anzahl_elemente     :word;

  type
    {$IfDef VirtualPascal}
    pSmallWord          =^SmallWord;
    {$Else}
    pSmallWord          =^Word;
    {$EndIf}

  begin
    DetermineCountryCode;

    LangEnv := GetEnv('LANG');

    (* de_DE -> de, ko_KR -> ko *)
    sprache := Copy(LangEnv, 1, 2);
    (* de_DE -> DE, ko_KR -> KR *)
    sprache_untervarinte := Copy(LangEnv, 1 + 3, 2);

    if sprache = '' then
      case CountryCodeValue of
        049,     (* BRD *)
        041,     (* Schweiz,fr+de *)
        043:     (* ™sterreich *)
          sprache := 'DE';

        033,     (* Frankreich *)
        002:     (* Kanada fr. *)
          sprache := 'FR';

        007:
          sprache := 'RU';

        022,     (* Spanien *)
        052..055,(* Mexiko/Kuba/Argentinien/Brasilien *)
        057:     (* Kolumbien *)
          sprache := 'ES';
      else
          sprache := 'EN';
      end;

    sprache[1] := UpCase(sprache[1]);
    sprache[2] := UpCase(sprache[2]);
    sprache_untervarinte[1] := UpCase(sprache_untervarinte[1]);
    sprache_untervarinte[2] := UpCase(sprache_untervarinte[2]);

    lese_zeiger := DataBegin;
    schreib_zeiger := FirstPointer;
    
    (* skip string pinter block identier (not used) *)
    schreib_zeiger^ := nil;
    Inc(schreib_zeiger); 

    (* search header signature of strings *)
    while lese_zeiger^ <> spra2_signature do
      Inc(lese_zeiger_Longint, 1);

    Inc(lese_zeiger_Longint, 1 + Length(spra2_signature));

    (* choose matching language index *)
    anzahl_sprachen := Length(lese_zeiger^) div Length('DE');
    choice := 0; (* none *)

    (* first check language subvariant *)
    for z1:=1 to anzahl_sprachen do
      if Copy(lese_zeiger^, 2 * z1 - 1, 2) = sprache_untervarinte then
        begin
          choice := z1;
          Break;
        end;

    (* if no match was found, look for language family *)
    if choice = 0 then
      for z1 := 1 to anzahl_sprachen do
        if Copy(lese_zeiger^, 2 * z1 - 1, 2) = sprache then
          begin
            choice := z1;
            Break;
          end;

    (* if still no match was found, choose english *)
    if choice = 0 then
      for z1:=1 to anzahl_sprachen do
        if Copy(lese_zeiger^, 2 * z1 - 1, 2) = 'EN' then
          begin
            choice := z1;
            Break;
          end;

    (* last resort: choose first language *)
    if choice = 0 then
      choice := 1;

    Inc(lese_zeiger_Longint,1 + 2 * anzahl_sprachen);

    anzahl_elemente := pSmallWord(@lese_zeiger^)^;
    Inc(lese_zeiger_Longint, 2);

    (* set all pointers, skip strings that are for other languages *)
    for z1 := anzahl_elemente downto 1 do
      for z2 := 1 to anzahl_sprachen do
        begin
          if z2 = choice then
            begin
              {$IfDef Translate_IBM850_to_ISO8859_1}
              schreib_zeiger^ := TranslateString(lese_zeiger);
              {$Else}
              schreib_zeiger^ := lese_zeiger;
              {$EndIf}
              Inc(schreib_zeiger);
            end;
          Inc(lese_zeiger_Longint, 1 + Length(lese_zeiger^));
        end;

  end; (* SetLanguageStringPointers *)

procedure setze_sprachzeiger(const DataBegin: Pointer; const FirstPointer: ppString);
  begin
    SetLanguageStringPointers(DataBegin, FirstPointer);
  end;

(* using FSearch would limit searchpath to 255 chars *)
function FSearchE(const FileName: String; const EnvName: PChar): String;
  var
    FileNameA: array[0..255] of Char;
    EnvValue: PChar;
    SearchR: array[0..fsPathName] of Char;
  begin
    FSearchE := '';
    EnvValue := GetEnvVar(EnvName);
    if Assigned(EnvValue) then
      begin
        StrPCopy(FileNameA, FileName);
        SearchR[0] := #0;
        FileSearch(SearchR, FileNameA, EnvValue);
        FSearchE := StrPas(SearchR);
      end;
  end;


procedure SetLanguageStringPointersFromFile(const FileName: String;   const FirstPointer: ppString);
  var
    F                   : File;
    Error               : Integer;
    FullName            : String;
    FileInMemory        : Pointer;
    org_FileMode        : Word;
    {$IfDef LargeFileSupport}
    FileLen             : TFileSize;
    {$Else LargeFileSupport}
    FileLen             : Longint;
    {$EndIf LargeFileSupport}

  procedure TryOpenFile;
    begin

      if FullName = '' then
        begin
          Error:=2; (* not found *)
          Exit;
        end;

      Assign(F, FullName);
      {$I-}
      Reset(F, 1);
      {$I+}
      Error := IOResult;
    end;

  begin
    org_FileMode := FileMode;
    FileMode := $40; (* readonly, deny none *)

    if  (Pos('\', FileName) = 0)
    and (Pos('/', FileName) = 0) then
      begin
        FullName := ParamStr(0);
        while (FullName <> '') and not (FullName[Length(FullName)] in ['\','/']) do
          Dec(FullName[0]);

        FullName := FullName + FileName;
        TryOpenFile;

        if Error <> 0 then
          begin
            FullName := FSearchE(FileName, 'PATH');
            TryOpenFile;
          end;

        if Error <> 0 then
          begin
            FullName := FSearchE(FileName, 'DPATH');
            TryOpenFile;
          end;

      end
    else
      begin
        FullName := FileName;
        TryOpenFile;
      end;

    if Error <> 0 then
      begin
        WriteLn('"', FileName, '"?');
        RunError(Error);
      end;

    FileLen := FileSize(F);

    {$IfDef VirtualPascal}
    if FileLen > 100*1024*1024 then
    {$Else VirtualPascal}
    if FileLen >         65528 then
    {$EndIf VirtualPascal}
      RunError(8);

    {$IfDef LargeFileSupport}
    GetMem(FileInMemory, TFileSizeRec(FileLen).lo32);
    BlockRead(F, FileInMemory^, TFileSizeRec(FileLen).lo32);
    {$Else LargeFileSupport}
    GetMem(FileInMemory, FileLen);
    BlockRead(F, FileInMemory^, FileLen);
    {$EndIf LargeFileSupport}
    Close(F);

    FileMode:=org_FileMode;

    SetLanguageStringPointers(FileInMemory, FirstPointer);

  end; (* SetLanguageStringPointersFromFile *)

procedure setze_sprachzeiger_aus_datei(const FileName: String;   const FirstPointer: ppString);
  begin
    SetLanguageStringPointersFromFile(FileName, FirstPointer);
  end;

function StrFormat (const Format: String; const Args: Array of pString): String;
  var
    i, p                  : Word;
    s                     : String;
    {$IfNDef VirtualPascal}
    Result                : String;
    {$EndIf}
  begin
    Result := Format;
    for i := Low(Args) to High(Args) do
      begin
        Str(i + 1, s);
        Insert('%', s, 1);
        p := Pos(s, Result);
        if p = 0 then Continue;
        Delete(Result, p, Length(s));
        Insert(Args[i]^, Result, p);
      end;
    {$IfNDef VirtualPascal}
    StrFormat := Result;
    {$EndIf}
  end;

function StrFormat1(const Format: String; const Arg1: String): String;
  var
    a1                  :array[0..0] of pString;
  begin
    a1[0] := @Arg1;
    StrFormat1 := StrFormat(Format, a1);
  end;

function StrFormat2(const Format: String; const Arg1, Arg2: String): String;
  var
    a2                  :array[0..1] of pString;
  begin
    a2[0] := @Arg1;
    a2[1] := @Arg2;
    StrFormat2 := StrFormat(Format, a2);
  end;

function StrFormat3(const Format: String; const Arg1, Arg2, Arg3: String): String;
  var
    a3                  :array[0..2] of pString;
  begin
    a3[0] := @Arg1;
    a3[1] := @Arg2;
    a3[2] := @Arg3;
    StrFormat3 := StrFormat(Format,a3);
  end;

function StrFormat4(const Format: String; const Arg1, Arg2, Arg3, Arg4: String): String;
  var
    a4                  :array[0..3] of pString;
  begin
    a4[0] := @Arg1;
    a4[1] := @Arg2;
    a4[2] := @Arg3;
    a4[3] := @Arg4;
    StrFormat4 := StrFormat(Format, a4);
  end;

function StrFormat5(const Format: String; const Arg1, Arg2, Arg3, Arg4, Arg5: String): String;
  var
    a5                  :array[0..4] of pString;
  begin
    a5[0] := @Arg1;
    a5[1] := @Arg2;
    a5[2] := @Arg3;
    a5[3] := @Arg4;
    a5[4] := @Arg5;
    StrFormat5 := StrFormat(Format, a5);
  end;

function StrF(const l: Longint): String;
  {$IfNDef VirtualPascal}
  var
    Result              :String;
  {$EndIf}
  begin
    Str(l, Result);
    {$IfNDef VirtualPascal}
    StrF := Result
    {$EndIf}
  end;

end.

