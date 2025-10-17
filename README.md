# Game Boy Tetris

A Tetris game written in assembly for the Game Boy console.

## Features

- Complete Tetris gameplay with all 7 standard tetromino pieces (I, O, T, S, Z, J, L)
- Proper Game Boy hardware compatibility
- Input handling for movement and rotation
- Gravity system for piece dropping
- Collision detection
- Random piece generation using Fisher-Yates shuffle
- Game state management

## Project Structure

- `src/main.asm` - Main game loop and core functions
- `src/tetromino.asm` - Tetromino piece definitions and rotation data
- `src/logic.asm` - Game logic including collision detection
- `src/graphics.asm` - Display and graphics functions
- `src/random.asm` - Random number generation and piece bag system
- `src/gamestate.asm` - Game state variables in WRAM
- `src/gbhw.inc` - Game Boy hardware definitions
- `src/constants.inc` - Game constants and configuration

## Building

The project uses RGBDS (Rednex Game Boy Development System) for assembly and linking.

```bash
make clean
make
```

This will create `gbtetris.gb` - a 32KB Game Boy ROM file.

## Game Controls

- Left/Right: Move piece horizontally
- Down: Soft drop (move piece down faster)
- Up: Rotate piece
- The game automatically handles gravity and piece placement

## Technical Details

- Written in Z80 assembly language
- Uses proper Game Boy memory layout (ROM0, WRAM0 sections)
- Implements proper Game Boy hardware register usage
- Compatible with both original Game Boy and Game Boy Color
- Uses efficient collision detection algorithms
- Implements proper random number generation for fair piece distribution

## Compatibility

This ROM is compatible with:
- Original Game Boy (DMG)
- Game Boy Color (GBC)
- Game Boy Advance (GBA) in Game Boy mode
- Modern Game Boy emulators

The game follows Game Boy development best practices and should run on real hardware.