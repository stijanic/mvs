//ALIST    JOB (SYS),'INSTALL ALIST',CLASS=A,MSGCLASS=A
//*
//* ***************************************************************** *
//* INSTALL ALIST COMMAND IN SYS2.CMDLIB (HELP IN SYS2.HELP)          *
//* ***************************************************************** *
//*
//*
//ALIST   EXEC ASMFCL,PARM='LIST,NODECK,LOAD,TERM',
//             MAC1='SYS1.AMODGEN'
//ASM.SYSIN DD *
*
*        %GOTO QDBL1;  /*
         MACRO
         IHAQDB &DSECT=YES    */
*%QDBL1 : ;
*
*/* **************************************************************** */
*/*                                                                  */
*/*                         QUEUE DESCRIPTOR BLOCK                   */
*/*                                                                  */
*/*  OS/VS2 RELEASE 2, 08/02/72, LEVEL=1                             */
*/*                                                                  */
*/*  METHOD OF ACCESS                                                */
*/*      BAL   - DSECT IS PRODUCED UNLESS DSECT=NO IS SPECIFIED.     */
*/*              USING ON QDB GIVES ADDRESSABILITY FOR ALL SYMBOLS.  */
*/*      PL/S  - DCL QDBPTR PTR                                      */
*/*                                                                  */
*/* **************************************************************** */
*%GOTO QDBL2;  /*
         SPACE 1
         AIF ('DSECT' EQ 'NO').QDB10
QDB      DSECT
         AGO   .QDB20
.QDB10    ANOP
         DS    0D
QDB      EQU   *
.QDB20   ANOP
QDBQDB   DS    CL4 -          ACRONYM IN EBCDIC -QDB-
QDBATTR  DS    BL2 -          QUEUE ATTRIBUTES
QDBRV001 DS    H -            RESERVED
QDBNELMS DS    F -            NUMBER OF ELEMENTS ON QUEUE
QDBFELMP DS    A -            POINTER TO FIRST ELEMENT
QDBLELMP DS    A -            POINTER TO LAST ELEMENT
QDBFPTDS DS    H -            FORWARD POINTER DISPLACEMENT
QDBBPTDS DS    H -            BACKWARD POINTER DISPLACEMENT
QDBPRSZ  DS    H -            PRIORITY FIELD SIZE
QDBPRDS  DS    H -            PRIORITY FIELD DISPLACEMENT
QDBRV002 DS    A -            RESERVED
         MEND  , -  */
*%QDBL2 : ;
*
*DECLARE
*  1 QDB     BASED(QDBPTR)  BDY(WORD),
*   2 QDBQDB      CHAR(4) BDY(WORD),     /* ACRONYM IN EBCIDIC -QDB- */
*   2 QDBATTR     CHAR(2),               /* QUEUE ATTRIBUTES         */
*   2 QDBRV001    FIXED(15),             /* RESERVED                 */
*   2 QDBNELMS    FIXED(31),             /* NUMBER OF ELEMENTS ON
*                                           QUEUE                    */
*   2 QDBFELMP    PTR(31),               /* POINTER TO FIRST ELEMENT */
*   2 QDBLELMP    PTR(31),               /* POINTER TO LAST ELEMENT  */
*   2 QDBFPTDS    FIXED(15),             /* FORWARD POINTER
*                                           DISPLACEMENT             */
*   2 QDBBPTDS    FIXED(15),             /* BACKWARD POINTER
*                                           DISPLACEMENT             */
*   2 QDBPRSZ     FIXED(15),             /* PRIORITY FIELD SIZE      */
*   2 QDBPRDS     FIXED(15),             /* PRIORITY FIELD
*                                           DISPLACEMENT             */
*   2 QDBRV002    PTR(31);               /* RESERVED                 */
         MACRO
&LABEL   $PROLOG &LV=0,&GM=Y
.**********************************************************************
.*
.*       THIS MACRO WILL PROVIDE ENTRY LINKAGE AND OPTIONALLY
.*       MULTIPLE BASE REGISTERS.  ALSO, VIA THE 'LV=' KEYWORD
.*       PROVIDE ADDITIONAL USER STORAGE (APPENDED TO THE
.*       SAVE AREA) ADDRESSABLE FROM REG 13.  IF NO OPERANDS
.*       ARE CODED, REG 12 IS ASSUMED THE BASE. EXAMPLE:
.*              SECTNAME $PROLOG          = STANDARD REG 12 BASE
.*              SECTNAME $PROLOG 5        = STANDARD, REG 5 BASE
.*              SECTNAME $PROLOG 10,LV=20 = ADD 20 BYTES TO SAVE AREA
.*                                             REG 10 IS BASE
.*              SECTNAME $PROLOG R10,R11  = REGS 10 AND 11 ARE BASES
.*
.**********************************************************************
         LCLA  &AA,&AB,&AC
         GBLB  &PRORG
         GBLC  &PROGM
