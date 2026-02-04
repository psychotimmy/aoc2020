      PROGRAM DAY24P1
C
      CHARACTER*80 LINE
      INTEGER A0(100,100),A1(100,100),TOTAL,L1,L2
C
   10 FORMAT(A)
   20 FORMAT(A)
   40 FORMAT(A,I6)
C
      WRITE(*,10)"Advent of Code 2020 day 24, part 1"
      WRITE(*,10)" "
C
C     Use HECS to represent hexagonal grid using 2x2D arrays
C     Starting colour of all tiles is white (0)
C
      DO L1=1,100
        DO L2=1,100
          A0(L1,L2)=0
          A1(L1,L2)=0
        ENDDO
      ENDDO
      OPEN(10,FILE="day24in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      CALL FLIPTILES(LINE,A0,A1)
      GOTO 50
  100 CONTINUE
      CLOSE(10)
C     Count the black tiles
      TOTAL=0
      DO L1=1,100
        DO L2=1,100
          IF (A0(L1,L2).EQ.1) TOTAL=TOTAL+1
          IF (A1(L1,L2).EQ.1) TOTAL=TOTAL+1
        ENDDO
      ENDDO
      WRITE(*,40)"Black tile total is ",TOTAL
      END
C
      SUBROUTINE FLIPTILES(STR,G0,G1)
      CHARACTER*80 STR
      CHARACTER*2 DIR
      INTEGER G0(100,100),G1(100,100),STRPOS
      INTEGER A0,R0,C0,A1,R1,C1
C
C     Set starting tile position in middle of HECS
C
      A0=0
      R0=50
      C0=50
C
C     WRITE(*,*)">>Processing ",STR
C
      STRPOS=1
      DIR(1:1)=STR(STRPOS:STRPOS)
      DO WHILE (STR(STRPOS:STRPOS).NE.' ')
        IF ((DIR(1:1).EQ.'n').OR.(DIR(1:1).EQ.'s')) THEN
          STRPOS=STRPOS+1
          DIR(2:2)=STR(STRPOS:STRPOS)
        ENDIF
        CALL NEIGHBOUR(DIR,A0,R0,C0,A1,R1,C1)
C       Process next direction
        A0=A1
        R0=R1
        C0=C1
        STRPOS=STRPOS+1
        DIR(1:1)=STR(STRPOS:STRPOS)
        DIR(2:2)=" "
      ENDDO
C     Update HECS grid with the final tile found
      IF (A1.EQ.0) THEN
        G0(R1,C1)=1-G0(R1,C1)
      ELSE
        G1(R1,C1)=1-G1(R1,C1)
      ENDIF
C
      RETURN
      END
C
      SUBROUTINE NEIGHBOUR(STR,A0,R0,C0,A1,R1,C1)
      CHARACTER*2 STR
      INTEGER A0,R0,C0,A1,R1,C1
C
C     Returns the nearest neighbouring tile of A0,R0,C0 
C     for direction STR in A1,R1,C1
C
      IF (STR(1:1).EQ.'w') THEN
        A1=A0
        R1=R0
        C1=C0-1
      ELSE IF (STR(1:1).EQ.'e') THEN
        A1=A0
        R1=R0
        C1=C0+1
      ELSE IF (STR(1:2).EQ.'ne') THEN
        A1=1-A0
        R1=R0-(1-A0)
        C1=C0+A0
      ELSE IF (STR(1:2).EQ.'se') THEN
        A1=1-A0
        R1=R0+A0
        C1=C0+A0
      ELSE IF (STR(1:2).EQ.'sw') THEN
        A1=1-A0
        R1=R0+A0
        C1=C0-(1-A0)
      ELSE IF (STR(1:2).EQ.'nw') THEN
        A1=1-A0
        R1=R0-(1-A0)
        C1=C0-(1-A0)
      ELSE
        WRITE(*,*)"Illegal direction ",STR(1:2)," !!"
        STOP 8
      ENDIF
      RETURN
      END
