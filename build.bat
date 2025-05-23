@echo off
REM build.bat - Compila todos os arquivos VHDL do projeto

ghdl -a reg16bits.vhd
ghdl -a decoder3x6.vhd
ghdl -a bancoRegs.vhd
ghdl -a ULA.vhd
ghdl -a topLevel.vhd
ghdl -a toplevel_tb.vhd
ghdl -a ULA_tb.vhd
ghdl -a maq_estados.vhd
ghdl -a maq_estados_tb.vhd
ghdl -a rom_inst.vhd
ghdl -a rom_inst_tb.vhd
ghdl -e maq_estados
ghdl -e maq_estados_tb
ghdl -e rom_inst
ghdl -e rom_inst_tb
ghdl -e topLevel
ghdl -e toplevel_tb
ghdl -e ULA_tb
ghdl -r toplevel_tb --wave=topLevel_tb.ghw;

echo.
echo ====== Build completo! ======
pause