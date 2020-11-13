//HWFULL   JOB CLASS=A,MSGCLASS=A,RESTART=ASMF
//*--------------------------------------------------------------------
//IEHPROGM EXEC PGM=IEHPROGM
//SYSPRINT  DD SYSOUT=*
//MVS3350   DD UNIT=3350,VOL=SER=PUB000,DISP=SHR
//SYSIN     DD *
 SCRATCH DSNAME=HERC01.WORK.LOADLIB,VOL=3350=PUB000
 UNCATLG DSNAME=HERC01.WORK.LOADLIB
//*--------------------------------------------------------------------
//ALLOC    EXEC PGM=IEFBR14
//LOAD      DD DSN=HERC01.WORK.LOADLIB,
//             UNIT=3350,VOL=SER=PUB000,
//             SPACE=(CYL,(20,0,15)),
//             DCB=(RECFM=U,BLKSIZE=32760),
//             DISP=(,CATLG)
//*--------------------------------------------------------------------
//ASMF     EXEC PGM=IFOX00,REGION=2048K
//SYSLIB    DD DSN=SYS1.AMODGEN,DISP=SHR
//          DD DSN=SYS1.AMACLIB,DISP=SHR
//SYSUT1    DD DISP=(NEW,DELETE),SPACE=(1700,(900,100)),UNIT=SYSDA
//SYSUT2    DD DISP=(NEW,DELETE),SPACE=(1700,(600,100)),UNIT=SYSDA
//SYSUT3    DD DISP=(NEW,DELETE),SPACE=(1700,(600,100)),UNIT=SYSDA
//SYSPRINT  DD SYSOUT=*
//SYSPUNCH  DD DSN=&&OBJ,UNIT=SYSDA,SPACE=(CYL,1),DISP=(,PASS)
//SYSIN     DD *
HELLO    CSECT
         USING HELLO,15
         SAVE (14,12)
         WTO 'HELLO WORLD COMPILED STEP BY STEP!'
         RETURN (14,12),RC=0
         END
//*-------------------------------------------------------------------
//LKED     EXEC PGM=IEWL,
//             COND=(5,LT,ASMF),
//             PARM='LIST,MAP,XREF,LET,NCAL,RENT'
//SYSPRINT  DD SYSOUT=*
//SYSLMOD   DD DSN=HERC01.WORK.LOADLIB,DISP=SHR
//* SLIB    DD DSN=SYS1.LINKLIB,DISP=SHR
//SYSUT1    DD UNIT=SYSDA,SPACE=(TRK,(5,5))
//SYSLIN    DD DSN=&&OBJ,DISP=(OLD,DELETE)
//          DD *
 NAME HWFULL(R)
//*-------------------------------------------------------------------
//HWFULL   EXEC PGM=HWFULL
//STEPLIB   DD DSN=HERC01.WORK.LOADLIB,DISP=SHR
//
