# stix
stix is an InstallShield 3 extractor created by Veit Kannegieser.
This version has been modified so that it works on Linux.
It is not complete, however (see Todo).

# Todo

Subdirectories in data.z files are treated as top-level directories
with backslashes in their names. Since backslashes are not directory
delimiters on Linux, this results in an ugly and incorrect directory
structure being extracted. As a result, I've tried to add a bit of
code that replaces backslashes with forward slashes in path names,
but my attempt didn't end up doing anything as far as I could tell,
so I removed it to avoid future trouble.
