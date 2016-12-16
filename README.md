# stix
stix is an InstallShield 3 extractor created by Veit Kannegieser.
This version has been modified by me so that it works on Linux.

## Building

Please see the wiki page [Building](https://github.com/RogueAI42/stix/wiki/Building) for the latest instructions.

## Usage

To use stix, run:
`stix FILENAME TARGETDIRECTORY`

where FILENAME is the name of your data.z file and TARGETDIRECTORY
is the root directory where it should be extracted.

## Todo

stix now seems to function perfectly on Linux, and I have everything
I wanted out of it. However, the build process is absolutely nuts.
A native Linux clone of TASM32, preferably a libre one, would be
useful for this program, but the most important thing to do is figure
out how to invoke vpc from the CLI so that the build can be scripted.
Currently I get a stack overflow error when running a copy of stix
that has been compiled using vpc rather than using the vp IDE.
Obviously this makes automated packaging pretty near impossible.

Apart from that, being able to plug the program into graphical
archiving tools would be neat.
