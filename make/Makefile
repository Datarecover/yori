
BINARIES=ymake.exe

!INCLUDE "..\config\common.mk"

!IF $(PDB)==1
LINKPDB=/Pdb:ymake.pdb
!ENDIF

CFLAGS=$(CFLAGS) -DMAKE_VER_MAJOR=$(MAKE_VER_MAJOR) -DMAKE_VER_MINOR=$(MAKE_VER_MINOR)

BIN_OBJS=\
	 alloc.obj        \
	 exec.obj         \
	 make.obj         \
	 preproc.obj      \
	 scope.obj        \
	 target.obj       \
	 var.obj          \

MOD_OBJS=\
	 alloc.obj        \
	 exec.obj         \
	 mod_make.obj     \
	 preproc.obj      \
	 scope.obj        \
	 target.obj       \
	 var.obj          \

compile: $(BIN_OBJS) builtins.lib

MAKE_LIBS=..\lib\yorilib.lib ..\crt\yoricrt.lib ..\echo\builtins.lib ..\mkdir\builtins.lib ..\rmdir\builtins.lib

ymake.exe: $(BIN_OBJS) $(MAKE_LIBS)
	@echo $@
	@$(LINK) $(LDFLAGS) -entry:$(YENTRY) $(BIN_OBJS) $(LIBS) $(CRTLIB) $(MAKE_LIBS) -version:$(MAKE_VER_MAJOR).$(MAKE_VER_MINOR) $(LINKPDB) -out:$@

mod_make.obj: make.c
	@echo $@
	@$(CC) -c -DYORI_BUILTIN=1 $(CFLAGS) -Fo$@ make.c

builtins.lib: $(MOD_OBJS)
	@echo $@
	@$(LIB32) $(LIBFLAGS) $(MOD_OBJS) -out:$@
