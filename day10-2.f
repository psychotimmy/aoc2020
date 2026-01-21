      PROGRAM DAY10P2
C
      INTEGER CHARGER(100),HI,NUMCH,START,SINDEX,FIN
      INTEGER*8 TOTAL,MEMO(100)
   10 FORMAT(A)
   20 FORMAT(I4)
   40 FORMAT(A,I14)
C
      WRITE(*,10)"Advent of Code 2020 day 10, part 2"
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
C     Sort the joltages
      CALL HEAPSORT(CHARGER,NUMCH)
C     Find all of the possible charger arrangements that satisfy the
C     condition that all connections must be within 3 jolts AND that
C     connect the outlet to the adapter
      SINDEX=1
      START=CHARGER(SINDEX)
      FIN=CHARGER(NUMCH)
      TOTAL=0
      DO L1=1,100
        MEMO(L1)=0
      ENDDO
      CALL FINDALL(CHARGER,NUMCH,START,SINDEX,FIN,TOTAL,MEMO)
      WRITE(*,40)"Number of possible arrangements is",TOTAL
      END
C
      RECURSIVE SUBROUTINE FINDALL(CHARGER,N,S,SI,F,TOTAL,MEMO)
      INTEGER CHARGER(*),N,S,SI,F
      INTEGER*8 TOTAL,MEMO(*)
C
      INTEGER L1,CP,NEWSTART,NEWSI
C
      IF (S.EQ.F) THEN
        TOTAL=TOTAL+1
      ELSE
        L1=SI+1
        DO WHILE ((CHARGER(L1).LE.CHARGER(SI)+3).AND.(L1.LE.N))
          NEWSI=L1
          NEWSTART=CHARGER(NEWSI)
C         Need a memo otherwise the runtime is "heat death of the universe"
          IF (MEMO(NEWSI).GT.0) THEN
            TOTAL=TOTAL+MEMO(NEWSI)
          ELSE
            CALL FINDALL(CHARGER,N,NEWSTART,NEWSI,F,TOTAL,MEMO)
            MEMO(NEWSI)=TOTAL
          ENDIF
          L1=L1+1
        ENDDO
      ENDIF
C
      RETURN
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
