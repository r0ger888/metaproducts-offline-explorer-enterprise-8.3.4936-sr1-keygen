AboutProc	PROTO :HWND,:UINT,:WPARAM,:LPARAM;sub_401A25 		PROTO :HWND,:UINT,:WPARAM,:LPARAM
sub_401775 		PROTO
sub_4017AD 		PROTO :DWORD
sub_4017CC 		PROTO :DWORD,:DWORD
sub_401802 		PROTO
sub_4017E2 		PROTO
StartAddress 	PROTO
sub_4019C7 		PROTO

; aboutbox barely inspired from Alive_WMA_MP3_Recorder_2.6.3.6_Patch_newborn_tPORt.rar

.data

AboutText   	db "      MetaProducts Offline Explorer Enterprise",13
				db "      Version 8.3.0.4936 [ Service Release 1 ]",13,13
				db "      ****   kEYGEN.iNCL.pATCH bY r0ger   ****",13,13,13,13
				db "   Protection    : RSA-790 + Base64",13
				db "   Release date  : o7.Sep.2o22",13
				db "   Operating sys : WinALL",13
				db "   Website URL   : https://metaproducts.com/",13
				db "   Templated by  : r0ger",13,13,13,13
				db "   V2m created by Leopart",13
				db "   Scroller box by lord_Phoenix",13
				db "   Aboutbox effect by x0man .",13,13,13,13
				db "       Greetz 2 all my thugs from this list :",13,13
				db "     [Al0hA...........................reverser]",13
				db "     [B@TRyNU.........................reverser]",13
				db "     [GRUiA...........manager, reverser, coder]",13
				db "     [MaryNello.......................reverser]",13
				db "     [iSkyle.(retired)...............c++ coder]",13
				db "     [WeeGee..........................reverser]",13
				db "     [yMRAN...........................reverser]",13
				db "     [sabYn....................reverser, coder]",13
				db "     [r0ger....founder, reverser, coder, GFXer]",13
				db "     [zzLaTaNN........................reverser]",13
				db "     [ShoGunu.........................reverser]",13
				db "     [r0bica..........................reverser]",13
				db "     [DAViiiiDDDDDDD..................reverser]",13
				db "     [ShTEFY...........................manager]",13
				db "     [NoNNy.(retired).................reverser]",13
				db "     [pHane...........................reverser]",13
				db "     [PuMMy...........................reverser]",13,13
				db "       But also 2 :",13,13
				db "     [Cachito....admin, reverser, coder @ TSRh]",13
				db "     [DJ ZLO......................GFXer @ TSRh]",13
				db "     [Roentgen..........reverser, coder @ TSRh]",13
				db "     [Talers.....................tester @ TSRh]",13
				db "     [Jowy..............reverser, coder @ TSRh]",13
				db "     [Xylitol...........reverser, coder @  RED]",13
				db "     [JonArbuckle.........reverser @ Board4All]",13
				db "     [de!......................reverser @ TSRh]",13
				db "     [TeddyRogers......admin, coder @ Tuts4You]",13
				db "     [p4r4d0x..................reverser @ TSRh]",13
				db "     [kao.....................coder @ Tuts4You]",13
				db "     [fearless............coder @ MASM32 board]",13
				db "     [sama....................coder @ Tuts4You]",13
				db "     [BataBo..................coder @ Tuts4You]",13
				db "     [Dilik...................................]",13
				db "     [Intel Core 2 Extreme............reverser]",13
				db "     [kEy-tONe..........reverser, SFXer, GFXer]",13
				db "     [Vad1m..............................SFXer]",13
				db "     [Bang1338........................reverser]",13
				db "     [Log0.....................reverser, coder]",13,13
				db "             and other positive pipl  =)",13,13,13,13,13,13,13,13
				db "  special thanks to JonArbuckle for some",13
				db "  moral support about the difference between",13
				db "  the RSA scheme (in which i didn't know the",13
				db "  difference between factorization and public",13
				db "  key replacement.",13,13
				db "  shoutout 2 BataBo for recoding my two ripped",13
				db "  effects (the cube from FFF and this scroller",13
				db "  box i've used rn) in C   =)",13,13
				db "     discord : r0ger#2649",13
				db "     telegram: t.me/r0ger888",13
				db "     github  : r0gerica",13
				db "     insta   : @r0ger888",13,13
				db "  peryferiah.ro under construction . :p",0
				
				
aWnd    		dd 0                    
Globalstop		BOOL	FALSE							
Rndval    dd 0                   
AbttextLen    	dd 0                 
hMem            dd 0                 
JumpHeight    	dd 1Eh                
TextLeft    	dd 0Fh             
StartPosition    dd 0F1h               
aWidth			dd 448
aHeight			dd 238
dword_40C439    dd 0                   
                                        
dword_40C43D    dd 0                   
idc             dd 0                
hdcDest         dd 0              
ahFont    		dd 0                                                    
hBmp			dd 0      
ThreadId2        dd 0      
dword_40C455    dd 0          
AboutBoxTitle   db "about keygen",0     
AboutFont     LOGFONT <12,8,0,0,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,0,'terminal'>
TextLength     db 5Bh      
	

