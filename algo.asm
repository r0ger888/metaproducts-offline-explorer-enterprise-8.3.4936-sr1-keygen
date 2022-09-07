
include biglib.inc
includelib biglib.lib

include base64.asm

GenKey		PROTO	:DWORD

.data
ExpN db "29523A2568E5B57AD4B6C405F97F847B1FEF5AC667EC2585D185D018AE43673A7"
		db "72F48D2EB9B903819FEEC2CEC8E3CBBBE5640277EB1824FC1E44FADE81B0C851C"
		db "1F558B86C1033395E7857C51003D86C1F9AAFE4AF52E3F1A7C4E707E479E8956B"
		db "479",0
ExpD db "AFDD57BC8087A9ADEE4730647D4F4CFAFB202CA8E3051D6E3E21D75C33D28C373"
		db "9ABF5B63D2F0AD0BB534EBCA4D17B8B5284C9942FDFD435C05DDD68177508C4C0"
		db "14BCC19E53245EC4AC34006492FE519BE2DDC2B28CC16DD860DA4042BC18C3405"
		db "C5",0

AppLabel	db "OEE",0
OneByte		db 01h,0 ; if i put 1 directly in this variable, then in OEE it'll show the license type behind the name buffer.
					 ; i just did what ev1l^4 [tPORt] did with these variables. :p
LicType		db "10000",0
StartKey	db "dqma",0
EndKey		db "amqd",0
CustomStr	db "ThinkOfBatmanPoopinSnakes",0 ; can be any custom string after the strings shows in GenKey procedure,
								 ; doesn't have to be the expiration date as ev1l^4 did on the old OEE
NoName		db "insert ur name.",0
TooLong		db "name too long.",0
FinalBuffer db 256 dup(0)
NameBuffer	db 256 dup(0)

.data?
_N			dd ?
_D			dd ?
_C			dd ?
_M  		dd ?
RSAEnk		db 256 dup(?)
Base64Bfr	db 256 dup(?)

.code
GenKey proc hWin:DWORD

	; get the whole name string.
	invoke GetDlgItemText,hWin,IDC_NAME,offset NameBuffer,sizeof NameBuffer
	.if eax == 0
		invoke SetDlgItemText,hWin,IDC_SERIAL,offset NoName
	.elseif eax > 30
		invoke SetDlgItemText,hWin,IDC_SERIAL,offset TooLong
	.elseif
		; initialize the string for RSA-790 decryption
		mov byte ptr [RSAEnk],7
		invoke lstrcat,offset RSAEnk,offset AppLabel	; OEE
		invoke lstrcat,offset RSAEnk,offset OneByte		; 01h
		invoke lstrcat,offset RSAEnk,offset NameBuffer	; ur name
		invoke lstrcat,offset RSAEnk,offset OneByte		; 01h
		invoke lstrcat,offset RSAEnk,offset LicType		; 10000 (Unlimited site license)
		invoke lstrcat,offset RSAEnk,offset OneByte		; 01h
		invoke lstrcat,offset RSAEnk,offset CustomStr	; any string :p
		
		; initialize biglib for modulus and the private key exponent, and for the plaintext and chipertext.
		invoke _BigCreate,0
		mov _N,eax
		invoke _BigCreate,0
		mov _D,eax
		invoke _BigCreate,0
		mov _C,eax
		invoke _BigCreate,0
		mov _M,eax
		
		; set exponents with _BigIn
		invoke _BigIn,offset ExpN,16,_N
		invoke _BigIn,offset ExpD,16,_D
		invoke lstrlen,offset RSAEnk
		
		; set the bytes for the padded plaintext
		invoke _BigInBytes,offset RSAEnk,eax,256,_M
		
		; _C = _M^_D mod _N
		invoke _BigPowMod,_M,_D,_N,_C
		
		; set RSA-790 bytes for the RSA buffer
		invoke _BigOutBytes,_C,256,offset RSAEnk
		
		; encode them with base64
		push offset Base64Bfr
		push eax
		push offset RSAEnk
		call Base64Enk
		
		; "dqma" + final string made of RSA-790 & Base64 + "amqd"
		invoke lstrcat,offset FinalBuffer,offset StartKey
		invoke lstrcat,offset FinalBuffer,offset Base64Bfr
		invoke lstrcat,offset FinalBuffer,offset EndKey
		
		; final result in the textbox :p
		invoke SetDlgItemText,hWin,IDC_SERIAL,offset FinalBuffer
		
		; clear RSA buffers.
		call Clean
		
	.endif
	ret
	
GenKey endp

Clean proc

	invoke RtlZeroMemory,offset FinalBuffer,sizeof FinalBuffer
	invoke RtlZeroMemory,offset RSAEnk,sizeof RSAEnk
	invoke RtlZeroMemory,offset Base64Bfr,sizeof Base64Bfr
	invoke RtlZeroMemory,offset NameBuffer,sizeof NameBuffer
	invoke _BigDestroy,_N
	invoke _BigDestroy,_D
	invoke _BigDestroy,_C
	invoke _BigDestroy,_M
	ret
	
Clean endp