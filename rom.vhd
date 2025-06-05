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
      0  => "0010011000000101", -- carrega o valor 5 no registrador r3

      1  => "0010100000001000", -- carrega o valor 8 no registrador r4

      -- adiciona r3 e r4, resultado em r5
      2  => "0100111011000000", -- mov A, r3
      3  => "0101111100111111", -- ADD A, A, R4
      4  => "0100101111000000", -- MOV R5, A 

      --Subtrai 1 de R5
      5  => "0100111101000000", -- MOV A, R5
      6  => "0110111111000001",  --SUBI A, A, 1
      7  => "0100101111000000", -- MOV R5, A 

      -- salta para o endereço 20
      8  => "1111000000010100", -- jump para o endereço 20

      9  => "0010101000000000", -- ld r5, 0
      10 => "0000000000000000", -- NOP
      11 => "0000000000000000", -- NOP
      12 => "0000000000000000", -- NOP
      13 => "0000000000000000", -- NOP
      14 => "0000000000000000", -- NOP
      15 => "0000000000000000", -- NOP
      16 => "0000000000000000", -- NOP
      17 => "0000000000000000", -- NOP
      18 => "0000000000000000", -- NOP
      19 => "0000000000000000", -- NOP
      
      -- volta para o endereço 20
      20 => "0100011101000000", -- mov r3, r5
      21 => "1111000000000011", -- jump 3
      22 => "0010011000000000", -- LD R3, 0
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