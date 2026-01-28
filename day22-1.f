      PROGRAM DAY22P1
C
      CHARACTER*16 LINE
      INTEGER CARDS(2,52),CT1,CT2,L1,TOTAL
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I2)
   40 FORMAT(A,I6)
C
      WRITE(*,10)"Advent of Code 2020 day 22, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day22in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
C     Ignore line with contents Player 1:
      READ(10,FMT=20,ERR=100,END=100) LINE
      CT1=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      IF (LINE(1:1).NE. ' ') THEN
        CT1=CT1+1
        READ(LINE,30) CARDS(1,CT1)
        GOTO 50
      ENDIF
C     Ignore line with contents Player 2:
      READ(10,FMT=20,ERR=100,END=100) LINE
      CT2=0
   60 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      IF (LINE(1:1).NE. ' ') THEN
        CT2=CT2+1
        READ(LINE,30) CARDS(2,CT2)
        GOTO 60
      ENDIF
  100 CONTINUE
      CLOSE(10)
      CALL COMBAT(CARDS,CT1,CT2)
      TOTAL=0
      IF (CT1.EQ.0) THEN
        DO L1=1,CT2
          TOTAL=TOTAL+CARDS(2,L1)*(CT2+1-L1)
        ENDDO
      ELSE
        DO L1=1,CT1
          TOTAL=TOTAL+CARDS(1,L1)*(CT1+1-L1)
        ENDDO
      ENDIF
      WRITE(*,40)"The winning player's score is",TOTAL
      END
C
      SUBROUTINE COMBAT(CARDS,CT1,CT2)
      INTEGER CARDS(2,52),CT1,CT2,L1
C
      DO WHILE ((CT1.NE.0).AND.(CT2.NE.0))
        IF (CARDS(1,1).GT.CARDS(2,1)) THEN
          CARDS(1,CT1+1)=CARDS(1,1)
          CARDS(1,CT1+2)=CARDS(2,1)
          DO L1=1,CT1+1
            CARDS(1,L1)=CARDS(1,L1+1)
          ENDDO
          DO L1=1,CT2
            CARDS(2,L1)=CARDS(2,L1+1)
          ENDDO
          CT1=CT1+1
          CT2=CT2-1
        ELSE IF (CARDS(2,1).GT.CARDS(1,1)) THEN
          CARDS(2,CT2+1)=CARDS(2,1)
          CARDS(2,CT2+2)=CARDS(1,1)
          DO L1=1,CT2+1
            CARDS(2,L1)=CARDS(2,L1+1)
          ENDDO
          DO L1=1,CT1
            CARDS(1,L1)=CARDS(1,L1+1)
          ENDDO
          CT2=CT2+1
          CT1=CT1-1
        ELSE
          WRITE(*,*)"Tie! Shouldn't happen!!"
          STOP 8
        ENDIF
      ENDDO
      RETURN
      END
