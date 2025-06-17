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
      0  => B"0010_100_000000100", -- carrega o valor 4 no registrador R4
      1  => B"0010_111_000000000", -- carrega o valor 0 no Acumulador A
      2  => B"1101_111_100_000000", -- sw 
      3  => B"0011_010_111_000000", -- lw
      4  => B"0101_111_100_111_111", -- soma A com R4
      5  => B"0100_100_111_101010", -- carrega o valor de A no registrador R4
      6  => B"0010_111_000000001", -- carrega o valor 1 no acumulador A
      7  => B"0101_111_011_111_111", -- soma A com R3
      8  => B"0100_011_111_010101", -- carrega o valor do acumulador em R3
      9  => B"0100_111_011_110011", -- carrega o valor de R3 no acumulador A
      10  => B"1001_111_000011110", -- compara o valor do acumulador A com o valor 30 (11110)-mudei para 1
      11 => B"1100_00000010_1_101", -- branch para o endereço 12 se A for maior ou igual 
      12 => B"1111_01010_0000010", -- jump para o endereço 2
      13 => B"0100_101_100_001111", -- mov r5, r4 --carrega o valor de R4 em R5
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