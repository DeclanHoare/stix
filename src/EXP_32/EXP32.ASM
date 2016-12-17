.386P
DGROUP          group data32
.MODEL FLAT

;********************************************************************

code32          segment dword use32 public 'CODE'
		assume cs:flat, ds:flat, ss:flat, es:flat

Explode         proc near
		public Explode

leser           = dword ptr  4
schreiber       = dword ptr  8
arg_8           = dword ptr  0Ch
arg_C           = dword ptr  10h

                mov     eax, [esp+leser]
                push    ebx
                mov     ecx, [esp+4+schreiber]
                push    esi
                mov     esi, [esp+8+arg_8]
                push    edi
                mov     edx, [esp+0Ch+arg_C]
                lea     edi, [esi+1Ch]
                lea     ebx, [esi+2234h]
                mov     [esi+28h], eax
                mov     [esi+2Ch], ecx
                mov     [esi+24h], edx
                mov     dword ptr [edi], 800h
                mov     edx, [esi+24h]
                push    edx
                push    edi
                push    ebx
                call    dword ptr [esi+28h]
                add     esp, 0Ch
                mov     [esi+20h], eax
                cmp     eax, 4
                ja      short loc_407258
                mov     eax, 3
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_407258:
                xor     eax, eax
                xor     ecx, ecx
                mov     al, [ebx]
                xor     edx, edx
                mov     [esi+4], eax
                mov     cl, [esi+2235h]
                mov     [esi+0Ch], ecx
                mov     dl, [esi+2236h]
                mov     [esi+14h], edx
                mov     dword ptr [esi+18h], 0
                mov     dword ptr [edi], 3
                mov     edx, [esi+0Ch]
                cmp     edx, 4
                jb      loc_40737C
                cmp     edx, 6
                ja      loc_40737C
                mov     eax, 0FFFFh
                mov     cl, 10h
                sub     cl, dl
                sar     eax, cl
                mov     [esi+10h], eax
                mov     eax, [esi+4]
                test    eax, eax
                jz      short loc_4072DC
                cmp     eax, 1
                jz      short loc_4072BA
                mov     eax, 2
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_4072BA:
                push    100h
                lea     eax, [esi+2FB4h]
                push    offset byte_40F640
                push    eax
                call    Move
                add     esp, 0Ch
                push    esi
                call    e1
                add     esp, 4

loc_4072DC:
                lea     edi, [esi+30F4h]
                push    10h
                push    offset byte_40F620
                push    edi
                call    Move
                add     esp, 0Ch
                lea     eax, [esi+2B34h]
                push    eax
                push    offset byte_40F630
                push    edi
                push    10h
                call    e2
                add     esp, 10h
                lea     eax, [esi+3104h]
                push    10h
                push    offset byte_40F5F0
                push    eax
                call    Move
                add     esp, 0Ch
                lea     eax, [esi+3114h]
                lea     edi, [esi+30B4h]
                push    20h
                push    offset byte_40F600
                push    eax
                call    Move
                add     esp, 0Ch
                push    40h
                push    offset byte_40F570
                push    edi
                call    Move
                add     esp, 0Ch
                lea     eax, [esi+2A34h]
                push    eax
                push    offset byte_40F5B0
                push    edi
                push    40h
                call    e2
                add     esp, 10h
                push    esi
                call    e3
                add     esp, 4
                sub     eax, 306h
                cmp     eax, 1
                pop     edi
                sbb     eax, eax
                pop     esi
                and     eax, 4
                pop     ebx
                retn


loc_40737C:
                mov     eax, 1
                pop     edi
                pop     esi
                pop     ebx
                retn
Explode         endp



e3              proc near

var_8           = dword ptr -8
var_4           = dword ptr -4
arg_0           = dword ptr  4

                sub     esp, 8
                push    ebx
                push    esi
                mov     esi, [esp+10h+arg_0]
                push    edi
                push    ebp
                mov     edi, 305h
                mov     dword ptr [esi+8], 1000h
                mov     ebx, 100h

