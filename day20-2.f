      PROGRAM DAY20P2
C
      CHARACTER*10 LINE,LEFT,RIGHT,TOP,BOTTOM
      CHARACTER*100 TILES(8,144)
      CHARACTER*1 GRID(120,120)
      INTEGER MONSTERGRID(96,96)
      INTEGER TILELOOKUP(3,144),NTILES,STR2BASE2F,STR2BASE2B
      INTEGER NEDGE,EDGES(8,144)
      INTEGER NROW,L1,L2,L3,L4,L5,TN,X,Y,TLCORNER,ROW
      INTEGER*8 TOTAL,C1,C2,C3,C4
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I4)
   40 FORMAT(4I5)
   50 FORMAT(A,I20)
   60 FORMAT(120A)
C
      WRITE(*,10)"Advent of Code 2020 day 20, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day20in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      NTILES=0
   90 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
C     Store 4 digit tile numbers in a lookup table, skips blank lines
      IF (LINE(1:4).EQ."Tile") THEN
        NTILES=NTILES+1
        READ(LINE(6:9),30) TILELOOKUP(1,NTILES)
        NROW=0
        DO WHILE (NROW.LT.10)
          NROW=NROW+1
          READ(10,FMT=20,ERR=100,END=100) LINE
C         Store this tile orientation as tile variant 1
          TILES(1,NTILES)(((NROW-1)*10)+1:((NROW-1)*10)+10)=LINE(1:10)
C         Store the 8 possible tile edges as numbers. EDGES(1,x) represents
C         the top edge of the tile as read in, EDGES(2,x) is 90deg clockwise
C         (3,x) 180deg (bottom edge), (4,x) 270 deg. EDGES (5,x) to (8,x) are
C         the flipped versions of these tiles.
          IF (NROW.EQ.1) THEN
            EDGES(1,NTILES)=STR2BASE2F(LINE)
            EDGES(5,NTILES)=STR2BASE2B(LINE)
          ENDIF
          LEFT(NROW:NROW)=LINE(1:1)
          RIGHT(NROW:NROW)=LINE(10:10)
          IF (NROW.EQ.10) THEN
            EDGES(2,NTILES)=STR2BASE2F(RIGHT)
            EDGES(6,NTILES)=STR2BASE2B(RIGHT)
            EDGES(3,NTILES)=STR2BASE2F(LINE)
            EDGES(7,NTILES)=STR2BASE2B(LINE)
            EDGES(4,NTILES)=STR2BASE2F(LEFT)
            EDGES(8,NTILES)=STR2BASE2B(LEFT)
          ENDIF
        ENDDO
C
C       Store the 7 other possible orientations for each tile. Clockwise
C       rotations first, then the flipped tile and its 3 clockwise
C       rotations.
C
        DO L1=2,4
          TILES(L1,NTILES)=TILES(L1-1,NTILES)
          CALL R90CLOCK(TILES(L1,NTILES))
        ENDDO
        TILES(5,NTILES)=TILES(1,NTILES)
        CALL FLIP(TILES(5,NTILES))
        DO L1=6,8
          TILES(L1,NTILES)=TILES(L1-1,NTILES)
          CALL R90CLOCK(TILES(L1,NTILES))
        ENDDO
      ENDIF
      GOTO 90
  100 CONTINUE
      CLOSE(10)
C     Calculate the edge size of the square needed - square root of NTILES
      NEDGE=INT(SQRT(REAL(NTILES)))
      GRID="+"
C
C     Store the number of common edges per tile. Corner tiles will have
C     2 common edges, edge tiles will have 3, centre tiles 4.
C     Do the calculation for each orientation - i.e. front (1-4) (index 2)
C     and back (5-8) (index 3) - they should match!
C
      DO L1=1,NTILES
        TILELOOKUP(2,L1)=0
        TILELOOKUP(3,L1)=0
C       Front to front
        DO L2=1,L1-1
          DO L3=1,4
            DO L4=1,4
              IF (EDGES(L3,L1).EQ.EDGES(L4,L2)) THEN
                TILELOOKUP(2,L1)=TILELOOKUP(2,L1)+1
              ENDIF
            ENDDO
          ENDDO
        ENDDO
        DO L2=L1+1,NTILES
          DO L3=1,4
            DO L4=1,4
              IF (EDGES(L3,L1).EQ.EDGES(L4,L2)) THEN
                TILELOOKUP(2,L1)=TILELOOKUP(2,L1)+1
              ENDIF
            ENDDO
          ENDDO
        ENDDO
