-- filepath: /home/vinicius/Desktop/meuDiretorio/UTFPR/Disciplinas/arqComp/microProcessor-Arq_Comp/rom_inst_tb.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_inst_tb is
end entity;

architecture sim of rom_inst_tb is
    signal clk      : std_logic := '0';
    signal endereco : unsigned(6 downto 0) := (others => '0');
    signal dado     : unsigned(15 downto 0);

    component rom
        port(
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(15 downto 0)
        );
    end component;

    constant clk_period : time := 10 ns;
begin

    uut: rom
        port map (
            clk      => clk,
            endereco => endereco,
            dado     => dado
        );

    clk_proc: process
    begin
        while now < 120 ns loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        -- Lê os primeiros 12 endereços da ROM
        for i in 0 to 11 loop
            endereco <= to_unsigned(i, 7);
            wait for clk_period;
        end loop;
        wait for 20 ns;
        wait;
    end process;

end architecture;