loc_4073AC:
                push    esi
                call    e4
                mov     [esp+1Ch+var_8], eax
                add     esp, 4
                cmp     eax, edi
                jnb     loc_40745C
                cmp     eax, ebx
                jnb     short loc_4073D1
                mov     ecx, [esi+8]
                mov     [ecx+esi+30h], al
                inc     dword ptr [esi+8]
                jmp     short loc_40740B


loc_4073D1:
                sub     [esp+18h+var_8], 0FEh
                mov     eax, [esp+18h+var_8]
                push    eax
                push    esi
                call    e6
                add     esp, 8
                test    eax, eax
                jz      short loc_407454
                mov     ebp, [esi+8]
                lea     edx, [ebp+esi+30h]
                mov     ecx, edx
                sub     ecx, eax
                mov     eax, [esp+18h+var_8]
                add     eax, ebp
                mov     [esi+8], eax

loc_4073FF:
                mov     al, [ecx]
                inc     ecx
                mov     [edx], al
                inc     edx
                dec     [esp+18h+var_8]
                jnz     short loc_4073FF

loc_40740B:
                cmp     dword ptr [esi+8], 2000h
                jb      short loc_4073AC
                lea     ebp, [esi+1030h]
                mov     eax, [esi+24h]
                lea     ecx, [esp+18h+var_8]
                push    eax
                mov     [esp+1Ch+var_8], 1000h
                push    ecx
                push    ebp
                call    dword ptr [esi+2Ch]
                add     esp, 0Ch
                mov     eax, [esi+8]
                sub     eax, 1000h
                lea     ecx, [esi+30h]
                push    eax
                push    ebp
                push    ecx
                call    Move
                sub     dword ptr [esi+8], 1000h
                add     esp, 0Ch
                jmp     loc_4073AC


loc_407454:
                mov     [esp+18h+var_8], 306h

loc_40745C:
                mov     eax, [esi+8]
                mov     ecx, [esi+24h]
                sub     eax, 1000h
                push    ecx
                lea     edx, [esi+1030h]
                mov     [esp+1Ch+var_4], eax
                lea     eax, [esp+1Ch+var_4]
                push    eax
                push    edx
                call    dword ptr [esi+2Ch]
                mov     eax, [esp+24h+var_8]
                add     esp, 0Ch
                pop     ebp
                pop     edi
                pop     esi
                pop     ebx
                add     esp, 8
                retn
e3              endp


e4              proc near

arg_0           = dword ptr  0Ch

                push    ebx
                push    esi
                mov     esi, [esp+arg_0]
                push    edi
                push    1
                push    esi
                test    byte ptr [esi+14h], 1
                jz      loc_40753F
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_4074B9
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_4074B9:
                mov     eax, [esi+14h]
                and     eax, 0FFh
                movzx   edi, byte ptr [eax+esi+2B34h]
                xor     eax, eax
                lea     ebx, [esi+edi]
                mov     al, [esi+edi+30F4h]
                push    eax
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_4074EC
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_4074EC:
                mov     cl, [ebx+3104h]
                test    cl, cl
                jz      short loc_407533
                mov     ebx, 1
                xor     eax, eax
                shl     ebx, cl
                dec     ebx
                mov     al, cl
                and     ebx, [esi+14h]
                push    eax
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_407526
                lea     eax, [edi+ebx]
                cmp     eax, 10Eh
                jz      short loc_407526
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_407526:
                xor     eax, eax
                mov     ax, [esi+edi*2+3114h]
                lea     edi, [eax+ebx]

loc_407533:
                add     edi, 100h

