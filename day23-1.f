      PROGRAM DAY23P1
C
      CHARACTER*9 LINE
      CHARACTER*8 RESSTR
      INTEGER BUFFER(9),L1,L2,MOVES,CPTR,REMOVE(3),CUPLAB,DESTLAB
      INTEGER GETDEST,SPTR
C
   10 FORMAT(A)
   11 FORMAT(2A)
   20 FORMAT(A)
   30 FORMAT(I1)
   31 FORMAT(A,9I2)
   40 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 23, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day23in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      READ(10,FMT=20,ERR=100,END=100) LINE
  100 CONTINUE
      CLOSE(10)
      DO L1=1,9
        READ(LINE(L1:L1),30) BUFFER(L1)
      ENDDO
C
      CPTR=0
      DO MOVES=1,100
        CPTR=CPTR+1
        IF (CPTR.GT.9) CPTR=1
C       Store the cup label at position CPTR
        CUPLAB=BUFFER(CPTR)
C       Pick the next 3 cups after CPTR
        CALL PICK(BUFFER,CPTR,REMOVE)
C       Find the label of the destination cup
        DESTLAB=CUPLAB
        DESTLAB=GETDEST(DESTLAB,BUFFER)
        CALL INSERT(BUFFER,CPTR,CUPLAB,REMOVE,DESTLAB)
      ENDDO
      WRITE(*,31)"Final arrangement of cups is:",(BUFFER(L1),L1=1,9)
      SPTR=1
      DO WHILE (BUFFER(SPTR).NE.1)
        SPTR=SPTR+1
      ENDDO
      L1=0
      DO L2=SPTR+1,9
        L1=L1+1
        WRITE(RESSTR(L1:L1),30) BUFFER(L2)
      ENDDO
      DO L2=1,SPTR-1
        L1=L1+1
        WRITE(RESSTR(L1:L1),30) BUFFER(L2)
      ENDDO
      WRITE(*,10)" "
      WRITE(*,11)"Required answer is: ",RESSTR
      END       
C
      SUBROUTINE INSERT(BUFFER,CPTR,CUPLAB,REMOVE,DESTLAB)
      INTEGER BUFFER(9),CPTR,CUPLAB,REMOVE(3),DESTLAB
      INTEGER DPTR,TBUFFER(12),TPTR,L1,BPTR,SPTR
   10 FORMAT(A,12I2)
C
      DO L1=1,9
        IF (BUFFER(L1).EQ.DESTLAB) DPTR=L1
      ENDDO
      TPTR=0
      DO L1=1,DPTR
          TPTR=TPTR+1
          TBUFFER(TPTR)=BUFFER(L1)
      ENDDO
      DO L1=1,3
        TPTR=TPTR+1
        TBUFFER(TPTR)=REMOVE(L1)
      ENDDO
      DO L1=DPTR+1,9
          TPTR=TPTR+1
          TBUFFER(TPTR)=BUFFER(L1)
      ENDDO
      BPTR=0
C     Move 0's to the end of TBUFFER
      DO L1=1,12
        IF (TBUFFER(L1).NE.0) THEN
          BPTR=BPTR+1
          TBUFFER(BPTR)=TBUFFER(L1)
        ENDIF
      ENDDO
      DO L1=10,12
        TBUFFER(L1)=0
      ENDDO
C     Arrange BUFFER so that CPTR remains in the correct place
      DO L1=1,9
        IF (TBUFFER(L1).EQ.CUPLAB) SPTR=L1
      ENDDO
      DO L1=1,SPTR-CPTR
        TBUFFER(L1+9)=TBUFFER(L1)
        TBUFFER(L1)=0
      ENDDO
      BPTR=0
      DO L1=1,12
        IF (TBUFFER(L1).NE.0) THEN
          BPTR=BPTR+1
          BUFFER(BPTR)=TBUFFER(L1)
        ENDIF
      ENDDO
      RETURN
      END
C
      INTEGER FUNCTION GETDEST(DESTLAB,BUFFER)
      INTEGER DESTLAB,BUFFER(9),L1
C
      GETDEST=0
      DO WHILE (GETDEST.EQ.0)
C       If DEST is (still) 0 it means that the next cup was one of
C       the three removed, so try again with the next lowest number
        DESTLAB=DESTLAB-1
        IF (DESTLAB.EQ.0) DESTLAB=9
        DO L1=1,9
C         The 3 cups removed are inserted AFTER the matching CUPNO
          IF (BUFFER(L1).EQ.DESTLAB) THEN 
            GETDEST=BUFFER(L1)
C           Found the destination label - break loop and exit
            GOTO 100
          ENDIF
        ENDDO
      ENDDO
  100 CONTINUE
      RETURN
      END
C
      SUBROUTINE PICK(BUFFER,CPTR,REMOVE)
      INTEGER BUFFER(9),CPTR,REMOVE(3),L1,L2
C
      L2=CPTR
C     Pick 3 numbers from CPTR+1 to CPTR+3,
C     wrapping if CPTR is greater than 9.
      DO L1=1,3
        L2=L2+1
        IF (L2.GT.9) L2=1
        REMOVE(L1)=BUFFER(L2)
        BUFFER(L2)=0
      ENDDO
C
      RETURN
      END
