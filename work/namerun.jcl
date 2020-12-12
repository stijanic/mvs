//NAMERUN JOB (SETUP),                                          
//            'Run NAME',                                       
//            CLASS=A,                                          
//            MSGCLASS=A,                                       
//            REGION=8M,                                        
//            MSGLEVEL=(1,1),
//            USER=HERC01,PASSWORD=CUL8TR                                    
//************************************************************* 
//NAME    EXEC PGM=NAME                                         
//STEPLIB DD DISP=SHR,DSN=HERC01.WORK.LOADLIB                   
//SYSPRINT DD SYSOUT=*                                          
//SYSTERM  DD SYSOUT=*                                          
//SYSIN    DD DUMMY                                             
//                                                              