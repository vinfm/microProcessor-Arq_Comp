# Rode na pasta builds
# ./roda_maqest_tb.sh

cd ..

ghdl -a maq_estados.vhd

ghdl -a ./tbs/maq_estados_tb.vhd

ghdl -e maq_estados

ghdl -e maq_estados_tb

ghdl -r maq_estados_tb --wave=maq_estados_tb.ghw

mv maq_estados_tb.ghw sinais/
cd sinais
gtkwave maq_estados_tb.ghw