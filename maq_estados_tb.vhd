library ieee;
use ieee.std_logic_1164.all;

entity maq_estados_tb is
end entity;

architecture sim of maq_estados_tb is
    signal clk    : std_logic := '0';
    signal estado : std_logic := '0';
    signal rst    : std_logic := '1';

    component maq_estados
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out std_logic
        );
    end component;

    constant clk_period : time := 10 ns;
begin

    uut: maq_estados
        port map (
            clk    => clk,
            estado => estado,
            rst    => rst
        );

    clk_proc: process
    begin
        wait for 200 ns;
        while now < 300 ns loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    reset_proc: process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait;
    end process;

    stim_proc: process
    begin
        estado <= '0';
        wait for 100 ns;
        wait;
    end process;

end architecture;