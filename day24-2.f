      PROGRAM DAY24P2
C
      CHARACTER*80 LINE
      INTEGER A0(175,175),A1(175,175),TOTAL,L1,L2,GENS
C
   10 FORMAT(A)
   20 FORMAT(A)
   40 FORMAT(A,I6)
C
      WRITE(*,10)"Advent of Code 2020 day 24, part 2"
      WRITE(*,10)" "
C
C     Use HECS to represent hexagonal grid using 2x2D arrays
C     Starting colour of all tiles is white (0)
C
      DO L1=1,175
        DO L2=1,175
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
      DO L1=1,175
        DO L2=1,175
          IF (A0(L1,L2).EQ.1) TOTAL=TOTAL+1
          IF (A1(L1,L2).EQ.1) TOTAL=TOTAL+1
        ENDDO
      ENDDO
      WRITE(*,40)"Black tile total on day   0 is",TOTAL
C     Now play a game of hexagonal life!
C     We already have day 0's configuration, therefore need 100 more
C     to get to day 100
      DO GENS=1,100
        CALL NEXTGEN(A0,A1)
      ENDDO
C     Count the black tiles
      TOTAL=0
      DO L1=2,174
        DO L2=2,174
          IF (A0(L1,L2).EQ.1) TOTAL=TOTAL+1
          IF (A1(L1,L2).EQ.1) TOTAL=TOTAL+1
        ENDDO
      ENDDO
      WRITE(*,40)"Black tile total on day 100 is",TOTAL
      END
C
      SUBROUTINE NEXTGEN(G0,G1)
      INTEGER G0(175,175),G1(175,175)
      CHARACTER*2 DIR(6)
      INTEGER OLDG0(175,175),OLDG1(175,175),L1,L2,L3,G0V,G1V
      INTEGER TILECOLOUR0,TILECOLOUR1,A,R,C
C
      DATA DIR /"w ","nw","ne","e ","se","sw"/
      OLDG0=G0
      OLDG1=G1
C
C     Assume a white border all around the grid - and that the
C     arrays are large enough to contain any/all black tiles!
C
      DO L1=2,174
        DO L2=2,174
C         Look around the current tile in each grid array and
C         see how many black tiles border it
          G0V=0
          TILECOLOUR0=OLDG0(L1,L2)
          G1V=0
          TILECOLOUR1=OLDG1(L1,L2)
          DO L3=1,6
            CALL NEIGHBOUR(DIR(L3),0,L1,L2,A,R,C)
            IF (A.EQ.0) THEN
              G0V=G0V+OLDG0(R,C)
            ELSE
              G0V=G0V+OLDG1(R,C)
            ENDIF
            CALL NEIGHBOUR(DIR(L3),1,L1,L2,A,R,C)
            IF (A.EQ.0) THEN
              G1V=G1V+OLDG0(R,C)
            ELSE
              G1V=G1V+OLDG1(R,C)
            ENDIF
          ENDDO
C         Black tile rule
          IF ((TILECOLOUR0.EQ.1).AND.((G0V.EQ.0).OR.(G0V.GT.2))) THEN
            G0(L1,L2)=0
          ENDIF
C         White tile rule
          IF ((TILECOLOUR0.EQ.0).AND.(G0V.EQ.2)) THEN
            G0(L1,L2)=1
          ENDIF
C         Black tile rule
          IF ((TILECOLOUR1.EQ.1).AND.((G1V.EQ.0).OR.(G1V.GT.2))) THEN
            G1(L1,L2)=0
          ENDIF
C         White tile rule
          IF ((TILECOLOUR1.EQ.0).AND.(G1V.EQ.2)) THEN
            G1(L1,L2)=1
          ENDIF
        ENDDO
      ENDDO    
      RETURN
      END
C
      SUBROUTINE FLIPTILES(STR,G0,G1)
      CHARACTER*80 STR
      CHARACTER*2 DIR
      INTEGER G0(175,175),G1(175,175),STRPOS
      INTEGER A0,R0,C0,A1,R1,C1
C
C     Set starting tile position in middle of HECS
C
      A0=0
      R0=88
      C0=88
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
