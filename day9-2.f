      PROGRAM DAY9P2
C
      INTEGER*8 FULL(1000),LAST25(25),NEXTVAL,LO,HI
      CHARACTER*20 LINE
      INTEGER COUNT
      LOGICAL*4 GOOD,VERIVAL
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I14)
   40 FORMAT(A,I14)
C
      WRITE(*,10)"Advent of Code 2020 day 9, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day9in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      COUNT=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      COUNT=COUNT+1
      READ(LINE,30) LAST25(COUNT)
C     Store the complete list of numbers read in FULL
      FULL(COUNT)=LAST25(COUNT)
C     If we've reached the end of the preamble stop reading values
C     from the input file for the moment
      IF (COUNT.EQ.25) GOTO 100
      GOTO 50
  100 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      READ(LINE,30) NEXTVAL
      COUNT=COUNT+1
      FULL(COUNT)=NEXTVAL
      GOOD=VERIVAL(NEXTVAL,LAST25)
      IF (GOOD) THEN 
        CALL ADDVAL(NEXTVAL,LAST25)
        GOTO 100
      ENDIF
C     Only get here if GOOD was FALSE - this is the number we need
      CLOSE(10)
      WRITE(*,40)"Part 1 answer remains ",NEXTVAL
      CALL WEAKNESS(FULL,COUNT,NEXTVAL,LO,HI)
      WRITE(*,40)
     +  "Encryption weakness is",LO+HI
      END
C
      LOGICAL FUNCTION VERIVAL(NEXTVAL,LAST25)
      INTEGER*8 NEXTVAL,LAST25(25)
C
      INTEGER L1,L2
      VERIVAL=.FALSE.
      DO L1=1,24
        DO L2=2,25
          IF ((LAST25(L1)+LAST25(L2)).EQ.NEXTVAL) THEN
            VERIVAL=.TRUE.
            GOTO 100
          ENDIF
        ENDDO
      ENDDO
  100 CONTINUE
      RETURN
      END
C
      SUBROUTINE ADDVAL(NEXTVAL,LAST25)
      INTEGER*8 NEXTVAL,LAST25(25)
C
      INTEGER L1
      DO L1=1,24
        LAST25(L1)=LAST25(L1+1)
      ENDDO
      LAST25(25)=NEXTVAL
      RETURN
      END
C
      SUBROUTINE WEAKNESS(FULL,COUNT,TARGET,LO,HI)
      INTEGER*8 FULL(1000),TARGET,XMAS,LO,HI
      INTEGER COUNT
C
      INTEGER L1,L2,LOP,HIP
C
      DO L1=1,COUNT-2
        XMAS=FULL(L1)
        LOP=L1
        DO L2=L1+1,COUNT-1
          XMAS=XMAS+FULL(L2)
          HIP=L2
C         We have the contiguous set of numbers that make the target
          IF (XMAS.EQ.TARGET) GOTO 200
C         Abandon the element at L1 if we've exceeded the target
          IF (XMAS.GT.TARGET) GOTO 100
        ENDDO
  100   CONTINUE
      ENDDO
  200 CONTINUE
C     Find the smallest (LO) and largest (HI) numbers between
C     FULL(LOP) and FULL(HIP)
      LO=FULL(LOP)
      HI=FULL(LOP)
      DO L1=LOP,HIP
        IF (FULL(L1).LT.LO) LO=FULL(L1)
        IF (FULL(L1).GT.LO) HI=FULL(L1)
      ENDDO
      RETURN
      END
