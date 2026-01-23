      PROGRAM DAY15P1
C
      CHARACTER*40 LINE 
      INTEGER*8 SAIDNUM(2020)
      INTEGER NUM
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I2)
   40 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 15, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day15in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      READ(10,FMT=20) LINE
      CLOSE(10)
      NUM=1
      DO WHILE (INDEX(LINE,',').NE.0)
        READ(LINE(1:INDEX(LINE,',')-1),30) SAIDNUM(NUM)
        LINE=LINE(INDEX(LINE,',')+1:)
        NUM=NUM+1
      ENDDO
      READ(LINE,30)SAIDNUM(NUM)
C
C     Note that the input numbers in the samples and puzzle are all
C     unique - so these are the first n said numbers
      DO L1=NUM+1,2020
        CALL SAYNUM(SAIDNUM,L1)
      ENDDO
      WRITE(*,40)"The 2020th number to be spoken is ",SAIDNUM(2020)
      END
C
      SUBROUTINE SAYNUM(SAIDNUM,NUM)
      INTEGER*8 SAIDNUM(*),SAY
      INTEGER NUM,L1
C
      SAY=0
      DO L1=NUM-2,1,-1
        IF (SAIDNUM(NUM-1).EQ.SAIDNUM(L1)) THEN
          SAY=INT8((NUM-1)-L1)
C         Break out of the loop as we've found the last time before
C         the last number was said
          GOTO 100
        ENDIF
      ENDDO
  100 CONTINUE
      SAIDNUM(NUM)=SAY
      RETURN
      END
