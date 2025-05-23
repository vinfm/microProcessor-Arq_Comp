library ieee;
use ieee.std_logic_1164.all;

entity maq_estados is
   port( 
        clk    : in std_logic;
        rst    : in std_logic;
        estado : out std_logic
   );
end entity;

architecture a_maq_estados of maq_estados is
   signal estado_reg : std_logic := '0'; -- Estado inicial S0
begin
   process(clk, rst)
   begin
      if rst = '1' then
         estado_reg <= '0'; -- Vai para S0 no reset
      elsif rising_edge(clk) then
         estado_reg <= not estado_reg; -- Flip-flop T: alterna estado
      end if;
   end process;

   estado <= estado_reg;
end architecture;