.code

sub_401775      proc ;near               ; CODE XREF: sub_401A25+27p
;SystemTime      = SYSTEMTIME ptr -10h
local SystemTime:SYSTEMTIME
                lea     eax, SystemTime
                push    eax            
                call    GetSystemTime
                movzx   eax, SystemTime.wHour
                imul    eax, 3Ch
                add     ax, SystemTime.wMinute
                imul    eax, 3Ch
                xor     edx, edx
                mov     dx, SystemTime.wSecond
                add     eax, edx
                imul    eax, 3E8h
                mov     dx, SystemTime.wMilliseconds
                add     eax, edx
                mov     Rndval, eax
				ret
sub_401775      endp


sub_4017AD      proc arg_0000:DWORD;near               ; CODE XREF: StartAddress+A3p
;arg_0000           = dword ptr  8
                mov     eax, arg_0000
                imul    edx, Rndval, 8088405h
                inc     edx
                mov     Rndval, edx
                mul     edx
                mov     eax, edx
				ret
sub_4017AD      endp


sub_4017CC      proc arg_000:DWORD,arg_444:DWORD
;arg_000           = dword ptr  8
;arg_444           = dword ptr  0Ch
                shr     [arg_444], 1
                shr     [arg_000], 1
                mov     eax, arg_000
                sub     arg_444, eax
                mov     eax,arg_444
				ret
sub_4017CC      endp


sub_4017E2      proc near 
                push    offset AboutText
                call    lstrlen
                mov     AbttextLen, eax
                imul    eax, 15h
                push    eax      
                push    40h  
                call    GlobalAlloc
                mov     hMem, eax
				ret
sub_4017E2      endp


sub_401802      proc
LOCAL var_88:DWORD
LOCAL var_44:DWORD
                push    TextLeft
                pop var_44
                push    StartPosition
                pop var_88
                mov     edx, hMem
                mov     ecx, offset AboutText
                xor     eax, eax
loc_401827: 
                push    eax
                mov     al, [ecx]
                mov     [edx], al
                push var_44
                pop     dword ptr [edx+1]
                push var_88
                pop     dword ptr [edx+5]
                push    dword ptr [edx+1]
                pop     dword ptr [edx+9]
                push    dword ptr [edx+5]
                pop     dword ptr [edx+0Dh]
                add var_44,8
                add     edx, 15h
                cmp     al, 0Dh
                jnz     short loc_40185C
                push    TextLeft
                pop var_44
                add var_88,0Fh
loc_40185C: 
                pop     eax
                inc     eax
                inc     ecx
                cmp     AbttextLen, eax
                ja      short loc_401827
				ret
sub_401802      endp

StartAddress    proc
LOCAL idcSrc:HDC 
LOCAL hBackground:DWORD
LOCAL var_5:DWORD
                
                invoke CreateCompatibleDC,0
                mov idcSrc,eax 
                invoke FindResource,hInstance,250,eax                 
			    invoke BitmapFromResource,eax,250
                mov hBackground,eax
	            invoke SelectObject,idcSrc,hBackground
	             
loc_401897:    
                mov var_5,0
           		invoke StretchBlt,hdcDest,0,0,aWidth,aHeight,idcSrc,0,0,aWidth,aHeight,0CC0020h
                mov     edx, hMem

loc_4018CD:  
                mov     eax, [edx+5]
                cmp     [edx+0Dh], eax
                jnz     short loc_401939
                mov     eax, [edx+1]
                mov     ecx, eax
                add     ecx, 14
                cmp     dword_40C439, eax
                jb      short loc_40193F
                cmp     dword_40C439, ecx
                ja      short loc_40193F
                mov     eax, [edx+5]
                mov     ecx, eax
                add     ecx, 1Eh
                cmp     dword_40C43D, eax
                jb      short loc_401937
                cmp     dword_40C43D, ecx
                ja      short loc_401937
                push    edx
                push    JumpHeight
                call    sub_4017AD
                pop     edx
                mov     ecx, eax
                push    edx
                push    2
                call    sub_4017AD
                pop     edx
                cmp     al, 1
                jnz     short loc_40192D
                mov     dword ptr [edx+11h], 1
                imul    ecx, -1
                jmp     short loc_401934
; ---------------------------------------------------------------------------
loc_40192D:                   
                mov     dword ptr [edx+11h], 0FFFFFFFFh
loc_401934:           
                add     [edx+5], ecx
loc_401937:  
                jmp     short loc_40193F
; ---------------------------------------------------------------------------
loc_401939: 
                mov     eax, [edx+11h]
                add     [edx+5], eax
loc_40193F:    
                push    edx
                cmp     byte ptr [edx], 0Dh
                jz      short loc_40195B
                push    1    
                lea     eax, [edx]
                push    eax  
                push    dword ptr [edx+5]
                push    dword ptr [edx+1] 
                push    hdcDest        
                call    TextOut

