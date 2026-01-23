      PROGRAM DAY15P2
C
      CHARACTER*40 LINE 
      INTEGER LOOKUPLOW(0:30000000),LASTSAID
C     LOOKUPLOW(X)= last time X said (for X=0 to 30,000,000)
      INTEGER LNUML,LNUM,NUM,L1
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I2)
   35 FORMAT(I9,A,I9,A,I18)
   40 FORMAT(A,I18)
C
      WRITE(*,10)"Advent of Code 2020 day 15, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day15in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      READ(10,FMT=20) LINE
      CLOSE(10)
      DO L1=1,30000000
        LOOKUPLOW(L1)=-1
      ENDDO
      NUM=1
      DO WHILE (INDEX(LINE,',').NE.0)
        READ(LINE(1:INDEX(LINE,',')-1),30) LNUML
        LOOKUPLOW(LNUML)=NUM
        LINE=LINE(INDEX(LINE,',')+1:)
        NUM=NUM+1
      ENDDO
      READ(LINE,30) LNUML
      LOOKUPLOW(LNUML)=NUM
C
C     Note that the input numbers in the samples and puzzle are all
C     unique - so these are the first n said numbers. LNUM is the number
C     of entries used in the LOOKUP array, LNUML is used for low numbers
C     kept in LOOKUPLOW. All starting numbers go into LOOKUPLOW.
C
      LASTSAID=LNUML
      LNUM=0
      DO L1=NUM+1,30000000
        CALL SAYNUM(LOOKUPLOW,LOOKUP,LNUM,L1,LASTSAID)
      ENDDO
      WRITE(*,40)"The 30,000,000th number to be spoken is "
     +           ,LASTSAID
      END
C
      SUBROUTINE SAYNUM(LOOKUPLOW,LOOKUP,LNUM,NTHNUM,LASTSAID)
      INTEGER SAY,LASTSAID,LOOKUPLOW(0:30000000)
      INTEGER LNUM,NTHNUM,L1
C
      IF (LASTSAID.LE.30000000) THEN
        IF (LOOKUPLOW(LASTSAID).NE.-1) THEN
C           This number has been said before
            SAY=(NTHNUM-1)-LOOKUPLOW(LASTSAID)
            LOOKUPLOW(LASTSAID)=NTHNUM-1
C           Break out of the loop
            GOTO 100
        ENDIF
      ELSE
C       There's a problem - the number is bigger than we can store!
        STOP 8
      ENDIF
C     Can only get here if LASTSAID is new
      IF (LASTSAID.LT.30000000) THEN
        LOOKUPLOW(LASTSAID)=NTHNUM-1
      ELSE
C       There's a problem - the number is bigger than we can store!
        STOP 8
      ENDIF
      SAY=0
  100 CONTINUE
      LASTSAID=SAY
C
      RETURN
      END
