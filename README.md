# stix
stix is an InstallShield 3 extractor created by Veit Kannegieser.
This version has been modified so that it works on Linux.
It is not complete, however (see Todo).

# Building

You will need to assemble EXP32.ASM with TASM32 under Wine.
This will produce EXP32.OBJ, needed to compile the rest of the project.
To compile the rest of stix, use Virtual Pascal to compile stix.pas.

# Todo

Subdirectories in data.z files are treated as top-level directories
with backslashes in their names. Since backslashes are not directory
delimiters on Linux, this results in an ugly and incorrect directory
structure being extracted. As a result, I've tried to add a bit of
code that replaces backslashes with forward slashes in path names,
but my attempt didn't end up doing anything as far as I could tell,
so I removed it to avoid future trouble.

Try to find a free assembler that can assemble EXP32.ASM to get rid
of the dependency on TASM32.