loc_407539:
                mov     eax, edi
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_40753F:
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_407554
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_407554:
                cmp     dword ptr [esi+4], 0
                jnz     short loc_40757B
                mov     edi, [esi+14h]
                push    8
                and     edi, 0FFh
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_407539
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_40757B:
                mov     ecx, [esi+14h]
                mov     eax, ecx
                and     eax, 0FFh
                jz      short loc_4075EE
                movzx   edi, byte ptr [esi+eax+2C34h]
                cmp     edi, 0FFh
                jnz     short loc_407616
                test    cl, 3Fh
                jz      short loc_4075C6
                push    4
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_4075B4
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_4075B4:
                mov     eax, [esi+14h]
                and     eax, 0FFh
                movzx   edi, byte ptr [eax+esi+2D34h]
                jmp     short loc_407616


loc_4075C6:
                push    6
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_4075DE
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_4075DE:
                mov     eax, [esi+14h]
                and     eax, 7Fh
                movzx   edi, byte ptr [eax+esi+2E34h]
                jmp     short loc_407616


loc_4075EE:
                push    8
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_407606
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_407606:
                mov     eax, [esi+14h]
                and     eax, 0FFh
                movzx   edi, byte ptr [eax+esi+2EB4h]

loc_407616:
                xor     eax, eax
                mov     al, [esi+edi+2FB4h]
                push    eax
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      loc_407539
                mov     eax, 306h
                pop     edi
                pop     esi
                pop     ebx
                retn
e4              endp


e6              proc near

arg_0           = dword ptr  8
arg_4           = dword ptr  0Ch

                push    esi
                xor     ecx, ecx
                mov     esi, [esp+arg_0]
                push    edi
                mov     eax, [esi+14h]
                and     eax, 0FFh
                movzx   edi, byte ptr [eax+esi+2A34h]
                mov     cl, [esi+edi+30B4h]
                push    ecx
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_407672
                xor     eax, eax
                pop     edi
                pop     esi
                retn


loc_407672:
                cmp     [esp+4+arg_4], 2
                jnz     short loc_407698
                shl     edi, 2
                mov     eax, [esi+14h]
                and     eax, 3
                push    2
                or      edi, eax
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_4076B8
                xor     eax, eax
                pop     edi
                pop     esi
                retn


loc_407698:
                mov     ecx, [esi+0Ch]
                mov     eax, [esi+10h]
                and     eax, [esi+14h]
                push    ecx
                shl     edi, cl
                or      edi, eax
                push    esi
                call    e5
                add     esp, 8
                test    eax, eax
                jz      short loc_4076B8
                xor     eax, eax
                pop     edi
                pop     esi
                retn


loc_4076B8:
                lea     eax, [edi+1]
                pop     edi
                pop     esi
                retn
e6              endp


e5              proc near


arg_0           = dword ptr  0Ch
arg_4           = dword ptr  10h

                push    ebx
                push    esi
                mov     esi, [esp+arg_0]
                push    edi
                mov     ebx, [esp+4+arg_4]
                mov     eax, [esi+18h]
                cmp     eax, ebx
                jb      short loc_4076E2
                mov     cl, bl
                sub     eax, ebx
                pop     edi
                mov     [esi+18h], eax
                shr     dword ptr [esi+14h], cl
                xor     eax, eax
                pop     esi
                pop     ebx
                retn


loc_4076E2:
                mov     cl, al
                lea     edi, [esi+1Ch]
                shr     dword ptr [esi+14h], cl
                mov     eax, [esi+20h]
                cmp     [edi], eax
                jnz     short loc_40771F
                mov     eax, [esi+24h]
                lea     ecx, [esi+2234h]
                push    eax
                mov     dword ptr [edi], 800h
                push    edi
                push    ecx
                call    dword ptr [esi+28h]
                add     esp, 0Ch
                mov     [esi+20h], eax
                test    eax, eax
                jnz     short loc_407719
                mov     eax, 1
                pop     edi
                pop     esi
                pop     ebx
                retn


loc_407719:
                mov     dword ptr [edi], 0

