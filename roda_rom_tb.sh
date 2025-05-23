ghdl -a rom.vhd
ghdl -a rom_inst_tb.vhd
ghdl -e rom
ghdl -e rom_inst_tb
ghdl -r rom_inst_tb --wave=rom_inst_tb.ghw