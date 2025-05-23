ghdl -a maq_estados.vhd
ghdl -a maq_estados_tb.vhd
ghdl -e maq_estados
ghdl -e maq_estados_tb
ghdl -r maq_estados_tb --wave=maq_estados_tb.ghw