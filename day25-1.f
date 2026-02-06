      PROGRAM DAY25P1
      INTEGER*8 CARDPK,DOORPK,VALUE,DOORLOOPSIZE,CARDLOOPSIZE
      INTEGER*8 EKEY1,EKEY2
C
   10 FORMAT(A)
   20 FORMAT(I10)
   30 FORMAT(I10,A,I10)
   40 FORMAT(A,I10,A,I10)
   50 FORMAT(A,I10)
C
      WRITE(*,10)"Advent of Code 2020 day 25, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day25in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      READ(10,FMT=20) CARDPK
      READ(10,FMT=20) DOORPK
      CLOSE(10)
      WRITE(*,40)"Public keys are",CARDPK," and",DOORPK
C     Work out the loop size for the card
      CARDLOOPSIZE=0
      VALUE=1
      DO WHILE (CARDPK.NE.VALUE)
        CARDLOOPSIZE=CARDLOOPSIZE+1
        CALL TRANSFORM(INT8(7),VALUE)
      ENDDO
C     Work out the loop size for the door
      DOORLOOPSIZE=0
      VALUE=1
      DO WHILE (DOORPK.NE.VALUE)
        DOORLOOPSIZE=DOORLOOPSIZE+1
        CALL TRANSFORM(INT8(7),VALUE)
      ENDDO
C     Work out the encryption key from the cards public key and door loop size
      EKEY1=1
      DO L1=1,CARDLOOPSIZE
        CALL TRANSFORM(DOORPK,EKEY1)
      ENDDO
      EKEY2=1
      DO L1=1,DOORLOOPSIZE
        CALL TRANSFORM(CARDPK,EKEY2)
      ENDDO
      IF (EKEY1.NE.EKEY2) THEN
        WRITE(*,10)"Failure!"
        WRITE(*,30)EKEY1," is not the same as ",EKEY2
        STOP8
      ENDIF
      WRITE(*,10)" "
      WRITE(*,50)"The required encryption key is",EKEY1
      END
C
      SUBROUTINE TRANSFORM(SUBJECT,VALUE)
      INTEGER*8 SUBJECT,VALUE
C
      VALUE=VALUE*SUBJECT
      VALUE=MOD(VALUE,20201227)
      RETURN
      END
