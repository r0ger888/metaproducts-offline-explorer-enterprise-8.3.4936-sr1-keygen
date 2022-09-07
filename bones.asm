.686
.model	flat, stdcall
option	casemap :none

include	resID.inc
include BoxProc.asm
include textscr_mod.asm
include algo.asm
include CrazyWord.asm

AllowSingleInstance MACRO lpTitle
        invoke FindWindow,NULL,lpTitle
        cmp eax, 0
        je @F
          push eax
          invoke ShowWindow,eax,SW_RESTORE
          pop eax
          invoke SetForegroundWindow,eax
          mov eax, 0
          ret
        @@:
ENDM

patch MACRO offsetAdr,_bytes,_byteSize
 invoke SetFilePointer,hTarget,offsetAdr,NULL,FILE_BEGIN
   .if eax==0FFFFFFFFh
     invoke CloseHandle,hTarget
     invoke MessageBox,hDlg,addr Filebusy,addr Cpt1,MB_OK OR MB_ICONERROR
     ret
.endif
 invoke WriteFile,hTarget,addr _bytes,_byteSize,addr BytesWritten,FALSE
ENDM

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	InitCommonControls
	invoke LoadBitmap,hInstance,400
	mov hIMG,eax
	invoke CreatePatternBrush,eax
	mov hBrush,eax
	AllowSingleInstance addr WindowTitle
	invoke	DialogBoxParam, hInstance, IDD_MAIN, 0, offset DlgProc, 0
	invoke	ExitProcess, eax

