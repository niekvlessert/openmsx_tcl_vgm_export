# openmsx_tcl_vgm_export

A TCL script for OpenMSX to export AY8910 (PSG), YM2413 (FMPAC, MSX-Music), Y8950 (Music Module, MSX-Audio), YMF278B (OPL4, Moonsound) and Konami SCC(+) music to VGM

This script is an expanded version from the script created by Grauw: https://bitbucket.org/grauw/vgmplay-msx/src/tip/tools/vgmrec.tcl?at=default&fileviewer=file-view-default, which was in turn an expansion of the script by Ricbit; https://github.com/ricbit/Oldies/blob/master/2014-11-grabfm/grabfm.tcl

# How to use it

- The script is included in OpenMSX since version 0.14.0.
- Start OpenMSX, the script will be available.
- Go to the console.
- Insert the required virtual sound cartridges.
- Load your software/game.
- Start recording the VGM data using ```vgm_rec```.
- Be careful; start the recording before the initialisation of the sound chips, this info needs to be logged as well!
- You must enable at least one soundchip you want to record for; use tab completion: ```vgm_rec PSG MSX-Music MSX-Audio Moonsound SCC```
- Recordings will be stored in the OpenMSX home directory from the active user in a subdirectory vgm_recordings.
- Without any arguments it will record to music0001.vgm. If music0001.vgm already exists it'll be music0002.vgm etc.
- You may specify another filename prefix using ```-prefix prefix```.
- For example if you want to record for Moonsound using pa3_ as a prefix: ```vgmrec -prefix pa3_ Moonsound```.
- If you want to end the active recording just type ```vgm_rec_end```. This is required, without doing that the VGM file won't be written.
- Play your file!
- This just creates the raw VGM file, you need to split/compress/add tags/etc.

# vgm_rec_next

- There's also a ```vgm_rec_next``` function available. This will end the previous recording and start the next one with the same sound chip parameters and filename, but the filename contains an increasing digit
- With this you can easily put tracks in separate files so you don't have to split them afterward
- Be careful; this function won't always work; the second and beyond file might not contain any soundchip initialisation stuff
- For SCC it works fine, because no sound chip initialisation is required, but for Moonsound it might not because of this, if the player engine is not doing all initialisation with every track. This can be fixed as well, but that'll require more work, better use the vgm_sptd for splitting those.

# Future updates

- Error handling (file permissions etc.)
- MIDI??
