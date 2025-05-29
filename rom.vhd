library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(15 downto 0) 
   );
end entity;
architecture a_rom of rom is
   type mem is array (0 to 127) of unsigned(15 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      0  => "0000000000000000", -- NOP
      1  => "0000000000000000", -- NOP
      2  => "1111000000000101", -- JMP para 5
      3  => "0000000000000000", -- NOP (deve ser pulado)
      4  => "0000000000000000", -- NOP (deve ser pulado)
      5  => "0000000000000000", -- NOP
      6  => "1111000000000010", -- JMP para 2 (loop)
      7  => "0000000000000000", -- NOP (deve ser pulado)
      others => (others=>'0')
   );

   begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;
end architecture;