@echo off
REM build.bat - Compila todos os arquivos VHDL do projeto
ghdl -a reg7bits.vhd
ghdl -a decoder3x6.vhd
ghdl -a reg16bits.vhd
ghdl -a bancoRegs.vhd
ghdl -a ULA.vhd
ghdl -a regsMaisULA.vhd

ghdl -a rom.vhd
ghdl -a maq_estados.vhd
ghdl -a PC.vhd
ghdl -a UC.vhd

ghdl -a reg1bit.vhd

ghdl -a processador.vhd
ghdl -e processador

ghdl -a ./tbs/processador_tb.vhd
ghdl -e processador_tb
ghdl -r processador_tb  --wave=processador_tb.ghw

gtkwave processador_tb.ghw 
echo.
echo ====== Build completo! ======
pause