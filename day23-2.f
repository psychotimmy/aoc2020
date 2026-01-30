      PROGRAM DAY23P2
C
      CHARACTER*9 LINE
      INTEGER BUFFER(1000000),L1,L2,MOVES,CPTR,REMOVE(3),CUPLAB,DESTLAB
      INTEGER GETDEST,SPTR
      INTEGER*8 TOTAL
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I1)
   40 FORMAT(A,I20)
   45 FORMAT(A,I10)
C
      WRITE(*,10)"Advent of Code 2020 day 23, part 2"
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
      DO L1=10,1000000
        BUFFER(L1)=L1
      ENDDO
C
      CPTR=0
      DO MOVES=1,10000000
        CPTR=CPTR+1
        IF (CPTR.GT.1000000) CPTR=1
C       Store the cup label at position CPTR
        CUPLAB=BUFFER(CPTR)
C       Pick the next 3 cups after CPTR
        CALL PICK(BUFFER,CPTR,REMOVE)
C       Find the label of the destination cup
        DESTLAB=CUPLAB
        DESTLAB=GETDEST(DESTLAB,BUFFER)
        CALL INSERT(BUFFER,CPTR,CUPLAB,REMOVE,DESTLAB)
        IF (MOD(MOVES,1000).EQ.0)
     +    WRITE(*,45)"Moves completed =",MOVES
      ENDDO
      SPTR=1
      DO WHILE (BUFFER(SPTR).NE.1)
        SPTR=SPTR+1
      ENDDO
C     Need to check that we're not too close to the end of the BUFFER!
      IF (SPTR.LT.999999) THEN
        TOTAL=INT8(BUFFER(SPTR+1))*INT8(BUFFER(SPTR+2))
      ELSE IF (SPTR.EQ.999999) THEN
        TOTAL=INT8(BUFFER(SPTR+1))*INT8(BUFFER(1))
      ELSE IF (SPTR.EQ.1000000) THEN
        TOTAL=INT8(BUFFER(1))*INT8(BUFFER(2))
      ENDIF
      WRITE(*,40)"Product of the two cup labels after 1 is",TOTAL
      END       
C
      SUBROUTINE INSERT(BUFFER,CPTR,CUPLAB,REMOVE,DESTLAB)
      INTEGER BUFFER(1000000),CPTR,CUPLAB,REMOVE(3),DESTLAB
      INTEGER DPTR,TBUFFER(1000003),TPTR,L1,BPTR,SPTR
C
      DO L1=1,1000000
        IF (BUFFER(L1).EQ.DESTLAB) THEN
          DPTR=L1
          GOTO 100
        ENDIF
      ENDDO
  100 CONTINUE
      TPTR=0
      DO L1=1,DPTR
          TPTR=TPTR+1
          TBUFFER(TPTR)=BUFFER(L1)
      ENDDO
      DO L1=1,3
        TPTR=TPTR+1
        TBUFFER(TPTR)=REMOVE(L1)
      ENDDO
      DO L1=DPTR+1,1000000
          TPTR=TPTR+1
          TBUFFER(TPTR)=BUFFER(L1)
      ENDDO
      BPTR=0
C     Move 0's to the end of TBUFFER
      DO L1=1,1000003
        IF (TBUFFER(L1).NE.0) THEN
          BPTR=BPTR+1
          TBUFFER(BPTR)=TBUFFER(L1)
        ENDIF
      ENDDO
      DO L1=1000001,1000003
        TBUFFER(L1)=0
      ENDDO
C     Arrange BUFFER so that CPTR remains in the correct place
      DO L1=1,1000000
        IF (TBUFFER(L1).EQ.CUPLAB) THEN 
          SPTR=L1
          GOTO 200
        ENDIF
      ENDDO
  200 CONTINUE
      DO L1=1,SPTR-CPTR
        TBUFFER(L1+1000000)=TBUFFER(L1)
        TBUFFER(L1)=0
      ENDDO
      BPTR=0
      DO L1=1,1000003
        IF (TBUFFER(L1).NE.0) THEN
          BPTR=BPTR+1
          BUFFER(BPTR)=TBUFFER(L1)
        ENDIF
      ENDDO
      RETURN
      END
C
      INTEGER FUNCTION GETDEST(DESTLAB,BUFFER)
      INTEGER DESTLAB,BUFFER(1000000),L1
C
      GETDEST=0
      DO WHILE (GETDEST.EQ.0)
C       If DEST is (still) 0 it means that the next cup was one of
C       the three removed, so try again with the next lowest number
        DESTLAB=DESTLAB-1
        IF (DESTLAB.EQ.0) DESTLAB=1000000
        DO L1=1,1000000
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
      INTEGER BUFFER(1000000),CPTR,REMOVE(3),L1,L2
C
      L2=CPTR
C     Pick 3 numbers from CPTR+1 to CPTR+3,
C     wrapping if CPTR is greater than 1000000.
      DO L1=1,3
        L2=L2+1
        IF (L2.GT.1000000) L2=1
        REMOVE(L1)=BUFFER(L2)
        BUFFER(L2)=0
      ENDDO
C
      RETURN
      END