loc_40771F:
                mov     eax, [edi]
                xor     edx, edx
                mov     dl, [esi+eax+2234h]
                inc     eax
                mov     ecx, ebx
                shl     edx, 8
                mov     [edi], eax
                or      edx, [esi+14h]
                mov     eax, [esi+18h]
                sub     cl, al
                mov     [esi+14h], edx
                sub     eax, ebx
                pop     edi
                shr     edx, cl
                add     eax, 8
                mov     [esi+14h], edx
                mov     [esi+18h], eax
                xor     eax, eax
                pop     esi
                pop     ebx
                retn
e5              endp




e2              proc near

arg_0           = dword ptr  0Ch
arg_4           = dword ptr  10h
arg_8           = dword ptr  14h
arg_C           = dword ptr  18h

                push    ebx
                push    esi
                mov     ebx, [esp+arg_0]
                push    edi
                push    ebp
                dec     ebx
                js      short loc_407785
                mov     edx, [esp+8+arg_4]
                mov     esi, [esp+8+arg_8]
                mov     edi, [esp+8+arg_C]

loc_407767:
                mov     ebp, 1
                mov     cl, [edx+ebx]
                shl     ebp, cl
                xor     eax, eax
                mov     al, [esi+ebx]

loc_407776:
                mov     [edi+eax], bl
                add     eax, ebp
                cmp     eax, 100h
                jb      short loc_407776
                dec     ebx
                jns     short loc_407767

loc_407785:
                pop     ebp
                pop     edi
                pop     esi
                pop     ebx
                retn
e2              endp



e1              proc near

arg_0           = dword ptr  10h

                push    ebx
                push    esi
                push    edi
                mov     ebx, 0FFh
                push    ebp
                mov     edx, ebx
                mov     esi, offset word_40F740+1FEh
                mov     edi, [esp+4+arg_0]

loc_4077A4:
                lea     ebp, [edi+edx+2FB4h]
                mov     cl, [ebp+0]
                cmp     cl, 8
                ja      short loc_4077D4
                mov     ebp, 1
                xor     eax, eax
                shl     ebp, cl
                mov     ax, [esi]

loc_4077BF:
                mov     [edi+eax+2C34h], dl
                add     eax, ebp
                cmp     eax, 100h
                jb      short loc_4077BF
                jmp     loc_40786F


loc_4077D4:
                mov     ax, [esi]
                and     ax, bx
                jz      short loc_407846
                and     eax, 0FFFFh
                mov     [eax+edi+2C34h], bl
                test    byte ptr [esi], 3Fh
                mov     cl, [ebp+0]
                jz      short loc_40781B
                sub     cl, 4
                mov     [ebp+0], cl
                mov     ebp, 1
                shl     ebp, cl
                mov     ax, [esi]
                shr     ax, 4
                and     eax, 0FFFFh

loc_407809:
                mov     [edi+eax+2D34h], dl
                add     eax, ebp
                cmp     eax, 100h
                jb      short loc_407809
                jmp     short loc_40786F


loc_40781B:
                sub     cl, 6
                mov     [ebp+0], cl
                mov     ebp, 1
                shl     ebp, cl
                mov     ax, [esi]
                shr     ax, 6
                and     eax, 0FFFFh

loc_407834:
                mov     [edi+eax+2E34h], dl
                add     eax, ebp
                cmp     eax, 80h
                jb      short loc_407834
                jmp     short loc_40786F


loc_407846:
                sub     cl, 8
                mov     [ebp+0], cl
                mov     ebp, 1
                shl     ebp, cl
                mov     ax, [esi]
                shr     ax, 8
                and     eax, 0FFFFh

loc_40785F:
                mov     [edi+eax+2EB4h], dl
                add     eax, ebp
                cmp     eax, 100h
                jb      short loc_40785F

