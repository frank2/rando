	;; for now this only works on 64-bit. nasm has a hard time expanding %if macros properly, it would seem.

   %assign rando_lfsr_seed __POSIX_TIME__
   %assign rando_lfsr_poly 15564440312192434176
   
   %macro rando_lfsr 0
	
   %assign rando_lfsr_lsb rando_lfsr_seed & 1

   %assign rando_lfsr_seed rando_lfsr_seed >> 1

   %ifn rando_lfsr_lsb = 0
      %assign rando_lfsr_seed rando_lfsr_seed ^ rando_lfsr_poly
   %endif

   %endmacro
	
   %macro rando_lfsr_next 0
   
   rando_lfsr
   %define rando_lfsr_result rando_lfsr_seed
   
   %endmacro

   %macro rando_lfsr_next 1

   rando_lfsr_next
   %assign rando_lfsr_result rando_lfsr_result % %1

   %endmacro

   ;; shamelessly stolen from Dan Kaminsky, who used a clock skew to perform the coinflip. since we don't have fractional
   ;; time available to us, we'll just use our linear feedback shift register to determine how many times the coin flips.
   %macro rando_coin_flip 0
   
   rando_lfsr_next 64
   %assign rando_lfsr_result rando_lfsr_result + 32

   %rep rando_lfsr_result
      rando_lfsr_next(2)
      %assign rando_coin_result rando_lfsr_result
   %endrep

   %endmacro
	
   %macro rando_random 0

   %assign rando_random_result 0

   %rep __BITS__
      %assign rando_random_result rando_random_result << 1
      rando_coin_flip
      %assign rando_random_result rando_random_result | rando_coin_result
   %endrep

   %endmacro

   %macro rando_random 1

   rando_random
   %assign rando_random_result rando_random_result % %1

   %endmacro
