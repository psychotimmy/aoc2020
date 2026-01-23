      PROGRAM DAY14P1
C
      CHARACTER*80 LINE
      CHARACTER*36 MASK
      INTEGER L1,NMEM
      INTEGER*8 MEM(1000,2),TOTAL
C     MEM(X,1) = actual memory location
C     MEM(X,2) = value of that location
C
   10 FORMAT(A)
   20 FORMAT(A)
   40 FORMAT(A,I20)
C
      WRITE(*,10)"Advent of Code 2020 day 14, part 1"
      WRITE(*,10)" "
C
C     Initialise a map for the memory
      NMEM=0
      DO L1=1,1000
        MEM(L1,1)=0
        MEM(L1,2)=0
      ENDDO
C
      OPEN(10,FILE="day14in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
C     The only instructions are mask and mem
      IF (LINE(1:2).EQ.'ma') THEN
        MASK(1:36)=LINE(8:44)
      ELSE
        CALL SETMEM(LINE,MASK,MEM,NMEM)
      ENDIF
      GOTO 50
  100 CONTINUE
      CLOSE(10)
C     Sum the value of the memory locations to get the answer
      TOTAL=0
      DO L1=1,NMEM
        TOTAL=TOTAL+MEM(L1,2)
      ENDDO
      WRITE(*,40)"Sum of the values in the memory is ",TOTAL
      END
C
      SUBROUTINE SETMEM(STR,MASK,MEM,NMEM)
      CHARACTER*(*)STR,MASK
      INTEGER*8 MEM(1000,2)
      INTEGER NMEM
C
      CHARACTER*5 LOCSTR
      CHARACTER*16 VALSTR
      CHARACTER*36 VALBIN
      INTEGER*8 LOCN,VALUE
      INTEGER L1
   10 FORMAT(I5)
   20 FORMAT(I16)
C
C     Get the memory location
      LOCSTR=STR(INDEX(STR,'[')+1:INDEX(STR,']')-1)
      READ(LOCSTR,10) LOCN
C     Get the value to write there before masking
      VALSTR=STR(INDEX(STR,'=')+2:)
      READ(VALSTR,20) VALUE
C     Convert this base 10 number into 36 'binary' bits
      DO L1=1,36
        IF ((VALUE/2**INT8(36-L1)).EQ.1) THEN 
          VALUE=VALUE-2**INT8(36-L1)
          VALBIN(L1:L1)='1'
        ELSE
          VALBIN(L1:L1)='0'
        ENDIF
      ENDDO
C     Apply the mask
      DO L1=1,36
        IF (MASK(L1:L1).EQ.'0') VALBIN(L1:L1)='0'
        IF (MASK(L1:L1).EQ.'1') VALBIN(L1:L1)='1'
      ENDDO
C     Convert VALBIN back to a INTEGER*8
      VALUE=0
      DO L1=1,36
        IF (VALBIN(L1:L1).EQ.'1') VALUE=VALUE+2**INT8(36-L1)
      ENDDO
C     Store it in the MEM array. If we've seen the location before,
C     overwrite the existing value. Otherwise add it in as a newly
C     populated location.
      DO L1=1,NMEM
C       We've already seen this location, overwrite it and break loop
        IF (MEM(L1,1).EQ.LOCN) THEN
          MEM(L1,2)=VALUE
          GOTO 100
        ENDIF
      ENDDO
C     Can only get here if this is the first time we've written to this
C     memory location
      NMEM=NMEM+1
      MEM(NMEM,1)=LOCN
      MEM(NMEM,2)=VALUE
  100 CONTINUE
C
      RETURN
      END
