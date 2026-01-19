      PROGRAM DAY2P1
C
      INTEGER HI,LO,L1,TIMES,TOTAL
      CHARACTER*80 LINE,TEMP
      CHARACTER*1 MUST
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I3)
   40 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 2, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day2in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      TOTAL=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
C     Line format is: LO-HI MUST: PASSWORD
C     Get the LO value
      TEMP=LINE(1:INDEX(LINE,'-')-1)
      LINE=LINE(INDEX(LINE,'-')+1:)
      READ(TEMP,30)LO
C     Get the HI value
      TEMP=LINE(1:INDEX(LINE,' ')-1)
      LINE=LINE(INDEX(LINE,' ')+1:)
      READ(TEMP,30)HI
C     Get the MUST value
      MUST=LINE(1:1)
      LINE=LINE(4:)
C     See how many times MUST is in the remainder of LINE
      L1=1
      TIMES=0
      DO WHILE (LINE(L1:L1).NE.' ')
        IF (LINE(L1:L1).EQ.MUST) TIMES=TIMES+1
        L1=L1+1
      ENDDO
C     Password is valid if MUST occurs between LO and HI times
      IF ((TIMES.GE.LO).AND.(TIMES.LE.HI)) TOTAL=TOTAL+1
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      WRITE(*,40)"Number of valid passwords is ",TOTAL
      END
