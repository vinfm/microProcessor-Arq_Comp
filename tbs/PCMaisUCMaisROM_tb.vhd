-- filepath: e:\UTFPR\QUINTO SEMESTRE\ARQCOMP\VHDls\microProcessor-Arq_Comp\PCMaisUCMaisROM_tb.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCMaisUCMaisROM_tb is
end entity;

architecture tb of PCMaisUCMaisROM_tb is
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal wr_en    : std_logic := '0';
    signal data_out : unsigned(15 downto 0);

    component PCMaisUCMaisROM
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_out : out unsigned(15 downto 0)
        );
    end component;

begin
    -- Instancia o DUT
    DUT: PCMaisUCMaisROM
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            data_out => data_out
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
        wr_en <= '0';
        wait for 15 ns;

        -- Libera reset e ativa escrita
        rst <= '0';
        wr_en <= '1';
        wait for 100 ns;

        -- Desativa escrita
        wr_en <= '0';
        wait for 30 ns;

        -- Finaliza simulação
        wait;
    end process;

   

end architecture;