//HLWRLD  JOB  CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),REGION=256K
//STEP1   EXEC PGM=IEBGENER
//SYSUT1   DD  DATA,DLM=$$
/*******************************************************/
/*                                                     */
/*                      Hello World                    */
/*                                                     */
/*******************************************************/
$$
//SYSUT2   DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//
