      PROGRAM DAY18P2
C
      CHARACTER*200 LINE
      INTEGER TOKENS(200),NTOKENS
      INTEGER*8 CALC,TOTAL
C
   10 FORMAT(A)
   20 FORMAT(A)
   40 FORMAT(A,I16)
C
      WRITE(*,10)"Advent of Code 2020 day 18, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day18in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      TOTAL=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
C     WRITE(*,*)LINE
      CALL TOKENISE(LINE,200,TOKENS,NTOKENS)
      TOTAL=TOTAL+CALC(TOKENS,NTOKENS)
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      WRITE(*,40)"Sum of all calculations is ",TOTAL
      END
C
      SUBROUTINE TOKENISE(STR,STRL,TOKENS,NT)
      CHARACTER*(*) STR
      INTEGER STRL,TOKENS(*),NT,L1
C     + = -100, * = -200, ( = -300, ) = -400
C     Code assumes that all tokens (including digits) are single
C     characters, space separated (if separated at all), STR space
C     padded to the end (STRL).
   10 FORMAT(200I3)
      NT=0
      DO L1=1,STRL
        IF (STR(L1:L1).NE.' ') THEN
          NT=NT+1
          IF(STR(L1:L1).EQ.'+') THEN 
            TOKENS(NT)=-100
          ELSE IF (STR(L1:L1).EQ.'*') THEN 
            TOKENS(NT)=-200
          ELSE IF (STR(L1:L1).EQ.'(') THEN
            TOKENS(NT)=-300
          ELSE IF (STR(L1:L1).EQ.')') THEN
            TOKENS(NT)=-400
          ELSE IF ((STR(L1:L1).GE.'0').AND.(STR(L1:L1).LE.'9')) THEN
            TOKENS(NT)=ICHAR(STR(L1:L1))-48
          ELSE
            WRITE(*,*)"Unrecognised token ",STR(L1:L1)
            STOP 8
          ENDIF
        ENDIF
      ENDDO
C
C     WRITE(*,10)(TOKENS(L1),L1=1,NT)
      RETURN
      END
C
      INTEGER*8 FUNCTION CALC(TOKENS,NT)
      INTEGER TOKENS(*),NT,NB
      INTEGER PTR1,PTR2,TEMP(200),L1,L2
      INTEGER*8 EVALUATE,TCALC
      CALC=0
      BC=0
C     Count the lh brackets
      NB=0
      DO L1=1,NT
        IF (TOKENS(L1).EQ.-300) NB=NB+1
      ENDDO
C
C     WRITE(*,*)">>",NB
      DO WHILE (NB.GT.0)
        PTR1=1
        DO WHILE (TOKENS(PTR1).NE.-300)
          PTR1=PTR1+1
        ENDDO
  100   CONTINUE
        PTR2=PTR1+1
        DO WHILE (TOKENS(PTR2).NE.-400)
          IF (TOKENS(PTR2).EQ.-300) THEN
C           We weren't at the inner bracketed expression, so
C           try again
            PTR1=PTR2
            GOTO 100
          ENDIF
          PTR2=PTR2+1
        ENDDO
C       WRITE(*,*)PTR1,PTR2
        L2=0
        DO L1=PTR1+1,PTR2-1
          L2=L2+1
          TEMP(L2)=TOKENS(L1)
        ENDDO
        TCALC=EVALUATE(TEMP,L2)
C       WRITE(*,*)">>",TCALC
C       Overwrite the LH bracket with the result
        TOKENS(PTR1)=TCALC
C       Substitute everything up to and including the rh bracket
C       with the 'special' token -500 (ignored by EVALUATE).
        DO L1=PTR1+1,PTR2
          TOKENS(L1)=-500
        ENDDO
C       There's now 1 fewer sets of brackets to evaluate.
        NB=NB-1
      ENDDO
C     No brackets remain - evaluate tokens left to right.
      CALC=EVALUATE(TOKENS,NT)
C     WRITE(*,*)"-->",CALC
      RETURN
      END
C
      INTEGER*8 FUNCTION EVALUATE(TOKENS,NT)
      INTEGER TOKENS(*),NT,PARTIAL,PTR1,PTR2,NA,L1
C     Evaluate the expression from left to right - odd values will
C     be numbers, even values operators (+ or *). + takes precedence
C     Count the addition symbols
      NA=0
      DO L1=2,NT,2
        IF (TOKENS(L1).EQ.-100) NA=NA+1
      ENDDO
C
C     WRITE(*,*)">>",NA
C     Process any additions first
      DO WHILE (NA.GT.0)
        PTR1=2
        DO WHILE (TOKENS(PTR1).NE.-100)
          PTR1=PTR1+2
        ENDDO
C       One fewer '+' to evaluate
        NA=NA-1
C       Find the first positive number working backwards to 1 - there
C       will always be a positive number before we get to index 0!
        L1=PTR1-1
        DO WHILE(TOKENS(L1).LT.0)
          L1=L1-1
        ENDDO
        PARTIAL=TOKENS(L1)
        PTR2=PTR1+1
  100   CONTINUE
        IF (TOKENS(PTR2).GT.0) THEN
          PARTIAL=PARTIAL+INT8(TOKENS(PTR2))
C         WRITE(*,*)"==",PARTIAL
        ELSE
          PTR2=PTR2+2 
          IF (PTR2.LE.NT) GOTO 100
        ENDIF
C       Overwrite the first number with PARTIAL
        TOKENS(L1)=PARTIAL
C       Substitute everything up to and including the number following 
C       the last '+' found with the 'special' -500 token
C       WRITE(*,*)(TOKENS(L1),L1=1,NT)
        DO L1=PTR1,PTR2
          TOKENS(L1)=-500
        ENDDO
C       WRITE(*,*)(TOKENS(L1),L1=1,NT)
      ENDDO
C
C     Process the multiplications - this is all that's left to do, so
C     just find all of the remaining positive tokens - there will always
C     be one in position 1.
      EVALUATE=INT8(TOKENS(1))
      DO L1=3,NT,2
        IF (TOKENS(L1).GT.0) THEN
          EVALUATE=EVALUATE*INT8(TOKENS(L1))
        ENDIF
C       Note that the -500 token introduced when brackets are removed
C       in CALC is always ignored by this function. The same token is
C       used in this function when an addition has been performed.
      ENDDO
C     WRITE(*,*)"...",EVALUATE
      RETURN
      END
