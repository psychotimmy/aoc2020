      PROGRAM DAY8P2
C
      CHARACTER*80 LINE
      INTEGER PGM(640,3),PGMSAFE(640,3),PGL,ACC,RUNBOOT
      INTEGER NEXTCHANGE,L1
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I4)
   40 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 8, part 2"
      WRITE(*,10)" "
C
      OPEN(10,FILE="day8in.txt",STATUS="OLD",FORM="FORMATTED",
     +     ACCESS="SEQUENTIAL",ACTION="READ")
      PGL=0
   50 CONTINUE
      READ(10,FMT=20,ERR=100,END=100) LINE
      PGL=PGL+1
C     Convert the instruction to a number
      IF (LINE(1:3).EQ.'acc') PGM(PGL,1)=1
      IF (LINE(1:3).EQ.'jmp') PGM(PGL,1)=2
      IF (LINE(1:3).EQ.'nop') PGM(PGL,1)=3
C     Store the value associated with the instuction
      READ(LINE(5:),30) PGM(PGL,2)
C     Set the number of times this instruction has executed to 0
      PGM(PGL,3)=0
      GOTO 50
  100 CONTINUE
      CLOSE(10)
C     Mark the location after the last real instruction with 999 as the
C     'halt' instruction number with 0 values for the other two elements
      PGM(PGL+1,1)=999
      PGM(PGL+1,2)=0
      PGM(PGL+1,3)=0
C     Save a copy of the original program
      PGMSAFE=PGM
C
      ACC=0
      PGL=1
      NEXTCHANGE=1
C     PGL=0 means success, -1 means failure
      DO WHILE (PGL.NE.0)
        PGL=RUNBOOT(PGM,PGL,ACC)
        IF (PGL.EQ.-1) THEN
          WRITE(*,40)"Failed with accumulator value ",ACC
          WRITE(*,*)"Reprogramming line ",NEXTCHANGE," ..."
          ACC=0
          PGL=1
          PGM=PGMSAFE
          IF (PGM(NEXTCHANGE,1).EQ.2) THEN
            PGM(NEXTCHANGE,1)=3
          ELSE IF (PGM(NEXTCHANGE,1).EQ.3) THEN
            PGM(NEXTCHANGE,1)=2
          ENDIF
C         Somewhat inefficient as the program will be identical
C         if the next instruction to 'change' was an acc ...
          NEXTCHANGE=NEXTCHANGE+1
        ENDIF
      ENDDO
      WRITE(*,10)" "
      WRITE(*,40)
     +  "Accumulator value after successful run was ",ACC
      END
C
      INTEGER FUNCTION RUNBOOT(PGM,PGL,ACC)
      INTEGER PGM(640,3),PGL,ACC
C
C     Check if this instruction has already been executed
C     WRITE(*,*)"Executing ",PGM(PGL,1),PGM(PGL,2),PGM(PGL,3)
      IF (PGM(PGL,3).NE.0) THEN
        RUNBOOT=-1
      ELSE
        PGM(PGL,3)=PGM(PGL,3)+1
C       acc
        IF (PGM(PGL,1).EQ.1) THEN
          ACC=ACC+PGM(PGL,2)
          RUNBOOT=PGL+1
C       jmp
        ELSE IF (PGM(PGL,1).EQ.2) THEN
          RUNBOOT=PGL+PGM(PGL,2)
        ELSE IF (PGM(PGL,1).EQ.3) THEN
C       nop
          RUNBOOT=PGL+1
C       successful halt
        ELSE IF (PGM(PGL,1).EQ.999) THEN
          RUNBOOT=0
C       shouldn't get here!
        ELSE
          STOP 8
        ENDIF
      ENDIF
C
      RETURN
      END
