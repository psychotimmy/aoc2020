      PROGRAM DAY4P2
C
      INTEGER PASSVAL,POS,EPOS,TOTAL,CHECKVALID
      CHARACTER*160 LINE
      CHARACTER*24 TEST
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 4, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day4in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      TOTAL=0
      PASSVAL=0
C     Passports are separated by a blank line, data may be over
C     multiple lines
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
C     If the line is blank, add 1 to total if the last passport
C     processed was valid (i.e. all fields present, but cid
C     doesn't matter. Do this by checking PASSVAL - if all fields
C     are present AND VALID this will be 1+2+4+8+16+32+64 = 127 as
C     byr=1, iyr=2, eyr=4, hgt=8, hcl=16, ecl=32, pid=64)
C
      IF (LINE(1:1).EQ.' ') THEN
        IF (PASSVAL.EQ.127) TOTAL=TOTAL+1
        PASSVAL=0
      ENDIF
      POS=INDEX(LINE,'byr:')
      IF (POS.GT.0) THEN
        EPOS=INDEX(LINE(POS:),' ')-1
        TEST=LINE(POS+4:POS+EPOS)
        PASSVAL=PASSVAL+CHECKVALID(TEST,1)
      ENDIF
      POS=INDEX(LINE,'iyr:')
      IF (POS.GT.0) THEN
        EPOS=INDEX(LINE(POS:),' ')-1
        TEST=LINE(POS+4:POS+EPOS)
        PASSVAL=PASSVAL+CHECKVALID(TEST,2)
      ENDIF
      POS=INDEX(LINE,'eyr:')
      IF (POS.GT.0) THEN
        EPOS=INDEX(LINE(POS:),' ')-1
        TEST=LINE(POS+4:POS+EPOS)
        PASSVAL=PASSVAL+CHECKVALID(TEST,4)
      ENDIF
      POS=INDEX(LINE,'hgt:')
      IF (POS.GT.0) THEN
        EPOS=INDEX(LINE(POS:),' ')-1
        TEST=LINE(POS+4:POS+EPOS)
        PASSVAL=PASSVAL+CHECKVALID(TEST,8)
      ENDIF
      POS=INDEX(LINE,'hcl:')
      IF (POS.GT.0) THEN
        EPOS=INDEX(LINE(POS:),' ')-1
        TEST=LINE(POS+4:POS+EPOS)
        PASSVAL=PASSVAL+CHECKVALID(TEST,16)
      ENDIF
      POS=INDEX(LINE,'ecl:')
      IF (POS.GT.0) THEN
        EPOS=INDEX(LINE(POS:),' ')-1
        TEST=LINE(POS+4:POS+EPOS)
        PASSVAL=PASSVAL+CHECKVALID(TEST,32)
      ENDIF
      POS=INDEX(LINE,'pid:')
      IF (POS.GT.0) THEN
        EPOS=INDEX(LINE(POS:),' ')-1
        TEST=LINE(POS+4:POS+EPOS)
        PASSVAL=PASSVAL+CHECKVALID(TEST,64)
      ENDIF
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      WRITE(*,30)"Number of valid passports is ",TOTAL
      END
C
      INTEGER FUNCTION CHECKVALID(TOKEN,VALUE)
      CHARACTER*(*) TOKEN
      INTEGER VALUE
C
      INTEGER IVAL,L1
C
C     The checks made depend on the VALUE parameter.
C     If the checks pass, the return value of this function is VALUE,
C     otherwise it is 0.
C
   10 FORMAT (I4)
      CHECKVALID=0
      IF (VALUE.EQ.1) THEN
        READ(TOKEN,10) IVAL
        IF ((IVAL.GE.1920).AND.(IVAL.LE.2020)) CHECKVALID=1
      ENDIF
      IF (VALUE.EQ.2) THEN
        READ(TOKEN,10) IVAL
        IF ((IVAL.GE.2010).AND.(IVAL.LE.2020)) CHECKVALID=2
      ENDIF
      IF (VALUE.EQ.4) THEN
        READ(TOKEN,10) IVAL
        IF ((IVAL.GE.2020).AND.(IVAL.LE.2030)) CHECKVALID=4
      ENDIF
      IF (VALUE.EQ.8) THEN
        IF (INDEX(TOKEN,'cm').GT.0) THEN
          TOKEN=TOKEN(:INDEX(TOKEN,'cm')-1)
          READ(TOKEN,10) IVAL
          IF ((IVAL.GE.150).AND.(IVAL.LE.193)) CHECKVALID=8
        ELSE
          TOKEN=TOKEN(:INDEX(TOKEN,'in')-1)
          READ(TOKEN,10) IVAL
          IF ((IVAL.GE.59).AND.(IVAL.LE.76)) CHECKVALID=8
        ENDIF
      ENDIF
      IF (VALUE.EQ.16) THEN
        IF ((TOKEN(1:1).EQ.'#').AND.(TOKEN(8:8).EQ.' ')) THEN
          DO L1=2,7
            IF((TOKEN(L1:L1).GE.'0').AND.(TOKEN(L1:L1).LE.'9')) GOTO 100
            IF((TOKEN(L1:L1).GE.'a').AND.(TOKEN(L1:L1).LE.'f')) GOTO 100
C           If here the hair colour is invalid
            GOTO 200
  100       CONTINUE
          ENDDO
          CHECKVALID=16
  200     CONTINUE
        ENDIF   
      ENDIF
      IF (VALUE.EQ.32) THEN
        IF (TOKEN(4:4).EQ.' ') THEN
          IF ((TOKEN(1:3).EQ.'amb').OR.
     +        (TOKEN(1:3).EQ.'blu').OR.
     +        (TOKEN(1:3).EQ.'brn').OR.
     +        (TOKEN(1:3).EQ.'gry').OR.
     +        (TOKEN(1:3).EQ.'grn').OR.
     +        (TOKEN(1:3).EQ.'hzl').OR.
     +        (TOKEN(1:3).EQ.'oth')) CHECKVALID=32
        ENDIF
      ENDIF
      IF (VALUE.EQ.64) THEN
        IF (TOKEN(10:10).EQ.' ') THEN
          DO L1=1,9
            IF((TOKEN(L1:L1).GE.'0').AND.(TOKEN(L1:L1).LE.'9')) GOTO 300
C           If here the passport number is invalid
            GOTO 400
  300       CONTINUE
          ENDDO
          CHECKVALID=64
  400     CONTINUE
        ENDIF
      ENDIF
C
      RETURN
      END
