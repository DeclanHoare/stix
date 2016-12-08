# stix
stix is an InstallShield 3 extractor created by Veit Kannegieser.
This version has been modified so that it sort of works on Linux.
It seems to crash as soon as it reaches a subdirectory, but it
extracts files on the root of the archive correctly.

# Building

You will need to assemble EXP32.ASM with TASM32 under Wine.
This will produce EXP32.OBJ, needed to compile the rest of the project.
To compile the rest of stix, use Virtual Pascal to compile stix.pas.

# Todo

I think the reason it's crashing on subdirectories is because of
the use of backslashes for path delimiters. I need to figure out how
to make the program convert these on the fly. But I have no idea
where to start.
