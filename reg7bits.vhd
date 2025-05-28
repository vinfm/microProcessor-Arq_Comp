library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg7bits is
   port( clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_in  : in unsigned(6 downto 0);
         data_out : out unsigned(6 downto 0)
   );
end entity;

architecture a_reg7bits of reg7bits is
   signal registro: unsigned(6 downto 0);
begin
   process(clk, rst)
   begin
       if rst = '1' then
           registro <= (others => '0');
       elsif rising_edge(clk) then
           if wr_en = '1' then
               registro <= data_in;
           end if;
       end if;
   end process;
   
   data_out <= registro;  -- conexao direta, fora do processo
end architecture;