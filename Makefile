rando: rando.obj
	golink /debug coff /entry start /o rando.exe rando.obj kernel32.dll msvcrt.dll

rando.obj: test.asm
	nasm -f win64 -g -o rando.obj test.asm

clean:
	rm rando.obj rando.exe

