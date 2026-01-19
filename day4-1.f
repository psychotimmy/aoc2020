      PROGRAM DAY4P1
C
      INTEGER PASSVAL,TOTAL
      CHARACTER*160 LINE
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 4, part 1"
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
C     are present this will be 1+2+4+8+16+32+64 = 127 as
C     byr=1, iyr=2, eyr=4, hgt=8, hcl=16, ecl=32, pid=64)
C
      IF (LINE(1:1).EQ.' ') THEN
        IF (PASSVAL.EQ.127) TOTAL=TOTAL+1
        PASSVAL=0
      ENDIF
      IF (INDEX(LINE,'byr:').GT.0) PASSVAL=PASSVAL+1
      IF (INDEX(LINE,'iyr:').GT.0) PASSVAL=PASSVAL+2
      IF (INDEX(LINE,'eyr:').GT.0) PASSVAL=PASSVAL+4
      IF (INDEX(LINE,'hgt:').GT.0) PASSVAL=PASSVAL+8
      IF (INDEX(LINE,'hcl:').GT.0) PASSVAL=PASSVAL+16
      IF (INDEX(LINE,'ecl:').GT.0) PASSVAL=PASSVAL+32
      IF (INDEX(LINE,'pid:').GT.0) PASSVAL=PASSVAL+64
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      WRITE(*,30)"Number of valid passports is ",TOTAL
      END
