library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity processador_tb is

end entity;

architecture a_processador_tb of processador_tb is
    component processador
        port(        
        clk       : in  std_logic;            --clock
        rst       : in  std_logic;            --reset geral
        bus_debug : out unsigned(15 downto 0) --bus de debug para visualização
            );
    end component;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal bus_debug  : unsigned(15 downto 0);

begin

    uut: processador
        port map(
            clk             => clk,
            rst             => rst,
            bus_debug       => bus_debug
        );

    -- Clock de 10ns
    clk_process: process
    begin

        wait for 20 ns; -- Atraso inicial para garantir que o reset seja aplicado antes do clock
        while now < 120000 ns loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Estímulos
    stim_proc: process
    begin
        -- Reset ativo
        rst <= '1';
        wait for 5 ns;

        -- Libera reset
        rst <= '0';
        wait for 10 ns;

        -- Finaliza simulação
        wait;
    end process;

end architecture;