      PROGRAM DAY3P1
C
      CHARACTER*80 LINE(325)
      INTEGER ROW,COL,CURROW,CURCOL,TREES
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 3, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day3in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      ROW=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE(ROW+1)
      ROW=ROW+1
      GOTO 50
  100 CONTINUE
      CLOSE(10)
C     Work out how many columns are in the map
      COL=INDEX(LINE(1),' ')-1
C     Work through the map moving right 3, down 1, wrapping as needed
      CURROW=1
      CURCOL=1
      TREES=0
      DO WHILE (CURROW.NE.ROW)
        CURROW=CURROW+1
        CURCOL=CURCOL+3
        IF (CURCOL.GT.COL) CURCOL=CURCOL-COL
C       Do we have a tree?
        IF (LINE(CURROW)(CURCOL:CURCOL).EQ.'#') TREES=TREES+1 
      ENDDO
      WRITE(*,30)"Number of trees encountered is ",TREES
      END
