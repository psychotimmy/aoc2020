      PROGRAM DAY21P1
C
      CHARACTER*800 LINE,INGLIST,ALGLIST
      CHARACTER*32 INGRLU(200),ALGLU(8)
      INTEGER FOODAL(8),FOODNO,ALLERGENS(8)
      INTEGER ALGVSING(8,2000)
      INTEGER NOING,NOALG,TOTAL,COUNTALLERGENFREE
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I2,A,2000I4)
   40 FORMAT(A,I7,A)
C
      WRITE(*,10)"Advent of Code 2020 day 21, part 1"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day21in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      NOING=0
      NOALG=0
      ALGVSING=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      INGLIST=LINE(1:INDEX(LINE,'(')-1)
      ALGLIST=LINE(INDEX(LINE,'contains')+9:)
      CALL PROCESSA(ALGLIST,NOALG,ALGLU,FOODAL,FOODNO)
      CALL PROCESSI(INGLIST,NOING,INGRLU,ALGVSING,FOODAL,FOODNO)
      GOTO 50
  100 CONTINUE
      CLOSE(10)
C     DO L1=1,8
C       WRITE(*,30)L1,":",(ALGVSING(L1,L2),L2=1,2000)
C     ENDDO
      CALL IDENTIFYALLERGENS(ALGVSING,NOING,NOALG,ALLERGENS)
C     DO L1=1,NOALG
C       WRITE(*,30)L1," allergen is in ingredient",ALLERGENS(L1)
C     ENDDO
      TOTAL=COUNTALLERGENFREE(ALLERGENS,NOALG,INGRLU,NOING)
      WRITE(*,40)"Allergen free ingredients appear",TOTAL,
     +           " times in all ingredient lists"
      END
C
      INTEGER FUNCTION COUNTALLERGENFREE(ALLERGENS,NA,INGRLU,NI)
      INTEGER ALLERGENS(*),NA,NI,L1,SEP,ALLING
      CHARACTER*32 INGRLU(*),CHECKIT
      CHARACTER*800 FOOD
      LOGICAL ALLER
