      PROGRAM DAY6P2
C
      INTEGER L1,TOTAL
      CHARACTER*80 LINE
      LOGICAL*1 YES(26),GROUPYES(26),FIRSTPERSON
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(A,I5)
C
      WRITE(*,10)"Advent of Code 2020 day 6, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day6in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      TOTAL=0
C
C     Set questions to false (no) for this person and the group
C     Mark this person as the first in the group.
C
      DO L1=1,26
        YES(L1)=.FALSE.
        GROUPYES(L1)=.FALSE.
      ENDDO
      FIRSTPERSON=.TRUE.
C
C     Groups of forms are separated by a blank line,
C     one person's data per line.
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      IF (LINE(1:1).EQ.' ') THEN
C       We're at the end of the group - count up the GROUP yes answers
C       reset all 'yes' to false, ready for the next GROUP and person
        DO L1=1,26
          IF (GROUPYES(L1)) THEN
            TOTAL=TOTAL+1
            GROUPYES(L1)=.FALSE.
          ENDIF
          YES(L1)=.FALSE.
        ENDDO
        FIRSTPERSON=.TRUE.
      ELSE
C       We're reading lines of up to 80 characters blank padded
        L1=1
        DO WHILE (LINE(L1:L1).NE.' ')
C         'a' is ASCII 97, therefore subtract 96 from each value
          IF (FIRSTPERSON) THEN
            GROUPYES(ICHAR(LINE(L1:L1))-96)=.TRUE.
          ELSE
            YES(ICHAR(LINE(L1:L1))-96)=.TRUE.
          ENDIF
          L1=L1+1
        ENDDO
C       We only need to compare the yes answers with the groups if
C       this wasn't the first person in the current group.
        IF (FIRSTPERSON) THEN
          FIRSTPERSON=.FALSE.
        ELSE
          DO L1=1,26
C           If we have an answer that isn't the same the groups
C           asnwer is always 'no'
            IF (YES(L1).NEQV.GROUPYES(L1)) GROUPYES(L1)=.FALSE.
            YES(L1)=.FALSE.
          ENDDO
        ENDIF
      ENDIF
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      WRITE(*,30)"Number of questions everyone in each group answered 'y
     +es' is",TOTAL
      END
