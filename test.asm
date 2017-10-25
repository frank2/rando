   bits 64
   align 16
	
   %include "rando.asm"
	
   global start

   section .text use64

start:
   rando_random
   mov rax, rando_random_result
   rando_random 16
   mov rax, rando_random_result
   rando_random 65535
   mov rax, rando_random_result
   retn
