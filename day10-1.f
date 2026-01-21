      PROGRAM DAY10P1
C
      INTEGER CHARGER(100),HI,NUMCH,J1,J3,L1
   10 FORMAT(A)
   20 FORMAT(I4)
   40 FORMAT(A,I5)
C
      WRITE(*,10)"Advent of Code 2020 day 10, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day10in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      HI=0
      NUMCH=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) CHARGER(NUMCH+1)
      NUMCH=NUMCH+1
      IF (CHARGER(NUMCH).GT.HI) HI=CHARGER(NUMCH)
      GOTO 50
  100 CONTINUE
      CLOSE(10)
C
C     Add in the adapter (HI+3) and outlet (0) joltages
      CHARGER(NUMCH+1)=HI+3
      CHARGER(NUMCH+2)=0
      NUMCH=NUMCH+2
C     Sort the joltages - the only way to meet the critera of using
C     ALL of the chargers.
      CALL HEAPSORT(CHARGER,NUMCH)
C     Count the 1 jolt and 3 jolt differences
      J1=0
      J3=0
      DO L1=1,NUMCH-1
        IF (CHARGER(L1+1)-CHARGER(L1).EQ.1) J1=J1+1
        IF (CHARGER(L1+1)-CHARGER(L1).EQ.3) J3=J3+1
      ENDDO
C
      WRITE(*,40)"1 jolt differences x 3 jolt differences is",J1*J3
      END
C
      SUBROUTINE HEAPSORT(LIST,NUM)
C     O(n log n) sort. Based on Sedgewick, R., Algorithms (1983), p.136.
C     LIST is returned with the first NUM elements sorted
C     in ascending order of their REAL part, expressed as an integer*8
C
      INTEGER LIST(*),NUM
C
      INTEGER T,K,M,N,ONE
C
      N=NUM
      M=N
      ONE=1
      DO K=(M/2),1,-1
        CALL DOWNHEAP(LIST,K,N)
      ENDDO
      DO WHILE (N.GT.1)
        T=LIST(1)
        LIST(1)=LIST(N)
        LIST(N)=T
        N=N-1
        CALL DOWNHEAP(LIST,ONE,N)
      ENDDO
      RETURN
      END
C
      SUBROUTINE DOWNHEAP(LIST,K,N)
      INTEGER LIST(*),K,N
C
      INTEGER V,I,J,R
C
      V=LIST(K)
      R=K
      DO WHILE (R.LE.(N/2))
        J=R+R
        IF (J.LT.N) THEN
          IF (LIST(J).LT.LIST(J+1)) THEN
            J=J+1
          ENDIF
        ENDIF
        IF (V.GE.LIST(J)) GOTO 999
        LIST(R)=LIST(J)
        R=J
      ENDDO
  999 CONTINUE
      LIST(R)=V
      RETURN
      END
