      PROGRAM DAY5P1
C
      INTEGER CALCSID,SID,HI
      CHARACTER*16 LINE
C
   10 FORMAT(A)
   20 FORMAT(A)
   40 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 5, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day5in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      HI=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      SID=CALCSID(LINE)
      IF (SID.GT.HI) HI=SID
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      WRITE(*,40)"Highest seat id is ",HI
      END
C
      INTEGER FUNCTION CALCSID(STR)
      CHARACTER*(*)STR
C     
      INTEGER ROW(7),COL(3),L1,LO,HI
      DATA ROW,COL /64,32,16,8,4,2,1,4,2,1/
C
C     Calculate the seat row and the first part of the seat id
C     LO will be the same as HI at the end of this loop
C
      LO=0
      HI=127
      DO L1=1,7
        IF (STR(L1:L1).EQ.'F') THEN
          HI=HI-ROW(L1)
        ELSE
          LO=LO+ROW(L1)
        ENDIF
      ENDDO
      CALCSID=LO*8
C
C     Calculate the seat column and the last part of the seat id
C     LO will be the same as HI at the end of this loop
C
      LO=0
      HI=7
      DO L1=8,10
        IF (STR(L1:L1).EQ.'L') THEN
          HI=HI-COL(L1-7)
        ELSE
          LO=LO+COL(L1-7)
        ENDIF
      ENDDO
      CALCSID=CALCSID+LO
C
      RETURN
      END
