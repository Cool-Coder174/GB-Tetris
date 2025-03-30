; Tetromino rotation data structure
; Format: [dx, dy] x4 blocks per rotation
TETROMINO_DEFS:
; I-piece (4 rotations)
    db  0,0, 1,0, 2,0, 3,0  ; 0°
    db  0,0, 0,1, 0,2, 0,3  ; 90°
    db  0,0, 1,0, 2,0, 3,0  ; 180° (same as 0°)
    db  0,0, 0,1, 0,2, 0,3  ; 270° (same as 90°)
; Add other pieces following same pattern...

; Rotation system constants
ROTATION_OFFSETS equ 8*4 ; 4 rotations × 8 bytes (4 blocks × 2 coordinates)
