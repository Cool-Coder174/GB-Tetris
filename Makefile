ROM_NAME = gbtetris
ASM_FLAGS = 

all: $(ROM_NAME).gb

$(ROM_NAME).gb: main.o tetromino.o logic.o graphics.o random.o gamestate.o
	rgblink -n $(ROM_NAME).sym -m $(ROM_NAME).map -o $@ $^
	rgbfix -v -c -p 0 $@

main.o: src/main.asm src/gbhw.inc src/constants.inc
	rgbasm $(ASM_FLAGS) -I src -o $@ src/main.asm

tetromino.o: src/tetromino.asm src/constants.inc
	rgbasm $(ASM_FLAGS) -I src -o $@ src/tetromino.asm

logic.o: src/logic.asm src/constants.inc
	rgbasm $(ASM_FLAGS) -I src -o $@ src/logic.asm

graphics.o: src/graphics.asm src/gbhw.inc src/constants.inc
	rgbasm $(ASM_FLAGS) -I src -o $@ src/graphics.asm

random.o: src/random.asm
	rgbasm $(ASM_FLAGS) -I src -o $@ src/random.asm

gamestate.o: src/gamestate.asm src/constants.inc
	rgbasm $(ASM_FLAGS) -I src -o $@ src/gamestate.asm

clean:
	rm -f *.gb *.o *.sym *.map