C       Front to back
        DO L2=1,L1-1
          DO L3=1,4
            DO L4=5,8
              IF (EDGES(L3,L1).EQ.EDGES(L4,L2)) THEN
                TILELOOKUP(2,L1)=TILELOOKUP(2,L1)+1
              ENDIF
            ENDDO
          ENDDO
        ENDDO
        DO L2=L1+1,NTILES
          DO L3=1,4
            DO L4=5,8
              IF (EDGES(L3,L1).EQ.EDGES(L4,L2)) THEN
                TILELOOKUP(2,L1)=TILELOOKUP(2,L1)+1
              ENDIF
            ENDDO
          ENDDO
        ENDDO
C       Back to back
        DO L2=1,L1-1
          DO L3=5,8
            DO L4=5,8
              IF (EDGES(L3,L1).EQ.EDGES(L4,L2)) THEN
                TILELOOKUP(3,L1)=TILELOOKUP(3,L1)+1
              ENDIF
            ENDDO
          ENDDO
        ENDDO
        DO L2=L1+1,NTILES
          DO L3=5,8
            DO L4=5,8
              IF (EDGES(L3,L1).EQ.EDGES(L4,L2)) THEN
                TILELOOKUP(3,L1)=TILELOOKUP(3,L1)+1
              ENDIF
            ENDDO
          ENDDO
        ENDDO
C       Back to front
        DO L2=1,L1-1
          DO L3=5,8
            DO L4=1,4
              IF (EDGES(L3,L1).EQ.EDGES(L4,L2)) THEN
                TILELOOKUP(3,L1)=TILELOOKUP(3,L1)+1
              ENDIF
            ENDDO
          ENDDO
        ENDDO
        DO L2=L1+1,NTILES
          DO L3=5,8
            DO L4=1,4
              IF (EDGES(L3,L1).EQ.EDGES(L4,L2)) THEN
                TILELOOKUP(3,L1)=TILELOOKUP(3,L1)+1
              ENDIF
            ENDDO
          ENDDO
        ENDDO
      ENDDO
C
C     Locate the TL corner tile - this will have 2 common edges as
C     either EDGES(2,x) and (3,x) OR EDGES(6,x) and (7,x)
C
      TLFOUND=0
      L1=0
      DO WHILE (TLFOUND.NE.2)
        L1=L1+1
        TLFOUND=0
        IF (TILELOOKUP(2,L1).EQ.2) THEN
          DO L2=1,L1-1
            DO L3=1,8
              IF (EDGES(2,L1).EQ.EDGES(L3,L2)) TLFOUND=TLFOUND+1
              IF (EDGES(3,L1).EQ.EDGES(L3,L2)) TLFOUND=TLFOUND+1
            ENDDO
          ENDDO
          DO L2=L1+1,NTILES
            DO L3=1,8
              IF (EDGES(2,L1).EQ.EDGES(L3,L2)) TLFOUND=TLFOUND+1
              IF (EDGES(3,L1).EQ.EDGES(L3,L2)) TLFOUND=TLFOUND+1
            ENDDO
          ENDDO
        ENDIF
      ENDDO
      TLCORNER=L1
C
C     WRITE(*,50)"TL corner index is ",TLCORNER
C     Put this tile into the big grid at the top left (1,1)
      CALL PLACETILE(1,1,TILES,1,TLCORNER,GRID)
C     ... and mark it as placed in the TILELOOKUP array by negating
C     the tile id entry
      TILELOOKUP(1,TLCORNER)=-TILELOOKUP(1,TLCORNER)
      C1=INT8(TILELOOKUP(1,TLCORNER))
C     Now work through the remaining tiles left to right, ending
C     at tile (NEDGE,NEDGE) = NTILES. Assumes that edges are unique.
C     Top row of tiles are placed by comparing the rhs of the previous
C     tile with the lhs of the candidate tile. Match=correct tile found.
C
      DO L1=1,10
        RIGHT(L1:L1)=TILES(1,TLCORNER)(L1*10:L1*10)
      ENDDO
      DO L1=2,NEDGE
        DO L2=1,NTILES
          IF (TILELOOKUP(1,L2).GT.0) THEN
            DO L3=1,8
              DO L4=1,10
                LEFT(L4:L4)=TILES(L3,L2)((L4-1)*10+1:(L4-1)*10+1)
              ENDDO
              IF (RIGHT(1:10).EQ.LEFT(1:10)) THEN
                CALL PLACETILE(L1,1,TILES,L3,L2,GRID)
                TILELOOKUP(1,L2)=-TILELOOKUP(1,L2)
                IF (L1.EQ.NEDGE) C2=INT8(TILELOOKUP(1,L2))
                DO L5=1,10
                  RIGHT(L5:L5)=TILES(L3,L2)(L5*10:L5*10)
                ENDDO
                GOTO 200
              ENDIF
            ENDDO
          ENDIF
        ENDDO
  200 CONTINUE
      ENDDO
