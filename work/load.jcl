*************** NOT WORKING ***************
//HERC01   JOB (CBT),
//             'Restore Tape',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//*  Name: HERC01.IEBGENER.CNTL(LOAD)                                *
//*                                                                  *
//*  Type: JCL                                                       *
//*                                                                  *
//*  Desc: Load HERC01.CBT.CNTL files from tape                      *
//*                                                                  *
//********************************************************************
//CLEANUP EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
//* DELETE XXX.YYY.ZZZ       NONVSAM
 SET MAXCC=0
 SET LASTCC = 0
//LOAD    EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//CNTLOUT  DD  DISP=(,CATLG),DSN=HERC01.XXX.CNTL,
//             UNIT=SYSDA,
//             VOL=SER=PUB000,
//             SPACE=(CYL,(1,1,10))
//CNTLIN   DD  DISP=OLD,DSN=BSP.MVS38J.CNTL,
//             UNIT=(TAPE,,DEFER),
//             VOL=SER=BSP38J,
//             LABEL=(1,SL)
//SYSIN    DD  *
 C I=CNTLIN,O=CNTLOUT
//