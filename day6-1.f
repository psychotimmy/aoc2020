      PROGRAM DAY6P1
C
      INTEGER L1,TOTAL
      CHARACTER*80 LINE
      LOGICAL*1 YES(26)
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(A,I5)
C
      WRITE(*,10)"Advent of Code 2020 day 6, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day6in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      TOTAL=0
C
C     Set questions to false (no)
C
      DO L1=1,26
        YES(L1)=.FALSE.
      ENDDO
C
C     Groups of forms are separated by a blank line,
C     one person's data per line.
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      IF (LINE(1:1).EQ.' ') THEN
C       We're at the end of the group - count up the
C       yes answers and reset to false, ready for the next group
        DO L1=1,26
          IF (YES(L1)) THEN
            TOTAL=TOTAL+1
            YES(L1)=.FALSE.
          ENDIF
        ENDDO
      ENDIF
C     We're reading lines of up to 80 characters blank padded
      L1=1
      DO WHILE (LINE(L1:L1).NE.' ')
C       'a' is ASCII 97, therefore subtract 96 from each value
        YES(ICHAR(LINE(L1:L1))-96)=.TRUE.
        L1=L1+1
      ENDDO
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      WRITE(*,30)"Number of questions someone in each group answered 'ye
     +s' is",TOTAL
      END
