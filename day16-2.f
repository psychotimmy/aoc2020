      PROGRAM DAY16P2
C
      CHARACTER*100 LINE
      INTEGER RANGES(4,20),MYTICKET(20),NEARBY(20,240),L1
      INTEGER NRANGES,NNEARBY,TOTAL,VTICKET(20,240),NV,TKFREF(20)
      INTEGER*8 TOTAL2
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(20I4)
   40 FORMAT(A,I14)
C
      WRITE(*,10)"Advent of Code 2020 day 16, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day16in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
C     Read RANGES
      READ(10,FMT=20,ERR=100,END=100) LINE
      NRANGES=1
      DO WHILE (LINE(1:1).NE.' ')
        CALL PROCESSRANGE(LINE,RANGES,NRANGES)
        READ(10,FMT=20,ERR=100,END=100) LINE
        NRANGES=NRANGES+1
      ENDDO
      NRANGES=NRANGES-1
C     Read MYTICKET, skipping "your ticket:"
      READ(10,FMT=20,ERR=100,END=100) LINE
      READ(10,FMT=20,ERR=100,END=100) LINE
      CALL PROCESSTICKET(LINE,MYTICKET,1)
C     WRITE(*,30)(MYTICKET(L1),L1=1,20)
C     Skip next blank line
      READ(10,FMT=20,ERR=100,END=100) LINE
C     Read NEARBY tickets, skipping "nearby tickets:"
      READ(10,FMT=20,ERR=100,END=100) LINE
      NNEARBY=0
      DO WHILE (LINE(1:1).NE.' ')
        READ(10,FMT=20,ERR=100,END=100) LINE
        NNEARBY=NNEARBY+1
        CALL PROCESSTICKET(LINE,NEARBY,NNEARBY)
C       WRITE(*,30)(NEARBY(L1,NNEARBY),L1=1,20)
      ENDDO
  100 CONTINUE
      CLOSE(10)
      CALL ERATE(RANGES,NRANGES,NEARBY,NNEARBY,TOTAL,VTICKET,NV)
      WRITE(*,40)"Ticket scanning error rate is ",TOTAL
      WRITE(*,40)"Number of nearby valid tickets is ",NV
      CALL DECODER(VTICKET,NV,RANGES,NRANGES,TKFREF)
C     The six ranges that start 'departure' are numbers 1-6 inclusive
      TOTAL2=1
      DO L1=1,NRANGES
        IF (TKFREF(L1).LE.6) THEN
          TOTAL2=TOTAL2*MYTICKET(L1)
        ENDIF
      ENDDO
      WRITE(*,40)"Multiple of my ticket's departure fields is ",TOTAL2
      END
C
      SUBROUTINE DECODER(TICKET,NT,RANGES,NR,TKFREF)
      INTEGER TICKET(20,240),NT,RANGES(4,20),NR,TKFREF(20)
C
      INTEGER TK,TKF,VR,L1,L2,ITER
      INTEGER NUMTRUE,COLTRUE,VROK(NR),XREF(20,20)
      LOGICAL VALID
   10 FORMAT(20I2)
C
      DO L1=1,NR
        DO L2=1,NR
          XREF(L1,L2)=0
        ENDDO
      ENDDO
C
C     Work through each ticket and field against each range, count
C     the number of potentially valid tickets for each field vs range
C
        DO TK=1,NT
          DO TKF=1,NR
            DO L1=1,NR
              VROK(L1)=0
            ENDDO
            DO VR=1,NR
              VALID=.FALSE.
              IF (TICKET(TKF,TK).GE.RANGES(1,VR).AND.
     +            TICKET(TKF,TK).LE.RANGES(2,VR)) VALID=.TRUE.
              IF (TICKET(TKF,TK).GE.RANGES(3,VR).AND.
     +            TICKET(TKF,TK).LE.RANGES(4,VR)) VALID=.TRUE.
              IF (VALID)VROK(VR)=VROK(VR)+1
            ENDDO
            DO L1=1,NR
              XREF(TKF,L1)=XREF(TKF,L1)+VROK(L1)
            ENDDO
          ENDDO
        ENDDO
C     Not really needed, but makes it easier to print the 20x20 TKF v VR
C     array for debugging ...
      DO L1=1,NR
        DO L2=1,NR
          IF (XREF(L1,L2).EQ.NT) THEN
            XREF(L1,L2)=1
          ELSE
            XREF(L1,L2)=0
          ENDIF
        ENDDO
      ENDDO
