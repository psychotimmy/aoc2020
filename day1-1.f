      PROGRAM DAY1P1
C
      INTEGER I,VALUES(200),L1,L2
C
   10 FORMAT(A)
   20 FORMAT(I4)
   30 FORMAT(A,I4,A,I4)
   40 FORMAT(A,I7)
C
      WRITE(*,10)"Advent of Code 2020 day 1, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day1in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      I=1
   50 CONTINUE
      READ(10,FMT=20,ERR=999,END=100) VALUES(I)
      I=I+1
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      DO L1=1,I-1
        DO L2=L1+1,I
          IF ((VALUES(L1)+VALUES(L2)).EQ.2020) THEN
            WRITE(*,30)
     +        "First two numbers in list that sum to 2020 are ",
     +        VALUES(L1)," and ",VALUES(L2)
            WRITE(*,40)"Giving a result of ",VALUES(L1)*VALUES(L2)
            STOP
          ENDIF
        ENDDO
      ENDDO
  999 WRITE(*,10)"Error calculating result or reading input file"
      END