loc_40786F:
                sub     esi, 2
                dec     edx
                cmp     esi, offset word_40F740
                jnb     loc_4077A4
                pop     ebp
                pop     edi
                pop     esi
                pop     ebx
                retn
e1              endp



Move            proc near

arg_0           = dword ptr  4
arg_4           = dword ptr  8
arg_8           = dword ptr  0Ch

                mov     ecx, [esp+arg_4]
                push    ebx
                mov     edx, [esp+4+arg_0]
                push    esi
                mov     eax, [esp+8+arg_8]
                push    edi
                mov     esi, eax
                shr     esi, 2
                test    esi, esi
                jz      short loc_4078B5

loc_4078A8:
                mov     edi, [ecx]
                add     ecx, 4
                mov     [edx], edi
                add     edx, 4
                dec     esi
                jnz     short loc_4078A8

loc_4078B5:
                and     eax, 3
                jz      short loc_4078C3

loc_4078BA:
                mov     bl, [ecx]
                inc     ecx
                mov     [edx], bl
                inc     edx
                dec     eax
                jnz     short loc_4078BA

loc_4078C3:
                pop     edi
                pop     esi
                pop     ebx
                retn
Move            endp

code32          ends

;********************************************************************

data32          segment dword use32 public 'DATA'

byte_40F570     db 2, 2 dup(4), 4 dup(5), 0Fh dup(6), 1Ah dup(7), 10h dup(8)

byte_40F5B0     db 3, 0Dh, 5, 19h, 9, 11h, 1, 3Eh, 1Eh, 2Eh, 0Eh, 36h
                db 16h, 26h, 6, 3Ah, 1Ah, 2Ah, 0Ah, 32h, 12h, 22h, 42h
                db 2, 7Ch, 3Ch, 5Ch, 1Ch, 6Ch, 2Ch, 4Ch, 0Ch, 74h, 34h
                db 54h, 14h, 64h, 24h, 44h, 4, 78h, 38h, 58h, 18h, 68h
                db 28h, 48h, 8, 0F0h, 70h, 0B0h, 30h, 0D0h, 50h, 90h, 10h
                db 0E0h, 60h, 0A0h, 20h, 0C0h, 40h, 80h, 0

byte_40F5F0     db 8 dup(0), 1, 2, 3, 4, 5, 6, 7, 8

byte_40F600     db 2 dup(0), 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0
                db 8, 0, 0Ah, 0, 0Eh, 0, 16h, 0, 26h, 0, 46h, 0, 86h, 0
                db 6, 1

byte_40F620     db 3, 2, 2 dup(3), 3 dup(4), 4 dup(5), 3 dup(6), 2 dup(7)

byte_40F630     db 5, 3, 1, 6, 0Ah, 2, 0Ch, 14h, 4, 18h, 8, 30h, 10h, 20h
                db 40h, 0

byte_40F640     db 0Bh, 8 dup(0Ch), 8, 7, 2 dup(0Ch), 7, 0Ch dup(0Ch)
                db 0Dh, 5 dup(0Ch), 4, 0Ah, 8, 0Ch, 0Ah, 0Ch, 0Ah, 8, 2 dup(7)
                db 8, 9, 7, 6, 7, 8, 7, 6, 4 dup(7), 8, 2 dup(7), 2 dup(8)
                db 0Ch, 0Bh, 7, 9, 0Bh, 0Ch, 6, 7, 2 dup(6), 5, 7, 2 dup(8)
                db 6, 0Bh, 9, 6, 7, 2 dup(6), 7, 0Bh, 3 dup(6), 7, 9, 8
                db 2 dup(9), 0Bh, 8, 0Bh, 9, 0Ch, 8, 0Ch, 5, 3 dup(6)
                db 5, 3 dup(6), 5, 0Bh, 7, 5, 6, 2 dup(5), 6, 0Ah, 4 dup(5)
                db 8, 7, 2 dup(8), 0Ah, 2 dup(0Bh), 3 dup(0Ch), 30h dup(0Dh)
                db 30h dup(0Ch), 0Dh, 0Ch, 3 dup(0Dh), 0Ch, 3 dup(0Dh)
                db 0Ch, 4 dup(0Dh), 0Ch, 3 dup(0Dh), 3 dup(0Ch), 0Bh dup(0Dh)

