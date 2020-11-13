//SONGRUN JOB (SETUP),
//            'Run SONG',
//            CLASS=A,
//            MSGCLASS=A,
//            REGION=8M,
//            MSGLEVEL=(1,1)
//SONG    EXEC PGM=SONG
//STEPLIB DD DISP=SHR,DSN=HERC01.WORK.LOADLIB
//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//SYSIN    DD DUMMY
//                                                  