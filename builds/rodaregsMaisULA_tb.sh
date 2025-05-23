cd ..;

ghdl -a decoder3x6.vhd;
ghdl -a reg16bits.vhd;
ghdl -a bancoRegs.vhd;
ghdl -a ULA.vhd;
ghdl -a regsMaisULA.vhd;

ghdl -a ./tbs/regsMaisULA_tb.vhd;
ghdl -e regsMaisULA_tb;


ghdl -r regsMaisULA_tb --wave=regsMaisULA_tb.ghw;

mv regsMaisULA_tb.ghw sinais/;

cd sinais;

gtkwave regsMaisULA_tb.ghw;