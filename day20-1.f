      PROGRAM DAY20P1
C
      CHARACTER*10 LINE,LEFT,RIGHT
      INTEGER TILELOOKUP(3,144),NTILES,STR2BASE2F,STR2BASE2B
      INTEGER NEDGE,EDGES(8,144)
      INTEGER NROW,L1,L2,L3,L4
      INTEGER*8 TOTAL
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I4)
   40 FORMAT(4I5)
   50 FORMAT(A,I20)
C
      WRITE(*,10)"Advent of Code 2020 day 20, part 1"
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
C       WRITE(*,40)(EDGES(L1,NTILES),L1=1,8)
C       WRITE(*,*)"--------------------"
      ENDIF
      GOTO 90
  100 CONTINUE
      CLOSE(10)
C     Calculate the edge size of the square needed - square root of NTILES
      NEDGE=INT(SQRT(REAL(NTILES)))
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
C     DO L1=1,NTILES
C       WRITE(*,*)(TILELOOKUP(L2,L1),L2=1,3)
C     ENDDO
C     Locate corner tiles - these will have 2 common edges.
      TOTAL=1
      DO L1=1,NTILES
        IF (TILELOOKUP(2,L1).EQ.2) THEN
          WRITE(*,50)"A corner tile id is ",TILELOOKUP(1,L1)
          TOTAL=TOTAL*INT8(TILELOOKUP(1,L1))
        ENDIF
      ENDDO
      WRITE(*,10)" "
      WRITE(*,50)"Product of the 4 corner tile ids is",TOTAL
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
