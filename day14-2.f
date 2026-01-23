      PROGRAM DAY14P2
C
      CHARACTER*80 LINE
      CHARACTER*36 MASK
      INTEGER L1,NMEM
      INTEGER*8 MEM(90000,2),TOTAL
C     Need lots of space - dynamic memory allocation would be nice!!
C     MEM(X,1) = actual memory location
C     MEM(X,2) = value of that location
C
   10 FORMAT(A)
   20 FORMAT(A)
   40 FORMAT(A,I20)
C
      WRITE(*,10)"Advent of Code 2020 day 14, part 2"
      WRITE(*,10)" "
C
C     Initialise a map for the memory
      NMEM=0
      DO L1=1,90000
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
      INTEGER*8 MEM(90000,2)
      INTEGER NMEM
C
      CHARACTER*5 LOCSTR
      CHARACTER*16 VALSTR
      CHARACTER*36 VALBIN(2048)
      INTEGER*8 LOCN,VALUE
      INTEGER LOCS,L1,L2
   10 FORMAT(I5)
   20 FORMAT(I16)
C
C     Get the memory location
      LOCSTR=STR(INDEX(STR,'[')+1:INDEX(STR,']')-1)
      READ(LOCSTR,10) LOCN
C     Get the value to write there before masking
      VALSTR=STR(INDEX(STR,'=')+2:)
      READ(VALSTR,20) VALUE
C     Convert the LOCN base 10 number into 36 'binary' bits
      CALL C10TO2(LOCN,VALBIN(1))
C     Apply the mask to this location - expect multiple locations back
      LOCS=1
      CALL APPLYMASK(MASK,VALBIN,LOCS)
C     WRITE(*,*)LOCS
C     Convert VALBINs back to INTEGER*8s and store the value against
C     each of these locations.
      DO L1=1,LOCS
        CALL C2TO10(VALBIN(L1),LOCN)
C       Store VALUE in the MEM array. If we've seen the location before,
C       overwrite the existing value. Otherwise add it in as a newly
C       populated location.
        DO L2=1,NMEM
C         We've already seen this location, overwrite it and break loop
          IF (MEM(L2,1).EQ.LOCN) THEN
            MEM(L2,2)=VALUE
            GOTO 100
          ENDIF
        ENDDO
C       Can only get here if this is the first time we've written to this
C       memory location
        NMEM=NMEM+1
        MEM(NMEM,1)=LOCN
        MEM(NMEM,2)=VALUE
  100   CONTINUE
      ENDDO
C     WRITE(*,*)">>",NMEM
      RETURN
      END
C
      SUBROUTINE C10TO2(VALUE,VALBIN)
      INTEGER*8 VALUE
      CHARACTER*(*) VALBIN
C
      INTEGER L1
C
      DO L1=1,36
        IF ((VALUE/2**INT8(36-L1)).EQ.1) THEN 
          VALUE=VALUE-2**INT8(36-L1)
          VALBIN(L1:L1)='1'
        ELSE
          VALBIN(L1:L1)='0'
        ENDIF
      ENDDO
      RETURN
      END
C
      SUBROUTINE APPLYMASK(MASK,VALBIN,VALBINS)
      CHARACTER*(*) MASK, VALBIN(*)
      INTEGER VALBINS
C
      INTEGER L1,L2
C
C     WRITE(*,*)MASK
      DO L1=1,36
C       No action if mask bit is 0
        IF (MASK(L1:L1).EQ.'1') THEN
C         Change the bit of all the exisitng VALBINS if mask bit is 1
          DO L2=1,VALBINS
            VALBIN(L2)(L1:L1)='1'
          ENDDO
        ELSE IF (MASK(L1:L1).EQ.'X') THEN
C         Double the number of VALBINS if mask bit is X, set one half
C         of the VALBINS to have this bit as value 0, the other half
C         as value 1
          DO L2=1,VALBINS
C           Copy to second half of the VALBIN array
            VALBIN(VALBINS+L2)=VALBIN(L2)
C           Set first copy's bit to 0, second copy's bit to 1
            VALBIN(L2)(L1:L1)='0'
            VALBIN(VALBINS+L2)(L1:L1)='1'
          ENDDO
C         We've now double the number of VALBINS
          VALBINS=VALBINS*2
        ENDIF
      ENDDO
      RETURN
      END
C
      SUBROUTINE C2TO10(VALBIN,VALUE)
      CHARACTER*(*) VALBIN
      INTEGER*8 VALUE
C
      VALUE=0
      DO L1=1,36
        IF (VALBIN(L1:L1).EQ.'1') VALUE=VALUE+2**INT8(36-L1)
      ENDDO
      RETURN
      END