loc_40195B:  
                pop     edx
                movzx   ecx, TextLength
                imul    ecx, 0Fh
                imul    ecx, -1
                cmp     ecx, [edx+5]
                jnz     short loc_401975
                pusha
                call    sub_401802
                popa

loc_401975:   
                add     edx, 15h
                mov     eax, AbttextLen
                inc var_5
                cmp var_5,eax
                jb      loc_4018CD
                push    0CC0020h  
                push    0             
                push    0             
                push    hdcDest  
                push    aHeight ; height
                push    aWidth ; width  
                push    0          
                push    0           
                push    idc         
                call    BitBlt
                push    10                    
                call    Sleep
                cmp     Globalstop, 1
                jnz     loc_401897
				ret
StartAddress    endp


sub_4019C7      proc 
                mov     ecx, AbttextLen
                mov     edx, hMem
loc_4019D3: 
                mov     eax, [edx+5]
                cmp     [edx+0Dh], eax
                jnz     short loc_401A09
                push    ecx
                push    edx
                push    3
                call    sub_4017AD
                mov     ecx, eax
                push    2
                call    sub_4017AD
                pop     edx
                cmp     al, 1
                jnz     short loc_4019FE
                mov     dword ptr [edx+11h], 1
                imul    ecx, -1
                jmp     short loc_401A05
; ---------------------------------------------------------------------------
loc_4019FE: 
                mov     dword ptr [edx+11h], 0FFFFFFFFh
loc_401A05: 
                add     [edx+5], ecx
                pop     ecx
loc_401A09:    
                dec     dword ptr [edx+0Dh]
                dec     dword ptr [edx+5]
                add     edx, 15h
                loop    loc_4019D3
                push    1Eh ; scroll speed
                call    Sleep
                cmp     Globalstop, 1
                jnz     short sub_4019C7
				ret
sub_4019C7      endp


AboutProc proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
LOCAL Y:DWORD
LOCAL X:DWORD
LOCAL Aboutrect:RECT

                mov eax,uMsg
                cmp     eax, 110h ; <-- WM_INITDIALOG
                jnz     loc_401BAF
                mov     Globalstop, 0
                push hWnd
                pop     aWnd
                call    sub_401775
               invoke GetParent, hWnd
				mov ecx, eax
				invoke GetWindowRect, ecx, addr Aboutrect
				mov edi, Aboutrect.left
				mov esi, Aboutrect.top
				add edi, 0
				add esi, 0
				invoke SetWindowPos,hWnd,HWND_TOP,edi,esi,aWidth,aHeight,SWP_SHOWWINDOW
               invoke SetWindowText,hWnd,offset AboutBoxTitle
               invoke GetDC,aWnd
                mov     idc, eax
               invoke CreateCompatibleDC,0
                mov     hdcDest, eax
               invoke CreateBitmap,aWidth,aHeight,1,20h,0
                mov     hBmp, eax
                invoke CreateFontIndirect,addr AboutFont
                mov     ahFont, eax ;mov ahFont,eax
                invoke SelectObject,hdcDest,hBmp
                invoke SelectObject,hdcDest,ahFont
                invoke SetBkMode,hdcDest,1
                xor     eax, eax
                mov     ah, 0
                mov     al, 0
                rol     eax, 8
                mov     al, 0
                invoke SetTextColor,hdcDest,White
                call    sub_4017E2
                call    sub_401802
                invoke CreateThread,0,0,offset StartAddress,0,0,offset ThreadId2
                invoke CreateThread,0,0,offset sub_4019C7,0,0,offset dword_40C455
                jmp     loc_401C83
; ---------------------------------------------------------------------------
loc_401BAF:                  
                cmp uMsg,200h ; <-- WM_MOUSEMOVE
                jnz     short loc_401BD5
                mov eax,lParam;arg_C
                and     eax, 0FFFFh
                mov     dword_40C439, eax
                mov eax,lParam;arg_C
                shr     eax, 10h
                mov     dword_40C43D, eax
                jmp     loc_401C83
; ---------------------------------------------------------------------------
loc_401BD5:                            
                cmp     eax, 201h ; <-- WM_LBUTTONDOWN
                jnz     short loc_401C09
                push    0             
                push    0               
                push    10h           
                push hWnd
                call    SendMessage
                jmp     loc_401C83
; ---------------------------------------------------------------------------
loc_401C09:                           
                cmp     eax, 10h ; <-- WM_CLOSE
                jnz     loc_401C83
                mov     Globalstop, 1
                invoke Sleep,64h
                invoke ReleaseDC,aWnd,idc
                invoke DeleteObject,hdcDest
                invoke DeleteObject,ahFont
                invoke DeleteObject,hBmp
                invoke TerminateThread,ThreadId2,0
                invoke TerminateThread,ThreadId2,0
                invoke ResumeThread,BoxThread
                invoke ResumeThread,SkrThread
                invoke GlobalFree,hMem
                invoke EndDialog,aWnd,0
loc_401C83:                                                             
                xor     eax, eax
				ret
AboutProc      endp