&AC      SETA  4096
&LABEL   CSECT
         B     32(R15)             BRANCH AROUND
         DC    AL1(26)
         DC    CL8'&LABEL'         CSECT NAME
         DC    C'-'
         DC    CL8'&SYSDATE'       COMPILE DATE
         DC    C'-'
         DC    CL8'&SYSTIME'       COMPILE TIME
         CNOP  0,4                 ALIGNMENT
         STM   R14,R12,12(R13)     SAVE REGISTERS
         LR    R12,R15             LOAD BASE REG
         USING &LABEL,R12          INFORM ASSEMBLER
         AIF   (&LV GT 4023).MERR
         AIF   ('&GM' EQ 'N').NOGM
&PROGM   SETC  'GETMAIN'
         LA    R0,&LV+72           LOAD REG 0 WITH LENGTH VARIABLE
         GETMAIN R,LV=(0)          GET CORE FOR SAVEAREA AND USER
         AIF   (&LV+72 LE 256).XC2
         AIF   (&LV+72 LE 512).XC1
         MVI   0(R1),X'00'         MOVE X'00' TO FIRST BYTE
         LR    R2,R1               SAVE POINTER IN EVEN REG
         LA    R4,1(R1)            SET RECEIVING POINTER
         LR    R5,R0               SET RECEIVING LENGTH
         BCTR  R5,R0               DECREMENT LENGTH
         LA    R5,0(R5)            CLEAR HIGH ORDER BYTE
         LA    R3,1                SET SENDING LENGTH
         MVCL  R4,R2               INSTRUCTION PADS WITH X'00'
         AGO   .STORE
.XC1     ANOP
         XC    256(&LV-184,R1),256(R1)  CLEAR SAVE AREA
         XC    0(256,R1),0(R1)          CLEAR SAVE AREA
         AGO   .STORE
.XC2     ANOP
         XC    0(&LV+72,R1),0(R1)       CLEAR SAVE AREA
         AGO   .STORE
.NOGM    ANOP
         CNOP  0,4
         LA    R1,SAVE&SYSNDX
         B     *+76
