namespace eval vgm {
	variable active false

	variable psg_register
	variable opll_register
	variable y8950_register
	variable opl4_register_1
	variable opl4_register_2

	variable start_time
	variable ticks
	variable music_data
	variable file_name

	variable psg_logged
	variable fm_logged
	variable y8950_logged
	variable moonsound_logged

	variable sample_accurate true

	variable watchpoint_psg_address
	variable watchpoint_psg_data
	variable watchpoint_opll_address
	variable watchpoint_opll_data
	variable watchpoint_y8950_address
	variable watchpoint_y8950_data
	variable watchpoint_opl4_address_1
	variable watchpoint_opl4_data_1
	variable watchpoint_opl4_address_2
	variable watchpoint_opl4_data_2

	variable watchpoint_isr

	proc little_endian {value} {
		format %c%c%c%c [expr $value & 0xFF] \
		                [expr ($value >> 8) & 0xFF] \
		                [expr ($value >> 16) & 0xFF] \
		                [expr ($value >> 24) & 0xFF]
	}

	proc zeros {value} {
		string repeat "\0" $value
	}

	proc vgm_rec {{filename "/tmp/music.vgm"} {psglogged 1} {fmlogged 1} {y8950logged 0} {moonsoundlogged 0}} {
		variable active

		variable psg_register
		variable fm_register
		variable y8950_register
		variable opl4_register_1
		variable opl4_register_2

		variable start_time
		variable ticks
		variable music_data
		variable file_name
		variable sample_accurate

		variable psg_logged
		variable fm_logged
		variable y8950_logged
		variable moonsound_logged

		variable watchpoint_psg_address
		variable watchpoint_psg_data
		variable watchpoint_opll_address
		variable watchpoint_opll_data
		variable watchpoint_y8950_address
		variable watchpoint_y8950_data
		variable watchpoint_opl4_address_1
		variable watchpoint_opl4_data_1
		variable watchpoint_opl4_address_2
		variable watchpoint_opl4_data_2

		variable watchpoint_isr

		if {$active} {
			error "Already recording."
		}

		set active true
		set psg_register -1
		set fm_register -1
		set y8950_register -1
		set opl4_register_1 -1
		set opl4_register_2 -1

		set start_time [machine_info time]
		set ticks 0
		set music_data ""
		set file_name $filename
		set psg_logged $psglogged
		set fm_logged $fmlogged
		set y8950_logged $y8950logged
		set moonsound_logged $moonsoundlogged

		if {$psg_logged == 1} {
			set watchpoint_psg_address [debug set_watchpoint write_io 0xA0 {} {vgm::write_psg_address}]
			set watchpoint_psg_data [debug set_watchpoint write_io 0xA1 {} {vgm::write_psg_data}]
		}

		if {$fm_logged == 1} {
			set watchpoint_opll_address [debug set_watchpoint write_io 0x7C {} {vgm::write_opll_address}]
			set watchpoint_opll_data [debug set_watchpoint write_io 0x7D {} {vgm::write_opll_data}]
		}

		if {$y8950_logged == 1} {
			set watchpoint_y8950_address [debug set_watchpoint write_io 0xC0 {} {vgm::write_y8950_address}]
			set watchpoint_y8950_data [debug set_watchpoint write_io 0xC1 {} {vgm::write_y8950_data}]
		}

		# I've been told almost all music on MSX using Moonsound uses Moonsound wave, but for that to work some settings have te be done on the second FM unit
		# So log FM2 as well..
		# opl4 1 = wave
		# opl4 2 = FM2
		# Maybe log more in the future.. FM1 if needed

		if {$moonsound_logged == 1} {
			set watchpoint_opl4_address_1 [debug set_watchpoint write_io 0x7E {} {vgm::write_opl4_address_1}]
			set watchpoint_opl4_data_1 [debug set_watchpoint write_io 0x7F {} {vgm::write_opl4_data_1}]
			set watchpoint_opl4_address_2 [debug set_watchpoint write_io 0xC6 {} {vgm::write_opl4_address_2}]
			set watchpoint_opl4_data_2 [debug set_watchpoint write_io 0xC7 {} {vgm::write_opl4_data_2}]
		}

		if {!$sample_accurate} {
			set watchpoint_isr [debug set_watchpoint read_mem 0x38 {} {vgm::update_frametime}]
		}

		puts "Recording started to $filename."
		puts -nonewline "Recording data for the following sound chips: "
		if {$psg_logged == 1} { puts -nonewline "PSG " }
		if {$fm_logged == 1} { puts -nonewline "FMPAC " }
		if {$y8950_logged == 1} { puts -nonewline "Music_Module " }
		if {$moonsound_logged == 1} { puts -nonewline "Moondsound" }
		puts ""
	}

	proc write_psg_address {} {
		variable psg_register
		set psg_register $::wp_last_value
	}

	proc write_psg_data {} {
		variable psg_register
		variable music_data
		if {$psg_register >= 0 && $psg_register < 14} {
			update_time
			append music_data [format %c%c%c 0xA0 $psg_register $::wp_last_value]
		}
	}

	proc write_opll_address {} {
		variable opll_register
		set opll_register $::wp_last_value
	}

