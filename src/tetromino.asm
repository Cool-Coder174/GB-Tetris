SECTION "TetrominoData", ROM0

; Tetromino rotation data structure
; Format: [dx, dy] x4 blocks per rotation
TETROMINO_DEFS:
; I-piece (4 rotations)
    db  0,0, 1,0, 2,0, 3,0  ; 0°
    db  0,0, 0,1, 0,2, 0,3  ; 90°
    db  0,0, 1,0, 2,0, 3,0  ; 180° (same as 0°)
    db  0,0, 0,1, 0,2, 0,3  ; 270° (same as 90°)

; O-piece (4 rotations - all same)
    db  0,0, 1,0, 0,1, 1,1  ; 0°
    db  0,0, 1,0, 0,1, 1,1  ; 90°
    db  0,0, 1,0, 0,1, 1,1  ; 180°
    db  0,0, 1,0, 0,1, 1,1  ; 270°

; T-piece (4 rotations)
    db  0,0, 1,0, 2,0, 1,1  ; 0°
    db  0,0, 0,1, 0,2, 1,1  ; 90°
    db  0,0, 1,0, 2,0, 1,1  ; 180°
    db  0,0, 0,1, 0,2, 1,1  ; 270°

; S-piece (4 rotations)
    db  0,0, 1,0, 1,1, 2,1  ; 0°
    db  0,0, 0,1, 1,1, 1,2  ; 90°
    db  0,0, 1,0, 1,1, 2,1  ; 180°
    db  0,0, 0,1, 1,1, 1,2  ; 270°

; Z-piece (4 rotations)
    db  0,0, 1,0, 1,1, 2,1  ; 0°
    db  0,0, 0,1, 1,1, 1,2  ; 90°
    db  0,0, 1,0, 1,1, 2,1  ; 180°
    db  0,0, 0,1, 1,1, 1,2  ; 270°

; J-piece (4 rotations)
    db  0,0, 1,0, 2,0, 0,1  ; 0°
    db  0,0, 0,1, 0,2, 1,2  ; 90°
    db  0,0, 1,0, 2,0, 2,1  ; 180°
    db  0,0, 0,1, 0,2, 1,0  ; 270°

; L-piece (4 rotations)
    db  0,0, 1,0, 2,0, 2,1  ; 0°
    db  0,0, 0,1, 0,2, 1,0  ; 90°
    db  0,0, 1,0, 2,0, 0,1  ; 180°
    db  0,0, 0,1, 0,2, 1,2  ; 270°

; Rotation system constants
DEF ROTATION_OFFSETS EQU 8*4 ; 4 rotations × 8 bytes (4 blocks × 2 coordinates)

SECTION "TetrominoCode", ROM0

; Export symbols
EXPORT TETROMINO_DEFS
EXPORT GetRotationData

; Function to get rotation data for a piece
; Input: A = piece type, D = rotation
; Output: HL = pointer to rotation data
GetRotationData:
    ; Calculate offset: (piece * 4 + rotation) * 8
    ld b, 0
    ld c, a
    sla c
    rl b
    sla c
    rl b
    sla c
    rl b
    add c
    ld c, a
    ld a, b
    adc 0
    ld b, a
    
    ld a, d
    sla a
    sla a
    sla a
    add c
    ld c, a
    ld a, b
    adc 0
    ld b, a
    
    ld hl, TETROMINO_DEFS
    add hl, bc
    ret