      PROGRAM DAY11P1
      INTEGER SZ
C     Set the parameter SZ to be the (square) grid size + 2
C     Will also work for smaller grids with a large parameter, but
C     if PRINTGRID is used the output will look messy. 
      PARAMETER(SZ=100)
C
      CHARACTER*100 ROW
      INTEGER GRID(100,100),ROWNO,OCCUPIED,L1,L2
      INTEGER COUNTGRID
      LOGICAL*1 CHANGED
C
   10 FORMAT(A)
   20 FORMAT(A)
   40 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 11, part 1"
      WRITE(*,10)" "
C
C     Initialise the grid as all floor (0)
C     Empty seat = -1, Occupied seat = +1
C
      DO L1=1,SZ
        DO L2=1,SZ
          GRID(L1,L2)=0
        ENDDO
      ENDDO
      ROWNO=1
C
      OPEN(10,FILE="day11in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) ROW
      ROWNO=ROWNO+1
      L1=1
      DO WHILE (ROW(L1:L1).NE.' ')
        IF (ROW(L1:L1).EQ.'L') GRID(ROWNO,L1+1)=-1
        L1=L1+1
      ENDDO
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      CHANGED=.TRUE.
      DO WHILE (CHANGED)
C       CALL PRINTGRID(GRID,SZ,SZ)
C       WRITE(*,10)" "
        CALL DORULES(GRID,SZ,SZ,CHANGED)
      ENDDO
      OCCUPIED=COUNTGRID(GRID,SZ,SZ)
      WRITE(*,40)"Number of occupied seats stabilises at ",OCCUPIED
      END
C
      INTEGER FUNCTION COUNTGRID(GRID,MAXX,MAXY)
      INTEGER GRID(100,100),MAXX,MAXY
C
      INTEGER L1,L2
C
      COUNTGRID=0
      DO L1=2,MAXX-1
        DO L2=2,MAXY-1
          IF (GRID(L1,L2).EQ.1) COUNTGRID=COUNTGRID+1
        ENDDO
      ENDDO
C
      RETURN
      END
C     
      SUBROUTINE DORULES(GRID,MAXX,MAXY,CHG)
      INTEGER GRID(100,100),MAXX,MAXY
      LOGICAL*1 CHG
C
      INTEGER OLDGRID(100,100),L1,L2,OCC
C
      CHG=.FALSE.
      OLDGRID=GRID
      DO L1=2,MAXX-1
        DO L2=2,MAXY-1
          IF (OLDGRID(L1,L2).EQ.-1) THEN
            IF ((OLDGRID(L1-1,L2-1).NE.1).AND.
     +          (OLDGRID(L1-1,L2).NE.1).AND.
     +          (OLDGRID(L1-1,L2+1).NE.1).AND.
     +          (OLDGRID(L1,L2+1).NE.1).AND.
     +          (OLDGRID(L1+1,L2+1).NE.1).AND.
     +          (OLDGRID(L1+1,L2).NE.1).AND.
     +          (OLDGRID(L1+1,L2-1).NE.1).AND.
     +          (OLDGRID(L1,L2-1).NE.1)) THEN
               CHG=.TRUE.
               GRID(L1,L2)=1
             ENDIF
          ELSE IF (OLDGRID(L1,L2).EQ.1) THEN
            OCC=0
            IF (OLDGRID(L1-1,L2-1).EQ.1) OCC=OCC+1
            IF (OLDGRID(L1-1,L2).EQ.1) OCC=OCC+1
            IF (OLDGRID(L1-1,L2+1).EQ.1) OCC=OCC+1
            IF (OLDGRID(L1,L2+1).EQ.1) OCC=OCC+1
            IF (OLDGRID(L1+1,L2+1).EQ.1) OCC=OCC+1
            IF (OLDGRID(L1+1,L2).EQ.1) OCC=OCC+1
            IF (OLDGRID(L1+1,L2-1).EQ.1) OCC=OCC+1
            IF (OLDGRID(L1,L2-1).EQ.1) OCC=OCC+1
            IF (OCC.GE.4) THEN
              CHG=.TRUE.
              GRID(L1,L2)=-1
            ENDIF
          ENDIF
        ENDDO
      ENDDO
C
      RETURN
      END
C     
      SUBROUTINE PRINTGRID(GRID,MAXX,MAXY)
      INTEGER GRID(100,100),MAXX,MAXY
C
      INTEGER L1,L2
   30 FORMAT(100I2)
C
      DO L1=1,MAXX
        WRITE(*,30) (GRID(L1,L2),L2=1,MAXY)
      ENDDO
C
      RETURN
      END
