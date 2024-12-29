TARGET = hello
FILES = main

ASM = z88dk-z80asm
BIN = z88dk-appmake
BINARGS = +rom --org 0x8000 -b $(FILES).bin -o $(TARGET).com

all : build

# create the binary file
build : LINK
	$(BIN) $(BINARGS)
	$( **** info rename com file since xmodem doesn't like it! ****)

# link the object files
LINK : OBJ
	$(ASM) -b $(FILES)

# create the object files
OBJ : 
	$(ASM) $(FILES)

# delete output files
.PHONY : clean
clean : 
#	-del /Q /F *.z80, *.hex
	-del /Q /F *.o, *.hex, *.bin, *.com, *.trn
