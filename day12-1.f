      PROGRAM DAY12P1
C
      CHARACTER*8 LINE
      CHARACTER*1 CMD
      COMPLEX START,FIN
      INTEGER VALUE,FACING,MANHATTAN
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I4)
   40 FORMAT(A,I5)
   45 FORMAT(A,2G14.6)
C
      WRITE(*,10)"Advent of Code 2020 day 12, part 1"
      WRITE(*,10)" "
C
      START=CMPLX(0,0)
      FIN=CMPLX(0,0)
C     FACING: 0 = East, 1 = South, 2 = West, 3 = North
      FACING=0
      OPEN(10,FILE="day12in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      CMD=LINE(1:1)
      READ(LINE(2:),30) VALUE
      CALL DOCOMMAND(CMD,VALUE,FACING,START,FIN)
      START=FIN
      GOTO 50
  100 CONTINUE
      CLOSE(10)
C     WRITE(*,45)"Ended at ",START
      WRITE(*,40)"Manhattan distance travelled is"
     +            ,MANHATTAN(CMPLX(0,0),START)
      END
C
      SUBROUTINE DOCOMMAND(CMD,VALUE,FACING,S,F)
      CHARACTER*1 CMD
      INTEGER VALUE,FACING
      COMPLEX S,F
C
   10 FORMAT(3A)
C
      IF (CMD.EQ.'N') THEN
        F=S+CMPLX(0,VALUE)
      ELSE IF (CMD.EQ.'S') THEN
        F=S-CMPLX(0,VALUE)
      ELSE IF (CMD.EQ.'E') THEN
        F=S+CMPLX(VALUE,0)
      ELSE IF (CMD.EQ.'W') THEN
        F=S-CMPLX(VALUE,0)
      ELSE IF (CMD.EQ.'L') THEN
        FACING=FACING-1*(VALUE/90)
C       Need to correct a negative value
        IF (FACING.EQ.-1) FACING=3
        IF (FACING.EQ.-2) FACING=2
        IF (FACING.EQ.-3) FACING=1
        IF (FACING.EQ.-4) FACING=0
C       Assumption is we never turn more than 360deg in one go
        IF (FACING.LE.-5) STOP 8
      ELSE IF (CMD.EQ.'R') THEN
        FACING=MOD(FACING+1*(VALUE/90),4)
      ELSE IF (CMD.EQ.'F') THEN
        IF (FACING.EQ.0) THEN
          F=S+CMPLX(VALUE,0)
        ELSE IF (FACING.EQ.1) THEN
          F=S-CMPLX(0,VALUE)
        ELSE IF (FACING.EQ.2) THEN
          F=S-CMPLX(VALUE,0)
        ELSE
          F=S+CMPLX(0,VALUE)
        ENDIF
      ELSE
        WRITE(*,10)"Unrecognised command ",CMD," stopping!"
        STOP 8
      ENDIF
C
      RETURN
      END
C
      INTEGER FUNCTION MANHATTAN(P1,P2)
      COMPLEX P1,P2
C
      INTEGER I,J
C
      I=IABS(INT(REAL(P1))-INT(REAL(P2)))
      J=IABS(INT(AIMAG(P1))-INT(AIMAG(P2)))
      MANHATTAN=I+J
      RETURN
      END
