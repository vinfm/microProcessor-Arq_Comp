library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- não vejo mais serventia nesse aqui, mas vou deixar por enquanto
entity PC is
    port( 
        clk      : in std_logic; --clock
        rst      : in std_logic; --reset geral
        wr_en    : in std_logic; -- write enable do PC
        data_in  : in unsigned(6 downto 0); -- endereço do PC atualizado
        data_out  : out unsigned(6 downto 0) -- endereço do PC atual
   );
end entity;

architecture a_PC of PC is
    component reg7bits
    port( 
        clk      : in std_logic; --clock
        rst      : in std_logic; --reset
        wr_en    : in std_logic; 
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
    );
    end component;

begin

    PC_reg :   reg7bits 
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            data_in  => data_in,
            data_out => data_out
        );

end architecture;