cd ..

ghdl -a rom.vhd

ghdl -a ./tbs/rom_inst_tb.vhd

ghdl -e rom

ghdl -e rom_inst_tb

ghdl -r rom_inst_tb --wave=rom_inst_tb.ghw

mv rom_inst_tb.ghw sinais/
cd sinais
gtkwave rom_inst_tb.ghw