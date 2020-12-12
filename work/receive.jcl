//ALLOCATE EXEC PGM=IEFBR14                                             
//TO#FILE  DD DSN=receiving-pds,                                       
//            DISP=(,CATLG,DELETE),                                     
//            UNIT=SYSDA,                                               
//            SPACE=(TRK,(175,25,250)),                           
//            DCB=(RECFM=FB,LRECL=080)                                 
//**********************************************************************
//RECEIVE  EXEC PGM=IKJEFT01,                                           
//            REGION=5000K,                                             
//            DYNAMNBR=30                                               
//FROMFILE DD DSN=input-dsname,                                         
//            DISP=SHR                                                 
//SYSPRINT DD  SYSOUT=*                                                 
//SYSTSPRT DD SYSOUT=*                                                 
//SYSTSIN  DD  *                                                       
 RECEIVE   +                                                           
 INDDNAME(FROMFILE)                                                     
 DATASET('receiving-pds')                                               
/*

Read more: http://ibmmainframes.com/about38909.html#ixzz43Tm9C300
