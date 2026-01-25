      PROGRAM DAY16P1
C
      CHARACTER*100 LINE
      INTEGER RANGES(4,20),MYTICKET(20),NEARBY(20,240)
      INTEGER NRANGES,NNEARBY,TOTAL
      INTEGER ERATE
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(20I4)
   40 FORMAT(A,I10)
C
      WRITE(*,10)"Advent of Code 2020 day 16, part 1"
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
      TOTAL=ERATE(RANGES,NRANGES,NEARBY,NNEARBY)
      WRITE(*,40)"Ticket scanning error rate is ",TOTAL
      END
C
      INTEGER FUNCTION ERATE(RANGES,NR,TICKET,NN)
      INTEGER RANGES(4,20),NR,TICKET(20,240),NN
C
      INTEGER TK,TKF,VR,TRATE
      LOGICAL VALID
   10 FORMAT(A,I4,A,I10)
C
      ERATE=0
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
        ERATE=ERATE+TRATE
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
