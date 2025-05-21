@echo off
REM build.bat - Compila todos os arquivos VHDL do projeto

ghdl -a reg16bits.vhd
ghdl -a decoder3x6.vhd
ghdl -a bancoRegs.vhd
ghdl -a ULA.vhd
ghdl -a topLevel.vhd
ghdl -e topLevel

echo.
echo ====== Build completo! ======
pause