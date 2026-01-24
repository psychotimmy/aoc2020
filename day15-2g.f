      PROGRAM DAY15P2
C
      CHARACTER*40 LINE 
      INTEGER LOOKUP(0:30000000),LASTSAID
C     LOOKUP(X)= last time X said (for X=0 to 30,000,000)
      INTEGER LNUM,NUM,L1
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I2)
   40 FORMAT(A,I9)
C
      WRITE(*,10)"Advent of Code 2020 day 15, parts 1 and 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day15in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      READ(10,FMT=20) LINE
      CLOSE(10)
C     Initialise the LOOKUP array elements to -1
      DO L1=1,30000000
        LOOKUP(L1)=-1
      ENDDO
C     Get the starting numbers
      NUM=1
      DO WHILE (INDEX(LINE,',').NE.0)
        READ(LINE(1:INDEX(LINE,',')-1),30) LNUM
        LOOKUP(LNUM)=NUM
        LINE=LINE(INDEX(LINE,',')+1:)
        NUM=NUM+1
      ENDDO
      READ(LINE,30) LNUM
      LOOKUP(LNUM)=NUM
C     Note that the starting numbers in the samples and puzzle are all
C     unique - so these are the first n said numbers.
      LASTSAID=LNUM
      LNUM=0
      DO L1=NUM+1,2020
        CALL SAYNUM(LOOKUP,L1,LASTSAID)
      ENDDO
      WRITE(*,40)"The 2,020th number to be spoken is ",LASTSAID
      DO L1=2021,30000000
        CALL SAYNUM(LOOKUP,L1,LASTSAID)
      ENDDO
      WRITE(*,40)"The 30,000,000th number to be spoken is ",LASTSAID
      END
C
      SUBROUTINE SAYNUM(LOOKUP,NTHNUM,LASTSAID)
      INTEGER LOOKUP(0:30000000),NTHNUM,LASTSAID
      INTEGER SAY
C
C     There's a problem - the number is bigger than we can store!
      IF (LASTSAID.GT.30000000) STOP 8
C
      IF (LOOKUP(LASTSAID).NE.-1) THEN
C       This number has been said before so can calculate next to SAY
        SAY=(NTHNUM-1)-LOOKUP(LASTSAID)
      ELSE
C       LASTSAID is new
        SAY=0
      ENDIF
C     Update the last time we said LASTSAID ...
      LOOKUP(LASTSAID)=NTHNUM-1
C     ... and update LASTSAID
      LASTSAID=SAY
      RETURN
      END