C
C     Now work through the rest of the grid comparing the bottom of the
C     tile above with the top rows of candidate tiles.
C       
      DO ROW=2,NEDGE
        DO L1=1,NEDGE
          DO L2=1,10
            BOTTOM(L2:L2)=GRID(L2+(L1-1)*10,(ROW-1)*10)
          ENDDO
          DO L2=1,NTILES
            IF (TILELOOKUP(1,L2).GT.0) THEN
              DO L3=1,8
                DO L4=1,10
                  TOP(L4:L4)=TILES(L3,L2)(L4:L4)
                ENDDO
                IF (BOTTOM(1:10).EQ.TOP(1:10)) THEN
                  CALL PLACETILE(L1,ROW,TILES,L3,L2,GRID)
                  TILELOOKUP(1,L2)=-TILELOOKUP(1,L2)
                  IF ((L1.EQ.1).AND.(ROW.EQ.NEDGE)) 
     +              C3=INT8(TILELOOKUP(1,L2))
                  IF ((L1.EQ.NEDGE).AND.(ROW.EQ.NEDGE))
     +              C4=INT8(TILELOOKUP(1,L2))
                  GOTO 300
                ENDIF
              ENDDO
            ENDIF
          ENDDO
  300   CONTINUE
        ENDDO
      ENDDO
C
C     DO L1=1,NEDGE*10
C       WRITE(*,60) (GRID(L2,L1),L2=1,NEDGE*10)
C     ENDDO
C
      TOTAL=C1*C2*C3*C4
      WRITE(*,50)"Part 1: Product of the 4 corner tile ids is",TOTAL
      WRITE(*,10)" "
      CALL MONSTERSETUP(GRID,MONSTERGRID)
      CALL MONSTERHUNT(MONSTERGRID,TOTAL)
      WRITE(*,10)" "
      WRITE(*,50)"Part 2: Sea monsters' water roughness is   ",TOTAL
      END
C
      SUBROUTINE MONSTERHUNT(GRID,TOTAL)
      INTEGER GRID(96,96),MGRID(96,96)
      INTEGER EGRID(9216)
      INTEGER PATTERN(20,3)
      INTEGER*8 TOTAL,TOTALHASHES,MONSTERS
      INTEGER X,Y,MATCH,XM,YM,ROTATIONS
      LOGICAL FLIPPED
   10 FORMAT(A)
   20 FORMAT(I3,A)
C
C     Equivalence is used for rotations and flips
C     ... bit lazy really, but saves rewriting / debugging the
C     tile rotation and flip routines that work on a 1d array!
      EQUIVALENCE (MGRID,EGRID)
C     This is the sea monster pattern
      DATA PATTERN /0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
     +              1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,1,
     +              0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0/
C
      MONSTERS=0
      TOTALHASHES=0
C     Count the number of hashes (1s) in the GRID
      DO Y=1,96
        DO X=1,96
          IF (GRID(X,Y).EQ.1) TOTALHASHES=TOTALHASHES+1
        ENDDO
      ENDDO
C     Start with the grid as it comes in.
      MGRID=GRID
C     Only one grid orientation has the monsters in it
      FLIPPED=.FALSE.
  500 CONTINUE
      ROTATIONS=0
      DO WHILE ((MONSTERS.EQ.0).AND.(ROTATIONS.LE.3))
        DO Y=1,94
          DO X=1,77
            MATCH=0
            DO YM=1,3
              DO XM=1,20
                IF (PATTERN(XM,YM).EQ.1) THEN
                  IF (MGRID(X+(XM-1),Y+(YM-1)).EQ.1) THEN
                    MATCH=MATCH+1
                  ENDIF
                ENDIF
              ENDDO
            ENDDO
            IF (MATCH.EQ.15) MONSTERS=MONSTERS+1
          ENDDO
        ENDDO
        IF (MONSTERS.EQ.0) THEN
          WRITE(*,10)"No sea monsters found, rotating the image"
          CALL R90CLOCKGRID(EGRID)
          ROTATIONS=ROTATIONS+1
        ENDIF
      ENDDO
C     If we've not found the monsters, flip the image and try again
      IF ((MONSTERS.EQ.0).AND.(FLIPPED.EQV..FALSE.)) THEN
        WRITE(*,10)"No sea monsters found, flipping the image"
        MGRID=GRID
        CALL FLIPGRID(EGRID)
        FLIPPED=.TRUE.
        GOTO 500
      ENDIF
