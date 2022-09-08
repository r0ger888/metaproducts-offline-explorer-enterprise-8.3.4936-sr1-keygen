# metaproducts-offline-explorer-enterprise-8.3.4936-sr1-keygen
This is my first time coding a clean RSA keygen - without ripping any crypto procedures with IDA. I've read [ev1l^4's old tutorial of keygenning and patching MetaProducts OEE 4.9](https://exelab.one/articles/%D1%81%D1%82%D0%B0%D1%82%D1%8C%D0%B8-%D0%BF%D0%BE-%D0%BA%D1%80%D0%B5%D0%BA%D0%B8%D0%BD%D0%B3%D1%83/303-art-460)
and i was thinking of writing one for the latest version ever released.

What i did is:

1. i've got the modulus and the private key exponent (N and D) with **RSA-tool 2 by tE!**
2. i've proceeded an RSA public key replacement in OllyDBG, starting from **00997FB0** . (mostly by RAW offset patching which was pretty easier for me to code a patch too in masm)
3. got the buffer for the name string first with **GetDlgItemText**
4. made a variable for the RSA encryption (i've named it **RSAEnk**)
5. added '7' to the beginning of algo (**mov byte ptr [RSAEnk],7**) , the app label (**OEE**), the name buffer, 01h, the license type (**10000** - which is for the unlimited site license), 01h, the custom string ( since the new version of OEE's algo has barely changed, this can be any string besides the expiration date like i said through the comment - i know it's actually a misheard lyric from the song from Peter Pan that came in my mind after watching [Stevie T's videos :)))](https://www.youtube.com/watch?v=QynJ0NKa1p4&t=412s) ) , and then concatenated all of these altogether to **RSAEnk** variable.
6. used the biglib library and initialized big numbers with _BigCreate for the **_N** (modulus), **_D** (private key exponent), **_M** (padded plaintext), and **_C** (final chipertext - or the final encrypted string).
7. set the modulus and the private exponent with **_BigIn** and then calculated the length of the **RSAEnk** variable with **lstrlen**.
8. set 256 bytes for the **_M** plaintext with **BigInBytes**.
9. did the modular arithmetic calculation with **_BigPowMod** to finalize the string encryption (derived from **RSAEnk**) for the **_C** variable (chipertext):
```
_C = _M^_D mod _N
```
10. set out the final bytes in the **RSAEnk** variable from the chipertext with **_BigOutBytes**.
11. then for the whole RSA encryption i've applied the **Base64** encoding scheme and inserted it between the **dqma** and **amqd** parts.
12. set the final serial on the serial field with **SetDlgItemText** then cleaned all the buffers with **RtlZeroMemory** and **_BigDestroy**.
