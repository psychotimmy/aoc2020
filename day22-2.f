      PROGRAM DAY22P2
C
      CHARACTER*16 LINE
      INTEGER CARDS(2,52),CT1,CT2,L1,TOTAL
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I2)
   40 FORMAT(A,I6)
C
      WRITE(*,10)"Advent of Code 2020 day 22, part 2"
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
      RECURSIVE SUBROUTINE COMBAT(CARDS,CT1,CT2)
      INTEGER CARDS(2,52),CT1,CT2,RCARDS(2,52),RCT1,RCT2,L1
      INTEGER HISTORY(2,3000),HT,TOTAL
C
C     Number of games in the history is 0 to start
      HT=0
      DO WHILE ((CT1.NE.0).AND.(CT2.NE.0))
        IF (((CT1-1).GE.CARDS(1,1)).AND.((CT2-1).GE.CARDS(2,1))) THEN
C         WRITE(*,*)"Recursive combat!"
C         WRITE(*,*)CT1,CARDS(1,1),CT2,CARDS(2,1)
          DO L1=1,CARDS(1,1)
            RCARDS(1,L1)=CARDS(1,L1+1)
          ENDDO
          DO L1=1,CARDS(2,1)
            RCARDS(2,L1)=CARDS(2,L1+1)
          ENDDO
          RCT1=CARDS(1,1)
          RCT2=CARDS(2,1)
          CALL COMBAT(RCARDS,RCT1,RCT2)
          IF (RCT1.EQ.0) THEN
C           Player 2 won the recursive combat game
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
C           Player 1 won the recursive combat game
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
          ENDIF
        ELSE
C         WRITE(*,*)"Normal combat!",HT,MT
C         WRITE(*,*)CT1,CARDS(1,1),CT2,CARDS(2,1)
C         Keep a track of the game history
          HT=HT+1
C         Work out the running game scores and store them
          TOTAL=0
          DO L1=1,CT1
            TOTAL=TOTAL+CARDS(1,L1)*(CT1+1-L1)
          ENDDO
          HISTORY(1,HT)=TOTAL
          TOTAL=0
          DO L1=1,CT2
            TOTAL=TOTAL+CARDS(2,L1)*(CT2+1-L1)
          ENDDO
          HISTORY(2,HT)=TOTAL
C         Have we seen a game in this state before? If so, award
C         the win to player 1 and return
          DO L1=1,HT-1
            IF ((HISTORY(1,L1).EQ.HISTORY(1,HT)).AND.
     +          (HISTORY(2,L1).EQ.HISTORY(2,HT))) THEN
              CT2=0
              CT1=1
C             WRITE(*,*)"History match - player 1 wins"
              RETURN
            ENDIF
          ENDDO
C
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
        ENDIF
      ENDDO
      RETURN
      END