C
      IF (MONSTERS.EQ.0) THEN
        WRITE(*,10)"Couldn't find any monsters :("
        STOP 8
      ENDIF
C
C     Success!!
C
      WRITE(*,20) MONSTERS," sea monsters found!"
      TOTAL=TOTALHASHES-(MONSTERS*15)
      RETURN
      END
C
      SUBROUTINE MONSTERSETUP(GRID,MONSTERGRID)
      CHARACTER*1 GRID(120,120)
      INTEGER MONSTERGRID(96,96)
      INTEGER X,Y,XMONSTER,YMONSTER
C     Remove the tile borders from GRID to get MONSTERGRID
      YMONSTER=0
      XMONSTER=0
      DO Y=1,120
        IF ((MOD(Y,10).NE.1).AND.(MOD(Y,10).NE.0)) THEN 
          YMONSTER=YMONSTER+1
          DO X=1,120
            IF ((MOD(X,10).NE.1).AND.(MOD(X,10).NE.0)) THEN 
              XMONSTER=XMONSTER+1
              IF (GRID(X,Y).EQ.'#') THEN 
                MONSTERGRID(XMONSTER,YMONSTER)=1
              ELSE
                MONSTERGRID(XMONSTER,YMONSTER)=0
              ENDIF
            ENDIF
          ENDDO
          XMONSTER=0
        ENDIF
      ENDDO
      RETURN
      END
C
      SUBROUTINE PLACETILE(X,Y,TILES,TILEORIENT,TILENO,GRID)
      INTEGER X,Y,TILEORIENT,TILENO,YPOS,XPOS,L1
      CHARACTER*100 TILES(8,144)
      CHARACTER*1 GRID(120,120)
      YPOS=(Y*10)-9
      DO L1=1,100
        XPOS=MOD(L1,10)
        IF (XPOS.EQ.0) XPOS=10
        GRID(XPOS+((X-1)*10),YPOS)=TILES(TILEORIENT,TILENO)(L1:L1)
        IF (XPOS.EQ.10) YPOS=YPOS+1
      ENDDO
      RETURN
      END
C
      INTEGER FUNCTION STR2BASE2F(STR)
      CHARACTER*10 STR
      INTEGER L1
      STR2BASE2F=0
      DO L1=1,10
        IF (STR(L1:L1).EQ.'#') STR2BASE2F=STR2BASE2F+2**(L1-1)
      ENDDO
      RETURN
      END
C
      INTEGER FUNCTION STR2BASE2B(STR)
      CHARACTER*10 STR
      INTEGER L1
      STR2BASE2B=0
      DO L1=1,10
        IF (STR(L1:L1).EQ.'#') STR2BASE2B=STR2BASE2B+2**(10-L1)
      ENDDO
      RETURN
      END
C
      SUBROUTINE FLIP(TILE)
      CHARACTER*100 TILE,OLDTILE
      INTEGER X,Y
      OLDTILE=TILE
      DO X=1,10
        DO Y=1,10
          TILE((11-X)+(Y-1)*10:(11-X)+(Y-1)*10)=
     +    OLDTILE(X+(Y-1)*10:X+(Y-1)*10)
        ENDDO
      ENDDO
      RETURN
      END
C     
      SUBROUTINE FLIPGRID(G)
      INTEGER G(9216),OLDG(9216)
      INTEGER X,Y
      OLDG=G
      DO X=1,96
        DO Y=1,96
          G((97-X)+(Y-1)*96:(97-X)+(Y-1)*96)=
     +    OLDG(X+(Y-1)*96:X+(Y-1)*96)
        ENDDO
      ENDDO
      RETURN
      END
C
      SUBROUTINE R90CLOCK(TILE)
      CHARACTER*100 TILE,OLDTILE
      INTEGER X,Y
      OLDTILE=TILE
      DO X=1,10
        DO Y=1,10
          TILE((11-Y)+(X-1)*10:(11-Y)+(X-1)*10)=
     +    OLDTILE(X+(Y-1)*10:X+(Y-1)*10)
        ENDDO
      ENDDO
      RETURN
      END
C
      SUBROUTINE R90CLOCKGRID(G)
      INTEGER G(9216),OLDG(9216)
      INTEGER X,Y
      OLDG=G
      DO X=1,96
        DO Y=1,96
          G((97-Y)+(X-1)*96:(97-Y)+(X-1)*96)=
     +    OLDG(X+(Y-1)*96:X+(Y-1)*96)
        ENDDO
      ENDDO
      RETURN
      END
