-- filepath: e:\UTFPR\QUINTO SEMESTRE\ARQCOMP\VHDls\microProcessor-Arq_Comp\tbs\PCMaisUCMaisROM_tb.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCMaisUCMaisROM_tb is
end entity;

architecture tb of PCMaisUCMaisROM_tb is
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal wr_en    : std_logic := '1';

    component PCMaisUCMaisROM
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic
        );
    end component;

begin
    -- Instancia o DUT
    DUT: PCMaisUCMaisROM
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en
        );

    -- Clock de 10ns
    clk_process: process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Estímulos
    stim_proc: process
    begin
        -- Reset ativo
        rst <= '1';
        wait for 15 ns;

        -- Libera reset
        rst <= '0';
        wait for 150 ns;

        -- Finaliza simulação
        wait;
    end process;

end architecture;