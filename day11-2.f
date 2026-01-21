      PROGRAM DAY11P2
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
      WRITE(*,10)"Advent of Code 2020 day 11, part 2"
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
      LOGICAL*1 AGAIN
      INTEGER OLDGRID(100,100),L1,L2,L3,OCC,X,Y,OK8
      INTEGER DIR(2,8)
C     Note that Fortran 2D arrays are in column-major order
      DATA DIR /-1,-1,-1,0,-1,1,0,-1,0,1,1,-1,1,0,1,1/
C
      CHG=.FALSE.
      OLDGRID=GRID
      DO L1=2,MAXX-1
        DO L2=2,MAXY-1
          IF (OLDGRID(L1,L2).EQ.-1) THEN
            OK8=0
            DO L3=1,8
              X=L1
              Y=L2
              AGAIN=.TRUE.
              DO WHILE (AGAIN)
                X=X+DIR(1,L3) 
                Y=Y+DIR(2,L3) 
C               Unoccupied seat or border seen
                IF ((OLDGRID(X,Y).EQ.-1).OR.(X.EQ.1)
     +                                  .OR.(Y.EQ.1) 
     +                                  .OR.(X.EQ.MAXX)
     +                                  .OR.(Y.EQ.MAXY)) THEN
                  AGAIN=.FALSE.
                  OK8=OK8+1
C               Occupied seat seen
                ELSE IF (OLDGRID(X,Y).EQ.1) THEN
                  AGAIN=.FALSE.
                ENDIF
              ENDDO
            ENDDO
C           If we have a newly occupied seat the grid has changed
            IF (OK8.EQ.8) THEN
              CHG=.TRUE.
              GRID(L1,L2)=1
            ENDIF
          ELSE IF (OLDGRID(L1,L2).EQ.1) THEN
            OCC=0
            DO L3=1,8
              X=L1
              Y=L2
              AGAIN=.TRUE.
              DO WHILE (AGAIN)
                X=X+DIR(1,L3) 
                Y=Y+DIR(2,L3) 
C               Border or unoccupied seat seen
                IF ((OLDGRID(X,Y).EQ.-1).OR.
     +              (X.EQ.1).OR.
     +              (Y.EQ.1).OR. 
     +              (X.EQ.MAXX).OR.
     +              (Y.EQ.MAXY)) THEN
                  AGAIN=.FALSE.
C               Occupied seat seen
                ELSE IF (OLDGRID(X,Y).EQ.1) THEN
                  OCC=OCC+1
                  AGAIN=.FALSE.
                ENDIF
              ENDDO
            ENDDO
C           If there are 5 or more occupied seats in view we vacate
C           this seat and the grid has changed
            IF (OCC.GE.5) THEN
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
