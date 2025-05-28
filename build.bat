@echo off
REM build.bat - Compila todos os arquivos VHDL do projeto
ghdl -a reg7bits.vhd
ghdl -a rom.vhd
ghdl -a ./tbs/rom_inst_tb.vhd
ghdl -e rom
ghdl -e rom_inst_tb
ghdl -a maq_estados.vhd
ghdl -a ./tbs/maq_estados_tb.vhd
ghdl -e maq_estados
ghdl -e maq_estados_tb
ghdl -a decoder3x6.vhd
ghdl -a reg16bits.vhd
ghdl -a bancoRegs.vhd
ghdl -a ULA.vhd
ghdl -a regsMaisULA.vhd
ghdl -a ./tbs/regsMaisULA_tb.vhd
ghdl -e regsMaisULA_tb
ghdl -a PC.vhd
ghdl -e PC
ghdl -a UC.vhd
ghdl -e UC
ghdl -a PCMaisUCMaisROM.vhd
ghdl -e PCMaisUCMaisROM

ghdl -a ./tbs/PCMaisUCMaisROM_tb.vhd
ghdl -e PCMaisUCMaisROM_tb
ghdl -r PCMaisUCMaisROM_tb --wave=PCMaisUCMaisROM_tb.ghw
echo.
echo ====== Build completo! ======
pause