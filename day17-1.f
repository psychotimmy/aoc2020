      PROGRAM DAY17P1
C
      CHARACTER*10 ROW
      INTEGER GRID(0:50,0:50,0:50),MINX,MINY,MINZ,MAXX,MAXY,MAXZ,NC
C                      X   Y   Z
      INTEGER OX,OY,OZ,ROWN,COLN,COUNTGRID
C
C     Start in the middle of the space - saves dealing with negative
C     indices. Keep a track of the min/max X,Y,Z co-ordinates to 
C     reduce the search time and detect if we go below 1 in any
C     direction
      DATA OX,OY,OZ,MINX,MINY,MINZ /25,25,25,25,25,25/
      DATA MAXX,MAXY,MAXZ /25,25,25/
C
   10 FORMAT(A)
   20 FORMAT(A)
   40 FORMAT(A,I6)
C
      WRITE(*,10)"Advent of Code 2020 day 17, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day17in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
C
      ROWN=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100)ROW
      COLN=0
      DO WHILE (ROW(COLN+1:COLN+1).NE.' ')
        IF (ROW(COLN+1:COLN+1).EQ.'#') THEN 
          IF ((OX+ROWN).GT.MAXX) MAXX=OX+ROWN
          IF ((OY+COLN).GT.MAXY) MAXY=OY+COLN
          GRID((OX+ROWN),(OY+COLN),OZ)=1
        ELSE
          GRID((OX+ROWN),(OY+COLN),OZ)=0
        ENDIF
        COLN=COLN+1
      ENDDO
      ROWN=ROWN+1
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      NC=COUNTGRID(GRID,MINX,MINY,MINZ,MAXX,MAXY,MAXZ)
      WRITE(*,40)"Number of Conway Cubes at start is ",NC
      DO L1=1,6
        CALL GENERATE(GRID,MINX,MINY,MINZ,MAXX,MAXY,MAXZ)
C       NC=COUNTGRID(GRID,MINX,MINY,MINZ,MAXX,MAXY,MAXZ)
C       WRITE(*,*)L1,NC
      ENDDO
      NC=COUNTGRID(GRID,MINX,MINY,MINZ,MAXX,MAXY,MAXZ)
      WRITE(*,40)"Number of Conway Cubes after 6 generations is ",NC
      END
C
      SUBROUTINE GENERATE(GRID,XL,YL,ZL,XH,YH,ZH)
      INTEGER GRID(0:50,0:50,0:50),XL,YL,ZL,XH,YH,ZH
      INTEGER OLDGRID(0:50,0:50,0:50)
      INTEGER OFFSETS(81),X,Y,Z,OFF,NEIGH
      DATA OFFSETS 
     +/-1,-1,-1,-1,0,-1,-1,1,-1,0,-1,-1,0,0,-1,0,1,-1,1,-1,-1,1,0,-1,
     +  1,1,-1,
     + -1,-1,0,-1,0,0,-1,1,0,0,-1,0,0,0,0,0,1,0,1,-1,0,1,0,0,1,1,0,
     + -1,-1,1,-1,0,1,-1,1,1,0,-1,1,0,0,1,0,1,1,1,-1,1,1,0,1,1,1,1/
C
      OLDGRID=GRID
      DO X=XL-1,XH+1
        DO Y=YL-1,YH+1
          DO Z=ZL-1,ZH+1
            IF (OLDGRID(X,Y,Z).EQ.1) THEN
              NEIGH=-1  
              DO OFF=1,81,3
                IF (OLDGRID(X+OFFSETS(OFF),
     +                      Y+OFFSETS(OFF+1),
     +                      Z+OFFSETS(OFF+2)).EQ.1) THEN
                  NEIGH=NEIGH+1
                ENDIF
              ENDDO
              IF ((NEIGH.NE.2).AND.(NEIGH.NE.3)) THEN
                GRID(X,Y,Z)=0
              ENDIF
            ELSE
              NEIGH=0 
              DO OFF=1,81,3
                IF (OLDGRID(X+OFFSETS(OFF),
     +                      Y+OFFSETS(OFF+1),
     +                      Z+OFFSETS(OFF+2)).EQ.1) THEN
                  NEIGH=NEIGH+1
                ENDIF
              ENDDO
              IF (NEIGH.EQ.3) THEN
                GRID(X,Y,Z)=1
              ENDIF
            ENDIF
          ENDDO
        ENDDO
      ENDDO
C     Expand the grid by 1 in all directions. Not perfect (as it may
C     be too big, but never too small) but good enough for 6 generations
      XL=XL-1
      YL=YL-1
      ZL=ZL-1
      XH=XH+1
      YH=YH+1
      ZH=ZH+1
C
      RETURN
      END
C
      INTEGER FUNCTION COUNTGRID(GRID,XL,YL,ZL,XH,YH,ZH)
      INTEGER GRID(0:50,0:50,0:50),XL,YL,ZL,XH,YH,ZH
      INTEGER X,Y,Z
      COUNTGRID=0
      DO X=XL,XH
        DO Y=YL,YH
          DO Z=ZL,ZH
            IF (GRID(X,Y,Z).EQ.1) COUNTGRID=COUNTGRID+1
          ENDDO
        ENDDO
      ENDDO
      RETURN
      END