C     DO L1=1,NR
C       WRITE(*,10) (XREF(L1,L2),L2=1,NR)
C     ENDDO
      WRITE(*,*)""
C     Worst case is that we'll have to go through the XREF array NR
C     times to get all of the ticket field TKF to ranges VR references
      DO ITER=1,NR
        DO L1=1,NR
          NUMTRUE=0
          COLTRUE=0
          DO L2=1,NR
            IF (XREF(L1,L2).EQ.1) THEN
              COLTRUE=L2
              NUMTRUE=NUMTRUE+1
            ENDIF
          ENDDO
          IF (NUMTRUE.EQ.1) THEN
            WRITE(*,*)"Ticket field ",L1," is range ",COLTRUE
            TKFREF(L1)=COLTRUE
            DO L2=1,NR
              XREF(L2,COLTRUE)=0
            ENDDO
          ENDIF
        ENDDO
      ENDDO
      WRITE(*,*)
C     We now have the complete ticket field to range reference in TKFREF
      RETURN
      END
C
      SUBROUTINE ERATE(RANGES,NR,TICKET,NN,ER,VTICKET,NV)
      INTEGER RANGES(4,20),NR,TICKET(20,240),NN,ER,VTICKET(20,240),NV
C
      INTEGER TK,TKF,VR,TRATE,L1
      LOGICAL VALID
   10 FORMAT(A,I4,A,I10)
C
      ER=0
      NV=0
      DO TK=1,NN
        TRATE=0
        DO TKF=1,20
          VALID=.FALSE.
          VR=1
          DO WHILE ((.NOT.VALID).AND.(VR.LE.20))
            IF (TICKET(TKF,TK).GE.RANGES(1,VR).AND.
     +          TICKET(TKF,TK).LE.RANGES(2,VR)) VALID=.TRUE.
            IF (TICKET(TKF,TK).GE.RANGES(3,VR).AND.
     +          TICKET(TKF,TK).LE.RANGES(4,VR)) VALID=.TRUE.
            VR=VR+1
          ENDDO
          IF(.NOT.VALID) TRATE=TRATE+TICKET(TKF,TK)
        ENDDO
C       WRITE(*,10)"Scanning error rate for ticket",TK," is",TRATE
        IF (TRATE.EQ.0) THEN
C         This is a valid ticket
          NV=NV+1
          DO L1=1,20
            VTICKET(L1,NV)=TICKET(L1,TK)
          ENDDO
        ENDIF
        ER=ER+TRATE
      ENDDO
      RETURN
      END
C           
      SUBROUTINE PROCESSRANGE(STR,RANGES,NR)
      CHARACTER*(*)STR
      INTEGER RANGES(*),NR
C     
      CHARACTER*20 R,RL,RR
      INTEGER I1,I2,I3,I4
   10 FORMAT(I4)
C
C     Extract first range
C
      R=STR(INDEX(STR,': ')+2:)
      R=R(:INDEX(R,' or')-1)
      RL=R(:INDEX(R,'-')-1)
      RR=R(INDEX(R,'-')+1:)
      READ(RL,10)I1
      READ(RR,10)I2
C
C     Extract second range
C
      R=STR(INDEX(STR,'or ')+3:)
      R=R(:INDEX(R,' ')-1)
      RL=R(:INDEX(R,'-')-1)
      RR=R(INDEX(R,'-')+1:)
      READ(RL,10)I3
      READ(RR,10)I4
C
C     Place into RANGES array (column major order)
C
      RANGES(NR*4-3)=I1
      RANGES(NR*4-2)=I2
      RANGES(NR*4-1)=I3
      RANGES(NR*4)=I4
      RETURN
      END
C
      SUBROUTINE PROCESSTICKET(STR,TICKET,NN)
      CHARACTER*(*)STR 
      INTEGER TICKET(*),NN
C
      CHARACTER*10 CVAL
      INTEGER IP,IV
   10 FORMAT(I4)
C
      IP=19
      DO WHILE (INDEX(STR,',').NE.0)
        CVAL=STR(:INDEX(STR,',')-1)
        STR=STR(INDEX(STR,',')+1:)
        READ(CVAL,10)IV
C       Update TICKET - column major order
        TICKET(NN*20-IP)=IV
        IP=IP-1
      ENDDO
C     Deal with last value on the TICKET
      CVAL=STR(:INDEX(STR,' ')-1)
      READ(CVAL,10)IV
      TICKET(NN*20-IP)=IV
      RETURN
      END