SAVE&SYSNDX DC 18F'0'
.STORE   ANOP
         ST    R13,4(R1)           SAVE BACK CHAIN
         ST    R1,8(R13)           SET FORWARD CHAIN
         LR    R11,R1              SAVE NEW SAVEAREA ADDRESS
         L     R15,16(R13)         RESTORE REG 15
         ST    R0,16(R13)          SAVE SAVEAREA LENGTH
         LM    R0,R1,20(R13)       RESTORE REGS USED IN GETMAIN
         LR    R13,R11             SET SAVEAREA POINTER
         AIF   (N'&SYSLIST EQ 0).MEND
         AIF   ('&SYSLIST(1)' EQ 'R12').SKIPIT
         AIF   ('&SYSLIST(1)' EQ '12').SKIPIT
         LA    &SYSLIST(1),&LABEL  LOAD REQUESTED BASE REG
         DROP  R12                 DROP ASSUMED BASE REG
         USING &LABEL,&SYSLIST(1)  INFORM ASSEMBLER
.SKIPIT  ANOP
&AA      SETA  2
.LOOP    ANOP
         AIF   (&AA GT N'&SYSLIST).MEXIT
&AB      SETA  &AA-1
         LA    &SYSLIST(&AA),2048(&SYSLIST(&AB))  LOAD NEXT BASE REG
         LA    &SYSLIST(&AA),2048(&SYSLIST(&AA))  LOAD NEXT BASE REG
         USING &LABEL+&AC,&SYSLIST(&AA) INFORM ASSEMBLER
&AC      SETA  &AC+4096
&AA      SETA  &AA+1
         AGO   .LOOP
.MEXIT   ANOP
         AIF   (&PRORG).MEX2
         SPACE
         $REGS
         SPACE
.MEX2    ANOP
&AA      SETA  &LV+72
         MNOTE *,'TOTAL STORAGE AREA RECEIVED = &AA'
         MEXIT
.MEND    ANOP
         MNOTE *,'NO REGISTER SPECIFIED - R12 ASSUMED'
         AGO   .MEXIT
.MERR    ANOP
         MNOTE 12,'LV > 4023 - REQUEST IGNORED'
         AGO   .MEXIT
         MEND
         MACRO
&LABEL   $EPILOG &RC
         GBLC  &PROGM
&LABEL   LR    R1,R13              GET SAVEAREA ADDRESS
         L     R13,4(R13)          GET BACK CHAIN POINTER
         AIF   ('&PROGM' NE 'GETMAIN').NOFREE
         L     R0,16(R13)          GET SAVEAREA LENGTH
         ST    R15,16(R13)         SAVE REGISTER 15 (RETCODE)
         FREEMAIN R,LV=(0),A=(1)   FREE SAVEAREA
         AGO   .LM
.NOFREE  ANOP
         ST    R15,16(R13)         SAVE REGISTER 15 (RETCODE)
.LM      ANOP
         LM    R14,R12,12(R13)     RESTORE CALLERS REGS
         AIF   (T'&RC EQ 'O').SPEC
         LA    R15,&RC             SET RETURN CODE
.SPEC    ANOP
         BR    R14                 RETURN TO CALLER
         MEND
         MACRO
         $REGS
         GBLB  &PRORG
         AIF   (&PRORG).MEX2
&PRORG   SETB  1
 SPACE
R0       EQU   0
R1       EQU   1
R2       EQU   2
R3       EQU   3
R4       EQU   4
R5       EQU   5
R6       EQU   6
R7       EQU   7
R8       EQU   8
R9       EQU   9
R10      EQU   10
R11      EQU   11
R12      EQU   12
R13      EQU   13
R14      EQU   14
R15      EQU   15
 SPACE
REG0     EQU   0
REG1     EQU   1
REG2     EQU   2
REG3     EQU   3
REG4     EQU   4
REG5     EQU   5
REG6     EQU   6
REG7     EQU   7
REG8     EQU   8
REG9     EQU   9
REG10    EQU   10
REG11    EQU   11
REG12    EQU   12
REG13    EQU   13
REG14    EQU   14
REG15    EQU   15
 SPACE
.MEX2    ANOP
       MEND
         MACRO
&NAME    TPT   &A,&B
         LCLC  &X
&X       SETC  'L'''
&NAME    LA    1,&A
         AIF   ('&B' NE '').GENB
         LA    0,&X&A
         AGO   .TPT
.GENB    LA    0,&B
.TPT     TPUT  (1),(0),R
         MEND
         TITLE 'LISTALC REPLACEMENT'
*-------------------------------------------------------------------*
* AUTHOR:      LIONEL DYCK                                          *
*              ROCKWELL INTERNATIONAL                               *
*              PO BOX 2515                                          *
*              2201 SEAL BEACH BLVD.                                *
*              SEAL BEACH, CALIF  90740                             *
*              MAIL CODE 110-SH28                                   *
*              PHONE (213) 594-1125                                 *
*              COMNET 374-1125                                      *
*-------------------------------------------------------------------*
ALIST    $PROLOG
         L     R1,CVTPTR           -> CVT
         USING CVT,R1
         L     R1,CVTTCBP          -> TCB WORDS
         L     R1,4(R1)            -> MY TCB
         USING TCB,R1
         L     R1,TCBJSCB          -> JSCB
         USING IEZJSCB,R1
         L     R1,JSCDSABQ        -> QDB
         USING QDB,R1
         L     R6,QDBFELMP         -> DSAB Q
         USING DSAB,R6
*        CHECK DSORG
LOOP     TM    DSABORG1,DSABIS
         BO    IS
         TM    DSABORG1,DSABPS
         BO    PS
         TM    DSABORG1,DSABDA
         BO    DA
         TM    DSABORG1,DSABPO
         BO    PO
         MVC   DSORG,=C'??'
         B     CKALLOC
PO       MVC   DSORG,=C'PO'
         B     CKALLOC
DA       MVC   DSORG,=C'DA'
         B     CKALLOC
IS       MVC   DSORG,=C'IS'
         B     CKALLOC
PS       MVC   DSORG,=C'PS'
         B     CKALLOC
CKALLOC  EQU   *
         TM    DSABFLG1,DSABDALC
         BO    DALC
         TM    DSABFLG1,DSABPALC
         BO    PALC
         TM    DSABFLG1,DSABDCNV
         BO    DCNV
         TM    DSABFLG1,DSABCONV
         BO    CONV
         TM    DSABFLG1,DSABDCAT
         BO    DCAT
         TM    DSABFLG1,DSABPCAT
         BO    PCAT
         TM    DSABFLG1,DSABNUSE
         BO    NUSE
         TM    DSABFLG1,DSABCATM
         BO    CATM
         MVC   ALLF,=C'????'
         B     CKDD
DALC     MVC   ALLF,=CL4'DYN'
         B     CKDD
PALC     MVC   ALLF,=CL4'PERM'
         B     CKDD
DCNV     MVC   ALLF,=CL4'DCNV'
         B     CKDD
CONV     MVC   ALLF,=CL4'CONV'
         B     CKDD
DCAT     MVC   ALLF,=CL4'DCON'
         B     CKDD
PCAT     MVC   ALLF,=CL4'PCON'
         B     CKDD
CATM     MVC   ALLF,=CL4'CMEM'
         B     CKDD
NUSE     MVC   ALLF,=CL4'NUSE'
         B     CKDD
CKDD     EQU   *
         L     R7,DSABRS01         -> SIOT
         LA    R7,16(R7)           -> PREFIX
         USING INDMSIOT,R7
MVDDN    MVC   DDNAME,SCTDDNAM
         L     R8,SJFCBPTR         -> JFCB
         USING JFCB,R8
         TM    SIOTTSTC,SIOTTERM IS IT A TERMINAL
         BZ    MVDSN            NO
         MVC   DSN(8),=C'TERMINAL'
         B     DODISP
MVDSN    MVC   DSN,JFCBDSNM
         TM    JFCBIND1,JFCPDS
         BZ    CKDISP
         LA    R1,DSN
         LA    R2,32
BLP      CLC   0(2,R1),BLANKS
         BE    MVMEM
         LA    R1,1(R1)
         BCT   R2,BLP
MVMEM    MVI   0(R1),C'('
         MVC   1(8,R1),JFCBELNM
         MVI   9(R1),C')'
CKDISP   EQU   *
         TM    JFCBIND2,JFCTEMP
         BO    TEMP
         TM    JFCBIND2,JFCNEW
         BO    NEW
         TM    JFCBIND2,JFCMOD
         BO    MOD
         TM    JFCBIND2,JFCSHARE
         BO    SHR
         TM    JFCBIND2,JFCOLD
         BO    OLD
         MVC   DISP,=CL3'???'
         B     CKVOL
NEW      MVC   DISP,=CL3'NEW'
         B     CKVOL
OLD      MVC   DISP,=CL3'OLD'
         B     CKVOL
MOD      MVC   DISP,=CL3'MOD'
         B     CKVOL
SHR      MVC   DISP,=CL3'SHR'
         B     CKVOL
TEMP     MVC   DISP,=CL3'TMP'
         B     CKVOL
CKVOL    EQU   *
         MVC   VOL,JFCBVOLS
DODISP   TPT   MSG
         MVC   MSG,BLANKS
         L     R6,DSABFCHN
         LTR   R6,R6
         BNZ   LOOP
END      $EPILOG 0
         LTORG
MSG      DC    CL80' '
         ORG   MSG+1
DDNAME   DC    CL8' ',C' '
DSORG    DC    CL2' ',C' '
ALLF     DC    CL4' ',C' '
DISP     DC    CL3' ',C' '
VOL      DC    CL6' ',C' '
DSN      DC    CL44' ',CL2' '
MEM      DC    CL8' ',C' '
         ORG
BLANKS   DC    CL80' '
         EJECT
*        PRINT NOGEN
JFCB     DSECT
         IEFJFCBN
         CVT   DSECT=YES
         DSECT
         IKJTCB
         DSECT
         IEZJSCB
         DSECT
         IHADSAB
         DSECT
         IHAQDB
         DSECT
         IEFASIOT
         END
/*
//ASM.SYSTERM DD SYSOUT=*
//LKED.SYSLMOD DD DSN=SYS2.CMDLIB,DISP=SHR
//LKED.SYSIN DD *
  NAME ALIST(R)
/*
//HELP    EXEC PGM=IEBUPDTE,PARM=NEW,COND=(0,NE)
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DISP=SHR,DSN=SYS2.HELP
//SYSIN    DD  *
./ ADD NAME=ALIST
)F ALIST FUNCTIONS -
          THE ALIST COMMAND WILL LIST ALL ALLOCATED FILES FOR
          YOUR TSO SESSION IN THE FOLLOWING FORMAT:

              SYSHELP  PO PERM SHR MVSRES SYS1.HELP
                       ?? PERM SHR PUB001 SYS2.HELP
              SYSUT1   PO DYN  OLD SYSP01 SYSP.INSTALL.DOCS

          FIELDS SHOWN ARE DDNAME, DSORG, ALLOCATION TYPE,
          VOLUME SERIAL NUMBER, AND DATASET NAME.

)X SYNTAX -
          ALIST
)O OPERANDS -
          ALIST COMMAND TAKES NO OPERANDS
./ ENDUP
/*