	proc write_opll_data {} {
		variable opll_register
		variable music_data
		if {$opll_register >= 0} {
			update_time
			append music_data [format %c%c%c 0x51 $opll_register $::wp_last_value]
		}
	}

	proc write_y8950_address {} {
		variable y8950_register
		set y8950_register $::wp_last_value
	}

	proc write_y8950_data {} {
		variable y8950_register
		variable music_data
		if {$y8950_register >= 0} {
			update_time
			append music_data [format %c%c%c 0x5C $y8950_register $::wp_last_value]
		}
	}

	proc write_opl4_address_1 {} {
		variable opl4_register_1
		set opl4_register_1 $::wp_last_value
	}

	proc write_opl4_data_1 {} {
		variable opl4_register_1
		variable music_data
		#puts "write data..."
		if {$opl4_register_1 >= 0} {
			update_time
			# Port 0 = FM1, port 1 = FM2, port 2 = Wave
			append music_data [format %c%c%c%c 0xD0 0x2 $opl4_register_1 $::wp_last_value]
		}
	}

	proc write_opl4_address_2 {} {
		puts $::wp_last_value
		variable opl4_register_2
		set opl4_register_2 $::wp_last_value
	}

	proc write_opl4_data_2 {} {
		variable opl4_register_2
		variable music_data
		if {$opl4_register_2 >= 0} {
			update_time
			append music_data [format %c%c%c%c 0xD0 0x1 $opl4_register_2 $::wp_last_value]
		}
	}

	proc update_time {} {
		variable start_time
		variable ticks
		variable music_data
		variable sample_accurate
		if {!$sample_accurate} {
			return
		}
		set new_ticks [expr int(([machine_info time] - $start_time) * 44100)]
		while {$new_ticks > $ticks} {
			set difference [expr $new_ticks - $ticks]
			set step [expr $difference > 65535 ? 65535 : $difference]
			append music_data [format %c%c%c 0x61 [expr $step & 0xFF] [expr ($step >> 8) & 0xFF]]
			incr ticks $step
		}
	}

	proc update_frametime {} {
		variable ticks
		variable music_data
		set new_ticks [expr $ticks + 735]
		append music_data [format %c 0x62]
	}

	proc vgm_rec_end {} {
		variable active
		variable ticks
		variable music_data
		variable file_name
		variable sample_accurate

		variable psg_logged
		variable fm_logged
		variable y8950_logged
		variable moonsound_logged

		variable watchpoint_psg_address
		variable watchpoint_psg_data
		variable watchpoint_opll_address
		variable watchpoint_opll_data
		variable watchpoint_y8950_address
		variable watchpoint_y8950_data
		variable watchpoint_opl4_address_1
		variable watchpoint_opl4_data_1
		variable watchpoint_opl4_address_2
		variable watchpoint_opl4_data_2

		variable watchpoint_isr

		if {!$active} {
			error "Not recording."
		}

		if {$psg_logged == 1 } {
			debug remove_watchpoint $watchpoint_psg_address
			debug remove_watchpoint $watchpoint_psg_data
		}
		if {$fm_logged == 1} {
			debug remove_watchpoint $watchpoint_opll_address
			debug remove_watchpoint $watchpoint_opll_data
		}
		if {$y8950_logged == 1} {
			debug remove_watchpoint $watchpoint_y8950_address
			debug remove_watchpoint $watchpoint_y8950_data
		}

		if {$moonsound_logged == 1} {
			debug remove_watchpoint $watchpoint_opl4_address_1
			debug remove_watchpoint $watchpoint_opl4_data_1
			debug remove_watchpoint $watchpoint_opl4_address_2
			debug remove_watchpoint $watchpoint_opl4_data_2
		}

		if {!$sample_accurate} {
			debug remove_watchpoint $watchpoint_isr
		}

		update_time
		append music_data [format %c 0x66]

		set header "Vgm "
		# file size
		append header [little_endian [expr [string length $music_data] + 0x100 - 4]]
		# VGM version 1.7
		append header [little_endian 0x170]
		append header [zeros 4]

		# YM2413 clock
		if {$fm_logged == 1} {
			append header [little_endian 3579545]
		} else {
			append header [zeros 4]
		}

		append header [zeros 4]
		# Number of ticks
		append header [little_endian $ticks]
		append header [zeros 24]
		# Data starts at offset 0x100
		append header [little_endian [expr 0x100 - 0x34]]
		append header [zeros 32]

		# Y8950 clock
		if {$y8950_logged == 1} {
			append header [little_endian 3579545]
		} else {
			append header [zeros 4]
		}

		append header [zeros 4]

		# YMF278B clock
		if {$moonsound_logged == 1} {
			append header [little_endian 33868800]
		} else {
			append header [zeros 4]
		}

		append header [zeros 16]

		# AY8910 clock
		if {$psg_logged == 1} {
			append header [little_endian 1789773]
		} else {
			append header [zeros 4]
		}

		append header [zeros 136]

		set file_handle [open $file_name "w"]
		fconfigure $file_handle -encoding binary -translation binary
		puts -nonewline $file_handle $header
		puts -nonewline $file_handle $music_data
		close $file_handle

		set active false

		puts "Recording stopped"
	}

	namespace export vgm_rec
	namespace export vgm_rec_end
}

namespace import vgm::*
