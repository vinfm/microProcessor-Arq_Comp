library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;


entity reg1bit is
   port( clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_in  : in std_logic;  -- Alterado de unsigned(6 downto 0) para std_logic
         data_out : out std_logic  -- Alterado de unsigned(6 downto 0) para std_logic
   );
end entity;

architecture a_reg1bit of reg1bit is  -- Nome da arquitetura atualizado para corresponder à entidade
   signal registro: std_logic;  -- Alterado de unsigned(6 downto 0) para std_logic
begin
   process(clk, rst)
   begin
       if rst = '1' then
           registro <= '0';  -- Alterado para atribuir um único bit '0'
       elsif rising_edge(clk) then
           if wr_en = '1' then
               registro <= data_in;
           end if;
       end if;
   end process;
   
   data_out <= registro;  -- Conexão direta, fora do processo
end architecture;