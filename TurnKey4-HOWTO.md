<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [System Configuration and Tips](#system-configuration-and-tips)
    - [Linux](#linux)
        - [HerculesStudio:](#herculesstudio)
        - [$HOME/.HerculesStudio:](#homeherculesstudio)
        - [Tools](#tools)
    - [Windows](#windows)
- [Config (tk4-.cnf)](#config-tk4-cnf)
- [Console (???):](#console-)
- [Terminal 3270](#terminal-3270)
- [Terminal 3278](#terminal-3278)
- [Hercules](#hercules)
- [MVS](#mvs)
    - [-](#-)
    - [STOP:](#stop)
    - [DASD](#dasd)
    - [DATA SETS](#data-sets)
    - [JES2](#jes2)
    - [MISC](#misc)
    - [MSGCLASS (SYSOUT)](#msgclass-sysout)
    - [PASSWORDS](#passwords)
- [TSO](#tso)
    - [RFE](#rfe)
    - [QUEUE](#queue)
    - [RPF](#rpf)

<!-- markdown-toc end -->

# System Configuration and Tips
## Linux
### HerculesStudio:
  - Load environment variables: `source ~/.HerculesStudio`
  - Be sure to configure Hercules' Directory to `<NONE>`
  - Configuration Directory = `$HOME/Software/tk4-_v1.00_current/conf`
  - Logs Directory = `$HOME/Software/tk4-_v1.00_current/log`
  - Don't use script `scripts/ipl.rc` to IPL as it goes wild quite often, use manual IPL...
  - Configuring semi-graphical console (Esc key): `~/Software/tk4-_v1.00_current/unattended/set_console_mode` (without `-d` option)
### $HOME/.HerculesStudio:
  - `export PATH=$HOME/Software/tk4-_v1.00_current/hercules/linux/64/bin:$PATH`
  - `export LD_LIBRARY_PATH=$HOME/Software/tk4-_v1.00_current/hercules/linux/64/lib:$LD_LIBRARY_PATH`
  - `export LD_LIBRARY_PATH=$HOME/Software/tk4-_v1.00_current/hercules/linux/64/lib/hercules:$LD_LIBRARY_PATH`
  - `#export HERCULES_RC=$HOME/Software/tk4-_v1.00_current/scripts/ipl.rc` - Not used, manual IPL...
### Tools
  - Submit a job to sockdev Card Reader with netcat command: `netcat -w1 localhost 3505 < restore.jcl`
  - Create a new DASD: `dasdinit -a -z test00.340 3350 TEST00`
  - Create DASD from XMIT files (trailing CR in ctl file is mandatory): `dasdload -a -z revhelp.ctl REVH00 3`
  - Print content of member of partitioned dataset: `dasdcat -i REVH00 "GPRICE.REVIEW.HELP/FSHELP:a"`
  - Unload members from partitioned dataset: `dasdpdsu REVH00 GPRICE.REVIEW.HELP ascii`
  - Print map of AWS tape: `tapemap ./tapes/HERCULES.0000XX.het`
  - Create a new HET volume: `hetinit ./tapes/HERCULES.0000XX.het 0000XX HERC01`
  - Print map of HET tape: `hetmap ./tapes/HERCULES.0000XX.het`
  - Print output: ``tail -f prt00e.txt``
  - Use ftp from Linux: `ftp localhost 2100`  
## Windows
- HercGUI - Rename `ipl.rc` to `hercules.rc` and place it in Configuration Files directory which has to be the "target dir"
- HercPrt - Printing using `mvs38j-33lines.ini` configuration
- TCPIP??? add Microsoft loopback with hdwwiz:
 ```
 attach E20 3088 CTCI-W32 192.168.0.25 192.168.0.15
 attach E21 3088 CTCI-W32 192.168.0.25 192.168.0.15
 ```
 - Submitting jobs via the socket reader (HercGUI), USER and PASSWORD fields in JOB statement are mandatory: `hercrdr.exe 127.0.0.1:3505 restore.jcl`

# Config (tk4-.cnf)
- Add one console (`0010 3270` // `0011 3270`) just before the line "`INCLUDE conf/${TK4CONS:=intcons}.cnf`" in `tk4-.cnf` and don't use mvs script to IPL, then execute: `x3270 localhost:3270`
- Redirecting A class output device to a socket in config file: `#000E 1403 prt/prt00e.txt ${TK4CRLF}` => `000E 1403 127.0.0.1:1403 sockdev`

# Console (???):
 
Hercules - `ATTACH 010 3270 CONS`
x3270/tn3270 -
  `CONS@127.0.0.1:3270` (x3270)
  `127.0.0.1:3270 LUNAME=CONS` (tn3270)
MVS - `/V 010,CONSOLE,AUTH=ALL`

- Connect/disconnect terminal:
 ```
/V NET,ACT,ID=CUU0C2
/V NET,INACT,ID=CUU0C2
 ```

# Terminal 3270
 - Cancel everything: `PA1`
 - Running curses version of terminal emulator: `c3270 127.0.0.1:3270`
 - Getting help for screen command for usage with c3270: `Ctrl-A ?`
 - Running scripts version (actions) of terminal emulator - http://x3270.bgp.nu/x3270-script.html: `s3270`
 - Running a session with script listener: `x3270 -scriptport 9999`
 - Executing a script through running `x3270`:
 ```
 for X in $(cat actions.txt);
 do
   x3270if -t 9999 "$X";
 done
 ```
 - Script for logon: 
 ```
connect(127.0.0.1:3270)
pf(3)
string(herc01)
enter()
enter()
string(cul8tr)
enter()
enter()
enter()
 ```
- Script for logoff:
 ```
pf(3)
string(logoff)
enter()
disconnect()
 ```
- File transfer parameters: `fixed 80/3120`
- Printing the session in x3scr* files, `/tmp` on Linux and Desktop on Windows
 - Use option `x3270 -oversize 90x45` to display all characters in RFE/RPF or set it in .Xresources: `x3270.oversize: 90x45`
# Terminal 3278
- JRP logon for printing: `logon applid=cjrp`, `PF12`, `PF1` and `PF8 (PF9)`
- LU for printing is specified in tk4-.cnf: `00C7 3287 - LU = 00C7`
- Printing to local printer from x3270 requires to stop printer session after the job is purged
- Emulates a printer: `pr3287 -crlf -eojtimeout 60 "0C7@127.0.0.1:3270"`
- Prints to PDF file on Linux with CUPS-PDF Printer: `pr3287 -trace -crlf -eojtimeout 60 "0C7@127.0.0.1:3270"`

# Hercules
 - Activate device: `ATTACH 340 3350 DASD/TEST01.340`
 - Load a tape: `DEVINIT 0480 TAPES/VS2START.HET`
 - Run a job : `DEVINIT 000C JCL/IEBGENER.JCL` - USER and PASSWORD must be supplied in JCL because of RAKF
 - Force stop: `SCRIPT SCRIPTS/SHUTDOWN`
 - Start IPL from device 148: `IPL 148`

# MVS
### IPL
  - IPL answer to automated system:
    - `/R 00,CLPA` (`CVIO, CMD=00, CMD=01, CMD=02`)
  - IPL answer to non automated system use nonexistent (`SYS1.PARMLIB.COMMND03`):
    - `/R 00,CMD=03`
### STOP
  - `/F BSPPILOT,SHUTNOW`
  - `/$PJES2`
  - `/Z EOD`
  - `/QUIESCE`
### DASD
- Display online DASDs: `/D U,DASD,ONLINE`
- Display offline DASDs: `/D U,DASD,OFFLINE`
- Get available device numbers/types for DASD: `/D U,DASD,OFFLINE,,999`
- Add a new DASD in `SYS1.PARMLIB(VATLST00)` : `TEST01,1,2,3350 VOL TEST01 DEVICE 340 FILE test01.340`
- Initialize 3350 disk TEST01: `ICKDSF/INIT3350.JCL`
- Vary DASD: `/V 340,ONLINE`
- Mount DASD: `/MOUNT 340,VOL=(SL,TEST01),USE=PRIVATE`
#### DATA SETS
- System configuration data set: `SYS1.PARMLIB`
- System commands/procedures and help: `SYS1.CMDLIB` `SYS1.PROCLIB` `SYS1.HELP`
- Additional system commands/procedures and help: `SYS2.CMDLIB` `SYS2.PROCLIB` `SYS2.HELP`
- Many JCL examples (ALGOL, FORTRAN, GCC, COBOL, PL1, RPG, ...): `SYS2.JCLLIB`
- IBM utilities can be found in `SYS1.LINKLIB` partitioned data set
- RAKF configuration: `SYS1.PARMLIB(RAKFINIT)`
### JES2
- Cancel job: `/$c jXX`
- Cancel printer output: `/$c prt3`
- Re-configuring JES2 from MVS console:
  - `/S JES2,,,PARM='COLD,NOREQ'`
  - `/S JES2,PARM='COLD,FORMAT'`
- Execute a JES2 command:
 ```
  /$d a
  /$d i
  /$d u,prts
  /$d u,puns
  /$d u,rdrs
 ```
- JES2 parameters file: `SYS1.JES2PARM(JES2PARM)`
### MISC
- Check what is running: `/D A,L`
- Display users: `/DISPLAY U`
- Send a message to a user: `/SEND 'TEST MESSAGE' HERC01`
- Cancel session: `/CANCEL U=HERC01`
- Reply to `*??` with: `/REPLY ??`, use `'CANCEL'` to cancel
- Start ftpd: `/START FTPD,SRVPORT=2100` (FTPD is not working with some Hercules which are not shipped with TK4-)
#@# MSGCLASS (SYSOUT)
  - `A`: `prt/prt00e.txt`
  - `Z`: `prt/prt00f.txt`
  - `G`: 3287 printer
  - `B`: `pch/pch00d.txt`
  - `X`: `prt/prt002.txt` - Held in `JES2PARM`
  - `-`: `pch/pch10d.txt` - Not defined in `JES2PARM`  
### PASSWORDS
- `HERC01/CUL8TR`
- `HERC02/CUL8TR`
- `HERC03/PASS4U`
- `HERC04/PASS4U`
- `TEST/SKYRPFXA`
# TSO
- Logon: `HERC01`
- Reconnect: `LOGON HERC01 RECONNECT`
- Start TSOAPPLS: `TSOAPPLS`
- List volumes: `LISTVOL`
- List catalogue: `LISTCAT`
- List VTOC of DASD: `DASDLS REVH00`
- Set prefix: `PROFILE PREFIX(HERC01)`
- Remove prefix: `PROFILE NOPREFIX`
- List all Data Sets in catalogue: `LISTCAT CATALOG('SYS1.UCAT.TSO') ALL`
- List details about Data Set: `LISTCAT ENTRIES('HERC01.IEBGENE3.JCL') ALL`
- List all JCL Data Sets in HERC01: `LISTDS 'HERC01.*.JCL'`
- List of partitioned Data Sets TSO commands: `LISTDS 'SYS2.CMDLIB' MEMBERS`
- List of partitioned Data Sets TSO helps: `LISTDS 'SYS2.HELP' MEMBERS`
- List of partitioned Data Sets TSO procedures: `LISTDS 'SYS2.PROCLIB' MEMBERS`
- List the content of the Data Set: `LIST 'HERC01.IEBGENE3.JCL'`
- Rename Data Set: `RENAME 'HERC01.COMPILE2.JCL' 'HERC01.COMPILE2.JCK'`
- Delete Data Set: `DELETE 'HERC01.COMPILE2.JCL'`
- Submit a job: `SUBMIT 'HERC01.IEBGENE3.JCL'`
- Submit another job: `SUBMIT PRINTA.JCL`
- Restore from tape to disk TEST01: `SUBMIT IEHDASDR/RESTORE.JCL` - data sets in `HERC01/TEST01` won't be catalogued, use `c` in RFE to catalogue them.
- Dump from disk TEST01 to tape: `SUBMIT IEHDASDR/DUMP2TP.JCL`
- Get status of jobs: `STATUS`
- Cancel job: `CANCEL HERC01(JOB00019)`
- Get output of job: `OUTPUT MYJOB(JOB00019)`
- Send message: `SEND 'This is my message' USER(HERC02)`
- Display Direct-Access Storage Device: `DDASD`
- Get the blocksize of device: `BLKSPTRK 2314`
- Calculate blocksize BLKXXXX: `BLK3390`
- Free all allocated Data Sets: `FREEALL`
- List volume table of contents: `VTOC PUB001`
- Remove jobs if it doesn't have an output held: `CANCEL ASMFCLG(JOB00034) PURGE`
- Print held output from class X to Z: `OUTPUT HERC01X(JOB00032) NEWCLASS(Z)`
- Allocate and execute a CLIST: `ALLOC F(SYSPROC) DA(CLIST)` `%SONG`
- Execute a program from TSO (READY prompt) and get the output in console: `CALL 'HERC01.WORK.LOADLIB(HWFULL)'`
- Set screen-size: `TERMINAL SCRSIZE(45, 140)` `LETTERS LIST`
## RFE
- Go to menu option X: =X
- Go to start menu: =bye
## QUEUE
- Get all jobs: status *
- S (command): S[tatus]/C[ancel]/P[urge]/O[utput] 
- Q (class): A/Z/G/B/X
## RPF
- B - browse
- C - catalog
- D - delete
- E - edit
- I - info
- M - member
- R - rename
- U - uncatalog
- V - view
- Z - compress
