# Emulator
HerculesStudio - Be sure to configure Hercules' Directory = <NONE> (source .HerculesStudio) // Configuration Directory = $HOME/tk4-_v1.00_current/conf // Logs Directory = $HOME/tk4-_v1.00_current/log in order to point to TK4- installation.
HerculesStudio - Don't use script scripts/ipl.rc to IPL as it goes wild quite often, use manual IPL...
Hercules - .HerculesStudio: export PATH=$HOME/tk4-_v1.00_current/hercules/linux/64/bin:$PATH; export LD_LIBRARY_PATH=$HOME/tk4-_v1.00_current/hercules/linux/64/lib:$HOME/tk4-_v1.00_current/hercules/linux/64/lib/hercules:$LD_LIBRARY_PATH; #export HERCULES_RC=$HOME/tk4-_v1.00_current/scripts/ipl.rc

HercGUI - Rename ipl.rc to hercules.rc and place it in Configuration Files directory which has to be the "target dir"

HercPrt - Printing using mvs38j-33lines.ini configuration: submit printa.jcl

SHELL - Print output: tail -f prt00e.txt
CONSOLE - Add one console (0010 3270 // 0011 3270) just before the line "INCLUDE conf/${TK4CONS:=intcons}.cnf" in tk4-.cnf and don't use mvs script: x3270 localhost:3270

# 3270
3270 - File transfer parameters: fixed 80/3120
3270 - Cancel everything: PA1
3270 - Getting help for screen command for usage with c3270: Ctrl-A ?
3270 - Running curses version of terminal emulator: c3270 127.0.0.1:3270
3270 - Use option x3270 -oversize 90x45 to display all characters in RFE/RPF or set in .Xresources: x3270.oversize: 90x45
3270 - Running scripts version (actions) of terminal emulator - http://x3270.bgp.nu/x3270-script.html: s3270
3270 - Running a session with script listener: x3270 -scriptport 9999
3270 - Executing a script through running x3270: for X in $(cat actions.txt); do x3270if -t 9999 "$X"; done
3270 - Script for logon: connect(127.0.0.1:3270) // pf(3) // string(herc01) // enter() // enter() // string(cul8tr) // enter() // enter() // enter()
3270 - Script for logoff: pf(3) // string(logoff) // enter() // disconnect()
3270 - Printing the session in x3scr* files, /tmp on Linux and Desktop on Windows
3278 - JRP logon for printing: logon applid=cjrp // PF12, PF1 and PF8 (PF9)
3278 - LU for printing is specified in tk4-.cnf:00C7 3287 - LU = 00C7
3278 - Printing to local printer from x3270 requires to stop printer session after the job is purged
3278 - Emulates a printer: pr3287 -crlf -eojtimeout 60 "0C7@127.0.0.1:3270"
3278 - Prints to PDF file on Linux with CUPS-PDF Printer: pr3287 -trace -crlf -eojtimeout 60 "0C7@127.0.0.1:3270"

# Hercules
HERCULES - Execute a Hercules command - Load a tape: devinit 0480 tapes/vs2start.het
HERCULES - Execute a Hercules command (USER,PASSWORD might be supplied in JCL because of RAKF) - Run a job : devinit 000C jcl/iebgener.jcl
HERCULES - Accessing semi-graphical console (Esc key): run set_console_mode once
HERCULES - Get semi-graphical console commands: Start hercules without -d parameter // hit ESC
HERCULES - Execute an MVS System Command: /display u // /send 'test message' herc01
HERCULES - Submitting jobs via the socket reader (HercGUI), USER and PASSWORD fields in JOB statement are mandatory: hercrdr.exe 127.0.0.1:3505 restore.jcl
HERCULES - Redirecting A class output device to a socket in config file: "#000E 1403 prt/prt00e.txt ${TK4CRLF}" // "000E 1403 127.0.0.1:1403 sockdev"
HERCULES - Create a new DASD: dasdinit -a -z test00.340 3350 TEST00
HERCULES - Create DASD from XMIT files (trailing CR in ctl file is mandatory): dasdload -a -z revhelp.ctl REVH00 3
HERCULES - List VTOC of DASD: dasdls REVH00
HERCULES - Print content of member of partitioned dataset: dasdcat -i REVH00 "GPRICE.REVIEW.HELP/FSHELP:a"
HERCULES - Unload members from partitioned dataset: dasdpdsu REVH00 GPRICE.REVIEW.HELP ascii
HERCULES - Print map of AWS tape: tapemap ./tapes/HERCULES.0000XX.het
HERCULES - Create a new HET volume: hetinit ./tapes/HERCULES.0000XX.het 0000XX HERC01
HERCULES - Print map of HET tape: hetmap ./tapes/HERCULES.0000XX.het
HERCULES - Force stop: script scripts/shutdown
HERCULES - MVS console: attach 010 3270 CONS // 127.0.0.1:3270 LUNAME=CONS // /v 010,console,auth=all
HERCULES - TCPIP??? add Microsoft loopback with hdwwiz // attach E20 3088 CTCI-W32 192.168.0.25 192.168.0.15 // attach E21 3088 CTCI-W32 192.168.0.25 192.168.0.15
HERCULES - Connect/disconnect terminal: /v net,act,id=cuu0c2 // /v net,inact,id=cuu0c2
HERCULES - Submit a job to sockdev Card Reader with netcat command: netcat -w1 localhost 3505 < restore.jcl

# MVS
MVS - IPL automated system (HerculesStudio -f conf/tk4-.cnf &): IPL 148 // /R 00,CLPA (CVIO, CMD=00, CMD=01, CMD=02)
MVS - IPL non automated system use inexistent /R 00,CMD=03 (SYS1.PARMLIB.COMMND03)
MVS - Stop system: /F BSPPILOT,SHUTNOW // /$PJES2 // /Z EOD // /QUIESCE
MVS - Check what is running: /D A,L

MVS - System configuration files: SYS1.PARMLIB
MVS - System commands/procedures and help: SYS1.CMDLIB SYS1.PROCLIB SYS1.HELP
MVS - Additional system commands/procedures and help: SYS2.CMDLIB SYS2.PROCLIB SYS2.HELP
MVS - Many JCL examples (ALGOL, FORTRAN, GCC, COBOL, PL1, RPG, ...): SYS2.JCLLIB
MVS - IBM utilities can be found in SYS1.LINKLIB partitioned data set
MVS - RAKF configuration: SYS1.PARMLIB(RAKFINIT)

MVS - Cancel session: /CANCEL U=HERC01
MVS - Reply to *?? by /REPLY ??,'CANCEL' to cancel

MVS - Display online DASDs: /D U,DASD,ONLINE
MVS - Display offline DASDs: /D U,DASD,OFFLINE
MVS - Get available device numbers/types for DASD: /D U,DASD,OFFLINE,,999
MVS - Add a new DASD in SYS1.PARMLIB(VATLST00): TEST01,1,2,3350 // VOL TEST01 // DEVICE 340 // FILE test01.340
MVS - Activate device: attach 340 3350 dasd/test01.340 // run job init3350.jcl
MVS - Vary DASD: /V 340,ONLINE
MVS - Mount DASD: /MOUNT 340,VOL=(SL,TEST01),USE=PRIVATE

MVS - Start ftpd: /START FTPD,SRVPORT=2100 (FTPD is not working with some Hercules which are not shipped with TK4-)
MVS - Use ftp from Linux: ftp localhost 2100

MVS - MSGCLASS/SYSOUT A: prt/prt00e.txt
MVS - MSGCLASS/SYSOUT Z: prt/prt00f.txt
MVS - MSGCLASS/SYSOUT G: 3287 printer
MVS - MSGCLASS/SYSOUT B: pch/pch00d.txt
MVS - MSGCLASS/SYSOUT - Not defined in JES2PARM: pch/pch10d.txt
MVS - MSGCLASS/SYSOUT X - Held in JES2PARM: prt/prt002.txt

MVS - JES2 parameters file: SYS1.JES2PARM(JES2PARM)
MVS - Reconfiguring JES2 from MVS console: /S JES2,,,PARM='COLD,NOREQ' // /S JES2,PARM='COLD,FORMAT'

# JES2
JES2 - Execute a JES2 command: /$d a // /$d i // /$d u,prts // /$d u,puns // /$d u,rdrs
JES2 - Cancel job: /$c jXX
JES2 - Cancel printer output: /$c prt3

# JCL
JCL - Initialize 3350 disk TEST01: ickdsf/init3350.jcl
JCL - Restore from tape to disk TEST01, files in HERC01/TEST01 won't be catalogued, use 'c' in RFE to catalogue them: iehdasdr/restore.jcl
JCL - Dump from disk TEST01 to tape: iehdasdr/dump2tp.jcl

# PASSWORD
PASSWORD - HERC01/CUL8TR
PASSWORD - HERC02/CUL8TR
PASSWORD - HERC03/PASS4U
PASSWORD - HERC04/PASS4U
PASSWORD - TEST/SKYRPFXA

# TSO
TSO - Logon: HERC01
TSO - Reconnect: LOGON HERC01 RECONNECT
TSO - Start TSOAPPLS: TSOAPPLS
TSO - List volumes: LISTVOL
TSO - List catalogue: LISTCAT
TSO - Set prefix: PROFILE PREFIX(HERC01)
TSO - Remove prefix: PROFILE NOPREFIX
TSO - List all Data Sets in catalogue: LISTCAT CATALOG('SYS1.UCAT.TSO') ALL
TSO - List details about Data Set: LISTCAT ENTRIES('HERC01.IEBGENE3.JCL') ALL
TSO - List all JCL Data Sets in HERC01: LISTDS 'HERC01.*.JCL'
TSO - List of partitioned Data Sets TSO commands: LISTDS 'SYS2.CMDLIB' MEMBERS
TSO - List of partitioned Data Sets TSO helps: LISTDS 'SYS2.HELP' MEMBERS
TSO - List of partitioned Data Sets TSO procedures: LISTDS 'SYS2.PROCLIB' MEMBERS
TSO - List the content of the Data Set: LIST 'HERC01.IEBGENE3.JCL'
TSO - Rename Data Set: RENAME 'HERC01.COMPILE2.JCL' 'HERC01.COMPILE2.JCK'
TSO - Delete Data Set: DELETE 'HERC01.COMPILE2.JCL'
TSO - Submit a job: SUBMIT 'HERC01.IEBGENE3.JCL'
TSO - Get status of jobs: STATUS
TSO - Cancel job: CANCEL HERC01(JOB00019)
TSO - Get output of job: OUTPUT MYJOB(JOB00019)
TSO - Send message: SEND 'This is my message' USER(HERC02)
TSO - Display Direct-Access Storage Device: DDASD
TSO - Get the blocksize of device: BLKSPTRK 2314
TSO - Calculate blocksize BLKXXXX: BLK3390
TSO - Free all allocated Data Sets: FREEALL
TSO - List volume table of contents: VTOC PUB001
TSO - Remove jobs if it doesn't have an output held: CANCEL ASMFCLG(JOB00034) PURGE
TSO - Print held output from class X to Z: OUTPUT HERC01X(JOB00032) NEWCLASS(Z)
TSO - Allocate and execute a CLIST: ALLOC F(SYSPROC) DA(CLIST) // %SONG
TSO - Execute a program from TSO (READY prompt) and get the output in console: CALL 'HERC01.WORK.LOADLIB(HWFULL)'
TSO - Set screen-size: TERMINAL SCRSIZE(45, 140) // LETTERS LIST

# RFE
RFE - Go to menu option X: =X
RFE - Go to start menu: =bye

# QUEUE
QUEUE - Get all jobs: status *
QUEUE - S(command):S[tatus]/C[ancel]/P[urge]/O[utput] Q(class):A/Z/G/B/X

# RPF
RPF - B - browse
RPF - C - catalog
RPF - D - delete
RPF - E - edit
RPF - I - info
RPF - M - member
RPF - R - rename
RPF - U - uncatalog
RPF - V - view
RPF - Z - compress