DlgProc proc hDlg:HWND,uMessg:UINT,wParams:WPARAM,lParam:LPARAM
LOCAL X:DWORD
LOCAL Y:DWORD
LOCAL ps:PAINTSTRUCT
LOCAL ff32:WIN32_FIND_DATA
LOCAL pFileMem:DWORD

	.if [uMessg] == WM_INITDIALOG
 
		mov eax, 448
		mov nHeight, eax
		mov eax, 238
		mov nWidth, eax                
		invoke GetSystemMetrics,0                
		sub eax, nHeight
		shr eax, 1
		mov [X], eax
		invoke GetSystemMetrics,1               
		sub eax, nWidth
		shr eax, 1
		mov [Y], eax
		invoke SetWindowPos,hDlg,0,X,Y,nHeight,nWidth,40h
            	
		invoke	LoadIcon,hInstance,200
		invoke	SendMessage, hDlg, WM_SETICON, 1, eax
		invoke  SetWindowText,hDlg,addr WindowTitle
		
		invoke  V2M_V15_Init,FUNC(GetForegroundWindow),offset theTune,1000,44100,1 ; v2m initialization with current window
		invoke  V2M_V15_Play,0
		
		invoke  SkrBoxInit,hDlg
		invoke  GetUserName,offset Userbuff,offset usrsize
		invoke  SetDlgItemText,hDlg,IDC_NAME,offset Userbuff
		invoke 	SendDlgItemMessage, hDlg, IDC_NAME, EM_SETLIMITTEXT, 31, 0
		invoke  ScrollerInit,hDlg
		invoke CreateFontIndirect,addr TxtFont
		mov hFont,eax
		invoke GetDlgItem,hDlg,IDC_NAME
		mov hName,eax
		invoke SendMessage,eax,WM_SETFONT,hFont,1
		invoke GetDlgItem,hDlg,IDC_SERIAL
		mov hSerial,eax
		invoke SendMessage,eax,WM_SETFONT,hFont,1
		
		invoke ImageButton,hDlg,23,186,500,502,501,IDB_PATCH
		mov hPatch,eax
		invoke ImageButton,hDlg,164,186,600,602,601,IDB_ABOUT
		mov hAbout,eax
		invoke ImageButton,hDlg,305,186,700,702,701,IDB_EXIT
		mov hExit,eax
		
		invoke GenKey,hDlg
		
		call InitCRC32Table
		
	.elseif [uMessg] == WM_LBUTTONDOWN

		invoke SendMessage, hDlg, WM_NCLBUTTONDOWN, HTCAPTION, 0

	.elseif [uMessg] == WM_CTLCOLORDLG

		return hBrush

	.elseif [uMessg] == WM_PAINT
                
		invoke BeginPaint,hDlg,addr ps
		mov edi,eax
		lea ebx,r3kt
		assume ebx:ptr RECT
                
		invoke GetClientRect,hDlg,ebx
		invoke CreateSolidBrush,00FFB884h
		invoke FrameRect,edi,ebx,eax
		invoke EndPaint,hDlg,addr ps                   
     
    .elseif [uMessg] == WM_CTLCOLOREDIT
    
		invoke SetBkMode,wParams,TRANSPARENT
		invoke SetTextColor,wParams,White
		invoke GetWindowRect,hDlg,addr WndRect
		invoke GetDlgItem,hDlg,IDC_NAME
		invoke GetWindowRect,eax,addr NameRect
		mov edi,WndRect.left
		mov esi,NameRect.left
		sub edi,esi
		mov ebx,WndRect.top
		mov edx,NameRect.top
		sub ebx,edx
		invoke SetBrushOrgEx,wParams,edi,ebx,0
		mov eax,hBrush
		ret        
	
	.elseif [uMessg] == WM_CTLCOLORSTATIC
	
		invoke SetBkMode,wParams,TRANSPARENT
		invoke SetTextColor,wParams,White
		invoke GetWindowRect,hDlg,addr XndRect
		invoke GetDlgItem,hDlg,IDC_SERIAL
		invoke GetWindowRect,eax,addr SerialRect
		mov edi,XndRect.left
		mov esi,SerialRect.left
		sub edi,esi
		mov ebx,XndRect.top
		mov edx,SerialRect.top
		sub ebx,edx
		invoke SetBrushOrgEx,wParams,edi,ebx,0
		mov eax,hBrush
		ret
	.elseif [uMessg] == WM_COMMAND
        
		mov eax,wParams
		mov edx,eax
		shr edx,16
		and eax,0ffffh
		.if edx == EN_CHANGE
			.if eax == IDC_NAME
				invoke GenKey,hDlg
			.endif
		.endif
		.if	eax==IDB_PATCH
			invoke FindFirstFile,ADDR TargetName,ADDR ff32
	        .if eax == INVALID_HANDLE_VALUE
	           invoke MessageBox,hDlg,addr Notfound,addr Cpt1,MB_OK OR MB_ICONERROR
	        .else
	        mov eax,TargetSize
	            ; File size is incorrect
	            .if ff32.nFileSizeLow != eax
	                invoke MessageBox,hDlg,addr Wrongsize,addr Cpt1,MB_OK OR MB_ICONERROR
	            ; Filesize is correct
	            .else
	            mov pFileMem,InputFile(ADDR TargetName)
	            invoke CRC32,pFileMem,ff32.nFileSizeLow
	            mov edx,TargetCRC32
	            ; Calculated CRC32 does not match
	            .if eax != edx
	               invoke MessageBox,hDlg,addr Badcrc,addr Cpt1,MB_OK OR MB_ICONERROR
	            .else
	            invoke GetFileAttributes,addr TargetName
	            ; The file is read-only, so let's try to set it to read/write
	                .if eax!=FILE_ATTRIBUTE_NORMAL
	                    invoke SetFileAttributes,addr TargetName,FILE_ATTRIBUTE_NORMAL
	                .endif
	              ; Everything's okay, so let's patch the file
	              invoke CreateFile,addr TargetName,GENERIC_READ+GENERIC_WRITE,FILE_SHARE_READ+FILE_SHARE_WRITE,\
	                                                NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
	             .if eax!=INVALID_HANDLE_VALUE
	                    mov hTarget,eax
	            invoke CopyFile, addr TargetName, addr BackupName, TRUE
	     		   .endif
	        ; Start patches to the file
	        patch RawOffset1,WBuffer1,2
	        patch RawOffset2,WBuffer2,2
	        patch RawOffset3,WBuffer3,5
	        patch RawOffset4,WBuffer4,5
	        patch RawOffset5,WBuffer5,13
	        patch RawOffset6,WBuffer6,7
	        patch RawOffset7,WBuffer7,14
	        patch RawOffset8,WBuffer8,2
	        patch RawOffset9,WBuffer9,14
	        patch RawOffset10,WBuffer10,5
	        patch RawOffset11,WBuffer11,3
	        patch RawOffset12,WBuffer12,4
	        patch RawOffset13,WBuffer13,7
	        patch RawOffset14,WBuffer14,1
	        patch RawOffset15,WBuffer15,5
	        patch RawOffset16,WBuffer16,8
	        patch RawOffset17,WBuffer17,3
	        patch RawOffset18,WBuffer18,6
	        patch RawOffset19,WBuffer19,3
	        patch RawOffset20,WBuffer20,1
	        patch RawOffset21,WBuffer21,5
	        patch RawOffset22,WBuffer22,9
	        patch RawOffset23,WBuffer23,11
	        patch RawOffset24,WBuffer24,10
	        patch RawOffset25,WBuffer25,16
	        patch RawOffset26,WBuffer26,10
	        patch RawOffset27,WBuffer27,10
	        patch RawOffset28,WBuffer28,16
	        patch RawOffset29,WBuffer29,13
	        invoke CloseHandle,hTarget
	        invoke MessageBox,hDlg,addr Msg1,addr Cpt1,MB_OK OR MB_ICONINFORMATION
	        invoke GetDlgItem,hDlg,IDB_PATCH
	        invoke EnableWindow, eax, FALSE
	        .endif
	        .endif
	    .endif
	    .elseif eax == IDB_ABOUT
	    	invoke SuspendThread,BoxThread
	    	invoke SuspendThread,SkrThread
	    	invoke DialogBoxParam,0,IDD_ABOUT,hDlg,offset AboutProc,0
		.elseif eax == IDB_EXIT
			invoke SendMessage,hDlg,WM_CLOSE,0,0
		.endif 
             
	.elseif [uMessg] == WM_CLOSE
		invoke V2M_V15_Stop,0
		invoke V2M_V15_Close
		call CleanEf
		invoke EndDialog,hDlg,0     
	.endif
         xor eax,eax
         ret
DlgProc endp

end start