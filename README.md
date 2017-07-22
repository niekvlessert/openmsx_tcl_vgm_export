# openmsx_tcl_vgm_export

A TCL script for OpenMSX to export AY8910 (PSG), YM2413 (FMPAC), Y8950 (Music Module), YMF278B (OPL4, Moonsound) and Konami SCC(+) music to VGM

This script is an expanded version from the script created by Grauw: https://bitbucket.org/grauw/vgmplay-msx/src/tip/tools/vgmrec.tcl?at=default&fileviewer=file-view-default, which was in turn an expansion of the script by Ricbit; https://github.com/ricbit/Oldies/blob/master/2014-11-grabfm/grabfm.tcl

# How to use it

- Copy the script in the scripts directory in the openmsx profile directory, where ever that might be. On OSX it's ~/.openMSX/share/scripts.
- Start OpenMSX, the script will be loaded automagically.
- Go to the console
- Insert the required virtual sound cartridges (SCC must be in exta to make recording work).
- Load your software/game
- Start recording the VGM data using vgm_rec [filename] [AY8910 0/1] [YM2413 0/1] [Y8950 0/1] [YMF278B 0/1] [SCC 0/1].
- Some defaults are in place; without any arguments it will record to /tmp/music.vgm with AY8910 and FM2413 enabled.
- So if you want to record Moonsound music in /tmp/test.vgm: vgm_rec /tmp/test.vgm 0 0 0 1 0.
- If you want to end the recording just type vgm_rec_end. This is required, without doing that the VGM file header won't be written.
- Play your file!
- Be careful; start the recording before the initialisation of the sound chips, this info needs to be logged as well!
- This just creates the raw VGM file, you need to split/compress/add tags/etc.

# vgm_rec_next

- There's also a vgm_rec_next function available. This will end the previous recording and start the next one with the same sound chip parameters and filename, but the filename contains an increasing digit
- With this you can easily put tracks in separate files so you don't have to split them afterward
- Be careful; this function won't work always; the second and beyond file won't contain any soundchip initialisation stuff
- For SCC it works fine, because no sound chip initialisation is required, but for Moonsound it won't because of this. This can be fixed as well, but that'll require more work, better use the vgm_tools for splitting those.

# Future updates

- Error handling (file permissions etc.)
- MIDI??
