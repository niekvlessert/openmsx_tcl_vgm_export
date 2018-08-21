# openmsx_tcl_vgm_export

A TCL script for OpenMSX to export AY8910 (PSG), YM2413 (FMPAC, MSX-Music), Y8950 (Music Module, MSX-Audio), YMF278B (OPL4, Moonsound) and Konami SCC(+) music to VGM files

This script is an expanded version from the script created by Grauw: https://bitbucket.org/grauw/vgmplay-msx/src/tip/tools/vgmrec.tcl?at=default&fileviewer=file-view-default, which was in turn an expansion of the script by Ricbit; https://github.com/ricbit/Oldies/blob/master/2014-11-grabfm/grabfm.tcl

The script is included in OpenMSX since version 0.14.0.

# Basic usage

- Start OpenMSX, the script will be available.
- Go to the console.
- Insert the required virtual sound cartridges.
- Load your software/game.
- Start recording the VGM data using ```vgm_rec start``` followed by the soundchip(s) you wan't to record. Use tab completion to see the options.
- Recording won't actually start; whenever commands are send to the recording sound chip it will.
- Recordings will be stored in the OpenMSX home directory from the active user in a subdirectory vgm_recordings.
- By default it will record to music0001.vgm. If music0001.vgm already exists it'll be music0002.vgm etc.
- When you have heard the music you want to record end the recording in the console with ```vgm_rec stop```.
- Play the resulting file using Vgmplay.

# Advanced features

There are several features available to make the recording process more convenient. Using tab completion after vgm_rec you may see the options.

- Before starting the recording you can activate the auto_next feature. This will cause a new recording to be started whenever there is no data send to the recorded sound chip for longer then 1 second. Like this you are sure sure every track you want to record will be in a seperate VGM file. However there are caveats; the PSG will always receive data for example. Another issue can be that the implementation of the audio player sends data to the chip even when not playing anything, Aleste does that for example with the FMPAC. It works fine with Undeadline. Also; the resulting VGM file should contain the correct initialisation of the chips. Using the current version of the script the initialisation settings will be correct most of the time, currently I only know about FMPAC settings that might differ.
- The current recording may be aborted with ```vgm_rec abort```. No music data will be saved.
- There's also a ```vgm_rec next``` function available. This will end the current recording and start the next one with the same sound chip parameters.
- Using the ```prefix``` feature a user can change the prefix from the resulting VGM file, to distinguish several recording projects in the vgm_recordings directory.
- Several hacks are implemented; they can be activated by ```vgm_rec enable_hack``` followed by the tab key. Available are:
	- MBWave_basic_title: when recording for Moonsound using the MBWave basic driver this hack will change the filename of the file to the title of the track given to it by the composer
	- MBWave_title: the same but when using MBWave itself for playback
	- MBWave_loop: this feature will insert a VGM pokey command in the VGM file when the track loops for the second time. This can be useful when it's hard to find the actual loop point. More on that in the part below.
- The hacks can be disabled using ```vgm_rec disable_hacks```
- Be careful when recording tracks using sample RAM. The RAM will be saved when ending the recording. When changing drumkits while recording and ending the recording, only the last loaded samples will be saved.
- Because the sample RAM is saved it's not required to load the drumkit while recording.

# Molding the resulting VGM files

For a good listening experience of the resulting music the tracks should loop once and fade out slowly. However the saved recording will probably not be like that. One of the purposes of the great vgm_tools is just that. Others are for optimising the resulting VGM files. This should not be a tutorial about vgm_tools, but a short version will save you some time.

- First try finding the correct loop point using vgmlpfnd.
- You can also try to find the loop by looking for Pokey commands (when the above hack have been used) by feeding the file to vgm2txt.
- When found use vgm_trim to split the VGM file.
- If the file contains samples then run vgm_sro.
- Then use vgm_cmp, which besides compression will remove unnecessary VGM commands, for instance the Pokey commands
- Use vgm_tag to set additional information for the VGM file
- If you want to create packs for vgmrips.net, there's more to that then the above, use IRC or the vgmrips forum to get information about that.

# Dutch Moonsound Veterans Hack/Version

This is an old version of the basic script adapted for ripping Dutch Moonsound Veterans while avoiding manual work as much as possible. It's not perfect at all; it won't work as the normal version however all code is still in and the commands won't work the way the help information will tell you. OpenMSX needs to run in UX environment and vgm_sptd and vgm_tag need to be in /usr/local/bin. Be sure to put this version on top of the original version, otherwise it will conflict.

All you have to do is start Dutch Moonsound Veterans and run vgm_rec_auto_next. In the vgm_recordings directory all VGM files will appear. It's advised to use the throttle feature...
