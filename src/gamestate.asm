INCLUDE "constants.inc"

; Game state variables
SECTION "GameState", WRAM0
CurrentPieceType: db
CurrentPieceX: db
CurrentPieceY: db
CurrentPieceRotation: db
Playfield: ds PLAYFIELD_WIDTH * PLAYFIELD_HEIGHT
GravityCounter: db
MoveCounter: db
GameState: db
Score: dw
Lines: db
Level: db
JoypadState: db
JoypadPressed: db

; Export symbols
EXPORT CurrentPieceType
EXPORT CurrentPieceX
EXPORT CurrentPieceY
EXPORT CurrentPieceRotation
EXPORT Playfield
EXPORT GravityCounter
EXPORT MoveCounter
EXPORT GameState
EXPORT Score
EXPORT Lines
EXPORT Level
EXPORT JoypadState
EXPORT JoypadPressed