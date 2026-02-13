      PROGRAM DAY19P2
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
      WRITE(*,10)"Advent of Code 2020 day 19, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day19in2.txt",STATUS="OLD",FORM="FORMATTED",
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
C     WRITE(*,*)"Parsing message:",LINE(1:LINELEN)
      CALL PARSE(LINE,LINEPOS,LINELEN,RULEZERO,VALID)
C     Parital matches are not valid
C     WRITE(*,*)"Result:",LINEPOS,LINELEN,VALID
      IF ((LINEPOS.LE.LINELEN).AND.(VALID.EQ.1)) THEN
C       WRITE(*,*)"Valid partial match - so invalid!"
        VALID=0
      ENDIF
C     IF (VALID.EQ.1) THEN
C       WRITE(*,*)LINE(1:LINELEN)," is a valid message"
C     ELSE
C       WRITE(*,*)LINE(1:LINELEN)," is an invalid message"
C     ENDIF
C     WRITE(*,*)">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<"
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
C     WRITE(*,*)">>",LINE(LINEPOS:LINELEN),LINEPOS,LINELEN,">",RSTR,"<"
      DO WHILE (RSTR(1:1).NE.' ')
C
C       This should not happen - program aborts if it does.
C
        IF (RSTR(1:1).EQ.'|') STOP 8
C
C       Check to ensure we're not still processing rules when the
C       end of the message has been reached 'successfully'. We can ignore
C       rule 31 if that's left at this stage on the RHS - see later in the
C       code for this trap
C
        IF (LINEPOS.GT.LINELEN) THEN
C         WRITE(*,*)"Rules left to parse but message end reached"
          VALID=0
          RETURN
        ENDIF
C
C       Hit a terminating character - set VALID (1) / invalid (0)
C       and increment message position
C
        IF ((RSTR(1:1).EQ.'a').OR.(RSTR(1:1).EQ.'b')) THEN
          IF (LINE(LINEPOS:LINEPOS).EQ.RSTR(1:1)) THEN
C           WRITE(*,*)"Valid terminator found ",RSTR(1:1)
            VALID=1
            LINEPOS=LINEPOS+1
          ELSE
C           WRITE(*,*)"Invalid terminator found ",RSTR(1:1)
            VALID=0
          ENDIF
          RETURN
        ELSE
C
C         Otherwise recursively parse the rule string
C
          READ(RSTR(1:INDEX(RSTR,' ')-1),10) NNEXTRULE
C         WRITE(*,*) NNEXTRULE,"::",RULE(NNEXTRULE)
          BARPOS=INDEX(RULE(NNEXTRULE),'|')
          IF (BARPOS.GT.0) THEN
            LEFT=RULE(NNEXTRULE)(:BARPOS-1)
            RIGHT=RULE(NNEXTRULE)(BARPOS+2:)
          ELSE
            LEFT=RULE(NNEXTRULE)
            RIGHT="x"
          ENDIF
C         WRITE(*,*)"left is ",LEFT," right is ",RIGHT
          SAVEPOS=LINEPOS
          IF (LINEPOS.LE.LINELEN)
     +      CALL PARSE(LINE,LINEPOS,LINELEN,LEFT,VALID)
C         If we have a left hand side that is invalid, try the RHS
C         if there is one.
          IF ((VALID.EQ.0).AND.(RIGHT(1:1).NE.'x')) THEN
C           WRITE(*,*)"Parsing RHS ",RIGHT
            LINEPOS=SAVEPOS
            IF (LINEPOS.LE.LINELEN)
     +        CALL PARSE(LINE,LINEPOS,LINELEN,RIGHT,VALID)
          ENDIF
C         If we're still not valid, return without parsing further rules
          IF (VALID.EQ.0) THEN
C           WRITE(*,*)"No match for rule(s)",LEFT," or ",RIGHT
C           Special handling for rule 31 on RHS and where we've already
C           matched the message
            IF ((RIGHT(1:2).EQ."31").AND.(LINEPOS.GT.LINELEN)) VALID=1
            RSTR=" "
          ELSE
C           We're valid, so try the next rule 
            NPOS=INDEX(RSTR,' ')
            RSTR=RSTR(NPOS+1:)
C           WRITE(*,*)"Valid so far - next rule(s) ::",RSTR
          ENDIF
        ENDIF
      ENDDO
C     WRITE(*,*)"Exit with ",LINE(LINEPOS:LINELEN),LINEPOS,LINELEN,
C    +          ">",RSTR,"<"
C
      RETURN
      END
