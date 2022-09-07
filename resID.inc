include		windows.inc 
include		kernel32.inc 
include		user32.inc 
include     gdi32.inc  
include 	shell32.inc
include		winmm.inc
include		masm32.inc
include		msvcrt.inc
include		comctl32.inc
include		oleaut32.inc
include		ole32.inc
include		advapi32.inc
include		comdlg32.inc
include		msimg32.inc
include     /masm32/macros/macros.asm

includelib	kernel32.lib
includelib	user32.lib 
includelib 	gdi32.lib
includelib 	shell32.lib
includelib	winmm.lib
includelib 	masm32.lib
includelib	msvcrt.lib
includelib	comctl32.lib
includelib  oleaut32.lib
includelib  ole32.lib
includelib	advapi32.lib
includelib	comdlg32.lib
includelib 	msimg32.lib

include btnt.inc
include crc32.inc

include V2M_V15.inc
includelib V2M_V15.lib

externdef c theTune:byte 

DlgProc			PROTO	:DWORD,:DWORD,:DWORD,:DWORD
Patch           PROTO 	:DWORD

.const
IDD_MAIN	equ	1000
IDD_ABOUT	equ	2000
IDB_EXIT	equ	1001
IDB_ABOUT	equ	1002
IDC_NAME	equ	1003
IDC_SERIAL	equ	1004
IDB_PATCH	equ	1005

.data
WindowTitle	db	"-=: PRF oWNZ dA wORLD ! :=-",0
r3kt			RECT	<>
TxtFont		LOGFONT <0FFFFFFF7h,0,0,0,2BCh,0,0,0,1,0,0,0,0,'verdana'>
;<12,8,0,0,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,0,'terminal'>
DELAY_VALUE			equ		6
Transparency		dd		?
TRANSPARENT_VALUE	equ 254
usrsize		dd  100h
Userbuff	db	100h dup(0)

Cpt1		db	"PERYFERiAH tEAM",0
Msg1		db	"Patch succeeded!",0
Wrongsize	db	"Wrong size.",0
Badcrc		db 	"Wrong crc checksum.",0
Filebusy	db	"You need to run this keygen as admin to patch OEE.",13
			db  "Or if the app is running in background, pls close it.",0
Notfound	db	"OE7.exe not found.",0

TargetName   db "OE7.exe",0
BackupName   db "OE7.exe.BAK",0
TargetCRC32  dd 0A837BEC2h
TargetSize   dd 24505480 

WBuffer1 	db 034h,032h
RawOffset1	dd 00997FB0h 
WBuffer2	db 034h,032h
RawOffset2	dd 00997FB3h
WBuffer3	db 039h,035h,038h,036h,032h
RawOffset3	dd 00997FB6h 
WBuffer4	db 033h,030h,036h,039h,035h
RawOffset4	dd 00997FBCh
WBuffer5	db 035h,030h,037h,036h,031h,031h,039h,032h,034h,033h,035h,036h,039h 
RawOffset5	dd 00997FC2h
WBuffer6	db 032h,036h,036h,034h,034h,035h,037h
RawOffset6	dd 00997FD0h
WBuffer7	db 039h,030h,034h,034h,030h,033h,035h,034h,034h,037h,033h,031h,031h,031h
RawOffset7	dd 00997FD8h
WBuffer8	db 034h,036h
RawOffset8	dd 00997FE7h
WBuffer9	db 033h,035h,030h,039h,035h,039h,034h,039h,034h,038h,036h,039h,039h,035h
RawOffset9	dd 00997FEAh
WBuffer10	db 034h,033h,034h,036h,035h
RawOffset10	dd 00997FF9h
WBuffer11	db 032h,035h,036h
RawOffset11	dd 00997FFFh
WBuffer12	db 030h,037h,034h,037h
RawOffset12	dd 00998003h
WBuffer13	db 032h,039h,035h,035h,036h,032h,038h
RawOffset13	dd 00998008h
WBuffer14	db 034h
RawOffset14	dd 00998010h
WBuffer15	db 030h,035h,037h,037h,030h
RawOffset15	dd 00998012h 
WBuffer16	db 037h,035h,030h,037h,034h,033h,032h,034h
RawOffset16	dd 00998018h
WBuffer17	db 036h,034h,032h
RawOffset17	dd 00998021h
WBuffer18	db 037h,039h,038h,038h,036h,033h
RawOffset18	dd 00998025h 
WBuffer19	db 036h,032h,035h
RawOffset19	dd 0099802Ch
WBuffer20	db 033h
RawOffset20	dd 00998030h
WBuffer21	db 037h,037h,036h,032h,036h
RawOffset21	dd 00998032h
WBuffer22	db 031h,036h,033h,033h,034h,036h,033h,036h,033h
RawOffset22	dd 00998038h
WBuffer23	db 033h,035h,039h,031h,033h,037h,031h,032h,030h,035h,030h
RawOffset23	dd 00998043h
WBuffer24	db 033h,034h,037h,030h,036h,036h,038h,038h,036h,035h
RawOffset24	dd 0099804Fh
WBuffer25	db 037h,038h,037h,038h,038h,032h,037h,033h,035h,037h,039h,037h,034h,034h,032h,031h
RawOffset25	dd 0099805Ah
WBuffer26	db 034h,031h,036h,035h,035h,030h,036h,039h,032h,039h
RawOffset26	dd 0099806Ah
WBuffer27	db 033h,033h,031h,038h,036h,036h,037h,031h,035h,035h
RawOffset27	dd 00998076h
WBuffer28	db 032h,033h,032h,035h,034h,035h,039h,032h,034h,030h,030h,037h,031h,038h,039h,034h
RawOffset28	dd 00998081h
WBuffer29	db 039h,035h,037h,037h,032h,037h,038h,032h,037h,032h,036h,033h,033h
RawOffset29	dd 00998091h

.data?
hInstance	dd	?
hFont			dd	?
hName			dd	?
hSerial			dd	?
hIMG			dd  ?
WndRect		RECT	<>
XndRect		RECT	<>
NameRect	RECT	<>
SerialRect	RECT	<>
hBrush		dd	?
nHeight		dd	?
nWidth		dd	?
hTarget      HINSTANCE ?
BytesWritten db  ?
