      PROGRAM DAY13P1
C
      INTEGER TIMESTAMP,TOTAL,L1,L2,BUSNO,MYWAIT,MYBUS,VALUE
      CHARACTER*160 LINE
C
   10 FORMAT(A)
   20 FORMAT(I10)
   30 FORMAT(A)
   40 FORMAT(A,I7)
C
      WRITE(*,10)"Advent of Code 2020 day 13, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day13in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
C     Only 2 lines to read
      READ(10,FMT=20) TIMESTAMP
      READ(10,FMT=30) LINE
      CLOSE(10)
C     Set a high waiting time to start
      MYWAIT=TIMESTAMP
C     Find the valid bus numbers (and trip times) in LINE
      L1=1
      L2=INDEX(LINE,',')-1
      DO WHILE (L2.NE.-1) 
        IF (LINE(L1:L2).NE.'x') THEN
C         Ignores x's
          READ(LINE(L1:L2),20) BUSNO
C         WRITE(*,*)">>",BUSNO
          VALUE=(TIMESTAMP/BUSNO)*BUSNO+BUSNO-TIMESTAMP
C         WRITE(*,*)"--",VALUE
          IF (VALUE.LT.MYWAIT) THEN
            MYWAIT=VALUE
            MYBUS=BUSNO
          ENDIF
        ENDIF
        LINE=LINE(L2+2:)
        L1=1
        L2=INDEX(LINE,',')-1
      ENDDO
C     Deal with the last value in the LINE
      IF (LINE(1:1).NE.'x') THEN
        READ(LINE(1:),20) BUSNO
C       WRITE(*,*)">>",BUSNO
        VALUE=(TIMESTAMP/BUSNO)*BUSNO+BUSNO-TIMESTAMP
C       WRITE(*,*)"--",VALUE
        IF (VALUE.LT.MYWAIT) THEN
          MYWAIT=VALUE
          MYBUS=BUSNO
        ENDIF
      ENDIF
C         
      WRITE(*,40)"Best bus number x waiting time is ",MYBUS*MYWAIT
      END
