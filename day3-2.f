      PROGRAM DAY3P2
C
      CHARACTER*80 LINE(325)
      INTEGER ROW,COL,TOTAL
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(A,I10)
C
      WRITE(*,10)"Advent of Code 2020 day 3, part 2"
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
C     Check the possible slopes to toboggan down
      TOTAL=CHECKSLOPE(1,1,ROW,COL,LINE)*
     +      CHECKSLOPE(3,1,ROW,COL,LINE)*
     +      CHECKSLOPE(5,1,ROW,COL,LINE)*
     +      CHECKSLOPE(7,1,ROW,COL,LINE)*
     +      CHECKSLOPE(1,2,ROW,COL,LINE)
      WRITE(*,30)
     +  "Total trees encountered on each slope multiplied is ",TOTAL
      END
C
      FUNCTION CHECKSLOPE(RIGHT,DOWN,ROW,COL,LINE)
      INTEGER RIGHT,DOWN,ROW,COL
      CHARACTER*80 LINE(*)
C
      INTEGER CURROW,CURCOL
C     Work through the map moving RIGHT,DOWN wrapping as needed
      CURROW=1
      CURCOL=1
      CHECKSLOPE=0
      DO WHILE (CURROW.NE.ROW)
        CURROW=CURROW+DOWN
        CURCOL=CURCOL+RIGHT
        IF (CURCOL.GT.COL) CURCOL=CURCOL-COL
C       Do we have a tree?
        IF (LINE(CURROW)(CURCOL:CURCOL).EQ.'#') CHECKSLOPE=CHECKSLOPE+1 
      ENDDO
      RETURN
      END
