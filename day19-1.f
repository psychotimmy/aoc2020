      PROGRAM DAY19P1
C
      CHARACTER*120 LINE
      CHARACTER*40 RULE(0:150),RULEZERO
      INTEGER NRULES,NMSGS,VMSGS,THISRULE,VALID
      INTEGER LINEPOS,LINELEN
      COMMON /ADVENT/ RULE,NRULES
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I4)
   40 FORMAT(I3,A,I3,A)
C
      WRITE(*,10)"Advent of Code 2020 day 19, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day19in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
C     Read in the rules, stored in rule order in /ADVENT/
      NRULES=0
      READ(10,FMT=20,ERR=100,END=100) LINE
      DO WHILE (LINE(1:1).NE.' ')
        NRULES=NRULES+1
        READ(LINE(1:INDEX(LINE,':')-1),30) THISRULE
        RULE(THISRULE)=LINE(INDEX(LINE,':')+2:)
C       Strip double quotes off terminating rules
        IF (RULE(THISRULE)(1:1).EQ.'"')
     +    RULE(THISRULE)(1:)=RULE(THISRULE)(2:2)
        READ(10,FMT=20,ERR=100,END=100) LINE
      ENDDO
C     Read in the monster messages
      NMSGS=0
      VMSGS=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      NMSGS=NMSGS+1
      LINEPOS=1
      LINELEN=INDEX(LINE,' ')-1
      RULEZERO=RULE(0)
      CALL PARSE(LINE,LINEPOS,LINELEN,RULEZERO,VALID)
C     Parital matches are not valid
      IF ((LINEPOS.LE.LINELEN).AND.(VALID.EQ.1)) VALID=0
      VMSGS=VMSGS+VALID
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      WRITE(*,40)NMSGS," messages processed, ",VMSGS," are valid"
      END
C
      RECURSIVE SUBROUTINE PARSE(LINE,LINEPOS,LINELEN,RSTR,VALID)
      CHARACTER*120 LINE
      CHARACTER*40 RSTR,TEMP,LEFT,RIGHT
      INTEGER LINEPOS,LINELEN,VALID,NNEXTRULE,BARPOS,SAVEPOS,NPOS
C
      COMMON /ADVENT/ RULE,NRULES
      CHARACTER*40 RULE(0:150)
      INTEGER NRULES
   10 FORMAT(I3)
      DO WHILE (RSTR(1:1).NE.' ')
C
C       This should not happen - program aborts if it does.
C
        IF (RSTR(1:1).EQ.'|') STOP 8
C
C       Hit a terminating character - set VALID (1) / invalid (0)
C       and increment message position
C
        IF ((RSTR(1:1).EQ.'a').OR.(RSTR(1:1).EQ.'b')) THEN
          IF (LINE(LINEPOS:LINEPOS).EQ.RSTR(1:1)) THEN
            VALID=1
            LINEPOS=LINEPOS+1
          ELSE
            VALID=0
          ENDIF
          RETURN
        ELSE
C
C         Otherwise recursively parse the rule string
C
          READ(RSTR(1:INDEX(RSTR,' ')-1),10) NNEXTRULE
          BARPOS=INDEX(RULE(NNEXTRULE),'|')
          IF (BARPOS.GT.0) THEN
            LEFT=RULE(NNEXTRULE)(:BARPOS-1)
            RIGHT=RULE(NNEXTRULE)(BARPOS+2:)
          ELSE
            LEFT=RULE(NNEXTRULE)
            RIGHT="x"
          ENDIF
          SAVEPOS=LINEPOS
          IF (LINEPOS.LE.LINELEN)
     +      CALL PARSE(LINE,LINEPOS,LINELEN,LEFT,VALID)
C         If we have a left hand side that is invalid, try the RHS
C         if there is one.
          IF ((VALID.EQ.0).AND.(RIGHT(1:1).NE.'x')) THEN
            LINEPOS=SAVEPOS
            IF (LINEPOS.LE.LINELEN)
     +        CALL PARSE(LINE,LINEPOS,LINELEN,RIGHT,VALID)
          ENDIF
C         If we're still not valid, return without parsing further rules
          IF (VALID.EQ.0) THEN
            RSTR=" "
          ELSE
C           We're valid, so try the next rule 
            NPOS=INDEX(RSTR,' ')
            RSTR=RSTR(NPOS+1:)
          ENDIF
        ENDIF
      ENDDO
C
      RETURN
      END
