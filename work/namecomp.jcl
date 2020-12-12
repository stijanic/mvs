//NAMECOMP JOB (SETUP),                                               
//            'Compile NAME',                                         
//            CLASS=A,                                                
//            MSGCLASS=A,                                             
//            REGION=8M,                                              
//            MSGLEVEL=(1,1),
//            USER=HERC01,PASSWORD=CUL8TR                                          
//********************************************************************
//NAME    EXEC  GCCCL,COPTS='-v'                                      
//COMP.SYSIN DD DISP=SHR,DSN=HERC01.WORK.C(NAME)                      
//* COMP.OUT   DD DISP=SHR,DSN=HERC01.WORK.OBJ(NAME)                  
//LKED.SYSLMOD DD DISP=SHR,DSN=HERC01.WORK.LOADLIB(NAME)              
//                                                                    