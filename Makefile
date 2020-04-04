
DEBUG=0
PDB=0
YORI_BUILD_ID=0
ARCH=win32

!IF [$(CC) -? 2>&1 | findstr /C:"x64" >NUL 2>&1]==0
ARCH=amd64
!ELSE
!IF [$(CC) -? 2>&1 | findstr /C:"AMD64" >NUL 2>&1]==0
ARCH=amd64
!ELSE
!IF [$(CC) -? 2>&1 | findstr /C:"ARM64" >NUL 2>&1]==0
ARCH=arm64
!ELSE
!IF [$(CC) -? 2>&1 | findstr /C:"ARM" >NUL 2>&1]==0
ARCH=arm
!ELSE
!IF [$(CC) -? 2>&1 | findstr /C:"Itanium" >NUL 2>&1]==0
ARCH=ia64
!ELSE
!IF [$(CC) -? 2>&1 | findstr /C:"MIPS" >NUL 2>&1]==0
ARCH=mips
!ENDIF # MIPS
!ENDIF # Itanium
!ENDIF # ARM (32)
!ENDIF # ARM64
!ENDIF # AMD64
!ENDIF # x64

BINDIR=bin\$(ARCH)
SYMDIR=sym\$(ARCH)
MODDIR=bin\$(ARCH)\modules

BUILD=$(MAKE) -nologo DEBUG=$(DEBUG) PDB=$(PDB) YORI_BUILD_ID=$(YORI_BUILD_ID) BINDIR=..\$(BINDIR) SYMDIR=..\$(SYMDIR) MODDIR=..\$(MODDIR)

CURRENTTIME=REM
WRITECONFIGCACHEFILE=cache.mk

all: all.real

!INCLUDE "config\common.mk"

!IF "$(FOR)"=="for"
STARTCMD=
!ELSE
STARTCMD="
!ENDIF

!IF [ydate.exe -? >NUL 2>&1]==0
CURRENTTIME=echo. & echo For: $(FOR) & ydate $$HOUR$$:$$MIN$$:$$SEC$$ & echo.
!ENDIF

SHDIRS=sh      \

DIRS=crt       \
     lib       \
     libwin    \
     libdlg    \
     builtins  \
     assoc     \
     cab       \
     cal       \
     charmap   \
     clip      \
     clmp      \
     cls       \
     co        \
     compact   \
     copy      \
     cpuinfo   \
     cshot     \
     cut       \
     cvtvt     \
     date      \
     df        \
     dir       \
     du        \
     echo      \
     env       \
     erase     \
     err       \
     expr      \
     finfo     \
     for       \
     fscmp     \
     get       \
     grpcmp    \
     hash      \
     help      \
     hexdump   \
     hilite    \
     iconv     \
     initool   \
     intcmp    \
     kill      \
     lines     \
     lsof      \
     mem       \
     mkdir     \
     mklink    \
     more      \
     mount     \
     move      \
     nice      \
     osver     \
     path      \
     pause     \
     pkglib    \
     procinfo  \
     ps        \
     readline  \
     repl      \
     rmdir     \
     scut      \
     sdir      \
     setver    \
     shutdn    \
     sleep     \
     split     \
     sponge    \
     start     \
     strcmp    \
     stride    \
     sync      \
     tail      \
     tee       \
     timethis  \
     title     \
     touch     \
     type      \
     vhdtool   \
     vol       \
     which     \
     wininfo   \
     winpos    \
     ydbg      \
     ypm       \
     ysetup    \
     yui       \

all.real: writeconfigcache
	@$(CURRENTTIME)
	@$(FOR) %%i in ($(BINDIR) $(SYMDIR) $(MODDIR) $(BINDIR)\YoriInit.d) do $(STARTCMD)@if not exist %%i $(MKDIR) %%i$(STARTCMD)
	@$(FOR) %%i in ($(SHDIRS) $(DIRS)) do $(STARTCMD)@if exist %%i echo *** Compiling %%i & cd %%i & $(BUILD) compile READCONFIGCACHEFILE=..\$(WRITECONFIGCACHEFILE) & cd ..$(STARTCMD)
	@$(FOR) %%i in ($(DIRS)) do $(STARTCMD)@if exist %%i echo *** Linking %%i & cd %%i & $(BUILD) link READCONFIGCACHEFILE=..\$(WRITECONFIGCACHEFILE) & cd ..$(STARTCMD)
	@$(FOR) %%i in ($(SHDIRS)) do $(STARTCMD)@if exist %%i echo *** Linking %%i & cd %%i & $(BUILD) link READCONFIGCACHEFILE=..\$(WRITECONFIGCACHEFILE) & cd ..$(STARTCMD)
	@$(FOR) %%i in ($(SHDIRS) $(DIRS)) do $(STARTCMD)@if exist %%i echo *** Installing %%i & cd %%i & $(BUILD) install READCONFIGCACHEFILE=..\$(WRITECONFIGCACHEFILE) & cd ..$(STARTCMD)
	@$(CURRENTTIME)

beta: all.real
	@if not exist beta $(MKDIR) beta
	@move $(BINDIR) beta\$(ARCH)
	@move $(SYMDIR) beta\$(ARCH)\sym

clean: writeconfigcache
	@$(FOR) %%i in ($(SHDIRS) $(DIRS)) do $(STARTCMD)@if exist %%i echo *** Cleaning %%i & cd %%i & $(BUILD) clean READCONFIGCACHEFILE=..\$(WRITECONFIGCACHEFILE) & cd ..$(STARTCMD)
	@if exist *~ erase *~
	@$(FOR_ST) /D %%i in ($(MODDIR) $(BINDIR) $(SYMDIR)) do @if exist %%i $(RMDIR) /s/q %%i
	@if exist $(WRITECONFIGCACHEFILE) erase $(WRITECONFIGCACHEFILE)

distclean: clean
	@$(FOR_ST) /D %%i in (pkg\*) do @if exist %%i $(RMDIR) /s/q %%i
	@$(FOR_ST) %%i in (beta doc bin sym) do @if exist %%i $(RMDIR) /s/q %%i

help:
	@echo "DEBUG=[0|1] - If set, will compile debug build without optimization and with instrumentation"
	@echo "PDB=[0|1] - If set, will generate debug symbols"