word_40F740     dw 490h, 0FE0h, 7E0h, 0BE0h, 3E0h, 0DE0h, 5E0h, 9E0h, 1E0h
                dw 0B8h, 62h, 0EE0h, 6E0h, 22h, 0AE0h, 2E0h, 0CE0h, 4E0h
                dw 8E0h, 0E0h, 0F60h, 760h, 0B60h, 360h, 0D60h, 560h, 1240h
                dw 960h, 160h, 0E60h, 660h, 0A60h, 0Fh, 250h, 38h, 260h
                dw 50h, 0C60h, 390h, 0D8h, 42h, 2, 58h, 1B0h, 7Ch, 29h
                dw 3Ch, 98h, 5Ch, 9, 1Ch, 6Ch, 2Ch, 4Ch, 18h, 0Ch, 74h
                dw 0E8h, 68h, 460h, 90h, 34h, 0B0h, 710h, 860h, 31h, 54h
                dw 11h, 21h, 17h, 14h, 0A8h, 28h, 1, 310h, 130h, 3Eh, 64h
                dw 1Eh, 2Eh, 24h, 510h, 0Eh, 36h, 16h, 44h, 30h, 0C8h
                dw 1D0h, 0D0h, 110h, 48h, 610h, 150h, 60h, 88h, 0FA0h
                dw 7, 26h, 6, 3Ah, 1Bh, 1Ah, 2Ah, 0Ah, 0Bh, 210h, 4, 13h
                dw 32h, 3, 1Dh, 12h, 190h, 0Dh, 15h, 5, 19h, 8, 78h, 0F0h
                dw 70h, 290h, 410h, 10h, 7A0h, 0BA0h, 3A0h, 240h, 1C40h
                dw 0C40h, 1440h, 440h, 1840h, 840h, 1040h, 40h, 1F80h
                dw 0F80h, 1780h, 780h, 1B80h, 0B80h, 1380h, 380h, 1D80h
                dw 0D80h, 1580h, 580h, 1980h, 980h, 1180h, 180h, 1E80h
                dw 0E80h, 1680h, 680h, 1A80h, 0A80h, 1280h, 280h, 1C80h
                dw 0C80h, 1480h, 480h, 1880h, 880h, 1080h, 80h, 1F00h
                dw 0F00h, 1700h, 700h, 1B00h, 0B00h, 1300h, 0DA0h, 5A0h
                dw 9A0h, 1A0h, 0EA0h, 6A0h, 0AA0h, 2A0h, 0CA0h, 4A0h, 8A0h
                dw 0A0h, 0F20h, 720h, 0B20h, 320h, 0D20h, 520h, 920h, 120h
                dw 0E20h, 620h, 0A20h, 220h, 0C20h, 420h, 820h, 20h, 0FC0h
                dw 7C0h, 0BC0h, 3C0h, 0DC0h, 5C0h, 9C0h, 1C0h, 0EC0h, 6C0h
                dw 0AC0h, 2C0h, 0CC0h, 4C0h, 8C0h, 0C0h, 0F40h, 740h, 0B40h
                dw 340h, 300h, 0D40h, 1D00h, 0D00h, 1500h, 540h, 500h
                dw 1900h, 900h, 940h, 1100h, 100h, 1E00h, 0E00h, 140h
                dw 1600h, 600h, 1A00h, 0E40h, 640h, 0A40h, 0A00h, 1200h
                dw 200h, 1C00h, 0C00h, 1400h, 400h, 1800h, 800h, 1000h
                dw 0

data32          ends

;********************************************************************

                end
