# openmsx_tcl_vgm_export

A TCL script for OpenMSX to export AY8910 (PSG), YM2413 (FMPAC), Y8950 (Music Module), YMF278B (OPL4, Moonsound) and Konami SCC(+) music to VGM

This script is an expanded version from the script created by Grauw: https://bitbucket.org/grauw/vgmplay-msx/src/tip/tools/vgmrec.tcl?at=default&fileviewer=file-view-default, which was in turn an expansion of the script by Ricbit; https://github.com/ricbit/Oldies/blob/master/2014-11-grabfm/grabfm.tcl

# How to use it

- Copy the script in the scripts directory in the openmsx profile directory, where ever that might be. On OSX it's ~/.openMSX/share/scripts.
- Start OpenMSX, the script will be loaded automagically.
- Go to the console
- Insert the required virtual sound cartridges (SCC must be in exta to make recording work).
- Load your software/game
- Start recording the VGM data using vgm_rec.
- Be careful; start the recording before the initialisation of the sound chips, this info needs to be logged as well!
- Recordings will be stored in the OpenMSX home directory from the active user in a subdirectory vgm_recordings
- Some defaults are in place; without any arguments it will record to music0001.vgm with PSG and FMPAC enabled.
- If music0001.vgm already exists it'll be music0002.vgm etc.
- Enable different soundchips using tab completion: vgm_rec PSG FMPAC Y8950 Moonsound SCC
- If you want to end the active recording just type vgm_rec_end. This is required, without doing that the VGM file won't be written.
- Play your file!
- This just creates the raw VGM file, you need to split/compress/add tags/etc.

# vgm_rec_next

- There's also a vgm_rec_next function available. This will end the previous recording and start the next one with the same sound chip parameters and filename, but the filename contains an increasing digit
- With this you can easily put tracks in separate files so you don't have to split them afterward
- Be careful; this function won't  always work; the second and beyond file might not contain any soundchip initialisation stuff
- For SCC it works fine, because no sound chip initialisation is required, but for Moonsound it might not because of this, if the player engine is not doing all initialisation with every track. This can be fixed as well, but that'll require more work, better use the vgm_sptd for splitting those.

# vgm_rec_set_filename

- With this you can set the first part of the filename. So vgm_rec_set_filename pa3_ will cause the filename to be pa3_0001.vgm. If that exists it'll be pa3_0002.vgm etc.

# Future updates

- Error handling (file permissions etc.)
- MIDI??
