bin_PROGRAMS = stix
stix_SOURCES = stix.exe
CLEANFILES = $(srcdir)/src/EXP_32/EXP32.OBJ

$(srcdir)/src/EXP_32/EXP32.OBJ:
	$(tasm32Path) "$(dozeSrcDir)\\src\\EXP_32\\EXP32.ASM"
	mv EXP32.OBJ $(srcdir)/src/EXP_32

stix.exe: $(srcdir)/src/EXP_32/EXP32.OBJ
	mkdir -p units
	cd $(srcdir)/src && $(vpcPath) -V$(vpoPath) -O$(abs_builddir)/units -E$(abs_builddir) -B stix.pas

stix$(EXEEXT): stix.exe
	$(pe2elfPath) stix.exe
	chmod +x stix
