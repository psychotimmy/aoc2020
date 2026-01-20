      PROGRAM DAY8P1
C
      CHARACTER*80 LINE
      INTEGER PGM(640,3),PGL,ACC,RUNBOOT
C
   10 FORMAT(A)
   20 FORMAT(A)
   30 FORMAT(I4)
   40 FORMAT(A,I4)
C
      WRITE(*,10)"Advent of Code 2020 day 8, part 1"
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
C
      ACC=0
      PGL=1
      DO WHILE (PGL.NE.-1)
        PGL=RUNBOOT(PGM,PGL,ACC)
      ENDDO
      WRITE(*,40)
     +  "Accumulator value before first repeated instruction was ",ACC
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
        ELSE
C       nop
          RUNBOOT=PGL+1
        ENDIF
      ENDIF
C
      RETURN
      END
