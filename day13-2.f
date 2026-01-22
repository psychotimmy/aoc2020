      PROGRAM DAY13P2
C
      INTEGER IGNORE,L1,L2
      INTEGER*8 BUSSES(10),OFFSETS(10),NUM,BUSNO,NEXTOFF
      INTEGER*8 TSTAMP,ANS
      CHARACTER*160 LINE
C
   10 FORMAT(A)
   20 FORMAT(I10)
   30 FORMAT(A)
   40 FORMAT(A,I18)
C
      WRITE(*,10)"Advent of Code 2020 day 13, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day13in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
C     Only 2 lines to read - ignore the first line for part 2
      READ(10,FMT=20) IGNORE
      READ(10,FMT=30) LINE
      CLOSE(10)
C     Find the valid bus numbers and offsets in LINE
      NUM=1
      NEXTOFF=0
      L1=1
      L2=INDEX(LINE,',')-1
      DO WHILE (L2.NE.-1) 
        IF (LINE(L1:L2).NE.'x') THEN
          READ(LINE(L1:L2),20) BUSNO
          BUSSES(NUM)=BUSNO
          OFFSETS(NUM)=BUSNO-NEXTOFF
          NUM=NUM+1
        ENDIF
C       Increment the value of the OFFSET
        NEXTOFF=NEXTOFF+1
        LINE=LINE(L2+2:)
        L1=1
        L2=INDEX(LINE,',')-1
      ENDDO
C     Deal with the last value in the LINE
      IF (LINE(1:1).NE.'x') THEN
        READ(LINE(1:),20) BUSNO
        BUSSES(NUM)=BUSNO
        OFFSETS(NUM)=BUSNO-NEXTOFF
      ENDIF
C         
C     Note: CRT algorithm assumes all pairs of bus numbers are coprimes
C
      ANS=TSTAMP(BUSSES,OFFSETS,NUM)
C
      WRITE(*,40)"Earliest timestamp is  ",ANS
      END
C
      INTEGER*8 FUNCTION TSTAMP(BUS,OFF,NUM)
      INTEGER*8 BUS(*),OFF(*),NUM
C
C     Implements the Chinese remainder theorum
C
      INTEGER*8 PRODUCT,CRT,PP,MODMULINV,L1
C
      PRODUCT=BUS(1)
      DO L1=2,NUM
        PRODUCT=PRODUCT*BUS(L1)
      ENDDO
      CRT=0
      DO L1=1,NUM
        PP=PRODUCT/BUS(L1)
        CRT=CRT+OFF(L1)*MODMULINV(PP,BUS(L1))*PP
      ENDDO
      TSTAMP=MOD(CRT,PRODUCT)
C
      RETURN
      END
C
      INTEGER*8 FUNCTION MODMULINV(ANUM,AMOD)
      INTEGER*8 ANUM,AMOD
C
C     Modulo multiplcative inverse of ANUM with AMOD
C
      INTEGER*8 A,M,T,QUOT,X
C     Use locals A,M to avoid side effects in calling routine
      A=ANUM
      M=AMOD 
C
      IF (M.EQ.1) THEN
        MODMULINV=0
      ELSE
        X=0
        MODMULINV=1
        DO WHILE (A.GT.1) 
C         QUOT is the quotient
          QUOT=A/M
          T=M
C         M is now the remainder
          M=MOD(A,M)
          A=T
          T=X
          X=MODMULINV-QUOT*X
          MODMULINV=T
        ENDDO
C       Ensure MODMULINV is positive
        IF (MODMULINV.LT.0) MODMULINV=MODMULINV+AMOD
      ENDIF
C
      RETURN
      END
