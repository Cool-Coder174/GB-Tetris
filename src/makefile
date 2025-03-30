ROM_NAME = gbtetris
ASM_FLAGS = -h -L -Weverything

all: $(ROM_NAME).gb

$(ROM_NAME).gb: $(ROM_NAME).o
    rgblink -n $(ROM_NAME).sym -m $(ROM_NAME).map -o $@ $<
    rgbfix -v -c -p 0 $@

$(ROM_NAME).o: src/main.asm src/tetromino.asm src/logic.asm src/graphics.asm
    rgbasm $(ASM_FLAGS) -o $@ src/main.asm

clean:
  rm -f *.gb *.o *.sym *.map
