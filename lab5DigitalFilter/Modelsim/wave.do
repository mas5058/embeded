onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /audiofilter_tb/clk_tb
add wave -noupdate /audiofilter_tb/reset_tb
add wave -noupdate /audiofilter_tb/dataReq_tb
add wave -noupdate /audiofilter_tb/audioSample_tb
add wave -noupdate /audiofilter_tb/audioSample_sig
add wave -noupdate /audiofilter_tb/audioSampleFiltered_tb
add wave -noupdate /audiofilter_tb/audioSampleFiltered_sig
add wave -noupdate /audiofilter_tb/period
add wave -noupdate /audiofilter_tb/audioSample_w
add wave -noupdate /audiofilter_tb/audioSampleArray
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {3061 ns}
