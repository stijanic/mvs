//SONGCOMP JOB (SETUP),
//            'Compile SONG',
//            CLASS=A,
//            MSGCLASS=A,
//            REGION=8M,
//            MSGLEVEL=(1,1)
//********************************************************************
//SONG    EXEC GCCCLG,COPTS='-v'
//COMP.SYSIN DD DISP=SHR,DSN=HERC01.WORK.CNTL(SONGC)
//* COMP.OUT   DD DISP=SHR,DSN=HERC01.WORK.CNTL(SONG)
//LKED.SYSLMOD DD DISP=SHR,DSN=HERC01.WORK.LOADLIB(SONG)
//
