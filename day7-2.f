      PROGRAM DAY7P2
C
      CHARACTER*160 LINE,CBAG
      CHARACTER*32 BAGTYPE(600),NODECOL
      INTEGER TOTAL,BAGTYPES,NODEVAL,WEIGHT,SGBNODE
      INTEGER GRAPH(1600,3),GNODES,SGBCONTAINS
      LOGICAL CONNECTED
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I1)
   40 FORMAT(A,I5)
C
      WRITE(*,10)"Advent of Code 2020 day 7, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day7in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      TOTAL=0
      BAGTYPES=0
C     Read through the file once to get all of the BAGTYPES
C     Assumption - each BAGTYPE appears ONCE at the start of a line
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      BAGTYPES=BAGTYPES+1
      BAGTYPE(BAGTYPES)=LINE(1:INDEX(LINE,' bags')-1)
C     Store our target node - shiny gold - for later
      IF (BAGTYPE(BAGTYPES).EQ.'shiny gold') SGBNODE=BAGTYPES
      GOTO 50
  100 CONTINUE
      REWIND(10)
      BAGTYPES=0
      GNODES=0
  150 CONTINUE
      READ(10,FMT=20,ERR=200,END=200) LINE
      BAGTYPES=BAGTYPES+1
C     Find the first connected bag or 'no other bags' statement
      CBAG=LINE(INDEX(LINE,'contain')+8:)
C     Leaf node found - read next line
      IF (CBAG(1:2).EQ.'no') THEN
        GNODES=GNODES+1
        GRAPH(GNODES,1)=BAGTYPES
        GRAPH(GNODES,2)=0
        GRAPH(GNODES,3)=0
        GOTO 150
      ELSE
C     We have at least 1 connected node - store its weight (range is 1-9)
        CONNECTED=.TRUE.
        DO WHILE (CONNECTED)
          READ(CBAG(1:1),30) WEIGHT
C         Find the index of the connected node's colour in BAGTYPE array
C         bag or bags are possible, so INDEX using ' bag'.
          NODECOL=CBAG(3:INDEX(CBAG,' bag')-1)
          NODEVAL=1
          DO WHILE (BAGTYPE(NODEVAL).NE.NODECOL) 
            NODEVAL=NODEVAL+1
          ENDDO
          GNODES=GNODES+1
          GRAPH(GNODES,1)=BAGTYPES
          GRAPH(GNODES,2)=NODEVAL
          GRAPH(GNODES,3)=WEIGHT
C         If there's a comma left in CBAG there is at least one more
C         connected node
          IF (INDEX(CBAG,',').GT.0) THEN
            CBAG=CBAG(INDEX(CBAG,',')+2:)
          ELSE
            CONNECTED=.FALSE.
          ENDIF
        ENDDO
      ENDIF
      GOTO 150
  200 CONTINUE
      CLOSE(10)
C     Work out how many bags are inside a single shing gold bag
      TOTAL=SGBCONTAINS(GRAPH,GNODES,SGBNODE)
      WRITE(*,10)" "
      WRITE(*,40)"Bags required inside one shiny gold bag is "
     +           ,TOTAL
      END
C
      RECURSIVE INTEGER FUNCTION 
     +        SGBCONTAINS(GRAPH,GNODES,NODE) RESULT(RES)
      INTEGER GRAPH(1600,3),GNODES,NODE,NEWNODE,TIMES
C
      INTEGER L1
      RES=0
      DO L1=1,GNODES
        IF (GRAPH(L1,1).EQ.NODE) THEN
          NEWNODE=GRAPH(L1,2)
          TIMES=GRAPH(L1,3)
C         Check for leaf (doesn't matter if we don't as NEWNODE and
C         TIMES will be 0 anyway, but that's just a happy coincidence!)
          IF (NEWNODE.NE.0) THEN
C           WRITE(*,*)NODE," contains ",NEWNODE," ",TIMES," times"
            RES=RES+TIMES+TIMES*SGBCONTAINS(GRAPH,GNODES,NEWNODE)
          ENDIF
        ENDIF
      ENDDO
      RETURN
      END
