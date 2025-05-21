ghdl -a toplevel_tb.vhd;
ghdl -e toplevel_tb;
ghdl -r toplevel_tb --wave=topLevel_tb.ghw;
gtkwave topLevel_tb.ghw;