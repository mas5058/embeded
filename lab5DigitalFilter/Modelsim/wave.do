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
add wave -noupdate /audiofilter_tb/uut/b1input
add wave -noupdate -group outputs /audiofilter_tb/uut/ab2Output
add wave -noupdate -group outputs /audiofilter_tb/uut/ff21output
add wave -noupdate -group outputs /audiofilter_tb/uut/ff22output
add wave -noupdate -group outputs /audiofilter_tb/uut/ff31output
add wave -noupdate -group outputs /audiofilter_tb/uut/ff32output
add wave -noupdate -group outputs /audiofilter_tb/uut/s2adder1Output
add wave -noupdate -group outputs /audiofilter_tb/uut/s2adder2Output
add wave -noupdate -group outputs /audiofilter_tb/uut/s2adder3Output
add wave -noupdate -group outputs /audiofilter_tb/uut/badder2output
add wave -noupdate -group outputs /audiofilter_tb/uut/b2Output
add wave -noupdate -group outputs /audiofilter_tb/uut/b11Output
add wave -noupdate -group outputs /audiofilter_tb/uut/b12Output
add wave -noupdate -group outputs /audiofilter_tb/uut/b13Output
add wave -noupdate -group outputs /audiofilter_tb/uut/b22Output
add wave -noupdate -group outputs /audiofilter_tb/uut/b23Output
add wave -noupdate -group outputs /audiofilter_tb/uut/b32Output
add wave -noupdate -group outputs /audiofilter_tb/uut/b33Output
add wave -noupdate -group outputs /audiofilter_tb/uut/a2Output
add wave -noupdate -group outputs /audiofilter_tb/uut/a22Output
add wave -noupdate -group outputs /audiofilter_tb/uut/a23Output
add wave -noupdate -group outputs /audiofilter_tb/uut/a32Output
add wave -noupdate -group outputs /audiofilter_tb/uut/sec1Output
add wave -noupdate -group outputs /audiofilter_tb/uut/a33Output
add wave -noupdate -group outputFull /audiofilter_tb/uut/b2OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/b11OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/b12OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/b13OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/b22OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/b23OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/b32OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/b33OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/a2OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/a22OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/a23OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/a32OutputFull
add wave -noupdate -group outputFull /audiofilter_tb/uut/a33OutputFull
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B11
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B12
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B13
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B21
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B22
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B23
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B31
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B32
add wave -noupdate -expand -group constants /audiofilter_tb/uut/B33
add wave -noupdate -expand -group constants /audiofilter_tb/uut/A21
add wave -noupdate -expand -group constants /audiofilter_tb/uut/A22
add wave -noupdate -expand -group constants /audiofilter_tb/uut/A23
add wave -noupdate -expand -group constants /audiofilter_tb/uut/A31
add wave -noupdate -expand -group constants /audiofilter_tb/uut/A32
add wave -noupdate -expand -group constants /audiofilter_tb/uut/A33
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {10500 ns}
