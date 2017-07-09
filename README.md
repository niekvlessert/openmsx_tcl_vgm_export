# openmsx_tcl_vgm_export

A TCL script for OpenMSX to export AY8910 (PSG), YM2413 (FMPAC), Y8950 (Music Module) and YMF278B (OPL4, Moonsound) music to VGM

This script is an expanded version from the initial script created by Grauw: https://bitbucket.org/grauw/vgmplay-msx/src/tip/tools/vgmrec.tcl?at=default&fileviewer=file-view-default

# How to use it

- Copy the script in the scripts directory from the openmsx profile directory, where ever that might be. On OSX it's ~/.openMSX/share/scripts.
- Start OpenMSX, the script will be loaded automagically.
- Start recording the VGM data using vgm_rec <filename\> <AY8910 0/1> <YM2413 0/1> <Y8950 0/1> <YMF278B 0/1>.
- Some defaults are in place; without any arguments it will record to /tmp/music.vgm with AY8910 and FM2413 enabled.
- So if you want to record Moonsound music in /tmp/test.vgm: vgm_rec /tmp/test.vgm 0 0 0 1.
- If you want to end the recording just type vgm_rec_end. This is required, without doing that the VGM file header won't be written.
- Play your file!
- Be careful; start the recording before the initialisation of the sound chips, this info needs to be logged as well!
- This just creates the raw VGM file, you need to split/compress/add tags/etc.

# Future updates

- If proven necessary I will add logging from the FM1 for Moonsound as well
- SCC is missing for now...