C
      COUNTALLERGENFREE=0
   10 FORMAT(A)
      OPEN(10,FILE="day21in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
   50 CONTINUE
      READ(10,FMT=10,ERR=100,END=100) FOOD
C     Remove (contains ...) - not needed as we know the allergenic
C     ingredients now
      SEP=INDEX(FOOD,'(')
      FOOD=FOOD(1:SEP-1)
      DO WHILE (FOOD(1:1).NE.' ')
        SEP=INDEX(FOOD,' ')
        CHECKIT(:SEP-1)=FOOD(:SEP-1)
        ALLER=.FALSE.
        DO L1=1,NA
          ALLING=ALLERGENS(L1)
C         WRITE(*,*)INGRLU(ALLING)(1:INDEX(INGRLU(ALLING),' ')-1)
          IF (CHECKIT(:SEP-1).EQ.
     +      INGRLU(ALLING)(1:INDEX(INGRLU(ALLING),' ')-1))
     +      ALLER=.TRUE.
        ENDDO
        IF (.NOT.ALLER) COUNTALLERGENFREE=COUNTALLERGENFREE+1
        FOOD=FOOD(SEP+1:)
      ENDDO
      GOTO 50
  100 CONTINUE
      CLOSE(10)
      RETURN
      END
C
      SUBROUTINE IDENTIFYALLERGENS(AVI,NI,NA,ALLERGENS)
      INTEGER AVI(8,2000),CMAX(4,8),CURR(8,200)
      INTEGER NI,NA,ALLDONE,ALLERGENS(*)
C
   10 FORMAT(8I4)
      CURR=0
      CMAX=0
      DO L1=1,NA
        L2=1
        DO WHILE (AVI(L1,L2).NE.0)
          CURR(L1,AVI(L1,L2))=CURR(L1,AVI(L1,L2))+1
          L2=L2+1
        ENDDO
      ENDDO
C     DO L1=1,NI
C       WRITE(*,10)(CURR(L2,L1),L2=1,8)
C     ENDDO
C     If there is a clear winner in a column for an allergen, that's
C     the ingredient that contains the allergen. May need 8 iterations
C     (= number of allergens in the puzzle input) to resolve
      ALLDONE=0
      DO WHILE (ALLDONE.NE.NA)
        DO L1=1,NA
          CMAX(1,L1)=0
          CMAX(2,L1)=0
          CMAX(3,L1)=0
          DO L2=1,NI
            IF (CURR(L1,L2).EQ.CMAX(1,L1)) CMAX(3,L1)=0
            IF (CURR(L1,L2).GT.CMAX(1,L1)) THEN
              CMAX(1,L1)=CURR(L1,L2)
              CMAX(2,L1)=L2
C             (3,L1) used to indicate we have a unique high value (1,L1)
C             for this ingredient number (2,L1) 
              CMAX(3,L1)=1
            ENDIF
          ENDDO
        ENDDO
C       Zap unique ingredients from the other allergens
        DO L1=1,8
          IF ((CMAX(3,L1).EQ.1).AND.(CMAX(4,L1).EQ.0)) THEN
C           WRITE(*,*)"Column",L1," has unique max",CMAX(1,L1),
C    +                " for ingredient",CMAX(2,L1)
            ALLDONE=ALLDONE+1
            CMAX(4,L1)=1
C           Set count to zero - means it won't be considered again as
C           there is only 1 indgredient with each allergen
            DO L2=1,NA
              CURR(L2,CMAX(2,L1))=0
            ENDDO
C           Store allergen number in the return array
            ALLERGENS(ALLDONE)=CMAX(2,L1)
          ENDIF
        ENDDO
      ENDDO
      RETURN
      END
C
      SUBROUTINE PROCESSA(ALIST,N,ALOOKUP,FOODAL,FOODNO)
      CHARACTER*(*) ALIST
      CHARACTER*32 ALOOKUP(*),ASTR
      INTEGER N,SEP,L1,FOODAL(*),FOODNO
      CHARACTER*32 ALLERGEN
      LOGICAL NEW
C
      FOODNO=0
      DO WHILE (ALIST(1:1).NE.' ')
        SEP=INDEX(ALIST,',')
        IF (SEP.EQ.0) THEN
          SEP=INDEX(ALIST,')')
          IF (SEP.EQ.0) THEN
            WRITE(*,*)"Malformed allergen list"
            STOP 8
          ENDIF
        ENDIF
        ASTR=ALIST(1:SEP-1)
        ALIST=ALIST(SEP+2:)
C       Only add allergen to the lookup array if not already seen
        NEW=.TRUE.
        DO L1=1,N
          IF (ALOOKUP(L1).EQ.ASTR) NEW=.FALSE.
        ENDDO
        IF (NEW) THEN
          N=N+1
          ALOOKUP(N)=ASTR
        ENDIF
C       Convert this allergen name back to a number from the lookup
        DO L1=1,N
          IF (ALOOKUP(L1).EQ.ASTR) THEN
            FOODNO=FOODNO+1
            FOODAL(FOODNO)=L1
          ENDIF
        ENDDO
      ENDDO
      RETURN
      END
C
      SUBROUTINE PROCESSI(ILIST,N,ILOOKUP,ALGVSING,FOODAL,FOODNO)
      CHARACTER*(*) ILIST
      CHARACTER*32 ILOOKUP(*),INGSTR
      INTEGER N,SEP,ALGVSING(8,2000),L1,L2,FOODAL(*),FOODNO,INGNO
      LOGICAL NEW
C
      DO WHILE(ILIST(1:1).NE.' ')
        SEP=INDEX(ILIST,' ')
        INGSTR=ILIST(1:SEP-1)
        ILIST=ILIST(SEP+1:)
C       Only add ingredient to the lookup array if not already seen
        NEW=.TRUE.
        DO L1=1,N
          IF (ILOOKUP(L1).EQ.INGSTR) THEN
            NEW=.FALSE.
            INGNO=L1
          ENDIF
        ENDDO
        IF (NEW) THEN
          N=N+1
          ILOOKUP(N)=INGSTR
          INGNO=N
        ENDIF
C       Add the converted ingredient to the possible allergen lists
C       if it isn't already in the list
        DO L1=1,FOODNO
          L2=1
          DO WHILE ((ALGVSING(FOODAL(L1),L2)).NE.0)
            L2=L2+1
          ENDDO
          ALGVSING(FOODAL(L1),L2)=INGNO
        ENDDO
      ENDDO
      RETURN
      END
